USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptTaskAssignmentSheet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptTaskAssignmentSheet]
	(
		 @ProjectKey int,
		 @TaskKey int
		
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 12/11/06 GHL 8.4   For a summary task, print assignments on tracking tasks immediately below it 
  || 12/13/06 CRG 8.4   Wrapped TaskID - TaskName with ISNULL to avoid blank TaskFullName on report. 
  || 12/15/06 RTC 8.4   Added DueBy column
  ||                    
  */
  
	SET NOCOUNT ON

-- Print at the task level
if isnull(@TaskKey,0) > 0 
	Select 
	p.CompanyKey,
	p.ProjectKey,
	p.ClientKey,
	p.Active,
	p.ProjectStatusKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + '-' + p.ProjectName as ProjectFullName,
	p.AccountManager,
	cl.CompanyName as ClientName,
	am.FirstName + ' ' + am.LastName as AccountManagerName,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	ISNULL(t.TaskID + '-' + t.TaskName, t.TaskName) as TaskFullName,
	t.PlanStart,
	t.PlanComplete,
	t.Priority,
	t.Description,
	t.Description as Title,
	t.PlanDuration,
	t.CustomFieldKey,
	t.DueBy,
	tu.UserKey,
	u.FirstName + ' ' + u.LastName as UserName
	
FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	LEFT OUTER JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
	LEFT OUTER JOIN tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on tu.UserKey = u.UserKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
WHERE	t.ProjectKey = @ProjectKey -- Take advantage of the index on ProjectKey no matter what
AND		t.TaskType = 2
AND		
		(	t.TaskKey = @TaskKey
				OR 
			t.SummaryTaskKey = @TaskKey
		)
	
else

	-- Print at the project level
	Select 
	p.CompanyKey,
	p.ProjectKey,
	p.ClientKey,
	p.Active,
	p.ProjectStatusKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + '-' + p.ProjectName as ProjectFullName,
	p.AccountManager,
	cl.CompanyName as ClientName,
	am.FirstName + ' ' + am.LastName as AccountManagerName,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	ISNULL(t.TaskID + '-' + t.TaskName, t.TaskName) as TaskFullName,
	t.PlanStart,
	t.PlanComplete,
	t.Priority,
	t.Description,
	t.Description as Title,
	t.PlanDuration,
	t.CustomFieldKey,
	t.DueBy,
	tu.UserKey,
	u.FirstName + ' ' + u.LastName as UserName
	
FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	LEFT OUTER JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
	LEFT OUTER JOIN tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on tu.UserKey = u.UserKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
WHERE t.ProjectKey = @ProjectKey
AND		t.TaskType = 2
	
	RETURN 1
GO
