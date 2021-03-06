USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailUpdate]
	@VendorCreditDetailKey int,
	@VendorCreditKey int,
	@VoucherKey int,
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@Amount money

AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money

	Select @CreditAmt = CreditAmount from tVendorCredit (NOLOCK) Where VendorCreditKey = @VendorCreditKey
	Select @ApplAmt = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is not null and VendorCreditDetailKey <> @VendorCreditDetailKey

	if @ApplAmt + @Amount > @CreditAmt
		return -1

	Declare @VoucherTotal money
	Declare @VoucherAmt money

	Select @VoucherTotal = (Select ISNULL(sum(Amount), 0) + ISNULL(sum(DiscAmount), 0) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey) +
		(Select ISNULL(sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VoucherKey = @VoucherKey and VendorCreditDetailKey <> @VendorCreditDetailKey and VoucherKey is not null )
		
	Select @VoucherAmt = VoucherTotal from tVoucher (nolock) Where VoucherKey = @VoucherKey
	if @VoucherAmt < @VoucherTotal + @Amount
		return -2

	UPDATE
		tVendorCreditDetail
	SET
		VendorCreditKey = @VendorCreditKey,
		VoucherKey = @VoucherKey,
		Description = @Description,
		Quantity = @Quantity,
		UnitAmount = @UnitAmount,
		Amount = @Amount
	WHERE
		VendorCreditDetailKey = @VendorCreditDetailKey 
		
	exec sptVoucherUpdateAmountPaid @VoucherKey

	RETURN 1
GO
