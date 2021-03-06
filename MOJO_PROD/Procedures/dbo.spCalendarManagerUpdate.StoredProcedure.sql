USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdate]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdate]
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
	@RecurringEndType varchar(50),
	@RecurringCount int,
	@RecurringEndDate smalldatetime,
	@ReminderTime int,
	@ContactCompanyKey int,
	@ContactUserKey int,
	@ContactLeadKey int,
	@CalendarTypeKey int,
	@OrganizerKey int,
	@AllDayEvent int,
	@BlockOutOnSchedule int,
	@Freq varchar(25),
	@Interval int,
	@BySetPos int,
	@ByMonthDay int,
	@ByMonth int,
	@Su int,
	@Mo int,
	@Tu int,
	@We int,
	@Th int,
	@Fr int,
	@Sa int,
	@Private tinyint,
	@ParentKey int,
	@OriginalStart smalldatetime,
	@OriginalEnd smalldatetime,
	@Deleted tinyint,
	@CreatedBy int,
	@Application varchar(50),
	@UID varchar(200),
	@TaskKey int,
	@TypeColor varchar(50) OUTPUT

AS --Encrypt

/*
|| When     Who Rel      What
|| 8/26/08  CRG 10.5.0.0 Created for 10.5.
|| 4/1/09   CRG 10.5.0.0 Added Application parameter for call to sptCalendarUpdateLogInsert
|| 4/14/09  CRG 10.5.0.0 Added UID to allow it to be inserted by a new CalDAV event
|| 6/9/09   CRG 10.5.0.0 Changed tCalendarReminder to Entity/EntityKey
|| 7/23/09  CRG 10.5.0.5 Modified UID to varchar(200)
|| 8/13/09  CRG 10.5.0.6 (59895) Added protection because Interval cannot be 0
|| 8/28/09  CRG 10.5.0.7 Check for existing exception event
|| 9/11/09  CRG 10.5.1.0 (62484) Now replacing spaces in the UID with _ because the iPhone can't handle spaces.
|| 9/15/09  CRG 10.5.1.0 Added protection to ensure that the EventEnd >= EventStart
|| 10/15/09 CRG 10.5.1.2 (65389) Added protection to ensure that weekly recurring meetings have at least one day
||                       of the week specified.
|| 1/13/10  CRG 10.5.1.7 (72137) Now updating the Sequence of the parent of a modified occurrence so that iCal knows it's changed in CalDAV.
|| 01/27/10 QMD 10.5.1.8 Added If clause to insert googleuid   
|| 08/03/10 QMD 10.5.3.3 Added Exchange2010UID and Exchange2010 condition
|| 2/8/11   CRG 10.5.4.1 (102895) If a UID has { or }, give it a new UID.  Also added OriginalUID column to store off the one with { }.
|| 4/18/11  CRG 10.5.4.3 (102935) Added call to sptCalendarIncrementSequence on the parent during insert when ParentKey > 0. Otherwise, iCal doesn't know that the parent meeting has been modified.
|| 5/23/11  CRG 10.5.4.4 Now populating CreatedByApplication in tCalendar on the insert, so we know what application created the meeting to begin with.
|| 05/18/11 QMD 10.5.4.4 Added the Exchange2010UID to the insert
|| 6/23/11  CRG 10.5.4.5 If the ParentKey = 0, now setting OriginalStart and OriginalEnd to NULL. These were being set by CalendarSync and causing some bugs when they were not exceptions.
|| 12/9/11  CRG 10.5.5.1 (127220) Added protection against All Day meetings being set to 0 min. duration.
|| 09/19/13 QMD 10.5.7.2 Added the if class for exchange 2010 in the insert logic
|| 03/12/14 CRG 10.5.7.8 Modified the minimum AllDay check to only set it to the full 1439 minutes if it's less than 22hrs, 59 min. to handle all day events on the day
||                       Daylight Savings time changes.
|| 04/29/14 CRG 10.5.7.9 Added TaskKey
*/

	DECLARE @Parms varchar(500)
	DECLARE @Exchange2010 varchar(750)
	
	IF ISNULL(@CalendarKey,0) = 0 AND @ParentKey > 0 
		SELECT @CalendarKey = ISNULL(CalendarKey,0) FROM tCalendar (NOLOCK) WHERE ParentKey = @ParentKey AND OriginalStart = @OriginalStart
	
	IF @Recurring = 1 AND ISNULL(@Interval, 0) = 0 AND @Freq <> 'DAILY'
		SELECT @Interval = 1
	
	IF @Recurring = 1 AND @Freq = 'WEEKLY'
	BEGIN
		--If no day of the week has been specified, default it to the day of the week of EventStart
		IF ISNULL(@Mo, 0) + ISNULL(@Tu, 0) + ISNULL(@We, 0) + ISNULL(@Th, 0) + ISNULL(@Fr, 0) + ISNULL(@Sa, 0) + ISNULL(@Su, 0) = 0
		BEGIN
			DECLARE @dw int
			SELECT	@dw = DATEPART(dw, @EventStart)
			IF @dw = 1
				SELECT @Su = 1
			IF @dw = 2
				SELECT @Mo = 1
			IF @dw = 3
				SELECT @Tu = 1
			IF @dw = 4
				SELECT @We = 1
			IF @dw = 5
				SELECT @Th = 1
			IF @dw = 6
				SELECT @Fr = 1
			IF @dw = 7
				SELECT @Sa = 1
		END
	END

	IF ISNULL(@ParentKey, 0) = 0
		SELECT	@OriginalStart = NULL,
				@OriginalEnd = NULL
			
	--Ensure that the date range is valid
	IF @EventEnd < @EventStart
		SELECT	@EventEnd = @EventStart

	IF @AllDayEvent = 1
	BEGIN
		--If an All Day Event has a duration less than one day minus 61 minute (1379 minutes), then set the EventEnd to 1439 minutes after EventStart
		IF DATEDIFF(mi, @EventStart, @EventEnd) < 1379
			SELECT	@EventEnd = DATEADD(mi, 1439, @EventStart)
	END

	IF @CalendarKey > 0
	BEGIN
		SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
		EXEC sptCalendarUpdateLogInsert @CalendarKey, @CreatedBy, 'U', 'spCalendarManagerUpdate', @Parms, @Application

		DECLARE @DateUpdated smalldatetime,
				@OldEventStart smalldatetime,
				@OldEventEnd smalldatetime,
				@OldReminderTime int
				
		SELECT	@OldEventStart = EventStart,
				@OldEventEnd = EventEnd,
				@OldReminderTime = ReminderTime
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey
		
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
			TaskKey = @TaskKey,
			CompanyKey = @CompanyKey,
			ShowTimeAs = @ShowTimeAs,
			Visibility = @Visibility,
			Recurring = @Recurring,
			RecurringEndType = @RecurringEndType,
			RecurringCount = @RecurringCount,
			RecurringEndDate = @RecurringEndDate,
			ReminderTime = @ReminderTime,
			ContactCompanyKey = @ContactCompanyKey,
			ContactUserKey = @ContactUserKey,
			ContactLeadKey = @ContactLeadKey,
			CalendarTypeKey = @CalendarTypeKey,
			AllDayEvent = @AllDayEvent,
			BlockOutOnSchedule = @BlockOutOnSchedule,
			DateUpdated = GETUTCDATE(),
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
			Private = @Private
		WHERE
			CalendarKey = @CalendarKey 

		--Increment the Sequence number
		EXEC sptCalendarIncrementSequence @CalendarKey
			
		IF @ParentKey > 0
		BEGIN
			Select @DateUpdated = DateUpdated from tCalendar (nolock) Where CalendarKey = @CalendarKey
			
			Update tCalendar 
			Set DateUpdated = @DateUpdated
			Where CalendarKey = @ParentKey

			--Increment the Sequence number
			EXEC sptCalendarIncrementSequence @ParentKey
		END
		
		--Clear the reminder flags if the start/end or reminder times have been updated
		IF @EventStart <> @OldEventStart
				OR @EventEnd <> @OldEventEnd
				OR @ReminderTime <> @OldReminderTime
			UPDATE	tCalendarReminder
			SET		Displayed = 0,
					Dismissed = 0,
					SnoozeTime = NULL
			WHERE	Entity = 'tCalendar'
			AND		EntityKey = @CalendarKey
	END
	ELSE
	BEGIN
		SELECT @Exchange2010 = NULL
		
		IF @UID IS NULL
			IF @ParentKey > 0
				SELECT	@UID = UID, @Exchange2010 = Exchange2010UID
				FROM	tCalendar (nolock)
				WHERE	CalendarKey = @ParentKey

		IF @UID IS NULL
			SELECT @UID = newid()

		DECLARE	@OriginalUID varchar(200)
		SELECT	@OriginalUID = @UID

		--Replace space in the UID with _ because the iPhone can't handle it with CalDAV
		IF CHARINDEX(' ', @UID) > 0
			SELECT @UID = REPLACE(@UID, ' ', '_')

		IF CHARINDEX('{', @UID) > 0 OR CHARINDEX('}', @UID) > 0
			SELECT	@UID = newid()
		
		INSERT tCalendar
			(
			EventLevel,
			Subject,
			Description,
			Location,
			EventStart,
			EventEnd,
			ProjectKey,
			TaskKey,
			CompanyKey,
			ShowTimeAs,
			Visibility,
			Recurring,
			RecurringEndType,
			RecurringCount,
			RecurringEndDate,
			ReminderTime,
			ContactCompanyKey,
			ContactUserKey,
			ContactLeadKey,
			CalendarTypeKey,
			ParentKey,
			OriginalStart,
			OriginalEnd,
			Deleted,
			AllDayEvent,  	 	
			ReminderSent,
			BlockOutOnSchedule,
			DateUpdated,
			DateCreated,
			CreatedBy,
			Freq,
			Interval,
			BySetPos,
			ByMonthDay,
			ByMonth,
			Su,
			Mo,
			Tu,
			We,
			Th,
			Fr,
			Sa,
			Private,
			UID,
			Exchange2010UID,
			OriginalUID,    
			CreatedByApplication 
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
			@TaskKey,
			@CompanyKey,
			@ShowTimeAs,
			@Visibility,
			@Recurring,
			@RecurringEndType,
			@RecurringCount,
			@RecurringEndDate,
			@ReminderTime,
			@ContactCompanyKey,
			@ContactUserKey,
			@ContactLeadKey,
			@CalendarTypeKey,
			@ParentKey,
			@OriginalStart,
			@OriginalEnd,
			@Deleted,
			@AllDayEvent,
			0,
			@BlockOutOnSchedule,
			GETUTCDATE(),
			GETUTCDATE(),
			@CreatedBy,
			@Freq,
			@Interval,
			@BySetPos,
			@ByMonthDay,
			@ByMonth,
			@Su,
			@Mo,
			@Tu,
			@We,
			@Th,
			@Fr,
			@Sa,
			@Private,
			@UID,
			@Exchange2010,
			@OriginalUID,	
			@Application
			)
			
		SELECT @CalendarKey = @@IDENTITY
		
		SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
		EXEC sptCalendarUpdateLogInsert @CalendarKey, @CreatedBy, 'I', 'spCalendarManagerUpdate', @Parms, @Application

		IF @Application = 'Google' 
			BEGIN 
				DECLARE @ParentUID VARCHAR(500)		
				
				IF @ParentKey > 0
					BEGIN 								
						SELECT @ParentUID = UID FROM tCalendar (NOLOCK) WHERE CalendarKey = @ParentKey
						
						IF @ParentUID IS NULL
							SELECT @ParentUID = newid()
					END
				ELSE
					SELECT @ParentUID = newid()
					
				UPDATE	tCalendar
				SET		UID = @ParentUID, GoogleUID = @UID
				WHERE	CalendarKey = @CalendarKey
				
			END
		ELSE IF @Application = 'Exchange2010'
			BEGIN 
				DECLARE @pUID VARCHAR(500)		
				
				IF @ParentKey > 0
					BEGIN 								
						SELECT @pUID = UID FROM tCalendar (NOLOCK) WHERE CalendarKey = @ParentKey
						
						IF @pUID IS NULL
							SELECT @pUID = newid()
					END
				ELSE
					SELECT @pUID = newid()
					
				UPDATE	tCalendar
				SET		UID = @pUID, Exchange2010UID = @UID
				WHERE	CalendarKey = @CalendarKey
				
			END
			
		IF @ParentKey > 0
		BEGIN
			IF @Application <> 'Exchange2010'
			BEGIN
				UPDATE tCalendar 
				SET DateUpdated = GETUTCDATE()
				WHERE CalendarKey = @ParentKey

				--Increment the Sequence number
				EXEC sptCalendarIncrementSequence @ParentKey
			END
		END
	END	

	SELECT	@TypeColor = TypeColor
	FROM	tCalendarType (nolock)
	WHERE	CalendarTypeKey = @CalendarTypeKey
	
	RETURN @CalendarKey
GO
