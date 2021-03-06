USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserDuplicateCheck]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserDuplicateCheck]
	@FirstName VARCHAR(250),
	@LastName VARCHAR(250),
	@Email VARCHAR(500),
	@Uid VARCHAR(2500),
	@CMFolderKey INT

AS

/*
|| When      Who Rel      What
|| 10/01/13  QMD 10.5.7.3 Created to check if a contact already exists for carddav
*/
	DECLARE @UserKey INT
	
	SET @UserKey = -1
	
	SELECT	@UserKey = u.UserKey
	FROM	tUser u (NOLOCK) LEFT JOIN tUserMapping um (NOLOCK) ON u.UserKey = um.UserKey AND um.CMFolderKey = @CMFolderKey
	WHERE	(u.Uid = @Uid OR um.Uid = @Uid)
			AND u.CMFolderKey = @CMFolderKey
						
	IF ISNULL(@UserKey, -1) < 0 											
		SELECT	@UserKey = u.UserKey
		FROM	tUser u (NOLOCK) LEFT JOIN tUserMapping um (NOLOCK) ON u.UserKey = um.UserKey AND um.CMFolderKey = @CMFolderKey
		WHERE	u.CMFolderKey = @CMFolderKey
				AND UPPER(u.FirstName) = UPPER(@FirstName) 
				AND UPPER(u.LastName) = UPPER(@LastName)
				AND UPPER(ISNULL(u.Email,'')) = UPPER(@Email)
																			
	RETURN ISNULL(@UserKey, -1)
GO
