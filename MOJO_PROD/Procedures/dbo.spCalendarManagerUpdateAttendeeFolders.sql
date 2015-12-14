USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdateAttendeeFolders]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdateAttendeeFolders]
	@CalendarKey int,
	@CMFolderKey int,
	@UserFolderKey int,
	@LoggedUserKey int,
	@FolderChanged tinyint = 0
AS

/*
|| When      Who Rel       What
|| 8/28/08   CRG 10.5.0.0  Created for the CalendarManager
|| 6/30/09   CRG 10.5.0.0  Fixed problem where attendee folders were getting cleared if Organizer cleared their folder
|| 7/28/09   CRG 10.5.0.0  Added logic to ensure that if an organizer puts an event in a public folder with BlockoutAttendees = 1, then
||                         it also sets their "Also Show In" folder on the Attendee record.  This is because the CalendarSchedule and
||                         CalendarReminder classes don't include BlockoutAttendee folders, but still need to include the actual events for the
||                         organizer.  By putting these events in the organizer's default calendar, it'll show up.
|| 8/14/09   CRG 10.5.0.7  (60463) Now, when the UserFolderKey is passed in, we're making sure that the User that it belongs to is the current logged in user to 
||                         keep it from inserting an attendee when a different user is editing someone's meeting.
|| 9/19/09   CRG 10.5.0.7  Now, when an attendee is added because of the "Also Show In" combo, their status is set to "Will Attend" rather than "Tentative"
|| 5/7/10    CRG 10.5.2.2  (80362) Added a call to spCalendarManagerEnsureUserDefaultCalendar for any attendees that don't have a DefaultCMFolderKey defined.
||                         Also consolidated the Update statement that sets the CMFolderKey for attendees to the end of the SP because it was the same call in 
||                         both parts of the IF block.
|| 5/20/11   CRG 10.5.4.4  (111406) Modified to ensure that on a Vacation calendar (where BlockoutAttendees = 1), the organizer's calendar is set in tCalendarAttendee.
|| 10/22/12  CRG 10.5.6.1  (157521) Added a check at the end to ensure that the CMFolderKey of the organizer actually belongs to the Organizer.  
||                         Somehow an organizer's folder got changed, but we can't reproduce it.
*/	

	DECLARE @UserKey int,
			@BlockoutAttendees tinyint
	
	SELECT	@UserKey = ISNULL(UserKey, 0),
			@BlockoutAttendees = ISNULL(BlockoutAttendees, 0)
	FROM	tCMFolder (nolock)
	WHERE	CMFolderKey = @CMFolderKey
	
	IF @UserKey > 0
	BEGIN
		--It's a personal folder
		
		--Set the Organizer's folder in the Attendee table
		UPDATE	tCalendarAttendee
		SET		CMFolderKey = @CMFolderKey
		WHERE	CalendarKey = @CalendarKey
		AND		Entity = 'Organizer'
		
		--Clear the folder on the Calendar record
		UPDATE	tCalendar
		SET		CMFolderKey = NULL
		WHERE	CalendarKey = @CalendarKey
	END
	ELSE
	BEGIN
		--It's a public folder
		IF @UserFolderKey >= 0 --If it's -1, then it's from CMP90 and we don't want to mess with the UserFolders
		BEGIN
			--Set the User folder in the Attendee table
			--This is from the "Also Show In" combo on the Meeting Edit screen
			IF @UserFolderKey > 0
			BEGIN
				--Only set the "Also Show In" folder if the user from the folder is the current logged in user
				--This can happen if someone is editing someone else's meeting
				DECLARE @UserKeyFromUserFolderKey int
				
				SELECT	@UserKeyFromUserFolderKey = UserKey
				FROM	tCMFolder (nolock)
				WHERE	CMFolderKey = @UserFolderKey
				
				IF @UserKeyFromUserFolderKey = @LoggedUserKey
				BEGIN
					IF EXISTS(
							SELECT	NULL
							FROM	tCalendarAttendee (nolock)
							WHERE	CalendarKey = @CalendarKey
							AND		EntityKey = @LoggedUserKey
							AND		(Entity = 'Organizer' OR Entity = 'Attendee'))
					BEGIN
						UPDATE	tCalendarAttendee
						SET		CMFolderKey = @UserFolderKey
						WHERE	CalendarKey = @CalendarKey
						AND		EntityKey = @LoggedUserKey
						AND		(Entity = 'Organizer' OR Entity = 'Attendee')
					END
					ELSE
					BEGIN
						INSERT	tCalendarAttendee
								(CalendarKey,
								Entity,
								EntityKey,
								Status,
								CMFolderKey)
						VALUES	(@CalendarKey,
								'Attendee', --It must not be the organizer because that was already inserted automatically for public events
								@LoggedUserKey,
								2, -- Will Attend
								@UserFolderKey)
					END
				END
			END
			ELSE
			BEGIN
				--If the UserFolderKey is cleared, and the Logged User is the organizer, just set it to NULL
				--Otherwise, delete the Attendee record from the public event
				IF EXISTS(
						SELECT	NULL
						FROM	tCalendarAttendee (nolock)
						WHERE	CalendarKey = @CalendarKey
						AND		EntityKey = @LoggedUserKey
						AND		Entity = 'Organizer')
				BEGIN
					--If the Logged User is the organizer, and the main CMFolderKey is a public folder where BlockoutAttendees is 1,
					--then set the Attendee CMFolderKey record to the DefaultCMFolderKey on the User
					IF @BlockoutAttendees = 1
						UPDATE	tCalendarAttendee
						SET		CMFolderKey = u.DefaultCMFolderKey
						FROM	tCalendarAttendee ca (nolock)
						INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
						WHERE	CalendarKey = @CalendarKey
						AND		EntityKey = @LoggedUserKey
						AND		Entity = 'Organizer'
					ELSE
						UPDATE	tCalendarAttendee
						SET		CMFolderKey = NULL
						WHERE	CalendarKey = @CalendarKey
						AND		EntityKey = @LoggedUserKey
						AND		Entity = 'Organizer'
				END
				ELSE
				BEGIN
					DELETE	tCalendarAttendee
					WHERE	CalendarKey = @CalendarKey
					AND		EntityKey = @LoggedUserKey
					AND		Entity = 'Attendee'

					--Ensure that the organizer in a "vacation" calendar has their folder set
					IF @BlockoutAttendees = 1
						UPDATE	tCalendarAttendee
						SET		CMFolderKey = u.DefaultCMFolderKey
						FROM	tCalendarAttendee ca (nolock)
						INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
						WHERE	CalendarKey = @CalendarKey
						AND		Entity = 'Organizer'
				END
			END
		END
							
		--Set the folder on the Calendar record
		UPDATE	tCalendar
		SET		CMFolderKey = @CMFolderKey
		WHERE	CalendarKey = @CalendarKey
		
		--clear all attendees' folders if the folder has just been changed to public
		IF @FolderChanged = 1
			UPDATE	tCalendarAttendee
			SET		CMFolderKey = NULL
			WHERE	CalendarKey = @CalendarKey
			AND		Entity = 'Attendee'
	END
	
	--Before we set any attendee folders that haven't been set yet, we need to ensure that they have a default calendar set
	DECLARE	@NoDefaultUserKey int
	SELECT	@NoDefaultUserKey = 0
	WHILE (1=1)
	BEGIN
		SELECT	@NoDefaultUserKey = MIN(u.UserKey)
		FROM	tCalendarAttendee ca (nolock)
		INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
		WHERE	ca.CalendarKey = @CalendarKey
		AND		ca.Entity = 'Attendee'
		AND		ca.CMFolderKey IS NULL
		AND		u.UserKey > @NoDefaultUserKey
		AND		ISNULL(u.DefaultCMFolderKey, 0) = 0
		
		IF @NoDefaultUserKey IS NULL
			BREAK

		EXEC spCalendarManagerEnsureUserDefaultCalendar @NoDefaultUserKey
	END

	--Set Attendee folders if they haven't been set yet
	UPDATE	tCalendarAttendee
	SET		tCalendarAttendee.CMFolderKey = tUser.DefaultCMFolderKey
	FROM	tUser
	WHERE	CalendarKey = @CalendarKey
	AND		tCalendarAttendee.Entity = 'Attendee'
	AND		tCalendarAttendee.EntityKey = tUser.UserKey
	AND		tCalendarAttendee.CMFolderKey IS NULL

	--Ensure that the organizer's CMFolderKey is actual theirs
	DECLARE	@OrganizerCMFolderKey int,
			@OrganizerKey int

	SELECT	@OrganizerCMFolderKey = MIN(CMFolderKey),
			@OrganizerKey = MIN(EntityKey)
	FROM	tCalendarAttendee (nolock)
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'Organizer'

	IF @OrganizerCMFolderKey IS NOT NULL
	BEGIN
		DECLARE	@OwnerOfFolder int

		SELECT	@OwnerOfFolder = UserKey
		FROM	tCMFolder (nolock)
		WHERE	CMFolderKey = @OrganizerCMFolderKey

		IF @OrganizerKey <> @OwnerOfFolder
			UPDATE	tCalendarAttendee
			SET		tCalendarAttendee.CMFolderKey = tUser.DefaultCMFolderKey
			FROM	tUser
			WHERE	tCalendarAttendee.CalendarKey = @CalendarKey
			AND		tCalendarAttendee.Entity = 'Organizer'
			AND		tCalendarAttendee.EntityKey = tUser.UserKey
	END
GO
