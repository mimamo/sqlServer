USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateSent]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptCalendarUpdateSent]

	(
		@CalendarKey int
	)

AS --Encrypt

Update tCalendar
Set ReminderSent = 1
Where CalendarKey = @CalendarKey


Update tCalendar set ReminderSent = 0 where CalendarKey in (select EventStart from tCalendar where EventStart < GetDate() and Recurring = 1)
GO
