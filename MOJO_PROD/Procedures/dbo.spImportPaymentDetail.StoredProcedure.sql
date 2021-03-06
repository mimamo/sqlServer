USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportPaymentDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportPaymentDetail]
	@PaymentKey int,
	@ExpenseAccountNumber varchar(100),
	@ClassID varchar(50),
	@InvoiceNumber varchar(50),
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@DiscAmount money,
	@Amount money
	
AS --Encrypt
Declare @VoucherTotal money
Declare @VoucherAmt money
Declare @GLAccountKey int, @ClassKey int, @VoucherKey int, @CompanyKey int, @VendorKey int, @Status smallint

Select @CompanyKey = CompanyKey, @VendorKey = VendorKey from tPayment (nolock) Where PaymentKey = @PaymentKey

if @InvoiceNumber is not null
begin
	Select @VoucherKey = VoucherKey, @Status = Status from tVoucher (nolock) Where VendorKey = @VendorKey and InvoiceNumber = @InvoiceNumber
	
	if @VoucherKey is not null
		begin
			if @Status <> 4
				Return -5
			Select @GLAccountKey = ISNULL(APAccountKey, 0) from tVoucher (nolock) Where VoucherKey = @VoucherKey
			Select @VoucherTotal = (Select ISNULL(sum(Amount), 0) + ISNULL(sum(DiscAmount), 0) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey) +
			ISNULL((Select sum(Amount) from tVoucherCredit (nolock) Where VoucherKey = @VoucherKey), 0)
			
			Select @VoucherAmt = VoucherTotal from tVoucher (nolock) Where VoucherKey = @VoucherKey
			if @VoucherAmt < @VoucherTotal + @Amount + @DiscAmount
				return -1
		end
	else
		return -2
		
end
else
BEGIN
	Select @GLAccountKey = GLAccountKey from tGLAccount (nolock) 
		Where AccountNumber = @ExpenseAccountNumber and CompanyKey = @CompanyKey and Rollup = 0
	if @GLAccountKey is null
		return -3

END

if @ClassID is not null
begin
	Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey
	if @ClassKey is null
		return -4

end

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -4

	INSERT tPaymentDetail
		(
		PaymentKey,
		GLAccountKey,
		ClassKey,
		VoucherKey,
		Description,
		Quantity,
		UnitAmount,
		DiscAmount,
		Amount
		)

	VALUES
		(
		@PaymentKey,
		@GLAccountKey,
		@ClassKey,
		@VoucherKey,
		@Description,
		@Quantity,
		@UnitAmount,
		@DiscAmount,
		@Amount
		)
	

	if not @VoucherKey is null
		exec sptVoucherUpdateAmountPaid @VoucherKey

	Update tPayment
	Set PaymentAmount = (Select ISNULL(Sum(Amount), 0) from tPaymentDetail Where PaymentKey = @PaymentKey)
	Where PaymentKey = @PaymentKey
	
	RETURN 1
GO
