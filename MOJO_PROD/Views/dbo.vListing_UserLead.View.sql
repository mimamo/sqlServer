USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_UserLead]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_UserLead]
AS

/*
  || When     Who Rel       What
  || 07/31/08 QMD 10.5.0.0  Initial Release
  || 02/09/09 GWG 10.5	    Made cmfolderkey force to 0 so that a no folder check can be made.
  || 03/11/09 MAS 10.5	    Added Last and Next Activity columns.
  || 04/03/09 GWG 10.5      Minor fixes to views
  || 04/07/09 GWG 10.5      Added hidden name for passing lead name to the activity history.
  || 04/30/09 CRG 10.5.0.0  Added Next/Last Activity Types, Days Since Last Activity, and No Activity Since
  || 08/06/10 QMD 10.5.3.3  Added MarketingMessage
  || 05/16/11 RLB 10.5.4.4  Added Oppt Custom Fields
  || 07/24/12 GHL 10.5.5.8  Added GL Company info
  || 03/11/14 KMC 10.5.7.8  (209380) Added ISNULL to CompanyTypeName
  */

SELECT 
	u.UserLeadKey,
	u.CompanyKey,
	u.GLCompanyKey,
	ISNULL(u.CMFolderKey, 0) as CMFolderKey,
	u.OwnerKey,
	u.UserCustomFieldKey,
	u.CompanyCustomFieldKey,
	u.OppCustomFieldKey,
	case When u.FirstName is null and u.LastName is null then u.CompanyName else ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, '') end AS [HiddenName],
	u.TimeZoneIndex,
	u.FirstName AS [First Name],
	u.MiddleName AS [Middle Name],
	u.LastName AS [Last Name],
	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, '') AS [Full Name],
	u.Salutation AS [Salutation],
	u.Phone1,
	u.Phone2,
	u.Cell,
	u.Fax,
	u.Pager,
	u.Title,
	u.Email,
	u.CompanyName AS [Company Name],
	u.CompanyPhone AS [Company Phone],
	u.CompanyFax AS [Company Fax],
	u.CompanyWebsite AS [Company Website],
	ISNULL(ct.CompanyTypeName, '') AS [Company Type],
	u.OppSubject AS [Opportunity Subject],
	u.OppAmount AS [Opportunity Amount],
	p.ProjectTypeName AS [Opportunity Project Type],
	u.OppDescription AS [Opportunity Description],
	u.ContactMethod AS [Contact Method],
	CASE When u.DoNotCall = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Call],
	CASE When u.DoNotEmail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Email],
	CASE When u.DoNotMail = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Mail],
	CASE When u.DoNotFax = 1 THEN 'YES' ELSE 'NO' END AS [Do Not Fax],
	CASE u.Active WHEN 1 THEN 'YES' ELSE 'NO' END AS [Active],
	ISNULL(u1.FirstName,'') + ' ' + ISNULL(u1.LastName,'')    AS [Added By],
	u.DateAdded AS [Added Date],
	ISNULL(u2.FirstName,'') + ' ' + ISNULL(u2.LastName,'') AS [Updated By],	
	u.DateUpdated AS [Updated Date],
	ISNULL(u3.FirstName,'') + ' ' + ISNULL(u3.LastName,'') AS [Lead Owner],
	f.FolderName AS [Folder],
	u.Department,
	u.UserRole AS [Role],
	u.Assistant,
	u.AssistantPhone AS [Assistant Phone],
	u.AssistantEmail [Assistant Email],
	u.Birthday,
	u.SpouseName AS [Spouse Name],
	u.Children,
	u.Anniversary,
	u.Hobbies,
	u.Comments,

	bizAdd.AddressName AS [Business Address Name],
	bizAdd.Address1 AS [Business Address1], 
	bizAdd.Address2 AS [Business Address2],
	bizAdd.Address3 AS [Business Address3], 
	bizAdd.City AS [Business Address City],
	bizAdd.State AS [Business Address State],
	bizAdd.PostalCode AS [Business Address Postal Code], 
	bizAdd.Country AS [Business Address Country],

	homeAdd.AddressName AS [Home Address Name],
	homeAdd.Address1 AS [Home Address1], 
	homeAdd.Address2 AS [Home Address2],
	homeAdd.Address3 AS [Home Address3], 
	homeAdd.City AS [Home Address City],
	homeAdd.State AS [Home Address State],
	homeAdd.PostalCode AS [Home Address Postal Code], 
	homeAdd.Country AS [Home Address Country],

	otherAdd.AddressName AS [Other Address Name],
	otherAdd.Address1 AS [Other Address1], 
	otherAdd.Address2 AS [Other Address2],
	otherAdd.Address3 AS [Other Address3], 
	otherAdd.City AS [Other Address City],
	otherAdd.State AS [Other Address State],
	otherAdd.PostalCode AS [Other Address Postal Code], 
	otherAdd.Country AS [Other Address Country],

	lastActivity.ActivityDate AS [Last Activity Date],
	lastActivity.Subject AS [Last Activity Subject],
	ISNULL(u4.FirstName,'') + ' ' + ISNULL(u4.LastName,'') AS [Last Activity Assigned To],

	nextActivity.ActivityDate AS [Next Activity Date],
	nextActivity.Subject AS [Next Activity Subject],
	ISNULL(u5.FirstName,'') + ' ' + ISNULL(u5.LastName,'') AS [Next Activity Assigned To],
	s.SourceName as [Source],
	-- Preferred Method of Contact
	CASE u.ContactMethod 
		WHEN 1 THEN 'Phone' 
		WHEN 2 THEN 'Fax'
		WHEN 3 THEN 'Email'
		WHEN 4 THEN 'Mail'
		ELSE '' 
	END AS [Preferred Method of Contact],
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
	u.MarketingMessage AS [Marketing Message],
	glc.GLCompanyID as [GL Company ID],
    glc.GLCompanyName as [GL Company Name]
FROM tUserLead u (NOLOCK)
	LEFT OUTER JOIN tCompany c (NOLOCK) ON u.CompanyKey = c.CompanyKey
	LEFT OUTER JOIN tAddress bizAdd (NOLOCK) ON u.AddressKey = bizAdd.AddressKey
	LEFT OUTER JOIN tAddress homeAdd (NOLOCK) ON u.HomeAddressKey = homeAdd.AddressKey
	LEFT OUTER JOIN tAddress otherAdd (NOLOCK) ON u.OtherAddressKey = otherAdd.AddressKey
	LEFT OUTER JOIN tUser u1 (NOLOCK) ON u.AddedByKey = u1.UserKey
	LEFT OUTER JOIN tUser u2 (NOLOCK) ON u.UpdatedByKey = u2.UserKey
	LEFT OUTER JOIN tUser u3 (NOLOCK) ON u.OwnerKey = u3.UserKey
	LEFT OUTER JOIN tCMFolder f (NOLOCK) ON u.CMFolderKey = f.CMFolderKey
	LEFT OUTER JOIN tCompanyType ct (NOLOCK) ON u.CompanyTypeKey = ct.CompanyTypeKey
	LEFT OUTER JOIN tProjectType p (NOLOCK) ON u.OppProjectTypeKey = p.ProjectTypeKey
	LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on u.LastActivityKey = lastActivity.ActivityKey
	LEFT OUTER JOIN tUser u4 (NOLOCK) ON lastActivity.AssignedUserKey = u4.UserKey
	LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on u.NextActivityKey = nextActivity.ActivityKey
	LEFT OUTER JOIN tUser u5 (NOLOCK) ON nextActivity.AssignedUserKey = u5.UserKey
	LEFT OUTER JOIN tSource s (NOLOCK) on u.CompanySourceKey = s.SourceKey
	LEFT OUTER JOIN tActivityType atNext (NOLOCK) ON nextActivity.ActivityTypeKey = atNext.ActivityTypeKey
	LEFT OUTER JOIN tActivityType atLast (NOLOCK) ON lastActivity.ActivityTypeKey = atLast.ActivityTypeKey
	LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON u.GLCompanyKey = glc.GLCompanyKey
GO
