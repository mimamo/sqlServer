USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vInvoice]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
|| When     Who Rel     What
|| 06/13/07 GHL 8.5    Added  GLCompanyKey + OfficeKey
|| 06/18/08 GHL 8.513  Added OpeningTransaction
|| 02/11/09 GHL 10.019 Added Advance Bill
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 10/21/11 GHL 10.549 (124386) Split RetainerAmount in 2 fields, 1 for sales, 1 for taxes
|| 08/05/13 GHL 10.571 Added multi currency data
|| 01/03/14 WDF 10.576 (188500) Added CreatedByKey and DateCreated
*/

CREATE    VIEW [dbo].[vInvoice]
AS
SELECT i.InvoiceKey, 
	c.CompanyKey AS ClientKey, 
	c1.CompanyKey, 
	c.ParentCompanyKey as ParentClientKey,
	c1.CompanyName, 
	a_c1.Address1, 
	a_c1.Address2, 
	a_c1.Address3, 
	a_c1.City, 
	a_c1.State, 
	a_c1.PostalCode, 
	a_c1.Country, 
	c.CompanyName AS BCompanyName, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.Address1 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END 
	END  AS BAddress1, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.Address2 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END 
	END  AS BAddress2, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.Address3 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END 
	END  AS BAddress3, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.City 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END 
	END  AS BCity, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.State 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END 
	END  AS BState, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.PostalCode 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END 
	END  AS BPostalCode, 
	CASE WHEN i.AddressKey IS NOT NULL THEN a_i.Country 
	     ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END 
	END  AS BCountry, 
	c.CustomerID,
	i.ContactName AS BillingContact,
  	i.PrimaryContactKey,
	i.AddressKey, 
	pt.TermsDescription, 
	i.InvoiceTemplateKey,
	i.LayoutKey,
	i.TermsKey,
	i.ApprovedByKey,
	i.InvoiceNumber, 
	i.InvoiceDate, 
	i.PostingDate,
	i.ProjectKey,
    	i.DueDate, 
	i.RecurringParentKey,
	i.UserDefined1,
	i.UserDefined2,
	i.UserDefined3,
	i.UserDefined4,
	i.UserDefined5,
	i.UserDefined6,
	i.UserDefined7,
	i.UserDefined8,
	i.UserDefined9,
	i.UserDefined10,
	i.Posted,
	i.InvoiceStatus, 
	i.HeaderComment, 
	i.SalesTaxKey,
	i.SalesTax2Key,
	i.ClassKey,
	i.ARAccountKey,
	i.ParentInvoiceKey,
	i.ParentInvoice,
	i.PercentageSplit,
	ISNULL(i.AmountReceived, 0) AS PaymentAmount, 
	ISNULL(i.DiscountAmount, 0) AS DiscountAmount, 
	ISNULL(i.WriteoffAmount, 0) AS WriteoffAmount, 
	ISNULL(i.RetainerAmount, 0) AS RetainerAmount,
	ISNULL(i.RetainerAmount, 0)
	-ISNULL((select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock) where iabt.InvoiceKey = i.InvoiceKey), 0) as RetainerAmountSales,
	ISNULL((select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock) where iabt.InvoiceKey = i.InvoiceKey), 0) as RetainerAmountTaxes,
	ISNULL(i.AmountReceived, 0) AS AmountReceived,
	ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) AS BilledAmount,
    ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - isnull(i.AmountReceived, 0) AS OpenAmount,
    ISNULL(i.SalesTaxAmount, 0) AS SalesTaxAmount, 
    ISNULL(i.SalesTax1Amount, 0) AS SalesTax1Amount, 
    ISNULL(i.SalesTax2Amount, 0) AS SalesTax2Amount, 
    ISNULL(i.TotalNonTaxAmount, 0) AS TotalNonTaxAmount, 
	ISNULL(i.InvoiceTotalAmount, 0) AS InvoiceTotalAmount, 
	ISNULL(st.Description, 'Sales Tax 1') AS SalesTaxDescription,
	ISNULL(st2.Description, 'Sales Tax 2') AS SalesTax2Description,
	Case When i.AdvanceBill = 1 then (Select Sum(Amount) from tInvoiceAdvanceBill iab (nolock) Where iab.AdvBillInvoiceKey = i.InvoiceKey) else 0 end as AdvanceApplied,
	i.GLCompanyKey
	,i.OfficeKey
	,ISNULL(i.OpeningTransaction, 0) AS OpeningTransaction
    ,i.AdvanceBill
    ,i.CurrencyID
    ,i.ExchangeRate
    ,i.CreatedByKey
    ,i.DateCreated
FROM tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) ON 
		i.ClientKey = c.CompanyKey 
	INNER JOIN tCompany c1 (nolock) ON 
		i.CompanyKey = c1.CompanyKey 
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON 
		i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tSalesTax st (nolock) ON 
		i.SalesTaxKey = st.SalesTaxKey
    LEFT OUTER JOIN tSalesTax st2 (nolock) ON 
		i.SalesTax2Key = st2.SalesTaxKey
	LEFT OUTER JOIN tAddress a_i (nolock) ON i.AddressKey = a_i.AddressKey
	LEFT OUTER JOIN tAddress a_c1 (nolock) ON c1.DefaultAddressKey = a_c1.AddressKey
	LEFT OUTER JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey
	LEFT OUTER JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey
GO
