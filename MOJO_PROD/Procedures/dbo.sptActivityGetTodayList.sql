USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetTodayList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetTodayList]

	(
		@UserKey int,  --In all 3 places that this is called @UserKey is the current logged in user
		@CurDate smalldatetime,
		@IncludeAll tinyint = 0,
		@AscendingOrder tinyint = 1,
		@NotAssignedToTask tinyint = 0, --If 1, it will only return activities where TaskKey is null
		@HideToDo tinyint = 0, --If 1, will not return ToDos
		@HideDiary tinyint = 0 --If 1, will not return Diarys
	)

AS --Encrypt

  /* @Include All values:
		0: All
		1: On and before today
		2: Last 2 weeks
		3: Next 2 weeks
		4: Last and next 2 weeks
	*/

  /*
  || When     Who Rel   What
  || 05/19/08 QMD 10.0  Added additional values for @IncludeAll based on the configuration of the my activities widget
  || 2/1/09   GWG 10.5  Rewrite for 10.5
  || 06/23/09 GHL 10.027 (38786) Sorting now by ActivityDate depending on @AscendingOrder
  || 11/4/09  GWG 10.513 Added project and task to the list
  || 8/24/10  CRG 10.5.3.4 Added check for Activity folder security, and also rewrote it to make it easier to maintain by removing all of the IF...ELSE blocks.
  ||                     Also added @NotAssignedToTask parm. If it's 1, then only activities where TaskKey is null will be returned.
  || 9/14/10  RLB 10.535 (89975) fixed IncludeAll when value was 5 will now get last 2 weeks and next 2 weeks nothing was set before
  || 12/21/10 CRG 10.5.3.9 Added several columns for use by the CalendarMyTasks component
  || 12/28/10 CRG 10.5.3.9 Wrapped TaskKey with ISNULL in ActivityKey query
  || 1/19/11  CRG 10.5.4.0 Modified so that To Do items are not restricted based on the activity folders
  || 09/23/11 RLB 10.5.4.8 (122084) remove part of the where the was filtering out 'ToDo's and reply activities
  || 10/21/14 WDF 10.5.8.5 (231857) Allow filtering out of 'ToDo's and 'Diary's
  */

  	DECLARE	@UseActivityFolders tinyint,
			@CompanyKey int,
			@SecurityGroupKey int
	
	SELECT	@CompanyKey = CompanyKey,
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

	SELECT	ActivityKey
	INTO	#ActivityKeys
	FROM	tActivity (nolock)
	WHERE	AssignedUserKey = @UserKey
	AND		ISNULL(Completed, 0) = 0
	AND		(@NotAssignedToTask = 0 OR ISNULL(TaskKey, 0) = 0)
	AND		(
				@UseActivityFolders = 0
				OR 
				CMFolderKey IS NULL
				OR
				CMFolderKey IN (SELECT CMFolderKey FROM #folders)
				OR
				ActivityEntity = 'ToDo'
			)
	AND		(
				@IncludeAll = 1 --All
				OR
				(@IncludeAll = 0 AND ActivityDate = @CurDate) --Today only (also CMP)
				OR
				(@IncludeAll = 2 AND ActivityDate < DATEADD(dd, 1, @CurDate)) --On or before today
				OR
				(@IncludeAll = 3 AND ActivityDate > DATEADD(dd, -14, @CurDate) AND ActivityDate < DATEADD(dd, 1, @CurDate)) --Last 2 weeks
				OR
				(@IncludeAll = 4 AND ActivityDate < DATEADD(dd, 14, @CurDate) AND ActivityDate > DATEADD(dd, -1, @CurDate)) --Next 2 weeks
				OR
				(@IncludeAll = 5 and ActivityDate >= DATEADD(dd, -14, @CurDate) AND ActivityDate <= DATEADD(dd, 14, @CurDate)) -- Next and Last 2 weeks
			) --Next 2 weeks

	IF @AscendingOrder = 1
		SELECT	ca.Subject,
				ca.ActivityKey,
				c.CompanyName,
				u.FirstName + ' ' + u.LastName as UserName,
				u.Phone1,
				u.Cell,
				u.Email,
				ca.Notes,
				ca.ActivityDate,
				ca.ActivityTime,
				ca.Priority,
				ca.ProjectKey,
				p.ProjectNumber,
				p.ProjectName,
				ca.TaskKey,
				t.TaskID,
				t.TaskName,
				ca.ActivityEntity,
				ca.AssignedUserKey,
				au.UserName AS AssignedUserName,
				ca.Completed,
				ca.Private,
				ca.VisibleToClient
		FROM	tActivity ca (nolock)
		LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
		LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
		LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
		LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
		LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey
		WHERE ca.ActivityKey IN (SELECT ActivityKey FROM #ActivityKeys)
		  AND (ca.ActivityEntity IS NULL
		   OR  ca.ActivityEntity NOT IN ('ToDo', 'Diary')
		   OR  (ca.ActivityEntity = 'ToDo' AND @HideToDo = 0)
		   OR  (ca.ActivityEntity = 'Diary' AND @HideDiary = 0))
		ORDER BY ActivityDate, ca.Subject
	ELSE
		SELECT	ca.Subject,
				ca.ActivityKey,
				c.CompanyName,
				u.FirstName + ' ' + u.LastName as UserName,
				u.Phone1,
				u.Cell,
				u.Email,
				ca.Notes,
				ca.ActivityDate,
				ca.ActivityTime,
				ca.Priority,
				ca.ProjectKey,
				p.ProjectNumber,
				p.ProjectName,
				ca.TaskKey,
				t.TaskID,
				t.TaskName,
				ca.ActivityEntity,
				ca.AssignedUserKey,
				au.UserName AS AssignedUserName,
				ca.Completed,
				ca.Private,
				ca.VisibleToClient
		FROM	tActivity ca (nolock)
		LEFT JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
		LEFT JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
		LEFT JOIN tProject p (nolock) ON ca.ProjectKey = p.ProjectKey
		LEFT JOIN tTask t (nolock) on ca.TaskKey = t.TaskKey
		LEFT JOIN vUserName au (nolock) ON ca.AssignedUserKey = au.UserKey
		WHERE	ca.ActivityKey IN (SELECT ActivityKey FROM #ActivityKeys)
		  AND (ca.ActivityEntity IS NULL
		   OR  ca.ActivityEntity NOT IN ('ToDo', 'Diary')
		   OR  (ca.ActivityEntity = 'ToDo' AND @HideToDo = 0)
		   OR  (ca.ActivityEntity = 'Diary' AND @HideDiary = 0))
		ORDER BY ActivityDate DESC, ca.Subject
GO
