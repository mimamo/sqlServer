USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostPaymentFillVoucher]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostPaymentFillVoucher]
	(
	@CompanyKey INT
	,@VoucherKey INT 
	,@PaymentKey INT
	,@PaymentDetailKey INT
	,@ApplyAmount MONEY
	,@IsLastApplication INT
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
*/

	SET NOCOUNT ON
		
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

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6


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
		@GLCompanyKey = v.GLCompanyKey
		,@VendorID = rtrim(ltrim(c.VendorID))
		,@TransactionDate = PostingDate
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
	From tVoucher v (nolock)
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	Where v.VoucherKey = @VoucherKey

-- Vars for payment info
Declare @CashAccountKey int
Declare @UnappliedAccountKey int
Declare @PaymentAmount money
Declare @UnappliedAmount money
Declare @DiscountAmount money
Declare @DetailAmount money
Declare @CheckNumber varchar(100)
Declare @PaymentPostingDate datetime
	
		Select
		@GLCompanyKey = GLCompanyKey
		,@PaymentAmount = PaymentAmount
		,@PaymentPostingDate = PostingDate
		,@CheckNumber = CheckNumber
		,@CashAccountKey = CashAccountKey
		,@ClassKey = ClassKey
		,@VendorKey = VendorKey
		,@Posted = Posted
		,@UnappliedAccountKey = ISNULL(UnappliedPaymentAccountKey, 0)
		,@ProjectKey = NULL
		,@ClientKey = NULL
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	from tPayment (nolock)
	Where PaymentKey = @PaymentKey


		-- These should not change
	Select	@Entity = 'PAYMENT'
			,@EntityKey = @PaymentKey
			,@Reference = @CheckNumber 
			,@SourceCompanyKey = @VendorKey			
			,@DepositKey = NULL 

	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
		
	/*	
	get a list of transaction lines
	*/
	
		-- one entry per tax and expense account
		SELECT @PostSide = 'D' , @GLAccountKey = @APAccountKey, @GLAccountErrRet = @kErrInvalidAPAcct 
				,@Memo = @kMemoPrepayments, @Amount = @PrepaymentAmount, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
	)
	
	SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey, @Reference,GLAccountKey,0,0,ClassKey,
	Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
	DepartmentKey,DetailLineKey,Section
	
	-- specific to cash
	, Entity, @VoucherKey, @InvoiceNumber, NULL, NULL, NULL, 0, Debit, CashTransactionLineKey, 0
	
	FROM tCashTransactionLine ctl (NOLOCK)
	WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND EntityKey = @VoucherKey
	AND   [Section] in ( 2, 5) -- lines + taxes only
	
	--select * from #tCashTransaction
	
	-- if not posted yet, must be in the #tTransaction
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2,  AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
		)
		
		SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@Reference,GLAccountKey,0,0,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section
		
		-- specific to cash
		, Entity, @VoucherKey, @InvoiceNumber, NULL, NULL, NULL, 0, Debit, TempTranLineKey, 1
		
		FROM #tTransaction ctl
		WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND EntityKey = @VoucherKey
		AND   [Section] in ( 2, 5) -- lines + taxes only
	
	END		

	--select * from #tCashTransaction Where AEntity = 'VOUCHER'

	TRUNCATE TABLE #tApply 
	INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
	SELECT CashTransactionLineKey, LineAmount, 0
    FROM   #tCashTransaction (NOLOCK)
	WHERE  Entity = 'PAYMENT'
	AND    EntityKey = @PaymentKey
	AND    AEntity IN ('VOUCHER', 'CREDITCARD')
	AND    AEntityKey = @VoucherKey
    AND    [Section] IN (2, 5) 		 

	IF @IsLastApplication = 1
	BEGIN
	     		 
		-- Already applied thru regular payments 		 
		UPDATE #tApply
		SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
			SELECT SUM(ct.Debit)
			FROM   tCashTransaction ct (NOLOCK)
				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
			WHERE  ct.Entity = 'PAYMENT'
			AND    ct.EntityKey <> @PaymentKey
			AND    ct.AEntity IN ('VOUCHER', 'CREDITCARD')
			AND    ct.AEntityKey = @VoucherKey
			AND    ct.CashTransactionLineKey = #tApply.LineKey
			AND    [Section] IN (2, 5) 		 
			AND    ISNULL(ctu.Unpost, 0) = 0
		),0)

		UPDATE #tApply
		SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
			SELECT SUM(Debit)
			FROM   #tCashTransaction 
			WHERE  #tCashTransaction.Entity = 'PAYMENT'
			AND    #tCashTransaction.EntityKey <> @PaymentKey
			AND    #tCashTransaction.AEntity IN ('VOUCHER', 'CREDITCARD')
			AND    #tCashTransaction.AEntityKey = @VoucherKey
			AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
			AND    [Section] IN (2, 5) 		 
		),0) 
	  	
  		-- Also applied thru prepayments, should be on the voucher
  		UPDATE #tApply
		SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
			SELECT SUM(ct.Debit)
			FROM   tCashTransaction ct (NOLOCK)
				LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
			WHERE  ct.Entity IN ('VOUCHER', 'CREDITCARD')
			AND    ct.EntityKey = @VoucherKey
			AND    ct.CashTransactionLineKey = #tApply.LineKey
			AND    [Section] IN (2, 5) 		 
			AND    ISNULL(ctu.Unpost, 0) = 0
		),0)

		UPDATE #tApply
		SET    #tApply.AlreadyApplied = #tApply.AlreadyApplied + ISNULL((
			SELECT SUM(Debit)
			FROM   #tCashTransaction 
			WHERE  #tCashTransaction.Entity IN ('VOUCHER', 'CREDITCARD')
			AND    #tCashTransaction.EntityKey = @VoucherKey
			AND    #tCashTransaction.CashTransactionLineKey = #tApply.LineKey
			AND    [Section] IN (2, 5) 		 
		),0) 
	  	
  	END
  	
  		 
    --select @VoucherTotalAmount, @ApplyAmount, @IsLastApplication
     		 
	EXEC sptCashApplyToLines @VoucherTotalAmount, @ApplyAmount, @ApplyAmount, @IsLastApplication		  

	--select * from #tApply

	UPDATE #tCashTransaction
	SET    #tCashTransaction.Debit = app.ToApply 
	FROM   #tApply app
	WHERE  #tCashTransaction.Entity = @Entity
	AND    #tCashTransaction.EntityKey = @EntityKey
	AND    #tCashTransaction.CashTransactionLineKey = app.LineKey

	--select * from #tCashTransaction
	
	
				
							
	RETURN 1
GO
