USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetActivities]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetActivities]
	@UserKey int,
	@LoggedUserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ExcludeCompletedActivities tinyint
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/4/08    CRG 10.5.0.0 Created for the CalendarManager to get Activities for a user
|| 3/3/09    CRG 10.5.0.0 Added @ExcludeCompletedActivities parameter
|| 4/24/09   CRG 10.5.0.0 Added Assigned user's TimeZoneIndex
|| 5/7/09    CRG 10.5.0.0 Added Activity Type Color
|| 8/7/09    CRG 10.5.0.0 Fixed join for AssignedUserKey
|| 8/24/10   CRG 10.5.3.4 Added security to not show activities that are in other users' personal folders or are in public folders that this user does not have rights to.
||                        Also added @LoggedUserKey parameter.
|| 3/26/12   RLB 10.5.5.4 (138055) Just pulling Activites and not ToDo's or Diary
*/

	DECLARE	@UseActivityFolders tinyint,
			@CompanyKey int,
			@SecurityGroupKey int
	
	SELECT	@CompanyKey = CompanyKey,
			@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (nolock)
	WHERE	UserKey = @LoggedUserKey

	SELECT	@UseActivityFolders = ISNULL(UseActivityFolders, 0)
	FROM	tPreference (nolock)
	WHERE	CompanyKey = @CompanyKey

	CREATE TABLE #folders
			(CMFolderKey int null)

	IF @UseActivityFolders = 1
	BEGIN
		--Get a list of public activity folders that the logged user can see
		INSERT	#folders
				(CMFolderKey)
		SELECT 	f.CMFolderKey
		FROM	tCMFolder f (nolock)
		INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
		WHERE	f.CompanyKey = @CompanyKey
		AND		f.Entity = 'tActivity'
		AND		f.UserKey = 0
		AND		((fs.Entity = 'tUser' AND fs.EntityKey = @LoggedUserKey)
				OR
				(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
		AND		(fs.CanView = 1 OR fs.CanAdd = 1)

		--Add the logged user's own personal folders
		INSERT	#folders
				(CMFolderKey)
		SELECT	CMFolderKey
		FROM	tCMFolder (nolock)
		WHERE	Entity = 'tActivity'
		AND		UserKey = @LoggedUserKey			
	END
		
	SELECT	a.*,
			u.UserName,
			u.Email,
			u.Phone1,
			c.CompanyName,
			l.Subject AS Opportunity,
			p.ProjectNumber,
			p.ProjectName,
			CASE
				WHEN a.StartTime IS NULL THEN 1
				ELSE 0
			END AS AllDay,
			au.TimeZoneIndex,
			type.TypeColor
	FROM	tActivity a (nolock)
	LEFT JOIN vUserName u (nolock) ON a.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON a.ContactCompanyKey = c.CompanyKey
	LEFT JOIN tLead l (nolock) ON a.LeadKey = l.LeadKey
	LEFT JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tUser au (nolock) ON a.AssignedUserKey = au.UserKey
	LEFT JOIN tActivityType type (nolock) ON a.ActivityTypeKey = type.ActivityTypeKey
	WHERE	AssignedUserKey = @UserKey
	AND		ActivityEntity = 'Activity'
	AND		ActivityDate BETWEEN @StartDate AND @EndDate
	AND		(@ExcludeCompletedActivities = 0 OR ISNULL(Completed, 0) = 0)
	AND		(a.CMFolderKey IS NULL
			OR
			a.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
			OR
			@UseActivityFolders = 0)
GO
