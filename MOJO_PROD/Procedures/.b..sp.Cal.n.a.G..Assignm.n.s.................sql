USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAssignments]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetAssignments]
	(
		@UserKey int,
		@CompanyKey int, 
		@ProjectKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@TaskFlag int,	-- 1 My , 2 All 
		@RestrictShowOnCalendar tinyint
	)
AS --Encrypt

	/*
        || When    Who Rel   What
        || 4/18/07 QMD 8.4.2 Added in project color to select statements
		|| 02/26/08 GHL 8.504 Fix for SQL 2005
	*/

if @ProjectKey > 0
BEGIN
	if @TaskFlag = 1
		
	SELECT	
			tTask.*,
			tTaskUser.UserKey,
			tTask.TaskName as Title,
			tTask.Description as WorkDescription,
			tTask.HideFromClient AS TaskHideFromClient, -- Differ from tTaskAssignment.HideFromClient
			tProject.ProjectNumber,
			tProject.ProjectName,
			1 as Assigned,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID,
			tProject.ProjectColor			
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) ON tProject.ClientKey = cli.CompanyKey
			inner join tTaskUser (NOLOCK) on tTask.TaskKey = tTaskUser.TaskKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTaskUser.UserKey = @UserKey
	AND		tTask.ProjectKey = @ProjectKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.CompanyKey = @CompanyKey
	AND		(@RestrictShowOnCalendar = 0 OR tTask.ShowOnCalendar = 0)
	ORDER BY tTask.PlanStart
	
	if @TaskFlag = 2
	SELECT
			tTask.*,
			tTask.TaskName as Title,
			tTask.Description as WorkDescription,
			tTask.HideFromClient  AS TaskHideFromClient,
			tProject.ProjectNumber,
			tProject.ProjectName,
			CASE 
				WHEN tTaskUser.UserKey IS NULL THEN 0
				ELSE 1
			END AS Assigned,
			tTaskUser.UserKey,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID,
			tProject.ProjectColor			
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) ON tProject.ClientKey = cli.CompanyKey
			inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
			left outer join tTaskUser (nolock) on tTask.TaskKey = tTaskUser.TaskKey and tTaskUser.UserKey = @UserKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTask.ProjectKey = @ProjectKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tAssignment.UserKey = @UserKey
	AND		tProject.CompanyKey = @CompanyKey
	AND		(@RestrictShowOnCalendar = 0 OR ISNULL(tTask.ShowOnCalendar,0) = 0 OR tTaskUser.UserKey <> @UserKey)
	ORDER BY tTask.PlanStart
END
ELSE
BEGIN

	if @TaskFlag = 1
		
	SELECT	
			tTask.*,
			tTaskUser.UserKey,
			tTask.TaskName as Title,
			tTask.Description as WorkDescription,
			tTask.HideFromClient  AS TaskHideFromClient,
			tProject.ProjectNumber,
			tProject.ProjectName,
			1 as Assigned,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID,
			tProject.ProjectColor						
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) ON tProject.ClientKey = cli.CompanyKey
			inner join tTaskUser (NOLOCK) on tTask.TaskKey = tTaskUser.TaskKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTaskUser.UserKey = @UserKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.Active = 1
	AND		tProject.CompanyKey = @CompanyKey
	AND		(@RestrictShowOnCalendar = 0 OR tTask.ShowOnCalendar = 0)
	ORDER BY tTask.PlanStart
	
	if @TaskFlag = 2
	SELECT
			tTask.*,
			tTask.TaskName as Title,
			tTask.Description as WorkDescription,
			tTask.HideFromClient  AS TaskHideFromClient,
			tProject.ProjectNumber,
			tProject.ProjectName,
			CASE 
				WHEN tTaskUser.UserKey IS NULL THEN 0
				ELSE 1
			END AS Assigned,
			tTaskUser.UserKey,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID,
			tProject.ProjectColor			
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) ON tProject.ClientKey = cli.CompanyKey
			inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
			left outer join tTaskUser (nolock) on tTask.TaskKey = tTaskUser.TaskKey and tTaskUser.UserKey = @UserKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.Active = 1
	AND		tAssignment.UserKey = @UserKey
	AND		tProject.CompanyKey = @CompanyKey
	AND		(@RestrictShowOnCalendar = 0 OR ISNULL(tTask.ShowOnCalendar,0) = 0 OR tTaskUser.UserKey <> @UserKey)
	ORDER BY tTask.PlanStart


END
	
	/* set nocount on */
	return 1
GO
