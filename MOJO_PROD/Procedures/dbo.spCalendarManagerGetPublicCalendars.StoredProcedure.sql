USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetPublicCalendars]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetPublicCalendars]
	@UserKey int,
	@EditOnly tinyint = 0 --If 1, only list public calendars that the user has rights to edit
AS

/*
|| When      Who Rel      What
|| 6/29/09   CRG 10.5.0.0 Created to provide a common SP for public calendar security
|| 8/31/09   CRG 10.5.0.9 Fixed query to avoid duplicate rows. If the user had access to a public folder, and their security group had access as well,
||                        it was causing duplicate rows.
*/

	/* Assume created outside of this SP
	CREATE TABLE #tPublicCalList (CMFolderKey int NULL, CanAdd tinyint NULL) --Only need CanAdd because you have to at least have CanView to be in the list
	*/
	
	DECLARE	@CompanyKey int,
			@SecurityGroupKey int,
			@Administrator tinyint
	
	SELECT	@CompanyKey = CompanyKey,
			@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey	
	
	INSERT	#tPublicCalList (CMFolderKey, CanAdd)
	SELECT 	f.CMFolderKey, MAX(fs.CanAdd)
	FROM	vCMFolderUserName f (nolock)
	INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
	WHERE	((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
			OR
			(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
	AND		(fs.CanAdd = 1
			OR (fs.CanView = 1 AND @EditOnly = 0))
	AND		ISNULL(f.UserKey, 0) = 0
	AND		f.Entity = 'tCalendar'
	GROUP BY f.CMFolderKey
	
	--If the user is an administrator, add in any Public calendars that the user didn't already have access to...
	IF @Administrator = 1
	BEGIN
		INSERT	#tPublicCalList (CMFolderKey, CanAdd)
		SELECT 	CMFolderKey, 1
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		ISNULL(UserKey, 0) = 0
		AND		Entity = 'tCalendar'
		AND		CMFolderKey NOT IN (SELECT CMFolderKey FROM #tPublicCalList)
		
		--If Administrator, set all rows' CanAdd to 1, since some may have been added by the first query
		UPDATE #tPublicCalList
		SET		CanAdd = 1
	END
GO
