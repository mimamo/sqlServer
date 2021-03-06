USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentProcessSelection]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentProcessSelection]

	(
		@CompanyKey int,
		@CashAccountKey int,
		@PaymentDate smalldatetime,
		@ClassKey int
	)

AS --Encrypt

/*
|| 09/25/07 BSH 8.5     (9659)Added GLCompanyKey
|| 10/28/08 GHL 10.011  (38216) Added OfficeKey when creating the payment detail
|| 12/15/10 RLB 10.539  (97193) setting UnappliedPaymentAccountKey when creating payment
|| 09/14/11 GHL 10.547  Removed GLCompanyKey from parameter list and
||                      placed it in #tVoucher so that it can be used for paying credit cards 
||                      This process should create 1 payment per GLCompanyKey/VendorKey
|| 10/27/11 GHL 10.549  Capturing now @@ERROR and @@IDENTITY is same statement 
|| 02/13/12 GHL 10.552  (134308) Allowing now negative checks...like in sptPaymentProcessSelectionCC
|| 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
|| 10/03/12 GHL 10.560  Added logic for vendor's OnePaymentPerVoucher
||                      + using now #tVoucher instead of #tVoucherSelect 
|| 1/11/13  GWG 10.563  Small fix for allowing $0 payments
|| 03/05/13 GHL 10.565  (170700) Getting now ClassKey and OfficeKey from the invoice
|| 11/11/13 GHL 10.574  Added multi currency functionality to the SP.
||                      The currency on the bank account must match the currency on the vouchers
|| 03/13/13 GHL 10.578  (209392) Allowing now negative checks. Added ABS when comparing applied amounts
||                      to voucher totals 
*/

-- #tVoucher
--VoucherKey, GLCompanyKey, VendorKey, Amount, Discount

--Create Table #tVoucher (VoucherKey int, GLCompanyKey int NULL, VendorKey int NULL, OnePaymentPerVoucher int NULL
--		,Amount money, Discount money)
--insert #tVoucher values (2, NULL, NULL, 1000, 0)
--insert #tVoucher values (1, NULL, NULL, 2000, 0)

/*
First Pass

for each voucher where OnePaymentPerVoucher = 1
	create payment
	create payment detail

Second Pass

for each gl company where OnePaymentPerVoucher = 0
    for each vendor where OnePaymentPerVoucher = 0
        create payment
		for each voucher for the vendor and gl company
            create payment detail 

*/

Create Table #tVoucher (VoucherKey int, GLCompanyKey int NULL, VendorKey int NULL, OnePaymentPerVoucher int NULL
		,Amount money, Discount money, CurrencyID varchar(10) null)

insert #tVoucher (VoucherKey, Amount, Discount)
select VoucherKey, Amount, Discount
from   #tVoucherSelect

Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @CurKey int
Declare @CurVendorKey int
Declare @GLClosedDate smalldatetime
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @RetVal int
Declare @DiscountAccountKey int
Declare @NewPaymentKey int
Declare @OpenAmount money
Declare @ExpenseAccountKey int
Declare @UnappliedPaymentAccountKey int
Declare @Amount money
Declare @Discount money
Declare @PaymentAddressKey int
Declare @Error int

Declare @PayToName varchar(300)
Declare @PayToAddress1 varchar(300)
Declare @PayToAddress2 varchar(300)
Declare @PayToAddress3 varchar(300)
Declare @PayToAddress4 varchar(300)
Declare @PayToAddress5 varchar(300)
Declare @Memo varchar(500)
Declare @OfficeKey int
Declare @GLCompanyKey int			-- used for loops, i.e cannot be null
Declare @PaymentGLCompanyKey int	-- exact gl company on payment, may be null
Declare @InvoiceClassKey int
DECLARE @MultiCurrency int
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

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
			return -1
		

if @PostToGL = 1
BEGIN
	if ISNULL(@CashAccountKey, 0) = 0
		return -2
		
	Select @CurKey = MIN(ISNULL(v.APAccountKey, 0))
	from tVoucher v (NOLOCK) inner join #tVoucher vs (NOLOCK) on v.VoucherKey = vs.VoucherKey

	if @CurKey = 0
		return -2
END

Update #tVoucher
set    VendorKey = v.VendorKey
      ,GLCompanyKey = v.GLCompanyKey
	  ,CurrencyID = v.CurrencyID
from   tVoucher v (NOLOCK) 
Where
	   #tVoucher.VoucherKey = v.VoucherKey

-- for loops, we need 0 GLCompanyKey and no nulls
Update #tVoucher
set    GLCompanyKey = isnull(GLCompanyKey, 0)


Update #tVoucher
Set    #tVoucher.OnePaymentPerVoucher = vend.OnePaymentPerVoucher
From   tCompany vend (nolock)
Where  #tVoucher.VendorKey = vend.CompanyKey 

Update #tVoucher
Set    OnePaymentPerVoucher = isnull(OnePaymentPerVoucher, 0)

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
			return -1
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
	return -5  

begin transaction

--First Pass: vouchers where OnePaymentPerVoucher = 1 
select @CurKey = -1
while (1=1)
begin
	select @CurKey = min(VoucherKey) from #tVoucher
	where OnePaymentPerVoucher = 1
	and   VoucherKey > @CurKey

	if @CurKey is null
		break

	-- Just do one reading, because we only have one record to query for the whole payment
	select @GLCompanyKey = GLCompanyKey
		, @CurVendorKey = VendorKey
		, @Amount = Amount
		, @Discount = Discount
	from #tVoucher
	where VoucherKey = @CurKey

	Select 
			@PayToName = CompanyName,
			@PaymentAddressKey = ISNULL(PaymentAddressKey, DefaultAddressKey),
			@Memo = DefaultMemo
		From tCompany (NOLOCK) 
		Where CompanyKey = @CurVendorKey
		
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

		--Select @Amount = Amount from #tVoucher Where VoucherKey = @CurKey
		if isnull(@Amount, 0) = 0
		BEGIN
			rollback transaction 
			return -4
		END

		-- get the exchange rate 
		if @MultiCurrency = 1 and isnull(@CashAccountCurrency, '') <> ''
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CashAccountCurrency, @PaymentDate, @ExchangeRate output, @RateHistory output
		else
			select @ExchangeRate = 1

		-- Create a payment

		if @GLCompanyKey = 0
			select @PaymentGLCompanyKey = null
		else
			select @PaymentGLCompanyKey = @GLCompanyKey
		
		INSERT tPayment
			( CompanyKey, CashAccountKey, ClassKey, PaymentDate, PostingDate, VendorKey, PayToName, PaymentAmount
			, PayToAddress1, PayToAddress2, PayToAddress3,  PayToAddress4
			, Memo, GLCompanyKey, UnappliedPaymentAccountKey, CurrencyID, ExchangeRate)
		VALUES
			( @CompanyKey, ISNULL(@CashAccountKey, 0), @ClassKey, @PaymentDate, @PaymentDate, @CurVendorKey, @PayToName, @Amount
			, @PayToAddress1, @PayToAddress2, @PayToAddress3, @PayToAddress4
			, @Memo, @PaymentGLCompanyKey, @UnappliedPaymentAccountKey, @CashAccountCurrency, @ExchangeRate)
			
		select @Error = @@ERROR, @NewPaymentKey = @@IDENTITY

		if @Error <> 0 
		begin
			rollback transaction 
			return -99
		end

		-- create a payment detail
		Select @ExpenseAccountKey = APAccountKey
				, @OpenAmount = OpenAmount 
				, @OfficeKey = OfficeKey
				, @InvoiceClassKey = ClassKey
		from vVoucher Where VoucherKey = @CurKey
		if ABS(@Amount + @Discount) > ABS(@OpenAmount) 
		begin
			rollback transaction 
			return -3
		end

			
		INSERT tPaymentDetail
			( PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, DiscAmount, Amount, OfficeKey )
		VALUES
			( @NewPaymentKey, ISNULL(@ExpenseAccountKey, 0), @InvoiceClassKey, @CurKey, NULL, 0, 0, @Discount, @Amount, @OfficeKey )
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return -98
			end

		exec sptVoucherUpdateAmountPaid @CurKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
end

select @GLCompanyKey = -1
while (1=1)
begin
	Select @GLCompanyKey = Min(GLCompanyKey) from #tVoucher 
	Where GLCompanyKey > @GLCompanyKey
	And   OnePaymentPerVoucher = 0

	if @GLCompanyKey is null
		break
	
	Select @CurVendorKey = -1

	While 1=1
	BEGIN
		Select @CurVendorKey = Min(VendorKey) from #tVoucher 
		Where GLCompanyKey = @GLCompanyKey and VendorKey > @CurVendorKey
		And   OnePaymentPerVoucher = 0

		if @CurVendorKey is null
			break
		
		Select 
			@PayToName = CompanyName,
			@PaymentAddressKey = ISNULL(PaymentAddressKey, DefaultAddressKey),
			@Memo = DefaultMemo
		From tCompany (NOLOCK) 
		Where CompanyKey = @CurVendorKey
		
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
	
		Select @Amount = Sum(Amount) from #tVoucher Where GLCompanyKey = @GLCompanyKey and VendorKey = @CurVendorKey
		if isnull(@Amount, 0) = 0
		BEGIN
			rollback transaction 
			return -4
		END

		-- get the exchange rate 
		if @MultiCurrency = 1 and isnull(@CashAccountCurrency, '') <> ''
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CashAccountCurrency, @PaymentDate, @ExchangeRate output, @RateHistory output
		else
			select @ExchangeRate = 1

		if @GLCompanyKey = 0
			select @PaymentGLCompanyKey = null
		else
			select @PaymentGLCompanyKey = @GLCompanyKey
		
		INSERT tPayment
			( CompanyKey, CashAccountKey, ClassKey, PaymentDate, PostingDate, VendorKey, PayToName, PayToAddress1, PayToAddress2, PayToAddress3,  PayToAddress4
			, Memo, GLCompanyKey, UnappliedPaymentAccountKey, CurrencyID, ExchangeRate)
		VALUES
		( @CompanyKey, ISNULL(@CashAccountKey, 0), @ClassKey, @PaymentDate, @PaymentDate, @CurVendorKey, @PayToName, @PayToAddress1, @PayToAddress2, @PayToAddress3, @PayToAddress4
		, @Memo, @PaymentGLCompanyKey, @UnappliedPaymentAccountKey, @CashAccountCurrency, @ExchangeRate)
			
		select @Error = @@ERROR, @NewPaymentKey = @@IDENTITY

		if @Error <> 0 
		begin
			rollback transaction 
			return -99
		end

		Select @CurKey = -1
		while 1=1
		BEGIN
			Select @CurKey = min(VoucherKey) from #tVoucher 
			Where GLCompanyKey = @GLCompanyKey and VendorKey = @CurVendorKey and VoucherKey > @CurKey
		
			if @CurKey is null
				break
	
			Select
					@Amount = Amount
					,@Discount = Discount
			from	#tVoucher
			Where	VoucherKey = @CurKey
		
			Select @ExpenseAccountKey = APAccountKey
				, @OpenAmount = OpenAmount 
				, @OfficeKey = OfficeKey
				, @InvoiceClassKey = ClassKey
			from vVoucher Where VoucherKey = @CurKey
			if ABS(@Amount + @Discount) > ABS(@OpenAmount) 
			begin
				rollback transaction 
				return -3
			end

			
			INSERT tPaymentDetail
				( PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, DiscAmount, Amount, OfficeKey )
			VALUES
				( @NewPaymentKey, ISNULL(@ExpenseAccountKey, 0), @InvoiceClassKey, @CurKey, NULL, 0, 0, @Discount, @Amount, @OfficeKey )
				if @@ERROR <> 0 
				begin
					rollback transaction 
					return -98
				end

			exec sptVoucherUpdateAmountPaid @CurKey
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return -99
			end

		END -- end VoucherKey loop
	
		Update tPayment
		Set PaymentAmount = (Select ISNULL(Sum(Amount), 0) from tPaymentDetail (nolock) Where PaymentKey = @NewPaymentKey)
		Where PaymentKey = @NewPaymentKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -96
		end
	
	END -- end VendorKey loop

end -- end GLCompanyKey loop
	
commit transaction
GO
