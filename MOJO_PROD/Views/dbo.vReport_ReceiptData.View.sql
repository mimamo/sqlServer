USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ReceiptData]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_ReceiptData]
AS

/*
|| When     Who Rel     What
|| 06/27/07 QMD 8.4.3.1 Initial Release
|| 10/11/07 CRG 8.5     Added Class and GLCompany
|| 11/20/07 GHL 8.5     (16257) Added second custom field from tProject
|| 03/17/09  RTC 10.5	  Removed user defined fields.
|| 08/15/09 GWG 10.507	Added SalesPerson
|| 04/24/12 GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 03/07/14 GHL 10.5.7.8  Added Currency + Exchange Rate
|| 07/28/14 GHL 10.5.8.2  Added Check Description
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
*/

SELECT	c.CustomFieldKey,
		p.CustomFieldKey AS CustomFieldKey2,
	c.OwnerCompanyKey AS CompanyKey,
	isnull(ca.TargetGLCompanyKey, ch.GLCompanyKey) as GLCompanyKey, 
	
	c.CompanyName AS [Client Name],
	c.CustomerID AS [Client ID],
	c.CustomerID + ' ' + c.CompanyName AS [Client Full Name],

	u.UserName AS [Account Manager],
	sa.UserName AS [Sales Person],
	
	p.ProjectName AS [Project Name],
	p.ProjectNumber AS [Project Number],
	CASE p.NonBillable WHEN 1 THEN 'YES' ELSE 'NO' END AS [Non Billable Project],
	pbs.ProjectBillingStatus AS [Project Billing Status],

	pt.ProjectTypeName AS [Project Type Name],
	
	ch.CheckAmount AS [Check Amount],
	ch.CheckDate AS [Check Date],
	ch.PostingDate AS [Check Posting Date],
	ch.ReferenceNumber AS [Check Reference Number],
	ch.[Description] AS [Check Description],	
	
	ca.[Description] AS [Receipt Description],	
	ca.Amount AS [Receipt Amount],

	i.InvoiceNumber	AS [Invoice Number],
	i.AmountReceived AS [Invoice Amount Received],
	i.HeaderComment	AS [Invoice Comment],
	i.InvoiceDate AS [Invoice Date],
	i.PostingDate AS [Invoice Posting Date],
	
	gl.AccountNumber AS [Check Header Account Number],
	gl.AccountName AS [Check Header Account Name],

	gl2.AccountNumber AS [Line GL Account Number],
	gl2.AccountName AS [Line GL Account Name],

	isnull(glcT.GLCompanyID, glc.GLCompanyID) as [Company ID], 
	isnull(glcT.GLCompanyName, glc.GLCompanyName) as [Company Name], 
	
	cl.ClassID as [Class ID],
	cl.ClassName as [Class Name],
	p.ProjectKey,
	ch.CurrencyID as [Currency],
	ch.ExchangeRate as [Exchange Rate],
	cd.DivisionID as [Client Division ID],
    cd.DivisionName as [Client Division],
    cp.ProductID as [Client Product ID],
    cp.ProductName as [Client Product]
FROM tCheck ch (NOLOCK) 
INNER JOIN tCompany c (NOLOCK) ON ch.ClientKey = c.CompanyKey
LEFT OUTER JOIN tCheckAppl ca (NOLOCK) ON ch.CheckKey = ca.CheckKey
LEFT OUTER JOIN tInvoice i (NOLOCK) ON ca.InvoiceKey = i.InvoiceKey
LEFT OUTER JOIN tProject p (NOLOCK) ON i.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tProjectBillingStatus pbs (NOLOCK) ON p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
LEFT OUTER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
LEFT OUTER JOIN vUserName u (NOLOCK) ON p.AccountManager = u.UserKey
LEFT OUTER JOIN vUserName sa (NOLOCK) ON c.SalesPersonKey = sa.UserKey
LEFT OUTER JOIN tGLAccount gl (NOLOCK) ON  ch.CashAccountKey = gl.GLAccountKey
LEFT OUTER JOIN tGLAccount gl2 (NOLOCK) ON  ca.SalesAccountKey = gl2.GLAccountKey
LEFT OUTER JOIN tClass cl (nolock) on ch.ClassKey = cl.ClassKey
LEFT OUTER JOIN tGLCompany glc (nolock) on ch.GLCompanyKey = glc.GLCompanyKey
LEFT OUTER JOIN tGLCompany glcT (nolock) on ca.TargetGLCompanyKey = glcT.GLCompanyKey
LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
