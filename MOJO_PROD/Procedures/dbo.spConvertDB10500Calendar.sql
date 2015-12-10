USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10500Calendar]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10500Calendar]
AS --Encrypt

/*
|| When      Who Rel      What
|| 7/31/08   CRG 10.5.0.0 Created for the data conversion of calendar events to 10.5
|| 4/23/09   CRG 10.5.0.0 Added call to SP to set IncludeInSync for the default calendar
|| 7/28/09   CRG 10.5.0.0 Now creating a public Vacations calendar for each company with BlockoutAttendees defaulted to 1
|| 10/12/09  GHL 10.512   Added protection against null CompanyKey in tCMFolder insert
*/

	DECLARE	@UserKey int,
			@CMFolderKey int,
			@CompanyKey int,
			@ProjectKey int,
			@CalendarKey int,
			@ContactLeadKey int,
			@ContactCompanyKey int,
			@ContactUserKey int

	SELECT	@UserKey = 0

	--Convert Personal Events
	WHILE(1=1)
	BEGIN
		SELECT	@UserKey = MIN(ca.EntityKey)
		FROM	tCalendarAttendee ca (nolock)
		INNER JOIN tCalendar c (nolock) ON ca.CalendarKey = c.CalendarKey
		WHERE	(ca.Entity = 'Organizer' OR ca.Entity = 'Attendee')
		AND		ca.EntityKey > @UserKey

		--print 'UserKey: ' + CAST(@UserKey as varchar)

		IF @UserKey IS NULL
			BREAK

		SELECT	@CMFolderKey = DefaultCMFolderKey,
				@CompanyKey = CompanyKey
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey
		
		--print 'DefaultCMFolderKey: ' + CAST(@CMFolderKey as varchar)

		IF @CMFolderKey IS NULL AND @CompanyKey IS NOT NULL
		BEGIN
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
			VALUES	('Default calendar', 0, @UserKey, @CompanyKey, 'tCalendar')

			SELECT	@CMFolderKey = @@IDENTITY
			
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
						WHEN 2 THEN 1
						ELSE 0
					END,
					CASE AccessType
						WHEN 2 THEN 1
						ELSE 0
					END
			FROM	tCalendarUser (nolock)
			WHERE	UserKey = @UserKey

			UPDATE	tUser
			SET		DefaultCMFolderKey = @CMFolderKey
			WHERE	UserKey = @UserKey
			
			--print 'Updated user DefaultCMFolderKey to: ' + CAST(@CMFolderKey as varchar)
			
			--Force IncludeInSync for the default calendar
			EXEC sptCMFolderIncludeInSyncUpdate @CMFolderKey, @UserKey, 1
		END

		UPDATE	tCalendarAttendee
		SET		CMFolderKey = @CMFolderKey
		WHERE	(Entity = 'Organizer' OR Entity = 'Attendee')
		AND		EntityKey = @UserKey
		AND		ISNULL(CMFolderKey, 0) = 0
		
		--print 'Updating tCalendarAttendee CMFolderKey to: ' + CAST(@CMFolderKey as varchar) + ' where EntityKey = ' + CAST(@UserKey as varchar)
		--print '------------------------------'
		--print ''
	END

	--Create Company and Project Public Folders for every company, then convert the Company and Project events into those folders
	SELECT	@CompanyKey = 0

	WHILE(1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	tCompany (nolock)
		WHERE	CompanyKey > @CompanyKey
		AND		ISNULL(OwnerCompanyKey, 0) = 0

		--print 'CompanyKey: ' + cast(@CompanyKey as varchar)

		IF @CompanyKey IS NULL
			BREAK

		SELECT	@CMFolderKey = NULL

		--Create Project Meeting folder
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UserKey = 0
		AND		FolderName = 'Public project meetings'
		
		--print 'CMFolderKey-Project: ' + cast(@CMFolderKey as varchar)

		IF @CMFolderKey IS NULL
		BEGIN
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
			VALUES	('Public project meetings', 0, 0, @CompanyKey, 'tCalendar')

			SELECT	@CMFolderKey = @@IDENTITY
			
			--Add a FolderSecurity row for every active SecurityGroup in the Company
			--CMFolderKey is brand new, so we don't need to check if it already exists in the table
			INSERT	tCMFolderSecurity
					(CMFolderKey,
					Entity,
					EntityKey,
					CanView,
					CanAdd)
			SELECT	@CMFolderKey,
					'tSecurityGroup',
					SecurityGroupKey,
					1,
					0
			FROM	tSecurityGroup (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		Active = 1
		END
		
		UPDATE	tCalendar
		SET		CMFolderKey = @CMFolderKey
		WHERE	CompanyKey = @CompanyKey
		AND		EventLevel = 2
		AND		ISNULL(CMFolderKey, 0) = 0
		
		SELECT	@CMFolderKey = NULL
		
		--Create Company Meeting folder
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UserKey = 0
		AND		FolderName = 'Public company meetings'

		--print 'CMFolderKey-Public: ' + cast(@CMFolderKey as varchar)

		IF @CMFolderKey IS NULL
		BEGIN
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
			VALUES	('Public company meetings', 0, 0, @CompanyKey, 'tCalendar')

			SELECT	@CMFolderKey = @@IDENTITY
			
			--Add a FolderSecurity row for every active SecurityGroup in the Company
			--CMFolderKey is brand new, so we don't need to check if it already exists in the table
			INSERT	tCMFolderSecurity
					(CMFolderKey,
					Entity,
					EntityKey,
					CanView,
					CanAdd)
			SELECT	@CMFolderKey,
					'tSecurityGroup',
					SecurityGroupKey,
					1,
					0
			FROM	tSecurityGroup (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		Active = 1
		END
		
		UPDATE	tCalendar
		SET		CMFolderKey = @CMFolderKey
		WHERE	CompanyKey = @CompanyKey
		AND		EventLevel = 3
		AND		ISNULL(CMFolderKey, 0) = 0
		
		--Create Company Vacation folder
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UserKey = 0
		AND		FolderName = 'Vacations'
		AND		BlockoutAttendees = 1

		--print 'CMFolderKey-Public: ' + cast(@CMFolderKey as varchar)

		IF @CMFolderKey IS NULL
		BEGIN
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity, BlockoutAttendees)
			VALUES	('Vacations', 0, 0, @CompanyKey, 'tCalendar', 1)

			SELECT	@CMFolderKey = @@IDENTITY
			
			--Add a FolderSecurity row for every active SecurityGroup in the Company
			--CMFolderKey is brand new, so we don't need to check if it already exists in the table
			INSERT	tCMFolderSecurity
					(CMFolderKey,
					Entity,
					EntityKey,
					CanView,
					CanAdd)
			SELECT	@CMFolderKey,
					'tSecurityGroup',
					SecurityGroupKey,
					1,
					1  --Allow everyone to edit the folder by default
			FROM	tSecurityGroup (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		Active = 1
		END		
	END
	
	--Create Project Links
	SELECT	@CalendarKey = 0
	
	WHILE(1=1)
	BEGIN
		SELECT	@CalendarKey = MIN(CalendarKey)
		FROM	tCalendar (nolock)
		WHERE	ISNULL(ProjectKey, 0) > 0
		AND		CalendarKey > @CalendarKey
		
		--print 'CalendarKey ' + cast(@CalendarKey as varchar)
		
		IF @CalendarKey IS NULL
			BREAK
		
		SELECT	@ProjectKey = ProjectKey
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey
		
		IF NOT EXISTS
				(SELECT 1
				FROM	tCalendarLink (nolock)
				WHERE	CalendarKey = @CalendarKey
				AND		Entity = 'tProject'
				AND		EntityKey = @ProjectKey)
			INSERT	tCalendarLink
					(CalendarKey,
					Entity,
					EntityKey)
			VALUES	(@CalendarKey,
					'tProject',
					@ProjectKey)
	END
	
	--Create Opportunity Links
	SELECT	@CalendarKey = 0
	
	WHILE(1=1)
	BEGIN
		SELECT	@CalendarKey = MIN(CalendarKey)
		FROM	tCalendar (nolock)
		WHERE	ISNULL(ContactLeadKey, 0) > 0
		AND		CalendarKey > @CalendarKey
		
		--print 'CalendarKey ' + cast(@CalendarKey as varchar)
		
		IF @CalendarKey IS NULL
			BREAK
		
		SELECT	@ContactLeadKey = ContactLeadKey
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey
		
		IF NOT EXISTS
				(SELECT 1
				FROM	tCalendarLink (nolock)
				WHERE	CalendarKey = @CalendarKey
				AND		Entity = 'tLead'
				AND		EntityKey = @ContactLeadKey)
			INSERT	tCalendarLink
					(CalendarKey,
					Entity,
					EntityKey)
			VALUES	(@CalendarKey,
					'tLead',
					@ContactLeadKey)
	END	

	--Create Company Links
	SELECT	@CalendarKey = 0

	WHILE(1=1)
	BEGIN
		SELECT	@CalendarKey = MIN(CalendarKey)
		FROM	tCalendar (nolock)
		WHERE	ISNULL(ContactCompanyKey, 0) > 0
		AND		CalendarKey > @CalendarKey
		
		--print 'CalendarKey ' + cast(@CalendarKey as varchar)
		
		IF @CalendarKey IS NULL
			BREAK
		
		SELECT	@ContactCompanyKey = ContactCompanyKey
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey
		
		IF NOT EXISTS
				(SELECT 1
				FROM	tCalendarLink (nolock)
				WHERE	CalendarKey = @CalendarKey
				AND		Entity = 'tCompany'
				AND		EntityKey = @ContactCompanyKey)
			INSERT	tCalendarLink
					(CalendarKey,
					Entity,
					EntityKey)
			VALUES	(@CalendarKey,
					'tCompany',
					@ContactCompanyKey)
	END	
	
	--Add Attendee for Contact
	SELECT	@CalendarKey = 0

	WHILE(1=1)
	BEGIN
		SELECT	@CalendarKey = MIN(CalendarKey)
		FROM	tCalendar (nolock)
		WHERE	ISNULL(ContactUserKey, 0) > 0
		AND		CalendarKey > @CalendarKey
		
		--print 'CalendarKey ' + cast(@CalendarKey as varchar)
		
		IF @CalendarKey IS NULL
			BREAK
		
		SELECT	@ContactUserKey = ContactUserKey
		FROM	tCalendar (nolock)
		WHERE	CalendarKey = @CalendarKey
		
		IF NOT EXISTS
				(SELECT 1
				FROM	tCalendarAttendee (nolock)
				WHERE	CalendarKey = @CalendarKey
				AND		Entity = 'Attendee'
				AND		EntityKey = @ContactUserKey)
			INSERT	tCalendarAttendee
					(CalendarKey,
					Entity,
					EntityKey,
					Status,
					CMFolderKey)
			SELECT	@CalendarKey,
					'Attendee',
					@ContactUserKey,
					1,
					DefaultCMFolderKey
			FROM	tUser
			WHERE	UserKey = @ContactUserKey
	END	

	
	--In 85 Tentative could be either 0 or 1. Now it'll always be 1
	UPDATE	tCalendarAttendee
	SET		Status = 1
	WHERE	ISNULL(Status, 0) = 0
GO
