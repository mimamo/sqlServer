USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_TaskAssignment]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_TaskAssignment]
AS

/*
|| When     Who Rel   What
|| 01/25/07 GHL 8.402 Added Timestamp related columns 
|| 04/05/07 GWG 8.5   Added predecessors completed field
|| 05/07/07 CRG 8.4.3 (8947) Added KeyPeople 1-6
|| 10/11/07 CRG 8.5   Added Class and GLCompany
|| 11/06/07 CRG 8.5   (13010) Added Row
|| 11/06/07 CRG 8.5   (12657) Added Task Priority
|| 01/29/08 GHL 8.503 (19631) Added hint with ProjectKey (tTask51 index)  to join with tTask. 
||                                    For some reason was doing a table scan
|| 04/13/09 RLB 10.0.2.3 (50834) Added where t.Tasktype=2 to just pull detail tasks.
|| 03/15/10 RLB 10.5.2.0 (76460) Add User Department
|| 10/26/10 RLB 10.5.3.7 (65197) Added Billing Contact
|| 02/11/11 RLB 10.5.4.1 (103245) Added Role to report
|| 04/07/11 RLB 10.543 (108045) Removed Project Short Name
|| 07/27/11 RLB 10.546  (111324) Added Campaign Segment
|| 11/16/11 RLB 10.550  (126449) Added Client ID
|| 02/29/12 MFT 10.553 (124662) Added Summary Task ID & Name
|| 04/24/12 GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 5/15/13  GWG 10.5.6.7 Added Exclude from Status
|| 08/07/13 WDF 10.571  (185818) Changed [Role] to [Service]
|| 11/15/13 RLB 10.5.7.4 (191407) Added Yes OR No for tax 1 and tax 2 on summary and detail tasks
|| 10/28/14 WDF 10.5.8.5 (226655) Added Users Default GLCompany ID/Name
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
|| 02/10/15 GWG 10.5.8.9  Added allocated hours
*/

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.CustomFieldKey
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID as [Client ID]
	,p.ClientProjectNumber [Client Project Number]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,cp.CampaignName as [Campaign Name]
	,cs.SegmentName as [Campaign Segment]
	,o.OfficeName as [Office]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,t.Description as [Task Description]
	,tat.TaskAssignmentType as [Task Type]
	,Case ISNULL(t.Taxable, 0) When 1 then 'YES' else 'NO' end as [Task Taxable]
	,Case ISNULL(t.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Task Taxable 2]
	,t.PlanStart as [Plan Start Date]
	,t.PlanComplete as [Plan Completion Date]
	,t.ActStart as [Actual Start Date]
	,t.ActComplete as [Actual Completion Date]
	,t.PercComp as [Percentage Complete]
	,t.BaseStart as [Baseline Start Date]
	,t.BaseComplete as [Baseline Completion Date]
	,Case t.MoneyTask When 1 then 'YES' else 'NO' end as [Track Budgets]
	,Case t.ScheduleTask When 1 then 'YES' else 'NO' end as [Track Schedules]
	,t.EstHours as [Original Budget Hours]
	,t.EstLabor as [Original Budget Labor]
	,t.BudgetExpenses as [Original Budget Net Expense]
	,t.EstExpenses as [Original Budget Gross Expense]
	,t.ApprovedCOHours as [Approved Change Order Hours]
	,t.ApprovedCOLabor as [Approved Change Order Labor]
	,t.ApprovedCOExpense as [Approved Change Order Gross Expense]
	,Case t.PredecessorsComplete When 1 then 'YES' else 'NO' end as [Predecessors Completed]
	,Case t.ExcludeFromStatus When 1 then 'YES' else 'NO' end as [Exclude From Status]
	,ISNULL((Select Sum(ActualHours * ActualRate) from tTime (nolock) Where tTime.TaskKey = t.TaskKey), 0) as [Actual Task Labor Total]
	,ISNULL((Select Sum(ActualHours) from tTime (nolock) Where tTime.TaskKey = t.TaskKey), 0) as [Actual Task Labor Hours]
	,u.FirstName + ' ' + u.LastName [Assigned User]
	,glc.GLCompanyID AS [Default GLCompany ID]
	,glc.GLCompanyID + ' - ' + glc.GLCompanyName AS [Default GLCompany Full Name]
	,d.DepartmentName as [User Department]
	,t.TaskName as [Assignment Subject]
	,t.DueBy as [Due By]
	,CAST(t.Description as varchar(4000)) as [Description of Work]
	,tu.ActStart as [Assignment Actual Start Date]
	,tu.ActComplete as [Assignment Actual Completion Date]
	,t.PlanStart as [Assignment Plan Start Date]
	,t.PlanComplete as [Assignment Plan Completion Date]
	,t.PlanDuration as [Assignment Duration]
	,t.DisplayOrder as [Assignment Work Order]
	,tu.PercComp as [Assignment Percentage Complete]
	,se.Description as [Role]
	,se.Description as [Service]
	,t.Comments as [Assignment Comments]
	,u2.FirstName + ' ' + u2.LastName as [Account Manager]
	,tu.CompletedByDate as [Time Completed]
	,tu.Hours as [Allocated Hours]
	,tsu.FirstName + ' ' + tsu.LastName as [Time Completed By]
	,bc.FirstName + ' ' + bc.LastName as [Billing Contact]
	,u3.UserName as [Key People 1]
	,u4.UserName as [Key People 2]
	,u5.UserName as [Key People 3]
	,u6.UserName as [Key People 4]
	,u7.UserName as [Key People 5]
	,u8.UserName as [Key People 6]
	,glcp.GLCompanyID as [Company ID]
	,glcp.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,t.ProjectOrder as Row
	,CASE t.ScheduleTask
		WHEN 1 THEN t.PlanDuration
		ELSE NULL
	END AS [Task Days]
	,CASE t.Priority
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END AS [Task Priority]
	,st.TaskID as [Summary Task ID]
	,st.TaskName as [Summary Task Name]
	,Case ISNULL(st.Taxable, 0) When 1 then 'YES' else 'NO' end as [Summary Taxable]
	,Case ISNULL(st.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Summary Taxable 2]
	,p.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,pc.ProductID as [Client Product ID]
    ,pc.ProductName as [Client Product]
From
	tProject p (nolock)
	inner join tTask t with (nolock, index=tTask51) on p.ProjectKey = t.ProjectKey
	left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	left outer join tUser u (nolock) on tu.UserKey = u.UserKey
	left outer join tUser tsu (nolock) on tu.CompletedByKey = tsu.UserKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser u2 (nolock) on p.AccountManager = u2.UserKey
	left outer join tTaskAssignmentType tat (nolock) on t.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
	left outer join vUserName u3 on p.KeyPeople1 = u3.UserKey
	left outer join vUserName u4 on p.KeyPeople2 = u4.UserKey
	left outer join vUserName u5 on p.KeyPeople3 = u5.UserKey
	left outer join vUserName u6 on p.KeyPeople4 = u6.UserKey
	left outer join vUserName u7 on p.KeyPeople5 = u7.UserKey
	left outer join vUserName u8 on p.KeyPeople6 = u8.UserKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glcp (nolock) on p.GLCompanyKey = glcp.GLCompanyKey
	left outer join tGLCompany glc (nolock) ON u.GLCompanyKey = glc.GLCompanyKey
	left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
	left outer join tUser bc (nolock) on p.BillingContact = bc.UserKey
	left outer join tService se (nolock) on tu.ServiceKey = se.ServiceKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  pc (nolock) on p.ClientProductKey  = pc.ClientProductKey
where t.TaskType = 2
GO
