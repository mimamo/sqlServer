USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Contact]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Contact]
AS

/*
  || When     Who Rel     What
  || 10/13/06 WES 8.3567  Added Account Manager
  || 10/16/06 WES 8.3567  Added Date Added
  || 01/30/07 BSH 8.4.1   Added Contact Address as in Custom Reports
  || 04/25/07 CRG 8.5     Added Company Type
  || 02/12/08 CRG 1.0.0.0 Added Is Primary Contact, Last Activity Date, Last Activity
  || 05/19/08 GHL 8.511   (26651) Fixed duplicate contact when last activity date has 2 activities
  || 07/01/08 GWG 10.5	  Added CMFolderKey and FolderName into the view
  || 08/01/08 GWG 10.5	  Made Company a left outer join and changed where OwnerCompanyKey comes from
  || 02/09/09 GWG 10.5	  Made cmfolderkey force to 0 so that a no folder check can be made.
  || 03/11/09 MAS 10.5	  Added Last and Next Activity columns, renamed columns, removed user_defined columns.
  || 04/03/09 GWG 10.5    Minor fixes to views
  || 04/30/09 CRG 10.5.0.0 Added Next/Last Activity Types, Days Since Last Activity, and No Activity Since
  || 05/15/09 ??? 10.5.0.0 Added User Company Name 
  || 10/28/09 GHL 10.513  (66843) Changed tCompany.CompanyName to [Linked Company] and added tUser.UserCompanyName as [Company Name]
  || 11/5/09  GWG 10.513  Changed company name to first on linked company then user company name
  || 12/22/09 GWG 10.515  Changed the join to Home address which was wrong
  || 12/27/09 GWG 10.515  Added Contact Company Name and Linked Company Name
  || 04/21/10 RLB 10.521  (79135, 79140) Added Contact Product, Contact Comments and Company Comments
  || 08/06/10 QMD 10.533  Added Marketing Message
  || 04/07/11 RLB 10.543  (108085) Added Contact Department
  || 05/30/12 GHL 10.556  Added Contractor info
  || 07/23/12 GWG 10.558  Changed contact ID to User Id cause no on knows what contact id is.
  || 02/12/13 WDF 10.565  (168365) Added Client Id.
  || 01/14/15 GWG 10.588  Added max date updated from opportunities for Mike
  */

SELECT 
	 u.OwnerCompanyKey
	,u.CompanyKey
	,u.UserKey
	,u.CustomFieldKey
	,c.CustomFieldKey as CompanyCustomFieldKey
	,ISNULL(u.CMFolderKey, 0) as CMFolderKey
	,cf.UserKey as FolderUserKey
	,u.OwnerKey as ContactOwnerKey
	,c.CompanyName AS [Linked Company]
	,ISNULL(c.CompanyName, u.UserCompanyName) AS [Company Name]
	,u.UserCompanyName as [Contact Company Name]
	,c.CompanyName as [Linked Company Name]
	,c.VendorID AS [Vendor ID]
	,c.CustomerID AS [Customer ID]
	,c.CustomerID AS [Client ID]
	,a_h.Address1 AS [Home Address 1]
	,a_h.Address2 AS [Home Address 2]
	,a_h.Address3 AS [Home Address 3]
	,a_h.City AS [Home City]
	,a_h.State AS [Home State]
	,a_h.PostalCode AS [Home Postal Code]
	,a_h.Country AS [Home Country]
	,ct.CompanyTypeName AS [Company Type]
	,CASE when c.Vendor = 1 then 'YES' else 'NO' end AS [Is a Vendor] 
	,CASE when c.BillableClient = 1 then 'YES' else 'NO' end AS [Is a Client] 
	,c.HourlyRate AS [Company Client Rate]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS [Company Address 1]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS [Company Address 2]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS [Company Address 3]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS [Company City]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS [Company State]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS [Company Postal Code]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS [Company Country]
	,c.WebSite AS [Company Web Site]
	,c.Phone AS [Company Main Phone]
	,c.Fax AS [Company Main Fax]
	,CASE when c.Active = 1 then 'YES' else 'NO' end AS [Company Active]
	,u.FirstName AS [Contact First Name]
	,u.LastName AS [Contact Last Name]
	,ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, '') AS [Contact Full Name]	
	,u.Salutation AS [Contact Salutation]
	,u.Phone1 AS [Contact Phone 1]
	,u.Phone2 AS [Contact Phone 2]
	,u.Cell AS [Contact Cell]
	,u.Fax AS [Contact Fax]
	,u.Pager AS [Contact Pager]
	,u.Title AS [Contact Title]
	,u.Email AS [Contact Email]
	,u.UserID AS [User ID]
	,u.SystemID AS [Contact System ID]
	,dept.DepartmentName As [Department]
	,u.Department As [Contact Department]
	,u.UserRole AS [Role]
	,u.DateConverted as [Date Converted]
	,ISNULL(u3.FirstName,'') + ' ' + ISNULL(u3.LastName, '') AS [Reports To]
	,u.Assistant
	,u.AssistantPhone AS [Assistant Phone]
	,u.AssistantEmail AS [Assistant Email]
	,u.Birthday
	,u.SpouseName AS [Spouse/Partner]
	,u.Children
	,u.Hobbies
	,u.Anniversary AS [Anniversary Date]
	,CASE WHEN u.DoNotCall = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Phone]
	,CASE WHEN u.DoNotFax = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Fax]
	,CASE WHEN u.DoNotEmail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Email]
	,CASE WHEN u.DoNotMail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Mail]
	,CASE when u.Active = 1 then 'YES' else 'NO' end AS [Active] 
	,CASE when u.ClientVendorLogin = 1 then 'YES' else 'NO' end AS [Contact Client Vendor Login]
	,cf.FolderName as [Folder]
	,cof.FolderName as [Company Folder]
	,u.DateAdded AS [User Date Added]
	,u.DateUpdated AS [User Date Updated]
	,s.GroupName AS [Contact Security Group Name]
	,cOwner.FirstName + ' ' + cOwner.LastName as [Contact Owner]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
        ,u.DateAdded as [Date Added]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [Personal Work Address 1]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [Personal Work Address 2]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [Personal Work Address 3]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [Personal Work City]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [Personal Work State]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [Personal Work Postal Code]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [Personal Work Country]
	,CASE WHEN c.PrimaryContact = u.UserKey THEN 'YES' ELSE '' END AS [Is Primary Contact]

	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address1 ELSE a_dc.Address1 END AS [Other Address 1]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address2 ELSE a_dc.Address2 END AS [Other Address 2]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address3 ELSE a_dc.Address3 END AS [Other Address 3]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.City ELSE a_dc.City END AS [Other City]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.State ELSE a_dc.State END AS [Other State]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.PostalCode ELSE a_dc.PostalCode END AS [Other Postal Code]
	,CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Country ELSE a_dc.Country END AS [Other Country]
	,ISNULL(owner.FirstName,'') + ' ' + ISNULL(owner.LastName, '') AS [Company Owner]
	,ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName, '') AS [Sales Person]
	,so.SourceName AS [Company Source]
	-- WWP
	,CASE u.WWPCurrentLevel 
		WHEN 2 THEN '2 - Contemplating'
		WHEN 3 THEN '3 - Planning'
		WHEN 4 THEN '4 - Action'
		ELSE '1 - Unaware' 
	 END AS [Contact WWP Level]

	-- Preferred Method of Contact
	,CASE u.ContactMethod 
		WHEN 1 THEN 'Phone' 
		WHEN 2 THEN 'Fax'
		WHEN 3 THEN 'Email'
		WHEN 4 THEN 'Mail'
		ELSE '' 
	 END AS [Preferred Method of Contact]	 
	
	,lastActivity.ActivityDate AS [Last Activity Date]
	,lastActivity.Subject AS [Last Activity Subject]
	,ISNULL(u1.FirstName,'') + ' ' + ISNULL(u1.LastName,'') AS [Last Activity Assigned To]

	,nextActivity.ActivityDate AS [Next Activity Date]
	,nextActivity.Subject AS [Next Activity Subject]
	,ISNULL(u2.FirstName,'') + ' ' + ISNULL(u2.LastName,'') AS [Next Activity Assigned To]
	,cd.DivisionName as [Contact Division]
	,cp.ProductName as [Contact Product]
	,u.Comments as [Contact Comments]
	,c.Comments as [Company Comments]
	 ,c.CompanyName as LinkedCompanyName --Needed for defaulting information into activity
	 ,u.FirstName
	 ,u.LastName
	 ,atNext.TypeName AS [Next Activity Type]
	 ,atLast.TypeName AS [Last Activity Type]
	 ,DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) AS [Days Since Last Activity]
	 ,CASE
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 90 THEN '90 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 60 THEN '60 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 30 THEN '30 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 7 THEN '7 Days'
		ELSE NULL
		END AS [No Activity Since]
	  ,u.MarketingMessage AS [Marketing Message]
	  ,case when u.Contractor = 1 then 'YES' else 'NO' end as [Contractor]
	  ,(Select Max(DateUpdated) from tLead l (nolock) Where l.ContactCompanyKey = u.CompanyKey) as [Opportunity Last Modified]
FROM tUser u (nolock)
left outer join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
left outer join tSecurityGroup s (nolock) on u.SecurityGroupKey = s.SecurityGroupKey
Left Outer join tUser cOwner (nolock) on u.OwnerKey = cOwner.UserKey
left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
left outer join tAddress a_h (nolock) on u.HomeAddressKey = a_h.AddressKey
left outer join tAddress a_o (nolock) on u.OtherAddressKey = a_o.AddressKey
left outer join tAddress a_dc (nolock) on c.DefaultAddressKey = a_dc.AddressKey
left outer join tAddress a_bc (nolock) on c.BillingAddressKey = a_bc.AddressKey
left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey
left outer join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
left outer join tActivity lca on u.LastActivityKey = lca.ActivityKey
left outer join tActivity nca on u.NextActivityKey = nca.ActivityKey
left outer join tCMFolder cf (nolock) on u.CMFolderKey = cf.CMFolderKey
left outer join tCMFolder cof (nolock) on c.CMFolderKey = cof.CMFolderKey
LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on u.LastActivityKey = lastActivity.ActivityKey
LEFT OUTER JOIN tUser u1 (NOLOCK) ON lastActivity.AssignedUserKey = u1.UserKey
LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on u.NextActivityKey = nextActivity.ActivityKey
LEFT OUTER JOIN tUser u2 (NOLOCK) ON nextActivity.AssignedUserKey = u2.UserKey
LEFT OUTER JOIN tDepartment dept (NOLOCK) ON u.DepartmentKey = dept.DepartmentKey
LEFT OUTER JOIN tUser u3 (NOLOCK) ON u.ReportsToKey = u3.UserKey
LEFT OUTER JOIN tUser owner (NOLOCK) ON c.ContactOwnerKey = owner.UserKey
LEFT OUTER JOIN tUser sales (NOLOCK) ON c.SalesPersonKey = sales.UserKey
LEFT OUTER JOIN	tSource so (NOLOCK) on c.SourceKey = so.SourceKey
LEFT OUTER JOIN tActivityType atNext (NOLOCK) ON nextActivity.ActivityTypeKey = atNext.ActivityTypeKey
LEFT OUTER JOIN tActivityType atLast (NOLOCK) ON lastActivity.ActivityTypeKey = atLast.ActivityTypeKey
LEFT OUTER JOIN tClientDivision cd (NOLOCK) ON u.ClientDivisionKey = cd.ClientDivisionKey
LEFT OUTER JOIN tClientProduct cp (NOLOCK) on u.ClientProductKey = cp.ClientProductKey
GO
