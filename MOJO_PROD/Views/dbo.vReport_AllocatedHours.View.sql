USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_AllocatedHours]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_AllocatedHours]
AS

/*
|| When      Who Rel     What
|| 10/11/07  CRG 8.5     Added GLCompany and Class
|| 11/06/07  GHL 8.5     Added Budgeted Hours
|| 11/06/07  CRG 8.5     (12657) Added Task Priority 
|| 01/15/08  GHL 8.5     (19112) Changed UNION to UNION ALL to get all distincts hours from tTime
|| 06/24/09  GHL 10.5    (55734) Using now DetailTaskKey vs TaskKey for actual hours
|| 04/12/10  RLB 10.5221 (78576) filter for only approved Budgets on Budgeted Hours
|| 02/11/11  RLB 10.541  (103245) Added Role to report
|| 04/07/11  RLB 10.543  (108045) Removed Project Short Name
|| 07/27/11  RLB 10.546  (114500) Added Line Number which is the tasks order in the projet schedule screen
|| 07/27/11  RLB 10.546  (111324) Added Campaign Segment
|| 04/23/12  GHL 10.555  Added GLCompanyKey for map/restrict
|| 06/11/12  GWG 10.556  Added Summary task info for rollups.
|| 08/22/12  WDF 10.559  (112726) Added Client ID and Client Full Name
|| 10/23/12  RLB 10.561  (156203) Added Project Account Manager
|| 10/29/12  CRG 10.561  (156391) Added ProjectKey
|| 05/22/13  MFT 10.568  (174957) Added t.Comments
|| 05/30/13  GWG 10.568  Added Actual Dollars, task and project full name and Project non billable
|| 08/07/13  WDF 10.571  (185818) Changed [Role] to [Service]
|| 08/12/13  WDF 10.571  (162746) Added CustomFieldKey
|| 11/15/13  RLB 10.5.7.4 (191407) Added Yes OR No for tax 1 and 2
|| 01/20/14  WDF 10.5.7.6 (203058) Add Hours Billed
|| 07/30/14  GWG 10.5.8.2 Added User Std Hourly Rate
|| 10/28/14  WDF 10.5.8.5 (226655) Added Users Default GLCompany ID/Name
|| 01/27/15  WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
*/

Select
	 p.CompanyKey
	,p.CustomFieldKey
	,isnull(p.GLCompanyKey, u.GLCompanyKey) as GLCompanyKey -- The GLCompany would come from the project or user
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,p.ProjectNumber + ' ' + p.ProjectName as [Project Full Name]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,cl.CustomerID as [Client ID]
	,cl.CompanyName as [Client Name]
	,ISNULL(cl.CustomerID, '') + ISNULL(cl.CompanyName, '') as [Client Full Name]
	,p.ClientProjectNumber [Client Project Number]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,cp.CampaignName as [Campaign Name]
	,cs.SegmentName as [Campaign Segment]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,Case p.NonBillable When 1 then 'NO' else 'YES' end as [Billable Project]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,se.Description as [Role]
	,se.Description as [Service]
	,o.OfficeName as [Office]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,t.TaskID  + ' ' + t.TaskName as [Task Full Name]
	,st.TaskID as [Summary Task ID]
	,st.TaskName as [Summary Task Name]
	,ISNULL(st.TaskID, '') + ISNULL(st.TaskName, '') as [Summary Task Full Name]
	,st.ProjectOrder as [Summary Task Line Number]
	,bt.TaskID as [Budget Task ID]
	,bt.TaskName as [Budget Task Name]
	,ISNULL(bt.TaskID, '') + ISNULL(bt.TaskName, '') as [Budget Task Full Name]
	,t.Description as [Task Description]
	,t.ProjectOrder as [Line Number]
	,Case t.TaskType When 1 Then 'Summary' else 'Tracking' end as [Task Type]
	,Case t.Taxable When 1 then 'YES' else 'NO' end as [Task Taxable]
	,Case ISNULL(t.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Task Taxable 2]
	,t.PlanStart as [Plan Start Date]
	,t.PlanComplete as [Plan Completion Date]
	,t.ActStart as [Actual Start Date]
	,t.ActComplete as [Actual Completion Date]
	,t.PercComp as [Percentage Complete]
	,t.Comments as [Task Status Comments]
	,t.BaseStart as [Baseline Start Date]
	,t.BaseComplete as [Baseline Completion Date]
	,Case t.MoneyTask When 1 then 'YES' else 'NO' end as [Track Budgets]
	,Case t.ScheduleTask When 1 then 'YES' else 'NO' end as [Track Schedules]
	,t.HourlyRate as [Task Hourly Rate]
	,t.EstHours as [Original Budget Hours]
	,t.EstLabor as [Original Budget Labor]
	,t.BudgetExpenses as [Original Budget Net Expense]
	,t.EstExpenses as [Original Budget Gross Expense]
	,t.ApprovedCOHours as [Approved Change Order Hours]
	,t.ApprovedCOLabor as [Approved Change Order Labor]
	,t.ApprovedCOExpense as [Approved Change Order Gross Expense]
	,t.EstExpenses + t.ApprovedCOExpense as [Estimate Total Gross Expense]
	,t.EstLabor + t.ApprovedCOLabor + t.EstExpenses + t.ApprovedCOExpense as [Estimate Total]
 	,u.FirstName As [User First Name]	
    ,u.LastName As [User Last Name]	
 	,u.FirstName + ' ' + u.LastName AS [User Full Name]
	,glc.GLCompanyID AS [Default GLCompany ID]
	,glc.GLCompanyID + ' - ' + glc.GLCompanyName AS [Default GLCompany Full Name]
 	,u.HourlyRate as [User Standard Hourly Rate]
   	,ISNULL(ptu.AllocatedHours, 0) As [Allocated Hours]	
   	,ISNULL(ptu.ActualHours, 0) As [Actual Hours]	
    ,ISNULL(ptu.HoursBilled, 0) As [Hours Billed]	
   	,ISNULL(ptu.ActualDollars, 0) As [Actual Labor Gross]
   	,ISNULL(ptu.BudgetedHours, 0) As [Budgeted Hours]	
	,dp.DepartmentName as [Department]
	,glcp.GLCompanyID as [Company ID]
	,glcp.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,CASE t.Priority
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END AS [Task Priority]
	,p.ProjectKey
    ,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,pc.ProductID as [Client Product ID]
    ,pc.ProductName as [Client Product]
From
	tProject p (nolock)
	inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	
left outer join
	(
select  ProjectKey, isnull(UserKey, 0) as UserKey, TaskKey, isnull(ServiceKey, 0) as ServiceKey 
	,SUM(AllocatedHours) as AllocatedHours
	,SUM(ActualHours) As ActualHours
	,SUM(BudgetedHours) AS BudgetedHours
	,SUM(ActualDollars) as ActualDollars
    ,SUM(HoursBilled) as HoursBilled
from
	(
select	t.ProjectKey
	,tu.UserKey
	,tu.TaskKey
	,tu.ServiceKey
	,tu.Hours As AllocatedHours
	,0        As ActualHours
	,0        As BudgetedHours
	,0.0      AS ActualDollars
	,0        AS HoursBilled
from	tTaskUser tu (NOLOCK)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	
UNION ALL

select	t.ProjectKey
	,t.UserKey
	,isnull(t.DetailTaskKey, t.TaskKey) -- report actual hours against detail task if any
	,ServiceKey
	,0
	,t.ActualHours
	,0
	,t.ActualHours * t.ActualRate
	,0
from	tTime t (NOLOCK)

 UNION ALL
 
 select  t.ProjectKey
     ,t.UserKey
     ,isnull(t.DetailTaskKey, t.TaskKey) -- report billed hours against detail task if any
     ,ServiceKey
     ,0
     ,0
     ,0
     ,0
     ,t.ActualHours
 from tTime t (NOLOCK)
where t.InvoiceLineKey > 0	

UNION ALL

select  e.ProjectKey
	,etl.UserKey
	,etl.TaskKey
	,ServiceKey
	,0
	,0
	,etl.Hours
	,0.0
	,0
from    vEstimateApproved vea (NOLOCK)
	inner join tEstimate e (NOLOCK) on vea.EstimateKey = e.EstimateKey
 	inner join tEstimateTaskLabor etl (NOLOCK) on e.EstimateKey = etl.EstimateKey
where   etl.TaskKey is not null  AND vea.Approved = 1 -- distinguish Task/Person from Task/Service
	) as ptu_detail
group by ProjectKey, isnull(UserKey, 0), TaskKey, isnull(ServiceKey, 0)
	) as ptu on p.ProjectKey = ptu.ProjectKey and t.TaskKey = ptu.TaskKey

	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser u (nolock) on ptu.UserKey = u.UserKey
	left outer join tDepartment dp (nolock) on u.DepartmentKey = dp.DepartmentKey
	left outer join tGLCompany glcp (nolock) on p.GLCompanyKey = glcp.GLCompanyKey
	left outer join tGLCompany glc (nolock) ON u.GLCompanyKey = glc.GLCompanyKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tService se (nolock) on ptu.ServiceKey = se.ServiceKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  pc (nolock) on p.ClientProductKey  = pc.ClientProductKey
GO
