USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceUpdateToken]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceUpdateToken]
(
  @UserKey INT,
  @PrivateUserToken VARCHAR(MAX),
  @PublicUserToken VARCHAR(MAX)
 )

AS --Encrypt

  /*
  || When     Who Rel      What  
  || 12/04/14 QMD 10.5.8.7 Created for API
 */
 
 IF EXISTS(SELECT * FROM tUserPreference (NOLOCK) WHERE UserKey = @UserKey)
	UPDATE tUserPreference SET PublicUserToken = @PublicUserToken, PrivateUserToken = @PrivateUserToken WHERE UserKey = @UserKey
 ELSE 
  	INSERT tUserPreference (UserKey, PublicUserToken, PrivateUserToken) VALUES (@UserKey, @PublicUserToken, @PrivateUserToken)
GO
