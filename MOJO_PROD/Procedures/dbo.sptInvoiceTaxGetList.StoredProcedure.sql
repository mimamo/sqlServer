USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTaxGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTaxGetList]
	(
	@InvoiceKey int
	)
AS
	SET NOCOUNT ON
	
	select it.InvoiceKey
	      ,it.InvoiceLineKey
	      ,it.SalesTaxKey
	      ,it.SalesTaxAmount
	      ,it.Type
	      ,il.LineSubject
	      ,st.SalesTaxName
	      ,st.TaxRate
	      ,st.PiggyBackTax
	      ,cast(it.InvoiceLineKey as varchar(50)) + '-' +cast(it.SalesTaxKey as varchar(50))
	      as ManufacturedKey 
	from   tInvoiceTax it (nolock)
		inner join tInvoiceLine il (nolock) on it.InvoiceLineKey = il.InvoiceLineKey
		inner join tSalesTax st (nolock) on it.SalesTaxKey = st.SalesTaxKey
	where  it.InvoiceKey = @InvoiceKey
	order by it.Type, il.InvoiceOrder
	
	RETURN 1
GO
