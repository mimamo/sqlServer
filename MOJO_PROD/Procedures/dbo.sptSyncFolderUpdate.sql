USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncFolderUpdate]
	@userKey INT,
	@companyKey INT,
	@folderID VARCHAR(2500),
	@name VARCHAR(100),
	@entity VARCHAR(50),
	@syncApp INT = 0
	
AS --Encrypt

/*
|| When     Who Rel     What
   11/13/08 QMD 10.5    Initial Release
|| 04/21/09 QMD 10.5    Added Entity restriction to Exist clause
|| 09/11/09 QMD 10.5.1.0 Extended folderID length
|| 01/26/10 QMD 10.5.1.8 Added syncApp variable
|| 04/06/10 QMD 10.5.2.0 Added Logic to delete folders not selected for google folder mapping
|| 04/23/10 QMD 10.5.2.1 Modifed the delete logic
|| 11/28/12 QMD 10.5.6.2 Added @syncApp = 2
*/	
DECLARE @syncFolderKey INT

	IF EXISTS (SELECT 1 FROM tSyncFolder (NOLOCK) WHERE UserKey = @userKey AND CompanyKey = @companyKey AND FolderID = @folderID AND Entity = @entity)
	  BEGIN
		UPDATE	tSyncFolder
		SET		UserKey = @userKey,
				CompanyKey = @companyKey,
				FolderID = @folderID,
				SyncFolderName = @name,
				Entity = @entity,
				LastModified = GetDATE(),
				SyncApp = @syncApp
		WHERE	UserKey = @userKey 
				AND CompanyKey = @companyKey
				AND FolderID = @folderID
				AND Entity = @entity
				
		SELECT @syncFolderKey = SyncFolderKey FROM tSyncFolder WHERE UserKey = @userKey AND CompanyKey = @companyKey AND FolderID = @folderID AND Entity = @entity
		
	  END
	ELSE
	  BEGIN
		INSERT INTO tSyncFolder (SyncFolderName, FolderID, UserKey, CompanyKey, Entity, LastModified, SyncApp)
		VALUES (@name, @folderID, @userKey, @companyKey, @entity, GetDATE(), @syncApp)
		
		SET @syncFolderKey = @@Identity	 	  
	  END 
	  
	--Logic to clean up table for google folders
	IF @syncApp = 1 OR @syncApp = 2
		BEGIN
			DELETE tSyncFolder WHERE UserKey = @userKey AND CompanyKey = @companyKey AND SyncApp IN (1,2) AND FolderID <> @folderID AND 
				SyncFolderKey NOT IN (SELECT GoogleSyncFolderKey FROM tCMFolder (NOLOCK) WHERE UserKey = @userKey AND GoogleSyncFolderKey IS NOT NULL)
		END 	  

	Return @syncFolderKey
GO
