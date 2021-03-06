USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetProjects]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetProjects]
	(
	@UserKey 	int,		
	@CompanyKey 	int, 		
	@ProjectKey 	int,		--NULL: All projects, -1: All projects, > 0 valid project
	@StartDate 	smalldatetime,	
	@EndDate 	smalldatetime,	
	@ProjectFlag 	int		-- 1: Display projects with tasks assigned to the user
					-- 2: Display projects assigned to the user 
	)
AS --Encrypt

	/*
  	|| When     Who Rel   What
	|| 04/18/07 QMD	8.4.2 Initial Release
	|| 04/26/07 GWG 8.4.2 Fix for No date range restriction
	|| 05/14/07 QMD 8.4.2.2 Customer wants to be able to view projects without any tasks.
	|| 05/17/07 QMD 8.4.2.2 Added INDEX Hint to increase performance. SQL Optimizer not picking the correct index.
	||			Also change the LEFT join in the first if clause to INNER join for performance.
    || 11/27/07 GHL 8.5   Added WITH for compliance with SQL Server 2005  			
	*/

	IF @ProjectFlag = 1	-- Display only my projects for the given project key
	BEGIN
		SELECT	p.ProjectKey,
			p.ProjectNumber, 
			p.ProjectName, 
			p.StartDate, 
			p.CompleteDate as DueDate, 
			min(t2.PlanStart) as PlanStartDate, 
			max(t2.PlanComplete) as PlanEndDate, 
			p.ProjectColor,
			c.CustomerID,
			c.CompanyName as ClientName,
			ps.ProjectStatus
		FROM	tProject p (NOLOCK) INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
					    INNER JOIN tTaskUser ta (NOLOCK) ON t.TaskKey = ta.TaskKey 
					    LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
					    INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
					    INNER JOIN tTask t2 (NOLOCK) ON p.ProjectKey = t2.ProjectKey
		WHERE 	t.TaskType = 2
			AND t.ScheduleTask = 1
			AND p.CompanyKey = @CompanyKey
			AND p.Active = 1
			AND ta.UserKey = @UserKey
			AND (@ProjectKey = -1 OR p.ProjectKey = @ProjectKey)
		GROUP BY p.ProjectKey, p.ProjectNumber,  p.ProjectName, p.StartDate, p.CompleteDate, p.ProjectColor,
			 c.CustomerID, c.CompanyName, ps.ProjectStatus
		HAVING (MAX(t2.PlanComplete) > @StartDate AND MIN(t2.PlanStart) < @EndDate) or (p.CompleteDate > @StartDate AND p.StartDate < @EndDate)
	END
	
	IF @ProjectFlag = 2	-- Display all projects
	BEGIN						
		SELECT	p.ProjectKey,
			p.ProjectNumber, 
			p.ProjectName, 
			p.StartDate, 
			p.CompleteDate as DueDate, 
			min(t.PlanStart) as PlanStartDate, 
			max(t.PlanComplete) as PlanEndDate, 
			p.ProjectColor,
			c.CustomerID,
			c.CompanyName as ClientName,
			ps.ProjectStatus
		FROM	tProject p (NOLOCK) LEFT OUTER JOIN tTask t WITH (NOLOCK, INDEX(tTask51)) ON p.ProjectKey =  t.ProjectKey
					    INNER JOIN tAssignment ta (NOLOCK) ON p.ProjectKey = ta.ProjectKey					    
					    INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
					    LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
		WHERE 	ta.UserKey = @UserKey
			AND p.CompanyKey = @CompanyKey
			AND p.Active = 1
			AND (@ProjectKey = -1 OR p.ProjectKey = @ProjectKey)
		GROUP BY p.ProjectKey, p.ProjectNumber,  p.ProjectName, p.StartDate, p.CompleteDate, p.ProjectColor,
			 c.CustomerID, c.CompanyName, ps.ProjectStatus
		HAVING (MAX(t.PlanComplete) > @StartDate AND MIN(t.PlanStart) < @EndDate) or (p.CompleteDate > @StartDate AND p.StartDate < @EndDate)

	END
	
	/* set nocount on */
	RETURN 1
GO
