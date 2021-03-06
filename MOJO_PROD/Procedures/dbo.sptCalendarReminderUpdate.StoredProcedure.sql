USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarReminderUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarReminderUpdate]
	@Entity varchar(50),
	@EntityKey int,
	@UserKey int,
	@EventMonth int,
	@EventDay int,
	@EventYear int,
	@Dismissed tinyint,
	@Snooze int -- if -1 is passed in, they didn't select snooze
AS

/*
|| When      Who Rel      What
|| 2/10/09   CRG 10.5.0.0 Created for the CalendarManager reminders
|| 6/9/09    CRG 10.5.0.0 Changed to Entity/EntityKey
*/

	DECLARE	@SnoozeTime smalldatetime,
			@Displayed tinyint
	
	IF @Snooze >= 0
	BEGIN
		SELECT @SnoozeTime = DATEADD(mi, @Snooze, GETUTCDATE())
		SELECT @Displayed = 0 --Clear the displayed flag so it'll display again when the snooze time is up
	END
	ELSE
	BEGIN
		SELECT @Displayed = 1	
	ENd
	
	IF EXISTS(
			SELECT	NULL
			FROM	tCalendarReminder (nolock)
			WHERE	Entity = @Entity
			AND		EntityKey = @EntityKey
			AND		UserKey = @UserKey
			AND		EventMonth = @EventMonth
			AND		EventDay = @EventDay
			AND		EventYear = @EventYear)
	BEGIN
		UPDATE	tCalendarReminder
		SET		Displayed = @Displayed,
				Dismissed = @Dismissed,
				SnoozeTime = @SnoozeTime				
		WHERE	Entity = @Entity
		AND		EntityKey = @EntityKey
		AND		UserKey = @UserKey
		AND		EventMonth = @EventMonth
		AND		EventDay = @EventDay
		AND		EventYear = @EventYear
	END
	ELSE
	BEGIN
		INSERT	tCalendarReminder
				(Entity,
				EntityKey,
				UserKey,
				EventMonth,
				EventDay,
				EventYear,
				Displayed,
				Dismissed,
				SnoozeTime)
		VALUES	(@Entity,
				@EntityKey,
				@UserKey,
				@EventMonth,
				@EventDay,
				@EventYear,
				@Displayed,
				@Dismissed,
				@SnoozeTime)
	END
GO
