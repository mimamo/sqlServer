USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdateUserFolder]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdateUserFolder]
	@CalendarKey int,
	@UserKey int,
	@CMFolderKey int,
	@Application varchar(50)
AS

/*
|| When      Who Rel      What
|| 10/3/08   CRG 10.5.0.0 Created for the CalendarManager. This updates an attendee's personal folder for an event.
|| 12/9/10   CRG 10.5.3.9 No calling sptCalendarUpdateLogInsert for this update
*/

	SELECT	@Application = ISNULL(@Application, '') + '-Attendee CMFolderKey only'

	DECLARE @Parms varchar(500)
	SELECT	@Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC	sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'spCalendarManagerUpdateUserFolder', @Parms, @Application

	UPDATE	tCalendarAttendee
	SET		CMFolderKey = @CMFolderKey
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'Attendee'
	AND		EntityKey = @UserKey
GO
