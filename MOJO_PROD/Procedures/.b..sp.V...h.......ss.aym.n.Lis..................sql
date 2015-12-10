USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherProcessPaymentList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherProcessPaymentList]
	(
	@CompanyKey int,
	@UserKey int,
	@CCAccountKey int,
	@PaymentDate smalldatetime,
	@ClassKey int
	)

AS--Encrypt

	SET NOCOUNT ON 

/*
|| When     Who Rel      What
|| 10/27/11 GHL 10.549   Creation for SelectVouchersForPayment.mxml when UseCreditCard = 1
||                       Inserts: header + multiple tVoucherCC records
|| 11/02/11 GHL 10.549   Added creation of #tApply (needed for sptVoucherCCUpdate) 
|| 05/10/12 GHL 10.556   Creating now one credit card charge per vendor on the voucher
||                       versus one single credit card charge (for 1099 purpose)
|| 06/20/12 GHL 10.556   (145598) Fixed confusion between BoughtFromKey and BoughtByKey
|| 07/11/12 GHL 10.557   (147567) After creating a credit card charge, try to approve and post
|| 10/01/12 GHL 10.560   (155675) Since we removed tGLAccount.GLCompanyKey (we cannot assume that the GL Company
||                       comes from the Credit Card GL Account record)
||                       we need to create 1 payment per GL company and vendor
|| 02/13/13 GHL 10.565   (168596) Checking now if the voucher is over applied
|| 03/22/14 RLB 10.578   (203504) Added field for enhancement 
*/
	-- Declare other @kErr errors starting at -1 for other purpose  
	declare @kErrOverApply int                  select @kErrOverApply = -1
	declare @kErrCurrency int					select @kErrCurrency = -2
	declare @kErrVoucherBase int				select @kErrVoucherBase = -1000
	declare @kErrVoucherCCBase int				select @kErrVoucherCCBase = -2000

	-- missing vars
	declare @VoucherCCKey int
	declare @VendorKey int
	declare @GLCompanyKey int
	declare @PaymentGLCompanyKey int
	declare @DateReceived smalldatetime
	declare @TermsPercent  decimal(24,4)
	declare @TermsDays int
	declare @TermsNet int
	declare @InvoiceDate smalldatetime
	declare @PostingDate smalldatetime
	declare @DueDate smalldatetime
	declare @Description varchar(500)
	declare @ApprovedByKey int
	declare @Status smallint
	declare @VoucherTotal money
	
	declare @InvoiceNumber varchar(50)
	declare @BoughtFromKey int
	declare @BoughtFrom varchar(250)
	declare @VoucherType int -- Overhead

	-- other vars
	declare @RetVal int
	declare @OpenAmount money
	DECLARE @CurrencyID varchar(10)
	DECLARE @MultiCurrency int
	DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
	DECLARE @RateHistory int

	Create Table #tVoucher (VoucherKey int, GLCompanyKey int NULL, VendorKey int NULL
		,Amount money, Discount money, CurrencyID varchar(10) null)

	insert #tVoucher (VoucherKey, Amount, Discount)
	select VoucherKey, Amount, Discount
	from   #tVoucherSelect

	-- get defaults from credit card
	select @VendorKey = VendorKey		-- this would be a vendor like AMEX 
	      ,@CurrencyID = CurrencyID     -- currency ID on the CC GL account
	from   tGLAccount (nolock)
	where  GLAccountKey = @CCAccountKey

	Update #tVoucher
	set    VendorKey = v.VendorKey      -- this would be a regular vendor that will be @BoughtFromKey on the CC charge
		  ,GLCompanyKey = v.GLCompanyKey
		  ,CurrencyID = v.CurrencyID
	from   tVoucher v (NOLOCK) 
	Where
		   #tVoucher.VoucherKey = v.VoucherKey

	update #tVoucher 
	set    GLCompanyKey = isnull(GLCompanyKey, 0) -- for loops

	if exists (select 1 from #tVoucher where isnull(CurrencyID, '') <> isnull(@CurrencyID, ''))
	return @kErrCurrency 

	Select @MultiCurrency = isnull(MultiCurrency, 0)
	From tPreference (nolock)
	Where CompanyKey = @CompanyKey

	--select @GLCompanyKey ,@VendorKey
	--select * from #tVoucher

	-- missing data
	select @InvoiceDate = @PaymentDate
	select @PostingDate = @PaymentDate
	select @DateReceived = @PaymentDate
	select @DueDate = '1/1/2050'
	select @Description = null -- ?
	--select @ApprovedByKey = @CreatedByKey -- let sptVoucherUpdateCC decide
	select @TermsDays = 0
	select @TermsNet = 30
	select @VoucherType = 0 -- not overhead

	-- needed by sptVoucherCCUpdate, do it before begin tran
	CREATE TABLE #tApply (
        LineKey int null
        ,LineAmount money null
        ,AlreadyApplied money null
        ,ToApply money null
        ,DoNotApply int null
        )

select @GLCompanyKey = -1
while (1=1)
begin
	Select @GLCompanyKey = Min(GLCompanyKey) 
	from #tVoucher 
	Where GLCompanyKey > @GLCompanyKey
	
	if @GLCompanyKey is null
		break

	select @BoughtFromKey = -1
	while (1=1)
	begin
		select @BoughtFromKey = min(VendorKey)
		from   #tVoucher
		where  VendorKey > @BoughtFromKey
		and    GLCompanyKey = @GLCompanyKey

		if @BoughtFromKey is null
			break

		select @BoughtFrom = CompanyName from tCompany (nolock) where CompanyKey = @BoughtFromKey

		select @VoucherTotal = sum(Amount) from #tVoucher where VendorKey = @BoughtFromKey 
		select @VoucherTotal = isnull(@VoucherTotal, 0)

		-- do not process 0 credit card charges
		if @VoucherTotal = 0
			continue

		if @GLCompanyKey = 0
			select @PaymentGLCompanyKey = null
		else
			select @PaymentGLCompanyKey = @GLCompanyKey
		
		-- get the exchange rate 
		if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @PaymentDate, @ExchangeRate output, @RateHistory output
		else
			select @ExchangeRate = 1

		begin transaction

		-- now call sptVoucherUpdateCC
		exec @VoucherCCKey = sptVoucherUpdateCC 0, -- VoucherKey
			@CompanyKey,
			@UserKey, -- @CreatedByKey,
			@VendorKey,
			@InvoiceDate,
			@PostingDate,
			@InvoiceNumber,
			@DateReceived,
			@TermsPercent,
			@TermsDays,
			@TermsNet,
			@DueDate,
			@Description,
			@ApprovedByKey,
			@CCAccountKey, --@APAccountKey,
			@ClassKey,
			null, --@ProjectKey, -- because the regular UI does not allow it
			0,    --@Downloaded 
			null, --@SalesTaxKey,
			null, --@SalesTax2Key,
			0,    --@SalesTax1Amount,
			0,    --@SalesTax2Amount,
			@VoucherTotal,
			@PaymentGLCompanyKey,
			null, --@OfficeKey,
			0,    --@OpeningTransaction,
			@BoughtFromKey,
			@BoughtFrom,
			@UserKey,--@BoughtByKey,
			@VoucherType,
			0, --Receipt
			@CurrencyID,
			@ExchangeRate

		if @VoucherCCKey <= 0
		begin
			rollback transaction
			return @kErrVoucherBase + @VoucherCCKey
		end

		-- must do this in a loop because that affects AmountPaid on the vouchers
		-- also tVoucherCCDetail

		declare @Amount money
		declare @VoucherKey int
		select @VoucherKey = -1
		while (1=1)
		begin
			select @VoucherKey = min(VoucherKey)
			from   #tVoucher
			where  VoucherKey > @VoucherKey
			And    VendorKey = @BoughtFromKey 
			And    GLCompanyKey = @GLCompanyKey

			if @VoucherKey is null
				break

			select @Amount = Amount
			from   #tVoucher
			where  VoucherKey = @VoucherKey

			Select @OpenAmount = OpenAmount 
			from vVoucher Where VoucherKey = @VoucherKey
			if @Amount > @OpenAmount 
			begin
				rollback transaction 
				return @kErrOverApply
			end

			exec sptVoucherCCUpdate @VoucherCCKey, @VoucherKey, @Amount, 0 --- addend Exclude1099 field
			if @@ERROR <> 0
			begin
				rollback transaction
				return @kErrVoucherCCBase
			end
		end -- voucher loop

		commit tran

		-- Try to approve and post
		select @ApprovedByKey = ApprovedByKey from tVoucher (nolock) where VoucherKey = @VoucherCCKey

		if @ApprovedByKey = @UserKey
			select @Status = 4 -- Approved
		else 
			select @Status = 2 -- submitted to approval

		update tVoucher set Status = @Status where VoucherKey = @VoucherCCKey

		-- this is a best attempt to post, not important if the GL posting does not go through
		if @Status = 4
			exec spGLPostVoucher @CompanyKey, @VoucherCCKey 

		
	end -- Vendor loop

end -- GLCompanyKey loop

	RETURN 1
GO
