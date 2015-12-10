USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncItemClean]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncItemClean]
	@CMFolderKey INT,
	@UserKey INT,
	@CompanyKey INT
AS --Encrypt

/*
|| When     Who Rel      What
|| 08/29/09 QMD 10.5.1.0 Initial Release - cleans up tSyncItem, tSyncActivity to allow for a clean sync
|| 09/08/09 QMD 10.5.1.1 Added update to tSyncFolder and made companykey an int .. not varchar
|| 08/26/10 QMD 10.5.3.4 Added logic to check for public folders to clean up the tsyncitem table
|| 04/19/11 QMD 10.5.4.3 Added logic to check for googlesyncfolderkey
|| 08/14/12 QMD 10.5.5.9 Added googleLastSync to update
|| 12/02/14	KMC 10.5.8.6 Updated delete of tSyncItem to handle change to FolderID for Google ClaDAV
|| 12/26/14 KMC 10.5.8.7 Updated for public folders so GoogleLastSyncDate is cleared out
*/	

DECLARE @folder VARCHAR(1000)
DECLARE @syncFolderKey INT

SET @syncFolderKey = 0

	--Check if CMFolderKey is public folder.  If it is set @UserKey = 0
	IF EXISTS (SELECT * FROM tCMFolder (NOLOCK) WHERE UserKey = 0 AND CMFolderKey = @CMFolderKey)
		SELECT @UserKey = 0

	--Get Folder Info
	IF EXISTS (SELECT * FROM tCMFolder (NOLOCK) WHERE (CMFolderKey = @CMFolderKey AND SyncFolderKey IS NOT NULL) OR (CMFolderKey = @CMFolderKey AND GoogleSyncFolderKey IS NOT NULL))
		SELECT	@folder = FolderID, @syncFolderKey = s.SyncFolderKey
		FROM	tSyncFolder s (NOLOCK) INNER JOIN tCMFolder c (NOLOCK) ON s.SyncFolderKey = c.SyncFolderKey OR s.SyncFolderKey = c.GoogleSyncFolderKey
		WHERE	(s.UserKey = @UserKey or @UserKey = 0)
				AND s.CompanyKey = @CompanyKey
				AND c.CMFolderKey = @CMFolderKey
	
	--Check for syncml
	ELSE IF EXISTS (SELECT SourceURI FROM tSyncActivity (NOLOCK) WHERE CMFolderKey = @CMFolderKey AND UserKey = @UserKey AND CompanyKey = @CompanyKey)
		SELECT	@folder = SourceURI
		FROM	tSyncActivity (NOLOCK)
		WHERE	CMFolderKey = @CMFolderKey 
				AND UserKey = @UserKey 
				AND CompanyKey = @CompanyKey

	BEGIN TRAN
			
		DELETE tSyncActivity WHERE UserKey = @UserKey AND CompanyKey = @CompanyKey AND CMFolderKey = @CMFolderKey
		IF @@ERROR <> 0 
		  BEGIN
			ROLLBACK TRAN
			RETURN -1
		  END 
	
		DELETE tSyncItem WHERE CompanyKey = @CompanyKey AND ApplicationFolderKey = @CMFolderKey AND DataStoreFolderID like ('%' + @folder + '%')
		IF @@ERROR <> 0
		   BEGIN
			 ROLLBACK TRAN
			 RETURN -2
		   END 
		
		IF @syncFolderKey > 0
			BEGIN
				UPDATE tSyncFolder SET LastSync = NULL, GoogleLastSync = NULL WHERE SyncFolderKey = @syncFolderKey
			  IF @@ERROR <> 0
				BEGIN
				  ROLLBACK TRAN
				  RETURN -2
				END 
			END
			  
	COMMIT TRAN
GO
