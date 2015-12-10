USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderIncludeInSyncUpdate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderIncludeInSyncUpdate]
	@CMFolderKey int,
	@UserKey int,
	@IncludeInSync tinyint
AS

/*
|| When      Who Rel      What
|| 4/23/09   CRG 10.5.0.0 Created for SyncML
*/

	IF @IncludeInSync = 1
	BEGIN
		IF NOT EXISTS
				(SELECT NULL
				FROM	tCMFolderIncludeInSync (nolock)
				WHERE	CMFolderKey = @CMFolderKey
				AND		UserKey = @UserKey)
		BEGIN
			INSERT	tCMFolderIncludeInSync 
					(CMFolderKey, 
					UserKey)
			VALUES	(@CMFolderKey,
					@UserKey)
		END
	END
	ELSE
	BEGIN
		DELETE	tCMFolderIncludeInSync
		WHERE	CMFolderKey = @CMFolderKey
		AND		UserKey = @UserKey
	END
GO
