USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ContactActivity]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        VIEW [dbo].[vReport_ContactActivity]
AS

/*
  || When     Who Rel       What
  || 04/30/08 GHL 8.509  Replaced left outer join between tCompany and tContactActivity by inner join 
  */

SELECT 
	tCompany.OwnerCompanyKey AS CompanyKey, 
	tCompany.CustomFieldKey,
	tCompany.CompanyName AS [Company Name], 
	tCompany.VendorID AS [Vendor ID], 
	tCompany.CustomerID AS [Customer ID], 
	a_dc.Address1 AS [Mailing Address1],
	a_dc.Address2 AS [Mailing Address2],
	a_dc.Address3 AS [Mailing Address3],
	a_dc.City AS [Mailing City],
	a_dc.State AS [Mailing State],
	a_dc.PostalCode AS [Mailing Postal Code],
	a_dc.Country AS [Mailing Country],
	case when tCompany.Vendor = 1 then 'YES' else 'NO' end AS [Is a Vendor], 
	case when tCompany.BillableClient = 1 then 'YES' else 'NO' end AS [Is a Client], 
	tCompany.HourlyRate AS [Client Rate], 
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS [Billing Address1],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS [Billing Address2],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS [Billing Address3],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS [Billing City],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS [Billing State],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS [Billing Postal Code],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS [Billing Country],
	tCompany.WebSite AS [Web Site], 
	tCompany.Phone AS [Company Main Phone], 
	tCompany.Fax AS [Company Main Fax], 
	case when tCompany.Active = 1 then 'YES' else 'NO' end AS [Company Active], 
	tCompany.UserDefined1 AS [Company User Defined 1],
	tCompany.UserDefined2 AS [Company User Defined 2],
	tCompany.UserDefined3 AS [Company User Defined 3],
	tCompany.UserDefined4 AS [Company User Defined 4],
	tCompany.UserDefined5 AS [Company User Defined 5],
	tCompany.UserDefined6 AS [Company User Defined 6],
	tCompany.UserDefined7 AS [Company User Defined 7],
	tCompany.UserDefined8 AS [Company User Defined 8],
	tCompany.UserDefined9 AS [Company User Defined 9],
	tCompany.UserDefined10 AS [Company User Defined 10],
	tUser2.FirstName + ' ' + tUser2.LastName AS [Contact Owner],
	tCompanyType.CompanyTypeName AS [Company Type],
	tUser.FirstName AS [Contact First Name], 
	tUser.LastName AS [Contact Last Name], 
	tUser.LastName + ', ' + tUser.FirstName AS [Contact Last First],
	tUser.FirstName + ' ' + tUser.LastName AS [Contact First Last],
	tUser.Salutation AS [Contact Salutation], 
	tUser.Phone1 AS [Contact Phone 1], 
	tUser.Phone2 AS [Contact Phone 2], 
	tUser.Cell AS [Contact Cell], 
	tUser.Fax AS [Contact Fax], 
	tUser.Pager AS [Contact Pager], 
	tUser.Title AS [Contact Title], 
	tUser.Email AS [Contact Email], 
	tUser.LastLogin AS [Contact Last Login Date], 
	case when tUser.Active = 1 then 'YES' else 'NO' end AS [Contact Active], 
	tUser.HourlyRate AS [Contact Hourly Rate], 
	tUser.HourlyCost AS [Contact Hourly Cost],
	tUser.UserDefined1 AS [Contact User Defined 1],
	tUser.UserDefined2 AS [Contact User Defined 2],
	tUser.UserDefined3 AS [Contact User Defined 3],
	tUser.UserDefined4 AS [Contact User Defined 4],
	tUser.UserDefined5 AS [Contact User Defined 5],
	tUser.UserDefined6 AS [Contact User Defined 6],
	tUser.UserDefined7 AS [Contact User Defined 7],
	tUser.UserDefined8 AS [Contact User Defined 8],
	tUser.UserDefined9 AS [Contact User Defined 9],
	tUser.UserDefined10 AS [Contact User Defined 10],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [Contact Address1],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [Contact Address2],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [Contact Address3],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [Contact City],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [Contact State],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [Contact Postal Code],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [Contact Country],
	tContactActivity.Type AS [Activity Type], 
	tContactActivity.Subject AS [Activity Subject], 
	tUser1.FirstName + ' ' + tUser1.LastName AS [Activity Assigned To Name],
	case when tContactActivity.Status = 1 then 'OPEN' else 'COMPLETED' end AS [Activity Status], 
	case when tContactActivity.Outcome = 1 then 'SUCCESSFUL' else 'UNSUCCESSFUL' end AS [Activity Outcome], 
	tContactActivity.ActivityDate AS [Activity Date], 
	tContactActivity.ActivityTime AS [Activity Time], 
	tContactActivity.DateCompleted AS [Activity Date Completed],
	tContactActivity.Priority as [Activity Priority],
	tLead.Subject AS [Lead Name], 
	tProject.ProjectName AS [Project Name], 
	CAST(tContactActivity.Notes  AS VARCHAR(8000)) AS [Activity Notes]
FROM 	tCompany 
	INNER JOIN tContactActivity ON 
    	tCompany.CompanyKey = tContactActivity.ContactCompanyKey
    	LEFT OUTER JOIN tUser tUser1 ON 
    	tContactActivity.AssignedUserKey = tUser1.UserKey 
	LEFT OUTER JOIN tProject ON 
    	tContactActivity.ProjectKey = tProject.ProjectKey 
	LEFT OUTER JOIN tLead ON 
    	tContactActivity.LeadKey = tLead.LeadKey 
	LEFT OUTER JOIN tUser ON 
    	tContactActivity.ContactKey = tUser.UserKey
	LEFT OUTER JOIN tUser tUser2 ON 
    	tCompany.ContactOwnerKey = tUser2.UserKey
	LEFT OUTER JOIN tCompanyType ON 
    	tCompany.CompanyTypeKey = tCompanyType.CompanyTypeKey
	left outer join tAddress a_u (nolock) on tUser.AddressKey = a_u.AddressKey
	left outer join tAddress a_dc (nolock) on tCompany.DefaultAddressKey = a_dc.AddressKey
	left outer join tAddress a_bc (nolock) on tCompany.BillingAddressKey = a_bc.AddressKey
GO
