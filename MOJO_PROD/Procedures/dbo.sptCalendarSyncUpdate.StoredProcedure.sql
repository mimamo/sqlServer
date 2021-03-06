USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarSyncUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarSyncUpdate]
	@CalendarKey int,
	@UserKey int,
	@CompanyKey int,
	@ParentKey int,
	@Subject varchar(100),
	@Description varchar(4000),
	@Location varchar(100),
	@EventStart datetime,
	@EventEnd datetime,
	@AllDayEvent tinyint,
	@Deleted tinyint,
	@ShowTimeAs smallint,
	@Recurring tinyint,
	@ReminderTime int,
	@RecurringSettings text,
	@RecurringEndType varchar(50),
	@Pattern int,	
	@RecurringCount int,
	@RecurringEndDate datetime,
	@Application varchar(50)			
 
AS

/*
|| When     Who Rel      What
|| 4/1/09   CRG 10.5.0.0 Added Application parameter for call to sptCalendarUpdateLogInsert
*/

DECLARE @Parms varchar(500)

Declare @RetVal int
Declare @Organizer int, @AllowAction int, @AccessType int

if @CalendarKey = 0
BEGIN
	INSERT tCalendar
		(
		EventLevel, 
		Subject, 
		Description, 
		Location, 
		EventStart, 
		EventEnd, 
		ProjectKey, 
		CompanyKey, 
		ShowTimeAs, 
		Visibility, 
		Recurring, 
		ReminderTime, 
		ParentKey, 
		OriginalStart, 
		Deleted, 
		AllDayEvent, 
		RecurringSettings,
		Pattern,
		RecurringCount,
		RecurringEndDate,
		RecurringEndType,
		DateUpdated
		)

	VALUES
		(
		1,
		@Subject,
		@Description,
		@Location,
		@EventStart,
		@EventEnd,
		NULL,
		@CompanyKey,
		@ShowTimeAs,
		0,
		@Recurring,
		@ReminderTime,
		@ParentKey,
		@EventStart,
		@Deleted,
		@AllDayEvent,
		@RecurringSettings,
		@Pattern,
		@RecurringCount,
		@RecurringEndDate,
		@RecurringEndType,
		GETUTCDATE() 	
		)
	
	SELECT @RetVal = @@IDENTITY
	
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @RetVal)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'I', 'sptCalendarSyncUpdate', @Parms, @Application
	
	INSERT tCalendarAttendee (CalendarKey, EntityKey, Entity, Status)
	VALUES (@RetVal, @UserKey, 'Organizer', 0)
	
	If ISNULL(@ParentKey, 0) > 0
		Update tCalendar Set DateUpdated = GETUTCDATE() Where CalendarKey = @ParentKey

	Return @RetVal
END
ELSE
BEGIN
	Select @AllowAction = 0
	Select @Organizer = EntityKey from tCalendarAttendee (nolock) Where CalendarKey = @CalendarKey and Entity = 'Organizer'
	if @Organizer = @UserKey
		Select @AllowAction = 1
	else
	BEGIN
	  Select @AccessType = AccessType from tCalendarUser (nolock) Where UserKey = @Organizer and CalendarUserKey = @UserKey
		if ISNULL(@AccessType, 0) = 2
			Select @AllowAction = 1
	END

	if @AllowAction = 0
		Return -1

	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarSyncUpdate', @Parms, @Application	
	
	UPDATE
		tCalendar
	SET
		Subject = @Subject,
		Description = @Description,
		Location = @Location,
		EventStart = @EventStart,
		EventEnd = @EventEnd,
		ReminderTime = @ReminderTime,
		AllDayEvent = @AllDayEvent,
		RecurringSettings = @RecurringSettings,
		Pattern = @Pattern,
		Deleted = @Deleted,
		Recurring = @Recurring,
		RecurringCount = @RecurringCount,
		RecurringEndDate = @RecurringEndDate,
		RecurringEndType = @RecurringEndType,
		ShowTimeAs = @ShowTimeAs,
		DateUpdated = GETUTCDATE()
	WHERE
		CalendarKey = @CalendarKey 
		
	If ISNULL(@ParentKey, 0) > 0
		Update tCalendar Set DateUpdated = GETUTCDATE() Where CalendarKey = @ParentKey
	
	Return @CalendarKey
END
GO
