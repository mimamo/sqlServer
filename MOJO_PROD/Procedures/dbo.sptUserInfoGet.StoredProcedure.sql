USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserInfoGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserInfoGet]
  @UserKey int
AS --Encrypt

/*
  || When     Who Rel    What
  || 02/15/08 BSH WMJ1.0 Created SP.
  || 02/29/08 CRG 1.0    Added CompanyDateAdded, CompanyDateUpdated
  || 03/04/08 CRG 1.0    Added Company Address columns
  || 10/1/08  GWG 10.5 Added Client ID and removed the inner join to tCompany
  || 01/13/09 RTC 10.5   Added additional info required for listing form 
  || 06/10/09 MFT 10.5   Added ReportsTo and CompanyFax to support ContactSnapshot, corrected ContactOwnerName to CompanyOwnerName, added ContactOwnerName
*/
 
 DECLARE @CompanyKey int
 
	SELECT  @CompanyKey = CompanyKey
	FROM	tUser (NOLOCK)
	WHERE	UserKey = @UserKey
 
	SELECT	u.*, 
			ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName,
			c.CompanyKey,
			c.CompanyName, 
			c.CustomerID,
			c.WebSite, 
			c.WWPCurrentLevel AS WWPCurrentLevelCompany,
			ad.AddressName,
			ad.Address1,
			ad.Address2,
			ad.Address3,
			ad.City,
			ad.State,
			ad.Country,
			ad.PostalCode,
			cad.AddressName AS CompanyAddressName,
			cad.Address1 AS CompanyAddress1,
			cad.Address2 AS CompanyAddress2,
			cad.Address3 AS CompanyAddress3,
			cad.City AS CompanyCity,
			cad.State AS CompanyState,
			cad.Country AS CompanyCountry,
			cad.PostalCode AS CompanyPostalCode,
			c.Phone,
			ISNULL(cpou.FirstName, '') + ' ' + ISNULL(cpou.LastName, '') AS CompanyOwnerName,
			ISNULL(ctou.FirstName, '') + ' ' + ISNULL(ctou.LastName, '') AS ContactOwnerName,
			ISNULL(am.FirstName, '') + ' ' + ISNULL(am.LastName, '') AS AccountManagerName,
		    c.DateAdded as CompanyDateAdded,
		    c.DateUpdated as CompanyDateUpdated,
		    ISNULL(rt.FirstName, '') + ' ' + ISNULL(rt.LastName, '') AS ReportsTo
	FROM	tUser u (nolock)
			left outer join tCompany c (NOLOCK) on u.CompanyKey = c.CompanyKey
			left outer join tUser cpou (nolock) on c.ContactOwnerKey = cpou.UserKey
			left outer join tUser am (nolock) on c.AccountManagerKey = am.UserKey
			left outer join tUser ctou (nolock) on u.OwnerKey = ctou.UserKey
			left outer join tAddress ad (nolock) on ISNULL(u.AddressKey, c.DefaultAddressKey) = ad.AddressKey
			left outer join tAddress cad (nolock) on c.DefaultAddressKey = cad.AddressKey
			left outer join tUser rt (nolock) on u.ReportsToKey = rt.UserKey
	WHERE	u.UserKey = @UserKey

	-- last activity for user
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUser cont (nolock) on cont.LastActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserKey = @UserKey

	-- next activity for user
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUser cont (nolock) on cont.NextActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserKey = @UserKey

	-- level history for user
	SELECT *
	   FROM   tLevelHistory lh (NOLOCK)
	   WHERE  EntityKey = @UserKey and Entity = 'tUser'
	   Order By LevelDate DESC
	   
	-- last activity for company
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tCompany c (nolock) on c.LastActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		c.CompanyKey = @CompanyKey

	-- next activity for company
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tCompany c (nolock) on c.NextActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		c.CompanyKey = @CompanyKey

	-- level history for company
	SELECT *
	   FROM   tLevelHistory lh (NOLOCK)
	   WHERE  EntityKey = @CompanyKey and Entity = 'tCompany'
	   Order By LevelDate DESC
GO
