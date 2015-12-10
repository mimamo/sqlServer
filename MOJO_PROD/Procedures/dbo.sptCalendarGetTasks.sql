USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetTasks]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetTasks]
	(
		@UserKey int,
		@CompanyKey int, 
		@ProjectKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@TaskFlag int	-- 1 My , 2 All 
	)
AS --Encrypt

if @ProjectKey > 0
BEGIN
	if @TaskFlag = 1
		
	SELECT	tTask.*,
		tProject.ProjectNumber,
		tProject.ProjectName,
		LEFT(tProject.ProjectName, 25) AS ProjectShortName,
		cli.CompanyName As ClientName,
		cli.CustomerID As CustomerID
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) on tProject.ClientKey = cli.CompanyKey
			inner join tTaskUser (NOLOCK) on tTask.TaskKey = tTaskUser.TaskKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTaskUser.UserKey = @UserKey
	AND		tTask.ProjectKey = @ProjectKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.CompanyKey = @CompanyKey
	ORDER BY tTask.PlanStart
	
	if @TaskFlag = 2
	SELECT	tTask.*,
			tProject.ProjectNumber,
			tProject.ProjectName,
			LEFT(tProject.ProjectName, 25) AS ProjectShortName,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) on tProject.ClientKey = cli.CompanyKey			
			inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTask.ProjectKey = @ProjectKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tAssignment.UserKey = @UserKey
	AND		tProject.CompanyKey = @CompanyKey
	ORDER BY tTask.PlanStart
END
ELSE
BEGIN

	if @TaskFlag = 1
		
	SELECT	tTask.*,
			tProject.ProjectNumber,
			tProject.ProjectName,
			LEFT(tProject.ProjectName, 25) AS ProjectShortName,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID			
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) on tProject.ClientKey = cli.CompanyKey
			inner join tTaskUser (NOLOCK) on tTask.TaskKey = tTaskUser.TaskKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTaskUser.UserKey = @UserKey
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.Active = 1
	AND		tProject.CompanyKey = @CompanyKey
	ORDER BY tTask.PlanStart
	
	if @TaskFlag = 2
	SELECT	tTask.*,
			tProject.ProjectNumber,
			tProject.ProjectName,
			LEFT(tProject.ProjectName, 25) AS ProjectShortName,
			cli.CompanyName As ClientName,
			cli.CustomerID As CustomerID			
	FROM    tTask (NOLOCK) 
			inner join tProject (NOLOCK) on tTask.ProjectKey = tProject.ProjectKey
			left outer join tCompany cli (NOLOCK) on tProject.ClientKey = cli.CompanyKey			
			inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
	WHERE   tTask.PlanComplete >= @StartDate
	AND     tTask.PlanStart <= @EndDate 
	AND		tTask.ScheduleTask = 1
	AND		tTask.TaskType = 2
	AND		tProject.Active = 1
	AND		tAssignment.UserKey = @UserKey
	AND		tProject.CompanyKey = @CompanyKey
	ORDER BY tTask.PlanStart


END
	
	/* set nocount on */
	return 1
GO
