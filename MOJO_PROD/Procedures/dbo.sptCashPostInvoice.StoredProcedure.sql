USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostInvoice]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostInvoice]
	(
		@CompanyKey int
		,@InvoiceKey int
		,@CreateTemp int = 0	-- Can be used for testing	
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 07/03/12 GHL 10.557 Added call to spGLPostICTCreateDTDF for Inter Company Transactions
|| 07/03/12 GHL 10.557 Added tCashTransaction.ICTGLCompanyKey
|| 08/05/13 GHL 10.571 Added Multi Currency stuff

*/
	SET NOCOUNT ON

IF @CreateTemp = 1
	BEGIN
	
		-- This table will track of which cash basis transactions are not valid anymore
		-- Just to get the same Entity's collation
		SELECT Entity, EntityKey, 1 AS Unpost INTO #tCashTransactionUnpost 
		FROM tCashTransaction (NOLOCK) WHERE 1 = 2 


		CREATE TABLE #tCashTransaction (
			UIDCashTransactionKey uniqueidentifier null,
			
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL, 
			ICTGLCompanyKey int null,

			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			-- Application fields
			AEntity varchar (50) NULL ,
			AEntityKey int NULL ,
			AReference varchar (100) NULL ,
			AEntity2 varchar (50) NULL ,
			AEntity2Key int NULL ,
			AReference2 varchar (100) NULL ,
			AAmount MONEY NULL,
			LineAmount MONEY NULL,
			CashTransactionLineKey INT NULL

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,UpdateTranLineKey int null
			)	 
	END		
			


-- Register all constants
DECLARE @kErrNotApproved INT					SELECT @kErrNotApproved = -1
DECLARE @kErrInvalidARAcct INT					SELECT @kErrInvalidARAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -3
DECLARE @kErrInvalidAdvBillAcct INT				SELECT @kErrInvalidAdvBillAcct = -4
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -5
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -6
DECLARE @kErrInvalidSalesTax3Acct INT			SELECT @kErrInvalidSalesTax3Acct = -7
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -8
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -9
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -10
DECLARE @kErrInvalidOUAcct INT					SELECT @kErrInvalidOUAcct = -11
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -12
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -13

DECLARE @kErrInvalidRoundingDiffAcct int		SELECT @kErrInvalidRoundingDiffAcct = -350
DECLARE @kErrInvalidRealizedGainAcct int		SELECT @kErrInvalidRealizedGainAcct = -351

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
DECLARE @kMemoPrepayments2 VARCHAR(100)			SELECT @kMemoPrepayments2 = 'Payment Reversal Check # '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Invoice # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Invoice # '
DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '
DECLARE @kMemoMCRounding VARCHAR(100)			SELECT @kMemoMCRounding = 'Multi Currency Rounding Diff '

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionICT int						SELECT @kSectionICT = 8
DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

DECLARE @kLineNoTransactions int				SELECT @kLineNoTransactions = 1
DECLARE @kLineUseTransactions int				SELECT @kLineUseTransactions = 2
DECLARE @kLineTypeDetail int					SELECT @kLineTypeDetail = 2

-- Vars for tPref
DECLARE @PostToGL tinyint
		,@GLClosedDate smalldatetime
		,@TrackOverUnder tinyint
		,@AccrueCostToItemExpenseAccount tinyint
		,@LaborOUAccountKey int
		,@ExpenseOUAccountKey int
		,@POAccruedExpenseAccountKey int
		,@POPrebillAccrualAccountKey int
		,@AdvBillAccountKey int
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  

-- Vars for invoice info
DECLARE @InvoiceStatus int
		,@ARAccountKey int
		,@Amount money
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
		,@InvoiceNonTaxAmount money
		,@AdvanceBill int
		,@InvoiceTotalAmount money
		,@CurrencyID varchar(10)
		,@ExchangeRate decimal(24,7)	
			
-- Other vars for GL tran
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

	Select
		 @GLClosedDate = GLClosedDate
		,@PostToGL = ISNULL(PostToGL, 0)
		,@TrackOverUnder = ISNULL(TrackOverUnder, 0)
		,@AccrueCostToItemExpenseAccount = ISNULL(AccrueCostToItemExpenseAccount, 0)
		,@LaborOUAccountKey = LaborOverUnderAccountKey
		,@ExpenseOUAccountKey = ExpenseOverUnderAccountKey
		,@POAccruedExpenseAccountKey = POAccruedExpenseAccountKey
		,@POPrebillAccrualAccountKey = POPrebillAccrualAccountKey
		,@AdvBillAccountKey = AdvBillAccountKey
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey  

	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
	
	Select 
		@InvoiceStatus = InvoiceStatus
		,@TransactionDate = dbo.fFormatDateNoTime(ISNULL(PostingDate, InvoiceDate))
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
		,@InvoiceNonTaxAmount = ISNULL(TotalNonTaxAmount, 0)
		,@AdvanceBill = AdvanceBill
		,@InvoiceTotalAmount = ISNULL(InvoiceTotalAmount, 0)
		,@CurrencyID = CurrencyID
		,@ExchangeRate = isnull(ExchangeRate, 1)
	From vInvoice (nolock)
	Where InvoiceKey = @InvoiceKey

		-- These should not change
	Select	@Entity = 'INVOICE'
			,@EntityKey = @InvoiceKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @ClientKey			
			,@DepositKey = NULL 
	
	/*
	
	All these postings should be reversals:
	
	1) reversals of prepayments
	2) reversals of receipts posted before this invoice
	3) reversals of adv billings
	
	*/
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
	
	-- since I do not know whether the lines are in permanent tables or not, capture the lines here  
	CREATE TABLE #InvoiceLines(LineKey int null, Section int null
		, LineAmount money null, AlreadyApplied money null, ToApply money null
		, AdvBillAmount money null, PrepaymentAmount money null, ReceiptAmount money null) 

	DECLARE @LinesInDB int

	SELECT @LinesInDB = 0
		
	INSERT #InvoiceLines (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
	SELECT TempTranLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
	FROM   #tCashTransactionLine
	WHERE  Entity = 'INVOICE'
	AND    EntityKey = @InvoiceKey
		
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @LinesInDB = 1

		INSERT #InvoiceLines (LineKey, Section, LineAmount, AlreadyApplied, AdvBillAmount, PrepaymentAmount, ReceiptAmount)
		SELECT CashTransactionLineKey, Section, Credit, 0, AdvBillAmount, PrepaymentAmount, ReceiptAmount
		FROM   tCashTransactionLine (NOLOCK)
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @InvoiceKey
	END 
	
	/*	
	get a list of transaction lines
	*/
	
	SELECT * INTO #tCashTransactionLines FROM #tCashTransaction WHERE 1 = 2 
	
	IF @LinesInDB = 1
	
		-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
		INSERT #tCashTransactionLines(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,'INVOICE',@InvoiceKey,Reference,GLAccountKey,0,0,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, NULL, NULL, NULL, NULL,NULL, NULL, 0, Credit, CashTransactionLineKey, 0
		
		FROM tCashTransactionLine ctl (NOLOCK)
		WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
		AND   [Section] in ( 2, 5) -- lines + taxes only
		
	ELSE
	
	-- if not posted yet, must be in the #tTransaction
		
		INSERT #tCashTransactionLines(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,'INVOICE',@InvoiceKey,Reference,GLAccountKey,0,0,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, NULL, NULL, NULL, NULL, NULL, NULL, 0, Credit, TempTranLineKey, 1
		
		FROM #tTransaction ctl
		WHERE Entity = 'INVOICE' AND EntityKey = @InvoiceKey
		AND   [Section] in ( 2, 5) -- lines + taxes only
	

/*
Prepayment section
*/

	SELECT @PostSide = 'D' ,@GLAccountErrRet = @kErrInvalidARAcct 
			,@Memo = @kMemoPrepayments , @Section = @kSectionPrepayments   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL


	-- First the REAL Prepayments which are not time sensitive
	-- Debit the Unapplied Account or Prepayment
	-- Prepayments cannot be unposted on the UI so we do not have to check the posting status

    -- One entry per payment applied
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		c.PrepayAccountKey, ca.Amount, 0,
		c.ClassKey,  @Memo + c.ReferenceNumber ,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(ca.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else ca.TargetGLCompanyKey end
		
		,@OfficeKey,@DepartmentKey,ca.CheckApplKey,@Section,@GLAccountErrRet, 1

		-- specific to cash
		, 'RECEIPT', c.CheckKey, c.ReferenceNumber, NULL, NULL, NULL, 0, 0, 0, 0
	From   tCheckAppl ca (nolock)
		Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
	Where	ca.InvoiceKey = @InvoiceKey
	And		ca.Prepay = 1
		
	DECLARE @Prepayments MONEY
	SELECT @Prepayments = SUM(Debit)
	FROM   #tCashTransaction
	WHERE  #tCashTransaction.Entity = 'INVOICE'
	AND    #tCashTransaction.EntityKey = @InvoiceKey
	AND    #tCashTransaction.[Section] =@kSectionPrepayments

	SELECT @Prepayments = ISNULL(@Prepayments, 0)
	
	IF @Prepayments <> 0
	BEGIN
		 
		-- Credit the Sales and Taxes
		-- the prepayment amounts should already been in #InvoiceLines
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,GPFlag, Section 
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,'INVOICE',@InvoiceKey,Reference,GLAccountKey
		,0,#InvoiceLines.PrepaymentAmount,ClassKey,
		'Prepayment for Invoice # '+@Reference ,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,0, #tCashTransactionLines.Section -- Use section = 2 or 5, sales or taxes to capture rounding errors later
		
		-- specific to cash, cannot specify which prepayment because we lump all prepayments per line
		-- but specify AEntityKey = -1 to distinguish from receipts below 
		, 'RECEIPT', -1, NULL, NULL, NULL, NULL, 0, 0, CashTransactionLineKey, UpdateTranLineKey
		
		FROM #tCashTransactionLines 
			INNER JOIN #InvoiceLines ON #tCashTransactionLines.CashTransactionLineKey = #InvoiceLines.LineKey
		
		--select * from #tCashTransaction
		
	END	


	-- Then add the posted payments which have a posting date BEFORE this invoice
	-- they are similar to prepayments but we reverse the AR account instead of the prepayment account
	-- the difference is that we do not know if they are posted or not
	-- Set AEntityKey = 0 to diff with REAL PREPAYMENTS
	
		SELECT @PostSide = 'D' ,@GLAccountErrRet = @kErrInvalidARAcct 
			,@Memo = @kMemoPrepayments2 , @Section = @kSectionPrepayments   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	DECLARE @CheckKey INT
	DECLARE @CheckApplKey INT
	DECLARE @ApplyAmount MONEY
	DECLARE @TotalApplyAmount MONEY
	DECLARE @CheckPosted INT 
	DECLARE @IsLastApplication INT
	DECLARE @ReceiptAmount MONEY
	DECLARE @AlreadyApplied MONEY

	SELECT @TotalApplyAmount = 0
	SELECT @CheckKey = -1
	WHILE (1=1)
	BEGIN
		-- Must be posted, but we cannot blindly trust c.Posted
		-- because we could be in the process of posting the check in the cash queue
		SELECT @CheckKey = MIN(ca.CheckKey)
		From   tCheckAppl ca (nolock)
			Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey	
			Left Outer Join #tCashQueue cq ON cq.Entity = 'RECEIPT' AND cq.EntityKey = ca.CheckKey		
		Where	ca.InvoiceKey = @InvoiceKey
		And		ca.Prepay = 0
		And     c.PostingDate < @TransactionDate
		And    (c.Posted = 1
				-- Or we are in the process of posting it to Accrual
				OR ca.CheckKey IN (SELECT EntityKey FROM #tCashQueue 
							WHERE Entity = 'RECEIPT' AND PostingOrder = 1 AND Action = 0) 
				)		
		And    ca.CheckKey > @CheckKey
		-- And we are not in the process of unposting it from Accrual
		AND	ca.CheckKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'RECEIPT' AND PostingOrder = 1 AND Action=1)
		
		
		If @CheckKey is null
			break	
		
		SELECT @CheckApplKey = ca.CheckApplKey
				,@ApplyAmount = ca.Amount
		FROM   tCheckAppl ca (nolock)
		WHERE  ca.InvoiceKey = @InvoiceKey
		AND    ca.CheckKey = @CheckKey
		
		SELECT @TotalApplyAmount = @TotalApplyAmount + @ApplyAmount
					
		-- One entry per payment applied			
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)

        SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@ARAccountKey, ca.Amount, 0,
		c.ClassKey,  @Memo + c.ReferenceNumber ,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(ca.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else ca.TargetGLCompanyKey end

		,@OfficeKey,@DepartmentKey,ca.CheckApplKey,@Section,@GLAccountErrRet, 0

		-- specific to cash
		, 'RECEIPT', @CheckKey, c.ReferenceNumber, NULL, NULL, 0, 0, 0, 0
		From   tCheckAppl ca (nolock)
		Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
		Where	ca.CheckApplKey = @CheckApplKey
	
		
	END	
	
	IF @TotalApplyAmount <> 0
	BEGIN
		-- Amounts already applied on receipts
		UPDATE #InvoiceLines
		SET    #InvoiceLines.AlreadyApplied = #InvoiceLines.AlreadyApplied + ISNULL((
			SELECT SUM(ct.Credit)
			FROM   tCashTransaction ct (NOLOCK)
				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
			WHERE  ct.Entity = 'RECEIPT'
			--AND    ct.EntityKey = @CheckKey
			AND    ct.AEntity = 'INVOICE'
			AND    ct.AEntityKey = @InvoiceKey
			AND    ct.CashTransactionLineKey = #InvoiceLines.LineKey
			AND    ISNULL(ctu.Unpost, 0) = 0
		),0)

		UPDATE #InvoiceLines
		SET    #InvoiceLines.AlreadyApplied = #InvoiceLines.AlreadyApplied + ISNULL((
			SELECT SUM(Credit)
			FROM   #tCashTransaction 
			WHERE  #tCashTransaction.Entity = 'RECEIPT'
			--AND    tCashTransaction.EntityKey = @CheckKey
			AND    #tCashTransaction.AEntity = 'INVOICE'
			AND    #tCashTransaction.AEntityKey = @InvoiceKey
			AND    #tCashTransaction.CashTransactionLineKey = #InvoiceLines.LineKey
		),0)
					
					
						
		-- Add the receipts posted before this invoice but not considered as PREPAYMENTS
		-- these have AEntityKey = 0, Prepayments have AEntityKey = -1
		-- they were REVERSALS when posting the invoice
		UPDATE #InvoiceLines
		SET    #InvoiceLines.AlreadyApplied = #InvoiceLines.AlreadyApplied + ISNULL((
			SELECT SUM(ct.Credit)
			FROM   tCashTransaction ct (NOLOCK)
				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
			WHERE  ct.Entity = 'INVOICE'
			AND    ct.EntityKey = @InvoiceKey
			AND    ct.AEntity = 'RECEIPT'
			AND    ct.AEntityKey = 0
			AND    ct.CashTransactionLineKey = #InvoiceLines.LineKey
			AND    ISNULL(ctu.Unpost, 0) = 0
		),0)

		UPDATE #InvoiceLines
		SET    #InvoiceLines.AlreadyApplied = #InvoiceLines.AlreadyApplied + ISNULL((
			SELECT SUM(Credit)
			FROM   #tCashTransaction 
			WHERE  #tCashTransaction.Entity = 'INVOICE'
			AND    #tCashTransaction.EntityKey = @InvoiceKey
			AND    #tCashTransaction.AEntity = 'RECEIPT'
			AND    #tCashTransaction.AEntityKey = 0
			AND    #tCashTransaction.CashTransactionLineKey = #InvoiceLines.LineKey
		),0)

				
		SELECT @ReceiptAmount = SUM(ReceiptAmount)
		FROM   #InvoiceLines

		SELECT @AlreadyApplied = SUM(AlreadyApplied)
		FROM   #InvoiceLines

		SELECT @ReceiptAmount = ISNULL(@ReceiptAmount, 0)
			  ,@AlreadyApplied = ISNULL(@AlreadyApplied, 0)
		
		-- determine whether this is the last application
		IF @TotalApplyAmount + @AlreadyApplied = @ReceiptAmount
			SELECT @IsLastApplication = 1
		ELSE
			SELECT @IsLastApplication = 0
			
		
		IF @IsLastApplication = 1
		BEGIN
			UPDATE #InvoiceLines
			SET    ToApply = ReceiptAmount - AlreadyApplied		
		END
		ELSE
		BEGIN
			-- Apply a simple proportion based on ReceiptAmount
			TRUNCATE TABLE #tApply
			
			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT LineKey, ReceiptAmount, 0
			FROM   #InvoiceLines 
		     		 
			EXEC sptCashApplyToLines @ReceiptAmount, @TotalApplyAmount, @TotalApplyAmount		  

			UPDATE #InvoiceLines
			SET    #InvoiceLines.ToApply = #tApply.ToApply 
			FROM   #tApply
			WHERE  #InvoiceLines.LineKey = #tApply.LineKey
			
		END	
			
		-- Credit the Sales and Taxes
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,GPFlag, Section 
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,'INVOICE',@InvoiceKey,Reference,GLAccountKey
		,0,#InvoiceLines.ToApply,ClassKey,
		'Payment for Invoice # '+@Reference ,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,0, #tCashTransactionLines.Section -- Use section = 2 or 5, sales or taxes to capture rounding errors later
		
		-- specific to cash, cannot specify which prepayment because we lump all prepayments per line
		-- but specify AEntityKey = 0 to distinguish from prepayments above 
		, 'RECEIPT', 0, NULL, NULL, NULL, NULL, 0, 0, CashTransactionLineKey, UpdateTranLineKey
		
		FROM #tCashTransactionLines 
			INNER JOIN #InvoiceLines ON #tCashTransactionLines.CashTransactionLineKey = #InvoiceLines.LineKey
			
	--select * from #tCashTransaction
		
	END	
	 
	-- Now process the Realized Gain/Loss for the prepayments
	-- One entry per application
	if @MultiCurrency = 1
	begin
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + ' Check # ' + c.ReferenceNumber ,@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,ca.CheckApplKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(ca.Amount * (isnull(c.ExchangeRate, 1) - @ExchangeRate), 2)
		From   tCheckAppl ca (nolock)
			Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
		-- do not check prepay = 1 here because we have the real prepayments and where check Posting Date before inv Posting Date  
		Where	ca.CheckApplKey in (
			select DetailLineKey from #tCashTransaction 
			where Entity = @Entity
			and   EntityKey = @EntityKey
			and   AEntity = 'RECEIPT'
			and   AEntityKey > 0 -- valid receipt
		)
		and Round(ca.Amount * (isnull(c.ExchangeRate, 1) - @ExchangeRate), 2) <> 0	

	end

	
			
/*
Advance Bill Section
*/
				
	CREATE TABLE #ABLines(LineKey int null, Section int null, LineAmount money null
	, AlreadyReceived money null, AlreadyReversed money null, ToApply money null) 
								
	DECLARE @AdvBillInvoiceKey INT
	DECLARE @ABReverseAmount MONEY
	DECLARE @ABInvoiceNumber VARCHAR(50)
	DECLARE @ABInvoiceTotalAmount MONEY
	DECLARE @ABAmount MONEY
	DECLARE @ABLinesInDB INT
	DECLARE @IsLastABApplication INT
	DECLARE @ABAlreadyReceived money
	DECLARE @ABAlreadyReversed money
	
	-- we do this loop only if we are not an advance bill
	SELECT @AdvBillInvoiceKey = -1
	WHILE (@AdvanceBill=0)
	BEGIN
		SELECT @AdvBillInvoiceKey = MIN(iab.AdvBillInvoiceKey)
		FROM   tInvoiceAdvanceBill iab (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON iab.AdvBillInvoiceKey = i.InvoiceKey
		WHERE  iab.InvoiceKey = @InvoiceKey
		And    (i.Posted = 1
				-- Or we are in the process of posting it to Accrual
				OR i.InvoiceKey IN (SELECT EntityKey FROM #tCashQueue 
							WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action = 0) 
				)		
		
		AND    iab.AdvBillInvoiceKey > @AdvBillInvoiceKey
		-- And we are not in the process of unposting it from Accrual
		AND	i.InvoiceKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=1)	
		
		IF @AdvBillInvoiceKey IS NULL
			BREAK
		
		SELECT @ABInvoiceNumber = ISNULL(InvoiceNumber, @InvoiceNumber)
				,@ABInvoiceTotalAmount = InvoiceTotalAmount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @AdvBillInvoiceKey
		
		SELECT @ABReverseAmount	= 0
						
		SELECT @ABAmount = Amount
		FROM   tInvoiceAdvanceBill (NOLOCK)
		WHERE  AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    InvoiceKey = @InvoiceKey
				
		/*	
		 * Process first the reversals on the AB	
		 */
	
		TRUNCATE TABLE #ABLines
		
		SELECT @ABLinesInDB = 0	
		INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
		SELECT TempTranLineKey, Section, Credit, 0, 0, 0
		FROM   #tCashTransactionLine
		WHERE  Entity = 'INVOICE'
		AND    EntityKey = @AdvBillInvoiceKey
		
		IF @@ROWCOUNT = 0	
		BEGIN
			SELECT @ABLinesInDB = 1
		
			INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
			SELECT CashTransactionLineKey, Section, Credit, 0, 0, 0
			FROM   tCashTransactionLine
			WHERE  Entity = 'INVOICE'
			AND    EntityKey = @AdvBillInvoiceKey
		END 	
			
		-- Amounts already applied on receipts
		UPDATE #ABLines
		SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
			SELECT SUM(ct.Credit)
			FROM   tCashTransaction ct (NOLOCK)
				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity collate database_default 
				AND ct.EntityKey = ctu.EntityKey
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
			
		-- they were REVERSALS when posting the invoice
		-- these are prepayments
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
	
		-- now get what has been reversed by previous invoices			
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
			
		SELECT @ABAlreadyReceived = ISNULL((
			SELECT SUM(AlreadyReceived)
			FROM   #ABLines 
		), 0)		
			
		SELECT @ABAlreadyReversed = ISNULL((
			SELECT SUM(AlreadyReversed)
			FROM   #ABLines 
		), 0)		
		
		SELECT @ABReverseAmount = ISNULL(@ABAlreadyReceived, 0) - ISNULL(@ABAlreadyReversed, 0)
			
		-- if nothing to reverse, stop
		IF @ABReverseAmount = 0
			CONTINUE

		-- we cannot over reverse
		IF @ABReverseAmount > @ABAmount
			SELECT @ABReverseAmount = @ABAmount 
			
		SELECT @IsLastABApplication = 0		
		IF @ABAlreadyReceived = @ABAlreadyReversed + @ABReverseAmount
			 SELECT @IsLastABApplication = 1
				
		-- Should we protect against negative @ABReverseAmount ?
		IF @ABReverseAmount < 0
			CONTINUE
		
		-- Figure out the reversal on the AB per line 
		TRUNCATE TABLE #tApply 
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT LineKey, AlreadyReceived, AlreadyReversed
		FROM   #ABLines	
			
		EXEC sptCashApplyToLines @ABAlreadyReceived, @ABReverseAmount, @ABReverseAmount, @IsLastABApplication	
		
		UPDATE #ABLines
		SET    #ABLines.ToApply = b.ToApply 
		FROM   #tApply b
		WHERE  #ABLines.LineKey = b.LineKey	
			
		SELECT @Memo = 'Advance Billing Reversal from Invoice # '  + @ABInvoiceNumber 
			  	
		-- Note: here we could also specify the ADV BILL GL account Key top match the Accrual for Section = 2 (LINES) 

		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
		
		-- must be reversed with the rate on the AB
		,CurrencyID, ExchangeRate
		)
	
		SELECT CompanyKey,@TransactionDate,'INVOICE',@InvoiceKey,@Reference,GLAccountKey,0,0,ClassKey,
		@Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, NULL, NULL, NULL, 0, 0, ctl.CashTransactionLineKey
		
		,CurrencyID, isnull(ExchangeRate, 1)
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
		
			-- must be reversed with the rate on the AB
			,CurrencyID, ExchangeRate
			)
			
			SELECT CompanyKey,@TransactionDate,'INVOICE',@InvoiceKey,@Reference,GLAccountKey,0,0,ClassKey,
			@Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
				
			-- specific to cash
			, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, NULL, NULL, NULL, 0, 0, ctl.TempTranLineKey, 1
			
			,CurrencyID, isnull(ExchangeRate, 1)
			FROM #tTransaction ctl (NOLOCK)
			WHERE Entity = 'INVOICE' AND EntityKey = @AdvBillInvoiceKey
				
		END
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.Debit = app.ToApply 
		FROM   #tApply app
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.EntityKey = @InvoiceKey
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
			
		/*	
		 * Now what we reversed from the AB, we must apply to this invoice	
		 */
		
		SELECT @IsLastApplication = 0
		IF @ABReverseAmount = @ABAmount
			SELECT @IsLastApplication = 1 -- this refers to the invoice, not the AB
			
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		
		-- must be created with the new rate on the real invoice
		,CurrencyID, ExchangeRate
		)
		
		SELECT CompanyKey,TransactionDate,'INVOICE',@InvoiceKey,@Reference,GLAccountKey,0,0,ClassKey,
		'Due to Advance Billing Invoice # ' + @ABInvoiceNumber,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, 'INVOICE', @AdvBillInvoiceKey, @ABInvoiceNumber, NULL, NULL, NULL, 0, Credit, CashTransactionLineKey, UpdateTranLineKey
		
		,@CurrencyID, @ExchangeRate
		
		FROM #tCashTransactionLines 
		
		-- now calculate the impact of this reversal would have on each line
		TRUNCATE TABLE #tApply 
		IF @LinesInDB = 1 
		BEGIN
			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT CashTransactionLineKey, Amount, 0
			FROM   tInvoiceAdvanceBillSale (NOLOCK)
			WHERE  InvoiceKey = @InvoiceKey
			AND    AdvBillInvoiceKey = @AdvBillInvoiceKey
		END
		ELSE
		BEGIN
			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT TempTranLineKey, Amount, 0
			FROM   #tInvoiceAdvanceBillSale (NOLOCK)
			WHERE  InvoiceKey = @InvoiceKey
			AND    AdvBillInvoiceKey = @AdvBillInvoiceKey		
		END
		 		 
		EXEC sptCashApplyToLines @ABAmount, @ABReverseAmount, @ABReverseAmount, @IsLastApplication		  
		 
		UPDATE #tCashTransaction
		SET    #tCashTransaction.Credit = app.ToApply 
		FROM   #tApply app
		WHERE  #tCashTransaction.Entity = 'INVOICE'
		AND    #tCashTransaction.EntityKey = @InvoiceKey
		AND    #tCashTransaction.AEntity = 'INVOICE'
		AND    #tCashTransaction.AEntityKey = @AdvBillInvoiceKey
		AND    #tCashTransaction.CashTransactionLineKey = app.LineKey

		--SELECT * from #tApply
		--SELECT * from #tCashTransaction
	
		-- Now process the Realized Gain/Loss for the adv bill
		if @MultiCurrency = 1
		begin
			SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
					,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
					,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
			
			SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
				@GLAccountKey, 0, 0,
				null, -- @ClassKey, null it like ICT  
				@Memo + ' Adv Bill ' + abi.InvoiceNumber ,@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
				@GLCompanyKey,@OfficeKey,@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet, 0,
				null, -- Home Currency
				1, -- Exchange Rate = 1
				0,
				Round(iab.Amount * (isnull(abi.ExchangeRate, 1) - @ExchangeRate), 2)
			From   tInvoiceAdvanceBill iab (nolock)
				Inner Join tInvoice abi (NOLOCK) ON iab.AdvBillInvoiceKey = abi.InvoiceKey -- go to the AdvBill invoice
			Where	iab.InvoiceKey = @InvoiceKey
			and iab.AdvBillInvoiceKey = @AdvBillInvoiceKey 
			and Round(iab.Amount * (isnull(abi.ExchangeRate, 1) - @ExchangeRate), 2) <> 0
		
		end 		 		  		
	END	

--select @TransactionDate

	if @MultiCurrency = 1
	begin

	-- Next flip sides to make it positive like Xero does
		update #tCashTransaction
		set    HDebit = -1 * HCredit
			  ,HCredit = 0
			  ,PostSide = 'D'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HCredit, 0) < 0 

		update #tCashTransaction
		set    HCredit = -1 * HDebit
			  ,HDebit = 0
			  ,PostSide = 'C'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HDebit, 0) < 0 

		-- Correct before because this creates the 'Added to balance cash transaction records' record 
		EXEC sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
		-- This will pull the correct rates from the AEntity
		exec sptCashPostSetExchangeRate @Entity,@EntityKey

		-- 0 Cash Basis, 1 Force to rounding account
		exec spGLPostCalcRoundingDiff @CompanyKey,@Entity,@EntityKey,0,1,@GLCompanyKey,@TransactionDate,@Reference, @RoundingDiffAccountKey,@RealizedGainAccountKey 
	end

	-- Create DT and DF for ICT -- 0 Cash Basis
	exec spGLPostICTCreateDTDF @CompanyKey,@Entity,@EntityKey,0,@GLCompanyKey,@TransactionDate,@Memo,@Reference 

	-- Correct and prepared data for final insert
	EXEC sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
--select * from #tCashTransaction

	RETURN 1
GO
