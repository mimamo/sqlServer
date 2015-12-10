USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerCopyAttendeeFoldersFromParent]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerCopyAttendeeFoldersFromParent]
	@CalendarKey int
AS

/*
|| When      Who Rel      What
|| 10/8/10   CRG 10.5.3.6 Created to copy over the attendee folders from the parent event
*/

	DECLARE	@ParentKey int
	SELECT	@ParentKey = ParentKey
	FROM	tCalendar (nolock)
	WHERE	CalendarKey = @CalendarKey

	UPDATE	ca
	SET		ca.CMFolderKey = p.CMFolderKey
	FROM	tCalendarAttendee ca (nolock),
			tCalendarAttendee p (nolock)
	WHERE	ca.CalendarKey = @CalendarKey
	AND		ca.Entity = p.Entity
	AND		ca.EntityKey = p.EntityKey
	AND		p.CalendarKey = @ParentKey
GO
