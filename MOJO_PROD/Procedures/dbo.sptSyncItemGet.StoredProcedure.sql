USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncItemGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncItemGet]
	@CMFolderKey INT,
	@DataStoreItemID VARCHAR(1000),
	@Entity VARCHAR(100)
AS --Encrypt

/*
|| When     Who Rel      What
|| 08/30/12 QMD 10.5.5.9 Created to get a sync item 
|| 09/04/12 QMD 10.5.6.0 Added entity, if statement and joins to tUser and tCalendar
*/	

IF LOWER(@Entity) = 'tuser'
	SELECT	* 
	FROM	tSyncItem s (NOLOCK) INNER JOIN tUser u (NOLOCK) ON s.ApplicationItemKey = u.UserKey
	WHERE	s.ApplicationFolderKey = @CMFolderKey 
		AND s.DataStoreItemID = @DataStoreItemID 
		AND s.ApplicationDeletion = 0 
		AND s.DataStoreDeletion = 0
ELSE
	SELECT	* 
	FROM	tSyncItem s (NOLOCK) INNER JOIN tCalendar c (NOLOCK) ON s.ApplicationItemKey = c.CalendarKey
	WHERE	s.ApplicationFolderKey = @CMFolderKey 
		AND s.DataStoreItemID = @DataStoreItemID 
		AND s.ApplicationDeletion = 0 
		AND s.DataStoreDeletion = 0
GO
