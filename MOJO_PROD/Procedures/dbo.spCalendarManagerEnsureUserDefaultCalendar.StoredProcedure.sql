USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerEnsureUserDefaultCalendar]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerEnsureUserDefaultCalendar]
	@UserKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/18/08   CRG 10.5.0.0 Created for new CalendarManager
|| 4/23/09   CRG 10.5.0.0 Added call to SP to set IncludeInSync for the default calendar
|| 6/12/09   CRG 10.5.0.0 Removed code that sets the folder of attendee records if it's NULL. 
||                        Otherwise, when people try to NULL out their "Also Show In" folder on a public event, 
||                        it gets set back when they log back in.
|| 10/14/09  CRG 10.5.1.1 Added protection against a contact with NULL CompanyKey
|| 10/20/09  CRG 10.5.1.2 Fixed it to work with contacts
|| 8/23/10   CRG 10.5.3.4 (88281) Modified it to ensure that the DefaultCMFolderKey in tUser actually belongs to this user.
*/

	DECLARE	@CMFolderKey int,
			@CompanyKey int

	--First try to get it for a company user
	SELECT	@CMFolderKey = DefaultCMFolderKey,
			@CompanyKey = CompanyKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	AND		ISNULL(OwnerCompanyKey, 0) = 0
	
	--If not found, try a company contact
	IF @CompanyKey IS NULL
		SELECT	@CMFolderKey = DefaultCMFolderKey,
				@CompanyKey = OwnerCompanyKey
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey

	--Ensure that the CMFolderKey is actually owned by this user
	IF @CMFolderKey IS NOT NULL
		IF NOT EXISTS
				(SELECT	NULL
				FROM	tCMFolder (nolock)
				WHERE	CMFolderKey = @CMFolderKey
				AND		UserKey = @UserKey)
			SELECT	@CMFolderKey = NULL

	IF @CMFolderKey IS NULL AND @CompanyKey IS NOT NULL
	BEGIN
		--First see if they have a folder, but the default was not set on the user record
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	tCMFolder (nolock)
		WHERE	UserKey = @UserKey
		AND		Entity = 'tCalendar'
		
		IF @CMFolderKey IS NULL
		BEGIN
			--If the user has no folders, create a default one
			
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
			VALUES	('Default calendar', 0, @UserKey, @CompanyKey, 'tCalendar')

			SELECT	@CMFolderKey = @@IDENTITY
			
			--Assign the folder security based on the old tCalendarUser table
			INSERT	tCMFolderSecurity
					(CMFolderKey,
					Entity,
					EntityKey,
					CanView,
					CanAdd)
			SELECT	@CMFolderKey,
					'tUser',
					CalendarUserKey,
					CASE AccessType
						WHEN 1 THEN 1
						ELSE 0
					END,
					CASE AccessType
						WHEN 2 THEN 1
						ELSE 0
					END
			FROM	tCalendarUser (nolock)
			WHERE	UserKey = @UserKey
		END

		UPDATE	tUser
		SET		DefaultCMFolderKey = @CMFolderKey
		WHERE	UserKey = @UserKey
		
		--Force IncludeInSync for the default calendar
		EXEC sptCMFolderIncludeInSyncUpdate @CMFolderKey, @UserKey, 1
	END

	--If any attendee records exist for this user without a folderkey, set them to the default folder
	/*
	IF EXISTS(
			SELECT	NULL
			FROM	tCalendarAttendee (nolock)
			WHERE	(Entity = 'Organizer' OR Entity = 'Attendee')
			AND		EntityKey = @UserKey
			AND		ISNULL(CMFolderKey, 0) = 0)
		UPDATE	tCalendarAttendee
		SET		CMFolderKey = @CMFolderKey
		WHERE	(Entity = 'Organizer' OR Entity = 'Attendee')
		AND		EntityKey = @UserKey
		AND		ISNULL(CMFolderKey, 0) = 0
	*/	
	RETURN @CMFolderKey
GO
