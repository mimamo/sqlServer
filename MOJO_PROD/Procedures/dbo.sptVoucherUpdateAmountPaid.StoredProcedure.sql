USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateAmountPaid]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateAmountPaid]

	(
		@VoucherKey int
	)

AS

/*
|| When     Who Rel      What
|| 09/13/11 GHL 8.547    Added impact of tVoucherCC
*/


Declare @PaidAmount money, @CreditAmount money, @AppliedCredit money, @CreditCardAmount money

Select @PaidAmount = ISNULL(sum(Amount), 0) + ISNULL(sum(DiscAmount), 0) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey
Select @CreditAmount = ISNULL(sum(Amount), 0) from tVoucherCredit (NOLOCK) Where VoucherKey = @VoucherKey
Select @AppliedCredit = ISNULL(sum(Amount), 0) * -1 from tVoucherCredit (NOLOCK) Where CreditVoucherKey = @VoucherKey
Select @CreditCardAmount = ISNULL(sum(Amount), 0) from tVoucherCC (NOLOCK) Where VoucherKey = @VoucherKey

Update tVoucher
	Set AmountPaid = @PaidAmount + @CreditAmount + @AppliedCredit + @CreditCardAmount
	Where VoucherKey = @VoucherKey
GO
