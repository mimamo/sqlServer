USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCheckFillABInvoice]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCheckFillABInvoice]
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


	DECLARE @CheckPostingDate DATETIME
	DECLARE @IsLastInvoicesApplication INT
	DECLARE @IsLastABApplication INT
	DECLARE @ToApplyOnInvoices MONEY
	DECLARE @InvoicesApplyAmount MONEY
	DECLARE @ABApplyAmount MONEY
	DECLARE @ABInvoiceNumber VARCHAR(100) 
	
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
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		,GPFlag int null
		)	
	
	 
	-- 1)Gather all the data on AB invoice lines
	DECLARE @ABLinesInDB int
	SELECT @ABLinesInDB = 1
	
	CREATE TABLE #ABLines(LineKey int null, Section int null, LineAmount money null
		, AlreadyReceived money null, AlreadyReversed money null, ToApply money null) 
	
	
	INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
	SELECT CashTransactionLineKey, Section, PrepaymentAmount + ReceiptAmount, 0, 0, 0
	FROM   tCashTransactionLine (NOLOCK)
	WHERE  Entity = 'INVOICE'
	AND    EntityKey = @AdvBillInvoiceKey
	
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @ABLinesInDB = 0
		
		INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
		SELECT TempTranLineKey, Section, PrepaymentAmount + ReceiptAmount, 0, 0, 0
		FROM   #tCashTransactionLine
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @AdvBillInvoiceKey
	END 
		
	-- because credit memos could be applied to AB, better to recalc @ABInvoiceTotalAmount
	SELECT @ABInvoiceTotalAmount = ISNULL((
		SELECT SUM(LineAmount)
		FROM #ABLines
		),0)
		
	-- Amounts already applied on receipts
	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'RECEIPT'
		--AND    ct.EntityKey = @CheckKey
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'RECEIPT'
		--AND    tCashTransaction.EntityKey = @CheckKey
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)	
		
	-- Add ALL PREPAYMENTS
	-- they were REVERSALS when posting the invoice
	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.EntityKey = @AdvBillInvoiceKey
		AND    ct.AEntity = 'RECEIPT'
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.EntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.AEntity = 'RECEIPT'
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)		

	-- Amounts already reversed
	UPDATE #ABLines
	SET    #ABLines.AlreadyReversed = #ABLines.AlreadyReversed + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReversed = #ABLines.AlreadyReversed + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)	
	

	-- 2) Analyze the invoices linked to the adv bill 

	CREATE TABLE #Invoices (InvoiceKey INT null)
	CREATE TABLE #InvoiceLines (InvoiceKey INT null, LineKey int null, LineID int identity(1,1), Closed int null
		, LinesInDB int null, AdvBillAmount money null, AlreadyReceived money null, AlreadyReversed money null, ToApply money null)
	
	INSERT #Invoices (InvoiceKey)
	SELECT i.InvoiceKey
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
	
	--select * from #Invoices
	
	DECLARE @InvoiceKey int
	DECLARE @LinesInDB int
	
	SELECT @InvoiceKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @InvoiceKey = MIN(InvoiceKey)
		FROM   #Invoices
		WHERE  InvoiceKey > @InvoiceKey 
	
		IF @InvoiceKey IS NULL
			BREAK
			
		SELECT @LinesInDB = 1
		INSERT #InvoiceLines (InvoiceKey, LineKey, Closed, LinesInDB, AdvBillAmount, AlreadyReceived, AlreadyReversed, ToApply)
		SELECT @InvoiceKey, CashTransactionLineKey, 0, 1, ISNULL(AdvBillAmount, 0), 0, 0, 0
		FROM   tCashTransactionLine (NOLOCK)
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @InvoiceKey
		
		IF @@ROWCOUNT = 0
		BEGIN
			SELECT @LinesInDB = 0
			
			INSERT #InvoiceLines (InvoiceKey, LineKey, Closed, LinesInDB, AdvBillAmount, AlreadyReceived, AlreadyReversed, ToApply)
			SELECT @InvoiceKey, TempTranLineKey, 0, 0, ISNULL(AdvBillAmount, 0), 0, 0, 0
			FROM   #tCashTransactionLine
			WHERE  Entity = 'INVOICE'
			AND    EntityKey = @InvoiceKey
		END 
	
		-- PROBLEM THE ADB BILL AMOUNT IS FOR ALL ADV BILLS
		-- need to isolate this one AB
		IF @LinesInDB = 1
			UPDATE #InvoiceLines
			SET    #InvoiceLines.AdvBillAmount = iabs.Amount
			FROM   tInvoiceAdvanceBillSale iabs (NOLOCK)
			WHERE  #InvoiceLines.InvoiceKey = iabs.InvoiceKey
			AND    #InvoiceLines.LineKey = iabs.CashTransactionLineKey
			AND    iabs.AdvBillInvoiceKey = @AdvBillInvoiceKey
		ELSE
			UPDATE #InvoiceLines
			SET    #InvoiceLines.AdvBillAmount = iabs.Amount
			FROM   #tInvoiceAdvanceBillSale iabs (NOLOCK)
			WHERE  #InvoiceLines.InvoiceKey = iabs.InvoiceKey
			AND    #InvoiceLines.LineKey = iabs.TempTranLineKey
			AND    iabs.AdvBillInvoiceKey = @AdvBillInvoiceKey
		
 	END		
 	
 	UPDATE #InvoiceLines SET AdvBillAmount = ISNULL(AdvBillAmount, 0)
	
	
	-- Get the receipts already applied against each invoice, thru the AB 
	UPDATE #InvoiceLines
	SET    #InvoiceLines.AlreadyReceived = #InvoiceLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'RECEIPT'
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.AEntity2 = 'INVOICE'
		AND    ct.AEntity2Key = #InvoiceLines.InvoiceKey
		AND    ct.CashTransactionLineKey = #InvoiceLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0	
		),0)

	-- Add the AB reversals when posting the real invoices
	UPDATE #InvoiceLines
	SET    #InvoiceLines.AlreadyReversed = #InvoiceLines.AlreadyReversed + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.EntityKey = #InvoiceLines.InvoiceKey
		AND    ct.AEntity = 'INVOICE'
		AND    ct.AEntityKey = @AdvBillInvoiceKey
		AND    ct.CashTransactionLineKey = #InvoiceLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
		),0)
	
	-- and check the temp table
	UPDATE #InvoiceLines
	SET    #InvoiceLines.AlreadyReceived = #InvoiceLines.AlreadyReceived + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'RECEIPT'
		AND    AEntity = 'INVOICE'
		AND    AEntityKey = @AdvBillInvoiceKey
		AND    AEntity2 = 'INVOICE'
		AND    AEntity2Key = #InvoiceLines.InvoiceKey
		AND    CashTransactionLineKey = #InvoiceLines.LineKey
		),0)

	UPDATE #InvoiceLines
	SET    #InvoiceLines.AlreadyReversed = #InvoiceLines.AlreadyReversed + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = #InvoiceLines.InvoiceKey
		AND    AEntity = 'INVOICE'
		AND    AEntityKey = @AdvBillInvoiceKey
		AND    CashTransactionLineKey = #InvoiceLines.LineKey
		),0)

	--select * from #InvoiceLines

    DECLARE @ABAlreadyReceived money 
    DECLARE @InvoiceAlreadyReceived money 
    DECLARE @ABAlreadyReversed money 
    DECLARE @InvoiceAlreadyReversed money 
    
	SELECT  @ABAlreadyReceived = ISNULL((
		SELECT SUM(AlreadyReceived)
		FROM   #ABLines
	),0)
	
	SELECT  @InvoiceAlreadyReceived = ISNULL((
		SELECT SUM(AlreadyReceived)
		FROM   #InvoiceLines
	),0)
	

	SELECT  @ABAlreadyReversed = ISNULL((
		SELECT SUM(AlreadyReversed)
		FROM   #ABLines
	),0)
	
	SELECT  @InvoiceAlreadyReversed = ISNULL((
		SELECT SUM(AlreadyReversed)
		FROM   #InvoiceLines
	),0)
	
	IF @ApplyAmount > 0
	BEGIN
		--we will apply only if AlreadyApplied < NonTaxAmount 
		UPDATE #InvoiceLines
		SET    Closed = 1
		WHERE  AlreadyReceived + AlreadyReversed >= AdvBillAmount
	
		SELECT @ToApplyOnInvoices = SUM(AdvBillAmount - AlreadyReceived - AlreadyReversed)
		FROM   #InvoiceLines
		WHERE  Closed = 0
		SELECT @ToApplyOnInvoices = ISNULL(@ToApplyOnInvoices, 0)	

		--select * from #InvoiceLines
			
		IF (SELECT COUNT(*) FROM #InvoiceLines WHERE Closed = 0) > 0 AND @ToApplyOnInvoices > 0 
		BEGIN
			IF @ApplyAmount >= @ToApplyOnInvoices
				SELECT @IsLastInvoicesApplication = 1, @InvoicesApplyAmount = @ToApplyOnInvoices
			ELSE
				SELECT @IsLastInvoicesApplication = 0, @InvoicesApplyAmount = @ApplyAmount
			
			-- Enter the lines for the real invoices
			TRUNCATE TABLE #tApply
			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT LineID, AdvBillAmount - AlreadyReceived - AlreadyReversed, 0
			FROM  #InvoiceLines
			WHERE Closed = 0

			EXEC sptCashApplyToLines @ToApplyOnInvoices, @InvoicesApplyAmount, @InvoicesApplyAmount, @IsLastInvoicesApplication	
 			
 			UPDATE #InvoiceLines
 			SET    #InvoiceLines.ToApply = b.ToApply
 			FROM   #tApply b
 			WHERE  #InvoiceLines.LineID = b.LineKey 
 			
 			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
			)
			
			SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,lines.ToApply,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', ctl.EntityKey, Reference, 0, Credit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
				INNER JOIN #InvoiceLines lines ON ctl.EntityKey = lines.InvoiceKey
				AND ctl.CashTransactionLineKey = lines.LineKey
			WHERE ctl.Entity = 'INVOICE' 
			AND   lines.Closed = 0
 			AND   lines.LinesInDB = 1

 			
 			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)
			
			SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,lines.ToApply,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', ctl.EntityKey, Reference, 0, Credit, ctl.TempTranLineKey, 1
			
			FROM #tTransaction ctl (NOLOCK)
				INNER JOIN #InvoiceLines lines ON ctl.EntityKey = lines.InvoiceKey
				AND ctl.TempTranLineKey = lines.LineKey
			WHERE ctl.Entity = 'INVOICE' 
			AND   lines.Closed = 0
 			AND   lines.LinesInDB = 0
 			
			--select * from #tCashTransaction 
		END		 
		ELSE
			SELECT @InvoicesApplyAmount = 0
			
		SELECT @ABApplyAmount = @ApplyAmount - @InvoicesApplyAmount
	
		--select @ABApplyAmount, @IsLastABApplication
		--SELECT @ReceiptImpactOnTaxes, @ApplyAmount, @InvoicesApplyAmount, @ABApplyAmount, @IsLastInvoicesApplication, @IsLastABApplication
		
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
					
			END
			
			SELECT @IsLastABApplication = 0
			--IF @ABAlreadyReceived + @ApplyAmount + @InvoiceAlreadyReceived = @ABInvoiceTotalAmount
			-- Tried this but causes problem when AB->I->R, R is applied against AB and I
			-- We would have to calc the impact of a receipt against I for the lines on the AB
			-- same scenario as Credit memos against invoices where we cannot fully relieve an invoice with CM
			IF @ABAlreadyReceived + @ABApplyAmount = @ABInvoiceTotalAmount
				SELECT @IsLastABApplication = 1 
				
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT LineKey, LineAmount, AlreadyReceived
 			FROM #ABLines
 			
			EXEC sptCashApplyToLines @ABInvoiceTotalAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
 			
 			--select * from #ABLines
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
		
	--select * from #ABLines
	--select * from #InvoiceLines
	
	/*
	@ApplyAmount < 0 tested with
	
	AB 4000 (line 1) 6000 (line 2) 1000 taxes 4/14/2009
	I1 2000 (line 1) 200 taxes 4/15/2009
	R1 5000 4/16/2009
	I2 2500 (line 1)
	R2 = R1 VOID 4/18/2009
	R3 11000 4/19/2009 
	
	Also tested with R2 = R1 void on same day 4/16/2009
	*/	
		
	IF @ApplyAmount < 0
	BEGIN
	
		-- strategy here is to apply against AB if receipts have been already applied (- reversed)
		-- then if there is something left, apply against the invoices, do not drive the invoices negative
		-- (actually they may not exist yet)
		-- then if there is something left, apply against the AB, i.e. we drive the AB negative  
		
		-- Calculate @ABApplyAmount
		
		SELECT @ABApplyAmount = @ABAlreadyReceived - @ABAlreadyReversed 
		
		
		SELECT @InvoicesApplyAmount = 0
		
		IF @ABApplyAmount > 0
		BEGIN
			-- limit to the apply amount in absolute value
			-- i.e. if ApplyAmount = -5,000 and ABApplyAmount = 10,000, limit to 5,000
			IF @ABApplyAmount > ABS(@ApplyAmount)
				SELECT @ABApplyAmount = ABS(@ApplyAmount)	
		
			SELECT @InvoicesApplyAmount = ABS(@ApplyAmount) - @ABApplyAmount
			
		END 
		
		IF @InvoicesApplyAmount > 0
		BEGIN
			-- try to apply the receipt against the invoice lines 
		
			-- we will only apply if AlreadyReceived - AlreadyReversed > 0
			UPDATE #InvoiceLines
			SET    Closed = 1
			WHERE  AlreadyReceived + AlreadyReversed <= 0
			
			SELECT @ToApplyOnInvoices = SUM(AlreadyReceived + AlreadyReversed)
			FROM   #InvoiceLines
			WHERE  Closed = 0
			SELECT @ToApplyOnInvoices = ISNULL(@ToApplyOnInvoices, 0)	
				
			IF (SELECT COUNT(*) FROM #InvoiceLines WHERE Closed = 0) > 0 AND @ToApplyOnInvoices > 0 
				BEGIN
					-- for now, we deal with positive numbers only
					IF @InvoicesApplyAmount >= @ToApplyOnInvoices
						SELECT @InvoicesApplyAmount = @ToApplyOnInvoices
					
					SELECT @IsLastInvoicesApplication = 0
						
						
					-- Enter the lines for the real invoices
					TRUNCATE TABLE #tApply
					INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
					SELECT LineID, AlreadyReceived + AlreadyReversed, 0
					FROM  #InvoiceLines
					WHERE Closed = 0

					EXEC sptCashApplyToLines @ToApplyOnInvoices, @InvoicesApplyAmount, @InvoicesApplyAmount, @IsLastInvoicesApplication	
				
					-- now take negative amounts to apply
					UPDATE #InvoiceLines
 					SET    #InvoiceLines.ToApply = -1 * b.ToApply
 					FROM   #tApply b
 					WHERE  #InvoiceLines.LineID = b.LineKey 
				
					
					INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
					)
					
					SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,lines.ToApply,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', ctl.EntityKey, Reference, 0, Credit, ctl.CashTransactionLineKey
					
					FROM tCashTransactionLine ctl (NOLOCK)
						INNER JOIN #InvoiceLines lines ON ctl.EntityKey = lines.InvoiceKey
						AND ctl.CashTransactionLineKey = lines.LineKey
					WHERE ctl.Entity = 'INVOICE' 
					AND   lines.Closed = 0
 					AND   lines.LinesInDB = 1

		 			
 					INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
					)
					
					SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,lines.ToApply,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, 'INVOICE', ctl.EntityKey, Reference, 0, Credit, ctl.TempTranLineKey, 1
					
					FROM #tTransaction ctl (NOLOCK)
						INNER JOIN #InvoiceLines lines ON ctl.EntityKey = lines.InvoiceKey
						AND ctl.TempTranLineKey = lines.LineKey
					WHERE ctl.Entity = 'INVOICE' 
					AND   lines.Closed = 0
 					AND   lines.LinesInDB = 0
					
			END			
			
		END
		
		-- Recalc the amount to apply against AB				
		SELECT @ABApplyAmount = ABS(@ApplyAmount) - @InvoicesApplyAmount
		
		IF @ABApplyAmount > 0
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
					
			END
			
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT LineKey, LineAmount, 0
 			FROM   #ABLines (NOLOCK)		
										
			SELECT @IsLastABApplication = 0
											 
 			EXEC sptCashApplyToLines @ABInvoiceTotalAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
 			
 			--select * from #tApply
 			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.Credit = -1 * app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			AND    #tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
		
		
		END					
	
				
	END -- negative sales amount
				
		
		
		
		
	RETURN 1
GO
