USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailTaxInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailTaxInsert]
	@PurchaseOrderDetailKey int,
	@SalesTaxKey int,
	@SalesTaxAmount money
AS -- Encrypt

	
	
	IF exists (select 1 
	FROM  tPurchaseOrderDetailTax (NOLOCK) 
	WHERE PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	AND   SalesTaxKey = @SalesTaxKey)

	BEGIN
		UPDATE tPurchaseOrderDetailTax
		SET    SalesTaxAmount = @SalesTaxAmount
		WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		AND    SalesTaxKey = @SalesTaxKey
	
	END
	
	ELSE
	BEGIN
		INSERT tPurchaseOrderDetailTax
			(
			PurchaseOrderDetailKey,
			SalesTaxKey,
			SalesTaxAmount
			)
		VALUES
			(
			@PurchaseOrderDetailKey,
			@SalesTaxKey,
			@SalesTaxAmount
			)
		
	END
	
	RETURN 1
GO
