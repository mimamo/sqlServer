USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vMailingMembers_EMMA]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMailingMembers_EMMA]

/*
|| When     Who Rel			What
|| 09/25/08 QMD 10.5		Initial Release
|| 02/03/09 QMD 10.5		Added Last_Modified
|| 03/30/09 QMD 10.5		Added Restriction to limit view to only contacts and leads in 
||							a Marketing Group.
|| 03/30/09 QMD 10.5.6.2	Added ExternalMarketingKey
||                    
*/

AS
SELECT	'U' + CONVERT(VARCHAR(10), u.UserKey) AS IGNORE_ALWAYS_MemberID,
		u.OwnerCompanyKey AS IGNORE_ALWAYS_CompanyKey,
		u.FirstName AS DEFAULT_First_Name, 
		u.MiddleName AS DEFAULT_Middle_Name,
		u.LastName AS DEFAULT_Last_Name,
		u.Salutation,
		u.Phone1 AS DEFAULT_Phone,
		u.Phone2 AS Phone_2,
		u.Cell,
		u.Fax AS DEFAULT_Fax,
		u.Pager,
		u.Title,
		u.Email AS DEFAULT_Email,
		u.ContactMethod AS Preferred_Contact_Method,
		u.Active,
		u.DoNotCall AS Do_Not_Call,
		u.DoNotEmail AS Do_Not_Email,
		u.DoNotMail AS Do_Not_Mail,
		u.DoNotFax AS Do_Not_Fax,
		u.Department,
		u.Assistant,
		u.AssistantPhone AS Assistant_Phone,
		u.AssistantEmail AS Assistant_Email,
		u.Birthday,
		u.SpouseName AS Spouse_Partner,
		u.Children,
		u.Anniversary,	
		u.Hobbies,
		u.DateUpdated AS Last_Modified,
		u.UserCompanyName AS DEFAULT_Company,
		a.Address1 AS DEFAULT_Address,
		a.Address2 AS DEFAULT_Address_2,
		a.City AS DEFAULT_City,
		a.State AS DEFAULT_Province,
		a.PostalCode AS DEFAULT_Zip_Code,
		a.Country AS DEFAULT_Country,
		u.ExternalMarketingKey AS IGNORE_ExternalMarketingKey
FROM	tUser u (NOLOCK) LEFT JOIN tAddress a (NOLOCK) ON u.AddressKey = a.AddressKey
WHERE	EXISTS (SELECT	*
				FROM	tMarketingList ml (NOLOCK) INNER JOIN tMarketingListList mll (NOLOCK) ON ml.MarketingListKey = mll.MarketingListKey
				WHERE	ml.CompanyKey = u.OwnerCompanyKey
						AND mll.EntityKey = u.UserKey
						AND mll.Entity = 'tUser')
UNION

SELECT	'L' + CONVERT(VARCHAR(10), ul.UserLeadKey) AS IGNORE_MemberID,
		ul.CompanyKey AS IGNORE_ALWAYS_CompanyKey,
		ul.FirstName AS DEFAULT_First_Name, 
		ul.MiddleName AS DEFAULT_Middle_Name,
		ul.LastName AS DEFAULT_Last_Name,
		ul.Salutation,
		ul.Phone1 AS DEFAULT_Phone,
		ul.Phone2 AS Phone_2,
		ul.Cell,
		ul.Fax AS DEFAULT_Fax,
		ul.Pager,
		ul.Title,
		ul.Email AS DEFAULT_Email,
		ul.ContactMethod AS Preferred_Contact_Method,
		ul.Active,
		ul.DoNotCall AS Do_Not_Call,
		ul.DoNotEmail AS Do_Not_Email,
		ul.DoNotMail AS Do_Not_Mail,
		ul.DoNotFax AS Do_Not_Fax,
		ul.Department,
		ul.Assistant,
		ul.AssistantPhone AS Assistant_Phone,
		ul.AssistantEmail AS Assistant_Email,
		ul.Birthday,
		ul.SpouseName AS Spouse_Partner,
		ul.Children,
		ul.Anniversary,	
		ul.Hobbies,
		ul.DateUpdated AS Last_Modified,
		ul.CompanyName AS DEFAULT_Company,
		a.Address1 AS DEFAULT_Address,
		a.Address2 AS DEFAULT_Address_2,
		a.City AS DEFAULT_City,
		a.State AS DEFAULT_Province,
		a.PostalCode AS DEFAULT_Zip_Code,
		a.Country AS DEFAULT_Country,
		ul.ExternalMarketingKey AS IGNORE_ExternalMarketingKey
FROM	tUserLead ul (NOLOCK) LEFT JOIN tAddress a ON ul.AddressKey = a.AddressKey
WHERE	EXISTS (SELECT	*
				FROM	tMarketingList ml (NOLOCK) INNER JOIN tMarketingListList mll (NOLOCK) ON ml.MarketingListKey = mll.MarketingListKey
				WHERE	ml.CompanyKey = ul.CompanyKey
						AND mll.EntityKey = ul.UserLeadKey
						AND mll.Entity = 'tUserLead')
GO
