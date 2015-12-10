USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncCalendarAttendeeGet]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncCalendarAttendeeGet]
	@CalendarKey int
	 
AS --Encrypt

/*
|| When      Who Rel       What
|| 01/05/13  QMD 10.5.6.3  Created for caldav
|| 10/10/14  KMC 10.5.8.4  Added join to tSyncItem for Google CalDAV implementation
|| 12/26/14  KMC 10.5.8.7  Added join to tSyncCalendar to get CMFolderKey and UID when NULL values on tSyncCalendarAttendee
|| 01/20/15  KMC 10.5.8.8  Added tSyncItem.DataStoreItemID to use during deletnig of events
*/

	SELECT	s.CalendarKey
		  , s.Entity
		  , s.EntityKey
		  , s.Status
		  , s.Action
		  , ISNULL(s.CMFolderKey, sc.CMFolderKey) AS CMFolderKey
		  , si.CompanyKey
		  , si.DataStoreItemID
		  , ISNULL(si.UID, sc.OriginalUID) as UID
	FROM	tSyncCalendarAttendee s (NOLOCK) 
		LEFT JOIN tCalendarAttendee ca (NOLOCK) ON s.CalendarKey = ca.CalendarKey 
			  AND s.EntityKey = ca.EntityKey 
			  AND s.Entity = ca.Entity
		LEFT JOIN tSyncItem si (NOLOCK) ON s.CalendarKey = si.ApplicationItemKey
		      AND ISNULL(s.CMFolderKey, ca.CMFolderKey) = si.ApplicationFolderKey
		LEFT JOIN tSyncCalendar sc (nolock) on s.CalendarKey = sc.CalendarKey
	WHERE	s.CalendarKey = @CalendarKey
GO
