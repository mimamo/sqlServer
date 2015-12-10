USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTaxGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineTaxGetList]
	(
	@InvoiceLineKey INT
	,@CompanyKey INT = 0
	,@FromSalesTaxTable INT = 0
	)
AS	-- Encrypt

	SET NOCOUNT ON
	
	IF @FromSalesTaxTable = 1
		-- this will be done when we come from the other sales tax popup
		SELECT st.SalesTaxKey 
			   ,st.SalesTaxName
			   ,st.TaxRate
			   ,st.PiggyBackTax
			   ,0 AS SalesTaxAmount
		FROM   tSalesTax st (NOLOCK)	
		WHERE  st.CompanyKey = @CompanyKey
		-- regardless of Active status because could be already on a voucher line
	ELSE
	
		SELECT ilt.*
			   ,st.SalesTaxName
			   ,st.TaxRate
			   ,st.PiggyBackTax
		FROM   tInvoiceLineTax ilt (NOLOCK)
			INNER JOIN tSalesTax st (NOLOCK) ON ilt.SalesTaxKey = st.SalesTaxKey
		WHERE ilt.InvoiceLineKey = @InvoiceLineKey
		
		
	RETURN 1
GO
