USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserApiGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel       What
  || 12/03/14 QMD 10.5.8.7  Created to get the API user
*/
CREATE PROCEDURE [dbo].[sptUserApiGet] 
	@APIAccessToken AS VARCHAR(MAX),
	@PublicUserToken AS VARCHAR(MAX)
AS

	SELECT	up.PrivateUserToken, u.UserKey, u.CompanyKey 
	FROM	tUserPreference up (NOLOCK) INNER JOIN tUser u (NOLOCK) ON u.UserKey = up.UserKey
				INNER JOIN tPreference p (NOLOCK) ON u.CompanyKey = p.CompanyKey
	WHERE	up.PublicUserToken = @PublicUserToken
			AND p.APIAccessToken = @APIAccessToken
GO
