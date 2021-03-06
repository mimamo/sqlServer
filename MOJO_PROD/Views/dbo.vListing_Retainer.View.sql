USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Retainer]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Retainer] AS

  /*
  || When     Who Rel     What
  || 01/09/07 GHL 8.4     Changed Active from numeric to Yes/No to prevent errors in listings 
  || 09/25/07 GHL 8437    (13480) Added Custom Field  
  || 10/10/07 CRG 8.4.3.8 (14435) Added Description Field
  || 10/10/07 CRG 8.5     Added GLCompany and Office
  || 10/08/09 GHL 10.512  (50725) Added RetainerAmount and ExtraAmount
  || 11/19/09 GWG 10.5.1.3 Added Number of periods
  || 03/09/10 RLB 10.5.2.0 Added Sales Account Name and Number to listing
  || 12/09/11 RLB 10.5.5.1 (119938) Added Next Billing Date
  || 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
  || 07/18/12 RLB 10.5.5.8 (139560) Added Parent Company Name
  || 01/31/13 MFT 10.5.6.4 Corrected Varience to use RetainerAmount (instead of TotalBilled) and respect IncludeLabor & IncludeExpense
  || 10/07/13 GHL 10.5.7.3 Added Currency info
  || 12/20/13 WDF 10.5.7.5 (198697) Added Billing Manager
  */

SELECT	r.RetainerKey,
	r.CompanyKey,
	r.GLCompanyKey,
	r.ClientKey,
	r.CustomFieldKey,
	c.CustomerID AS [Client ID],
	c.CompanyName AS [Client Name],
	pc.CompanyName AS [Parent Company Name],
	un.UserName AS [Account Executive],
	un2.UserName As [Billing Manager],
	r.Title,
	r.NumberOfPeriods as [Number of Periods],
	r.AmountPerPeriod AS [Amount Per Period],
	CASE r.Frequency
		WHEN 1 THEN 'Monthly'
		WHEN 2 THEN 'Quarterly'
		WHEN 3 THEN 'Yearly'
		ELSE ''
	END AS Frequency,
	CASE WHEN r.LastBillingDate IS NOT NULL
			THEN 
				CASE r.Frequency
					WHEN 1 THEN (SELECT DATEADD(m, 1, r.LastBillingDate))
					WHEN 2 THEN (SELECT DATEADD(m, 3, r.LastBillingDate))
					ELSE (SELECT DATEADD(yy, 1, r.LastBillingDate))	
				END
		ELSE NULL
	END As [Next Billing Date],	
	r.LastBillingDate AS [Last Invoiced], 
	v.TotalBilled AS [Total Billed],
    v.RetainerAmount AS [Retainer Amount Billed],
    v.ExtraAmount AS [Extra Amount Billed],
	gla.AccountNumber AS [Sales GL Account Number],
	gla.AccountName AS [Sales GL Account Name],
	v.TotalLabor AS [Total Labor],
	v.TotalExpense AS [Total Expense],
	ISNULL(v.RetainerAmount,0) - CASE IncludeLabor WHEN 1 THEN ISNULL(v.TotalLabor,0) ELSE 0 END - CASE IncludeExpense WHEN 1 THEN ISNULL(v.TotalExpense,0) ELSE 0 END AS Variance,
	CASE r.Active
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END as Active,
	r.Description,
	glc.GLCompanyID as [Company ID],
	glc.GLCompanyName as [Company Name],
	o.OfficeID as [Office ID],
	o.OfficeName as [Office Name],
	r.CurrencyID as [Currency]
FROM 	tRetainer r (NOLOCK)
INNER JOIN tCompany c (NOLOCK) ON r.ClientKey = c.CompanyKey
LEFT JOIN vListing_Retainer_Prelim v (NOLOCK) ON r.RetainerKey = v.RetainerKey
LEFT JOIN tUser am (NOLOCK) ON c.AccountManagerKey = am.UserKey
LEFT JOIN vUserName un (NOLOCK) ON am.UserKey = un.UserKey
LEFT JOIN vUserName un2 (NOLOCK) ON r.BillingManagerKey = un2.UserKey
LEFT JOIN tGLCompany glc (nolock) on r.GLCompanyKey = glc.GLCompanyKey
LEFT JOIN tOffice o (nolock) on r.OfficeKey = o.OfficeKey
LEFT Join tGLAccount gla (nolock) on r.SalesAccountKey = gla.GLAccountKey
LEFT JOIN tCompany pc (NOLOCK)on c.ParentCompanyKey = pc.CompanyKey
GO
