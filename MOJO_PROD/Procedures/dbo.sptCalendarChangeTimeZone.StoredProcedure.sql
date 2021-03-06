USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarChangeTimeZone]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarChangeTimeZone]
	@UserKey int,
	@StartDate datetime,
	@OldStdOffset int,
	@OldDaylightOffset int,
	@NewStdOffset int,
	@NewDaylightOffset int,
	@OldDaylightStart datetime,
	@OldDaylightEnd datetime,
	@NewDaylightStart datetime,
	@NewDaylightEnd datetime

AS --Encrypt

	--NOTE: All Offset variables are in MINUTES to handle timezones with half hour differences.

	DECLARE	@Year int,
			@CalendarKey int,
			@EventStart datetime,
			@EventEnd datetime,
			@OriginalStart datetime,
			@Recurring tinyint,
			@DateOut datetime
			
	SELECT	@Year = YEAR(@StartDate)
	
	--Get the Events for the year
	SELECT 	c.CalendarKey, c.EventStart, c.EventEnd, c.OriginalStart, c.Recurring, ca.EntityKey
	INTO	#tCalTZ
	FROM	tCalendar c (NOLOCK)
	INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey AND ca.Entity='Organizer'
	WHERE ca.EntityKey = @UserKey
	AND	(YEAR(c.EventStart) = @Year OR YEAR(c.EventEnd) = @Year OR YEAR(c.OriginalStart) = @Year)
	
	SELECT	@CalendarKey = 0
	
	WHILE (1=1)
	BEGIN
		SELECT	@CalendarKey = MIN(CalendarKey)
		FROM	#tCalTZ
		WHERE	CalendarKey > @CalendarKey and EntityKey = @UserKey
		
		IF @CalendarKey IS NULL
			BREAK
			
		SELECT	@EventStart = EventStart,
				@EventEnd = EventEnd,
				@OriginalStart = OriginalStart,
				@Recurring = Recurring
		FROM	#tCalTZ
		WHERE	CalendarKey = @CalendarKey

		IF @Recurring = 1
			BEGIN
				--Only update if the date is in the Year and it's on or after the start date.
				IF (YEAR(@OriginalStart) = @Year) AND (@OriginalStart >= @StartDate)
				BEGIN
					EXEC sptCalendarNewTZCalcDate 
							@OriginalStart,
							@OldStdOffset,
							@OldDaylightOffset,
							@NewStdOffset,
							@NewDaylightOffset,
							@OldDaylightStart,
							@OldDaylightEnd,
							@NewDaylightStart,
							@NewDaylightEnd,
							@DateOut OUTPUT
					
					UPDATE	#tCalTZ
					SET		OriginalStart = @DateOut
					WHERE	CalendarKey = @CalendarKey
				END		
			END	
		ELSE
			BEGIN
				--Only update if the date is in the Year and it's on or after the start date.			
				IF (YEAR(@EventStart) = @Year) AND (@EventStart >= @StartDate)
					BEGIN
						EXEC sptCalendarNewTZCalcDate 
								@EventStart,
								@OldStdOffset,
								@OldDaylightOffset,
								@NewStdOffset,
								@NewDaylightOffset,
								@OldDaylightStart,
								@OldDaylightEnd,
								@NewDaylightStart,
								@NewDaylightEnd,
								@DateOut OUTPUT
						
						UPDATE	#tCalTZ
						SET		EventStart = @DateOut
						WHERE	CalendarKey = @CalendarKey
					END		
				
				--Only update if the date is in the Year and it's on or after the start date.
				IF (YEAR(@EventEnd) = @Year) AND (@EventEnd >= @StartDate)
					BEGIN
						EXEC sptCalendarNewTZCalcDate 
								@EventEnd,
								@OldStdOffset,
								@OldDaylightOffset,
								@NewStdOffset,
								@NewDaylightOffset,
								@OldDaylightStart,
								@OldDaylightEnd,
								@NewDaylightStart,
								@NewDaylightEnd,
								@DateOut OUTPUT
						
						UPDATE	#tCalTZ
						SET		EventEnd = @DateOut
						WHERE	CalendarKey = @CalendarKey
					END		
			END				
	END

	UPDATE	tCalendar
	SET		tCalendar.EventStart = tz.EventStart,
			tCalendar.EventEnd = tz.EventEnd,
			tCalendar.OriginalStart = tz.OriginalStart
	FROM	#tCalTZ tz
	WHERE	tCalendar.CalendarKey = tz.CalendarKey and EntityKey = @UserKey

	RETURN 1
GO
