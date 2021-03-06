USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarReminderGetForUser]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarReminderGetForUser]
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 2/10/09   CRG 10.5.0.0 Created for the CalendarManager reminder processing to get the reminder info for a user.
||                        This table will be purged by the TaskManager so the hit here for the query shouldn't be too bad.
||                        And, it's only going to be called by the CalendarReminder object, not the regular CalendarManager.
*/

	SELECT	*
	FROM	tCalendarReminder (nolock)
	WHERE	UserKey = @UserKey
GO
