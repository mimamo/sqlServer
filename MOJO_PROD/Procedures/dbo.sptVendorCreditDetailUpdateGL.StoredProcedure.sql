USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailUpdateGL]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailUpdateGL]
	@VendorCreditDetailKey int,
	@VendorCreditKey int,
	@GLAccountKey int,
	@ClassKey int,
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@Amount money

AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money

Select @CreditAmt = CreditAmount from tVendorCredit (NOLOCK) Where VendorCreditKey = @VendorCreditKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VendorCreditDetailKey <> @VendorCreditDetailKey and VoucherKey is null

if @ApplAmt + @Amount > @CreditAmt
	return -1
	
	
	UPDATE
		tVendorCreditDetail
	SET
		VendorCreditKey = @VendorCreditKey,
		GLAccountKey = @GLAccountKey,
		ClassKey = @ClassKey,
		Description = @Description,
		Quantity = @Quantity,
		UnitAmount = @UnitAmount,
		Amount = @Amount
	WHERE
		VendorCreditDetailKey = @VendorCreditDetailKey 

	RETURN 1
GO
