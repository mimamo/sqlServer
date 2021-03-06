USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Company]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Company]
AS  

/*
  || When     Who Rel     What
  || 06/28/13 GHL 10.569  (182649) Added [Vendor Accepts Credit Cards]
  || 04/09/14 GHL 10.579  Added Currency
  || 09/26/14 WDF 10.584  (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
  || 10/15/14 WDF 10.585  (Abelson Taylor) Added Title Rate Sheet
  || 11/17/14 GAR 10.586  (236376) Added option 9 to [One Line Item Per] because it wasn't being populated in 
  ||					  the companies listing screen when that option was chosen.
  || 01/28/15 GHL 10.5.8.8 Added new Line Formats for Abelson Taylor
*/

SELECT   
 c.OwnerCompanyKey AS CompanyKey,  
 c.CompanyKey as ClientKey,
 c.Vendor,  
 c.BillableClient,   
 c.CustomFieldKey,  
 c.ContactOwnerKey,
 ISNULL(c.CMFolderKey, 0) as CMFolderKey,

 c.CompanyKey as ContactCompanyKey,  --Needed for defaulting information into activity
 c.PrimaryContact,
 c.CompanyName,
 pct.FirstName + ' ' + pct.LastName as ContactName,

 c.CompanyName AS [Company Name],
 c.DBA AS [DBA],   
 c.VendorID AS [Vendor ID],   
 c.CustomerID AS [Client ID],   
 ad.Address1 AS [Mailing Address1],   
 ad.Address2 AS [Mailing Address2],   
 ad.Address3 AS [Mailing Address3],   
 ad.City AS [Mailing City],   
 ad.State AS [Mailing State],   
 ad.PostalCode AS [Mailing Postal Code],   
 ad.Country AS [Mailing Country],   
 case when c.ParentCompany = 1 then 'YES' else 'NO' end AS [Parent Company],  
 pc.CompanyName as [Parent Company Name],  
 case when c.Vendor = 1 then 'YES' else 'NO' end AS [Is a Vendor],   
 case when c.BillableClient = 1 then 'YES' else 'NO' end AS [Is a Client],   
 c.HourlyRate AS [Client Rate],   
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
 case when c.Active = 1 then 'YES' else 'NO' end AS [Active],    
 Case c.Type1099 When 1 then 'MISC' When 2 then 'INT' end as [Form 1099 Type],
 Case isnull(c.Type1099, 0) when 0 then 'NO' else 'YES' end AS [Is 1099],  
 c.Box1099 as [Form 1099 Box],  
 c.EINNumber as [EIN Number],  
 ct.CompanyTypeName AS [Company Type],  
 u.FirstName + ' ' + u.LastName as [Account Manager Full Name],  
 pct.FirstName + ' ' + pct.LastName as [Primary Contact Name],  
 pct.Phone1 as [Primary Contact Phone 1],
 pct.Phone2 as [Primary Contact Phone 2],
 owner.FirstName + ' ' + owner.LastName as [Company Owner],
 c.Comments,
 c.DateConverted as [Date Converted],
 Cast(Cast(Month(c.DateAdded) as varchar) + '/' + Cast(Day(c.DateAdded) as varchar) + '/' + Cast(Year(c.DateAdded) as varchar) as smalldatetime) as [Date Added],
 it.TemplateName as [Invoice Template],
 case c.DefaultBillingMethod
	when 1 then 'Time and Materials'
	when 2 then 'Fixed Fee'
	when 3 then 'Retainer'
 end as [Default Billing Method],
 case c.OneInvoicePer
 	when 0 then 'Project'
	when 1 then 'Client'
	when 2 then 'Parent Client'
	when 3 then 'Division'
	when 4 then 'Product'
	when 5 then 'Campaign'
 end as [One Invoice Per],
 case c.OneInvoicePer
  	when 0 then
		 case c.DefaultARLineFormat
			when -1 then ''
			when 0 then 'Invoice'
			when 1 then 'Task'
			when 2 then 'Service'
			when 3 then 'Billing Item'
			when 8 then 'Billing Item and Item'
			when 9 then 'Billing Item and Item'
			When 11 then 'Title'
			When 12 then 'Title and Service'
			When 13 then 'Service and Title'
			When 14 then 'Service/Item'
		 end
    else
		 case c.DefaultARLineFormat
			when -1 then ''
			when 0 then 'Project'
			when 1 then 'Project and Task'
			when 2 then 'Project and Service'
			when 3 then 'Project and Billing Item'
			when 8 then 'Project then Billing Item and Item'
			when 9 then 'Billing Item and Item'
			When 11 then 'Project and Title'
			When 12 then 'Project and Title and Service'
			When 13 then 'Project and Service and Title'
			When 14 then 'Project and Service/Item'
		 end 
 end as [One Line Item Per],
 pt.TermsDescription as [Billing Terms],
 et.TemplateName as [Estimate Template],
 case c.GetRateFrom
	when 9 then 'Billing Title'
	when 10 then 'Billing Title Rate Sheet'
	when 1 then 'Client'
	when 2 then 'Project'
	when 3 then 'Project/User'
	when 4 then 'Service'
	when 5 then 'Service Rate Sheet'
	when 6 then 'Task'
 end as [Labor Get Rate From],
 case c.GetMarkupFrom
	when 1 then 'Client'
	when 2 then 'Project'
	when 3 then 'Item'
	when 4 then 'Item Rate Sheet'
	when 5 then 'Task'
 end as [Purchasing Get Rate From],
 rs.RateSheetName as [Expense Rate Sheet],
 srs.RateSheetName as [Labor Rate Sheet],
 tirs.RateSheetName as [Title Rate Sheet],
 c.ItemMarkup as [Purchasing Markup],
 case c.IOBillAt
	when 0 then 'Gross'
	when 1 then 'Net'
	when 2 then 'Commission Only'
 end as [Prebill Insertions At],
 case c.BCBillAt
	when 0 then 'Gross'
	when 1 then 'Net'
	when 2 then 'Commission Only'
 end as [Prebill Broadcast At],
 st1.SalesTaxName as [Sales Tax 1],
 st2.SalesTaxName as [Sales Tax 2],
 gla.AccountNumber + ' - ' + gla.AccountName as [Default Expense Account],
 gla2.AccountNumber + ' - ' + gla2.AccountName as [Default Sales Account],
 t.TeamName as [Account Team],
 cb.FirstName + ' ' + cb.LastName as [Created By],
 c.DateUpdated as [Date Updated],
 cb.FirstName + ' ' + cb.LastName as [Last Modified By],
 0 AS ASC_Selected,
 c.TermsPercent as [Vendor Discount Percent],
 c.TermsDays as [Vendor Discount Days],
 c.TermsNet as [Vendor Days Net Due],
 case  when c.Overhead = 1 Then 'YES' else 'NO' end as [OverHead Client], 
 case when c.CCAccepted = 1 Then 'YES' else 'NO' end as [Vendor Accepts Credit Cards],

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
c.CurrencyID as Currency
FROM tCompany c (nolock)  
LEFT OUTER JOIN tCompanyType ct (nolock) ON c.CompanyTypeKey = ct.CompanyTypeKey  
LEFT OUTER JOIN tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey  
Left outer join tUser u (nolock) ON c.AccountManagerKey = u.UserKey    
left outer join tUser pct (nolock) on c.PrimaryContact = pct.UserKey  
Left Outer join tUser owner (nolock) on c.ContactOwnerKey = owner.UserKey  
Left Outer Join tUser cb (nolock) on c.CreatedBy = cb.UserKey
Left Outer Join tUser mb (nolock) on c.ModifiedBy = mb.UserKey
Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
Left outer join tAddress ab (nolock) on c.BillingAddressKey = ab.AddressKey
left outer join tInvoiceTemplate it (nolock) on c.InvoiceTemplateKey = it.InvoiceTemplateKey
left outer join tEstimateTemplate et (nolock) on c.EstimateTemplateKey = et.EstimateTemplateKey
left outer join tPaymentTerms pt (nolock) on c.PaymentTermsKey = pt.PaymentTermsKey
left outer join tItemRateSheet rs (nolock) on c.ItemRateSheetKey = rs.ItemRateSheetKey
left outer join tTimeRateSheet srs (nolock) on c.TimeRateSheetKey = srs.TimeRateSheetKey
left outer join tTitleRateSheet tirs (nolock) on c.TitleRateSheetKey = tirs.TitleRateSheetKey
left outer join tSalesTax st1 (nolock) on c.SalesTaxKey = st1.SalesTaxKey
left outer join tSalesTax st2 (nolock) on c.SalesTax2Key = st2.SalesTaxKey
LEFT OUTER JOIN tTeam t (nolock) ON c.DefaultTeamKey = t.TeamKey
LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on c.LastActivityKey = lastActivity.ActivityKey
LEFT OUTER JOIN tUser lau (NOLOCK) ON lastActivity.AssignedUserKey = lau.UserKey
LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on c.NextActivityKey = nextActivity.ActivityKey
LEFT OUTER JOIN tUser nau (NOLOCK) ON nextActivity.AssignedUserKey = nau.UserKey
LEFT OUTER JOIN tUser sales (NOLOCK) ON c.SalesPersonKey = sales.UserKey
LEFT OUTER JOIN tCMFolder folder (NOLOCK) on c.CMFolderKey = folder.CMFolderKey
LEFT OUTER JOIN	tSource so (NOLOCK) on c.SourceKey = so.SourceKey
LEFT OUTER JOIN tActivityType atNext (NOLOCK) ON nextActivity.ActivityTypeKey = atNext.ActivityTypeKey
LEFT OUTER JOIN tActivityType atLast (NOLOCK) ON lastActivity.ActivityTypeKey = atLast.ActivityTypeKey
LEFT OUTER JOIN tGLAccount gla (NOLOCK) ON c.DefaultExpenseAccountKey = gla.GLAccountKey
LEFT OUTER JOIN tGLAccount gla2 (NOLOCK) ON c.DefaultSalesAccountKey = gla2.GLAccountKey
GO
