USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppCalendarGetUser]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptAppCalendarGetUser]
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 2/26/15   CRG 10.5.8.9 Created
*/

	DECLARE	@SecurityGroupKey int,
			@CompanyKey int
		
	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@CompanyKey = CompanyKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	--Ensure that the user's own calendars are all in tAppCalendar
	INSERT	tAppCalendar
			(UserKey, 
			Entity, 
			EntityKey, 
			CalendarColor,
			Display,
			OwnerUserKey)
	SELECT	@UserKey,
			'tCMFolder',
			f.CMFolderKey,
			f.CalendarColor,
			1,
			@UserKey
	FROM	tCMFolder f (nolock)
	WHERE	Entity = 'tCalendar'
	AND		UserKey = @UserKey
	AND		CMFolderKey NOT IN
				(SELECT	CMFolderKey
				FROM	tAppCalendar (nolock)
				WHERE	UserKey	= @UserKey)
	
	--Delete any calendars that have been deleted from tCMFolder
	DELETE	tAppCalendar
	WHERE	UserKey = @UserKey
	AND		Entity = 'tCMFolder'
	AND		OwnerUserKey = @UserKey
	AND		EntityKey NOT IN (SELECT CMFolderKey FROM tCMFolder)
	
	IF EXISTS (SELECT 1 FROM tAppCalendar WHERE UserKey = @UserKey AND Entity = 'tCMFolder' AND OwnerUserKey <> @UserKey)
	BEGIN
		--Make sure that this user still has rights to other peoples' calendars
		DELETE	tAppCalendar
		WHERE	UserKey = @UserKey 
		AND		Entity = 'tCMFolder' 
		AND		OwnerUserKey <> @UserKey
		AND		EntityKey NOT IN 
					(SELECT	f.CMFolderKey
					FROM	tCMFolder f (nolock)
					INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
					INNER JOIN tUser u (nolock) ON f.UserKey = u.UserKey
					WHERE	((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
							OR
							(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
					AND		(fs.CanView = 1 OR fs.CanAdd = 1)
					AND		f.UserKey <> 0
					AND		f.UserKey <> @UserKey
					AND		f.Entity = 'tCalendar'
					AND		u.Active = 1)
	END

	IF EXISTS (SELECT 1 FROM tAppCalendar WHERE UserKey = @UserKey AND Entity = 'tCMFolder' AND OwnerUserKey = 0)
	BEGIN
		--Make sure that this user still has rights to public calendars
		CREATE TABLE #tPublicCalList (CMFolderKey int NULL, CanAdd tinyint NULL)
		EXEC spCalendarManagerGetPublicCalendars @UserKey
		
		DELETE	tAppCalendar
		WHERE	UserKey = @UserKey
		AND		Entity = 'tCMFolder'
		AND		OwnerUserKey = 0
		AND		EntityKey NOT IN (SELECT CMFolderKey FROM #tPublicCalList)
	END
	
	IF EXISTS (SELECT 1 FROM tAppCalendar WHERE UserKey = @UserKey AND Entity = 'tCalendarResource')
	BEGIN
		--Make sure that the resource still exists
		DELETE	tAppCalendar
		WHERE	UserKey = @UserKey
		AND		Entity = 'tCalendarResource'
		AND		EntityKey NOT IN (SELECT CalendarResourceKey FROM tCalendarResource (nolock) WHERE CompanyKey = @CompanyKey)
	END

	SELECT	*
	FROM	tAppCalendar (nolock)
	WHERE	UserKey = @UserKey
GO
