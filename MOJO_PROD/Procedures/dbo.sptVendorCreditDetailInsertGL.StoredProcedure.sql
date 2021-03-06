USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailInsertGL]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailInsertGL]
	@VendorCreditKey int,
	@GLAccountKey int,
	@ClassKey int,
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@Amount money,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money

Select @CreditAmt = CreditAmount from tVendorCredit (NOLOCK) Where VendorCreditKey = @VendorCreditKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is null

if @ApplAmt + @Amount > @CreditAmt
	return -1

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
		@GLAccountKey,
		@ClassKey,
		NULL,
		@Description,
		@Quantity,
		@UnitAmount,
		@Amount
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
