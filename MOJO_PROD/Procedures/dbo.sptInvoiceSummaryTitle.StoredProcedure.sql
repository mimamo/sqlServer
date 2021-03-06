USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceSummaryTitle]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceSummaryTitle]
	(
	@InvoiceKey int
	)
AS --Encrypt
	
  /*
  || When     Who Rel     What
  || 10/01/14 GHL 10.584  Creation for titles by cloning sptInvoiceSummary and modifying accordingly
  ||                      Added handling of rounding errors 
  || 11/24/14 GHL 10.586  Added protection against division by 0
  */
	
	SET NOCOUNT ON
	
	DECLARE @ParentInvoice tinyint
	    ,@ParentInvoiceKey int
	    ,@OrigInvoiceKey int
	    ,@PercentageSplit decimal(24,4)
	    ,@CurrInvoiceKey int
	    
	DECLARE @CurrInvoiceLineKey int
	DECLARE @LineTotalAmount money
	DECLARE @SummaryTotalAmount money
	DECLARE @DiffAmount money
	DECLARE @MaxAmount MONEY
	DECLARE @ChangeKey INT
	
	Select 
		@ParentInvoiceKey = ISNULL(i.ParentInvoiceKey, 0),
		@OrigInvoiceKey = @InvoiceKey,
		@PercentageSplit = i.PercentageSplit,
		@ParentInvoice = ISNULL(i.ParentInvoice, 0)
	from tInvoice i (nolock) 
	Where i.InvoiceKey = @InvoiceKey	
		
		 
	if @ParentInvoiceKey = 0
		-- no parent, no split
		Select @PercentageSplit = 1
	ELSE
		-- there is a parent, point to it
		Select @InvoiceKey = @ParentInvoiceKey, @PercentageSplit = @PercentageSplit / 100
	
	IF @ParentInvoice = 1
	BEGIN
		DELETE tInvoiceSummaryTitle WHERE InvoiceKey = @OrigInvoiceKey
		RETURN 1	
	END
	
	-- We need a list of unique records
	CREATE TABLE #tInvoiceSummaryTitle (
		 MyKey int identity(1,1) not null
		
		,InvoiceLineKey int NULL
		,BillFrom int NULL
		,OfficeKey int NULL
		,ProjectKey int NULL
		,TaskKey int NULL 
		,TitleKey int NULL
		,Amount money NULL
		,SalesTaxAmount MONEY NULL

		,ISAmount money NULL			-- From #tInvoiceSummary
		,ISSalesTaxAmount MONEY NULL	-- From #tInvoiceSummary
		)
	
	
	-- No Transactions, these are good to go, no drill down
	INSERT #tInvoiceSummaryTitle(InvoiceLineKey,BillFrom,OfficeKey, ProjectKey, TaskKey, TitleKey, Amount, SalesTaxAmount)
	SELECT InvoiceLineKey,BillFrom
		,ISNULL(OfficeKey, 0), ISNULL(ProjectKey, 0), ISNULL(TaskKey, 0)
		,0 -- lack of title data so pass 0
		,TotalAmount, 0
	FROM   tInvoiceLine (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey
	AND    BillFrom = 1 -- No Transactions
	AND    LineType = 2 -- Detail
	-- at this time, we have not modified the Invoice screen to handle the titles
	AND    (Entity is NULL or Entity = 'tService')

	-- Use Transactions, these are NOT good to go, we need to drill down
	INSERT #tInvoiceSummaryTitle(InvoiceLineKey,BillFrom,OfficeKey,ProjectKey, TaskKey, TitleKey, Amount, SalesTaxAmount)	
	SELECT InvoiceLineKey,BillFrom,OfficeKey,ProjectKey, TaskKey, TitleKey, SUM(AmountBilled), 0
	FROM
	(
	SELECT  il.InvoiceLineKey, il.BillFrom
			,ISNULL(p.OfficeKey, 0) AS OfficeKey  -- If no project later, from the user?
			,ISNULL(t.ProjectKey, 0) AS ProjectKey
			,ISNULL(t.TaskKey, 0) AS TaskKey   
			,ISNULL(t.TitleKey, 0) AS TitleKey
			,ROUND(ISNULL(BilledHours,0) * ISNULL(BilledRate,0), 2) AS AmountBilled 
	FROM    tTime t (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON t.InvoiceLineKey = il.InvoiceLineKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
	WHERE  il.InvoiceKey = @InvoiceKey
	AND    il.BillFrom = 2 -- Use Transactions
	AND    il.LineType = 2 -- Detail
	
	) AS trans
	GROUP BY InvoiceLineKey,BillFrom,OfficeKey, ProjectKey, TaskKey, TitleKey
	
	-- capture the amounts and sales tax amounts from tInvoiceSummary (this is after the split)
	update #tInvoiceSummaryTitle
	set    #tInvoiceSummaryTitle.ISAmount = ISNULL((
		select sum(isum.Amount)
		from  #tInvoiceSummary isum (nolock)
		where #tInvoiceSummaryTitle.ProjectKey = isnull(isum.ProjectKey, 0)
		and   #tInvoiceSummaryTitle.TaskKey = isnull(isum.TaskKey, 0)
		and   #tInvoiceSummaryTitle.OfficeKey = isnull(isum.OfficeKey, 0) 
		and   #tInvoiceSummaryTitle.InvoiceLineKey = isnull(isum.InvoiceLineKey, 0)
		and   (isum.Entity is null or isum.Entity = 'tService') 
		),0)

	update #tInvoiceSummaryTitle
	set    #tInvoiceSummaryTitle.ISSalesTaxAmount = ISNULL((
		select sum(isum.SalesTaxAmount)
		from  #tInvoiceSummary isum (nolock)
		where #tInvoiceSummaryTitle.ProjectKey = isnull(isum.ProjectKey, 0)
		and   #tInvoiceSummaryTitle.TaskKey = isnull(isum.TaskKey, 0)
		and   #tInvoiceSummaryTitle.OfficeKey = isnull(isum.OfficeKey, 0)
		and   #tInvoiceSummaryTitle.InvoiceLineKey = isnull(isum.InvoiceLineKey, 0)
		and   (isum.Entity is null or isum.Entity = 'tService') 
		),0)

	-- apply the split
	UPDATE #tInvoiceSummaryTitle
	SET    #tInvoiceSummaryTitle.Amount = ROUND(Amount * @PercentageSplit, 2)
	
	-- calculate sales tax amount proportionally to the amount for the trans 
	UPDATE #tInvoiceSummaryTitle
	SET    SalesTaxAmount = case when isnull(ISAmount, 0) = 0 
		then 0 -- If tInvoiceSummary.Amount is 0 then taxes = 0
		else ROUND(isnull(ISSalesTaxAmount, 0) * (Amount / ISAmount), 2)
		end  
	WHERE   #tInvoiceSummaryTitle.BillFrom = 2
	
	--select  * from #tInvoiceSummaryTitle

	-- we may need to fix the amounts for the transactions (possible rounding errors) for each line
	
	-- here we compare with the labor records in tInvoiceSummary NOT tInvoiceLine
	
	SELECT @CurrInvoiceLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrInvoiceLineKey = MIN(InvoiceLineKey)
		FROM   #tInvoiceSummaryTitle 
		WHERE  InvoiceLineKey > @CurrInvoiceLineKey
		
		IF @CurrInvoiceLineKey IS NULL
			BREAK
		
		SELECT @LineTotalAmount = SUM(Amount)
		FROM   #tInvoiceSummary
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		AND    (Entity is null or Entity = 'tService')

		SELECT @SummaryTotalAmount = SUM(Amount)
		FROM   #tInvoiceSummaryTitle 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(Amount))
			FROM   #tInvoiceSummaryTitle 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummaryTitle 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    Amount = @MaxAmount
			
			UPDATE #tInvoiceSummaryTitle SET Amount = Amount + @DiffAmount WHERE MyKey = @ChangeKey 
		END

		SELECT @LineTotalAmount = SUM(SalesTaxAmount) 
		FROM   #tInvoiceSummary
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		AND    (Entity is null or Entity = 'tService')
		
		SELECT @SummaryTotalAmount = SUM(SalesTaxAmount)
		FROM   #tInvoiceSummaryTitle 
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey 
		
		SELECT @DiffAmount = @LineTotalAmount - @SummaryTotalAmount
		IF @DiffAmount <> 0
		BEGIN
			SELECT @MaxAmount = MAX(ABS(SalesTaxAmount))
			FROM   #tInvoiceSummaryTitle 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
		
			SELECT @ChangeKey = MyKey
			FROM   #tInvoiceSummaryTitle 
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxAmount = @MaxAmount
			
			UPDATE #tInvoiceSummaryTitle SET SalesTaxAmount = SalesTaxAmount + @DiffAmount WHERE MyKey = @ChangeKey 
		END
		
	END

	
	UPDATE #tInvoiceSummaryTitle SET OfficeKey = NULL WHERE OfficeKey = 0
	UPDATE #tInvoiceSummaryTitle SET ProjectKey = NULL WHERE ProjectKey = 0
	UPDATE #tInvoiceSummaryTitle SET TaskKey = NULL WHERE TaskKey = 0
	UPDATE #tInvoiceSummaryTitle SET TitleKey = NULL WHERE TitleKey = 0

--SELECT * FROM #tInvoiceSummaryTitle
	
	BEGIN TRAN
		
	DELETE tInvoiceSummaryTitle WHERE InvoiceKey = @OrigInvoiceKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	
	 
	INSERT tInvoiceSummaryTitle (InvoiceKey, InvoiceLineKey, OfficeKey, ProjectKey, TaskKey, TitleKey, Amount, SalesTaxAmount)
	SELECT @OrigInvoiceKey, InvoiceLineKey, OfficeKey, ProjectKey, TaskKey, TitleKey, ISNULL(Amount, 0) , ISNULL(SalesTaxAmount, 0)
	FROM   #tInvoiceSummaryTitle   

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	

	COMMIT TRAN
		 
	RETURN 1
GO
