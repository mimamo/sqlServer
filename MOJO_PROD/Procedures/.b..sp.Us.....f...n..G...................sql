USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceGet]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceGet]
	@UserKey int

AS --Encrypt

		SELECT 
			u.FirstName + ' ' + u.LastName as UserName,
			up.*
		FROM tUser u (NOLOCK) Left Outer Join
			tUserPreference up (NOLOCK) on u.UserKey = up.UserKey
		WHERE
			u.UserKey = @UserKey

	RETURN 1
GO
