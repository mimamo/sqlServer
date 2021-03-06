USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListGet]
	@MarketingListKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 06/25/09  MAS 10.5.0.0 (55679) Added ISNULL when concatinating full names
|| 07/14/10  QMD 10.5.3.3 Added MarketingMessage to display Error message from emma sync
|| 11/14/10  QMD 10.5.3.7 Changed name of MarketingMessage
*/
		SELECT *
		FROM tMarketingList
		WHERE
			MarketingListKey = @MarketingListKey




			SELECT 
				 'tUser' as Entity
				,u.UserKey as EntityKey
				,u.CustomFieldKey
				,c.CustomFieldKey as CompanyCustomFieldKey
				,c.CompanyName
				,a_dc.Address1 AS [CompanyMailingAddress1]
				,a_dc.Address2 AS [CompanyMailingAddress2]
				,a_dc.Address3 AS [CompanyMailingAddress3]
				,a_dc.City AS [CompanyMailingCity]
				,a_dc.State AS [CompanyMailingState]
				,a_dc.PostalCode AS [CompanyMailingPostalCode]
				,a_dc.Country AS [CompanyMailingCountry]
				,ct.CompanyTypeName AS [CompanyType]
				,c.WebSite AS [CompanyWebSite]
				,c.Phone AS [CompanyMainPhone]
				,c.Fax AS [CompanyMainFax]
				,s.SourceName as [CompanySource]
				,u.FirstName AS [UserFirstName]
				,u.LastName AS [UserLastName]
				,ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') as [UserFullName]	
				,u.Salutation AS [UserSalutation]
				,u.Phone1 AS [UserPhone1]
				,u.Phone2 AS [UserPhone2]
				,u.Cell AS [UserCell]
				,u.Fax AS [UserFax]
				,u.Pager AS [UserPager]
				,u.Title AS [UserTitle]
				,u.Email AS [UserEmail]
				,u.UserRole as [UserRole]
				,CASE when u.Active = 1 then 'YES' else 'NO' end AS [Active] 
				,ISNULL(cOwner.FirstName,'') + ' ' + ISNULL(cOwner.LastName,'') as [ContactOwner]
				,ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName,'') as [AccountManager]
				,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [ContactAddress1],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [ContactAddress2],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [ContactAddress3],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [ContactCity],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [ContactState],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [ContactPostalCode],
				CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [ContactCountry],
				CASE WHEN c.PrimaryContact = u.UserKey THEN 'YES' ELSE '' END AS [IsPrimaryContact],
				u.MarketingMessage AS [LastSyncMessage]
			 
			FROM tMarketingListList mll (nolock) 
				inner join tUser u (nolock) on mll.EntityKey = u.UserKey
				left outer join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
				Left Outer join tUser cOwner (nolock) on u.OwnerKey = cOwner.UserKey
				left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
				left outer join tAddress a_dc (nolock) on c.DefaultAddressKey = a_dc.AddressKey
				left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey
				left outer join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
				left outer join tSource s (nolock) on c.SourceKey = s.SourceKey
			Where mll.MarketingListKey = @MarketingListKey
				and mll.Entity = 'tUser'
				

			SELECT 
				 'tUserLead' as Entity
				,u.UserLeadKey as EntityKey
				,u.UserCustomFieldKey as CustomFieldKey
				,u.CompanyCustomFieldKey as CompanyCustomFieldKey
				,u.CompanyName
				,ct.CompanyTypeName AS [CompanyType]
				,u.CompanyWebsite AS [CompanyWebSite]
				,u.CompanyPhone AS [CompanyMainPhone]
				,u.CompanyFax AS [CompanyMainFax]
				,s.SourceName as [CompanySource]
				,u.FirstName AS [UserFirstName]
				,u.LastName AS [UserLastName]
				,ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') as [UserFullName]	
				,u.Salutation AS [UserSalutation]
				,u.Phone1 AS [UserPhone1]
				,u.Phone2 AS [UserPhone2]
				,u.Cell AS [UserCell]
				,u.Fax AS [UserFax]
				,u.Pager AS [UserPager]
				,u.Title AS [UserTitle]
				,u.Email AS [UserEmail]
				,u.UserRole as [UserRole]
				,CASE when u.Active = 1 then 'YES' else 'NO' end AS [Active] 
				,ISNULL(cOwner.FirstName,'') + ' ' + ISNULL(cOwner.LastName,'') as [ContactOwner]
				,a_u.Address1 [ContactAddress1]
				,a_u.Address2 [ContactAddress2]
				,a_u.Address3 [ContactAddress3]
				,a_u.City [ContactCity]
				,a_u.State [ContactState]
				,a_u.PostalCode [ContactPostalCode]
				,a_u.Country [ContactCountry]
			    ,u.MarketingMessage AS [LastSyncMessage]
			From tMarketingListList mll (nolock) 
				inner join tUserLead u (nolock) on mll.EntityKey = u.UserLeadKey
				Left Outer join tUser cOwner (nolock) on u.OwnerKey = cOwner.UserKey
				left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
				left outer join tCompanyType ct (nolock) on u.CompanyTypeKey = ct.CompanyTypeKey
				left outer join tSource s (nolock) on u.CompanySourceKey = s.SourceKey
			Where mll.MarketingListKey = @MarketingListKey
			and mll.Entity = 'tUserLead'



	RETURN 1
GO
