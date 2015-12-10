USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetShowOnCalendar]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetShowOnCalendar]
	@UserKey int,
	@CompanyKey int,
	@ProjectKey int,
	@StartDate datetime,
	@EndDate datetime
AS	--Encrypt

  /*
  || When     Who Rel   What
  || 11/08/07 GHL 8.440 Added missing NOLOCK 
  ||                    
  */
	IF @ProjectKey > 0
		SELECT	t.*,
				p.ProjectNumber,
				p.ProjectName,
				cli.CompanyName As ClientName,
				cli.CustomerID As CustomerID	
		FROM	tTask t	(NOLOCK)				
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany cli (NOLOCK) ON p.ClientKey = cli.CompanyKey
		INNER JOIN tTaskUser tu (NOLOCK) on t.TaskKey = tu.TaskKey
		WHERE	t.PlanComplete >= @StartDate
		AND     t.PlanStart <= @EndDate 
		AND		p.ProjectKey = @ProjectKey
		AND		tu.UserKey = @UserKey
		AND		t.ScheduleTask = 1
		AND		t.TaskType = 2
		AND		p.Active = 1
		AND		p.CompanyKey = @CompanyKey
		AND		t.ShowOnCalendar = 1
		ORDER BY EventStart
	ELSE	
		SELECT	t.*,
				p.ProjectNumber,
				p.ProjectName,
				cli.CompanyName As ClientName,
				cli.CustomerID As CustomerID	
		FROM	tTask t	(NOLOCK)				
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany cli (NOLOCK) ON p.ClientKey = cli.CompanyKey
		INNER JOIN tTaskUser tu (NOLOCK) on t.TaskKey = tu.TaskKey
		WHERE	t.PlanComplete >= @StartDate
		AND     t.PlanStart <= @EndDate 
		AND		tu.UserKey = @UserKey
		AND		t.ScheduleTask = 1
		AND		t.TaskType = 2
		AND		p.Active = 1
		AND		p.CompanyKey = @CompanyKey
		AND		t.ShowOnCalendar = 1
		ORDER BY EventStart
GO
