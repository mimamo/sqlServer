USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarInsert]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarInsert]

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
	@oIdentity INT OUTPUT,
	@ParentKey as int,
	@OriginalStart as Datetime = null,
	@Deleted int = 0,
	@AllDayEvent int,
	@ReminderSent int,
	@BlockOutOnSchedule tinyint,
	@CreatedBy int
AS

/*
|| When     Who Rel      What
|| 10/18/06 WES 8.3567   Added 'Date Created' to support calendar view of event creation date
|| 11/07/07 CRG 8.5      (12074) Added CreatedBy
|| 10/22/09 CRG 10.5.1.2 Added call to sptCalendarUpdateLogInsert, and modified to update the UID of child meetings to match their parent.
*/

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
		ContactCompanyKey,
		ContactUserKey,
		ContactLeadKey,
		CalendarTypeKey,
		ParentKey,
		OriginalStart,
		Deleted,
		AllDayEvent,  	 	
		ReminderSent,
		BlockOutOnSchedule,
		DateUpdated,
        DateCreated,
        CreatedBy
		)

	VALUES
		(
		@EventLevel,
		@Subject,
		@Description,
		@Location,
		@EventStart,
		@EventEnd,
		@ProjectKey,
		@CompanyKey,
		@ShowTimeAs,
		@Visibility,
		@Recurring,
		@ReminderTime,
		@ContactCompanyKey,
		@ContactUserKey,
		@ContactLeadKey,
		@CalendarTypeKey,
		@ParentKey,
		@OriginalStart,
		@Deleted,
		@AllDayEvent,
		@ReminderSent,
		@BlockOutOnSchedule,
		GETUTCDATE(),
		GETUTCDATE(),
		@CreatedBy
		)
	
	SELECT @oIdentity = @@IDENTITY

	if @ParentKey > 0
	BEGIN
		Update tCalendar 
		Set DateUpdated = GETUTCDATE()
		Where CalendarKey = @ParentKey
	
		DECLARE	@UID varchar(200)
		
		SELECT	@UID = UID
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @ParentKey
	
		UPDATE	tCalendar
		SET		UID = @UID
		WHERE	CalendarKey = @oIdentity
	END
	
	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @oIdentity)
	
	EXEC sptCalendarUpdateLogInsert @oIdentity, @CreatedBy, 'I', 'sptCalendarInsert', @Parms, 'CMP90'

	RETURN 0
GO
