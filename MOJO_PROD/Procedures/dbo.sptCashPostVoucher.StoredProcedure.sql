USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostVoucher]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostVoucher]
	(
		@CompanyKey int
		,@VoucherKey int
		,@CreateTemp int = 0	-- Can be used for testing	
	)

AS --Encrypt	

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
|| 03/27/12 GHL 10.554 Made changes for ICT 
|| 07/03/12 GHL 10.557 Added call to spGLPostICTCreateDTDF for Inter Company Transactions
|| 07/03/12 GHL 10.557 Added tCashTransaction.ICTGLCompanyKey
|| 04/08/13 GHL 10.566 (163359) Added now voucher lines coming thru tVoucherCC 
|| 08/05/13 GHL 10.571 Added Multi Currency stuff
|| 03/26/14 GHL 10.578 Added handling of tPreference.CreditCardPayment (a credit card charge is a payment)
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
			AEntity2 varchar (50) NULL ,
			AEntity2Key int NULL ,
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
DECLARE @kErrInvalidAPAcct INT					SELECT @kErrInvalidAPAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -2
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -3
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -4
DECLARE @kErrInvalidWIPExpenseAssetAcct INT		SELECT @kErrInvalidWIPExpenseAssetAcct = -5
DECLARE @kErrInvalidWIPMediaAssetAcct INT		SELECT @kErrInvalidWIPMediaAssetAcct = -6
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -7
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -8
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -9
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -10
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -11
DECLARE @kErrTranDateMissing INT				SELECT @kErrTranDateMissing = -12

DECLARE @kErrInvalidRoundingDiffAcct int		SELECT @kErrInvalidRoundingDiffAcct = -350
DECLARE @kErrInvalidRealizedGainAcct int		SELECT @kErrInvalidRealizedGainAcct = -351

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Voucher # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Voucher # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Voucher # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Reverse Prepayment Accrual '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Voucher # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Voucher # '
DECLARE @kMemoWIP VARCHAR(100)					SELECT @kMemoWIP = 'VI Post WIP Sales'
DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '
DECLARE @kMemoMCRounding VARCHAR(100)			SELECT @kMemoMCRounding = 'Multi Currency Rounding Diff '

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6
DECLARE @kSectionVoucherCC int					SELECT @kSectionVoucherCC = 7
DECLARE @kSectionICT int						SELECT @kSectionICT = 8
DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10


-- Vars for tPref
Declare @PostToGL tinyint
Declare @GLClosedDate smalldatetime
Declare @POAccruedExpenseAccountKey int
Declare @POPrebillAccrualAccountKey int
Declare @IOClientLink int
Declare @BCClientLink int
Declare	@AccrueCostToItemExpenseAccount int
Declare	@WIPRecognizeCostRev int
Declare	@WIPMediaAssetAccountKey int
Declare	@WIPExpenseAssetAccountKey int
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  
		,@CreditCardPayment int

-- Vars for invoice info
DECLARE @APAccountKey int
		,@Amount money
		,@SalesTaxKey int
		,@SalesTaxAccountKey int
		,@SalesTaxAmount money
		,@SalesTax2Key int
		,@SalesTax2AccountKey int
		,@SalesTax2Amount money
		,@InvoiceNumber varchar(100)
		,@Posted tinyint
		,@VendorKey int
        ,@VendorID varchar(100)
		,@HeaderOfficeKey INT
		,@PrepaymentAmount money
		,@OpeningTransaction tinyint
		,@VoucherTotalAmount money
		,@CreditCard int
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
		 @MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey  
		,@CreditCardPayment = isnull(CreditCardPayment, 0)
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey

	Select 
		@GLCompanyKey = v.GLCompanyKey
		,@VendorID = rtrim(ltrim(c.VendorID))
		,@TransactionDate = dbo.fFormatDateNoTime(PostingDate)
		,@APAccountKey = ISNULL(APAccountKey, 0)
		,@Amount = ISNULL(VoucherTotal, 0)
		,@VoucherTotalAmount= ISNULL(VoucherTotal, 0)
		,@ClassKey = v.ClassKey
		,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
		,@ProjectKey = v.ProjectKey
		,@ClientKey = p.ClientKey
		,@VendorKey = c.CompanyKey
		,@Posted = Posted
		,@SalesTaxKey = v.SalesTaxKey
		,@SalesTaxAmount = ISNULL(v.SalesTax1Amount, 0)
		,@SalesTax2Key = v.SalesTax2Key
		,@SalesTax2Amount = ISNULL(v.SalesTax2Amount, 0)
		,@HeaderOfficeKey = v.OfficeKey
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
		,@CreditCard = isnull(CreditCard, 0)
		,@CurrencyID = v.CurrencyID
		,@ExchangeRate = isnull(v.ExchangeRate, 1)
	From tVoucher v (nolock)
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	Where v.VoucherKey = @VoucherKey

	Select @PrepaymentAmount = Sum(Amount) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey and isnull(Prepay, 0) = 1
	Select @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)

	-- These should not change
	if @CreditCard = 1
		Select	@Entity = 'CREDITCARD'
	else
		Select	@Entity = 'VOUCHER'
	
	Select	@EntityKey = @VoucherKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @VendorKey			
			,@DepositKey = NULL 

	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	

	-- First add the posted payments which have a posting date BEFORE this invoice
	-- they are similar to prepayments but we reverse the AR account instead of the prepayment account
	-- the difference is that we do not know if they are posted or not
	SELECT @PostSide = 'C' ,@GLAccountErrRet = @kErrInvalidPrepayAcct 
			,@Memo = @kMemoPrepayments , @Section = @kSectionPrepayments   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	DECLARE @PaymentKey INT
	DECLARE @PaymentDetailKey INT
	DECLARE @ApplyAmount MONEY
	DECLARE @TotalApplyAmount MONEY
	DECLARE @PaymentPosted INT 
	
	SELECT @TotalApplyAmount = 0
	SELECT @PaymentKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @PaymentKey = MIN(pd.PaymentKey)
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey			
		Where	pd.VoucherKey = @VoucherKey
		And		isnull(pd.Prepay, 0) = 0
		And     p.PostingDate < @TransactionDate		
		And    (p.Posted = 1
				-- Or we are in the process of posting it to Accrual
				OR pd.PaymentKey IN (SELECT EntityKey FROM #tCashQueue 
							WHERE Entity = 'PAYMENT' AND PostingOrder = 1 AND Action = 0) 
				)		
		And    pd.PaymentKey > @PaymentKey
		-- And we are not in the process of unposting it from Accrual
		AND	pd.PaymentKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'PAYMENT' AND PostingOrder = 1 AND Action=1)
		
		If @PaymentKey is null
			break	
		
		SELECT @ApplyAmount = pd.Amount
			   ,@PaymentDetailKey = pd.PaymentDetailKey
		FROM   tPaymentDetail pd (nolock)
		WHERE  pd.VoucherKey = @VoucherKey
		AND    pd.PaymentKey = @PaymentKey
		
		
		/*
		-- Must be posted, but we cannot blindly trust c.Posted
		-- because we could be in the process of posting the check in the cash queue
		SELECT @PaymentPosted = 0
		
		IF EXISTS (SELECT 1 FROM #tCashTransaction 
					WHERE Entity = 'PAYMENT' 
					AND EntityKey = @PaymentKey)
			SELECT @PaymentPosted = 1
			
		IF @PaymentPosted = 0 AND EXISTS (SELECT 1 FROM tCashTransaction ct (NOLOCK)
					LEFT OUTER JOIN #tCashTransactionUnpost ctu 
							ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
					WHERE ct.Entity = 'PAYMENT' 
					AND   ct.EntityKey = @PaymentKey
					AND   ISNULL(ctu.Unpost, 0) = 0 
					)			
			SELECT @PaymentPosted = 1
			
		--SELECT @PaymentPosted
			
		IF 	@PaymentPosted = 0
			CONTINUE
		*/
		
		SELECT @TotalApplyAmount = @TotalApplyAmount + @ApplyAmount
					
		-- One entry per payment applied			
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)

		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@APAccountKey, 0, pd.Amount,
		p.ClassKey,  @Memo + p.CheckNumber ,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
		,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet, 0

		-- specific to cash
		, 'PAYMENT', @PaymentKey, p.CheckNumber, NULL, NULL, NULL, 0, 0, 0, 0
		From   tPaymentDetail pd (nolock)
		Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.PaymentDetailKey = @PaymentDetailKey
	
		
	END	

	if @PrepaymentAmount  <> 0
	BEGIN

		-- One entry per class, GL account
		SELECT @PostSide = 'C' , @GLAccountErrRet = @kErrInvalidPrepayAcct 
				,@Memo = @kMemoPrepayments, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet
		
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)
		
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			p.UnappliedPaymentAccountKey, 0, SUM(pd.Amount),
			ISNULL(p.ClassKey, 0),  @Memo + p.CheckNumber,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

			-- ICT
			, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
			,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet
		
			-- specific to cash
			, 'PAYMENT', p.PaymentKey, p.CheckNumber, NULL, NULL, NULL, 0, 0, 0, 0

		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.VoucherKey = @VoucherKey
		And		isnull(pd.Prepay, 0) = 1
		Group By case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
			,p.UnappliedPaymentAccountKey, p.PaymentKey, + p.CheckNumber, pd.PaymentDetailKey, ISNULL(p.ClassKey, 0) 

	END
	
	-- Now process the Realized Gain/Loss for the prepayments
	-- One entry per application
	if @MultiCurrency = 1
	begin
		SELECT @PostSide = 'D', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + p.CheckNumber ,
			null, --@ClientKey,
			null, --@ProjectKey,
			@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			Round(pd.Amount * (isnull(p.ExchangeRate, 1) - @ExchangeRate), 2),
			0
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		-- do not check prepay = 1 here because we have the real prepayments and where check Posting Date before inv Posting Date  
		Where	pd.PaymentDetailKey in (
			select DetailLineKey from #tCashTransaction 
			where Entity = @Entity
			and   EntityKey = @EntityKey
			and   AEntity = 'PAYMENT'
			and   AEntityKey > 0 -- valid payment
		)
		and Round(pd.Amount * (isnull(p.ExchangeRate, 1) - @ExchangeRate), 2) <> 0	

	end

	/*	
	get a list of transaction lines
	*/
	
	SELECT * INTO #tCashTransactionLines FROM #tCashTransaction WHERE 1 = 2 
	
	--select * from #tCashTransactionLines

	-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
	INSERT #tCashTransactionLines(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, AEntity, AEntityKey, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
	)
	
	SELECT CompanyKey,TransactionDate,Entity,@VoucherKey,Reference,GLAccountKey,0,0,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, NULL, NULL, NULL, NULL, 0, Debit, CashTransactionLineKey, 0
	
	FROM tCashTransactionLine ctl (NOLOCK)
	WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND EntityKey = @VoucherKey
	AND   [Section] in ( 2, 5) -- lines + taxes only
	
	--select * from #tCashTransactionLines
	
	-- if not posted yet, must be in the #tTransaction
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT #tCashTransactionLines(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,Entity,@VoucherKey,Reference,GLAccountKey,0,0,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, NULL, NULL, NULL, NULL, 0, Debit, TempTranLineKey, 1
		
		FROM #tTransaction ctl
		WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND EntityKey = @VoucherKey
		AND   [Section] in ( 2, 5) -- lines + taxes only
	
	END		
	
	--select * from #tCashTransactionLines
	
	-- now add the real vouchers applied through tVoucherCC, to this credit card
	-- these should be already posted, so get them from the real table tCashTransactionLine i.e. not the temp table
	INSERT #tCashTransactionLines(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, AEntity, AEntityKey, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
	)
	
	SELECT CompanyKey,TransactionDate,'CREDITCARD',@VoucherKey,Reference,GLAccountKey,0,0,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'C',GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, Entity, EntityKey, NULL, NULL, 0, Debit, CashTransactionLineKey, 0
	
	FROM  tVoucherCC vcc (nolock)
	INNER JOIN tCashTransactionLine ctl (NOLOCK) ON vcc.VoucherKey = ctl.EntityKey AND ctl.Entity = 'VOUCHER'
	WHERE vcc.VoucherCCKey = @VoucherKey
	AND   [Section] in ( 2, 5) -- lines + taxes only
	

	-- now take in account the amount in tVoucherCC
	DECLARE @RealVoucherKey int, @VoucherCCAmount money, @VoucherTotal money
	select @RealVoucherKey = -1
	while (1=1)
	begin
		select @RealVoucherKey = min(VoucherKey) 
		from   tVoucherCC (nolock)
		where  VoucherCCKey = @VoucherKey
		and    VoucherKey > @RealVoucherKey

		if @RealVoucherKey is null
			break

		select @VoucherCCAmount = Amount 
		from   tVoucherCC (nolock)
		where  VoucherCCKey = @VoucherKey
		and    VoucherKey = @RealVoucherKey

		TRUNCATE TABLE #tApply
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT CashTransactionLineKey, LineAmount, 0
		FROM   #tCashTransactionLines
		WHERE  EntityKey = @VoucherKey
		AND    Entity = 'CREDITCARD'  
		AND    AEntityKey = @RealVoucherKey
		AND    AEntity = 'VOUCHER'

		SELECT @VoucherTotal = SUM(LineAmount) FROM #tApply

		EXEC sptCashApplyToLines @VoucherTotal, @VoucherCCAmount, @VoucherCCAmount, 0	
 			
 		UPDATE #tCashTransactionLines
 		SET    #tCashTransactionLines.LineAmount = b.ToApply
 		FROM   #tApply b
 		WHERE  #tCashTransactionLines.CashTransactionLineKey = b.LineKey 
		AND    EntityKey = @VoucherKey
		AND    Entity = 'CREDITCARD'  
		AND    AEntityKey = @RealVoucherKey
		AND    AEntity = 'VOUCHER'

	end

	UPDATE #tCashTransactionLines
 	SET    #tCashTransactionLines.LineAmount = isnull(#tCashTransactionLines.LineAmount, 0)

	--select * from #tCashTransactionLines

	declare @CreditCardPrepaymentAmount money
	select @CreditCardPrepaymentAmount = 0

	if @CreditCardPayment = 1 AND @Entity = 'VOUCHER'
	begin
		/*
		If the Credit Card is after the vouchers, we do not do anything because no cash is involved yet at the time of the voucher
		
		If the Credit Card is before the voucher, we need to reverse the prepayment
		*/

		-- now take in account the amount in tVoucherCC
		Declare @VoucherCCKey int -- voucher key of the credit card 
		select @VoucherCCKey = -1
		while (1=1)
		begin
			select @VoucherCCKey = min(vcc.VoucherCCKey) 
			from   tVoucherCC vcc (nolock)
				inner join tVoucher ccc (nolock) on vcc.VoucherCCKey = ccc.VoucherKey
			where  vcc.VoucherKey = @VoucherKey -- real voucher
			and    vcc.VoucherCCKey > @VoucherCCKey
			and    ccc.PostingDate < @TransactionDate
			And    (ccc.Posted = 1
					-- Or we are in the process of posting it to Accrual
					OR ccc.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
								WHERE Entity = 'CREDITCARD' AND PostingOrder = 1 AND Action = 0) 
					)		
			-- And we are not in the process of unposting it from Accrual
			AND	ccc.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity = 'CREDITCARD' AND PostingOrder = 1 AND Action=1)
		
			if @VoucherCCKey is null
				break

			select @VoucherCCAmount = Amount 
			from   tVoucherCC (nolock)
			where  VoucherCCKey = @VoucherCCKey
			and    VoucherKey = @VoucherKey

			-- we need to capture the class and the AP GL account, + REF TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
			select @CreditCardPrepaymentAmount =  isnull(@CreditCardPrepaymentAmount, 0) + isnull(@VoucherCCAmount, 0)

			SELECT @PostSide = 'C'
			  ,@GLAccountKey = @APAccountKey
			  ,@GLAccountErrRet = @kErrInvalidAPAcct 
				,@Memo = @kMemoHeader, @Amount = @VoucherCCAmount, @Section = @kSectionPrepayments   
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
				
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag
		
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)

			SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			v.APAccountKey, 0, @VoucherCCAmount,
			v.ClassKey,  Left(@Memo + ' ' + rtrim(ltrim(v.InvoiceNumber)), 500)  ,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

			, @GLCompanyKey ,@OfficeKey,@DepartmentKey,null,@Section,@GLAccountErrRet, 0

			-- specific to cash
			, 'CREDITCARD', v.VoucherKey, NULL, NULL, NULL, NULL, 0, 0, 0, 0
			From   tVoucher v (nolock)
			Where  v.VoucherKey = @VoucherCCKey
		end

	end


	/*
	 * Prepayments
	 */
	 
	select @PrepaymentAmount = isnull(@PrepaymentAmount,0) + isnull(@TotalApplyAmount,0) + isnull(@CreditCardPrepaymentAmount, 0)
	if @PrepaymentAmount  <> 0
	BEGIN
		-- one entry per tax and expense account
		SELECT @PostSide = 'D' , @GLAccountKey = @APAccountKey, @GLAccountErrRet = @kErrInvalidAPAcct 
				,@Memo = @kMemoPrepayments, @Amount = @PrepaymentAmount, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL


	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,@Entity,@EntityKey,Reference,GLAccountKey,0,0,ClassKey,
		@Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,@PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section -- Important to keep Section = 2 or 5 so that we can capture rounding errors
		
		-- specific to cash, no need to specify AEntity, AEntityKey since we lump all prepayments per line
		, 'PAYMENT', 0, NULL, NULL, 0, 0, CashTransactionLineKey, UpdateTranLineKey
		
		FROM #tCashTransactionLines 
		
		TRUNCATE TABLE #tApply 
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT CashTransactionLineKey, LineAmount, 0
	    FROM  #tCashTransactionLines (NOLOCK)
	     		 
	    --select @VoucherTotalAmount, @PrepaymentAmount
	     		 
		EXEC sptCashApplyToLines @VoucherTotalAmount, @PrepaymentAmount, @PrepaymentAmount		  

		--select * from #tApply
 
		UPDATE #tCashTransaction
		SET    #tCashTransaction.Debit = app.ToApply 
		FROM   #tApply app
		WHERE  #tCashTransaction.Entity = @Entity
		AND    #tCashTransaction.EntityKey = @EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
	
	--select * from #tCashTransaction
		
		
	END
	
	-- Now take care of the case when the credit card charge is considered a payment
	if @CreditCardPayment = 1 AND @Entity = 'CREDITCARD'
	begin

		/*
            DR     CR
    CC             2000
	Exp0   1500            <-- Expense on the Credit Card
	
	AP     500             <--- If this is a prepayment, ie if the Credit Card charge is before the voucher
	or 
	Exp1   200             <-- If the voucher is on or before the Credit Card charge
	Exp2   300

		*/

		-- we can only use the voucher lines where PostingDate <= @TransactionDate
		DELETE #tCashTransactionLines
		FROM   tVoucher v (nolock)  
		where  #tCashTransactionLines.AEntity = 'VOUCHER'
		AND    #tCashTransactionLines.AEntityKey = v.VoucherKey 
		AND    v.PostingDate > @TransactionDate
		
		-- one entry per tax and expense account
		SELECT @PostSide = 'D' , @GLAccountKey = @APAccountKey, @GLAccountErrRet = @kErrInvalidAPAcct 
				,@Memo = @kMemoHeader, @Amount = @PrepaymentAmount, @Section = @kSectionVoucherCC   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	

		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AEntity2, AEntity2Key, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,TransactionDate,@Entity,@EntityKey,Reference,GLAccountKey,LineAmount,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,@PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section -- Important to keep Section = 2 or 5 so that we can capture rounding errors
		
		-- specific to cash
		, AEntity, AEntityKey, NULL, NULL, 0, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		
		FROM #tCashTransactionLines 

		-- now take in account the amount in tVoucherCC
		select @RealVoucherKey = -1
		while (1=1)
		begin
			select @RealVoucherKey = min(vcc.VoucherKey) 
			from   tVoucherCC vcc (nolock)
				inner join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey
			where  vcc.VoucherCCKey = @VoucherKey
			and    vcc.VoucherKey > @RealVoucherKey
			and    v.PostingDate > @TransactionDate
		
			if @RealVoucherKey is null
				break

			select @VoucherCCAmount = Amount 
			from   tVoucherCC (nolock)
			where  VoucherCCKey = @VoucherKey
			and    VoucherKey = @RealVoucherKey

			-- we need to capture the class and the AP GL account, + REF TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			-- plus here we may need a realized gain
				
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag
		
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)

			SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			v.APAccountKey, @VoucherCCAmount, 0,
			v.ClassKey,  @Memo  ,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

			, @GLCompanyKey ,@OfficeKey,@DepartmentKey,null,@Section,@GLAccountErrRet, 0

			-- specific to cash
			, 'VOUCHER', v.VoucherKey, NULL, NULL, NULL, NULL, 0, 0, 0, 0
			From   tVoucher v (nolock)
			Where  v.VoucherKey = @RealVoucherKey

		end


		-- now the credit card
		SELECT @PostSide = 'C'
			  ,@GLAccountKey = @APAccountKey
			  ,@GLAccountErrRet = @kErrInvalidAPAcct 
			  ,@Memo = @kMemoHeader , @Section = @kSectionHeader  
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
		  		
		select @Amount = sum(Debit) from #tCashTransaction
		where Entity= @Entity and EntityKey = @EntityKey

		exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

			--,AEntity,AEntityKey,AReference, AEntity2,AEntity2Key,AReference2, AAmount,LineAmount,CashTransactionLineKey
			,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL
	end
	
	

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

	
	RETURN 1
GO
