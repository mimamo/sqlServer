USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGetAppSetup]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptPreferenceGetAppSetup]
	@UserKey int
AS --Encrypt

/*
|| When     Who Rel     What
*/


	SELECT	ISNULL(ApplicationName, 'Workamajig') as ApplicationName, ISNULL(u.LanguageID, p.LanguageID) as LanguageID, p.Culture
	FROM	tPreference p (NOLOCK) 
	inner join tUser u (NOLOCK) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	WHERE	u.UserKey = @UserKey

 RETURN 1
GO
