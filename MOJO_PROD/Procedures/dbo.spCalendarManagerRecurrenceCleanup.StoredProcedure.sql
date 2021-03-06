USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerRecurrenceCleanup]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerRecurrenceCleanup]
	@OldCalendarKey int,
	@RecurSaveDate smalldatetime,
	@Application varchar(50),
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 1/4/13    CRG 10.5.6.3 Created
|| 1/7/13    CRG 10.5.6.4 Modified to just return the CalendarKeys of the modified meetings that need to be deleted. 
||                        Then we'll call the deleteEvent method in CalendarManager, rather than calling the SP directly.
|| 6/7/13    CRG 10.5.6.8 (180747) If the RecurSaveDate is going to be before or on the original start date, then just delete the original meeting
|| 7/31/13   CRG 10.5.7.0 (185154) Added an update to the Sequence for the original calendar key
*/

	DECLARE @Parms varchar(500),
			@OldEventStart smalldatetime

	SELECT	@Application = ISNULL(@Application, '') + '-RecurrenceCleanup'

	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @OldCalendarKey)
	EXEC sptCalendarUpdateLogInsert @OldCalendarKey, @UserKey, 'U', 'spCalendarManagerRecurrenceCleanup', @Parms, @Application

	SELECT	@OldEventStart = EventStart
	FROM	tCalendar (nolock)
	WHERE	CalendarKey = @OldCalendarKey

	SELECT	@RecurSaveDate = DATEADD(day, -1, @RecurSaveDate)

	IF @RecurSaveDate <= dbo.fFormatDateNoTime(@OldEventStart)
		EXEC sptCalendarDelete @OldCalendarKey, @UserKey, @Application
	ELSE
	BEGIN
		UPDATE	tCalendar
		SET		RecurringEndType = 'Date',
				RecurringEndDate = @RecurSaveDate
		WHERE	CalendarKey = @OldCalendarKey
		
		EXEC sptCalendarIncrementSequence @OldCalendarKey
	END

	SELECT	CalendarKey
	FROM	tCalendar (nolock)
	WHERE	ParentKey = @OldCalendarKey
	AND		EventStart >= @RecurSaveDate
GO
