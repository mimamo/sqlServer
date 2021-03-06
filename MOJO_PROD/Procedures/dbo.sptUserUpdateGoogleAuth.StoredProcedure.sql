USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateGoogleAuth]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateGoogleAuth]
	(
		@UserKey int,
		@GoogleAuthToken varchar(1000),
		@GoogleAuthTokenExpireSeconds int,
		@GoogleRefreshToken varchar(1000)
	)
AS --Encrypt

  /*
  || This stored procedure is intended to handle an update to both tokens at the same time or just an update to a single token.

  || When     Who Rel		What
  || 09/04/14 KMC 10.5.8.4  Added to update authorization information being returned from Google.
  || 09/08/14 CRG 10.5.8.4  Added @GoogleAuthTokenExpireSeconds, and now defaulting GoogleRefreshTokenExpires to 60 days
  || 1/14/15  KMC 10.5.8.8  Added update to tCMFolder for GoogleLoginAttempts to reset to zero when reauthorized
  */

	IF ISNULL(@GoogleAuthToken, '') <> ''
	BEGIN
		IF @GoogleAuthTokenExpireSeconds > 0
			SELECT	@GoogleAuthTokenExpireSeconds = @GoogleAuthTokenExpireSeconds - 900 --Set it to 15 min. less than the actual expire time
	
		UPDATE tUser
	       SET GoogleAuthToken = @GoogleAuthToken, GoogleAuthTokenExpires = DATEADD(S, @GoogleAuthTokenExpireSeconds, GETUTCDATE())
	     WHERE UserKey = @UserKey
	     
	    UPDATE tCMFolder
	       SET GoogleLoginAttempts = 0
	     WHERE UserKey = @UserKey
	END
	
	IF ISNULL(@GoogleRefreshToken, '') <> ''
	BEGIN
		UPDATE tUser
	       SET GoogleRefreshToken = @GoogleRefreshToken, GoogleRefreshTokenExpires = DATEADD(D, 60, GETUTCDATE())
	     WHERE UserKey = @UserKey
	END
GO
