USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Invoice]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[vExport_Invoice]
AS
SELECT 
	i.InvoiceKey, 
	i.CompanyKey, 
	c.CustomerID, 
	c.CompanyName,
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address1 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END 
	END  AS BAddress1, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address2 	    
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END 
	END  AS BAddress2, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address3 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END 
	END  AS BAddress3, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.City 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END 
	END  AS BCity, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.State 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END 
	END  AS BState, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.PostalCode 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END 
	END  AS BPostalCode, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Country 
	    ELSE CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END 
	END  AS BCountry, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
	i.DueDate, 
	i.DiscountAmount, 
	i.RetainerAmount,
	i.HeaderComment, 
	i.Downloaded, 
	i.InvoiceStatus,
	gl.AccountNumber AS ARAccount, 
	gl.ParentAccountKey,
	cl.ClassID,
	i.TotalNonTaxAmount as NoTaxAmount,
	i.InvoiceTotalAmount AS TotalAmount,
	ISNULL((Select Sum(il.BilledTimeAmount + il.BilledExpenseAmount) from tInvoiceLine il (nolock) Where il.InvoiceKey = i.InvoiceKey and il.Taxable = 1), 0) as LineTotalTaxableAmount,
	(Select COUNT(il.InvoiceLineKey) from tInvoiceLine il (nolock) Where i.InvoiceKey = il.InvoiceKey and il.LineType = 2) AS LineCount, 
	pt.TermsDescription AS PaymentTerms,
	st.SalesTaxID,
	ISNULL(st.TaxRate, 0) as TaxRate,
	(select AccountNumber from tGLAccount Where st.PayableGLAccountKey = tGLAccount.GLAccountKey) as SalesTaxGLAccount,
	(select VendorID from tCompany where st.PayTo = tCompany.CompanyKey) as SalesTaxVendorID,
	i.SalesTax1Amount as TaxableAmount
FROM
	tInvoice i (NOLOCK)
	inner join tCompany c (NOLOCK) on i.ClientKey = c.CompanyKey
	left outer join tGLAccount gl (NOLOCK) on i.ARAccountKey = gl.GLAccountKey
	left outer join tPaymentTerms pt (NOLOCK) on i.TermsKey = pt.PaymentTermsKey
	left outer join tSalesTax st (NOLOCK) on i.SalesTaxKey = st.SalesTaxKey
	left outer join tClass cl (NOLOCK) on i.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey
	LEFT OUTER JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey  
	LEFT OUTER JOIN tAddress a_i (nolock) ON i.AddressKey = a_i.AddressKey
GO
