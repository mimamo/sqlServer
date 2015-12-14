USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCheckFillInvoice]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCheckFillInvoice]
	(
	@CompanyKey INT
	,@InvoiceKey INT 
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
		
-- Register all constants
DECLARE @kErrNotApproved INT					SELECT @kErrNotApproved = -1
DECLARE @kErrInvalidARAcct INT					SELECT @kErrInvalidARAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -2
DECLARE @kErrInvalidAdvBillAcct INT				SELECT @kErrInvalidAdvBillAcct = -3
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -4
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -5
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -6
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -7
DECLARE @kErrInvalidOUAcct INT					SELECT @kErrInvalidOUAcct = -8
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -9
DECLARE @kErrInvalidSalesTax3Acct INT			SELECT @kErrInvalidSalesTax3Acct = -10
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -11
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -12

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Invoice # '
DECLARE @kMemoAdvBill VARCHAR(100)				SELECT @kMemoAdvBill = 'Advance Billing for Invoice # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Invoice # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Invoice # '
DECLARE @kMemoSalesTax3 VARCHAR(100)			SELECT @kMemoSalesTax3 = 'Sales Tax for Invoice # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Prepayment Reversal Check # '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Invoice # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Invoice # '

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5

DECLARE @kLineNoTransactions int				SELECT @kLineNoTransactions = 1
DECLARE @kLineUseTransactions int				SELECT @kLineUseTransactions = 2
DECLARE @kLineTypeDetail int					SELECT @kLineTypeDetail = 2

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
Declare @CheckPostingDate datetime

-- Vars for invoice info
DECLARE @InvoiceStatus int
		,@ARAccountKey int
		,@Amount money
		,@InvoiceTotalAmount money
		,@SalesTaxKey int
		,@SalesTaxAccountKey int
		,@SalesTaxAmount money
		,@SalesTax2Key int
		,@SalesTax2AccountKey int
		,@SalesTax2Amount money
		,@AdvBillAmount money
		,@AdvBillTaxAmount money
		,@AdvBillNoTaxAmount money
		,@InvoiceNumber varchar(100)
		,@Posted tinyint
		,@ParentInvoiceKey int
		,@ParentInvoice tinyint
		,@PercentageSplit decimal(24,4)
		,@Percent decimal (20,8)
		,@LineInvoiceKey int -- This is the invoice where to get the lines from (the parent invoice)
		,@HeaderOfficeKey int
		,@OpeningTransaction tinyint
		,@TotalNonTaxAmount money 
	
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
		@InvoiceTotalAmount = InvoiceTotalAmount
		,@TotalNonTaxAmount = TotalNonTaxAmount
		,@InvoiceStatus = InvoiceStatus
		,@TransactionDate = ISNULL(PostingDate, InvoiceDate)
		,@ARAccountKey = ARAccountKey
		,@Amount = BilledAmount
		,@AdvBillAmount = ISNULL(RetainerAmount, 0)
		,@SalesTaxKey = SalesTaxKey
		,@SalesTaxAmount = ISNULL(SalesTax1Amount, 0)
		,@SalesTax2Key = SalesTax2Key
		,@SalesTax2Amount = ISNULL(SalesTax2Amount, 0)
		,@ClassKey = ClassKey
		,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
		,@ProjectKey = NULL
		,@ClientKey = ClientKey
		,@Posted = Posted
		,@ParentInvoice = ISNULL(ParentInvoice, 0)
		,@ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0)
		,@PercentageSplit = ISNULL(PercentageSplit, 0)
		,@LineInvoiceKey = InvoiceKey -- By default, we get the lines from this invoice
		,@GLCompanyKey = GLCompanyKey
		,@HeaderOfficeKey = OfficeKey
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	From vInvoice (nolock)
	Where InvoiceKey = @InvoiceKey


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
		)	

	DECLARE @LinesInDB int -- works here to have that flag since we only have one invoice
	SELECT @LinesInDB = 1
	
	INSERT #LineAmount (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
	SELECT CashTransactionLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
	FROM   tCashTransactionLine (NOLOCK)
	WHERE  Entity = 'INVOICE'
	AND    EntityKey = @InvoiceKey
	
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @LinesInDB = 0
			
		INSERT #LineAmount (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
		SELECT TempTranLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
		FROM   #tCashTransactionLine
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @InvoiceKey
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
		AND    ct.AEntityKey = @InvoiceKey
		AND    ct.CashTransactionLineKey = #LineAmount.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'RECEIPT'
		--AND    tCashTransaction.EntityKey = @CheckKey
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @InvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = #LineAmount.LineKey
	),0)
					
	-- Add the receipts posted before this invoice but not considered as PREPAYMENTS
	-- these have AEntityKey = 0, Prepayments have AEntityKey = -1
	-- they were REVERSALS when posting the invoice
	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(ct.Credit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'INVOICE'
		AND    ct.EntityKey = @InvoiceKey
		AND    ct.AEntity = 'RECEIPT'
		AND    ct.AEntityKey = 0
		AND    ct.CashTransactionLineKey = #LineAmount.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #LineAmount
	SET    #LineAmount.AlreadyApplied = #LineAmount.AlreadyApplied + ISNULL((
		SELECT SUM(Credit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.EntityKey = @InvoiceKey
		AND    #tCashTransaction.AEntity = 'RECEIPT'
		AND    #tCashTransaction.AEntityKey = 0
		AND    #tCashTransaction.CashTransactionLineKey = #LineAmount.LineKey
	),0)
	
	
	DECLARE @ReceiptAmount MONEY
	DECLARE @AlreadyApplied MONEY
	DECLARE @IsLastApplication INT
	
	SELECT @ReceiptAmount = SUM(ReceiptAmount)
	FROM   #LineAmount

	SELECT @AlreadyApplied = SUM(AlreadyApplied)
	FROM   #LineAmount

	SELECT @ReceiptAmount = ISNULL(@ReceiptAmount, 0)
		  ,@AlreadyApplied = ISNULL(@AlreadyApplied, 0)
	
	-- determine whether this is the last application
	IF @ApplyAmount + @AlreadyApplied = @ReceiptAmount
		SELECT @IsLastApplication = 1
	ELSE
		SELECT @IsLastApplication = 0
		
	IF @IsLastApplication = 1
	BEGIN
		UPDATE #LineAmount
		SET    ToApply = ReceiptAmount - AlreadyApplied		
	END
	ELSE
	BEGIN
		-- Apply a simple proportion based on ReceiptAmount
		TRUNCATE TABLE #tApply
		
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT LineKey, ReceiptAmount, 0
	    FROM   #LineAmount 
	     		 
		EXEC sptCashApplyToLines @ReceiptAmount, @ApplyAmount, @ApplyAmount		  

		UPDATE #LineAmount
		SET    #LineAmount.ToApply = #tApply.ToApply 
		FROM   #tApply
		WHERE  #LineAmount.LineKey = #tApply.LineKey
		
	END	
	
	-- now create the #tCashTransaction lines
	
	IF @LinesInDB = 1
		
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
			, 'INVOICE', @InvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
			AND   [Section] IN (2, 5) -- lines and taxes

	ELSE
		-- Be careful because we could be in the process of posting the invoice to accrual
		-- And the records are missing from tCashTransactionLine 
		
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2,  AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)
			
			SELECT CompanyKey,@CheckPostingDate,'RECEIPT',@CheckKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'INVOICE', @InvoiceKey, Reference, NULL, NULL, NULL, 0, Credit, ctl.TempTranLineKey, 1
			
			FROM #tTransaction ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
			AND   [Section] IN( 2, 5) -- lines only
				

	UPDATE #tCashTransaction
	SET    #tCashTransaction.Credit = #LineAmount.ToApply
	FROM   #LineAmount 
	WHERE  #tCashTransaction.CashTransactionLineKey = #LineAmount.LineKey 
	AND    #tCashTransaction.Entity = 'RECEIPT'
	AND    #tCashTransaction.EntityKey = @CheckKey
	AND    #tCashTransaction.AEntity = 'INVOICE'
	AND    #tCashTransaction.AEntityKey = @InvoiceKey
	
	
										
	RETURN 1
GO
