USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserClearGoogleAuth]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptUserClearGoogleAuth]
	@UserKey int,
	@CompanyKey int
AS

/*
|| When      Who Rel        What
|| 9/10/14   CRG 10.5.8.4   Created
|| 10/24/14  KMC 10.5.8.4H  Added SyncDirection
*/

	UPDATE	tUser
	SET		GoogleAuthToken = NULL,
			GoogleAuthTokenExpires = NULL,
			GoogleRefreshToken = NULL,
			GoogleRefreshTokenExpires = NULL
	WHERE	UserKey = @UserKey
	
	
	CREATE TABLE #Folders
		(CMFolderKey int NULL,
		IsPublic tinyint NULL,
		FolderID varchar(2500) NULL,
		SyncDirection tinyint NULL)
		
	INSERT	#Folders
	SELECT	CMFolderKey,
			CASE 
				WHEN ISNULL(UserKey, 0) = 0 THEN 1
				ELSE 0
			END,
			NULL,
			NULL
	FROM	tCMFolder (nolock)
	WHERE	UserKey = @UserKey
	OR		GoogleCalDAVPublicUserKey = @UserKey
	
	EXEC sptCMFolderUpdateGoogle @UserKey, @CompanyKey
GO
