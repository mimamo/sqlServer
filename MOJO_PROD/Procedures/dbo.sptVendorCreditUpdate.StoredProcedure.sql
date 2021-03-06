USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditUpdate]
	@VendorCreditKey int,
	@CompanyKey int,
	@VendorKey int,
	@CreditDate smalldatetime,
	@ClassKey int,
	@APAccountKey int,
	@CreditAmount money,
	@Memo varchar(500),
	@Posted tinyint

AS --Encrypt


Declare @ApplAmt1 as money, @ApplAmt2 as money

Select @ApplAmt1 = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is null
Select @ApplAmt2 = ISNULL(Sum(Amount), 0) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is not null


if @CreditAmount < @ApplAmt1 or @CreditAmount < @ApplAmt2
	return -1
	
	UPDATE
		tVendorCredit
	SET
		CompanyKey = @CompanyKey,
		VendorKey = @VendorKey,
		CreditDate = @CreditDate,
		ClassKey = @ClassKey,
		APAccountKey = @APAccountKey,
		CreditAmount = @CreditAmount,
		Memo = @Memo,
		Posted = @Posted
	WHERE
		VendorCreditKey = @VendorCreditKey 

	RETURN 1
GO
