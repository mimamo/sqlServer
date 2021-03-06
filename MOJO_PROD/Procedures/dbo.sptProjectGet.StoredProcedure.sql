USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGet]
	@ProjectKey int = 0,
	@ProjectNumber varchar(50) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 08/12/2009 MFT 10.5.0.7 Added ProjectNumber & CompanyKey params and condition
  || 05/25/10   GWG 10.5.3   Added some client fields to simplify gets
  || 01/31/14   MAS 10.5.7.6 Added fields for the "new app" Diary
*/


IF @ProjectKey > 0
	SELECT p.*
	, c.CustomerID as ClientID, c.CompanyName as ClientName
	, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
	, pc.Phone1 as PrimaryContactPhone
	, pc.Email as PrimaryContactEmail
	, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
	FROM tProject p (NOLOCK)
	LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
	LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
  	WHERE ProjectKey = @ProjectKey
ELSE
	SELECT p.*
	, c.CustomerID as ClientID, c.CompanyName as ClientName
	, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
	, pc.Phone1 as PrimaryContactPhone
	, pc.Email as PrimaryContactEmail
	, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
	FROM tProject p (NOLOCK)
	LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
	LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
	WHERE
		p.CompanyKey = @CompanyKey AND
		ProjectNumber = @ProjectNumber

RETURN 1
GO
