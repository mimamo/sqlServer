USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTaskAssignmentNoUser]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel   What
  || 09/12/07 GHL 8.436 Added Schedule Task flag to hide unscheduled tasks on some reports
  || 04/18/12 GHL 10.555 Added GLCompanyKey for filtering in reports
  */


CREATE      View [dbo].[vTaskAssignmentNoUser]

as 

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
	p.OfficeKey,
	p.AccountManager,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	ISNULL(t.TaskID,'') + ' ' + t.TaskName as TaskFullName,
	t.TaskStatus,
	t.PlanStart,
	t.PlanComplete,
	t.PercComp,
	t.ActStart,
	t.ActComplete,
	t.Description,
	t.Priority,
	t.Comments,
	t.PredecessorsComplete,
	ISNULL(st.TaskID,'') + ' ' + st.TaskName as SummaryTaskName,
	t.Description as WorkDescription,
	t.ScheduleTask
FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	INNER JOIN tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	LEFT JOIN tTask st (NOLOCK) on t.SummaryTaskKey = st.TaskKey
GO
