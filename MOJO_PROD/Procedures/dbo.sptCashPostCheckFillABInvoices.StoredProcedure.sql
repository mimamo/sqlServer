USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCheckFillABInvoices]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCheckFillABInvoices]
	(
	@CompanyKey INT
	,@AdvBillInvoiceKey INT 
	,@CheckKey INT
	,@InvoicesApplyAmount MONEY
	,@IsLastInvoicesApplication INT
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
*/
	SET NOCOUNT ON
	
	/*
	Assume that we already determined the list of invoices that we have to apply to
			
	CREATE TABLE #tABAnalysis (InvoiceKey INT null, NonTaxAmount MONEY null, SalesAlreadyApplied MONEY NULL, Closed int null
	-- General purpose amounts that I can use for various purposes 
	,GPAmount1 MONEY NULL,GPAmount2 MONEY NULL, GPAmount3 MONEY NULL, GPAmount4 MONEY NULL, GPAmount5 MONEY NULL
	)
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)
		
	*/
	
 	/*
 	In #tABAnalysis
 	GPAmount1 = tInvoiceAdvanceBill.Amount - SUM(tInvoiceAdvanceBillTax.Amount) for reg invoice
 	           - amount already reversed when posting the invoice 
 	GPAmount2 = Impact of the receipt on each invoice           
 	*/
 		
 	UPDATE #tABAnalysis
 	SET    #tABAnalysis.GPAmount1 = #tABAnalysis.NonTaxAmount - ISNULL((
 			SELECT ct.Debit -- Debit means REVERSED
 			FROM   tCashTransaction ct (NOLOCK)
 				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
 			WHERE  ct.Entity = 'INVOICE'
 			AND    ct.EntityKey = #tABAnalysis.InvoiceKey
 			AND    ct.AEntity = 'INVOICE'
 			AND    ct.AEntityKey = @AdvBillInvoiceKey
 			AND    ct.AEntity2 IS NULL
 			AND    ct.[Section] = 1 -- Header
 			AND    ISNULL(ctu.Unpost, 0) = 0
 			), 0)
 			-- check also in the temp table?
 			- ISNULL((
 			SELECT Debit -- Debit means REVERSED
 			FROM   #tCashTransaction (NOLOCK)
 			WHERE  Entity = 'INVOICE'
 			AND    EntityKey = #tABAnalysis.InvoiceKey
 			AND    AEntity = 'INVOICE'
 			AND    AEntityKey = @AdvBillInvoiceKey
 			AND    AEntity2 IS NULL
 			AND    [Section] = 1 -- Header
 			), 0)
 	
 	WHERE  #tABAnalysis.Closed = 0

--select * from #tABAnalysis
	
	DECLARE @CheckPostingDate DATETIME
	DECLARE @ReferenceNumber VARCHAR(100)
	
	Select @CheckPostingDate = PostingDate
		  ,@ReferenceNumber = ReferenceNumber
	from tCheck (nolock)
	Where CheckKey = @CheckKey
	
	DECLARE @ABInvoiceNumber VARCHAR(100)
	
	Select @ABInvoiceNumber = InvoiceNumber
	from tInvoice (nolock)
	Where InvoiceKey = @AdvBillInvoiceKey
	
	DECLARE @InvoiceKey INT
	DECLARE @TotalInvoiceNoTaxLineAmount MONEY
	DECLARE @AdvanceBillInvoiceNoTaxAmount MONEY
	DECLARE @TotalAdvanceBillNoTaxAmount MONEY
	
	SELECT  @InvoiceKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @InvoiceKey = MIN(InvoiceKey)
		FROM   #tABAnalysis
		WHERE  Closed = 0
 		AND    InvoiceKey > @InvoiceKey 
 		
 		IF @InvoiceKey IS NULL
 			BREAK

		SELECT @TotalInvoiceNoTaxLineAmount = TotalNonTaxAmount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		
		--SELECT @AdvanceBillInvoiceNoTaxAmount = #tABAnalysis.NonTaxAmount  
		SELECT @AdvanceBillInvoiceNoTaxAmount = #tABAnalysis.GPAmount1
		FROM   #tABAnalysis 
		WHERE  InvoiceKey = @InvoiceKey  
		
		-- This should have been done on the UI, we should not be have been able to overapply
		/*
		IF ABS(@AdvanceBillInvoiceNoTaxAmount) > ABS(@TotalInvoiceNoTaxLineAmount)
		BEGIN
			SELECT @AdvanceBillInvoiceNoTaxAmount = @TotalInvoiceNoTaxLineAmount
		END
		*/
		IF ISNULL(@TotalInvoiceNoTaxLineAmount, 0) <> 0
		BEGIN
			-- First insert the tran lines
			
			--select @InvoiceKey  AS InvoiceKey
			
			-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
			)
			
			SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', @InvoiceKey, Reference, 0, Credit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
			AND   [Section] = 2 -- lines only
 			
			-- Be careful because we could be in the process of posting the invoice to accrual
			-- And the records are missing from tCashTransactionLine 
			IF @@ROWCOUNT = 0
			BEGIN
			
				INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section
				
				-- specific to cash
				, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
				)
				
				SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section
				
				-- specific to cash
				, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', @InvoiceKey, Reference, 0, Credit, ctl.TempTranLineKey, 1
				
				FROM #tTransaction ctl (NOLOCK)
				WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
				AND   [Section] = 2 -- lines only
	 				
			END
			
			
			-- then calculate AAmount
			-- this would be the impact of the full tInvoiceAdvanceBill.Amount (w/o taxes) on each line
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT CashTransactionLineKey, LineAmount, 0
 			FROM   #tCashTransaction (NOLOCK)
			WHERE  Entity = 'RECEIPT'
			AND    EntityKey = @CheckKey
			AND    AEntity = 'INVOICE'
			AND    AEntityKey = @AdvBillInvoiceKey
			AND    AEntity2 = 'INVOICE'
			AND    AEntity2Key = @InvoiceKey
		
			
			--select @TotalInvoiceNoTaxLineAmount, @AdvanceBillInvoiceNoTaxAmount, @AdvanceBillInvoiceNoTaxAmount
			
 			EXEC sptCashApplyToLines @TotalInvoiceNoTaxLineAmount, @AdvanceBillInvoiceNoTaxAmount, @AdvanceBillInvoiceNoTaxAmount	
 			
 			--select * from #tApply
			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.AAmount = app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 = 'INVOICE'
			AND    #tCashTransaction.AEntity2Key = @InvoiceKey
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
			
			--select * from #tCashTransaction			
 		END
 		
	END
	
	IF @IsLastInvoicesApplication = 0
	BEGIN
	
 		-- Now calculate the impact of the receipt on each invoice
 		TRUNCATE TABLE #tApply  	
 		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 		SELECT InvoiceKey, GPAmount1, 0  -- subtract the amount reversed from the AB when posting the invoice 		
 		FROM   #tABAnalysis
 		WHERE  Closed = 0


		SELECT @TotalAdvanceBillNoTaxAmount = ISNULL((
			SELECT SUM(GPAmount1)
			FROM   #tABAnalysis
 			WHERE  Closed = 0 
 			),0)

 		EXEC sptCashApplyToLines @TotalAdvanceBillNoTaxAmount, @InvoicesApplyAmount, @InvoicesApplyAmount	
	 	
	 	UPDATE #tABAnalysis
	 	SET    #tABAnalysis.GPAmount2 = #tApply.ToApply
	 	FROM   #tApply
	 	WHERE  #tABAnalysis.InvoiceKey = #tApply.LineKey
	 						
 		-- Now calculate the impact for each invoice line
 		DECLARE @ReceiptImpactOnInvoice AS MONEY
 		DECLARE @TotalInvoiceAAmount AS MONEY
	 		
		SELECT  @InvoiceKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @InvoiceKey = MIN(InvoiceKey)
			FROM   #tABAnalysis
			WHERE  InvoiceKey > @InvoiceKey 
	 		AND Closed = 0
	 		
 			IF @InvoiceKey IS NULL
 				BREAK
	 			
 			SELECT @ReceiptImpactOnInvoice = GPAmount2
 			FROM   #tABAnalysis
			WHERE  InvoiceKey = @InvoiceKey 

			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT CashTransactionLineKey, AAmount, 0
			FROM   #tCashTransaction 	 			
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 = 'INVOICE'
			AND    #tCashTransaction.AEntity2Key = @InvoiceKey
			
			SELECT @TotalInvoiceAAmount = SUM(AAmount)
			FROM   #tCashTransaction 	 			
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 = 'INVOICE'
			AND    #tCashTransaction.AEntity2Key = @InvoiceKey
			
			SELECT @TotalInvoiceAAmount = ISNULL(@TotalInvoiceAAmount, 0)
			
			EXEC sptCashApplyToLines @TotalInvoiceAAmount, @ReceiptImpactOnInvoice, @ReceiptImpactOnInvoice	
	 			
 			UPDATE #tCashTransaction
			SET    #tCashTransaction.Credit = app.ToApply 
			FROM   #tApply app
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 = 'INVOICE'
			AND    #tCashTransaction.AEntity2Key = @InvoiceKey
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey	
				 			
		END
		 	
	END -- IsLastApplication = 0
	
	IF @IsLastInvoicesApplication = 1
	BEGIN
		-- capture what has already been applied to each line
		
		CREATE TABLE #tAlreadyApplied (InvoiceKey INT NULL, LineKey INT NULL, Amount MONEY NULL)

		SELECT  @InvoiceKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @InvoiceKey = MIN(InvoiceKey)
			FROM   #tABAnalysis
			WHERE  InvoiceKey > @InvoiceKey 
	 		AND Closed = 0
	 		
 			IF @InvoiceKey IS NULL
 				BREAK
	 			
			INSERT #tAlreadyApplied (InvoiceKey, LineKey, Amount)
			SELECT @InvoiceKey, CashTransactionLineKey, AAmount
			FROM   #tCashTransaction 	 			
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 = 'INVOICE'
			AND    #tCashTransaction.AEntity2Key = @InvoiceKey
		END
				
 		UPDATE #tAlreadyApplied
 		SET    #tAlreadyApplied.Amount = ISNULL((
 			SELECT SUM(Credit)
 		    FROM   tCashTransaction ct (NOLOCK)
 				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey 
 		    WHERE  #tAlreadyApplied.LineKey = ct.CashTransactionLineKey
 		    AND    ct.Entity = 'RECEIPT'
 		    AND    ct.AEntity = 'INVOICE'
			AND    ct.AEntityKey = @AdvBillInvoiceKey
			AND    ct.AEntity2 = 'INVOICE'
			AND    ct.AEntity2Key = #tAlreadyApplied.InvoiceKey
			AND    ISNULL(ctu.Unpost, 0) = 0
			),0)

 		UPDATE #tAlreadyApplied
 		SET    #tAlreadyApplied.Amount = #tAlreadyApplied.Amount + ISNULL((
 			SELECT SUM(Credit)
 		    FROM   #tCashTransaction ct (NOLOCK)
 		    WHERE  #tAlreadyApplied.LineKey = ct.CashTransactionLineKey
 		    AND    ct.Entity = 'RECEIPT'
 		    AND    ct.EntityKey <> @CheckKey -- not this check
 		    AND    ct.AEntity = 'INVOICE'
			AND    ct.AEntityKey = @AdvBillInvoiceKey
			AND    ct.AEntity2 = 'INVOICE'
			AND    ct.AEntity2Key = #tAlreadyApplied.InvoiceKey
			),0)
 		    
 		-- now set credit = application amount - amount already applied
 		UPDATE #tCashTransaction
 		SET    #tCashTransaction.Credit = #tCashTransaction.AAmount - #tAlreadyApplied.Amount
 		FROM   #tAlreadyApplied 
 		WHERE  #tAlreadyApplied.LineKey = #tCashTransaction.CashTransactionLineKey
 		AND    #tCashTransaction.Entity = 'RECEIPT'
 		AND    #tCashTransaction.EntityKey = @CheckKey 
 		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.AEntity2 = 'INVOICE'
		AND    #tCashTransaction.AEntity2Key = #tAlreadyApplied.InvoiceKey    
 		    
	END -- IsLastApplication = 1
	
	--select * from #tCashTransaction
			
	RETURN 1
GO
