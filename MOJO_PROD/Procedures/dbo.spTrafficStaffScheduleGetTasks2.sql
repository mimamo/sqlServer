USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficStaffScheduleGetTasks2]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficStaffScheduleGetTasks2]
	(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@ProjectStatusKey int,
		@OfficeKey int = NULL,
		@ServiceKey int = NULL,
		@SkillKey int = NULL,
		@UserKey int = NULL,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL,
		@GLCompanyKey int = NULL,
		@ProjectKey int = 0,
		@UnassignedOnly tinyint = 0,
		@ExcludeZeroHourTasks tinyint = 0,
		@PredecessorsComplete tinyint = 0,
		@LoggedUserKey int = null
	)
AS --Encrypt

  /*
  || When     Who Rel       What
  || 11/11/11 RLB 105.5.0	(118328) Created for enhancement of New Staff Schedule passing in temp tables with Department and Team keys  
  || 11/29/11 RLB 105.5.0   (109878) Added GL Company Filter
  || 12/01/11 GHL 105.5.0   (127236) Returning now for each task a flag IsTaskServicesOnly that indicates if a task
  ||                         does not have any user in tTaskUser. This allows to remove the VB code fragment that kills
  ||                         performance when querying tTaskUser task by task   
  || 12/1/11  CRG 10.5.5.0  (126959) Added BudgetTaskKey in the query for Single User Mode
  || 12/27/11 CRG 10.5.5.1  (126589) Added @ExcludeZeroHourTasks, and now returning ProjectOrder for enhancement
  || 01/11/12 RLB 10.5.5.1  (130803) fix for Team Filter
  || 01/18/12 RLB 10.5.5.2  (131981) fix for department filter on service
  || 02/08/12 RLB 10.5.5.2  adding ProjectStatuses filter
  || 02/20/12 GWG 10.5.5.3  Added a date and verified filter for time so that only unverified time after today shows up.
  || 04/18/12 GWG 10.5.5.4  Added PercCompSeparate to the get
  || 04/30/12 GHL 10.5.5.5  Added @LoggedUserKey and logic for tUserGLCompanyAccess
  ||                        Note: @UserKey is the assigned user key from the user drop down, we need the logged user key
  || 09/10/13 RLB 10.5.7.2  (187729) Added Project Type as a filter on staff schedule
  || 11/04/13 WDF 10.5.7.4  (193655) Added Summary Task fields
  || 04/04/14 GHL 10.5.7.8  (212088) Increased performance from 6 sec to 2 sec by selecting only keys in initial
  ||                         query then filling up with other data. Case: By Company and UnassignedOnly = 0. 
  ||                         Did not investigate why so many descriptions must come from tProject (6000 chars each)
  */

/*
             ////////////////////////////////////////////////////////////////////////////
             ////////////////////////////////////////////////////////////////////////////
                             DO NOT ADD OTHER FIELDS TO THE INITIAL LOAD
             SOMEBODY ADDED tTask.Comments TO THE FIRST LOAD AND THAT REDUCED PERFORMANCE
             ////////////////////////////////////////////////////////////////////////////
             ////////////////////////////////////////////////////////////////////////////

I use a covering index to get the initial data 
Then get TaskID, TaskName, description from temp table (this could also be ontained when drilling down in the Flash screen)
--CREATE NONCLUSTERED INDEX [IX_tTask_2] ON [dbo].[tTask] ([ProjectKey], [PlanStart], [PlanComplete], [PlanDuration], [WorkAnyDay], [PercComp], [PercCompSeparate], [TaskKey])

exec spTrafficGetTasks @CompanyKey=2,@StartDate='2008-08-06 00:00:00:000',@EndDate='2008-08-20 00:00:00:000',
@ProjectStatusKey=NULL,@OfficeKey=NULL,@DepartmentKey=NULL,@ServiceKey=NULL,@SkillKey=NULL

*/

	DECLARE @AllDepartments int, @AllTeams int, @AllProjectStatuses int, @AllProjectTypes int

	if (Select  count(*) from #departmentKeys) = 0
		Select @AllDepartments = 0
	else
		Select @AllDepartments = 1

	if (Select  count(*) from #teamKeys) = 0
		Select @AllTeams = 0
	else
		Select @AllTeams = 1

	if (Select  count(*) from #projectStatusKeys) = 0
		Select @AllProjectStatuses = 0
	else
		Select @AllProjectStatuses = 1

	if (Select  count(*) from #projectTypeKeys) = 0
		Select @AllProjectTypes = 0
	else
		Select @AllProjectTypes = 1  

	SET NOCOUNT ON

	-- Get today's date without times 
	DECLARE @Today DATETIME
	SELECT @Today = GETDATE()
	SELECT @Today = CONVERT(DATETIME,  CONVERT(VARCHAR(10), @Today, 101), 101)

	if @StartDate < @Today and @EndDate < @Today
		return

	if @StartDate < @Today
		Select @StartDate = @Today
	if @EndDate < @Today
		Select @EndDate = @Today



Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @LoggedUserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	CREATE TABLE #tTask (
     TaskUserKey INT NULL  
	 ,TaskKey INT NULL  
	 ,FormattedName VARCHAR(535) NULL  
     ,TaskName VARCHAR(535) NULL 
     ,ProjectFullName VARCHAR(155) NULL  
     ,Description VARCHAR(6000) NULL  
	 ,ProjectKey INT NULL
	 ,PlanStart SMALLDATETIME NULL  
     ,PlanComplete SMALLDATETIME NULL  
     ,PlanDuration INT NULL
     ,WorkAnyDay INT NULL
     ,Hours DECIMAL(24, 4) NULL  
     ,UserKey INT NULL
	 ,ServiceKey INT NULL
     ,CompanyKey INT NULL
     ,WorkSun INT NULL
     ,WorkMon INT NULL
     ,WorkTue INT NULL
     ,WorkWed INT NULL
     ,WorkThur INT NULL
     ,WorkFri INT NULL
     ,WorkSat INT NULL
	 ,PercCompSeparate TINYINT NULL
     ,PercComp INT NULL   
     ,ActualHours DECIMAL(24, 4) NULL  
     ,ScheduleNote VARCHAR(200) NULL
     ,Comments VARCHAR(6000) NULL
     ,Priority INT NULL
     ,PriorityName Varchar(20)   
     ,ProjectNumber VARCHAR(155) NULL 
	 ,ProjectName VARCHAR(155) NULL 
	 ,ProjectStartDate SMALLDATETIME NULL  
	 ,ProjectCompleteDate SMALLDATETIME NULL  
	 ,ProjectPercComp SMALLDATETIME NULL  
	 ,ProjectStatusKey INT NULL 
	 ,ScheduleDirection INT NULL
	 ,StatusNotes VARCHAR(100) NULL
	 ,DetailedNotes VARCHAR(6000) NULL
	 ,ClientNotes VARCHAR(6000) NULL
	 ,ClientKey INT NULL
	 ,ScheduleLockedByKey INT NULL
	 ,Locked TINYINT NULL
	 ,ProjectStatus VARCHAR(200) NULL
	 ,ProjectStatusID VARCHAR(30) NULL
	 ,ProjectBillingStatusKey INT NULL
	 ,ProjectBillingStatus VARCHAR(200) NULL
	 ,ProjectBillingStatusID VARCHAR(30) NULL
	 ,BudgetTaskKey INT NULL
	 ,TaskConstraint SMALLINT NULL
	 ,ConstraintDate SMALLDATETIME NULL
	 ,IsTaskServicesOnly TINYINT NULL
	 ,UpdateFlag INT NULL -- General Purpose flag
	 ,ProjectOrder INT NULL
	 ,SummaryTaskID VARCHAR(30) NULL
     ,SummaryTaskName VARCHAR(500) NULL
     ,SummaryTask VARCHAR(531) NULL
     )  

    CREATE TABLE #tTime (UserKey INT NULL, DetailTaskKey INT NULL, ActualHours DECIMAL(24, 4) NULL)  

	IF @UserKey IS NULL 
	BEGIN
	-- Company mode
		IF @UnassignedOnly = 0
		BEGIN
			-- Not unassigned

			-- for now pull only keys or what is in the Where clause  + PercComp

			INSERT #tTask (TaskUserKey,TaskKey, ProjectKey ,PlanStart ,PlanComplete 
			  ,Hours ,UserKey, ServiceKey, CompanyKey 
			  ,PercComp ,PercCompSeparate, ActualHours
			  , ClientKey, ProjectStatusKey, ProjectBillingStatusKey )  
			SELECT tu.TaskUserKey, t.TaskKey,t.ProjectKey,t.PlanStart,t.PlanComplete
				   ,tu.Hours  ,tu.UserKey	,tu.ServiceKey
				   ,CASE
						WHEN tu.UserKey > 0 THEN u.CompanyKey
						WHEN tu.ServiceKey > 0 THEN s.CompanyKey
						ELSE NULL
					END
				   ,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 
					THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, 0) END AS PercComp
				   ,t.PercCompSeparate, 0
				   /*
				   , ISNULL(
					(SELECT SUM(ti.ActualHours) FROM tTime ti with (index=IX_tTime_6, NOLOCK) 
						WHERE ti.UserKey = tu.UserKey 
						AND ti.ProjectKey = t.ProjectKey 
						AND ti.DetailTaskKey = tu.TaskKey
						AND ti.WorkDate < @Today
						)
					,0)
					AS ActualHours
					*/
				    ,p.ClientKey, p.ProjectStatusKey ,p.ProjectBillingStatusKey 
					
			FROM  tProject p (NOLOCK) 
				INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
				INNER JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
				INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
				--LEFT OUTER JOIN tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
				LEFT OUTER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
				LEFT OUTER JOIN tService s (NOLOCK) ON tu.ServiceKey = s.ServiceKey AND tu.UserKey IS NULL
			WHERE p.CompanyKey = @CompanyKey
			AND p.ProjectKey <> @ProjectKey
			AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
			AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
			AND   t.PlanComplete >= @StartDate 
			AND	  t.PlanStart <= @EndDate
			AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
			--AND   (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)

			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @LoggedUserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

			AND   (@AllDepartments = 0 or ISNULL(u.DepartmentKey, 0) in (Select DepartmentKey from #departmentKeys) or  ISNULL(s.DepartmentKey, 0) in (Select DepartmentKey from #departmentKeys) )
			AND   (@AllProjectTypes = 0 or ISNULL(p.ProjectTypeKey, 0) in (Select ProjectTypeKey from #projectTypeKeys))
			AND   (
					(@ProjectStatusKey = -1 AND p.Active = 1 )
					OR
					(@ProjectStatusKey = -2 AND p.Active = 0 )
					OR
					(@AllProjectStatuses = 0 and @ProjectStatusKey = -3)
					OR
					(p.ProjectStatusKey in (Select ProjectStatusKey from #projectStatusKeys))
				  ) 
			AND	  (@ServiceKey IS NULL OR @ServiceKey IN (SELECT us.ServiceKey FROM tUserService us (NOLOCK)
						WHERE us.UserKey = u.UserKey) OR tu.ServiceKey = @ServiceKey)
			AND	  (@SkillKey IS NULL OR @SkillKey IN (SELECT us2.SkillKey FROM tUserSkill us2 (NOLOCK)
						WHERE us2.UserKey = u.UserKey))
			AND	   ISNULL(ps.OnHold, 0) = 0
			/*  Moved this logic to a delete after the insert. Speeds up query by 8x
				AND	(
					(ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) 
				or	(ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)
				) */
			AND ((tu.UserKey IS NOT NULL AND u.Active = 1)
				OR
				(tu.ServiceKey IS NOT NULL AND s.Active = 1))
			AND	(@ExcludeZeroHourTasks = 0 OR ISNULL(tu.Hours, 0) <> 0)
			AND	(PredecessorsComplete = @PredecessorsComplete OR PredecessorsComplete <> 0)
		
			Delete #tTask Where PercComp = 100

			-- now add what is missing from tProject
			UPDATE #tTask
			SET    #tTask.WorkSun = p.WorkSun,#tTask.WorkMon = p.WorkMon, #tTask.WorkTue = p.WorkTue
				  ,#tTask.WorkWed = p.WorkWed,#tTask.WorkThur = p.WorkThur,#tTask.WorkFri = p.WorkFri,#tTask.WorkSat= p.WorkSat
				  ,#tTask.ProjectFullName = p.ProjectNumber + '-' + p.ProjectName
				  ,#tTask.ProjectNumber = p.ProjectNumber
				  ,#tTask.ProjectName = p.ProjectName
				  ,#tTask.ProjectStartDate = p.StartDate
				  ,#tTask.ProjectCompleteDate = p.CompleteDate
				  ,#tTask.ProjectPercComp = p.PercComp
				  ,#tTask.ScheduleDirection = p.ScheduleDirection
				  ,#tTask.StatusNotes = p.StatusNotes
				  ,#tTask.DetailedNotes = p.DetailedNotes
				  ,#tTask.ClientNotes = p.ClientNotes
				  ,#tTask.ScheduleLockedByKey = p.ScheduleLockedByKey
			FROM   tProject p (nolock)
			WHERE  #tTask.ProjectKey = p.ProjectKey

			UPDATE #tTask
			SET    #tTask.Locked = ps.Locked
			      ,#tTask.ProjectStatus = ps.ProjectStatus
				  ,#tTask.ProjectStatusID = ps.ProjectStatusID  
			FROM  tProjectStatus ps (NOLOCK) 
			WHERE #tTask.ProjectStatusKey = ps.ProjectStatusKey

			UPDATE #tTask
			SET    #tTask.ProjectBillingStatus = pbs.ProjectBillingStatus
				  ,#tTask.ProjectBillingStatusID = pbs.ProjectBillingStatusID
			FROM  tProjectBillingStatus pbs (NOLOCK) 
			WHERE #tTask.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey

			-- now add what is missing from tTask
			UPDATE #tTask
			SET    #tTask.FormattedName = ISNULL(t.TaskID + '-', '') + t.TaskName
			       ,#tTask.TaskName = t.TaskName
				   ,#tTask.Description = t.Description
				   ,#tTask.ScheduleNote = t.ScheduleNote
				   ,#tTask.Comments = t.Comments
				   ,#tTask.BudgetTaskKey = t.BudgetTaskKey
				   ,#tTask.ProjectOrder = t.ProjectOrder
				   ,#tTask.PlanDuration = t.PlanDuration
				   ,#tTask.WorkAnyDay = t.WorkAnyDay
				   ,#tTask.Priority = t.Priority
				   ,#tTask.PriorityName = CASE -- Taken from ProjectConstants.as
						WHEN ISNULL(t.Priority, 0) = 3 THEN 'Low'
						WHEN ISNULL(t.Priority, 0) = 2 THEN 'Medium'
						WHEN ISNULL(t.Priority, 0) = 1 THEN 'High'
						ELSE 'Low'
					END
			FROM   tTask t (nolock)
			WHERE  #tTask.TaskKey = t.TaskKey

		END -- UnassignedMode = 0

		ELSE
		BEGIN
			-- UnassignedOnly = 1

			INSERT #tTask (TaskUserKey,TaskKey, FormattedName, TaskName, ProjectFullName,Description,ProjectKey ,PlanStart ,PlanComplete 
			 ,PlanDuration ,WorkAnyDay ,Hours ,UserKey ,CompanyKey 
			 ,WorkSun ,WorkMon ,WorkTue ,WorkWed ,WorkThur ,WorkFri ,WorkSat, PercComp ,ActualHours, Comments
			 ,Priority, PriorityName
			 ,ProjectNumber, ProjectName, ProjectStartDate, ProjectCompleteDate, ProjectPercComp, ProjectStatusKey, ScheduleDirection, StatusNotes
			 ,DetailedNotes, ClientNotes, ClientKey, ScheduleLockedByKey, Locked, ProjectStatus, ProjectStatusID 
			 ,ProjectBillingStatusKey, ProjectBillingStatus, ProjectBillingStatusID
			 ,SummaryTaskID ,SummaryTaskName ,SummaryTask  )  
			SELECT tu.TaskUserKey, t.TaskKey
				   ,NULL --,ISNULL(t.TaskID + '-', '') + t.TaskName As FormattedName 
				   ,t.TaskName
				   ,NULL --,p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName
				   ,NULL --,t.Description
				   ,t.ProjectKey
				   ,t.PlanStart
				   ,t.PlanComplete
				   ,t.PlanDuration
				   ,t.WorkAnyDay
				   ,NULL --tu.Hours  
				   ,NULL --tu.UserKey	
				   ,NULL --u.CompanyKey
				   ,NULL, NULL, NULL, NULL,NULL, NULL, NULL 	
				   --,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat
				   ,ISNULL(t.PercComp, 0) AS PercComp
				   ,0
				   /*
				   , ISNULL(
					(SELECT SUM(ti.ActualHours) FROM tTime ti with (index=IX_tTime_6, NOLOCK) 
						WHERE ti.UserKey = tu.UserKey 
						AND ti.ProjectKey = t.ProjectKey 
						AND ti.DetailTaskKey = tu.TaskKey
						AND ti.WorkDate < @Today
						)
					,0)
					AS ActualHours
					*/
				   ,NULL -- t.Comments
				   ,t.Priority
				   ,CASE -- Taken from ProjectConstants.as
						WHEN ISNULL(t.Priority, 0) = 3 THEN 'Low'
						WHEN ISNULL(t.Priority, 0) = 2 THEN 'Medium'
						WHEN ISNULL(t.Priority, 0) = 1 THEN 'High'
						ELSE 'Low'
					END AS PriorityName
					,p.ProjectNumber 
					,p.ProjectName 
					,p.StartDate
					,p.CompleteDate
					,p.PercComp
					,p.ProjectStatusKey 
					,p.ScheduleDirection
					,p.StatusNotes
					,p.DetailedNotes
					,p.ClientNotes
					,p.ClientKey
					,p.ScheduleLockedByKey
					,ps.Locked
					,ps.ProjectStatus
					,ps.ProjectStatusID
					,pbs.ProjectBillingStatusKey 
					,pbs.ProjectBillingStatus
					,pbs.ProjectBillingStatusID
					,NULL   -- SummaryTaskID
					,NULL   -- SummaryTaskName
					,NULL   -- SummaryTask
			FROM  tProject p (NOLOCK) 
				INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
				LEFT JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
				INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
				LEFT OUTER JOIN tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
			WHERE	p.CompanyKey = @CompanyKey
			AND		p.ProjectKey <> @ProjectKey
			AND		(@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
			AND		(@ClientKey IS NULL OR p.ClientKey = @ClientKey)
			--AND     (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)

			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @LoggedUserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

			AND   (@AllProjectTypes = 0 or ISNULL(p.ProjectTypeKey, 0) in (Select ProjectTypeKey from #projectTypeKeys))
			AND		t.PlanComplete >= @StartDate 
			AND		t.PlanStart <= @EndDate
			AND   (
					(@ProjectStatusKey = -1 AND p.Active = 1 )
					OR
					(@ProjectStatusKey = -2 AND p.Active = 0 )
					OR
					(@AllProjectStatuses = 0 and @ProjectStatusKey = -3)
					OR
					(p.ProjectStatusKey in (Select ProjectStatusKey from #projectStatusKeys))
				  ) 
			AND		t.TaskType = 2
			AND		ISNULL(ps.OnHold, 0) = 0
			AND		tu.TaskUserKey IS NULL
			AND		(@ExcludeZeroHourTasks = 0 OR ISNULL(tu.Hours, 0) <> 0)
			AND	    (PredecessorsComplete = @PredecessorsComplete OR PredecessorsComplete <> 0)

			Delete #tTask Where PercComp = 100

			UPDATE #tTask
			SET    #tTask.WorkSun = p.WorkSun,#tTask.WorkMon = p.WorkMon, #tTask.WorkTue = p.WorkTue
				  ,#tTask.WorkWed = p.WorkWed,#tTask.WorkThur = p.WorkThur,#tTask.WorkFri = p.WorkFri,#tTask.WorkSat= p.WorkSat
				  ,#tTask.ProjectFullName = p.ProjectNumber + '-' + p.ProjectName
			FROM   tProject p (nolock)
			WHERE  #tTask.ProjectKey = p.ProjectKey

			UPDATE #tTask
			SET    #tTask.FormattedName = ISNULL(t.TaskID + '-', '') + t.TaskName
					,#tTask.Description = t.Description
				   ,#tTask.ScheduleNote = t.ScheduleNote
				   ,#tTask.Comments = t.Comments
				   ,#tTask.PercCompSeparate = t.PercCompSeparate
				   ,#tTask.BudgetTaskKey = t.BudgetTaskKey
				   ,#tTask.ProjectOrder = t.ProjectOrder
			FROM   tTask t (nolock)
			WHERE  #tTask.TaskKey = t.TaskKey

		END -- Unassigned Mode

	END -- Company Mode
ELSE
	BEGIN

	-- single user mode

	INSERT #tTask (TaskUserKey,TaskKey, FormattedName, TaskName, ProjectFullName,Description,ProjectKey ,PlanStart ,PlanComplete 
     ,PlanDuration ,WorkAnyDay ,Hours ,UserKey ,CompanyKey 
     ,WorkSun ,WorkMon ,WorkTue ,WorkWed ,WorkThur ,WorkFri ,WorkSat ,PercComp ,ActualHours, ScheduleNote, Comments 
     ,Priority, PriorityName 
     ,ProjectNumber, ProjectName, ProjectStartDate, ProjectCompleteDate, ProjectPercComp, ProjectStatusKey, ScheduleDirection, StatusNotes
	 ,DetailedNotes, ClientNotes, ClientKey, ScheduleLockedByKey, Locked, ProjectStatus, ProjectStatusID 
	 ,ProjectBillingStatusKey, ProjectBillingStatus, ProjectBillingStatusID, BudgetTaskKey    
	 ,SummaryTaskID ,SummaryTaskName ,SummaryTask  )  
	SELECT tu.TaskUserKey, t.TaskKey
		   ,ISNULL(t.TaskID + '-', '') + t.TaskName As FormattedName 
		   ,t.TaskName
		   ,p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName
		   ,t.Description
		   ,t.ProjectKey
		   ,t.PlanStart
		   ,t.PlanComplete
		   ,t.PlanDuration
		   ,t.WorkAnyDay
		   ,tu.Hours  
		   ,tu.UserKey	
		   ,u.CompanyKey
		   ,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat
		   ,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 
			THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, 0) END AS PercComp
		   ,0
		   /*
		   , ISNULL(
			(SELECT SUM(ti.ActualHours) FROM tTime ti with (index=IX_tTime_6, NOLOCK) 
				WHERE ti.UserKey = @UserKey 
				AND ti.ProjectKey = t.ProjectKey 
				AND ti.DetailTaskKey = tu.TaskKey
				AND ti.WorkDate < @Today
				)
			,0)
			AS ActualHours
			*/
			,t.ScheduleNote
		   , t.Comments
		   ,t.Priority
		   ,CASE 
				WHEN ISNULL(t.Priority, 0) = 3 THEN 'Low'
				WHEN ISNULL(t.Priority, 0) = 2 THEN 'Medium'
				WHEN ISNULL(t.Priority, 0) = 1 THEN 'High'
				ELSE 'Low'
		    END AS PriorityName
		    ,p.ProjectNumber 
			,p.ProjectName 
			,p.StartDate
			,p.CompleteDate
			,p.PercComp
			,p.ProjectStatusKey 
			,p.ScheduleDirection
			,p.StatusNotes
			,p.DetailedNotes
			,p.ClientNotes
			,p.ClientKey
			,p.ScheduleLockedByKey
			,ps.Locked
			,ps.ProjectStatus
			,ps.ProjectStatusID
			,pbs.ProjectBillingStatusKey 
			,pbs.ProjectBillingStatus
			,pbs.ProjectBillingStatusID
			,t.BudgetTaskKey 
			,NULL   -- SummaryTaskID
			,NULL   -- SummaryTaskName
			,NULL   -- SummaryTask
	FROM  tProject p (NOLOCK) 
		INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
		INNER JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
		INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
		LEFT OUTER JOIN tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey		
	WHERE tu.UserKey = @UserKey
	AND p.ProjectKey <> @ProjectKey
	AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
	AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
	--AND   (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @LoggedUserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

    AND   (@AllProjectTypes = 0 or ISNULL(p.ProjectTypeKey, 0) in (Select ProjectTypeKey from #projectTypeKeys))
	AND   t.PlanComplete >= @StartDate 
	AND	  t.PlanStart <= @EndDate
	AND   (
					(@ProjectStatusKey = -1 AND p.Active = 1 )
					OR
					(@ProjectStatusKey = -2 AND p.Active = 0 )
					OR
					(@AllProjectStatuses = 0 and @ProjectStatusKey = -3)
					OR
					(p.ProjectStatusKey in (Select ProjectStatusKey from #projectStatusKeys))
				  ) 
	AND	   ISNULL(ps.OnHold, 0) = 0
	AND	(@ExcludeZeroHourTasks = 0 OR ISNULL(tu.Hours, 0) <> 0)
	AND	(PredecessorsComplete = @PredecessorsComplete OR PredecessorsComplete <> 0)
	/*  Moved this logic to a delete after the insert. Speeds up query by 8x
		AND	(
			(ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) 
		or	(ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)
		) */

	Delete #tTask Where PercComp = 100

	END

	if @AllTeams = 1
		Delete #tTask Where UserKey  not in (Select UserKey from tTeamUser (nolock) inner join #teamKeys on tTeamUser.TeamKey = #teamKeys.TeamKey)

	--if ISNULL(@TeamKey, 0) > 0
		--Delete #tTask Where UserKey in (Select UserKey from tTeamUser (nolock) Where TeamKey = @TeamKey)

	INSERT #tTime (UserKey, DetailTaskKey, ActualHours)  
	SELECT ti.UserKey, ISNULL(ti.DetailTaskKey, ti.TaskKey), SUM(ti.ActualHours)   
	FROM tTime ti (NOLOCK)  
		,#tTask ta     
	WHERE ti.UserKey = ta.UserKey
	AND   ti.ProjectKey = ta.ProjectKey  
	AND   ISNULL(ti.DetailTaskKey, ti.TaskKey) = ta.TaskKey
	AND   ti.WorkDate < @EndDate
	AND   ((ti.WorkDate < dbo.fFormatDateNoTime(GETDATE()) AND Verified = 1) OR Verified = 0)
    GROUP BY ti.UserKey, ISNULL(ti.DetailTaskKey, ti.TaskKey)

    --select * from #tTime

	UPDATE #tTask  
	SET    #tTask.ActualHours = ti.ActualHours 
	FROM   #tTime ti
	WHERE ti.UserKey = #tTask.UserKey
	AND ti.DetailTaskKey = #tTask.TaskKey

	UPDATE	#tTask
	SET		#tTask.TaskConstraint = t.TaskConstraint,
			#tTask.ConstraintDate = t.ConstraintDate,
			#tTask.ProjectOrder = t.ProjectOrder,
		    #tTask.PercCompSeparate = t.PercCompSeparate
	FROM	tTask t
	WHERE	t.TaskKey = #tTask.TaskKey

	-- flag the tasks with ANY (does not matter which one) user assigned
	UPDATE   #tTask
	SET      #tTask.UpdateFlag = 0

	UPDATE   #tTask
	SET      #tTask.UpdateFlag = 1
	FROM     tTaskUser tu (nolock)
	WHERE    #tTask.TaskKey = tu.TaskKey
	and      isnull(tu.UserKey, 0) > 0

    -- Update Summary Task fields
	UPDATE   #tTask
	SET      #tTask.SummaryTaskID = st.TaskID
	        ,#tTask.SummaryTaskName = st.TaskName
	        ,#tTask.SummaryTask = ISNULL(st.TaskID, '') + '-' + ISNULL(st.TaskName, '')
	FROM     tTask t (nolock) left outer join tTask st (NOLOCK) on t.SummaryTaskKey = st.TaskKey
	WHERE    t.TaskKey = #tTask.TaskKey

    -- if no user assigned, the task is a service only one
	UPDATE   #tTask
	SET      #tTask.IsTaskServicesOnly = 1
	WHERE    #tTask.UpdateFlag = 0

	SELECT 'tTask' AS Entity, * 
	FROM #tTask
	--ORDER BY PlanStart --this costs 26% of the total time in sp (does not seem to be used anywhere) 

	RETURN 1
GO
