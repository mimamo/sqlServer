USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetByUID]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetByUID]
	@UID as varchar(2000),
	@ParentKey as int = NULL,
	@CMFolderKey int = NULL
AS

/*
|| When      Who Rel      What
|| 4/14/09   CRG 10.5.0.0 Created to get calendar events by their UID for CalDAV. For now it only returns the CalendarKey.
|| 8/26/09   CRG 10.5.0.8 Added @CMFolderKey to restrict by a CMFolderKey
|| 8/26/09   CRG 10.5.0.8 Added Deleted column for use by CalDAV with deleted instances
|| 01/27/10  QMD 10.5.1.8 Added if exist clause and googleuid condition
|| 7/14/10   CRG 10.5.3.2 Added AttendeeStatus
|| 08/03/10  QMD 10.5.3.3 Added Exchange2010UID
*/

	IF EXISTS(SELECT * FROM tCalendar (NOLOCK) WHERE UID = @UID)
	  BEGIN
		SELECT DISTINCT c.CalendarKey, c.Deleted, ISNULL(ca.Status, 0) AS AttendeeStatus
		FROM	tCalendar c (nolock)
		LEFT JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
		WHERE	c.UID = @UID
		AND		ISNULL(c.ParentKey, 0) = ISNULL(@ParentKey, 0)
		AND		(@CMFolderKey IS NULL
				OR c.CMFolderKey = @CMFolderKey
	  			OR ca.CMFolderKey = @CMFolderKey)
	  END
	ELSE IF EXISTS(SELECT * FROM tCalendar (NOLOCK) WHERE GoogleUID = @UID)
	  BEGIN
		SELECT DISTINCT c.CalendarKey, c.Deleted, ISNULL(ca.Status, 0) AS AttendeeStatus
		FROM	tCalendar c (nolock)
		LEFT JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
		WHERE	c.GoogleUID = @UID
		AND		ISNULL(c.ParentKey, 0) = ISNULL(@ParentKey, 0)
		AND		(@CMFolderKey IS NULL
				OR c.CMFolderKey = @CMFolderKey
				OR ca.CMFolderKey = @CMFolderKey)
	  END
	ELSE
	  BEGIN
		SELECT DISTINCT c.CalendarKey, c.Deleted, ISNULL(ca.Status, 0) AS AttendeeStatus
		FROM	tCalendar c (nolock)
		LEFT JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
		WHERE	c.Exchange2010UID = @UID
		AND		ISNULL(c.ParentKey, 0) = ISNULL(@ParentKey, 0)
		AND		(@CMFolderKey IS NULL
				OR c.CMFolderKey = @CMFolderKey
				OR ca.CMFolderKey = @CMFolderKey)
	  END
GO
