USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventRights]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventRights]
	@CalendarKey int,
	@UserKey int,
	@CanView tinyint output,
	@CanEdit tinyint output,
	@IsPublic tinyint output,
	@ActualFolderName varchar(200) output, --If it's a public folder, this is the public folder name, otherwise it will match the @UserFolderName.
	@UserCMFolderKey int output, --This is the folder for the user who's viewing the event. If the user is the organizer it's the same as @CMFolderKey.
	@UserFolderName varchar(200) output,
	@OrganizerKey int output,
	@AttendeeStatus smallint output,
	@AttendeeComments varchar(500) output,
	@OrganizerFolderKey int output
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/17/08   CRG 10.5.0.0 Created for new CalendarManager
|| 6/29/09   CRG 10.5.0.0 Now Administrators can edit all public calendars
|| 8/19/09   CRG 10.5.0.8 Added @OrganizerFolderKey
|| 9/2/09    CRG 10.5.0.9 (60065) Changed the logic for Private meetings
|| 10/8/09   CRG 10.5.1.2 (65027) Moved the queries for @UserFolderName, @ActualFolderName, and @AttendeeStatus up in the SP so that they would not be 
||                        skipped by the RETURN statement when @OrganizerKey = @UserKey
|| 11/9/11   RLB 10.5.5.0 returning the Attendee comments
*/

	DECLARE	@CMFolderKey int, --This is the actual folder key for this event
			@SecurityGroupKey int,
			@Private tinyint,
			@Administrator tinyint

	SELECT	@CanView = 0,
			@CanEdit = 0

	SELECT	@OrganizerKey = ca.EntityKey,
			@CMFolderKey = 
				CASE
					WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
					ELSE
						(SELECT MIN(CMFolderKey) --MIN to ensure that it's just one row
						FROM	tCalendarAttendee (nolock)
						WHERE	CalendarKey = @CalendarKey
						AND		Entity = 'Organizer')
				END,
			@UserCMFolderKey = 
					(SELECT MIN(CMFolderKey) --MIN to ensure that it's just one row
					FROM	tCalendarAttendee (nolock)
					WHERE	CalendarKey = @CalendarKey
					AND		EntityKey = @UserKey
					AND		Entity IN ('Organizer', 'Attendee')),
			@IsPublic =
				CASE
					WHEN c.CMFolderKey IS NOT NULL THEN 1
					ELSE 0
				END,
			@Private = c.Private,
			@OrganizerFolderKey = ca.CMFolderKey --Used by the Organizer's calendar combo, when someone else can edit the public event
	FROM	tCalendar c (nolock)
	INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
	WHERE	c.CalendarKey = @CalendarKey
	AND		ca.Entity = 'Organizer'

	SELECT	@UserFolderName = FolderName
	FROM	tCMFolder (nolock)
	WHERE	CMFolderKey = @UserCMFolderKey

	SELECT	@ActualFolderName = FolderName
	FROM	tCMFolder (nolock)
	WHERE	CMFolderKey = @CMFolderKey
		
	SELECT	@AttendeeStatus = MIN(Status), @AttendeeComments = ISNULL(MIN(Comments), '')
	FROM	tCalendarAttendee (nolock)
	WHERE	CalendarKey = @CalendarKey
	AND		EntityKey = @UserKey
	AND		Entity IN ('Organizer', 'Attendee')

	--If user is the organizer, they can view and edit
	IF @OrganizerKey = @UserKey	
	BEGIN
		SELECT	@CanView = 1,
				@CanEdit = 1
		RETURN
	END

	--If user is not the organizer, check to see if the user has rights on the folder that the organizer put it in
	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey		

	IF @IsPublic = 1 AND @Administrator = 1
	BEGIN
		SELECT	@CanView = 1,
				@CanEdit = 1		
	END
	ELSE
	BEGIN
		SELECT	@CanView = MAX(CanView),
				@CanEdit = MAX(CanAdd)
		FROM	tCMFolderSecurity (nolock)
		WHERE	((Entity = 'tUser' AND EntityKey = @UserKey)
				OR
				(Entity = 'tSecurityGroup' AND EntityKey = @SecurityGroupKey))
		AND		CMFolderKey = @CMFolderKey --This is either a public folder or the organizer's folder (in case the user can view/edit the organizer's events)

		IF ISNULL(@CanView, 0) = 0 OR @Private = 1
		BEGIN
			--Only check to see if the user is an attendee if they can't normally view the organizer's folder or the meeting is Private.
			--Otherwise, there's no need to do the query.
			DECLARE @IsAttendee tinyint
			
			SELECT @IsAttendee = 0
			IF EXISTS
					(SELECT	NULL
					FROM	tCalendarAttendee (nolock)
					WHERE	CalendarKey = @CalendarKey
					AND		Entity = 'Attendee'
					AND		EntityKey = @UserKey)
				SELECT @IsAttendee = 1

			IF @IsAttendee = 1
			BEGIN
				--If the user is an attendee, they can view the event regardless of whether it's Private or not.  
				--Also, if they're an attendee, they can then Edit private meetings if they
				--normally have the right to edit the organizer's folder (so we'll leave CanEdit alone).
				SELECT @CanView = 1
			END
			ELSE
				IF @Private = 1
				BEGIN
					--If the user is not an attendee and it's private, clear the CanView and CanEdit flags, even if they can normally view or 
					--edit the organizer's folder.
					SELECT @CanView = 0
					SELECT @CanEdit = 0
				END
		END
	END
GO
