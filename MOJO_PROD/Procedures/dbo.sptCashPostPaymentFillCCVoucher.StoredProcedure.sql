USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostPaymentFillCCVoucher]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostPaymentFillCCVoucher]
	(
	@CompanyKey INT
	,@VoucherCCKey INT 
	,@PaymentKey INT
	,@PaymentDetailKey INT
	,@ApplyAmount MONEY
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 10/06/11 GHL 10.459  Creation for the cash basis posting of tVoucherCC records 
||                      Clone of sptCashPostCheckFillABInvoice then replace:
||                      tInvoiceAdvanceBillSales by tVoucherCCDetail
||                      AdvBillInvoiceKey by VoucherCCKey
||                      Could have left some wording releded to AdvanceBill
||                      but the same logic is applicable to credit card charges 
|| 10/13/11 GHL 10.459  Added new entity CREDITCARD
|| 12/06/12 GHL 10.562  Added protection against missing #tCashTransactionLine
|| 04/10/13 GHL 10.566  (163359) This sp could not handle negative credit card charges 
||                      applied to negative vendor invoices. Modified the ApplyAmount >0 section
||                      to handle both signs. Removed ApplyAmount <0 section
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

-- Vars for VOUCHER info
DECLARE @APAccountKey int
		,@Amount money
		,@SalesTaxKey int
		,@SalesTaxAccountKey int
		,@SalesTaxAmount money
		,@SalesTax2Key int
		,@SalesTax2AccountKey int
		,@SalesTax2Amount money
		,@ReferenceNumber varchar(100)
		,@VoucherNumber varchar(100)
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


	DECLARE @ABVoucherTotalAmount MONEY
	DECLARE @ABSalesAmount MONEY
	DECLARE @ABTaxesAmount MONEY
	DECLARE @ABVoucherNumber varchar(100)
	
	
	DECLARE @IsLastVouchersApplication INT
	DECLARE @IsLastABApplication INT
	DECLARE @ToApplyOnVouchers MONEY
	DECLARE @VouchersApplyAmount MONEY
	DECLARE @ABApplyAmount MONEY

	Select 
		@GLCompanyKey = v.GLCompanyKey
		,@VendorID = rtrim(ltrim(c.VendorID))
		,@TransactionDate = PostingDate
		,@APAccountKey = ISNULL(APAccountKey, 0)
		,@Amount = ISNULL(VoucherTotal, 0)
		,@VoucherTotalAmount= ISNULL(VoucherTotal, 0)
		,@ClassKey = v.ClassKey
		,@VoucherNumber = rtrim(ltrim(InvoiceNumber))
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
	Where v.VoucherKey = @VoucherCCKey

	Select 
		@ABVoucherTotalAmount = VoucherTotal
		,@ABTaxesAmount = ISNULL(SalesTaxAmount, 0) -- This includes sales tax 1 + sales tax 2 + other taxes
		,@ABSalesAmount = VoucherTotal - ISNULL(SalesTaxAmount, 0)
		,@ABVoucherNumber = rtrim(ltrim(InvoiceNumber))
	From tVoucher (nolock)
	Where VoucherKey = @VoucherCCKey

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
		,@ReferenceNumber = CheckNumber
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
			
declare @CashTransactionLineTempExists int
select @CashTransactionLineTempExists = 0

IF OBJECT_ID('tempdb..#tCashTransactionLine') IS NOT NULL
select @CashTransactionLineTempExists = 1

	-- 1)Gather all the data on AB VOUCHER lines
	DECLARE @ABLinesInDB int
	SELECT @ABLinesInDB = 1
	
	CREATE TABLE #ABLines(LineKey int null, Section int null, LineAmount money null
		, AlreadyReceived money null, AlreadyReversed money null, ToApply money null) 
	
	
	INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
	SELECT CashTransactionLineKey, Section, PrepaymentAmount + ReceiptAmount, 0, 0, 0
	FROM   tCashTransactionLine (NOLOCK)
	WHERE  Entity = 'CREDITCARD'
	AND    EntityKey = @VoucherCCKey
	
	IF @@ROWCOUNT = 0 and @CashTransactionLineTempExists =1
	BEGIN
		SELECT @ABLinesInDB = 0
		
		INSERT #ABLines (LineKey, Section, LineAmount, AlreadyReceived, AlreadyReversed, ToApply)
		SELECT TempTranLineKey, Section, PrepaymentAmount + ReceiptAmount, 0, 0, 0
		FROM   #tCashTransactionLine
		WHERE  Entity = 'CREDITCARD'
		AND    EntityKey = @VoucherCCKey
	END 
		
	-- because credit memos could be applied to AB, better to recalc @ABVoucherTotalAmount
	SELECT @ABVoucherTotalAmount = ISNULL((
		SELECT SUM(LineAmount)
		FROM #ABLines
		),0)
		
	-- Amounts already applied on receipts
	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'PAYMENT'
		--AND    ct.EntityKey = @PaymentKey
		AND    ct.AEntity = 'CREDITCARD'
		AND    ct.AEntityKey = @VoucherCCKey
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'PAYMENT'
		--AND    tCashTransaction.EntityKey = @PaymentKey
		AND    #tCashTransaction.AEntity = 'CREDITCARD'
		AND    #tCashTransaction.AEntityKey = @VoucherCCKey
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)	


	-- CHECK PREPAYMENTS REVERSALS I HAVE SEEN DEBIT AND CREDIT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	-- Add ALL PREPAYMENTS
	-- they were REVERSALS when posting the invoice
	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'CREDITCARD'
		AND    ct.EntityKey = @VoucherCCKey
		AND    ct.AEntity = 'PAYMENT'
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReceived = #ABLines.AlreadyReceived + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'CREDITCARD'
		AND    #tCashTransaction.EntityKey = @VoucherCCKey
		AND    #tCashTransaction.AEntity = 'PAYMENT'
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)		

	-- Amounts already reversed
	UPDATE #ABLines
	SET    #ABLines.AlreadyReversed = #ABLines.AlreadyReversed + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey
		WHERE  ct.Entity = 'CREDITCARD'
		AND    ct.AEntity = 'CREDITCARD'
		AND    ct.AEntityKey = @VoucherCCKey
		AND    ct.CashTransactionLineKey = #ABLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
	),0)

	UPDATE #ABLines
	SET    #ABLines.AlreadyReversed = #ABLines.AlreadyReversed + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction 
		WHERE  #tCashTransaction.Entity = 'CREDITCARD'
		AND    #tCashTransaction.AEntity = 'CREDITCARD'
		AND    #tCashTransaction.AEntityKey = @VoucherCCKey
		AND    #tCashTransaction.CashTransactionLineKey = #ABLines.LineKey
	),0)	



		-- 2) Analyze the invoices linked to the adv bill 

	CREATE TABLE #Vouchers (VoucherKey INT null)
	CREATE TABLE #VoucherLines (VoucherKey INT null, LineKey int null, LineID int identity(1,1), Closed int null
		, LinesInDB int null, AdvBillAmount money null, AlreadyReceived money null, AlreadyReversed money null, ToApply money null)
	
	INSERT #Vouchers (VoucherKey)
	SELECT i.VoucherKey
	FROM   tVoucherCC vcc (NOLOCK)
		INNER JOIN tVoucher i (NOLOCK) ON vcc.VoucherKey = i.VoucherKey -- i is the real invoice
	WHERE  vcc.VoucherCCKey = @VoucherCCKey   
	-- They should be posted
	AND (i.Posted = 1
			OR
			-- Or we are in the process of posting it to Accrual
			i.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity = 'VOUCHER' AND PostingOrder = 1 AND Action=0)
			)	 
	-- And we are not in the process of unposting it from Accrual
	AND	i.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
		WHERE Entity = 'VOUCHER' AND PostingOrder = 1 AND Action=1)		
		
	-- we consider that if the invoices have the same posting date
	-- they are BEFORE the check
	
	-- GHL 4/10/13 take them all, not like in AR
	-- AND    i.PostingDate <= @PaymentPostingDate  
	
	--select * from #Vouchers
	--select * from #ABLines
	
	DECLARE @VoucherKey int
	DECLARE @LinesInDB int
	
	SELECT @VoucherKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @VoucherKey = MIN(VoucherKey)
		FROM   #Vouchers
		WHERE  VoucherKey > @VoucherKey 
	
		IF @VoucherKey IS NULL
			BREAK
			
		SELECT @LinesInDB = 1
		INSERT #VoucherLines (VoucherKey, LineKey, Closed, LinesInDB, AdvBillAmount, AlreadyReceived, AlreadyReversed, ToApply)
		SELECT @VoucherKey, CashTransactionLineKey, 0, 1, ISNULL(AdvBillAmount, 0), 0, 0, 0
		FROM   tCashTransactionLine (NOLOCK)
		WHERE  Entity = 'VOUCHER'
		AND    EntityKey = @VoucherKey
		
		IF @@ROWCOUNT = 0 AND @CashTransactionLineTempExists = 1
		BEGIN
			SELECT @LinesInDB = 0
			
			INSERT #VoucherLines (VoucherKey, LineKey, Closed, LinesInDB, AdvBillAmount, AlreadyReceived, AlreadyReversed, ToApply)
			SELECT @VoucherKey, TempTranLineKey, 0, 0, ISNULL(AdvBillAmount, 0), 0, 0, 0
			FROM   #tCashTransactionLine
			WHERE  Entity = 'VOUCHER'
			AND    EntityKey = @VoucherKey
		END 
	
		-- PROBLEM THE ADB BILL AMOUNT IS FOR ALL ADV BILLS
		-- need to isolate this one AB
		IF @LinesInDB = 1
			UPDATE #VoucherLines
			SET    #VoucherLines.AdvBillAmount = iabs.Amount
			FROM   tVoucherCCDetail iabs (NOLOCK)
			WHERE  #VoucherLines.VoucherKey = iabs.VoucherKey
			AND    #VoucherLines.LineKey = iabs.CashTransactionLineKey
			AND    iabs.VoucherCCKey = @VoucherCCKey
		ELSE
			UPDATE #VoucherLines
			SET    #VoucherLines.AdvBillAmount = iabs.Amount
			FROM   #tVoucherCCDetail iabs (NOLOCK)
			WHERE  #VoucherLines.VoucherKey = iabs.VoucherKey
			AND    #VoucherLines.LineKey = iabs.TempTranLineKey
			AND    iabs.VoucherCCKey = @VoucherCCKey
		
 	END		
 	
 	UPDATE #VoucherLines SET AdvBillAmount = ISNULL(AdvBillAmount, 0)
	
	
	-- Get the receipts already applied against each invoice, thru the AB 
	UPDATE #VoucherLines
	SET    #VoucherLines.AlreadyReceived = #VoucherLines.AlreadyReceived + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'PAYMENT'
		AND    ct.AEntity = 'CREDITCARD'
		AND    ct.AEntityKey = @VoucherCCKey
		AND    ct.AEntity2 = 'VOUCHER'
		AND    ct.AEntity2Key = #VoucherLines.VoucherKey
		AND    ct.CashTransactionLineKey = #VoucherLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0	
		),0)

	-- Add the AB reversals when posting the real invoices
	UPDATE #VoucherLines
	SET    #VoucherLines.AlreadyReversed = #VoucherLines.AlreadyReversed + ISNULL((
		SELECT SUM(ct.Debit)
		FROM   tCashTransaction ct (NOLOCK)
			LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
		WHERE  ct.Entity = 'VOUCHER'
		AND    ct.EntityKey = #VoucherLines.VoucherKey
		AND    ct.AEntity = 'CREDITCARD'
		AND    ct.AEntityKey = @VoucherCCKey
		AND    ct.CashTransactionLineKey = #VoucherLines.LineKey
		AND    ISNULL(ctu.Unpost, 0) = 0
		),0)
	
	-- and check the temp table
	UPDATE #VoucherLines
	SET    #VoucherLines.AlreadyReceived = #VoucherLines.AlreadyReceived + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'PAYMENT'
		AND    AEntity = 'CREDITCARD'
		AND    AEntityKey = @VoucherCCKey
		AND    AEntity2 = 'VOUCHER'
		AND    AEntity2Key = #VoucherLines.VoucherKey
		AND    CashTransactionLineKey = #VoucherLines.LineKey
		),0)

	UPDATE #VoucherLines
	SET    #VoucherLines.AlreadyReversed = #VoucherLines.AlreadyReversed + ISNULL((
		SELECT SUM(Debit)
		FROM   #tCashTransaction (NOLOCK)
		WHERE  Entity = 'VOUCHER'
		AND    EntityKey = #VoucherLines.VoucherKey
		AND    AEntity = 'CREDITCARD'
		AND    AEntityKey = @VoucherCCKey
		AND    CashTransactionLineKey = #VoucherLines.LineKey
		),0)

	--select * from #VoucherLines

    DECLARE @ABAlreadyReceived money 
    DECLARE @VoucherAlreadyReceived money 
    DECLARE @ABAlreadyReversed money 
    DECLARE @VoucherAlreadyReversed money 
    
	SELECT  @ABAlreadyReceived = ISNULL((
		SELECT SUM(AlreadyReceived)
		FROM   #ABLines
	),0)
	
	SELECT  @VoucherAlreadyReceived = ISNULL((
		SELECT SUM(AlreadyReceived)
		FROM   #VoucherLines
	),0)
	

	SELECT  @ABAlreadyReversed = ISNULL((
		SELECT SUM(AlreadyReversed)
		FROM   #ABLines
	),0)
	
	SELECT  @VoucherAlreadyReversed = ISNULL((
		SELECT SUM(AlreadyReversed)
		FROM   #VoucherLines
	),0)
	
	--select * from #Vouchers
	--select * from #VoucherLines
	--select * from #ABLines
	
	-- GHL 4/10/13 do this all the time, I added ABS to handle negative values
	--IF @ApplyAmount > 0
	IF 1=1
	BEGIN
		--we will apply only if AlreadyApplied < NonTaxAmount 
		UPDATE #VoucherLines
		SET    Closed = 1
		WHERE  ABS(AlreadyReceived + AlreadyReversed) >= ABS(AdvBillAmount)
	
		SELECT @ToApplyOnVouchers = SUM(AdvBillAmount - AlreadyReceived - AlreadyReversed)
		FROM   #VoucherLines
		WHERE  Closed = 0
		SELECT @ToApplyOnVouchers = ISNULL(@ToApplyOnVouchers, 0)	

		--select * from #VoucherLines
			
		IF (SELECT COUNT(*) FROM #VoucherLines WHERE Closed = 0) > 0 AND @ToApplyOnVouchers <> 0 
		BEGIN
			IF ABS(@ApplyAmount) >= ABS(@ToApplyOnVouchers)
				SELECT @IsLastVouchersApplication = 1, @VouchersApplyAmount = @ToApplyOnVouchers
			ELSE
				SELECT @IsLastVouchersApplication = 0, @VouchersApplyAmount = @ApplyAmount
			
			-- Enter the lines for the real invoices
			TRUNCATE TABLE #tApply
			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
			SELECT LineID, AdvBillAmount - AlreadyReceived - AlreadyReversed, 0
			FROM  #VoucherLines
			WHERE Closed = 0

			EXEC sptCashApplyToLines @ToApplyOnVouchers, @VouchersApplyAmount, @VouchersApplyAmount, @IsLastVouchersApplication	
 			
 			UPDATE #VoucherLines
 			SET    #VoucherLines.ToApply = b.ToApply
 			FROM   #tApply b
 			WHERE  #VoucherLines.LineID = b.LineKey 
 			
 			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
			)
			
			SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,lines.ToApply,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'CREDITCARD', @VoucherCCKey, @ABVoucherNumber, 'VOUCHER', ctl.EntityKey, Reference, 0, Debit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
				INNER JOIN #VoucherLines lines ON ctl.EntityKey = lines.VoucherKey
				AND ctl.CashTransactionLineKey = lines.LineKey
			WHERE ctl.Entity = 'VOUCHER' 
			AND   lines.Closed = 0
 			AND   lines.LinesInDB = 1

 			
 			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
			)
			
			SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,lines.ToApply,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'CREDITCARD', @VoucherCCKey, @ABVoucherNumber, 'VOUCHER', ctl.EntityKey, Reference, 0, Credit, ctl.TempTranLineKey, 1
			
			FROM #tTransaction ctl (NOLOCK)
				INNER JOIN #VoucherLines lines ON ctl.EntityKey = lines.VoucherKey
				AND ctl.TempTranLineKey = lines.LineKey
			WHERE ctl.Entity = 'VOUCHER' 
			AND   lines.Closed = 0
 			AND   lines.LinesInDB = 0
 			
			--select * from #tCashTransaction 
		END		 
		ELSE
			SELECT @VouchersApplyAmount = 0
			
		SELECT @ABApplyAmount = @ApplyAmount - @VouchersApplyAmount
	
		--select @ABApplyAmount, @IsLastABApplication
		--SELECT @ApplyAmount, @VouchersApplyAmount, @ABApplyAmount, @IsLastVouchersApplication, @IsLastABApplication
		
		--select * from #Vouchers
	    --select * from #VoucherLines
	    --select * from #ABLines
	
		IF @ABApplyAmount <> 0
		BEGIN
			-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
			)
			
			SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'CREDITCARD', @VoucherCCKey, Reference, NULL, NULL, NULL, 0, Debit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'CREDITCARD' AND EntityKey = @VoucherCCKey
			
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
				
				SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section
				
				-- specific to cash
				, 'CREDITCARD', @VoucherCCKey, Reference, NULL, NULL, NULL, 0, Debit, ctl.TempTranLineKey, 1
				
				FROM #tTransaction ctl (NOLOCK)
				WHERE Entity = 'CREDITCARD' AND EntityKey = @VoucherCCKey
					
			END
			
			SELECT @IsLastABApplication = 0
			--IF @ABAlreadyReceived + @ApplyAmount + @VoucherAlreadyReceived = @ABVoucherTotalAmount
			-- Tried this but causes problem when AB->I->R, R is applied against AB and I
			-- We would have to calc the impact of a receipt against I for the lines on the AB
			-- same scenario as Credit memos against invoices where we cannot fully relieve an invoice with CM
			IF @ABAlreadyReceived + @ABApplyAmount = @ABVoucherTotalAmount
				SELECT @IsLastABApplication = 1 
				
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT LineKey, LineAmount, AlreadyReceived
 			FROM #ABLines
 			
			EXEC sptCashApplyToLines @ABVoucherTotalAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
 			
 			--select * from #ABLines
 			--select * from #tApply
 			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.Debit = app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'PAYMENT'
			AND    #tCashTransaction.EntityKey = @PaymentKey
			AND    #tCashTransaction.AEntity = 'CREDITCARD'
			AND    #tCashTransaction.AEntityKey = @VoucherCCKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
		
		
		END					
				
	END	
		
	--select * from #ABLines
	--select * from #VoucherLines
	
	
	--@ApplyAmount < 0 tested with
	
	--AB 4000 (line 1) 6000 (line 2) 1000 taxes 4/14/2009
	--I1 2000 (line 1) 200 taxes 4/15/2009
	--R1 5000 4/16/2009
	--I2 2500 (line 1)
	--R2 = R1 VOID 4/18/2009
	--R3 11000 4/19/2009 
	
	--Also tested with R2 = R1 void on same day 4/16/2009
		
	-- GHL 4/10/13 bypass this because this is for voided payments
	-- this code may not work for credit card charges which unlike advance bills may be negative
	--IF @ApplyAmount < 0
	IF 1=2
	BEGIN
	
		-- strategy here is to apply against AB if receipts have been already applied (- reversed)
		-- then if there is something left, apply against the invoices, do not drive the invoices negative
		-- (actually they may not exist yet)
		-- then if there is something left, apply against the AB, i.e. we drive the AB negative  
		
		-- Calculate @ABApplyAmount
		
		SELECT @ABApplyAmount = @ABAlreadyReceived - @ABAlreadyReversed 
		
		
		SELECT @VouchersApplyAmount = 0
		
		IF @ABApplyAmount <> 0
		BEGIN
			-- limit to the apply amount in absolute value
			-- i.e. if ApplyAmount = -5,000 and ABApplyAmount = 10,000, limit to 5,000
			IF @ABApplyAmount > ABS(@ApplyAmount)
				SELECT @ABApplyAmount = ABS(@ApplyAmount)	
		
			SELECT @VouchersApplyAmount = ABS(@ApplyAmount) - @ABApplyAmount
			
		END 
		
		IF @VouchersApplyAmount <> 0
		BEGIN
			-- try to apply the receipt against the invoice lines 
		
			-- we will only apply if AlreadyReceived - AlreadyReversed > 0
			UPDATE #VoucherLines
			SET    Closed = 1
			WHERE  ABS(AlreadyReceived - AlreadyReversed) <= 0
			
			SELECT @ToApplyOnVouchers = SUM(AlreadyReceived + AlreadyReversed)
			FROM   #VoucherLines
			WHERE  Closed = 0
			SELECT @ToApplyOnVouchers = ISNULL(@ToApplyOnVouchers, 0)	
				
			IF (SELECT COUNT(*) FROM #VoucherLines WHERE Closed = 0) > 0 AND @ToApplyOnVouchers <> 0 
				BEGIN
					-- for now, we deal with positive numbers only
					IF @VouchersApplyAmount >= @ToApplyOnVouchers
						SELECT @VouchersApplyAmount = @ToApplyOnVouchers
					
					SELECT @IsLastVouchersApplication = 0
						
						
					-- Enter the lines for the real invoices
					TRUNCATE TABLE #tApply
					INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
					SELECT LineID, AlreadyReceived + AlreadyReversed, 0
					FROM  #VoucherLines
					WHERE Closed = 0

					EXEC sptCashApplyToLines @ToApplyOnVouchers, @VouchersApplyAmount, @VouchersApplyAmount, @IsLastVouchersApplication	
				
					-- now take negative amounts to apply
					UPDATE #VoucherLines
 					SET    #VoucherLines.ToApply = -1 * b.ToApply
 					FROM   #tApply b
 					WHERE  #VoucherLines.LineID = b.LineKey 
				
					
					INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
					)
					
					SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,lines.ToApply,0,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, 'CREDITCARD', @VoucherCCKey, @ABVoucherNumber, 'VOUCHER', ctl.EntityKey, Reference, 0, Debit, ctl.CashTransactionLineKey
					
					FROM tCashTransactionLine ctl (NOLOCK)
						INNER JOIN #VoucherLines lines ON ctl.EntityKey = lines.VoucherKey
						AND ctl.CashTransactionLineKey = lines.LineKey
					WHERE ctl.Entity = 'VOUCHER' 
					AND   lines.Closed = 0
 					AND   lines.LinesInDB = 1

		 			
 					INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey, UpdateTranLineKey
					)
					
					SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,lines.ToApply,0,ClassKey,
					Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
					DepartmentKey,DetailLineKey,Section
					
					-- specific to cash
					, 'CREDITCARD', @VoucherCCKey, @ABVoucherNumber, 'VOUCHER', ctl.EntityKey, Reference, 0, Debit, ctl.TempTranLineKey, 1
					
					FROM #tTransaction ctl (NOLOCK)
						INNER JOIN #VoucherLines lines ON ctl.EntityKey = lines.VoucherKey
						AND ctl.TempTranLineKey = lines.LineKey
					WHERE ctl.Entity = 'VOUCHER' 
					AND   lines.Closed = 0
 					AND   lines.LinesInDB = 0
					
			END			
			
		END
		
		-- Recalc the amount to apply against AB				
		SELECT @ABApplyAmount = ABS(@ApplyAmount) - @VouchersApplyAmount
		
		IF @ABApplyAmount <> 0
		BEGIN
			-- FIX REFERENCE,MEMO,DEPOSIT KEY LATER ALSO WHICH DETAILLINEKEY = check appl or invoice line
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, AEntity, AEntityKey, AReference, AEntity2, AEntity2Key, AReference2, AAmount, LineAmount, CashTransactionLineKey
			)
			
			SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section
			
			-- specific to cash
			, 'CREDITCARD', @VoucherCCKey, Reference, NULL, NULL, NULL, 0, Debit, ctl.CashTransactionLineKey
			
			FROM tCashTransactionLine ctl (NOLOCK)
			WHERE Entity = 'CREDITCARD' AND EntityKey = @VoucherCCKey
			
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
				
				SELECT CompanyKey,@PaymentPostingDate,'PAYMENT',@PaymentKey,@ReferenceNumber,GLAccountKey,0,0,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,'D',GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section
				
				-- specific to cash
				, 'CREDITCARD', @VoucherCCKey, Reference, NULL, NULL, NULL, 0, Debit, ctl.TempTranLineKey, 1
				
				FROM #tTransaction ctl (NOLOCK)
				WHERE Entity = 'CREDITCARD' AND EntityKey = @VoucherCCKey
					
			END
			
			TRUNCATE TABLE #tApply  	
 			INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
 			SELECT LineKey, LineAmount, 0
 			FROM   #ABLines (NOLOCK)		
										
			SELECT @IsLastABApplication = 0
											 
 			EXEC sptCashApplyToLines @ABVoucherTotalAmount, @ABApplyAmount, @ABApplyAmount, @IsLastABApplication	
 			
 			--select * from #tApply
 			
 			UPDATE #tCashTransaction
 			SET    #tCashTransaction.Debit = -1 * app.ToApply 
 			FROM   #tApply app
 			WHERE  #tCashTransaction.Entity = 'PAYMENT'
			AND    #tCashTransaction.EntityKey = @PaymentKey
			AND    #tCashTransaction.AEntity = 'CREDITCARD'
			AND    #tCashTransaction.AEntityKey = @VoucherCCKey
			AND    #tCashTransaction.AEntity2 IS NULL
			AND    #tCashTransaction.CashTransactionLineKey = app.LineKey
		
		
		END					
	
				
	END -- negative sales amount
				
		
		
		
	RETURN 1
GO
