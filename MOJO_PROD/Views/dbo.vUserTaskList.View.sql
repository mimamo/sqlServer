USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vUserTaskList]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vUserTaskList]

as

/*
|| When      Who Rel      What
|| 3/20/08   CRG 1.0.0.0  Added TaskUserKey
|| 3/27/08   CRG 1.0.0.0  Added Closed
|| 4/18/07   QMD 1.0.0.0  Added ActualHours
|| 6/13/08   CRG 10.0.0.2 Added DetailTaskName, DetailTaskKey, BudgetTaskID for the My Tasks widget to send to the TimeEntryWidget
*/

Select 
	tu.TaskUserKey,
	p.ProjectKey,
	t.TaskKey,
	tu.UserKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + '-' + p.ProjectName as ProjectFullName,
	ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '') AS TaskIDName,
	ps.ProjectStatus,
	ps.OnHold,
	ps.IsActive,
	ps.TimeActive,
	c.CustomerID as ClientID,
	c.CompanyName as ClientName,
	c.CustomerID + '-' + c.CompanyName as ClientFullName,
	t.TaskName,
	t.TaskName AS DetailTaskName, --Used by TimeEntryWidget
	t.TaskKey AS DetailTaskKey, --Used by TimeEntryWidget
	bt.TaskID as BudgetTaskID, --Used by TimeEntryWidget
	t.Description as TaskDescription,
	t.PlanStart,
	t.PlanComplete,
	t.ScheduleNote,
	t.Comments,
	t.DueBy, 
	t.TaskStatus,
	t.TaskType,
	t.ScheduleTask,
	t.Priority,
	u.FirstName + ' ' + u.LastName as PrimaryContact,
	u.Phone1,
	u.Email,
	c.Phone,
	tu.PercComp,
	tu.ActStart,
	tu.ActComplete,
	tu.Hours as AssignedHours,
	ISNULL(tu.ServiceKey, us.DefaultServiceKey) as ServiceKey,
	t.PredecessorsComplete,
	CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END AS AssignedPercComp,
	p.Closed,
	(SELECT SUM(ActualHours) FROM tTime WITH (INDEX=IX_tTime_1, NOLOCK) WHERE (DetailTaskKey = t.TaskKey OR TaskKey = t.TaskKey) AND UserKey = tu.UserKey) AS ActualHours
from tTask t (nolock)
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	inner join tUser us (nolock) on tu.UserKey = us.UserKey
	LEFT OUTER JOIN tCompany c (nolock) on c.CompanyKey = p.ClientKey
	LEFT OUTER JOIN tUser u (nolock) ON p.BillingContact = u.UserKey
	left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
Where
	ISNULL(ps.OnHold, 0) = 0 and
	(ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100) or (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)
GO
