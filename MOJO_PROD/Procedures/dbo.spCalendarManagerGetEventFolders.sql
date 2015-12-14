USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventFolders]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventFolders]
	@CalendarKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/12/08   CRG 10.5.0.0 Created for Calendar Manager. This tells you what folders are affected when an event is updated.
|| 9/20/11   CRG 10.5.4.8 (121035) Added resources to the query
*/

	SELECT	CMFolderKey
	FROM	tCalendar (nolock)
	WHERE	CalendarKey = @CalendarKey
	AND		CMFolderKey IS NOT NULL

	UNION

	SELECT	CMFolderKey
	FROM	tCalendarAttendee (nolock)
	WHERE	CalendarKey = @CalendarKey
	AND		CMFolderKey IS NOT NULL

	UNION

	SELECT	-EntityKey --Resources are stored in CMCalendarManager as negative CMFolderKeys
	FROM	tCalendarAttendee (nolock)
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'Resource'
GO
