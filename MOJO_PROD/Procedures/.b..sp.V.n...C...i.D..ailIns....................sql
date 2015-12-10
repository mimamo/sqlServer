USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailInsert]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailInsert]
	@VendorCreditKey int,
	@VoucherKey int,
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@Amount money,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money

Select @CreditAmt = CreditAmount from tVendorCredit (NOLOCK) Where VendorCreditKey = @VendorCreditKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is not null

if @ApplAmt + @Amount > @CreditAmt
	return -1
	
	Declare @VoucherTotal money
	Declare @VoucherAmt money

	Select @VoucherTotal = (Select ISNULL(sum(Amount), 0) + ISNULL(sum(DiscAmount), 0) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey) +
		(Select ISNULL(sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VoucherKey = @VoucherKey and VoucherKey is not null )
		
	Select @VoucherAmt = VoucherTotal from tVoucher (nolock) Where VoucherKey = @VoucherKey
	if @VoucherAmt < @VoucherTotal + @Amount
		return -2

	
	INSERT tVendorCreditDetail
		(
		VendorCreditKey,
		GLAccountKey,
		ClassKey,
		VoucherKey,
		Description,
		Quantity,
		UnitAmount,
		Amount
		)

	VALUES
		(
		@VendorCreditKey,
		NULL,
		NULL,
		@VoucherKey,
		@Description,
		@Quantity,
		@UnitAmount,
		@Amount
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptVoucherUpdateAmountPaid @VoucherKey

	RETURN 1
GO
