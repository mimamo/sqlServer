USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderDelete]
	@CMFolderKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 08/28/13 KMC 10.5.7.2  (187507) Added logic to check if the folder was set to sync with Google Calendar, 
  ||                        and clear out the GoogleLastSync if it was.  This will enable the next time a 
  ||                        folder is setup to sync with Google to pull back all of the events instead of
  ||                        just from the last time any folder was synced.
  */

	DECLARE @GoogleSyncFolderKey INT, @CMFolderSyncsCount INT

	--Check if this calendar was set to sync with Google
	SELECT @GoogleSyncFolderKey = GoogleSyncFolderKey 
	  FROM tCMFolder (NOLOCK) 
	 WHERE CMFolderKey = @CMFolderKey

	--Check if there are any other calendars set to sync with the same Google folder
	SELECT @CMFolderSyncsCount = COUNT(CMFolderKey)
	  FROM tCMFolder (NOLOCK) 
	 WHERE GoogleSyncFolderKey = @GoogleSyncFolderKey 
	   AND CMFolderKey <> @CMFolderKey
	   
	--If Google sync was setup AND no other calendars are set to the same sync, NULL the GoogleLastSync
	IF ISNULL(@GoogleSyncFolderKey, 0) > 0 AND ISNULL(@CMFolderSyncsCount, 0) = 0
	BEGIN
		UPDATE tSyncFolder
		   SET GoogleLastSync = NULL
		 WHERE SyncFolderKey = @GoogleSyncFolderKey
	END

	DELETE
	FROM tCMFolderSecurity
	WHERE
		CMFolderKey = @CMFolderKey 

	DELETE
	FROM tCMFolder
	WHERE
		CMFolderKey = @CMFolderKey 

	RETURN 1
GO
