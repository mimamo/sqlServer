USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailTaxInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailTaxInsert]
	@VoucherDetailKey int,
	@SalesTaxKey int,
	@SalesTaxAmount money,
	@oIdentity INT OUTPUT
AS -- Encrypt

	DECLARE @VoucherDetailTaxKey INT
	
	SELECT @VoucherDetailTaxKey = VoucherDetailTaxKey
	FROM  tVoucherDetailTax (NOLOCK) 
	WHERE VoucherDetailKey = @VoucherDetailKey
	AND   SalesTaxKey = @SalesTaxKey
	
	
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE tVoucherDetailTax
		SET    SalesTaxAmount = @SalesTaxAmount
		WHERE  VoucherDetailKey = @VoucherDetailKey
		AND    SalesTaxKey = @SalesTaxKey
	
		SELECT @oIdentity = @VoucherDetailTaxKey	
	END
	
	ELSE
	BEGIN
		INSERT tVoucherDetailTax
			(
			VoucherDetailKey,
			SalesTaxKey,
			SalesTaxAmount
			)
		VALUES
			(
			@VoucherDetailKey,
			@SalesTaxKey,
			@SalesTaxAmount
			)
		
		SELECT @oIdentity = @@IDENTITY
	END
	
	RETURN 1
GO
