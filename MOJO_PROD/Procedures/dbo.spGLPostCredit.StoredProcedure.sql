USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostCredit]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostCredit]
	(
	@CompanyKey int,
	@Entity varchar(25),
	@EntityKey int
	)

AS --Encrypt


/*
|| When     Who Rel     What
|| 01/16/14 GHL 10.576  Creation to handle the posting of credits with foreign currencies
||                      For each credit application, the following should be done:
||                      - create an entry for credit amount * diff of exchange rates (section 10 = MC gain)
||                      - create an adjustment of the AR/AP account on the other side for same amount (section 1 = Header)
||                      Set DetailLineKey = VoucherCreditKey or InvoiceCreditKey on both sides
*/

/* Assume done in calling sp

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


*/

DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '

declare @AP_AR_GLAccountKey int
declare @CurrencyID varchar(10)
declare @CreditExchangeRate decimal(24,7)
declare @CreditApplicationKey int
declare @RegularInvoiceKey int
declare @RegularExchangeRate decimal(24,7)
declare @RegularInvoiceNumber varchar(50)
declare @GainLossAmount money
declare @AppliedAmount money

-- Copied from tTransaction
declare		@TransactionDate smalldatetime,
			@Reference varchar (100) ,
			@GLAccountKey int,
			@Debit money,
			@Credit money,
			@ClassKey int,
			@Memo varchar (500),
			@PostSide char (1),
			@ClientKey int,
			@ProjectKey int,
			@SourceCompanyKey int,
			@GLCompanyKey int,
			@OfficeKey int,
			@DepartmentKey int,
			@DetailLineKey int,
			@Section int, 
			@Overhead tinyint,
			@ICTGLCompanyKey int,

			@ExchangeRate decimal(24,7),
			@HDebit money,
			@HCredit money,
			
			-- our work space
			@GLValid int,
			@GLAccountErrRet int,
			@GPFlag int -- General purpose flag
			
declare @MultiCurrency int
declare @RealizedGainAccountKey int

Select
		 @MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RealizedGainAccountKey = RealizedGainAccountKey  
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey

if @MultiCurrency = 0
	return 1

if @Entity = 'VOUCHER'
begin
	select @AP_AR_GLAccountKey = APAccountKey
	      ,@CurrencyID = CurrencyID
		  ,@CreditExchangeRate = isnull(ExchangeRate, 1)
	from  tVoucher (nolock)
	where VoucherKey = @EntityKey

	if isnull(@CurrencyID, '') = ''
	return 1

	select @CreditApplicationKey = -1
	while (1=1)
	begin
		select @CreditApplicationKey = min(VoucherCreditKey)
		from   tVoucherCredit (nolock)
		where  CreditVoucherKey = @EntityKey
		and    VoucherCreditKey > @CreditApplicationKey

		if @CreditApplicationKey is null
			break

		select @RegularInvoiceKey = VoucherKey
		     , @AppliedAmount = Amount
		from   tVoucherCredit (nolock)
		where  VoucherCreditKey = @CreditApplicationKey

		select @RegularExchangeRate = isnull(ExchangeRate, 1)
		      ,@RegularInvoiceNumber = InvoiceNumber
		from   tVoucher (nolock)
		where  VoucherKey =@RegularInvoiceKey


		select @GainLossAmount = isnull(@AppliedAmount * (@CreditExchangeRate - @RegularExchangeRate), 0)
		select @GainLossAmount = round(@GainLossAmount, 2)

		if @GainLossAmount <> 0
		begin
			-- capture data from the header (AR/AP account)
			select @TransactionDate = TransactionDate
				  ,@Reference = Reference
				  ,@ClassKey = ClassKey
			      ,@Memo = Memo 
			      ,@ClientKey = ClientKey
			      ,@ProjectKey = ProjectKey
			      ,@SourceCompanyKey = SourceCompanyKey
			      ,@GLCompanyKey = GLCompanyKey
			      ,@OfficeKey = OfficeKey
			      ,@DepartmentKey = DepartmentKey
			      ,@Overhead  = Overhead
			      ,@ICTGLCompanyKey = ICTGLCompanyKey
			from  #tTransaction
			where Entity = @Entity
			and   EntityKey = @EntityKey
			and   GLAccountKey = @AP_AR_GLAccountKey
			and   [Section] = 1 -- Header

			-- common to 2 transactions
			select @DetailLineKey = @CreditApplicationKey
			      ,@CurrencyID = null -- this is what we do for other applications

			select @Section = 1
			      ,@Debit = 0
			      ,@Credit = 0
				  ,@HDebit = 0
				  ,@HCredit =@GainLossAmount
				  ,@PostSide = 'C'
				  ,@GLAccountKey = @AP_AR_GLAccountKey
				  ,@GLAccountErrRet = -2 -- Invalid AP account
				  ,@ExchangeRate = 1 -- does not matter because this is a difference of exchange rates
				  ,@Memo = @Memo + ' AP Adjustment'

			INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)

			values (@CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Debit,@Credit,@ClassKey,
					@Memo,@ClientKey,@ProjectKey,@SourceCompanyKey,null,@PostSide,@GLCompanyKey,@OfficeKey,
					@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate, @HDebit, @HCredit)

			select @Section = 10
			      ,@Debit = 0
			      ,@Credit = 0
				  ,@HDebit = @GainLossAmount
				  ,@HCredit = 0 
				  ,@PostSide = 'D'
				  ,@GLAccountKey = @RealizedGainAccountKey
				  ,@GLAccountErrRet = -351 -- Invalid MC account
				  ,@ExchangeRate = 1 -- does not matter because this is a difference of exchange rates
				  ,@Memo = @kMemoRealizedGain + ' - ' + @RegularInvoiceNumber
				  ,@OfficeKey = null
				  ,@DepartmentKey = null
				  ,@ClassKey = null
				  ,@ProjectKey = null

			INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)

			values (@CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Debit,@Credit,@ClassKey,
					@Memo,@ClientKey,@ProjectKey,@SourceCompanyKey,null,@PostSide,@GLCompanyKey,@OfficeKey,
					@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate, @HDebit, @HCredit)

		end -- end amount <> 0

	end -- end credit loop

end -- end AP side
else
begin
	select @AP_AR_GLAccountKey = ARAccountKey
	      ,@CurrencyID = CurrencyID
		  ,@CreditExchangeRate = isnull(ExchangeRate, 1)
	from  tInvoice (nolock)
	where InvoiceKey = @EntityKey

	if isnull(@CurrencyID, '') = ''
	return 1

	select @CreditApplicationKey = -1
	while (1=1)
	begin
		select @CreditApplicationKey = min(InvoiceCreditKey)
		from   tInvoiceCredit (nolock)
		where  CreditInvoiceKey = @EntityKey
		and    InvoiceCreditKey > @CreditApplicationKey

		if @CreditApplicationKey is null
			break

		select @RegularInvoiceKey = InvoiceKey
		     , @AppliedAmount = Amount
		from   tInvoiceCredit (nolock)
		where  InvoiceCreditKey = @CreditApplicationKey

		select @RegularExchangeRate = isnull(ExchangeRate, 1)
		      ,@RegularInvoiceNumber = InvoiceNumber
		from   tInvoice (nolock)
		where  InvoiceKey =@RegularInvoiceKey


		select @GainLossAmount = isnull(@AppliedAmount * (@CreditExchangeRate - @RegularExchangeRate), 0)
		select @GainLossAmount = round(@GainLossAmount, 2)

		if @GainLossAmount <> 0
		begin
			-- capture data from the header (AR/AP account)
			select @TransactionDate = TransactionDate
				  ,@Reference = Reference
				  ,@ClassKey = ClassKey
			      ,@Memo = Memo 
			      ,@ClientKey = ClientKey
			      ,@ProjectKey = ProjectKey
			      ,@SourceCompanyKey = SourceCompanyKey
			      ,@GLCompanyKey = GLCompanyKey
			      ,@OfficeKey = OfficeKey
			      ,@DepartmentKey = DepartmentKey
			      ,@Overhead  = Overhead
			      ,@ICTGLCompanyKey = ICTGLCompanyKey
			from  #tTransaction
			where Entity = @Entity
			and   EntityKey = @EntityKey
			and   GLAccountKey = @AP_AR_GLAccountKey
			and   [Section] = 1 -- Header

			-- common to 2 transactions
			select @DetailLineKey = @CreditApplicationKey
			      ,@CurrencyID = null -- this is what we do for other applications

			select @Section = 1
			      ,@Debit = 0
			      ,@Credit = 0
				  ,@HDebit = @GainLossAmount
				  ,@HCredit = 0
				  ,@PostSide = 'D'
				  ,@GLAccountKey = @AP_AR_GLAccountKey
				  ,@GLAccountErrRet = -2 -- Invalid AP account
				  ,@ExchangeRate = 1 -- does not matter because this is a difference of exchange rates
				  ,@Memo = @Memo + ' AR Adjustment'

			INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)

			values (@CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Debit,@Credit,@ClassKey,
					@Memo,@ClientKey,@ProjectKey,@SourceCompanyKey,null,@PostSide,@GLCompanyKey,@OfficeKey,
					@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate, @HDebit, @HCredit)

			select @Section = 10
			      ,@Debit = 0
			      ,@Credit = 0
				  ,@HDebit = 0
				  ,@HCredit = @GainLossAmount 
				  ,@PostSide = 'C'
				  ,@GLAccountKey = @RealizedGainAccountKey
				  ,@GLAccountErrRet = -351 -- Invalid MC account
				  ,@ExchangeRate = 1 -- does not matter because this is a difference of exchange rates
				  ,@Memo = @kMemoRealizedGain + ' - ' + @RegularInvoiceNumber
				  ,@OfficeKey = null
				  ,@DepartmentKey = null
				  ,@ClassKey = null
				  ,@ProjectKey = null

			INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)

			values (@CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Debit,@Credit,@ClassKey,
					@Memo,@ClientKey,@ProjectKey,@SourceCompanyKey,null,@PostSide,@GLCompanyKey,@OfficeKey,
					@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate, @HDebit, @HCredit)

		end -- end amount <> 0

	end -- end credit loop

end -- end AR case
GO
