USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderGetSingle]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncFolderGetSingle]
(
	@SyncFolderKey INT
)

As --Encrypt

  /*
  || When     Who Rel			What
  || 11/29/12 QMD 10.5.6.3      Created to get a single sync folder
  || 03/06/15 KMC 10.5.8.9		Added INNER JOIN to tUser to get the TimeZoneIndex for that user
  */

	SELECT sf.*, u.TimeZoneIndex
	  FROM tSyncFolder sf (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON sf.UserKey = u.UserKey
	 WHERE SyncFolderKey = @SyncFolderKey
GO
