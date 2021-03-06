USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficGetTasks]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficGetTasks]
	(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@ProjectStatusKey int = -1, -- -1:All Active, -2:All Inactive, -3:All, >0 valid project status
		@OfficeKey int = NULL,
		@DepartmentKey int = NULL,
		@ServiceKey int = NULL,
		@SkillKey int = NULL,
		@UserKey int = NULL,
		@TeamKey int = NULL,
		@ProjectKey int = 0,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL
	)
AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/13/08 GHL wmj	   Creation for the new traffic screens  
  || 05/20/08 GWG 10.0.0.1 Added with index to get subquery to pick up the index on tTime   
  || 05/29/08 GHL 10.0.0.1 Limiting now actual hours to yesterday's date because this is what
  ||                       we also do on the schedule task assignment screen
  ||                       Also added UserKey param so that we can use it in single user mode 
  ||                       Also joining thru tTime.DetailTaskKey instead of tTime.TaskKey   
  || 06/02/08 GHL 10.0.0.1 Added description for drill down    
  || 07/15/08 GHL 10.0.0.5 (29944) Added restriction on Active users 
  || 08/06/08 GHL 10.0.0.6 (31708) Converted to temp table because of performance issues 
  || 08/07/08 GHL 10.0.0.6 (31591) Added Active, Inactive, All project status
  || 08/22/08 GHL 10.0.0.7 (33133) Added Schedule Note for new status on traffic drill down 
  || 02/10/09 RTC 10.018  Removed query hint for better performance
  || 07/13/09 GWG 10.5.04  Changed left outer join to an inner join on project status and changed logic for new processing
  || 11/10/09 GWG 10.5.1.3 Modified the check for percent complete on the first get. Changed it from a where to a delete after the get. Now running 8x faster
  || 1/26/10  GWG 10.5.1.7 Modified the query so that it does an isnull(DetailTaskKey, TaskKey) to catch time charged direct to a detail task key and transfers.
  || 5/6/10   GHL 10.522   (80185) Removed tTask.Comments from initial load
  ||                               Removed bottom sort on PlanStart (26% of total query on 5100 rows)
  || 7/29/10  MAS 10.5.3.3 (85631) added filters SearchProjectKey and ClientKey  
  || 9/1/10   GWG 10.5.3.4 Modified the SearchProjectKey filter 
  || 10/28/10 GWG 10.5.3.7 Fixed where clause when searching for a specific project
  || 03/29/11 GHL 10.5.4.3 (107252) Added TaskUserKey since we use it now to reassign tasks to another user 
  || 10/15/11 GWG 10.5.4.9  Added a filter for Team
  || 01/11/12 RLB 10.5.5.1 (130803) fix for Team Filter
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
	
	CREATE TABLE #tTask (
	 TaskUserKey int null
     ,TaskKey INT NULL  
     ,FormattedName VARCHAR(535) NULL  
     ,ProjectFullName VARCHAR(155) NULL  
     ,Description VARCHAR(6000) NULL  
	 ,ProjectKey INT NULL
	 ,PlanStart SMALLDATETIME NULL  
     ,PlanComplete SMALLDATETIME NULL  
     ,PlanDuration INT NULL
     ,WorkAnyDay INT NULL
     ,Hours DECIMAL(24, 4) NULL  
     ,UserKey INT NULL  
     ,CompanyKey INT NULL
     ,WorkSun INT NULL
     ,WorkMon INT NULL
     ,WorkTue INT NULL
     ,WorkWed INT NULL
     ,WorkThur INT NULL
     ,WorkFri INT NULL
     ,WorkSat INT NULL
     ,PercComp INT NULL   
     ,ActualHours DECIMAL(24, 4) NULL  
     ,ScheduleNote VARCHAR(200) NULL
     ,Comments VARCHAR(6000) NULL
     )  
    
    CREATE TABLE #tTime (UserKey INT NULL, DetailTaskKey INT NULL, ActualHours DECIMAL(24, 4) NULL)  
 
	IF @UserKey IS NULL 
	BEGIN
	-- Company mode
	
	INSERT #tTask (TaskUserKey, TaskKey, FormattedName, ProjectFullName,Description,ProjectKey ,PlanStart ,PlanComplete 
     ,PlanDuration ,WorkAnyDay ,Hours ,UserKey ,CompanyKey 
     ,WorkSun ,WorkMon ,WorkTue ,WorkWed ,WorkThur ,WorkFri ,WorkSat ,PercComp ,ActualHours, Comments )  
	SELECT tu.TaskUserKey, t.TaskKey
		   ,NULL --,ISNULL(t.TaskID + '-', '') + t.TaskName As FormattedName 
		   ,NULL --,p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName
		   ,NULL --,t.Description
		   ,t.ProjectKey
		   ,t.PlanStart
		   ,t.PlanComplete
		   ,t.PlanDuration
		   ,t.WorkAnyDay
		   ,tu.Hours  
		   ,tu.UserKey	
		   ,u.CompanyKey
		   ,NULL, NULL, NULL, NULL,NULL, NULL, NULL 	
		   --,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat
		   ,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 
			THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, 0) END AS PercComp
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
	FROM  tProject p (NOLOCK) 
		INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
		INNER JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
		INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
	WHERE p.CompanyKey = @CompanyKey
    AND   p.ProjectKey <> @ProjectKey
	AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
	AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
	AND   t.PlanComplete >= @StartDate 
	AND	  t.PlanStart <= @EndDate
	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	AND   (@DepartmentKey IS NULL OR u.DepartmentKey = @DepartmentKey)
	AND   (
			(@ProjectStatusKey = -1 AND p.Active = 1 )
			 OR 
			(@ProjectStatusKey = -2 AND p.Active = 0 )
			OR
			 @ProjectStatusKey = -3
			OR
			 p.ProjectStatusKey = @ProjectStatusKey
		  )
	AND	  (@ServiceKey IS NULL OR @ServiceKey IN (SELECT us.ServiceKey FROM tUserService us (NOLOCK)
				WHERE us.UserKey = u.UserKey))
	AND	  (@SkillKey IS NULL OR @SkillKey IN (SELECT us2.SkillKey FROM tUserSkill us2 (NOLOCK)
				WHERE us2.UserKey = u.UserKey))
	AND	   ISNULL(ps.OnHold, 0) = 0
	/*  Moved this logic to a delete after the insert. Speeds up query by 8x
		AND	(
			(ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) 
		or	(ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)
		) */
	AND  u.Active = 1	
	
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
	FROM   tTask t (nolock)
	WHERE  #tTask.TaskKey = t.TaskKey


	END
	ELSE
	BEGIN
	
	-- single user mode
		
	INSERT #tTask (TaskUserKey, TaskKey, FormattedName, ProjectFullName,Description,ProjectKey ,PlanStart ,PlanComplete 
     ,PlanDuration ,WorkAnyDay ,Hours ,UserKey ,CompanyKey 
     ,WorkSun ,WorkMon ,WorkTue ,WorkWed ,WorkThur ,WorkFri ,WorkSat ,PercComp ,ActualHours, ScheduleNote, Comments )  
	SELECT tu.TaskUserKey, t.TaskKey
		   ,ISNULL(t.TaskID + '-', '') + t.TaskName As FormattedName 
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
	FROM  tProject p (NOLOCK) 
		INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
		INNER JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
		INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE tu.UserKey = @UserKey
    AND   p.ProjectKey <> @ProjectKey
	AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
	AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
	AND   t.PlanComplete >= @StartDate 
	AND	  t.PlanStart <= @EndDate
	AND   (
		(@ProjectStatusKey = -1 AND p.Active = 1 )
		 OR 
		(@ProjectStatusKey = -2 AND p.Active = 0 )
		OR
		 @ProjectStatusKey = -3
		OR
		 p.ProjectStatusKey = @ProjectStatusKey
	  )
	AND	   ISNULL(ps.OnHold, 0) = 0
	/*  Moved this logic to a delete after the insert. Speeds up query by 8x
		AND	(
			(ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) 
		or	(ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)
		) */
		
	Delete #tTask Where PercComp = 100
	
	END

	if ISNULL(@TeamKey, 0) > 0
		Delete #tTask Where UserKey not in (Select UserKey from tTeamUser (nolock) Where TeamKey = @TeamKey)

	INSERT #tTime (UserKey, DetailTaskKey, ActualHours)  
	SELECT ti.UserKey, ISNULL(ti.DetailTaskKey, ti.TaskKey), SUM(ti.ActualHours)
	FROM tTime ti (NOLOCK)  
		,#tTask ta     
	WHERE ti.UserKey = ta.UserKey
	AND   ti.ProjectKey = ta.ProjectKey  
	AND   ISNULL(ti.DetailTaskKey, ti.TaskKey) = ta.TaskKey
	AND   ti.WorkDate < @EndDate
    GROUP BY ti.UserKey, ISNULL(ti.DetailTaskKey, ti.TaskKey)
    
    --select * from #tTime

	UPDATE #tTask  
	SET    #tTask.ActualHours = ti.ActualHours 
	FROM   #tTime ti
	WHERE ti.UserKey = #tTask.UserKey
	AND ti.DetailTaskKey = #tTask.TaskKey  


	SELECT 'tTask' AS Entity, * 
	FROM #tTask
	--ORDER BY PlanStart --this costs 26% of the total time in sp (does not seem to be used anywhere) 
	
	RETURN 1
GO
