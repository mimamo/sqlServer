USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxCheck]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxCheck]
	(
		@InvoiceKey int
	)
AS -- Encrypt

/*
|| When     Who Rel   What
|| 05/01/07 GHL 8.5  Creation for enhancement 6523.
|| 09/30/09 GHL 10.5 Using now tInvoiceTax instead of tInvoice LineTax
*/
	-- Please note:
	-- Sales Tax 1 on Header: SalesTaxKey but SalesTax1Amount
	-- Sales Tax 2 on Header: SalesTax2Key and SalesTax2Amount

	SET NOCOUNT ON 
	
	DECLARE @AdvanceBill int, @SalesTaxKey INT, @SalesTax1Key INT, @SalesTax2Key INT
	
	SELECT @SalesTax1Key = SalesTaxKey
		   ,@SalesTax2Key = SalesTax2Key
		   ,@AdvanceBill = AdvanceBill 
	FROM   tInvoice (NOLOCK) 
	WHERE  InvoiceKey = @InvoiceKey
	
	-- Check if anything to check
	IF @AdvanceBill = 0 
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM tInvoiceAdvanceBillTax (NOLOCK) WHERE InvoiceKey = @InvoiceKey)
			RETURN 1
	END

	IF @AdvanceBill = 1 
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM tInvoiceAdvanceBillTax (NOLOCK) WHERE AdvBillInvoiceKey = @InvoiceKey)
			RETURN 1
	END
		
	IF @AdvanceBill = 0
		
	DELETE tInvoiceAdvanceBillTax
	WHERE  InvoiceKey = @InvoiceKey
	AND    SalesTaxKey NOT IN (
		SELECT @SalesTax1Key 
			UNION ALL
		SELECT @SalesTax2Key
			UNION ALL
		SELECT it.SalesTaxKey
		FROM   tInvoiceTax it (NOLOCK) 
		WHERE  it.InvoiceKey = @InvoiceKey 				
		AND    it.Type = 3
		)

	ELSE
	
	DELETE tInvoiceAdvanceBillTax
	WHERE  AdvBillInvoiceKey = @InvoiceKey
	AND    SalesTaxKey NOT IN (
		SELECT @SalesTax1Key 
			UNION ALL
		SELECT @SalesTax2Key
			UNION ALL
		SELECT it.SalesTaxKey
		FROM   tInvoiceTax it (NOLOCK) 
		WHERE  it.InvoiceKey = @InvoiceKey 				
		AND    it.Type = 3
		)
		
	RETURN 1
GO
