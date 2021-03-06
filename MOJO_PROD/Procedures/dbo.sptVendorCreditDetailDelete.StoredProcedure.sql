USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailDelete]
	@VendorCreditDetailKey int

AS --Encrypt

Declare @VoucherKey int

	Select @VoucherKey = VoucherKey
	From tVendorCreditDetail (NOLOCK)
	WHERE
		VendorCreditDetailKey = @VendorCreditDetailKey 
		
	DELETE
	FROM tVendorCreditDetail
	WHERE
		VendorCreditDetailKey = @VendorCreditDetailKey 
		
	if not @VoucherKey is null
		exec sptVoucherUpdateAmountPaid @VoucherKey

	RETURN 1
GO
