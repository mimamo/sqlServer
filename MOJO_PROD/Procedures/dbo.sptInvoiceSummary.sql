USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceSummary]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceSummary]
	(
	@InvoiceKey int
	)
AS --Encrypt
	
  /*
  || When     Who Rel   What
  || 08/07/07 GHL 8.5   Creation for 8.5
  || 09/11/07 GHL 8.5   Reviewed grouping by entity for transaction type records       
  || 09/26/07 GHL 8.5   Added sales taxes
  || 10/05/07 GHL 8.5   Needed entity = 'tItem' or 'tService' even if EntityKey = NULL because of reports            
  || 06/10/10 GHL 10.531 (82938) Placed a SQL transaction around delete/insert in tInvoiceSummary to make sure
  ||                    that we do not duplicate records
  || 10/01/14 GHL 10.484 Calling now sptInvoiceSummaryTitle 
  || 10/02/14 GHL 10.484 Added rounding when calculating taxes
  */
	
	SET NOCOUNT ON
	
	DECLARE @ParentInvoice tinyint
	    ,@ParentInvoiceKey int
	    ,@OrigInvoiceKey int
	    ,@PercentageSplit decimal(24,4)
	    ,@CurrInvoiceKey int
	    ,@UseBillingTitles int

	DECLARE @CurrInvoiceLineKey int
	DECLARE @LineTotalAmount money
	DECLARE @SummaryTotalAmount money
	DECLARE @DiffAmount money
	DECLARE @MaxAmount MONEY
	DECLARE @ChangeKey INT -- the key I use for rounding errors
	
	Select 
		@ParentInvoiceKey = ISNULL(i.ParentInvoiceKey, 0),
		@OrigInvoiceKey = @InvoiceKey,
		@PercentageSplit = i.PercentageSplit,
		@ParentInvoice = ISNULL(i.ParentInvoice, 0),
		@UseBillingTitles = ISNULL(UseBillingTitles, 0)
	from tInvoice i (nolock)
		left outer join tPreference pref (nolock) on i.CompanyKey = pref.CompanyKey 
	Where i.InvoiceKey = @InvoiceKey	
		
		 
	if @ParentInvoiceKey = 0
		-- no parent, no split
		Select @PercentageSplit = 1
	ELSE
		-- there is a parent, point to it
		Select @InvoiceKey = @ParentInvoiceKey, @PercentageSplit = @PercentageSplit / 100
	
	IF @ParentInvoice = 1
	BEGIN
		DELETE tInvoiceSummary WHERE InvoiceKey = @OrigInvoiceKey
		IF @UseBillingTitles = 1
			DELETE tInvoiceSummaryTitle WHERE InvoiceKey = @OrigInvoiceKey
		RETURN 1	
	END
	
	-- We need a list of unique records
	CREATE TABLE #tInvoiceSummary (
		 MyKey int identity(1,1) not null
		
		,InvoiceLineKey int NULL
		,BillFrom int NULL
		,OfficeKey int NULL
		,ProjectKey int NULL
		,TaskKey int NULL 
		,Entity varchar(50) NULL
		,EntityKey int NULL
		,Amount money NULL
		,SalesTaxAmount MONEY NULL
		)
	
	
	-- No Transactions, these are good to go, no drill down
	INSERT #tInvoiceSummary(InvoiceLineKey,BillFrom,OfficeKey, ProjectKey, TaskKey, Entity, EntityKey, Amount, SalesTaxAmount)
	SELECT InvoiceLineKey,BillFrom
		,ISNULL(OfficeKey, 0), ISNULL(ProjectKey, 0), ISNULL(TaskKey, 0)
		,Entity, ISNULL(EntityKey, 0)
		,TotalAmount, 0
	FROM   tInvoiceLine (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey
	AND    BillFrom = 1 -- No Transactions
	AND    LineType = 2 -- Detail
	
	-- Use Transactions, these are NOT good to go, we need to drill down
	INSERT #tInvoiceSummary(InvoiceLineKey,BillFrom,OfficeKey,ProjectKey, TaskKey, Entity, EntityKey, Amount, SalesTaxAmount)	
	SELECT InvoiceLineKey,BillFrom,OfficeKey,ProjectKey, TaskKey, Entity, EntityKey, SUM(AmountBilled), 0
	FROM
	(
	SELECT  il.InvoiceLineKey, il.BillFrom
			,ISNULL(p.OfficeKey, 0) AS OfficeKey  -- If no project later, from the user?
			,ISNULL(t.ProjectKey, 0) AS ProjectKey
			,ISNULL(t.TaskKey, 0) AS TaskKey   
			,CAST('tService' AS VARCHAR(50)) AS Entity 
			,t.ServiceKey AS EntityKey
			,ROUND(ISNULL(BilledHours,0) * ISNULL(BilledRate,0), 2) AS AmountBilled 
	FROM    tTime t (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON t.InvoiceLineKey = il.InvoiceLineKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	UNION ALL
	
	SELECT  il.InvoiceLineKey, il.BillFrom
			,ISNULL(p.OfficeKey, 0) AS OfficeKey	
			,ISNULL(mc.ProjectKey, 0) AS ProjectKey
			,ISNULL(mc.TaskKey, 0) AS TaskKey   
			,CAST('tItem' AS VARCHAR(50)) AS Entity 
			,mc.ItemKey AS EntityKey
			,mc.AmountBilled  
	FROM    tMiscCost mc (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON mc.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	UNION ALL
	
	SELECT  il.InvoiceLineKey, il.BillFrom
			,CASE WHEN ISNULL(er.ProjectKey, 0) > 0 THEN ISNULL(p.OfficeKey, 0)
				  ELSE ISNULL(u.OfficeKey, 0) END AS OfficeKey		
			,ISNULL(er.ProjectKey, 0) AS ProjectKey
			,ISNULL(er.TaskKey, 0) AS TaskKey   
			,CAST('tItem' AS VARCHAR(50)) AS Entity  
			,er.ItemKey AS EntityKey
			,er.AmountBilled  
	FROM    tExpenseReceipt er (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON er.InvoiceLineKey = il.InvoiceLineKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
		INNER JOIN tUser u (NOLOCK) ON er.UserKey = u.UserKey 
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	UNION ALL
	
	SELECT  il.InvoiceLineKey, il.BillFrom
			,ISNULL(pod.OfficeKey, 0) AS OfficeKey
			,ISNULL(pod.ProjectKey, 0) AS ProjectKey
			,ISNULL(pod.TaskKey, 0) AS TaskKey   
			,CAST('tItem' AS VARCHAR(50)) AS Entity 
			,pod.ItemKey AS EntityKey
			,pod.AmountBilled  
	FROM    tPurchaseOrderDetail pod (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	UNION ALL
	
	SELECT  il.InvoiceLineKey, il.BillFrom
			,ISNULL(vd.OfficeKey, 0) AS OfficeKey
			,ISNULL(vd.ProjectKey, 0) AS ProjectKey
			,ISNULL(vd.TaskKey, 0) AS TaskKey   
			,CAST('tItem' AS VARCHAR(50)) AS Entity  
			,vd.ItemKey AS EntityKey
			,vd.AmountBilled  
	FROM    tVoucherDetail vd (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON vd.InvoiceLineKey = il.InvoiceLineKey
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	) AS trans
	GROUP BY InvoiceLineKey,BillFrom,OfficeKey, ProjectKey, TaskKey, Entity, EntityKey
	
	-- we need to get the SalesTaxAmount from tInvoiceTax 
	-- rather than tInvoiceLine because they could be edited on the UI for children invoices
	UPDATE #tInvoiceSummary
	SET    #tInvoiceSummary.SalesTaxAmount = ISNULL((
		SELECT SUM(it.SalesTaxAmount)
		FROM   tInvoiceTax it (NOLOCK)
		WHERE  it.InvoiceKey = @OrigInvoiceKey
		AND    it.InvoiceLineKey = #tInvoiceSummary.InvoiceLineKey
	),0)
	
	-- calculate sales tax amount proportionally to the amount for the trans 
	UPDATE #tInvoiceSummary
	SET    #tInvoiceSummary.SalesTaxAmount = ROUND(isnull(#tInvoiceSummary.SalesTaxAmount, 0) * (#tInvoiceSummary.Amount / il.TotalAmount), 2) 
	FROM   tInvoiceLine il (NOLOCK)
	WHERE  #tInvoiceSummary.InvoiceLineKey = il.InvoiceLineKey
	AND    il.TotalAmount <> 0
	AND    #tInvoiceSummary.BillFrom = 2
	
	UPDATE #tInvoiceSummary
	SET    #tInvoiceSummary.Amount = ROUND(Amount * @PercentageSplit, 2)
	      --,#tInvoiceSummary.SalesTaxAmount = ROUND(SalesTaxAmount * @PercentageSplit, 2)

	-- we may need to fix the amounts for the transactions (possible rounding errors) for each line
	SELECT @CurrInvoiceLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrInvoiceLineKey = MIN(InvoiceLineKey)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey > @CurrInvoiceLineKey
		
		IF @CurrInvoiceLineKey IS NULL
			BREAK
		
		SELECT @LineTotalAmount = ROUND(ISNULL(il.TotalAmount, 0) * @PercentageSplit, 2)
		FROM   tInvoiceLine il (NOLOCK)
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @SummaryTotalAmount = SUM(Amount)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(Amount))
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    Amount = @MaxAmount
			
			UPDATE #tInvoiceSummary SET Amount = Amount + @DiffAmount WHERE MyKey = @ChangeKey 
		END

		SELECT @LineTotalAmount = SUM(it.SalesTaxAmount) 
		FROM   tInvoiceTax it (NOLOCK)
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey -- same parent invoice line can be on child invoice
		AND    InvoiceKey = @OrigInvoiceKey -- so add invoice to where clause
		
		SELECT @SummaryTotalAmount = SUM(SalesTaxAmount)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey 
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(SalesTaxAmount))
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxAmount = @MaxAmount
			
			UPDATE #tInvoiceSummary SET SalesTaxAmount = SalesTaxAmount + @DiffAmount WHERE MyKey = @ChangeKey 
		END
		
	END
		
	/*
	-- we may need to fix the amounts for the transactions (possible rounding errors) for each line
	SELECT @CurrInvoiceLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrInvoiceLineKey = MIN(InvoiceLineKey)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey > @CurrInvoiceLineKey
		
		IF @CurrInvoiceLineKey IS NULL
			BREAK
		
		SELECT @LineTotalAmount = ROUND(ISNULL(il.TotalAmount, 0) * @PercentageSplit, 2)
		FROM   tInvoiceLine il (NOLOCK)
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @SummaryTotalAmount = SUM(Amount)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(Amount))
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    Amount = @MaxAmount
			
			UPDATE #tInvoiceSummary SET Amount = Amount + @DiffAmount WHERE MyKey = @ChangeKey 
		END

		SELECT @LineTotalAmount = ROUND(ISNULL(il.SalesTaxAmount, 0) * @PercentageSplit, 2)
		FROM   tInvoiceLine il (NOLOCK)
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @SummaryTotalAmount = SUM(SalesTaxAmount)
		FROM   #tInvoiceSummary 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(SalesTaxAmount))
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummary 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxAmount = @MaxAmount
			
			UPDATE #tInvoiceSummary SET SalesTaxAmount = SalesTaxAmount + @DiffAmount WHERE MyKey = @ChangeKey 
		END
		
	END
*/


	UPDATE #tInvoiceSummary SET OfficeKey = NULL WHERE OfficeKey = 0
	UPDATE #tInvoiceSummary SET ProjectKey = NULL WHERE ProjectKey = 0
	UPDATE #tInvoiceSummary SET TaskKey = NULL WHERE TaskKey = 0
	UPDATE #tInvoiceSummary SET EntityKey = NULL WHERE EntityKey = 0

--SELECT * FROM #tInvoiceSummary
	
	BEGIN TRAN
		
	DELETE tInvoiceSummary WHERE InvoiceKey = @OrigInvoiceKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	
	 
	INSERT tInvoiceSummary (InvoiceKey, InvoiceLineKey, OfficeKey, ProjectKey, TaskKey, Entity, EntityKey, Amount, SalesTaxAmount)
	SELECT @OrigInvoiceKey, InvoiceLineKey, OfficeKey, ProjectKey, TaskKey, Entity, EntityKey, ISNULL(Amount, 0) , ISNULL(SalesTaxAmount, 0)
	FROM   #tInvoiceSummary   

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	

	COMMIT TRAN
		 
	IF @UseBillingTitles = 1
		exec sptInvoiceSummaryTitle @OrigInvoiceKey

	RETURN 1
GO
