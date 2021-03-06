USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineInsertTransactions]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineInsertTransactions]
	(
		@InvoiceLineKey int
	)
AS --Encrypt

/*
|| When         Who    Rel    What
|| 08/03/07     GHL    8.5    Creation for the new invoice transactions screen
|| 08/07/07     GHL    8.5    Added call to Invoice Summary + sptProjectRollupUpdateEntity
|| 09/26/07     GHL    8.5   Removed invoice summary since it is done in invoice recalc amounts
|| 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
|| 11/07/13 GHL 10.574 pod.AccruedCost is in HC
*/

	SET NOCOUNT ON
	
	UPDATE tTime
	SET    tTime.InvoiceLineKey = @InvoiceLineKey
		  ,tTime.BilledService = tTime.ServiceKey 
          ,tTime.BilledHours = tTime.ActualHours
          ,tTime.BilledRate = tTime.ActualRate          	      
	FROM   #tInvoiceLineTransaction b
	WHERE  tTime.TimeKey = b.EntityGuid
		
	UPDATE tExpenseReceipt
	SET	   tExpenseReceipt.InvoiceLineKey = @InvoiceLineKey
		   ,tExpenseReceipt.AmountBilled = tExpenseReceipt.BillableCost
	FROM   #tInvoiceLineTransaction b
	WHERE  tExpenseReceipt.ExpenseReceiptKey = b.EntityKey
	AND    b.Entity = 'tExpenseReceipt' 
	 
	UPDATE tMiscCost
	SET	   tMiscCost.InvoiceLineKey = @InvoiceLineKey
		  ,tMiscCost.AmountBilled = tMiscCost.BillableCost
	FROM   #tInvoiceLineTransaction b
	WHERE  tMiscCost.MiscCostKey = b.EntityKey
	AND    b.Entity = 'tMiscCost' 
	 
	UPDATE tPurchaseOrderDetail
	SET    tPurchaseOrderDetail.InvoiceLineKey = @InvoiceLineKey
          ,tPurchaseOrderDetail.AmountBilled = 	
			CASE 
				WHEN po.BillAt = 0 THEN tPurchaseOrderDetail.BillableCost	-- At Gross
				WHEN po.BillAt = 1 THEN tPurchaseOrderDetail.TotalCost		-- At Net
				WHEN po.BillAt = 2 THEN tPurchaseOrderDetail.BillableCost 
					- tPurchaseOrderDetail.TotalCost						-- At Commission
			END 
		  ,tPurchaseOrderDetail.AccruedCost =  
			CASE 
				WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
				ELSE 0
			END
    FROM   #tInvoiceLineTransaction b
		  ,tPurchaseOrder po (NOLOCK)
	WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
	AND    b.Entity = 'tPurchaseOrderDetail' 
	AND    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
 
	UPDATE tVoucherDetail
	SET	   tVoucherDetail.InvoiceLineKey = @InvoiceLineKey
			,tVoucherDetail.AmountBilled = tVoucherDetail.BillableCost
	FROM   #tInvoiceLineTransaction b
	WHERE  tVoucherDetail.VoucherDetailKey = b.EntityKey
	AND    b.Entity = 'tVoucherDetail' 
	 	
	-- Rollup totals to invoice line 	
	DECLARE @InvoiceKey INT, @RetVal int
	DECLARE @RecalcSalesTaxes int, @RecalcLineSalesTaxes int
	SELECT @RecalcSalesTaxes = 0, @RecalcLineSalesTaxes = 1
	EXEC @RetVal = sptInvoiceLineUpdateTotals @InvoiceLineKey, @RecalcSalesTaxes, @RecalcLineSalesTaxes

	-- Rollup totals to invoice
	SELECT @InvoiceKey = InvoiceKey FROM tInvoiceLine (NOLOCK) WHERE InvoiceLineKey = @InvoiceLineKey

	-- Rollup to projects on the invoice
	EXEC sptProjectRollupUpdateEntity 'tInvoice', @InvoiceKey
	
	RETURN 1
GO
