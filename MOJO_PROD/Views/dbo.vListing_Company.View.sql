USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Company]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Company]
AS  

/*
  || When     Who Rel     What
  || 10/16/06 WES 8.3567  Added Comments field
  || 10/16/06 WES 8.3567  Added Date Added field
  || 03/27/07 RTC 8.4.1   (7434) Added Invoice Template, Default Billing Method, One Invoice Per,
                          One Line Per, Default Terms, Estimate Template, Get Rate From Labor, Get Rate From Expenses,
 						  Item Rate Sheet, Item Markup, Prebill Insertions At, Prebill Broadcast At
  || 05/07/07 CRG 8.4.3   (9029) Added Sales Tax 1 and Sales Tax 2
  || 10/4/07  GWG 8.4.3   Added Labor Rate Sheet, modified name of item rate sheet to expense rate sheet
  || 11/06/07 CRG 8.5     (13138) Added Account Team
  || 02/08/08 CRG 1.0.0.0 Added Created By, Date Updated, Last Modified By
  || 02/29/08 CRG 1.0.0.0 Added ASC_Selected
  || 03/27/08 GWG 8.5     Added Vendor Discount Percent and days
  || 07/29/08 GHL 1.0.0.5 Added CMFolderKey since it affects the rights
  || 02/09/09 GWG 10.5	  Made cmfolderkey force to 0 so that a no folder check can be made.
  || 03/11/09 MAS 10.5	  Added Last and Next Activity columns, renamed columns, removed user_defined columns.
  || 04/03/09 GWG 10.5    Minor fixes to views
  || 04/29/09 RLB 10.024  (50919) Pulling just date on b.DateAdded
  || 04/30/09 CRG 10.500  Added Next/Last Activity Types, Days Since Last Activity, and No Activity Since
  || 9/22/09  CRG 10.511  (63789) Added new options for DefaultARLineFormat
  || 09/24/09 RLB 10.511  (63767) wrapped c.Type1099 in isnull was not displaying no in listing when it was null
  || 01/19/10 RLB 10.517  (72560) Added Over Head Client to the listing
  || 06/11/10 GWG 10.531  (82828) Fixed the Date converted. should come from the primary cont. not acct manager.
  || 07/09/10 RLB 10.532  (82828) changed Date Converted to the Companies Date Converted.
  || 10/06/10 RLB 10.536   added Primary Contact Phone 1 and 2
  || 11/1/10  RLB 10.537  (89516) Added DBA for voucher listing
  || 03/30/12 RLB 10.554  (138232) Added Default Expense Account
  || 05/03/12 RLB 10.555  (126104) Added Default Sales Account
  || 12/07/12 WDF 10.563  (161600) Added Default GL Company
  || 02/13/13 WDF 10.565  (168570) [Last Modified By] using the wrong alias of [Created By]
  || 03/25/13 WDF 10.566  (172384) Added [Account Manager Active]
  || 06/28/13 GHL 10.569  (182649) Added [Vendor Accepts Credit Cards]
  || 02/13/14 WDF 10.577  (206358) Added [One Payment Per Invoice] and [Print DBA On Check]
  || 04/09/14 GHL 10.579  Added CurrencyID
  || 07/18/14 WDF 10.582  Added IO/BC Commission 
  || 09/26/14 WDF 10.584  (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
  || 10/15/14 WDF 10.585  (Abelson Taylor) Added Title Rate Sheet
  || 11/17/14 GAR 10.586  (236376) Added option 9 to [One Line Item Per] because it wasn't being populated in 
  ||					  the companies listing screen when that option was chosen.
  || 01/28/15 GHL 10.588  Added new Line Formats for Abelson Taylor
  || 01/30/15 WDF 10.588  (244159) Added Billing Name and Email Invoices To
  || 02/10/15 KMC 10.589  (245859) Added Default AP Account
  || 02/11/15 KMC 10.589  (245859) Added Vendor Sales Tax 1 and Vendor Sales Tax 2
  || 03/05/15 GWG 10.590  Added Credit Card info
  || 05/05/15 KMC 10.591  (252479) Added masking of EINNumber on tCompany
  || 05/14/15 QMD 10.591  (256902) Tweaked ein masking slightly
*/

SELECT
	c.OwnerCompanyKey AS OwnerCompanyKey,  
	c.CompanyKey,  
	c.Vendor,  
	c.BillableClient,   
	c.CustomFieldKey,  
	c.ContactOwnerKey,
	ISNULL(c.CMFolderKey, 0) AS CMFolderKey,
	c.CompanyKey AS ContactCompanyKey,  --Needed for defaulting information into activity
	c.PrimaryContact,
	c.CompanyName,
	pct.FirstName + ' ' + pct.LastName AS ContactName,
	c.CompanyName AS [Company Name],
	c.DBA AS [DBA],   
	c.VendorID AS [Vendor ID],   
	c.CustomerID AS [Client ID],   
	bc.FirstName + ' ' + bc.LastName AS [Email Invoices To],
	ad.Address1 AS [Mailing Address1],   
	ad.Address2 AS [Mailing Address2],   
	ad.Address3 AS [Mailing Address3],   
	ad.City AS [Mailing City],   
	ad.State AS [Mailing State],   
	ad.PostalCode AS [Mailing Postal Code],   
	ad.Country AS [Mailing Country],   
	CASE
		WHEN c.ParentCompany = 1 THEN 'YES'
		ELSE 'NO'
	END AS [Parent Company],  
	pc.CompanyName AS [Parent Company Name],  
	CASE
		WHEN c.Vendor = 1 THEN 'YES'
		ELSE 'NO' 
	END AS [Is a Vendor],   
	CASE 
		WHEN c.BillableClient = 1 THEN 'YES' 
		ELSE 'NO' 
	END AS [Is a Client],   
	c.HourlyRate AS [Client Rate],   
	c.BillingName AS [Billing Name],
	ab.Address1 AS [Billing Address1],   
	ab.Address2 AS [Billing Address2],   
	ab.Address3 AS [Billing Address3],   
	ab.City AS [Billing City],   
	ab.State AS [Billing State],   
	ab.PostalCode AS [Billing Postal Code],   
	ab.Country AS [Billing Country],   
	c.WebSite AS [Web Site],   
	c.Phone AS [Main Phone],   
	c.Fax AS [Main Fax],   
	CASE
		WHEN c.Active = 1 THEN 'YES'
		ELSE 'NO'
	END AS [Active],    
	CASE c.Type1099 
		WHEN 1 THEN 'MISC'
		WHEN 2 THEN 'INT' 
	END AS [Form 1099 Type],
	CASE isnull(c.Type1099, 0)
		WHEN 0 THEN 'NO'
		ELSE 'YES'
	END AS [Is 1099],  
	c.Box1099 AS [Form 1099 Box],  	
	CASE
		WHEN LEN(c.EINNumber) >= 3 THEN '*********' + SUBSTRING(c.EINNumber, LEN(c.EINNumber) - 2, 3)
		ELSE c.EINNumber
	END AS [EIN Number],
	ct.CompanyTypeName AS [Company Type],  
	u.FirstName + ' ' + u.LastName AS [Account Manager Full Name],
	CASE u.Active
		WHEN 1 THEN 'YES'
		ELSE 'NO' 
	END AS [Account Manager Active],  
	pct.FirstName + ' ' + pct.LastName AS [Primary Contact Name],  
	pct.Phone1 AS [Primary Contact Phone 1],
	pct.Phone2 AS [Primary Contact Phone 2],
	owner.FirstName + ' ' + owner.LastName AS [Company Owner],
	c.Comments,
	c.DateConverted AS [Date Converted],
	Cast(Cast(Month(c.DateAdded) AS VARCHAR) + '/' + Cast(Day(c.DateAdded) AS VARCHAR) + '/' + Cast(Year(c.DateAdded) AS VARCHAR) AS SMALLDATETIME) AS [Date Added],
	it.TemplateName AS [Invoice Template],
	glc.GLCompanyName AS [Default Company],
	CASE c.DefaultBillingMethod
		WHEN 1 THEN 'Time and Materials'
		WHEN 2 THEN 'Fixed Fee'
		WHEN 3 THEN 'Retainer'
	END AS [Default Billing Method],
	CASE c.OneInvoicePer
		WHEN 0 THEN 'Project'
		WHEN 1 THEN 'Client'
		WHEN 2 THEN 'Parent Client'
		WHEN 3 THEN 'Division'
		WHEN 4 THEN 'Product'
		WHEN 5 THEN 'Campaign'
	END AS [One Invoice Per],
	CASE c.OneInvoicePer
	WHEN 0 THEN
		 CASE c.DefaultARLineFormat
			WHEN -1 THEN ''
			WHEN 0 THEN 'Invoice'
			WHEN 1 THEN 'Task'
			WHEN 2 THEN 'Service'
			WHEN 3 THEN 'Billing Item'
			WHEN 8 THEN 'Billing Item and Item'
			WHEN 9 THEN 'Billing Item and Item'
			WHEN 11 THEN 'Title'
			WHEN 12 THEN 'Title and Service'
			WHEN 13 THEN 'Service and Title'
			WHEN 14 THEN 'Service/Item'
		 END
	ELSE
		 CASE c.DefaultARLineFormat
			WHEN -1 THEN ''
			WHEN 0 THEN 'Project'
			WHEN 1 THEN 'Project and Task'
			WHEN 2 THEN 'Project and Service'
			WHEN 3 THEN 'Project and Billing Item'
			WHEN 8 THEN 'Project then Billing Item and Item'
			WHEN 9 THEN 'Billing Item and Item'
			WHEN 11 THEN 'Project and Title'
			WHEN 12 THEN 'Project and Title and Service'
			WHEN 13 THEN 'Project and Service and Title'
			WHEN 14 THEN 'Project and Service/Item'
		 END 
	END AS [One Line Item Per],
	CASE
		WHEN c.OnePaymentPerVoucher = 1 THEN 'YES' 
		ELSE 'NO' 
	END AS [One Payment Per Invoice], 
	CASE
		WHEN c.UseDBAForPayment = 1 THEN 'YES'
		ELSE 'NO'
	END AS [Print DBA On Check], 
	pt.TermsDescription AS [Billing Terms],
	et.TemplateName AS [Estimate Template],
	CASE c.GetRateFrom
		WHEN 9 THEN 'Billing Title'
		WHEN 10 THEN 'Billing Title Rate Sheet'
		WHEN 1 THEN 'Client'
		WHEN 2 THEN 'Project'
		WHEN 3 THEN 'Project/User'
		WHEN 4 THEN 'Service'
		WHEN 5 THEN 'Service Rate Sheet'
		WHEN 6 THEN 'Task'
	END AS [Labor Get Rate From],
	CASE c.GetMarkupFrom
		WHEN 1 THEN 'Client'
		WHEN 2 THEN 'Project'
		WHEN 3 THEN 'Item'
		WHEN 4 THEN 'Item Rate Sheet'
		WHEN 5 THEN 'Task'
	END AS [Purchasing Get Rate From],
	rs.RateSheetName AS [Expense Rate Sheet],
	srs.RateSheetName AS [Labor Rate Sheet],
	tirs.RateSheetName AS [Title Rate Sheet],
	c.ItemMarkup AS [Purchasing Markup],
	c.IOCommission AS [IO Commission Percent], 
	c.BCCommission AS [BC Commission Percent],
	CASE c.IOBillAt
		WHEN 0 THEN 'Gross'
		WHEN 1 THEN 'Net'
		WHEN 2 THEN 'Commission Only'
	END AS [Prebill Insertions At],
	CASE c.BCBillAt
		WHEN 0 THEN 'Gross'
		WHEN 1 THEN 'Net'
		WHEN 2 THEN 'Commission Only'
	END AS [Prebill Broadcast At],
	st1.SalesTaxName AS [Sales Tax 1],
	st2.SalesTaxName AS [Sales Tax 2],
	gla.AccountNumber + ' - ' + gla.AccountName AS [Default Expense Account],
	gla2.AccountNumber + ' - ' + gla2.AccountName AS [Default Sales Account],
	t.TeamName AS [Account Team],
	cb.FirstName + ' ' + cb.LastName AS [Created By],
	c.DateUpdated AS [Date Updated],
	mb.FirstName + ' ' + mb.LastName AS [Last Modified By],
	0 AS ASC_Selected,
	c.TermsPercent AS [Vendor Discount Percent],
	c.TermsDays AS [Vendor Discount Days],
	c.TermsNet AS [Vendor Days Net Due],
	CASE
		WHEN c.Overhead = 1 THEN 'YES'
		ELSE 'NO'
	END AS [OverHead Client], 
	CASE
		WHEN c.CCAccepted = 1 THEN 'YES'
		ELSE 'NO'
	END AS [Vendor Accepts Credit Cards],
	ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName, '') AS [Salesperson Name],
	so.SourceName AS [Company Source],
	folder.FolderName AS [Folder],
	-- WWP
	CASE c.WWPCurrentLevel 
		WHEN 2 THEN '2 - Contemplating'
		WHEN 3 THEN '3 - Planning'
		WHEN 4 THEN '4 - Action'
		ELSE '1 - Unaware' 
	END AS [WWP Current Level],
	lastActivity.ActivityDate AS [Last Activity Date],
	lastActivity.Subject AS [Last Activity Subject],
	ISNULL(lau.FirstName,'') + ' ' + ISNULL(lau.LastName,'') AS [Last Activity Assigned To],
	nextActivity.ActivityDate AS [Next Activity Date],
	nextActivity.Subject AS [Next Activity Subject],
	ISNULL(nau.FirstName,'') + ' ' + ISNULL(nau.LastName,'') AS [Next Activity Assigned To],
	atNext.TypeName AS [Next Activity Type],
	atLast.TypeName AS [Last Activity Type],
	DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) AS [Days Since Last Activity],
	CASE
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 90 THEN '90 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 60 THEN '60 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 30 THEN '30 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 7 THEN '7 Days'
		ELSE NULL
	END AS [No Activity Since],
	c.CurrencyID AS [Currency],
	gla3.AccountNumber + ' - ' + gla3.AccountName AS [Default AP Account],
	vst1.SalesTaxName AS [Vendor Sales Tax 1],
	vst2.SalesTaxName AS [Vendor Sales Tax 2],
	CASE c.CCAccepted
		WHEN 1 THEN 'YES'
		ELSE 'NO'
	END AS [Credit Cards Accepted],
	glcc.AccountNumber AS [Credit Card Used],
	c.EmailCCToAddress AS [Email Card Info To]
FROM tCompany c (NOLOCK)  
	LEFT OUTER JOIN tCompanyType ct (NOLOCK) ON c.CompanyTypeKey = ct.CompanyTypeKey  
	LEFT OUTER JOIN tCompany pc (NOLOCK) ON c.ParentCompanyKey = pc.CompanyKey  
	LEFT OUTER JOIN tUser u (NOLOCK) ON c.AccountManagerKey = u.UserKey    
	LEFT OUTER JOIN tUser pct (NOLOCK) ON c.PrimaryContact = pct.UserKey  
	LEFT OUTER JOIN tUser owner (NOLOCK) ON c.ContactOwnerKey = owner.UserKey  
	LEFT OUTER JOIN tUser cb (NOLOCK) ON c.CreatedBy = cb.UserKey
	LEFT OUTER JOIN tUser mb (NOLOCK) ON c.ModifiedBy = mb.UserKey
	LEFT OUTER JOIN tUser bc (NOLOCK) ON c.BillingEmailContact = bc.UserKey
	LEFT OUTER JOIN tAddress ad (NOLOCK) ON c.DefaultAddressKey = ad.AddressKey
	LEFT OUTER JOIN tAddress ab (NOLOCK) ON c.BillingAddressKey = ab.AddressKey
	LEFT OUTER JOIN tInvoiceTemplate it (NOLOCK) ON c.InvoiceTemplateKey = it.InvoiceTemplateKey
	LEFT OUTER JOIN tEstimateTemplate et (NOLOCK) ON c.EstimateTemplateKey = et.EstimateTemplateKey
	LEFT OUTER JOIN tPaymentTerms pt (NOLOCK) ON c.PaymentTermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tItemRateSheet rs (NOLOCK) ON c.ItemRateSheetKey = rs.ItemRateSheetKey
	LEFT OUTER JOIN tTimeRateSheet srs (NOLOCK) ON c.TimeRateSheetKey = srs.TimeRateSheetKey
	LEFT OUTER JOIN tTitleRateSheet tirs (NOLOCK) ON c.TitleRateSheetKey = tirs.TitleRateSheetKey
	LEFT OUTER JOIN tSalesTax st1 (NOLOCK) ON c.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (NOLOCK) ON c.SalesTax2Key = st2.SalesTaxKey
	LEFT OUTER JOIN tSalesTax vst1 (NOLOCK) ON c.VendorSalesTaxKey = vst1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax vst2 (NOLOCK) ON c.VendorSalesTax2Key = vst2.SalesTaxKey
	LEFT OUTER JOIN tTeam t (nolock) ON c.DefaultTeamKey = t.TeamKey
	LEFT OUTER JOIN tActivity lastActivity (NOLOCK) ON c.LastActivityKey = lastActivity.ActivityKey
	LEFT OUTER JOIN tUser lau (NOLOCK) ON lastActivity.AssignedUserKey = lau.UserKey
	LEFT OUTER JOIN tActivity nextActivity (NOLOCK) ON c.NextActivityKey = nextActivity.ActivityKey
	LEFT OUTER JOIN tUser nau (NOLOCK) ON nextActivity.AssignedUserKey = nau.UserKey
	LEFT OUTER JOIN tUser sales (NOLOCK) ON c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tCMFolder folder (NOLOCK) ON c.CMFolderKey = folder.CMFolderKey
	LEFT OUTER JOIN	tSource so (NOLOCK) on c.SourceKey = so.SourceKey
	LEFT OUTER JOIN tActivityType atNext (NOLOCK) ON nextActivity.ActivityTypeKey = atNext.ActivityTypeKey
	LEFT OUTER JOIN tActivityType atLast (NOLOCK) ON lastActivity.ActivityTypeKey = atLast.ActivityTypeKey
	LEFT OUTER JOIN tGLAccount gla (NOLOCK) ON c.DefaultExpenseAccountKey = gla.GLAccountKey
	LEFT OUTER JOIN tGLAccount gla2 (NOLOCK) ON c.DefaultSalesAccountKey = gla2.GLAccountKey
	LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON c.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tGLAccount gla3 (NOLOCK) ON c.DefaultAPAccountKey = gla3.GLAccountKey
	LEFT OUTER JOIN tGLAccount glcc (nolock) on c.CCAccountKey = glcc.GLAccountKey
GO
