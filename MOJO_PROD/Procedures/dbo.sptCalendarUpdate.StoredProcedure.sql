USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdate]
	@CalendarKey int,
	@EventLevel int,
	@Subject varchar(100),
	@Description varchar(4000),
	@Location varchar(100),
	@EventStart datetime,
	@EventEnd datetime,
	@ProjectKey int,
	@CompanyKey int,
	@ShowTimeAs int,
	@Visibility smallint,
	@Recurring tinyint,
	@ReminderTime int,
	@ContactCompanyKey int,
	@ContactUserKey int,
	@ContactLeadKey int,
	@CalendarTypeKey int,
	@OrganizerKey int,
	@AllDayEvent int,
	@BlockOutOnSchedule INT,
	@UserKey int,
	@Application varchar(50)
AS --Encrypt

/*
|| When     Who Rel      What
|| 12/21/06 CRG 8.4      Added a call to sptCalendarIncrementSequence (needed for .ics files)
|| 1/8/09   CRG 10.5.0.0 Brought back because of CMP90
|| 4/1/09   CRG 10.5.0.0 Added UserKey and Application and added call to sptCalendarUpdateLogInsert
*/

Declare @ParentKey int, @DateUpdated SMALLDATETIME, @OrigEventLevel INT

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarUpdate', @Parms, @Application
	
	UPDATE
		tCalendar
	SET

		EventLevel = @EventLevel,
		Subject = @Subject,
		Description = @Description,
		Location = @Location,
		EventStart = @EventStart,
		EventEnd = @EventEnd,
		ProjectKey = @ProjectKey,
		CompanyKey = @CompanyKey,
		ShowTimeAs = @ShowTimeAs,
		Visibility = @Visibility,
		Recurring = @Recurring,
		ReminderTime = @ReminderTime,
		ContactCompanyKey = @ContactCompanyKey,
		ContactUserKey = @ContactUserKey,
		ContactLeadKey = @ContactLeadKey,
		CalendarTypeKey = @CalendarTypeKey,
		AllDayEvent = @AllDayEvent,
		BlockOutOnSchedule = @BlockOutOnSchedule,
		DateUpdated = GETUTCDATE()
	WHERE
		CalendarKey = @CalendarKey 


	--Increment the Sequence number
	EXEC sptCalendarIncrementSequence @CalendarKey
		
	Select @ParentKey = ParentKey, @DateUpdated = DateUpdated from tCalendar (nolock) Where CalendarKey = @CalendarKey
	if @ParentKey > 0
		Update tCalendar 
		Set DateUpdated = @DateUpdated
		Where CalendarKey = @ParentKey

	Update tCalendarAttendee 
	Set 	
		EntityKey = @OrganizerKey 
	Where 
		CalendarKey = @CalendarKey 
		and 
		Entity = 'Organizer'

	Update tCalendarAttendee
	Set    Status = 1
	Where 
		CalendarKey = @CalendarKey 
		and 
		Entity <> 'Organizer'
	
	
	RETURN 1
GO
