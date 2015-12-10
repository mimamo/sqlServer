USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetOrganizerCalendars]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetOrganizerCalendars]
	@OrganizerKey int,
	@UserKey int, --Logged in User
	@CalendarKey int --If >0, then we have to make sure that the existing calendar for this meeting is in the list
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/25/08   CRG 10.5.0.0 Created for new CalendarManager. 
||                        This is a list of calendars (folders) that the current user can set the event to for the current organizer.
|| 5/4/09    CRG 10.5.0.0 Now using vCMFolderUserName which puts the user name in () after the folder name.
|| 6/29/09   CRG 10.5.0.0 Now calling new SP which determines list of public folders that the user has rights to.  
||                        And now also takes the @CalendarKey parameter to ensure that the existing CMFolderKey for the meeting is 
||                        included in the list.
|| 10/27/09  CRG 10.5.1.2 (66723) Fixed query where it gets CurrentCMFolderKey on personal meetings (it wasn't limiting it to the organizer's folder)
*/

	DECLARE	@SecurityGroupKey int,
			@CurrentCMFolderKey int,
			@CurrentIsPublic int
				
	--Load the Public folder list
	CREATE TABLE #tPublicCalList (CMFolderKey int NULL, CanAdd tinyint NULL)
	EXEC spCalendarManagerGetPublicCalendars @UserKey, 1 --Edit only

	IF @CalendarKey > 0
	BEGIN
		SELECT	@CurrentCMFolderKey = ISNULL(CMFolderKey, 0)
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey

		IF @CurrentCMFolderKey = 0
			SELECT	@CurrentCMFolderKey = ISNULL(CMFolderKey, 0)
			FROM	tCalendarAttendee (nolock)
			WHERE	CalendarKey = @CalendarKey
			AND		Entity IN ('Organizer', 'Attendee')
			AND		EntityKey = @OrganizerKey

		IF @CurrentCMFolderKey > 0
			SELECT	@CurrentIsPublic =
						CASE
							WHEN ISNULL(UserKey, 0) = 0 THEN 1
							ELSE 0
						END
			FROM	tCMFolder (nolock)
			WHERE	CMFolderKey = @CurrentCMFolderKey
			AND		Entity = 'tCalendar'
	ELSE
		SELECT	@CurrentCMFolderKey = 0,
				@CurrentIsPublic = 0
	END
			
	IF @UserKey = @OrganizerKey
	BEGIN
		--User is the Organizer
		
		--Get the User's Personal folders
		SELECT	CMFolderKey, FolderUserName AS FolderName, 0 AS IsPublic
		FROM	vCMFolderUserName (nolock)
		WHERE	(UserKey = @UserKey
			AND	Entity = 'tCalendar')
		OR		(CMFolderKey = @CurrentCMFolderKey AND @CurrentIsPublic = 0)
		
		UNION
		
		--Get the Public folders the user can edit
		SELECT	f.CMFolderKey, f.FolderUserName, 1
		FROM	vCMFolderUserName f (nolock)
		LEFT JOIN #tPublicCalList tmp (nolock) ON f.CMFolderKey = tmp.CMFolderKey
		WHERE	(tmp.CMFolderKey IS NOT NULL)
		OR		(f.CMFolderKey = @CurrentCMFolderKey AND @CurrentIsPublic = 1)
		ORDER BY IsPublic, FolderName
	END
	ELSE
	BEGIN
		--User is not the Organizer

		SELECT	@SecurityGroupKey = SecurityGroupKey
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey
		
		--Get the Organizer's personal folders that the User can edit
		SELECT	f.CMFolderKey, f.FolderUserName AS FolderName, 0 AS IsPublic
		FROM	vCMFolderUserName f (nolock)
		INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
		WHERE	(((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
					OR
					(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
			AND	fs.CanAdd = 1
			AND	f.UserKey = @OrganizerKey
			AND	f.Entity = 'tCalendar')
		OR		(f.CMFolderKey = @CurrentCMFolderKey AND @CurrentIsPublic = 0)	
		

		UNION

		--Get the Public folders the user can edit
		SELECT	f.CMFolderKey, f.FolderUserName, 1
		FROM	vCMFolderUserName f (nolock)
		LEFT JOIN #tPublicCalList tmp (nolock) ON f.CMFolderKey = tmp.CMFolderKey
		WHERE	(tmp.CMFolderKey IS NOT NULL)
		OR		(f.CMFolderKey = @CurrentCMFolderKey AND @CurrentIsPublic = 1)
		ORDER BY IsPublic, FolderName
	END

	DROP TABLE #tPublicCalList
GO
