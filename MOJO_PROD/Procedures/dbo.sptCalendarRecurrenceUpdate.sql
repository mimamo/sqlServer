USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarRecurrenceUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptCalendarRecurrenceUpdate]
	@CalendarKey int,
	@Freq varchar(25),
	@Interval int,
	@BySetPos int,
	@ByMonthDay int,
	@ByMonth int,
	@Su tinyint,
	@Mo tinyint,
	@Tu tinyint,
	@We tinyint,
	@Th tinyint,
	@Fr tinyint,
	@Sa tinyint,
	@RecurringEndType varchar(50),
	@RecurringCount int = 0,
	@RecurringEndDate datetime = null,
	@UserKey int,
	@Application varchar(50)		
AS --Encrypt

	/*
	|| When     Who Rel      What
	|| 12/30/08 CRG 9.0.0.0  Brought back for CMP90, but now with the new recurrence fields.
	|| 4/1/09   CRG 10.5.0.0 Added Application parameter on call to sptCalendarUpdateLogInsert
	*/

	if @CalendarKey = 0
		Return 1
		
	Declare @Recurring tinyint

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)

	if ISNULL(@Freq, '') = ''
		Select @Recurring = 0
	else
		Select @Recurring = 1


	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarRecurrenceUpdate', @Parms, @Application
			
	UPDATE
		tCalendar
	SET
		Freq = @Freq,
		Interval = @Interval,
		BySetPos = @BySetPos,
		ByMonthDay = @ByMonthDay,
		ByMonth = @ByMonth,
		Su = @Su,
		Mo = @Mo,
		Tu = @Tu,
		We = @We,
		Th = @Th,
		Fr = @Fr,
		Sa = @Sa,
		RecurringCount = @RecurringCount,
		RecurringEndDate = @RecurringEndDate,
		RecurringEndType = @RecurringEndType,
		Recurring = @Recurring,
		BlockOutOnSchedule = 0,
		DateUpdated = GETUTCDATE()			 	
	WHERE
		CalendarKey = @CalendarKey 
		
	EXEC sptCalendarIncrementSequence @CalendarKey	
		
	Delete tCalendarAttendeeGroup where CalendarKey in (select CalendarKey from tCalendar (NOLOCK) where ParentKey = @CalendarKey and EventStart >= DATEADD(d, - 14, GETUTCDATE()))	
	Delete tCalendarAttendee where CalendarKey in (select CalendarKey from tCalendar (NOLOCK) where ParentKey = @CalendarKey and EventStart >= DATEADD(d, - 14, GETUTCDATE()))	
	Delete tCalendar where ParentKey = @CalendarKey and EventStart >= GETUTCDATE()

	Update  tCalendar
	Set     Deleted = 1
	Where   ParentKey = @CalendarKey
			And EventStart >= DATEADD(d, - 14, GETUTCDATE())

	if @Recurring = 0
	BEGIN
		Delete tCalendarAttendeeGroup where CalendarKey in (select CalendarKey from tCalendar (NOLOCK) where ParentKey = @CalendarKey)	
		Delete tCalendarAttendee where CalendarKey in (select CalendarKey from tCalendar (NOLOCK) where ParentKey = @CalendarKey)	
		Delete tCalendar where ParentKey = @CalendarKey and ParentKey > 0
	END

	RETURN 1
GO
