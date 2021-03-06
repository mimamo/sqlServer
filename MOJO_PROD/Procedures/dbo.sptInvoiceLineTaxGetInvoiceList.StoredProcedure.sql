USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTaxGetInvoiceList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineTaxGetInvoiceList]
	(
		@InvoiceKey As Int
		,@Percentage as decimal(24,4) = 100 -- kept for backwards compatibility  
	)
AS	--Encrypt

/*  Who   When        Rel     What
||  GHL   09/27/07    8.5     Calculating SalesTaxAmount as
||                            ROUND(SUM()) instead of SUM(ROUND()) to minimize ronding errors
||  GHL   09/29/09   10.5     Using now tInvoiceTax instead of tInvoiceLineTax because users
||                            can now change these records on the UI for child invoices
*/ 
	SET NOCOUNT ON
	 
	SELECT  st.SalesTaxName,
			st.Description AS SalesTaxDescription, 
			SUM(it.SalesTaxAmount) AS SalesTaxAmount
	FROM    tInvoiceTax it (NOLOCK)
		INNER JOIN tSalesTax st (NOLOCK) ON it.SalesTaxKey = st.SalesTaxKey
	WHERE   it.InvoiceKey = @InvoiceKey		 
	AND     it.Type = 3 -- other taxes like in tInvoiceLineTax
	GROUP BY st.SalesTaxName, st.Description
	 
	RETURN 1
GO
