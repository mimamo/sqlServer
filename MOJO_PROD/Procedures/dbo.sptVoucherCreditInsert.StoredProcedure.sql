USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCreditInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCreditInsert]
	@VoucherKey int,
	@CreditVoucherKey int,
	@Description varchar(500),
	@Amount money
AS --Encrypt

/*
	|| When     Who  Rel       What
	|| 01/13/12 GHL  10.5.5.2  (135065) Added checking of sign of VoucherTotal on both VoucherKey/CreditVoucherKey
*/

Declare @VoucherTotal money, @VoucherAmt money
Declare @CreditAmt as money, @ApplAmt as money

select @VoucherTotal = VoucherTotal from tVoucher (nolock) where VoucherKey = @CreditVoucherKey
if @VoucherTotal >= 0
	return -1

Select @CreditAmt = ABS(VoucherTotal) from tVoucher (NOLOCK) Where VoucherKey = @CreditVoucherKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tVoucherCredit (NOLOCK) Where VoucherKey = @CreditVoucherKey

if @ApplAmt + @Amount > @CreditAmt
	return -1
	
select @VoucherTotal = VoucherTotal from tVoucher (nolock) where VoucherKey = @VoucherKey
if @VoucherTotal < 0
	return -2

Select @VoucherTotal = ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0)
	from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey
		
if @VoucherTotal - @Amount < 0
	return -2

	BEGIN TRAN
	
	INSERT tVoucherCredit
		(
		VoucherKey,
		CreditVoucherKey,
		Description,
		Amount
		)

	VALUES
		(
		@VoucherKey,
		@CreditVoucherKey,
		@Description,
		@Amount
		)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END	
		
	exec sptVoucherUpdateAmountPaid @VoucherKey
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END	
	
	exec sptVoucherUpdateAmountPaid @CreditVoucherKey
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END	

	COMMIT TRAN
		
	RETURN 1
GO
