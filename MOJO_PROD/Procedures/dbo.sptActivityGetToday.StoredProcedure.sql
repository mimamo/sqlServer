USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToday]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToday]

	@UserKey int,
	@CurrentDate datetime = GETDATE,
	@Mode varchar(50)
	
AS --Encrypt

  /*
  || When     Who Rel      What
  || 09/00/14 QMD 10.5.8.3 Created for wjapp
  || 10/01/14 QMD 10.5.8.5 Added year condition, added ContactCompanyKey, UserLeadKey, ContactKey, ProjectKey
  || 10/27/14 MAS 10.5.8.5 Added Opened activities
  || 10/31/14 QMD 10.5.8.5 Added Activity Entity
  || 12/15/14 MAS 10.5.8.7 Exclude replies
  || 02/19/15 QMD 10.5.8.9 Added OriginatorUserKey clause to the unread query
  */

  	DECLARE	@UseActivityFolders tinyint,
			@CompanyKey int,
			@SecurityGroupKey int
						
	
	SELECT	@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey),
			@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

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
		AND		(
					(fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
					OR
					(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey)
				)
		AND		(fs.CanView = 1 OR fs.CanAdd = 1)

		--Add the logged user's own personal folders
		INSERT	#folders
				(CMFolderKey)
		SELECT	CMFolderKey
		FROM	tCMFolder (nolock)
		WHERE	Entity = 'tActivity'
		AND		UserKey = @UserKey			
	END
	
			

if @Mode = 'today'
BEGIN
-- today
	SELECT	ca.Subject,
			ca.ActivityKey,
			c.CompanyName,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Phone1,
			u.Cell,
			u.Email,
			ca.Notes,
			dbo.fFormatDateNoTime(ca.ActivityDate) as ActivityDate,
			ca.ActivityTime,
			p.ProjectNumber,
			p.ProjectName	
	FROM	tActivity ca (nolock)
	LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
	LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
	LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey
	WHERE	ca.AssignedUserKey = @UserKey
			AND		ca.CompanyKey = @CompanyKey
			AND		ISNULL(ca.Completed, 0) = 0			
			AND		ISNULL(ca.ParentActivityKey, 0) = 0			
			AND		ca.ActivityEntity = 'Activity'
			AND		(
						@UseActivityFolders = 0
						OR 
						ca.CMFolderKey IS NULL
						OR
						ca.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
					)
			AND		DATEPART(yy, ca.ActivityDate) = DATEPART(yy,@CurrentDate) --Today only (also CMP)
			AND		DATEPART(mm, ca.ActivityDate) = DATEPART(mm,@CurrentDate)
			AND		DATEPART(dd, ca.ActivityDate) = DATEPART(dd,@CurrentDate) 
	
	ORDER BY ActivityDate, ca.Subject


END

if @Mode = 'thisweek'
BEGIN

	
	-- this week
	SELECT	ca.Subject,
			ca.ActivityKey,
			c.CompanyName,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Phone1,
			u.Cell,
			u.Email,
			ca.Notes,
			dbo.fFormatDateNoTime(ca.ActivityDate) as ActivityDate,
			ca.ActivityTime,
			p.ProjectNumber,
			p.ProjectName			
	FROM	tActivity ca (nolock)
	LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
	LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
	LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey
	WHERE	ca.AssignedUserKey = @UserKey
			AND		ca.CompanyKey = @CompanyKey
			AND		ISNULL(ca.Completed, 0) = 0
			AND		ISNULL(ca.ParentActivityKey, 0) = 0
			AND		ca.ActivityEntity = 'Activity'
			AND		(
						@UseActivityFolders = 0
						OR 
						ca.CMFolderKey IS NULL
						OR
						ca.CMFolderKey IN (SELECT CMFolderKey FROM #folders)
					)
			AND		DATEPART(wk, ca.ActivityDate) = DATEPART(wk, @CurrentDate)
			AND		DATEPART(yy, ca.ActivityDate) = DATEPART(yy,@CurrentDate)
	
	ORDER BY ca.ActivityDate, ca.Subject
	



END

if @Mode = 'unread'
BEGIN

	
	
	-- unread
	SELECT	ca.Subject,
			ca.ActivityKey,
			c.CompanyName,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Phone1,
			u.Cell,
			u.Email,
			ca.Notes,
			dbo.fFormatDateNoTime(ca.ActivityDate) as ActivityDate,
			ca.ActivityTime,
			p.ProjectNumber,
			p.ProjectName			
	FROM	tActivity ca (nolock)
	LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
	LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
	LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey	
	LEFT JOIN tAppRead ap (NOLOCK) ON ap.Entity = 'tActivity' AND ca.ActivityKey = ap.EntityKey AND	ap.UserKey = @UserKey
	WHERE	( ca.AssignedUserKey = @UserKey OR ca.OriginatorUserKey = @UserKey )
			AND		ca.CompanyKey = @CompanyKey
			AND		ISNULL(ca.Completed, 0) = 0
			AND		ISNULL(ca.ParentActivityKey, 0) = 0
			AND		ca.ActivityEntity = 'Activity'
			AND		(
						@UseActivityFolders = 0
						OR 
						ca.CMFolderKey IS NULL
						OR
						ca.CMFolderKey IN (SELECT CMFolderKey FROM #folders)						
					)
			AND		(
						ap.IsRead = 0
						OR ap.EntityKey IS NULL
					)
	
	ORDER BY ca.ActivityDate, ca.Subject
	
	



END

if @Mode = 'open'
BEGIN

-- opened (not completed)
	SELECT	ca.Subject,
			ca.ActivityKey,
			c.CompanyName,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Phone1,
			u.Cell,
			u.Email,
			ca.Notes,
			dbo.fFormatDateNoTime(ca.ActivityDate) as ActivityDate,
			ca.ActivityTime,
			p.ProjectNumber,
			p.ProjectName			
	FROM	tActivity ca (nolock)
	LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
	LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
	LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey
	WHERE	AssignedUserKey = @UserKey
			AND		ca.CompanyKey = @CompanyKey
			AND		ISNULL(Completed, 0) = 0
			AND		ISNULL(ParentActivityKey, 0) = 0
			AND		ActivityEntity = 'Activity'
			AND		(
						@UseActivityFolders = 0
						OR 
						ca.CMFolderKey IS NULL
						OR
						ca.CMFolderKey IN (SELECT CMFolderKey FROM #folders)						
					)

	ORDER BY ActivityDate, ca.Subject
	



END
GO
