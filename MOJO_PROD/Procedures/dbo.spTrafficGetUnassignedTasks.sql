USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficGetUnassignedTasks]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficGetUnassignedTasks]
	(
	@CompanyKey int,
	@StartDate datetime,
	@EndDate datetime,
	@ExcludeProjectKey int, -- Null, do not exclude anything
	@FilterProjectKey int	-- Null, do not filter anything
	)

AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel       What
  || 06/03/08 GHL 8.512 Creation for new traffic reassing screen       
  */

	
	SELECT TOP 3000 'tTask' AS Entity
		   ,t.TaskKey
		   ,ISNULL(t.TaskID + '-', '') + t.TaskName As FormattedName 
		   ,p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName
		   ,t.Description
		   ,t.ProjectKey
		   ,t.PlanStart
		   ,t.PlanComplete
		   ,t.PlanDuration
		   ,t.WorkAnyDay
		   ,0 AS Hours  
		   ,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat
		   ,ISNULL(t.PercComp, 0) AS PercComp
		   , 0 AS ActualHours
	FROM   tProject p (NOLOCK) 
		INNER JOIN tTask t (NOLOCK) ON t.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE p.CompanyKey = @CompanyKey
	AND   (@ExcludeProjectKey IS NULL OR p.ProjectKey <> @ExcludeProjectKey)
	AND   (@FilterProjectKey IS NULL OR p.ProjectKey = @FilterProjectKey)
	AND	  ISNULL(ps.OnHold, 0) = 0
	AND   p.Closed = 0
	AND   p.Active = 1
	AND   ISNULL(p.Template, 0) = 0
	AND   t.TaskType = 2 -- Tracking
	AND   t.ScheduleTask = 1 -- Can be scheduled
	AND   t.PlanComplete >= @StartDate 
	AND	  t.PlanStart <= @EndDate
	AND	  ISNULL(t.PercComp, 0) < 100
	AND   NOT EXISTS (SELECT 1 FROM tTaskUser tu (NOLOCK) WHERE t.TaskKey = tu.TaskKey)
	ORDER BY t.PlanStart
	
	
	RETURN 1
GO
