USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateExpensesMultiple]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineUpdateExpensesMultiple]
	(
	@InvoiceLineKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 03/09/07 GHL 8.4   Creation to prevent deadlocks    
  || 08/06/07 GHL 8.5   Added more readable Action (1/Update, 0/Delete)            
  || 08/07/07 GHL 8.5   Added call to Invoice Summary + removed tran
  ||                    Removed @projectKey param since an invoice line may have several projects
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
  || 10/12/07 CRG 8.5   Modified to mark voucher unbilled if linked to an Expense Receipt that is being removed from this invoice.
  || 11/20/07 GHL 8.5   Also setting DateBilled when removing from expense from the line  
  || 04/16/09 GHL 10.023 Looking at pod.AccruedCost rather than pod.TotalCost before removing from line
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 07/15/09 GHL 10.505 (57341) Added rollback when sptInvoiceLineUpdateTotals returns an error
  ||                    When transactions are linked to a real invoice, then applied to Advance Bills
  ||                    If we remove transactions, this causes the real invoice to be over applied 
  || 10/20/09 GHL 10.513 Calling now sptInvoiceRecalcLineAmounts here so that only taxes for this line are recalc'ed 
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC 
  */
  
	SET NOCOUNT ON
		
	/* Assume done in VB
	  sSQL = "CREATE TABLE #tInvoiceLineExpense ( "
            sSQL = sSQL & "		 Action INT NULL " 
            sSQL = sSQL & "		,Entity VARCHAR(10) NULL "  -- PO, VO, MC, ER
            sSQL = sSQL & "		,EntityKey INT NULL "
            sSQL = sSQL & "		,AmountBilled MONEY NULL "
            sSQL = sSQL & "		,ProjectKey INT NULL "
            sSQL = sSQL & "		,POHasVoucher INT NULL "
            sSQL = sSQL & " )"
	*/

	DECLARE @InvoiceKey INT, @ProjectKey INT, @RetVal INT
	
	SELECT @InvoiceKey = InvoiceKey FROM tInvoiceLine (NOLOCK) WHERE InvoiceLineKey = @InvoiceLineKey
   
	-- Clone of sptInvoiceLineUpdatePO    
	-- You can not delete an invoice if it has a prebilled order and that order has a voucher applied to it. 
	-- This would cause the prebill accruals to go out of whack       
	UPDATE #tInvoiceLineExpense
	SET    #tInvoiceLineExpense.POHasVoucher = 1
	FROM   tVoucherDetail vd (NOLOCK)
		   ,tPurchaseOrderDetail pod (NOLOCK)
	WHERE  #tInvoiceLineExpense.Entity = 'PO'
	AND    #tInvoiceLineExpense.EntityKey = vd.PurchaseOrderDetailKey
	AND    #tInvoiceLineExpense.EntityKey = pod.PurchaseOrderDetailKey
	AND    #tInvoiceLineExpense.Action = 0
	AND   ISNULL(pod.AccruedCost, 0) <> 0 -- Must have something to accrue
	       
	BEGIN TRAN
	       
	UPDATE tPurchaseOrderDetail
	SET    tPurchaseOrderDetail.InvoiceLineKey = NULL
	      ,tPurchaseOrderDetail.AmountBilled = b.AmountBilled
		  ,tPurchaseOrderDetail.AccruedCost = NULL
		  ,tPurchaseOrderDetail.DateBilled = NULL
    FROM   #tInvoiceLineExpense b
	WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
	AND    b.Entity = 'PO' 
	AND    b.POHasVoucher = 0   
	AND    b.Action = 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END

	UPDATE tPurchaseOrderDetail
	SET    tPurchaseOrderDetail.InvoiceLineKey = @InvoiceLineKey
		  ,tPurchaseOrderDetail.AmountBilled = b.AmountBilled
		  ,tPurchaseOrderDetail.AccruedCost = 
			CASE 
				WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
				ELSE 0
			END 	
    FROM   #tInvoiceLineExpense b
			,tPurchaseOrder po (nolock)
	WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
	and    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
	AND    b.Entity = 'PO' 
	AND    b.Action = 1

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END
	
	--If Expense Receipts linked to this invoice line are also linked to a voucher, mark as Unbilled
	UPDATE	tVoucherDetail
	SET		DateBilled = null,
			InvoiceLineKey = null
	FROM	tExpenseReceipt er (nolock)
	INNER JOIN #tInvoiceLineExpense b (nolock) ON er.ExpenseReceiptKey = b.EntityKey
	WHERE	er.VoucherDetailKey = tVoucherDetail.VoucherDetailKey
	AND		b.Entity = 'ER'
	AND		b.Action = 0
	

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END

	UPDATE tExpenseReceipt
	SET	   tExpenseReceipt.AmountBilled = b.AmountBilled
		   ,tExpenseReceipt.InvoiceLineKey = 
			CASE WHEN b.Action = 0 THEN NULL ELSE @InvoiceLineKey END
		   ,tExpenseReceipt.DateBilled = 
			CASE WHEN b.Action = 0 THEN NULL ELSE tExpenseReceipt.DateBilled END
	FROM   #tInvoiceLineExpense b
	WHERE  tExpenseReceipt.ExpenseReceiptKey = b.EntityKey
	AND    b.Entity = 'ER' 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END
	 
	UPDATE tMiscCost
	SET	   tMiscCost.AmountBilled = b.AmountBilled
		   ,tMiscCost.InvoiceLineKey = 
			CASE WHEN b.Action = 0 THEN NULL ELSE @InvoiceLineKey END
		   ,tMiscCost.DateBilled = 
			CASE WHEN b.Action = 0 THEN NULL ELSE tMiscCost.DateBilled END
	FROM   #tInvoiceLineExpense b
	WHERE  tMiscCost.MiscCostKey = b.EntityKey
	AND    b.Entity = 'MC' 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END
	 
	UPDATE tVoucherDetail
	SET	   tVoucherDetail.AmountBilled = b.AmountBilled
		   ,tVoucherDetail.InvoiceLineKey = 
			CASE WHEN b.Action = 0 THEN NULL ELSE @InvoiceLineKey END
		   ,tVoucherDetail.DateBilled = 
			CASE WHEN b.Action = 0 THEN NULL ELSE tVoucherDetail.DateBilled END			
	FROM   #tInvoiceLineExpense b
	WHERE  tVoucherDetail.VoucherDetailKey = b.EntityKey
	AND    b.Entity = 'VO' 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1	
	END
	 
	-- do not recalc sales taxes 'cause we create a temp table in sptInvoiceRecalcLineAmounts and there is a SQL tran
	DECLARE @RecalcSalesTaxes int, @RecalcLineSalesTaxes int
	SELECT @RecalcSalesTaxes = 0, @RecalcLineSalesTaxes = 0
	EXEC @RetVal = sptInvoiceLineUpdateTotals @InvoiceLineKey, @RecalcSalesTaxes, @RecalcLineSalesTaxes

	IF @RetVal < 0
	BEGIN
		ROLLBACK TRAN
		-- and report error to the UI
		RETURN @RetVal
	END
	
	COMMIT TRAN
		
	exec sptInvoiceRecalcLineAmounts @InvoiceKey, @InvoiceLineKey
			
	-- Project rollup for billing trantypes (6)
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tInvoiceLineExpense
		WHERE  ProjectKey > @ProjectKey   
		
		IF @ProjectKey IS NULL
			BREAK
			
		EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0
	END
	
	IF EXISTS (SELECT 1 FROM #tInvoiceLineExpense WHERE POHasVoucher = 1)
		RETURN -1
	ELSE	
		RETURN 1
GO
