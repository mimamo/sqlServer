USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateTaxes]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineUpdateTaxes]
	(
	@InvoiceLineKey INT
	,@InvoiceKey INT
	,@SalesTaxAmount MONEY
	,@SalesTax1Amount MONEY
	,@SalesTax2Amount MONEY
	)	 
AS
	SET NOCOUNT ON
	
	UPDATE tInvoiceLine
	SET    SalesTaxAmount = @SalesTaxAmount -- this contains @SalesTax1Amount + @SalesTax2Amount + other taxes
	      ,SalesTax1Amount = @SalesTax1Amount
	      ,SalesTax2Amount = @SalesTax2Amount
	WHERE  InvoiceLineKey = @InvoiceLineKey
	
	EXEC sptInvoiceRollupAmounts @InvoiceKey
	
	RETURN 1
GO
