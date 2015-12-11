USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTaskAssignment]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vTaskAssignment]

as 

  /*
  || When     Who Rel   What
  || 07/02/08 GHL 8.515 (29599) Corrected PercCompUser to take in account tTask.PercCompSeparate. 
  || 04/18/12 GHL 10.555 Added GLCompanyKey for filtering in reports
  */

Select 
	p.CompanyKey,
	p.GLCompanyKey,
	p.ProjectKey,
	p.ClientKey,
	p.Active,
	p.ProjectStatusKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
	p.AccountManager,
	am.FirstName + ' ' + am.LastName as AccountManagerName,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	ISNULL(t.TaskID + ' ' + t.TaskName, t.TaskName) as TaskFullName,
	t.TaskStatus,
	t.PlanStart As TaskPlanStart,
	t.PlanComplete As TaskPlanComplete,
	t.ProjectOrder,
	t.PlanStart,
	t.PlanComplete,
	t.PercComp,
	t.ActStart,
	t.ActComplete,
	t.Description,
	t.Priority,
	t.Comments,
	t.PredecessorsComplete,
	t.DueBy,
	t.CustomFieldKey,
	tu.UserKey,
	u.FirstName + ' ' + u.LastName as UserName,
	u.FirstName,
	u.MiddleName,
	u.LastName,
	u.DepartmentKey,
	tu.ActStart as ActStartUser,
	tu.ActComplete as ActCompleteUser,
	CASE 
		WHEN t.PercCompSeparate = 0 
		THEN  t.PercComp
		ELSE   tu.PercComp 
	END AS PercCompUser, 
	ISNULL(st.TaskID,'') + ' ' + st.TaskName as SummaryTaskName,
	t.Description as WorkDescription
	
FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	INNER JOIN tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	INNER JOIN tUser u (nolock) on tu.UserKey = u.UserKey
	INNER JOIN tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
	LEFT JOIN tTask st (NOLOCK) on t.SummaryTaskKey = st.TaskKey
GO
