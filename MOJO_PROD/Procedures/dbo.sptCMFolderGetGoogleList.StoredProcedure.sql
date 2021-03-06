USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderGetGoogleList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptCMFolderGetGoogleList]
	@UserKey int,
	@CompanyKey int
AS

/*
|| When      Who Rel        What
|| 08/29/14  CRG 10.5.8.4   Created
|| 10/22/14  KMC 10.5.8.4H  Added SyncDirection
*/

	SELECT	f.CMFolderKey,
			f.FolderName,
			sf.FolderID,
			sf.SyncDirection AS SyncDirection
	FROM	tCMFolder f (nolock)
	LEFT JOIN tSyncFolder sf (nolock) ON f.GoogleSyncFolderKey = sf.SyncFolderKey
	WHERE	f.CompanyKey = @CompanyKey
	AND		f.UserKey = @UserKey
	AND		f.Entity = 'tCalendar'
	ORDER BY FolderName

	CREATE TABLE #tPublicCalList (CMFolderKey int NULL, CanAdd tinyint NULL)
	EXEC spCalendarManagerGetPublicCalendars @UserKey
	
	SELECT	f.CMFolderKey,
			f.FolderName,
			f.GoogleCalDAVPublicUserKey,
			CASE
				WHEN f.GoogleCalDAVPublicUserKey <> @UserKey THEN 'Already linked by ' + ISNULL(u.UserName, '')
				ELSE sf.FolderID
			END AS FolderID,
			sf.SyncDirection AS SyncDirection
	FROM	tCMFolder f (nolock)
	INNER JOIN #tPublicCalList tmp (nolock) ON f.CMFolderKey = tmp.CMFolderKey
	LEFT JOIN tSyncFolder sf (nolock) ON f.GoogleSyncFolderKey = sf.SyncFolderKey
	LEFT JOIN vUserName u (nolock) ON f.GoogleCalDAVPublicUserKey = u.UserKey
	WHERE	f.CompanyKey = @CompanyKey
	AND		f.UserKey = 0
	AND		f.Entity = 'tCalendar'
	AND		tmp.CanAdd = 1
	ORDER BY f.FolderName
GO
