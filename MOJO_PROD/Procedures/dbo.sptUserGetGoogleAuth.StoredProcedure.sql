USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetGoogleAuth]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptUserGetGoogleAuth]
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 09/08/14  CRG 10.5.8.4 Created to get the Authentication info for Google
*/

	SELECT	GoogleAuthToken, GoogleAuthTokenExpires, GoogleRefreshToken, GoogleRefreshTokenExpires, GETUTCDATE() AS ServerDate
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
GO
