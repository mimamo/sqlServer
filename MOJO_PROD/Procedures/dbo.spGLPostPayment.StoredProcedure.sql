USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostPayment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostPayment]
	(
		@CompanyKey int
		,@PaymentKey int
		,@Prepost int = 0		-- Can be used by Preposting as well, Preposting does not validate GL accounts 
		,@CreateTemp int = 1	-- In some cases (PrePost) do not create temp table		
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/21/07 GHL 8.4   Added protection against double postings   
  || 04/05/07 GHL 8.4   Added more protection against double postings. Bug 8799.               
  || 06/19/07 GHL 8.5   Modifications for GLCompanyKey, OfficeKey, DepartmentKey + complete rework
  || 09/17/07 GHL 8.5   Added overhead (more)
  || 03/05/08 GHL 8.505 (22514) Removed validation of GL Closing Date when preposting   
  || 06/18/08 GHL 8.513 Added logic for OpeningTransaction
  || 02/26/09 GHL 10.019 Added cash basis process
  || 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD 
  || 03/23/12 GHL 10.554 Made changes for ICT 
  || 06/27/12 GHL 10.557 Added separate errors for header and line gl accounts
  || 07/03/12 GHL 10.557 Removed call to spGLPostICTCreateDTDF (cash basis) and added to cash basis function
  || 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 01/22/13 GHL 10.564 (164475) Added error @kErrICTBlankGLAccount = -103 as a last defense protection
  ||                     against null gl accounts linked to ICT
  || 02/15/13 GHL 10.565 TrackCash = 1 now 
  || 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to validate missing offices and depts 
  ||                      This is why I execute sptGLValidatePostTemp before exiting in case of preposting
  || 08/05/13 GHL 10.571 Added Multi Currency stuff
  || 10/28/13 GHL 10.573 (194612) Cannot post a payment if there are unposted applied vouchers with OpeningTransaction = 1
  || 01/31/14 GHL 10.576 (204131) Fixed Memo for the lines because pd.Description was truncated (was isnull(v.InvoiceNumber, pd.Description))
  || 04/14/14 GHL 10.579 (212533) The discount amount is now inserted by office (note: the payment details also are)
  */
  	-- Bypass cash basis process or not
	DECLARE @TrackCash INT SELECT @TrackCash = 1
	
	IF @CreateTemp = 1
	BEGIN
		CREATE TABLE #tTransaction (
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
			HCredit money null

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,TempTranLineKey int IDENTITY(1,1) NOT NULL
			)	 
	END

	CREATE TABLE #tVoucherCCDetail (
		VoucherKey int null
		,VoucherCCKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int NULL
		)	

-- Register all constants
DECLARE @kErrInvalidHeaderAcct INT				SELECT @kErrInvalidHeaderAcct = -1
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -2
DECLARE @kErrInvalidDiscountAcct INT			SELECT @kErrInvalidDiscountAcct = -3
DECLARE @kErrInvalidUnappliedAcct INT			SELECT @kErrInvalidUnappliedAcct = -4
DECLARE @kErrCheckNumberMissing INT				SELECT @kErrCheckNumberMissing = -5

DECLARE @kErrInvalidRoundingDiffAcct int		SELECT @kErrInvalidRoundingDiffAcct = -350
DECLARE @kErrInvalidRealizedGainAcct int		SELECT @kErrInvalidRealizedGainAcct = -351

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrICTBlankGLAccount INT				SELECT @kErrICTBlankGLAccount = -103
DECLARE @kErrVoucherOpeningTransaction INT      SELECT @kErrVoucherOpeningTransaction = -104
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Check Number '
DECLARE @kMemoDiscount VARCHAR(100)				SELECT @kMemoDiscount = 'Discounts taken from Check Number '
DECLARE @kMemoUnappliedPay VARCHAR(100)			SELECT @kMemoUnappliedPay = 'Unapplied amount from Check Number ' 
DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '
DECLARE @kMemoMCRounding VARCHAR(100)			SELECT @kMemoMCRounding = 'Multi Currency Rounding Diff '

-- Also declared in spGLPostInvoice
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

-- Vars for tPreference
Declare @PostToGL tinyint
Declare @RequireAccounts tinyint
Declare @GLClosedDate smalldatetime
Declare @DiscountAccountKey int
Declare @Customizations varchar(1000)
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @MultiCurrency int
Declare @RoundingDiffAccountKey int
Declare @RealizedGainAccountKey int 

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
Declare @CurrencyID varchar(10)
Declare @ExchangeRate decimal(24,7)	

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
		,@Customizations = ISNULL(Customizations, '')
		,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)	
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey  
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
		,@CurrencyID = CurrencyID
		,@ExchangeRate = isnull(ExchangeRate, 1)
	from tPayment (nolock)
	Where PaymentKey = @PaymentKey

	Select @DetailAmount = ISNULL(Sum(Amount), 0) 
	from tPaymentDetail (nolock) 
	Where PaymentKey = @PaymentKey
	Select @UnappliedAmount = @PaymentAmount - @DetailAmount

	Select @DiscountAmount = ISNULL(Sum(DiscAmount), 0) 
	from tPaymentDetail (nolock) 
	Where PaymentKey = @PaymentKey

	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			

	END
		
	if @Posted = 1
		return @kErrPosted
	if @OpeningTransaction = 1
		Select @PostToGL = 0
	
	If @PostToGL = 0 And @RequireAccounts = 0 And @Prepost = 0
	Begin
		Update tPayment
		Set Posted = 1
		Where PaymentKey = @PaymentKey
		
		return 1
	End
		
	-- Can not post before gl close date
	if @Prepost = 0 and not @GLClosedDate is null
		if @GLClosedDate > @TransactionDate
			return @kErrGLClosedDate

	-- cannot post if there exists vouchers applied with OpeningTransaction = 1 which are unposted
	-- the reason is they are posted temporarily against AP instead of the expense accounts when posting the payment
	-- The payment should be reposted when posting the voucher (this is what happens normally) but this will not be done
	-- because the voucher has OpeningTransaction = 1 i.e. nothing happens, leaving the voucher posted permanently to AP
	-- so error out now
	if exists  (select 1 
				from tPaymentDetail pd (nolock)
				inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
				where pd.PaymentKey = @PaymentKey
				and   v.OpeningTransaction = 1
				and   v.Posted = 0)
		return @kErrVoucherOpeningTransaction 

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

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
		  ,@GLAccountErrRet = @kErrInvalidHeaderAcct 
		  ,@Amount = @PaymentAmount
		  ,@Memo = @kMemoHeader + @CheckNumber, @Section = @kSectionHeader  
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
		  		
	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate

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

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate

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

			exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate

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
			  		
		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate

	End
	
	/*
	* Insert the lines
	*/
	
	SELECT @PostSide = 'D', @Section = @kSectionLine, @GLAccountErrRet = @kErrInvalidLineAcct, @DepositKey = NULL 
	
	-- One entry per detail line
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID,ExchangeRate)
	
	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		pd.GLAccountKey, ISNULL(pd.Amount, 0) + ISNULL(pd.DiscAmount, 0), 0, pd.ClassKey, 
		case when pd.VoucherKey is null then left(isnull(pd.Description, ''), 500)
		     else Left(ISNULL(v.InvoiceNumber, ''), 500)
        end
		,@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide
		
		-- ICT
		, case when isnull(pd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else pd.TargetGLCompanyKey end
		
		, pd.OfficeKey, pd.DepartmentKey, pd.PaymentDetailKey, @kSectionLine ,@GLAccountErrRet,@CurrencyID,@ExchangeRate
		from tPaymentDetail pd (nolock)
			left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		Where pd.PaymentKey = @PaymentKey

	-- now pull the exchange rate from invoices
	if @MultiCurrency = 1
	begin
		-- need to get the exchange rate for vouchers
		update #tTransaction
		set    #tTransaction.CurrencyID = v.CurrencyID
			  ,#tTransaction.ExchangeRate = isnull(v.ExchangeRate, 1)
		from   tPaymentDetail pd (nolock)
			  ,tVoucher v (nolock) 
		where  #tTransaction.Entity = @Entity
		and    #tTransaction.EntityKey = @EntityKey
		and    #tTransaction.DetailLineKey = pd.PaymentDetailKey
		and    pd.VoucherKey = v.VoucherKey

		-- and create the realized gain/loss
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
			,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + isnull(v.InvoiceNumber, '') ,@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(pd.Amount * (isnull(v.ExchangeRate, 1) - @ExchangeRate), 2)
		From   tPaymentDetail pd (nolock)
			Inner Join tVoucher v (NOLOCK) ON pd.VoucherKey = v.VoucherKey
		Where	pd.PaymentKey = @EntityKey
	
		-- Next flip sides to make it positive like Xero does
		update #tTransaction
		set    HDebit = -1 * HCredit
			  ,HCredit = 0
			  ,PostSide = 'D'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HCredit, 0) < 0 

		update #tTransaction
		set    HCredit = -1 * HDebit
			  ,HDebit = 0
			  ,PostSide = 'C'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HDebit, 0) < 0 

		--1 Accrual Basis, 1 Force to Rounding account
		exec spGLPostCalcRoundingDiff @CompanyKey,@Entity,@EntityKey,1,1,@GLCompanyKey,@TransactionDate,@Reference, @RoundingDiffAccountKey,@RealizedGainAccountKey 
	end

	-- Create DT and DF for ICT -- 1 Accrual Basis
	exec spGLPostICTCreateDTDF @CompanyKey,@Entity,@EntityKey,1,@GLCompanyKey,@TransactionDate,@Memo,@Reference 

	-- Correct and prepared data for final insert
	EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
	-- Exit when we are not really posting, but preposting
	--IF @Prepost = 1
	--	RETURN 1

	-- Check to see that the check has a number
	IF @Prepost = 0 And (len(@CheckNumber) = 0 or @CheckNumber IS NULL)
		return @kErrCheckNumberMissing
		
	/*
	 * Validations
	 */

	--select * from #tTransaction

	Select @TransactionCount = COUNT(*) from #tTransaction Where Entity = @Entity and EntityKey = @EntityKey

	EXEC @RetVal = spGLValidatePostTemp @CompanyKey, @Entity, @EntityKey, @kErrBalance, @kErrPosted 

	-- Exit when we are not really posting, but preposting
	IF @Prepost = 1
		RETURN 1

	IF @RetVal <> 1
		RETURN @RetVal
	
	-- We have validated the accounts in case @RequireAccounts = 1, but stop here if PostToGL = 0 
	IF @PostToGL = 0
	BEGIN	
		Update tPayment
		Set Posted = 1
		Where PaymentKey = @PaymentKey
		
		RETURN 1 
	END
	
	If Exists (Select 1 From #tTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount
	
	/*
	 * Cash-Basis prep
	 */
	IF @TrackCash = 1 
	BEGIN
		
		CREATE TABLE #tCashQueue(
			Entity varchar(25) NULL,
			EntityKey int NULL,
			PostingDate smalldatetime NULL,
			QueueOrder int identity(1,1),
			PostingOrder int NULL,
			Action smallint NULL, 
			AdvanceBill int NULL
			)
		
		-- This table will track of which cash basis transactions are not valid anymore
		/*
		CREATE TABLE #tCashTransactionUnpost (
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Unpost int NULL)
		*/
		
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
			
	Declare @PostingOrder int
	Declare @Action int Select @Action = 0 -- Posting
	Declare @CashEntity varchar(25)
	Declare @CashEntityKey varchar(25)
	Declare @CashPostingDate smalldatetime
	
	exec @RetVal = sptCashQueue @CompanyKey, @Entity, @EntityKey, @TransactionDate, @Action
	 
	INSERT #tCashTransactionUnpost (Entity, EntityKey, Unpost)
	Select Entity, EntityKey, 1
	From   #tCashQueue (NOLOCK)
	Where  Action = 1 -- UnPosting
 
	-- then post
	Select @PostingOrder = -1
	While (1=1)
	Begin
		Select @PostingOrder = MIN(PostingOrder)
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder > @PostingOrder
		And    Action = 0 -- Posting
		
		If @PostingOrder is null
			break
			
		Select @CashEntity = Entity
		      ,@CashEntityKey = EntityKey
			  ,@CashPostingDate = PostingDate
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder = @PostingOrder
		And    Action = 0 -- Posting
	
		If @CashEntity IN ('VOUCHER', 'CREDITCARD')
			exec @RetVal = sptCashPostVoucher @CompanyKey, @CashEntityKey
	
		If @CashEntity = 'PAYMENT'
			exec @RetVal = sptCashPostPayment @CompanyKey, @CashEntityKey
					  	
	End
	
		If Exists (Select 1 From #tCashTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount


	END -- End Track Cash
		
				
	/*
	 * Posting!!
	 */
				
	Begin Tran

	Update tPayment
	Set Posted = 1
	Where PaymentKey = @PaymentKey
	
	if @@ERROR <> 0 
	begin
		rollback tran 
		return @kErrUnexpected
	end
	
	IF NOT EXISTS (SELECT 1 FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	BEGIN
		INSERT tTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey ,Reversed, Cleared, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey, 0, 0, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
	END
	
	--select * from #tCashTransaction

	IF @TrackCash = 1 
	BEGIN
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
				
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey ,Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey ,0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		FROM #tCashTransaction 	
		--WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
	
	END
	
	-- Protect against double postings
	IF (SELECT COUNT(*) FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	<> @TransactionCount
	BEGIN
		ROLLBACK TRAN
		RETURN @kErrUnexpected 	
	END
	
	commit tran
	
Return 1
GO
