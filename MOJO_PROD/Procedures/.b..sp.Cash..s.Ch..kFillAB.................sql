USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCheckFillAB]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCheckFillAB]
	(
	@CompanyKey INT
	,@AdvBillInvoiceKey INT 
	,@CheckKey INT
	,@CheckApplKey INT
	,@ApplyAmount MONEY
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
*/

	SET NOCOUNT ON

	DECLARE @ABInvoiceTotalAmount MONEY
	DECLARE @ABSalesAmount MONEY
	DECLARE @ABTaxesAmount MONEY
	DECLARE @ParentInvoiceKey int
	DECLARE @ParentInvoice tinyint
	DECLARE @PercentageSplit decimal(24,4)
	DECLARE @Percent decimal (20,8)
	DECLARE @LineInvoiceKey int -- This is the invoice where to get the lines from (the parent invoice)


	DECLARE @ABSalesAlreadyApplied MONEY
	DECLARE @ABTaxesAlreadyApplied MONEY
	DECLARE @ReceiptImpactOnSales MONEY
	DECLARE @ReceiptImpactOnTaxes MONEY
	DECLARE @CheckPostingDate DATETIME
	DECLARE @IsLastInvoicesApplication INT
	DECLARE @SalesToApplyOnInvoices MONEY
	DECLARE @InvoicesApplyAmount MONEY
	DECLARE @ABApplyAmount MONEY
	DECLARE @InvAdvBillNonTaxAmount MONEY
	DECLARE @ABInvoiceNumber VARCHAR(100) 
	DECLARE @IsLastABApplication INT
	
	-- Register all constants
DECLARE @kErrInvalidGLAcct INT					SELECT @kErrInvalidGLAcct = -1
DECLARE @kErrInvalidPrePayAcct INT				SELECT @kErrInvalidPrePayAcct = -2

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

-- Also declared in spGLPostInvoice
DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4

	-- Vars for GL tran
DECLARE @TransactionDate smalldatetime
		,@Entity VARCHAR(50)
		,@EntityKey INT
		,@Reference VARCHAR(100)
		,@GLAccountKey INT
		,@ClassKey int
		,@Memo varchar(500)
		,@PostSide char(1)
		,@ClientKey int
		,@ProjectKey int
		,@SourceCompanyKey INT
		,@DepositKey INT
		,@GLCompanyKey INT
		,@OfficeKey INT
		,@DepartmentKey INT
		,@DetailLineKey INT
		,@Section INT
		,@GLAccountErrRet INT
		,@RetVal INT
		,@TransactionCount INT

-- Vars for check/receipt info
Declare @CashAccountKey int
Declare @PrepayAccountKey int
Declare @CheckAmount money
Declare @AppliedAmount money
Declare @PrepayAmount money
Declare @ReferenceNumber varchar(100)
Declare @Amount money
Declare @Posted tinyint
Declare @OpeningTransaction tinyint
	
	Select
		@CheckPostingDate = PostingDate
		,@GLCompanyKey = GLCompanyKey
		,@ClientKey = ClientKey
		,@TransactionDate = PostingDate
		,@ReferenceNumber = ReferenceNumber
		,@CashAccountKey = CashAccountKey
		,@PrepayAccountKey = PrepayAccountKey
		,@ClassKey = ClassKey
		,@DepositKey = DepositKey
		,@Posted = Posted
		,@ProjectKey = NULL
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	from tCheck (nolock)
	Where CheckKey = @CheckKey
	
	Select 
		@ABInvoiceTotalAmount = BilledAmount
		,@ABTaxesAmount = ISNULL(SalesTaxAmount, 0) -- This includes sales tax 1 + sales tax 2 + other taxes
		,@ABSalesAmount = BilledAmount - ISNULL(SalesTaxAmount, 0)
		,@ParentInvoice = ISNULL(ParentInvoice, 0)
		,@ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0)
		,@PercentageSplit = ISNULL(PercentageSplit, 0)
		,@LineInvoiceKey = InvoiceKey -- By default, we get the lines from this invoice
		,@ABInvoiceNumber = InvoiceNumber
	From vInvoice (nolock)
	Where InvoiceKey = @AdvBillInvoiceKey
	
	if @ParentInvoice = 0
	BEGIN
		if @ParentInvoiceKey > 0
			Select	@Percent = @PercentageSplit / 100.0
					,@LineInvoiceKey = @ParentInvoiceKey -- The lines belong to the parent invoice
		else
			Select @Percent = 1
	END

-- since I do not know whether the lines are in permanent tables or not, capture the lines here  
	CREATE TABLE #LineAmount(LineKey int null, Section int null
		, LineAmount money null, AlreadyApplied money null, ToApply money null
		, AdvBillAmount money null, PrepaymentAmount money null, ReceiptAmount money null) 
	
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		,GPFlag int null
		)	

	-- 1)Determine the last application flag and prepare taxes
	
	DECLARE @LinesInDB int
	SELECT @LinesInDB = 1
	
	INSERT #LineAmount (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
	SELECT CashTransactionLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
	FROM   tCashTransactionLine (NOLOCK)
	WHERE  Entity = 'INVOICE'
	AND    EntityKey = @AdvBillInvoiceKey
	
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @LinesInDB = 0
			
		INSERT #LineAmount (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
		SELECT TempTranLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
		FROM   #tCashTransactionLine
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @AdvBillInvoiceKey
	END 
		
		-- Amounts already applied on receipts
	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'RECEIPT'
		--AND    ct.EntityKey = @CheckKey
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.CashTransactionLineKey = #LineAmount.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
		AND    ct.Section = 5 -- taxes
	),0)

	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'RECEIPT'
		--AND    tCashTransaction.EntityKey = @CheckKey
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = #LineAmount.LineKey
		AND    #tCashTransaction.Section = 5 -- taxes
	),0)	
		
	-- Add ALL PREPAYMENTS
	-- they were REVERSALS when posting the invoice
	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.EntityKey = @AdvBillInvoiceKey
		AND    ct.AEntity = 'RECEIPT'
		AND    ct.CashTransactionLineKey = #LineAmount.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
		AND    ct.Section = 5 -- taxes
	),0)

	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.EntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.AEntity = 'RECEIPT'
		AND    #tCashTransaction.CashTransactionLineKey = #LineAmount.LineKey
		AND    #tCashTransaction.Section = 5 -- taxes
	),0)		

	SELECT @ABTaxesAlreadyApplied = ISNULL((
		SELECT SUM(AlreadyApplied)
		FROM   #LineAmount 
		WHERE  Section = 5	
	), 0)	
	
	-- now get the amount applied to sales	
			
	-- receipts
	SELECT @ABSalesAlreadyApplied = ISNULL((
	SELECT SUM(ct.Credit)
	FROM   tCashTransaction ct (NOLOCK)
		LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
	WHERE  ct.Entity = 'RECEIPT'
	--AND    ct.EntityKey <> @CheckKey
	AND    ct.AEntity = 'INVOICE'
	AND    ct.AEntityKey = @AdvBillInvoiceKey
	AND    ct.[Section] = 2 -- Lines
	AND    ISNULL(ctu.Unpost, 0) = 0
	), 0)
			
	-- reversals due to invoices
	SELECT @ABSalesAlreadyApplied = @ABSalesAlreadyApplied + ISNULL((
	SELECT SUM(ct.Credit)
	FROM   tCashTransaction ct (NOLOCK)
		LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
	WHERE  ct.Entity = 'INVOICE'   -- all invoices 
	AND    ct.AEntity = 'INVOICE'
	AND    ct.AEntityKey = @AdvBillInvoiceKey
	AND    ct.[Section] = 2 -- lines
	AND    ISNULL(ctu.Unpost, 0) = 0
	), 0)

	-- also check in temp tables 
	SELECT @ABSalesAlreadyApplied = @ABSalesAlreadyApplied + ISNULL((
	SELECT SUM(Credit)
	FROM   #tCashTransaction (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND	   Entity = 'RECEIPT'
	--AND    EntityKey <> @CheckKey
	AND    AEntity = 'INVOICE'
	AND    AEntityKey = @AdvBillInvoiceKey
	AND    [Section] = 2 -- Lines
	), 0)

	-- AB reversals due to invoices
	SELECT @ABSalesAlreadyApplied = @ABSalesAlreadyApplied + ISNULL((
	SELECT SUM(Credit)
	FROM   #tCashTransaction (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND	   Entity = 'INVOICE'   -- all invoices 
	AND    AEntity = 'INVOICE'
	AND    AEntityKey = @AdvBillInvoiceKey
	AND    [Section] = 2 -- lines
	), 0)
		
	select @ABTaxesAlreadyApplied = ISNULL(@ABTaxesAlreadyApplied, 0)
	select @ABSalesAlreadyApplied = ISNULL(@ABSalesAlreadyApplied, 0)

	--select @ABTaxesAlreadyApplied, @ABSalesAlreadyApplied
	
	IF ((@ABTaxesAlreadyApplied + @ABSalesAlreadyApplied + @ApplyAmount) = @ABInvoiceTotalAmount)
		SELECT @IsLastABApplication = 1
	ELSE
		SELECT @IsLastABApplication = 0
		
	IF @IsLastABApplication = 1 
	BEGIN
		-- Taxes are always calculated with every posting of a receipt against AB  
		SELECT @ReceiptImpactOnTaxes = @ABTaxesAmount - @ABTaxesAlreadyApplied 
		
		-- and then recalc impact on sales
		SELECT @ReceiptImpactOnSales = @ApplyAmount - @ReceiptImpactOnTaxes	
	END
	ELSE
	BEGIN
		IF @ABInvoiceTotalAmount <> 0
		BEGIN
			IF @ABTaxesAmount <> 0
			BEGIN
				SELECT @ReceiptImpactOnTaxes = ROUND((@ApplyAmount * @ABTaxesAmount) / @ABInvoiceTotalAmount, 2)
				SELECT @ReceiptImpactOnSales = @ApplyAmount - @ReceiptImpactOnTaxes 
			END
			ELSE
			BEGIN
				SELECT @ReceiptImpactOnTaxes = 0
				SELECT @ReceiptImpactOnSales = ROUND((@ApplyAmount * @ABSalesAmount) / @ABInvoiceTotalAmount, 2) 
			END
		END
		ELSE
			SELECT @ReceiptImpactOnSales = 0, @ReceiptImpactOnTaxes = 0
	END
		
 	IF @ReceiptImpactOnSales = 0
 		RETURN 1

	-- 2) Analyze the invoices linked to the adv bill 
	
	CREATE TABLE #tABAnalysis (InvoiceKey INT null, NonTaxAmount MONEY null, SalesAlreadyApplied MONEY NULL, Closed int null
	-- General purpose amounts that I can use for various purposes 
	,GPAmount1 MONEY NULL,GPAmount2 MONEY NULL, GPAmount3 MONEY NULL, GPAmount4 MONEY NULL, GPAmount5 MONEY NULL
	)

	INSERT #tABAnalysis (InvoiceKey, NonTaxAmount, SalesAlreadyApplied, Closed)
	SELECT i.InvoiceKey, iab.Amount, 0, 0
	FROM   tInvoiceAdvanceBill iab (NOLOCK)
		INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
	WHERE  iab.AdvBillInvoiceKey = @AdvBillInvoiceKey   
	-- They should be posted
	AND (i.Posted = 1
			OR
			-- Or we are in the process of posting it to Accrual
			i.InvoiceKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=0)
			)	 
	-- And we are not in the process of unposting it from Accrual
	AND	i.InvoiceKey NOT IN (SELECT EntityKey FROM #tCashQueue 
		WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=1)		
		
	-- we consider that if the invoices have the same posting date
	-- they are BEFORE the check
	AND    i.PostingDate <= @CheckPostingDate  
	AND    iab.InvoiceKey <> iab.AdvBillInvoiceKey -- filter out self applications
			
	UPDATE #tABAnalysis
	SET    #tABAnalysis.NonTaxAmount = #tABAnalysis.NonTaxAmount - ISNULL((
		SELECT SUM(Amount)
		FROM   tInvoiceAdvanceBillTax (NOLOCK)
		WHERE  AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    InvoiceKey = #tABAnalysis.InvoiceKey
		),0)
	
	-- Get the Sales already applied against each invoice 
	UPDATE #tABAnalysis
	SET    #tABAnalysis.SalesAlreadyApplied = #tABAnalysis.SalesAlreadyApplied + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'RECEIPT'
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.AEntity2 = 'INVOICE'
		AND    ct.AEntity2Key = #tABAnalysis.InvoiceKey
		AND    ct.[Section] = 2
		AND    ISNULL(ctu.Unpost, 0) = 0
		),0)

	-- Add the AB reversals when posting the real invoices
	UPDATE #tABAnalysis
	SET    #tABAnalysis.SalesAlreadyApplied = #tABAnalysis.SalesAlreadyApplied + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.EntityKey = #tABAnalysis.InvoiceKey
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.[Section] = 2
		AND    ISNULL(ctu.Unpost, 0) = 0
		),0)
	
	-- and check the temp table
	UPDATE #tABAnalysis
	SET    #tABAnalysis.SalesAlreadyApplied = #tABAnalysis.SalesAlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'RECEIPT'
		AND    AEntity = 'INVOICE'
		AND    AEntityKey = @AdvBillInvoiceKey
		AND    AEntity2 = 'INVOICE'
		AND    AEntity2Key = #tABAnalysis.InvoiceKey
		AND    [Section] = 2
		),0)

	UPDATE #tABAnalysis
	SET    #tABAnalysis.SalesAlreadyApplied = #tABAnalysis.SalesAlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = #tABAnalysis.InvoiceKey
		AND    AEntity = 'INVOICE'
		AND    AEntityKey = @AdvBillInvoiceKey
		AND    [Section] = 2
		),0)


	--select * from #tABAnalysis

	 -- 3) Save the taxes
	
	-- Enter credits for taxes
	IF @ABTaxesAmount <> 0
	BEGIN
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
			, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, NULL, NULL, NULL, 0, Credit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
			AND   [Section] = 5 -- taxes only
	
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
				, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, NULL, NULL, NULL, 0, Credit, ctl.TempTranLineKey, 1
				
				FROM #tTransaction ctl (NOLOCK)
				WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
				AND   [Section] = 5 -- taxes only
					
			END
	
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT CashTransactionLineKey, LineAmount, 0
 			FROM   #tCashTransaction (NOLOCK)
			WHERE  Entity = 'RECEIPT'
			AND    EntityKey = @CheckKey
			AND    AEntity = 'INVOICE'
			AND    AEntityKey = @AdvBillInvoiceKey
			AND    [Section] = 5
		
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
				SELECT SUM(line.AlreadyApplied)
				FROM   #LineAmount line
				WHERE  line.LineKey = #tApply.LineKey
			),0)
			
			 
 			EXEC sptCashApplyToLines @ABTaxesAmount, @ReceiptImpactOnTaxes, @ReceiptImpactOnTaxes, @IsLastABApplication	
 			
 			--select * from #tApply
 			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.Credit = app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
			AND    #tCashTransaction.[Section] = 5
		
	END

--select * from #tABAnalysis

	-- 4) Save the Sales
	
 	IF @ReceiptImpactOnSales > 0
	BEGIN
		--we will apply only if SalesAlreadyApplied < NonTaxAmount 
		UPDATE #tABAnalysis
		SET    Closed = 1
		WHERE  SalesAlreadyApplied >= NonTaxAmount
	
		SELECT @SalesToApplyOnInvoices = SUM(NonTaxAmount - SalesAlreadyApplied)
		FROM   #tABAnalysis
		WHERE  Closed = 0
		SELECT @SalesToApplyOnInvoices = ISNULL(@SalesToApplyOnInvoices, 0)	
			
		IF (SELECT COUNT(*) FROM #tABAnalysis WHERE Closed = 0) > 0 AND @SalesToApplyOnInvoices > 0 
		BEGIN
			IF @ReceiptImpactOnSales >= @SalesToApplyOnInvoices
				SELECT @IsLastInvoicesApplication = 1, @InvoicesApplyAmount = @SalesToApplyOnInvoices
			ELSE
				SELECT @IsLastInvoicesApplication = 0, @InvoicesApplyAmount = @ReceiptImpactOnSales
			
			EXEC sptCashPostCheckFillABInvoices @CompanyKey, @AdvBillInvoiceKey
				,@CheckKey, @InvoicesApplyAmount, @IsLastInvoicesApplication				
		END		 
		ELSE
			SELECT @InvoicesApplyAmount = 0
			
		SELECT @ABApplyAmount = @ReceiptImpactOnSales - @InvoicesApplyAmount
	
		--SELECT @ReceiptImpactOnTaxes, @ReceiptImpactOnSales, @InvoicesApplyAmount, @ABApplyAmount, @IsLastInvoicesApplication, @IsLastABApplication
		
		IF @ABApplyAmount <> 0
		BEGIN
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
			, 'INVOICE', @AdvBillInvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
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
				, 'INVOICE', @AdvBillInvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.TempTranLineKey, 1
				
				FROM #tTransaction ctl (NOLOCK)
				WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
				AND   [Section] = 2 -- lines only
					
			END
			
			-- Now add to the AlreadyApplied bucket, the amounts in tInvoiceAdvanceBill.Amount
			-- How can I distribute this by line?
			SELECT @InvAdvBillNonTaxAmount = SUM(NonTaxAmount) FROM #tABAnalysis
			SELECT @InvAdvBillNonTaxAmount = ISNULL(@InvAdvBillNonTaxAmount, 0)
			--SELECT @InvAdvBillNonTaxAmount
			
			-- we must subtract what has been reversed by invoices
			SELECT @InvAdvBillNonTaxAmount = @InvAdvBillNonTaxAmount - ISNULL((
				SELECT SUM(Debit)
				FROM   #tCashTransaction (NOLOCK)
				WHERE  Entity = 'INVOICE'
				--AND    EntityKey = @CheckKey
				AND    AEntity = 'INVOICE'
				AND    AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL -- not applied to invoices
				AND    #tCashTransaction.[Section] = 1
			),0)
			
			SELECT @InvAdvBillNonTaxAmount = @InvAdvBillNonTaxAmount - ISNULL((
				SELECT SUM(ct.Debit)
				FROM   tCashTransaction ct (NOLOCK)
					LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
				WHERE  ct.Entity = 'INVOICE'
				--AND    ct.EntityKey = @CheckKey
				AND    ct.AEntity = 'INVOICE'
				AND    ct.AEntityKey = @AdvBillInvoiceKey
				AND    ct.AEntity2 IS NULL -- not applied to invoices
				AND    ct.[Section] = 1
				AND    ISNULL(ctu.Unpost, 0) = 0
			),0)
			
			--SELECT @InvAdvBillNonTaxAmount
			
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT CashTransactionLineKey, LineAmount, 0
 			FROM   #tCashTransaction (NOLOCK)
			WHERE  Entity = 'RECEIPT'
			AND    EntityKey = @CheckKey
			AND    AEntity = 'INVOICE'
			AND    AEntityKey = @AdvBillInvoiceKey
			AND    AEntity2 IS NULL -- not applied to invoices
			AND    [Section] = 2 -- lines, no taxes
			
			EXEC sptCashApplyToLines @ABSalesAmount, @InvAdvBillNonTaxAmount, @InvAdvBillNonTaxAmount	
 			
 			--select * from #tApply
 			
 			-- place it in AAmount
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.AAmount = app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
									
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT CashTransactionLineKey, LineAmount, 0
 			FROM   #tCashTransaction (NOLOCK)
			WHERE  Entity = 'RECEIPT'
			AND    EntityKey = @CheckKey
			AND    AEntity = 'INVOICE'
			AND    AEntityKey = @AdvBillInvoiceKey
			AND    AEntity2 IS NULL -- not applied to invoices
			AND    [Section] = 2 -- lines, no taxes
			
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
				SELECT SUM(ct.Credit)
				FROM   tCashTransaction ct (NOLOCK)
					LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
				WHERE  ct.Entity = 'RECEIPT'
				--AND    ct.EntityKey = @CheckKey
				AND    ct.AEntity = 'INVOICE'
				AND    ct.AEntityKey = @AdvBillInvoiceKey
				AND    ct.AEntity2 IS NULL
				AND    ct.CashTransactionLineKey = #tApply.LineKey
				AND    ISNULL(ctu.Unpost, 0) = 0
			),0)
			
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
				SELECT SUM(Credit)
				FROM   #tCashTransaction (NOLOCK)
				WHERE  #tCashTransaction.Entity = 'RECEIPT'
				--AND    #tCashTransaction.EntityKey = @CheckKey
				AND    #tCashTransaction.AEntity = 'INVOICE'
				AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL
				AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
			),0)
			
			-- Add the prepayments, they should be on the adv bill invoice
			-- Added 02/18/2009 
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
				SELECT SUM(ct.Credit)
				FROM   tCashTransaction ct (NOLOCK)
					LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
				WHERE  ct.Entity = 'INVOICE'
				AND    ct.EntityKey = @AdvBillInvoiceKey
				AND    ct.AEntity = 'RECEIPT'
				AND    ct.CashTransactionLineKey = #tApply.LineKey
				AND    ISNULL(ctu.Unpost, 0) = 0
			),0)
			
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
				SELECT SUM(Credit)
				FROM   #tCashTransaction (NOLOCK)
				WHERE  #tCashTransaction.Entity = 'INVOICE'
				AND    #tCashTransaction.EntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity = 'RECEIPT'
				AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
			),0)
			
			
			--select * from #tApply
			
			-- Add the AAmount to AlreadyApplied
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL(#tCashTransaction.AAmount,0)
			FROM   #tCashTransaction
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
			
												 
 			EXEC sptCashApplyToLines @ABSalesAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
 			
 			--select * from #tApply
 			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.Credit = app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
		
		
		END					
				
	END
		
		
 	IF @ReceiptImpactOnSales < 0
	BEGIN
		IF @ABSalesAlreadyApplied > 0
		BEGIN
			IF ABS(@ReceiptImpactOnSales) >= @ABSalesAlreadyApplied
				SELECT @ABApplyAmount = -1 * @ABSalesAlreadyApplied
			ELSE
				SELECT @ABApplyAmount = @ReceiptImpactOnSales
		
			-- Enter the credits for AB
			IF @ABApplyAmount <> 0
			BEGIN
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
				, 'INVOICE', @AdvBillInvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.CashTransactionLineKey
				
				FROM tCashTransactionLine ctl (NOLOCK)
				WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
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
					, 'INVOICE', @AdvBillInvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.TempTranLineKey, 1
					
					FROM #tTransaction ctl (NOLOCK)
					WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
					AND   [Section] = 2 -- lines only
						
				END
			
				-- Now add to the AlreadyApplied bucket, the amounts in tInvoiceAdvanceBill.Amount
				-- How can I distribute this by line?
				SELECT @InvAdvBillNonTaxAmount = SUM(NonTaxAmount) FROM #tABAnalysis
				SELECT @InvAdvBillNonTaxAmount = ISNULL(@InvAdvBillNonTaxAmount, 0)
			
				-- we must subtract what has been reversed by invoices
				SELECT @InvAdvBillNonTaxAmount = @InvAdvBillNonTaxAmount - ISNULL((
					SELECT SUM(Debit)
					FROM   #tCashTransaction (NOLOCK)
					WHERE  Entity = 'INVOICE'
					--AND    EntityKey = @CheckKey
					AND    AEntity = 'INVOICE'
					AND    AEntityKey = @AdvBillInvoiceKey
					AND    AEntity2 IS NULL -- not applied to invoices
					AND    [Section] = 1
				),0)
				
				SELECT @InvAdvBillNonTaxAmount = @InvAdvBillNonTaxAmount - ISNULL((
					SELECT SUM(ct.Debit)
					FROM   tCashTransaction ct (NOLOCK)
						LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
					WHERE  ct.Entity = 'INVOICE'
					--AND    ct.EntityKey = @CheckKey
					AND    ct.AEntity = 'INVOICE'
					AND    ct.AEntityKey = @AdvBillInvoiceKey
					AND    ct.AEntity2 IS NULL -- not applied to invoices
					AND    ct.[Section] = 1
					AND    ISNULL(ctu.Unpost, 0) = 0
				),0)
				
				TRUNCATE TABLE #tApply  	
 				INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 				SELECT CashTransactionLineKey, LineAmount, 0
 				FROM   #tCashTransaction (NOLOCK)
				WHERE  Entity = 'RECEIPT'
				AND    EntityKey = @CheckKey
				AND    AEntity = 'INVOICE'
				AND    AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL -- not applied to invoices
				AND    #tCashTransaction.[Section] = 2 -- lines, no taxes
				
				EXEC sptCashApplyToLines @ABSalesAmount, @InvAdvBillNonTaxAmount, @InvAdvBillNonTaxAmount	
	 			
 				-- place it in AAmount
 				UPDATE #tCashTransaction
 				SET    #tCashTransaction.AAmount = app.ToApply 
 				FROM   #tApply app
 				WHERE  #tCashTransaction.Entity = 'RECEIPT'
				AND    #tCashTransaction.EntityKey = @CheckKey
				AND    #tCashTransaction.AEntity = 'INVOICE'
				AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL
				AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
										
				TRUNCATE TABLE #tApply  	
 				INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 				SELECT CashTransactionLineKey, LineAmount, 0
 				FROM   #tCashTransaction (NOLOCK)
				WHERE  Entity = 'RECEIPT'
				AND    EntityKey = @CheckKey
				AND    AEntity = 'INVOICE'
				AND    AEntityKey = @AdvBillInvoiceKey
				AND    AEntity2 IS NULL -- not applied to invoices
				AND    [Section] = 2 -- lines, no taxes
				
				UPDATE #tApply
				SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
					SELECT SUM(ct.Credit)
					FROM   tCashTransaction ct (NOLOCK)
						LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
					WHERE  ct.Entity = 'RECEIPT'
					--AND    ct.EntityKey = @CheckKey
					AND    ct.AEntity = 'INVOICE'
					AND    ct.AEntityKey = @AdvBillInvoiceKey
					AND    ct.AEntity2 IS NULL
					AND    ct.CashTransactionLineKey = #tApply.LineKey
					AND    ISNULL(ctu.Unpost, 0) = 0
				),0)
				
				UPDATE #tApply
				SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
					SELECT SUM(Credit)
					FROM   #tCashTransaction (NOLOCK)
					WHERE  #tCashTransaction.Entity = 'RECEIPT'
					--AND    #tCashTransaction.EntityKey = @CheckKey
					AND    #tCashTransaction.AEntity = 'INVOICE'
					AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
					AND    #tCashTransaction.AEntity2 IS NULL
					AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
				),0)

				-- Add the prepayments, they should be on the adv bill invoice
				-- Added 02/18/2009 
				-- This may not be required since @IsLastABApplication = 0 when ApplyAmount <0
				-- AlreadyApplied has to be ACCURATE when @IsLastABApplication = 1 
				UPDATE #tApply
				SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
					SELECT SUM(ct.Credit)
					FROM   tCashTransaction ct (NOLOCK)
						LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
					WHERE  ct.Entity = 'INVOICE'
					AND    ct.EntityKey = @AdvBillInvoiceKey
					AND    ct.AEntity = 'RECEIPT'
					AND    ct.CashTransactionLineKey = #tApply.LineKey
					AND    ISNULL(ctu.Unpost, 0) = 0
				),0)
				
				UPDATE #tApply
				SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
					SELECT SUM(Credit)
					FROM   #tCashTransaction (NOLOCK)
					WHERE  #tCashTransaction.Entity = 'INVOICE'
					AND    #tCashTransaction.EntityKey = @AdvBillInvoiceKey
					AND    #tCashTransaction.AEntity = 'RECEIPT'
					AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
				),0)
			
				-- Add the AAmount to AlreadyApplied
				UPDATE #tApply
				SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL(#tCashTransaction.AAmount,0)
				FROM   #tCashTransaction
				WHERE  #tCashTransaction.Entity = 'RECEIPT'
				AND    #tCashTransaction.EntityKey = @CheckKey
				AND    #tCashTransaction.AEntity = 'INVOICE'
				AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL
				AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
				
													 
 				EXEC sptCashApplyToLines @ABSalesAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
	 			
 				UPDATE #tCashTransaction
 				SET    #tCashTransaction.Credit = app.ToApply 
 				FROM   #tApply app
 				WHERE  #tCashTransaction.Entity = 'RECEIPT'
				AND    #tCashTransaction.EntityKey = @CheckKey
				AND    #tCashTransaction.AEntity = 'INVOICE'
				AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
				AND    #tCashTransaction.AEntity2 IS NULL
				AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
			
			END -- Enter credits against AB
			
			-- apply what is left against the invoices
			SELECT @IsLastInvoicesApplication = 0, @InvoicesApplyAmount = @ReceiptImpactOnSales - @ABApplyAmount
				
		END -- Someting was applied against AB 
		ELSE
		BEGIN
			-- Nothing applied against AB yet,
			SELECT @IsLastInvoicesApplication = 0, @InvoicesApplyAmount = @ReceiptImpactOnSales 
		END	
		--select * from #tCashTransaction
			
		IF @InvoicesApplyAmount <> 0
		BEGIN
			EXEC sptCashPostCheckFillABInvoices @CompanyKey, @AdvBillInvoiceKey
				,@CheckKey, @InvoicesApplyAmount, @IsLastInvoicesApplication				
		END 				
				
	END -- negative sales amount
		
		
		
	RETURN 1
GO
