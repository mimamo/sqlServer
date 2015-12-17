USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vMobile_MyTasks]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMobile_MyTasks]
AS

/*
  || When     Who Rel     What
*/

Select
	 p.CompanyKey
	,tu.TaskUserKey
	,tu.UserKey
	,p.ProjectNumber + ' - ' + p.ProjectName  as [Project Full Name]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID as [Client ID]
	,ps.ProjectStatus as [Project Status]
	,isnull(pt.ProjectTypeName, '') as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,cp.CampaignName as [Campaign Name]
	,o.OfficeName as [Office]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,t.TaskID + ' - ' + t.TaskName as [Task Full Name]
	,st.TaskName as [Summary Task Name]
	,t.Description as [Task Description]
	,t.PlanStart as [Task Plan Start Date]
	,t.PlanComplete as [Task Plan Completion Date]
	,t.ActStart as [Task Actual Start Date]
	,t.ActComplete as [Task Actual Completion Date]
	,t.PercComp as [Task Percentage Complete]
	,t.BaseStart as [Task Original Start Date]
	,t.BaseComplete as [Task Original Completion Date]
	,t.EstHours + t.ApprovedCOHours as [Original Budget Hours]
	,t.EstLabor + t.ApprovedCOLabor as [Original Budget Labor]
	,t.BudgetExpenses as [Original Budget Net Expense]
	,t.EstExpenses + t.ApprovedCOExpense as [Original Budget Gross Expense]
	,t.DueBy as [Due By Comment]
	,CAST(t.Description as varchar (4000)) as [Description of Work]
	,tu.ActStart as [Actual Start Date]
	,tu.ActComplete as [Actual Completion Date]
	,tu.PercComp as [Percentage Complete]
	,Case t.Priority When 1 then '1 - High' When 2 then '2 - Med' When 3 Then '3 - Low' end as [Priority]
	,Case t.PredecessorsComplete When 1 then 'YES' else 'NO' end as [Predecessors Completed]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active Project]
	,ISNULL(taun.UserName, ISNULL(tas.Description, '')) as [Assigned Staff]
	,tas.Description as [Assigned Role]
	,tu.Hours as [Allocated Hours]
	,(Select Count(*) from tActivity (nolock) Where TaskKey = t.TaskKey and Completed = 0 and ActivityEntity = 'ToDo') as [Open To Do Items]
	,(Select Sum(ActualHours) from tTime (nolock) Where tTime.UserKey = tu.UserKey and ISNULL(tTime.DetailTaskKey, tTime.TaskKey) = t.TaskKey) as [Actual Hours]
	,DATEDIFF(d, GETDATE(), t.PlanComplete) as [Days To Complete]
From
	tProject p (nolock)
	inner join tTask t with  (nolock, index=tTask51) on p.ProjectKey = t.ProjectKey
	left outer join tTask st with  (nolock, index=tTask51) on t.SummaryTaskKey = st.TaskKey
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	left outer join vUserName taun (nolock) on tu.UserKey = taun.UserKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tService tas (nolock) on tu.ServiceKey = tas.ServiceKey
Where
	p.Active = 1 And ISNULL(ps.OnHold, 0) = 0
GO
