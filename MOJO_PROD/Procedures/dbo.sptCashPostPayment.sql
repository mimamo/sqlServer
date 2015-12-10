USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostPayment]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostPayment]
	(
		@CompanyKey int
		,@PaymentKey int
		,@CreateTemp int = 0	-- Can be used for testing	
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 05/07/09 GHL 10.024 Added reading of Unapplied Account from pref (Third Degree testing)
|| 05/08/09 GHL 10.024 Changed setting of LastApplication flag (after Third Degree testing)
||                     Changed: IF @AlreadyApplied + @ApplyAmount + @DiscountAmount  >= @VoucherAmount
||                     to: IF @AlreadyApplied + @ApplyAmount + @DiscountAmount  = @VoucherAmount
||                     This was a problem when we have Payment + voided Payment + new Payment
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
|| 03/27/12 GHL 10.554 Made changes for ICT 
|| 07/03/12 GHL 10.557 Added call to spGLPostICTCreateDTDF for Inter Company Transactions
|| 07/03/12 GHL 10.557 Added tCashTransaction.ICTGLCompanyKey
|| 12/7/12  GHL 10.563 Taking now vouchers applied to credit cards regardless of dates
||                     The date on the credit card is the only valid one 
|| 08/07/13 GHL 10.571 Added Multi Currency stuff
|| 03/26/14 GHL 10.578 Added handling of tPreference.CreditCardPayment (the case when a credit card is a payment)
|| 04/14/14 GHL 10.579 (212533) The discount amount is now inserted by office (note: the payment details also are)
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
DECLARE @kErrInvalidGLAcct INT					SELECT @kErrInvalidGLAcct = -1
DECLARE @kErrInvalidDiscountAcct INT			SELECT @kErrInvalidDiscountAcct = -2
DECLARE @kErrInvalidUnappliedAcct INT			SELECT @kErrInvalidUnappliedAcct = -3
DECLARE @kErrCheckNumberMissing INT				SELECT @kErrCheckNumberMissing = -4

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Check Number '
DECLARE @kMemoDiscount VARCHAR(100)				SELECT @kMemoDiscount = 'Discounts taken from Check Number '
DECLARE @kMemoUnappliedPay VARCHAR(100)			SELECT @kMemoUnappliedPay = 'Unapplied amount from Check Number ' 

-- Also declared in spGLPostInvoice
DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionICT int						SELECT @kSectionICT = 8
DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

-- Vars for tPreference
Declare @PostToGL tinyint
Declare @RequireAccounts tinyint
Declare @GLClosedDate smalldatetime
Declare @DiscountAccountKey int
Declare @UnappliedPaymentAccountKey int
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  
		,@CreditCardPayment int

-- Vars for payment info
Declare @CashAccountKey int
Declare @UnappliedAccountKey int
Declare @PaymentAmount money
Declare @UnappliedAmount money
Declare @DiscountAmount money
Declare @DetailAmount money
Declare @CheckNumber varchar(100)
Declare @Amount money
Declare @Posted tinyint
Declare @VendorKey int
Declare @OpeningTransaction tinyint

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
 		 
	Select
		@RequireAccounts = ISNULL(RequireGLAccounts, 0)
		,@PostToGL = ISNULL(PostToGL, 0)
		,@GLClosedDate = GLClosedDate
		,@DiscountAccountKey = ISNULL(DiscountAccountKey, 0)
		,@UnappliedPaymentAccountKey = ISNULL(UnappliedPaymentAccountKey, 0)
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey
		,@CreditCardPayment = isnull(CreditCardPayment, 0)  
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey

	Select
		@GLCompanyKey = GLCompanyKey
		,@PaymentAmount = PaymentAmount
		,@TransactionDate = dbo.fFormatDateNoTime(PostingDate)
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

	IF @UnappliedAccountKey = 0
		SELECT @UnappliedAccountKey = @UnappliedPaymentAccountKey
	
	Select @DetailAmount = ISNULL(Sum(Amount), 0) 
	from tPaymentDetail (nolock) 
	Where PaymentKey = @PaymentKey
	And   isnull(Prepay, 0) = 0 -- do not include the prepayments
	
	Select @UnappliedAmount = @PaymentAmount - @DetailAmount

	Select @DiscountAmount = ISNULL(Sum(DiscAmount), 0) 
	from tPaymentDetail (nolock) 
	Where PaymentKey = @PaymentKey
	
	-- These should not change
	Select	@Entity = 'PAYMENT'
			,@EntityKey = @PaymentKey
			,@Reference = @CheckNumber
			,@SourceCompanyKey = @VendorKey
			,@DepositKey = NULL 			
	-- TransactionDate, ProjectKey, GLCompanyKey, ClassKey, ClientKey already set
	
	/*
	* Insert the header Amount
	*/
	
	SELECT @PostSide = 'C'
	      ,@GLAccountKey = @CashAccountKey
		  ,@GLAccountErrRet = @kErrInvalidGLAcct 
		  ,@Amount = @PaymentAmount
		  ,@Memo = @kMemoHeader + @CheckNumber, @Section = @kSectionHeader  
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
		  		
	exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		--,AEntity,AEntityKey,AReference, AEntity2,AEntity2Key,AReference2, AAmount,LineAmount,CashTransactionLineKey
		,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL

	/*
	* Insert the discount amount if there is one
	*/
	SELECT @PostSide = 'C'
		      ,@GLAccountKey = @DiscountAccountKey
			  ,@GLAccountErrRet = @kErrInvalidDiscountAcct 
			  ,@Amount = @DiscountAmount, @Section = @kSectionHeader 
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL, @DepositKey = NULL

	if ISNULL(@DiscountAmount, 0) <> 0
	Begin
		/* we must now pull the Office from the voucher 	  		
		SELECT @PostSide = 'C'
		      ,@GLAccountKey = @DiscountAccountKey
			  ,@GLAccountErrRet = @kErrInvalidDiscountAcct 
			  ,@Amount = @DiscountAmount, @Section = @kSectionHeader 
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL, @DepositKey = NULL
			  		
		exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		--,AEntity,AEntityKey,AReference, AEntity2,AEntity2Key,AReference2, AAmount,LineAmount,CashTransactionLineKey
		,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL
		*/

		select @OfficeKey = -1

		while (1=1)
		begin
			select @OfficeKey = min(OfficeKey)
			from 
				(
				select isnull(v.OfficeKey, 0) as OfficeKey
				from  tPaymentDetail pd (nolock) 
				   inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
				where pd.PaymentKey = @PaymentKey
				and   isnull(pd.DiscAmount,0) <> 0
				) as office
			where OfficeKey > @OfficeKey

			if @OfficeKey is null
				break

			select @Amount = sum(DiscAmount)
			from tPaymentDetail pd (nolock) 
			inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
			where pd.PaymentKey = @PaymentKey
			and   isnull(pd.DiscAmount,0) <> 0
			and   isnull(v.OfficeKey, 0) = @OfficeKey

		exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

			--,AEntity,AEntityKey,AReference, AEntity2,AEntity2Key,AReference2, AAmount,LineAmount,CashTransactionLineKey
			,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL
		
		end

	End
	
	/*
	* Insert the unapplied amount if there is one
	*/
	
	if ISNULL(@UnappliedAmount, 0) <> 0
	Begin
		SELECT @PostSide = 'D'
		      ,@GLAccountKey = @UnappliedAccountKey
			  ,@GLAccountErrRet = @kErrInvalidUnappliedAcct 
			  ,@Amount = @UnappliedAmount, @Section = @kSectionHeader 
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL, @DepositKey = NULL
			  		
		exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		--,AEntity,AEntityKey,AReference, AEntity2,AEntity2Key,AReference2, AAmount,LineAmount,CashTransactionLineKey
		,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL

	End

	/*
	* Insert the lines
	*/
	
	SELECT @PostSide = 'D', @Section = @kSectionLine, @GLAccountErrRet = @kErrInvalidGLAcct, @DepositKey = NULL 
	
	-- One entry per detail line where VoucherKey is null and prepay = 0
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
		AEntity,AEntityKey,AEntity2,AEntity2Key,AAmount,LineAmount,CashTransactionLineKey
		)
	
	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		pd.GLAccountKey, ISNULL(pd.Amount, 0) + ISNULL(pd.DiscAmount, 0), 0, pd.ClassKey, 
		Left(ISNULL(pd.Description, ''), 500),
		@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide

		-- ICT
		, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
		, pd.OfficeKey, pd.DepartmentKey, pd.PaymentDetailKey, @kSectionLine ,@GLAccountErrRet
		,NULL, NULL, NULL, NULL, 0, 0, NULL
		from tPaymentDetail pd (nolock)
		Where pd.PaymentKey = @PaymentKey
		and   pd.VoucherKey is null
		and isnull(Prepay, 0) = 0


	/*
	if the voucher is not posted consider it does not exist yet
	Things could go wrong during the posting of the voucher
	so post the payment against the unapplied account
	when posting the voucher, repost the payment
	*/
	
	-- debit each line tPaymentDetail where VoucherKey is not null and prepay = 0 and voucher not posted
	-- against unapplied account
	-- same if voucher is posted but posting date > payment posting date
	-- Talked to Greg 02/23/2009. We should use the AP account on the invoice
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
		AEntity,AEntityKey,AEntity2,AEntity2Key,AAmount,LineAmount,CashTransactionLineKey
		)

	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		v.APAccountKey, ISNULL(pd.Amount, 0) + ISNULL(pd.DiscAmount, 0), 0, pd.ClassKey, 
		Left(ISNULL(pd.Description, ''), 500),
		@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide

		-- ICT
		, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
		, pd.OfficeKey, pd.DepartmentKey, pd.PaymentDetailKey, @kSectionLine ,@GLAccountErrRet
		,NULL, NULL, NULL, NULL, 0, 0, NULL
		from tPaymentDetail pd (nolock)
			inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		Where pd.PaymentKey = @PaymentKey
		--and   pd.VoucherKey is not null
		and isnull(pd.Prepay, 0) = 0
		and (
			-- Unposted AND not in the process of being posted to ACCRUAL
			(v.Posted = 0 AND v.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=0))
			-- Or posted in the future  
		 	OR (v.Posted = 1 AND v.PostingDate > @TransactionDate)
			-- or we are in the process from unposting from accrual
			OR	v.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=1)
			) 
	
	
	-- Same process if this is a credit card and CreditCardPayment = 1 (i.e. a Credit Card charge is a payment)
	IF @CreditCardPayment = 1
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
		AEntity,AEntityKey,AEntity2,AEntity2Key,AAmount,LineAmount,CashTransactionLineKey
		)

	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		v.APAccountKey, ISNULL(pd.Amount, 0) + ISNULL(pd.DiscAmount, 0), 0, pd.ClassKey, 
		Left(ISNULL(pd.Description, ''), 500),
		@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide

		-- ICT
		, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
		, pd.OfficeKey, pd.DepartmentKey, pd.PaymentDetailKey, @kSectionLine ,@GLAccountErrRet
		,NULL, NULL, NULL, NULL, 0, 0, NULL
		from tPaymentDetail pd (nolock)
			inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		Where pd.PaymentKey = @PaymentKey
		and isnull(v.CreditCard, 0) = 1
		and (v.Posted = 1
			OR
			-- Or we are in the process of posting it to Accrual
			pd.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=0)
			)	 
		AND v.PostingDate <= @TransactionDate 
		-- And we are not in the process of unposting it from Accrual
		AND	pd.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=1)
 

	--select * from #tCashTransaction
		
	-- if an voucher is on same posting date as a payment, we can consider it like before the payment,
	-- similar to the convention of the invoices linked to an Advance Bill
 	
 	-- now process the posted invoices
	DECLARE @VoucherKey INT
	DECLARE @VoucherAmount MONEY
	DECLARE @AlreadyApplied MONEY
	DECLARE @IsLastApplication INT
	DECLARE @ApplyAmount MONEY
	DECLARE @PaymentDetailKey INT
	DECLARE @VoucherCC INT -- similar to @AdvanceBill in sptCashPostCheck

	SELECT @VoucherKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @VoucherKey = MIN(pd.VoucherKey)
		FROM   tPaymentDetail pd (NOLOCK)
			INNER JOIN tVoucher v (NOLOCK) ON pd.VoucherKey = v.VoucherKey
		WHERE pd.PaymentKey = @PaymentKey 
		and isnull(pd.Prepay, 0) = 0
		and (v.Posted = 1
			OR
			-- Or we are in the process of posting it to Accrual
			pd.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=0)
			)	 
		AND v.PostingDate <= @TransactionDate 
		AND  pd.VoucherKey > @VoucherKey  
		-- And we are not in the process of unposting it from Accrual
		AND	pd.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity IN ('VOUCHER', 'CREDITCARD') AND PostingOrder = 1 AND Action=1)

		IF @VoucherKey IS NULL
			BREAK
	
		--select @VoucherKey as VoucherKey
		
		IF EXISTS (SELECT 1 FROM tVoucher (NOLOCK) WHERE VoucherKey = @VoucherKey AND  isnull(CreditCard, 0) = 1)
			AND @CreditCardPayment = 1
		CONTINUE
 				
		SELECT @PaymentDetailKey = PaymentDetailKey
			  ,@ApplyAmount = Amount
			  ,@DiscountAmount = DiscAmount
		FROM   tPaymentDetail (NOLOCK)
		WHERE  PaymentKey = @PaymentKey
		AND    VoucherKey = @VoucherKey
	

		SELECT @VoucherCC = 0
		IF EXISTS (
				SELECT v.VoucherKey
				FROM   tVoucherCC vcc (NOLOCK)
				INNER JOIN tVoucher v (NOLOCK) ON vcc.VoucherKey = v.VoucherKey
				WHERE  vcc.VoucherCCKey = @VoucherKey   
				-- They should be posted
				AND (v.Posted = 1
						OR
						-- Or we are in the process of posting it to Accrual
						v.VoucherKey IN (SELECT EntityKey FROM #tCashQueue 
							WHERE Entity = 'VOUCHER' AND PostingOrder = 1 AND Action=0)
						)	 
				-- And we are not in the process of unposting it from Accrual
				AND	v.VoucherKey NOT IN (SELECT EntityKey FROM #tCashQueue 
					WHERE Entity = 'VOUCHER' AND PostingOrder = 1 AND Action=1)		
					
				-- take them regardless of dates

				-- we consider that if the invoices have the same posting date
				-- they are BEFORE the check
				-- AND    v.PostingDate <= @TransactionDate  
			)
			SELECT @VoucherCC = 1

		--select @VoucherKey, @VoucherCC
		IF @VoucherCC = 0
		BEGIN
		
			SELECT @VoucherAmount = ISNULL(VoucherTotal, 0) -- do we have to subtract something?
				   ,@AlreadyApplied = 0
			FROM   tVoucher (NOLOCK)
			WHERE  VoucherKey =	@VoucherKey
	

			SELECT @AlreadyApplied = @AlreadyApplied + ISNULL((
				SELECT SUM(ct.Debit)
				FROM   tCashTransaction ct (NOLOCK)
						LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
				WHERE  ct.Entity = 'PAYMENT'
				AND    ct.AEntity IN ('VOUCHER', 'CREDITCARD')
				AND    ct.AEntityKey = @VoucherKey
				AND    ct.Section IN (2, 5)
				AND    ISNULL(ctu.Unpost, 0) = 0
				),0)

			SELECT @AlreadyApplied = @AlreadyApplied + ISNULL((
				SELECT SUM(Debit)
				FROM   #tCashTransaction (NOLOCK)
				WHERE  #tCashTransaction.Entity = 'PAYMENT'
				AND    #tCashTransaction.EntityKey <> @PaymentKey
				AND    #tCashTransaction.AEntity IN ('VOUCHER', 'CREDITCARD')
				AND    #tCashTransaction.AEntityKey = @VoucherKey
				AND    #tCashTransaction.Section IN (2, 5)
				),0)

			-- we also need the prepayments, they should be on the voucher
			SELECT @AlreadyApplied = @AlreadyApplied + ISNULL((
				SELECT SUM(ct.Debit)
				FROM   tCashTransaction ct (NOLOCK)
						LEFT OUTER JOIN #tCashTransactionUnpost ctu ON ct.Entity = ctu.Entity AND ct.EntityKey = ctu.EntityKey  
				WHERE  ct.Entity IN ('VOUCHER', 'CREDITCARD')
				AND    ct.EntityKey = @VoucherKey
				AND    ct.Section IN (2, 5)
				AND    ISNULL(ctu.Unpost, 0) = 0
				),0)

			SELECT @AlreadyApplied = @AlreadyApplied + ISNULL((
				SELECT SUM(Debit)
				FROM   #tCashTransaction (NOLOCK)
				WHERE  #tCashTransaction.Entity IN ('VOUCHER', 'CREDITCARD')
				AND    #tCashTransaction.EntityKey = @VoucherKey
				AND    #tCashTransaction.Section IN (2, 5)
				),0)

			IF @VoucherAmount > 0
			BEGIN
				IF @AlreadyApplied + @ApplyAmount + @DiscountAmount  = @VoucherAmount
					SELECT @IsLastApplication = 1
				ELSE
					SELECT @IsLastApplication = 0
			END
			ELSE
			BEGIN
				IF @AlreadyApplied + @ApplyAmount + @DiscountAmount  = @VoucherAmount
					SELECT @IsLastApplication = 1
				ELSE
					SELECT @IsLastApplication = 0
			END
			
			-- The application really is the sum of the 2
			SELECT 	@ApplyAmount = @ApplyAmount + @DiscountAmount
		
			--Select @VoucherAmount as VoucherAmount, @AlreadyApplied AS AlreadyApplied,  @ApplyAmount as ApplyAmount, @DiscountAmount as DicountAmount, @IsLastApplication as IsLastApplication
			
			EXEC sptCashPostPaymentFillVoucher @CompanyKey, @VoucherKey
					,@PaymentKey, @PaymentDetailKey, @ApplyAmount, @IsLastApplication
		
		END
		ELSE
		BEGIN
			-- This involves tVoucherCC records
		
			-- The application really is the sum of the 2
			SELECT 	@ApplyAmount = @ApplyAmount + @DiscountAmount

			EXEC sptCashPostPaymentFillCCVoucher @CompanyKey, @VoucherKey,@PaymentKey, @PaymentDetailKey, @ApplyAmount

		END

	END 	

	if @MultiCurrency = 1
	begin
		-- Correct before because this creates the 'Added to balance cash transaction records' record 
		EXEC sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate 

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
