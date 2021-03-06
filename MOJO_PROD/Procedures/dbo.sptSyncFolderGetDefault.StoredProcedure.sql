USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderGetDefault]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSyncFolderGetDefault]
(
	@userKey INT,
	@companyKey INT,	
	@folderID VARCHAR(1000),
	@cmFolderKey INT
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 04/28/09 QMD 10.5.0.0  Created for initial Release of 10.5
  || 09/23/09 QMD 10.5.1.2	Added check against tPreference to see if the companykey uses contact folders
*/

--TO DO:  Take into account companies that don't use folders
DECLARE @syncFolderKey INT
SELECT @syncFolderKey = -1

	--Check if company uses contact folders
	IF EXISTS (SELECT * FROM tPreference (NOLOCK) WHERE CompanyKey = @companyKey AND ISNULL(UseContactFolders, 0) = 0)
	   SELECT @cmFolderKey = NULL	
	
	--Get Default folder 
	IF @cmFolderKey = 0
	   SELECT @cmFolderKey = ISNULL(DefaultContactCMFolderKey,0) FROM tUser (NOLOCK) WHERE UserKey = @userKey AND CompanyKey = @companyKey

	--If No default folder ... check min value first
	IF @cmFolderKey = 0
	  BEGIN
		SELECT TOP 1 @cmFolderKey = MIN(CMFolderKey), @syncFolderKey = ISNULL(SyncFolderKey,0) 
		FROM tCMFolder (NOLOCK) 
		WHERE UserKey = @userKey AND CompanyKey = @companyKey AND Entity = 'tUser'
		GROUP BY CMFolderKey, SyncFolderKey
	 	 
		IF @cmFolderKey > 0			      
 			UPDATE	tUser
			SET		DefaultContactCMFolderKey = @cmFolderKey
			WHERE	UserKey = @userKey
					AND CompanyKey = @companyKey		
										
	  END
	 
	IF @cmFolderKey = 0
	  BEGIN
		INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
		VALUES	('Default contacts', 0, @userKey, @companyKey, 'tUser')

		SELECT	@cmFolderKey = @@IDENTITY
		SELECT  @syncFolderKey = 0
				
		UPDATE	tUser
		SET		DefaultContactCMFolderKey = @cmFolderKey
		WHERE	UserKey = @userKey
				AND CompanyKey = @companyKey
	  END

	-- If no tSyncFolder record insert one
	IF @syncFolderKey = 0 AND @folderID <> 'MAC'
	  BEGIN
		
		 EXEC @syncFolderKey = sptSyncFolderUpdate @userKey, @companyKey, @folderID, 'Default Contacts', 'tUser'

		 UPDATE	tCMFolder
		 SET	SyncFolderKey = @syncFolderKey
		 WHERE	CMFolderKey = @cmFolderKey
		
      END

	

	RETURN @cmFolderKey
GO
