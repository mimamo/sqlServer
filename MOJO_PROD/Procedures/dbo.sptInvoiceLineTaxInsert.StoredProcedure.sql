USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTaxInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineTaxInsert]
	@InvoiceLineKey int,
	@SalesTaxKey int,
	@SalesTaxAmount money,
	@oIdentity INT OUTPUT
AS -- Encrypt

	DECLARE @InvoiceLineTaxKey INT
	
	SELECT @InvoiceLineTaxKey = InvoiceLineTaxKey
	FROM  tInvoiceLineTax (NOLOCK) 
	WHERE InvoiceLineKey = @InvoiceLineKey
	AND   SalesTaxKey = @SalesTaxKey
	
	
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE tInvoiceLineTax
		SET    SalesTaxAmount = @SalesTaxAmount
		WHERE  InvoiceLineKey = @InvoiceLineKey
		AND    SalesTaxKey = @SalesTaxKey
	
		SELECT @oIdentity = @InvoiceLineTaxKey	
	END
	ELSE
	BEGIN
		INSERT tInvoiceLineTax
			(
			InvoiceLineKey,
			SalesTaxKey,
			SalesTaxAmount
			)

		VALUES
			(
			@InvoiceLineKey,
			@SalesTaxKey,
			@SalesTaxAmount
			)
		
		SELECT @oIdentity = @@IDENTITY
	END
	
	RETURN 1
GO
