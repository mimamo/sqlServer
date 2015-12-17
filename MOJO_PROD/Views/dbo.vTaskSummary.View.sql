USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTaskSummary]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTaskSummary]

as 


/*
|| When     Who Rel     What
|| 12/14/07 GHL 8.5     Added t.ProjectKey to subquery with tTime to be able to use an index
|| 04/18/12 GHL 10.555  Added p.GLCompanyKey for filtering in reports
|| 07/17/13 RLB 10.570 (183944) Added for report changes
*/

Select 
	p.CompanyKey,
	p.GLCompanyKey,
	p.ClientKey,
	p.Active,
	p.ProjectStatusKey,
	u1.FirstName + ' ' + u1.LastName as AccountManagerName,
	p.AccountManager,
	isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber,'') AS ClientProjectNumber,
	isnull(c.CustomerID+' \ ','') + ISNULL(p.ProjectNumber+' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject,
	p.ProjectNumber,
	p.ProjectName,
	p.OfficeKey,
	o.OfficeName,
	p.WorkMon,
	p.WorkTue,
	p.WorkWed,
	p.WorkThur,
	p.WorkFri,
	p.WorkSat,
	p.WorkSun,
	p.StartDate as ProjectStartDate,
	p.CompleteDate as ProjectCompleteDate,
	p.StatusNotes,
	p.DetailedNotes,
	p.Duration as ProjectDuration,
	p.PercComp as ProjectPercComp,
	ps.ProjectStatus,
	t.ProjectKey,
	t.TaskKey,
	t.TaskID,
             t.TaskName,
             ISNULL(t.TaskID +  ' ','') + t.TaskName AS TaskFullName,
	t.PlanStart,
	t.PlanComplete,
	t.PlanDuration,
	t.DisplayOrder,
	t.TaskType,
	ISNULL(t.SummaryTaskKey, 0) as SummaryTaskKey,
	Case TaskType When 1 then 0 else 1 end as TaskCount,
	ISNULL(t.PercComp, 0) as PercComp,
	t.ScheduleNote,
	t.Comments,
	t.ActStart,
	t.ActComplete,
	t.ScheduleTask,
	t.MoneyTask,
             t.TrackBudget,
	t.TaskStatus,
	t.AssignedNames,
	ISNULL(t.ProjectOrder, 0) as ProjectOrder,
	ISNULL(t.TaskLevel, 0) as TaskLevel,
	c.CompanyName,
	c.CustomerID,
	ISNULL(t.EstHours + t.ApprovedCOHours, 0) as EstHours,
	ISNULL((Select SUM(ActualHours) from tTime ti (nolock) Where t.ProjectKey = ti.ProjectKey and  t.TaskKey = ti.TaskKey), 0) as ActHours

FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock)
	INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey 
	 ON t.ProjectKey = p.ProjectKey 
	LEFT OUTER JOIN tUser u1 (nolock) ON p.AccountManager = u1.UserKey 
	LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
GO
