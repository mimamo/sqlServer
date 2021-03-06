USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarAttendeeUpdateLogInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarAttendeeUpdateLogInsert]
	@CalendarUpdateLogKey int,
	@CalendarKey int
AS

/*
|| When      Who Rel      What
|| 09/15/10  QMD 10.5.3.5 Created for the new tCalendarAttendeeUpdateLog table to track changes to calendar attendee made by both CalendarManager and Sync Services.
*/
	
	INSERT	tCalendarAttendeeUpdateLog
				(CalendarUpdateLogKey
				,CalendarAttendeeKey
				,CalendarKey
				,Entity
				,EntityKey
				,Email
				,Status
				,NoticeSent
				,Comments
				,Optional
				,IsDistributionGroup
				,CMFolderKey)
		SELECT	@CalendarUpdateLogKey
				,CalendarAttendeeKey
				,CalendarKey
				,Entity
				,EntityKey
				,Email
				,Status
				,NoticeSent
				,Comments
				,Optional
				,IsDistributionGroup
				,CMFolderKey
		FROM	tCalendarAttendee (nolock)
		WHERE	CalendarKey = @CalendarKey
GO
