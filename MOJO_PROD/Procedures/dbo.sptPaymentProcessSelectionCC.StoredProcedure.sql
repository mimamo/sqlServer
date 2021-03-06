USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentProcessSelectionCC]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentProcessSelectionCC]

	(
		@CompanyKey int,
		@VendorKey int, -- AMEX vendor, not a regular vendor, required on the UI
		@CashAccountKey int,
		@PaymentDate smalldatetime,
		@ClassKey int,
		@TotalAmount money,
		@FinanceAmount money,
		@FinanceAccountKey int,
		@NewPaymentKeys varchar(500) output -- so that we can popup payment on the UI
	)

AS --Encrypt

/*
|| 09/25/07 BSH 8.5     (9659)Added GLCompanyKey
|| 10/28/08 GHL 10.011  (38216) Added OfficeKey when creating the payment detail
|| 12/15/10 RLB 10.539  (97193) setting UnappliedPaymentAccountKey when creating payment
|| 09/14/11 GHL 10.547  Removed GLCompanyKey from parameter list and
||                      placed it in #tVoucher so that it can be used for paying credit cards 
||                      This process should create 1 payment per GLCompanyKey/VendorKey
|| 10/19/11 GHL 10.549  Cloned sptPaymentProcessSelection for Credit Cards and made modifs 
|| 10/27/11 GHL 10.549  Returning now payment key
|| 05/15/12 GHL 10.556  Removed Credit Card GL account, added vendor and gl company parameter
||                      We attempt now to create now one payment per vendor, instead of one payment per credit card 
||                      If we have vouchers with a blank GL company, they go to one payment
||                      All other vouchers with a gl company go to another single payment
|| 05/16/12 GHL 10.556  Now we create one payment per gl company, removed gl company parameter 
|| 08/17/12 GHL 10.559  Added TotalAmount to pay, returning now several payment keys 
|| 09/28/12  RLB 10.560  Add MultiCompanyGLClosingDate preference check
|| 03/05/13 GHL 10.565  (170700) Getting now ClassKey and OfficeKey from the invoice
|| 11/21/13 GHL 10.574  Added multi currency functionality to the SP.
||                      The currency on the bank account must match the currency on the Credit Card vouchers
*/

-- #tVoucherSelect
--VoucherKey, GLCompanyKey, VendorKey, Amount, Discount

--Create Table #tVoucherSelect (VoucherKey int, GLCompanyKey int NULL, VendorKey int NULL, Amount money, Discount money)
--insert #tVoucherSelect values (2, NULL, NULL, 1000, 0)
--insert #tVoucherSelect values (1, NULL, NULL, 2000, 0)

Create Table #tVoucher (VoucherKey int, GLCompanyKey int NULL, VendorKey int NULL
		,Amount money, Discount money, CurrencyID varchar(10) null)

insert #tVoucher (VoucherKey, Amount, Discount)
select VoucherKey, Amount, Discount
from   #tVoucherSelect

Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @CurKey int
Declare @GLClosedDate smalldatetime
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @RetVal int
Declare @DiscountAccountKey int
Declare @OpenAmount money
Declare @ExpenseAccountKey int
Declare @UnappliedPaymentAccountKey int
Declare @UnappliedAmount money
Declare @Amount money
Declare @Discount money
Declare @PaymentAddressKey int
Declare @Error int
DECLARE @MultiCurrency int
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

Declare @PayToName varchar(300)
Declare @PayToAddress1 varchar(300)
Declare @PayToAddress2 varchar(300)
Declare @PayToAddress3 varchar(300)
Declare @PayToAddress4 varchar(300)
Declare @PayToAddress5 varchar(300)
Declare @Memo varchar(500)
Declare @OfficeKey int
Declare @GLCompanyKey int
Declare @CCCClassKey int

declare @kErrClosedDate int			select @kErrClosedDate = -1
declare @kErrGLAccount int			select @kErrGLAccount = -2
declare @kErrVoucherOverApply int	select @kErrVoucherOverApply = -3
declare @kErrZeroAmount int			select @kErrZeroAmount = -4
declare @kErrTotalAmount int		select @kErrTotalAmount = -5
declare @kErrCurrency int			select @kErrCurrency = -6
declare @kErrUnexpected int			select @kErrUnexpected = -99	

Select
	 @RequireAccounts = ISNULL(RequireGLAccounts, 0)
	,@PostToGL = ISNULL(PostToGL, 0)
	,@GLClosedDate = GLClosedDate
	,@DiscountAccountKey = ISNULL(DiscountAccountKey, 0)
	,@UnappliedPaymentAccountKey = UnappliedPaymentAccountKey
	,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
	,@MultiCurrency = isnull(MultiCurrency, 0)
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey
	

if @UseMultiCompanyGLCloseDate = 0	
	if not @GLClosedDate is null
		if @PaymentDate < @GLClosedDate
			return @kErrClosedDate 
		

if @PostToGL = 1
BEGIN
	if ISNULL(@CashAccountKey, 0) = 0
		return @kErrGLAccount 
		
	Select @CurKey = MIN(ISNULL(v.APAccountKey, 0))
	from tVoucher v (NOLOCK) inner join #tVoucher vs (NOLOCK) on v.VoucherKey = vs.VoucherKey

	if @CurKey = 0
		return @kErrGLAccount 
END

Select 
	@PayToName = CompanyName,
	@PaymentAddressKey = ISNULL(PaymentAddressKey, DefaultAddressKey),
	@Memo = DefaultMemo
From tCompany (NOLOCK) 
Where CompanyKey = @VendorKey
		
--Initialize Address
SELECT	@PayToAddress1 = NULL,
		@PayToAddress2 = NULL,
		@PayToAddress3 = NULL,
		@PayToAddress4 = NULL,
		@PayToAddress5 = NULL
		
Select 
	@PayToAddress1 = Address1,
	@PayToAddress2 = Address2,
	@PayToAddress3 = Address3,
	@PayToAddress4 = ISNULL(City, '') + ', ' + ISNULL(State, '') + ' ' + ISNULL(PostalCode, ''),
	@PayToAddress5 = Country
From tAddress (NOLOCK) 
Where AddressKey = @PaymentAddressKey
	
	
if @PayToAddress2 is null
	if @PayToAddress3 is null
	BEGIN
		Select @PayToAddress2 = @PayToAddress4
		Select @PayToAddress3 = @PayToAddress5
		Select @PayToAddress4 = NULL, @PayToAddress5 = NULL 
	END
	ELSE
	BEGIN
		Select @PayToAddress2 = @PayToAddress3
		Select @PayToAddress3 = @PayToAddress4
		Select @PayToAddress4 = @PayToAddress5
		Select @PayToAddress5 = NULL
	END
ELSE
BEGIN
	if @PayToAddress3 is null
	BEGIN
		Select @PayToAddress3 = @PayToAddress4
		Select @PayToAddress4 = @PayToAddress5
		Select @PayToAddress5 = NULL
	END
END


update #tVoucher
set    #tVoucher.GLCompanyKey = v.GLCompanyKey
       ,#tVoucher.CurrencyID = v.CurrencyID
from   tVoucher v (nolock)
where  #tVoucher.VoucherKey = v.VoucherKey

-- for looping, need GLCompanyKey = 0	
update #tVoucher
set    #tVoucher.GLCompanyKey = isnull(#tVoucher.GLCompanyKey, 0)

-- add check for multi company gl close date
if @UseMultiCompanyGLCloseDate = 1
BEGIN
	select @GLCompanyKey = -1
	while (1=1)
	begin
		Select @GLCompanyKey = Min(DISTINCT(GLCompanyKey)) from #tVoucher 
		Where GLCompanyKey > @GLCompanyKey
	
		if @GLCompanyKey is null
			break
		if @GLCompanyKey > 0
		begin
			Select 
				@GLClosedDate = GLCloseDate
			From 
				tGLCompany (nolock)
			Where
				GLCompanyKey = @GLCompanyKey
			
			if @PaymentDate < @GLClosedDate
			return @kErrClosedDate
		end
	end

END

declare @CashAccountCurrency varchar(10)
select @CashAccountCurrency = CurrencyID 
from tGLAccount (nolock)
where CompanyKey = @CompanyKey
and   GLAccountKey = @CashAccountKey 

--select * from #tVoucher
--select @CashAccountCurrency

if exists (select 1 from #tVoucher where isnull(CurrencyID, '') <> isnull(@CashAccountCurrency, ''))
	return @kErrCurrency 

Select @Amount = Sum(Amount) from #tVoucher 
Select @Amount = isnull(@Amount, 0) + isnull(@FinanceAmount, 0)
if @TotalAmount = 0
	return @kErrZeroAmount 
-- TotalAmount should be greater or equal to Amount, cannot be less
if Abs(@TotalAmount) < Abs(@Amount)
	return @kErrTotalAmount

select @UnappliedAmount = @TotalAmount - @Amount

declare @NewPaymentKey int
declare @PaymentGLCompanyKey int
declare @FinanceChargeDone int		select @FinanceChargeDone = 0
declare @UnappliedAmountDone int	select @UnappliedAmountDone = 0

select @NewPaymentKeys = ''

begin transaction

select @GLCompanyKey = -1
while (1=1)
begin
	select @GLCompanyKey = min(GLCompanyKey)
	from   #tVoucher
	where  GLCompanyKey > @GLCompanyKey

	if @GLCompanyKey is null
		break

	if @GLCompanyKey = 0
		select @PaymentGLCompanyKey = null
	else
		select @PaymentGLCompanyKey = @GLCompanyKey

	-- get the exchange rate 
	if @MultiCurrency = 1 and isnull(@CashAccountCurrency, '') <> ''
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CashAccountCurrency, @PaymentDate, @ExchangeRate output, @RateHistory output
	else
		select @ExchangeRate = 1

	INSERT tPayment
		( CompanyKey, CashAccountKey, ClassKey, PaymentDate, PostingDate, VendorKey, PayToName, PayToAddress1, PayToAddress2, PayToAddress3,  PayToAddress4
		, Memo, GLCompanyKey, UnappliedPaymentAccountKey, CurrencyID, ExchangeRate)
		VALUES
		( @CompanyKey, ISNULL(@CashAccountKey, 0), @ClassKey, @PaymentDate, @PaymentDate, @VendorKey, @PayToName, @PayToAddress1, @PayToAddress2, @PayToAddress3, @PayToAddress4
		, @Memo, @PaymentGLCompanyKey, @UnappliedPaymentAccountKey, @CashAccountCurrency, @ExchangeRate)
		
	select @Error = @@ERROR, @NewPaymentKey = @@IDENTITY

	if @Error <> 0 
	begin
		rollback transaction 
		return @kErrUnexpected 
	end
	
	if len(@NewPaymentKeys) = 0
		select @NewPaymentKeys = convert(varchar(500), @NewPaymentKey)
	else
		select @NewPaymentKeys = @NewPaymentKeys + '|' + convert(varchar(500), @NewPaymentKey)	
	
	--select @NewPaymentKeys

	Select @CurKey = -1
	while 1=1
	BEGIN
		Select @CurKey = min(VoucherKey) 
		from #tVoucher 
		Where VoucherKey > @CurKey
		And GLCompanyKey = @GLCompanyKey 

		if @CurKey is null
			break
	
		Select
				@Amount = Amount,
				@Discount = Discount
		from	#tVoucher
		Where	VoucherKey = @CurKey
		
		Select @ExpenseAccountKey = APAccountKey
			, @OpenAmount = OpenAmount 
			,@OfficeKey = OfficeKey
			,@CCCClassKey = ClassKey
		from vVoucher Where VoucherKey = @CurKey
		if @Amount + @Discount > @OpenAmount 
		begin
			rollback transaction 
			return @kErrVoucherOverApply 
		end

		
		INSERT tPaymentDetail
			( PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, DiscAmount, Amount, OfficeKey )
		VALUES
			( @NewPaymentKey, ISNULL(@ExpenseAccountKey, 0), @CCCClassKey, @CurKey, NULL, 0, 0, @Discount, @Amount, @OfficeKey )
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return @kErrUnexpected 
			end

		exec sptVoucherUpdateAmountPaid @CurKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return @kErrUnexpected 
		end

	END -- end VoucherKey loop
	
	-- only if it was not inserted yet 
	if @FinanceChargeDone = 0 and isnull(@FinanceAmount, 0) > 0 and isnull(@FinanceAccountKey, 0) > 0 
	begin

		INSERT tPaymentDetail
			( PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, DiscAmount, Amount, OfficeKey )
		VALUES
			( @NewPaymentKey, @FinanceAccountKey, @ClassKey, NULL, 'Late Fee/Finance Charge', 0, 0, 0, @FinanceAmount, NULL )
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return @kErrUnexpected 
			end
			
		select @FinanceChargeDone = 1
	end

	select @Amount = (Select ISNULL(Sum(Amount), 0) from tPaymentDetail (nolock) Where PaymentKey = @NewPaymentKey)
	
	if @UnappliedAmountDone = 0 And @UnappliedAmount <> 0
	begin 
		select @Amount = @Amount + @UnappliedAmount

		select @UnappliedAmountDone = 1
	end

	Update tPayment
	Set PaymentAmount = @Amount
	Where PaymentKey = @NewPaymentKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return @kErrUnexpected 
	end

end -- GLCompanyKey loop

commit transaction
	
return 1
GO
