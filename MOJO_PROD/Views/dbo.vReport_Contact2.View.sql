USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Contact2]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Contact2]
AS

/*
  || When     Who Rel     What
  || 10/11/06 WES 8.3567  Added Contact Owner
  || 11/06/07 CRG 8.5     (13138) Added Account Team.  Also added some missing nolock's.
  || 03/17/09 RTC 10.5	  Removed user defined fields.
  || 03/25/09 MAS 10.5	  Merged vReport_Contact fields leaving the CompanyKey, CustomFieldKey and CustomFieldKey2
  || 10/28/09 GHL 10.513  (66843) Changed tCompany.CompanyName to [Linked Company] and added tUser.UserCompanyName as [Company Name]
  || 04/21/10 RLB 10.521  (79135, 79140) Added Contact Product, Contact Comments and Company Comments
  || 02/19/15 GHL 10.589  Added Division and Product ID for Abelson Taylor  
*/

SELECT 
	tCompany.OwnerCompanyKey AS CompanyKey,		-- Left from original view
	tCompany.CustomFieldKey,					-- Left from original view
    tUser.CustomFieldKey as CustomFieldKey2,	-- Left from original view
	tCompany.CompanyName AS [Linked Company], 
	tUser.UserCompanyName AS [Company Name],  
	tCompany.VendorID AS [Vendor ID], 
	tCompany.CustomerID AS [Customer ID], 
	a_dc.Address1 AS [Home Address 1],
	a_dc.Address2 AS [Home Address 2],
	a_dc.Address3 AS [Home Address 3],
	a_dc.City AS [Home City],
	a_dc.State AS [Home State],
	a_dc.PostalCode AS [Home Postal Code],
	a_dc.Country AS [Home Country],
	case when tCompany.Vendor = 1 then 'YES' else 'NO' end AS [Is a Vendor], 
	case when tCompany.BillableClient = 1 then 'YES' else 'NO' end AS [Is a Client], 
	tCompany.HourlyRate AS [Client Rate], 
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS [Company Address 1],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS [Company Address 2],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS [Company Address 3],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS [Company City],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS [Company State],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS [Company Postal Code],
	CASE WHEN tCompany.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS [Company Country],
	tCompany.WebSite AS [Web Site], 
	tCompany.Phone AS [Company Main Phone], 
	tCompany.Fax AS [Company Main Fax], 
	case when tCompany.Active = 1 then 'YES' else 'NO' end AS [Company Active], 
	tCompany.UserDefined10 AS [Company User Defined 10],
	tCompanyType.CompanyTypeName AS [Company Type],
	tUser.FirstName AS [Contact First Name], 
	tUser.LastName AS [Contact Last Name], 
	tUser.FirstName + ' ' + tUser.LastName as [Contact Full Name],
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
	cp.ProductName as [Contact Product],
	cp.ProductID as [Contact Product ID],
	cd.DivisionName as [Contact Division],
	cd.DivisionID as [Contact Division ID],
	tUser.Comments as [Contact Comments],
	tCompany.Comments as [Company Comments], 
	CASE when tUser.ClientVendorLogin = 1 then 'YES' else 'NO' end AS [Contact Client Vendor Login],
	tUser.UserID AS [Contact ID]	,
	tUser.SystemID AS [Contact System ID],
	dept.DepartmentName As [Department],
	tUser.UserRole AS [Role],
	ISNULL(reports.FirstName,'') + ' ' + ISNULL(reports.LastName, '') AS [Reports To],
	tUser.Assistant,
	tUser.AssistantPhone AS [Assistant Phone],
	tUser.AssistantEmail AS [Assistant Email],
	tUser.Birthday,
	tUser.SpouseName AS [Spouse/Partner],
	tUser.Children,
	tUser.Hobbies,
	tUser.Anniversary AS [Anniversary Date],
	CASE WHEN tUser.DoNotCall = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Phone],
	CASE WHEN tUser.DoNotFax = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Fax],
	CASE WHEN tUser.DoNotEmail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Email],
	CASE WHEN tUser.DoNotMail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Mail],
	s.GroupName AS [Contact Security Group Name],
	tUser.DateAdded AS [Date Created],
	tUser.DateUpdated AS [Date Updated],
	tUser.LastLogin AS [Contact Last Login Date], 
	case when tUser.Active = 1 then 'YES' else 'NO' end AS [Contact Active], 
	tUser.HourlyRate AS [Contact Hourly Rate], 
	tUser.HourlyCost AS [Contact Hourly Cost],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [Personal Work Address 1],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [Personal Work Address 2],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [Personal Work Address 3],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [PersonalWork  City],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [Personal Work State],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [Personal Work Postal Code],
	CASE WHEN tUser.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [Personal Work Country],
	t.TeamName as [Account Team],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.Address1 ELSE a_dc.Address1 END AS [Other Address 1],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.Address2 ELSE a_dc.Address2 END AS [Other Address 2],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.Address3 ELSE a_dc.Address3 END AS [Other Address 3],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.City ELSE a_dc.City END AS [Other City],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.State ELSE a_dc.State END AS [Other State],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.PostalCode ELSE a_dc.PostalCode END AS [Other Postal Code],
	CASE WHEN tUser.OtherAddressKey IS NOT NULL THEN a_o.Country ELSE a_dc.Country END AS [Other Country],
	owner.FirstName + ' ' + owner.LastName as [Company Owner],
	ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName, '') AS [Sales Person],
	tCompany.SourceKey AS [Source ID],
	-- WWP
	CASE tUser.WWPCurrentLevel 
		WHEN 2 THEN '2 - Contemplating'
		WHEN 3 THEN '3 - Planning'
		WHEN 4 THEN '4 - Action'
		ELSE '1 - Unaware' 
	END AS [Contact WWP Level],

	lastActivity.ActivityDate AS [Last Activity Date],
	lastActivity.Subject AS [Last Activity Subject],
	ISNULL(lau.FirstName,'') + ' ' + ISNULL(lau.LastName,'') AS [Last Activity Assigned To],

	nextActivity.ActivityDate AS [Next Activity Date],
	nextActivity.Subject AS [Next Activity Subject],
	ISNULL(nau.FirstName,'') + ' ' + ISNULL(nau.LastName,'') AS [Next Activity Assigned To]

FROM tUser (nolock)
LEFT OUTER JOIN tSecurityGroup s (nolock) on tUser.SecurityGroupKey = s.SecurityGroupKey
LEFT OUTER JOIN tCompany (nolock) ON tUser.CompanyKey = tCompany.CompanyKey
LEFT OUTER JOIN tCompanyType (nolock) ON tCompany.CompanyTypeKey = tCompanyType.CompanyTypeKey
left outer join tAddress a_u (nolock) on tUser.AddressKey = a_u.AddressKey
left outer join tAddress a_o (nolock) on tUser.OtherAddressKey = a_o.AddressKey
left outer join tAddress a_dc (nolock) on tCompany.DefaultAddressKey = a_dc.AddressKey
left outer join tAddress a_bc (nolock) on tCompany.BillingAddressKey = a_bc.AddressKey
LEFT OUTER JOIN tTeam t (nolock) ON tCompany.DefaultTeamKey = t.TeamKey
Left Outer join tUser owner (nolock) on tCompany.ContactOwnerKey = owner.UserKey
LEFT OUTER JOIN tDepartment dept (NOLOCK) ON tUser.DepartmentKey = dept.DepartmentKey
LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on tUser.LastActivityKey = lastActivity.ActivityKey
LEFT OUTER JOIN tUser lau (NOLOCK) ON lastActivity.AssignedUserKey = lau.UserKey
LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on tUser.NextActivityKey = nextActivity.ActivityKey
LEFT OUTER JOIN tUser nau (NOLOCK) ON nextActivity.AssignedUserKey = nau.UserKey
LEFT OUTER JOIN tUser sales (NOLOCK) ON tCompany.SalesPersonKey = sales.UserKey
LEFT OUTER JOIN tUser reports (NOLOCK) ON tUser.ReportsToKey = reports.UserKey
LEFT OUTER JOIN tClientProduct cp (NOLOCK) on tUser.ClientProductKey = cp.ClientProductKey
LEFT OUTER JOIN tClientDivision cd (NOLOCK) on tUser.ClientDivisionKey = cd.ClientDivisionKey
GO
