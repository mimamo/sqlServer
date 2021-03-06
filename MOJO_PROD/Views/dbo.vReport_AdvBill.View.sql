USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_AdvBill]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vReport_AdvBill]
AS

/*
|| When      Who Rel      What
|| 10/09/09 GHL 10.512    (53144) creation for enhancement
||                        Display info on advance bill
|| 04/23/12 GHL 10.555    Added GLCompanyKey for map/restrict
|| 11/11/13 RLB 10.574   (198032) Added Project number from non Adv billed invoice also pulling Adv invoices that have not been applied
|| 11/06/14 GHL 10.586   (230365) Added currency and exchange rate
|| 01/27/15 WDF 10.588   (Abelson Taylor) Added Division and Product
*/

select vabi.CompanyKey 
       ,vabi.GLCompanyKey
       ,iab.AdvBillInvoiceKey
       ,iab.InvoiceKey

       ,vabi.InvoiceTotalAmount as [Advance Bill Invoice Total Amount]
       ,vabi.InvoiceTotalAmount 
       - ISNULL((
			select SUM(iab2.Amount)
            from   tInvoiceAdvanceBill iab2 (nolock)
            where  iab2.AdvBillInvoiceKey = iab.AdvBillInvoiceKey
        ),0) 
       as [Advance Bill Unapplied Amount]

       ,vi.InvoiceTotalAmount as [Regular Invoice Total Amount]
	   ,iab.Amount as [Applied Amount]
	   ,ISNULL((
			select SUM(iabt.Amount)
            from   tInvoiceAdvanceBillTax iabt (nolock)
            where  iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey
            and    iabt.InvoiceKey = iab.InvoiceKey 
		),0) 
       AS [Applied Sales Tax Amount]
       ,vi.OpenAmount as [Regular Invoice Open Amount]

       ,vabi.InvoiceNumber as [Advance Bill Invoice Number]
       ,vabi.InvoiceDate as [Advance Bill Invoice Date]
       ,vabi.PostingDate as [Advance Bill Posting Date]
       ,vabi.CustomerID as [Client ID]
       ,vabi.BCompanyName as [Client Name]

       ,vi.InvoiceNumber as [Regular Invoice Number]
       ,vi.InvoiceDate as [Regular Invoice Date]
       ,vi.PostingDate as [Regular Invoice Posting Date]
       
       ,vabi.SalesTaxAmount as [Advance Bill Total Sales Tax]
       ,vabi.SalesTax1Amount as [Advance Bill Sales Tax Amount 1]
       ,vabi.SalesTax2Amount as [Advance Bill Sales Tax Amount 2]
       ,vabi.SalesTaxAmount - vabi.SalesTax1Amount - vabi.SalesTax2Amount as [Advance Bill Other Sales Tax]
       ,vabi.SalesTaxDescription as [Advance Bill Sales Tax Description 1]
       ,vabi.SalesTax2Description as [Advance Bill Sales Tax Description 2]

       ,vi.SalesTaxAmount as [Regular Invoice Total Sales Tax]
       ,vi.SalesTax1Amount as [Regular Invoice Sales Tax Amount 1]
       ,vi.SalesTax2Amount as [Regular Invoice Sales Tax Amount 2]
       ,vi.SalesTaxAmount - vi.SalesTax1Amount - vi.SalesTax2Amount as [Regular Invoice Other Sales Tax]
       ,vi.SalesTaxDescription as [Regular Invoice Sales Tax Description 1]
       ,vi.SalesTax2Description as [Regular Invoice Sales Tax Description 2]
       , p.ProjectNumber as [Regular Invoice Header Project Number]
       ,cd.DivisionID as [Client Division ID]
       ,cd.DivisionName as [Client Division]
       ,cp.ProductID as [Client Product ID]
       ,cp.ProductName as [Client Product]
       
	   ,vabi.CurrencyID as [Currency]
	   ,vabi.ExchangeRate as [Advance Bill Exchange Rate]
	   ,vi.ExchangeRate as [Regular Invoice Exchange Rate]
	   
from    vInvoice vabi (nolock)
left outer join tInvoiceAdvanceBill iab (nolock) on vabi.InvoiceKey = iab.AdvBillInvoiceKey
left outer join vInvoice vi (nolock) on iab.InvoiceKey = vi.InvoiceKey
left outer join tProject p (nolock) on vi.ProjectKey = p.ProjectKey
left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
where vabi.AdvanceBill = 1
GO
