USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_TaskAssignment]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_TaskAssignment]
AS

/*
  || When     Who Rel     What
  || 12/14/06 GHL 8.4     Replaced NULL columns (assignments) by tTask or tTaskUser values 
  || 12/21/06 GHL 8.4     Fixed bad vUserName JOIN. Somebody changed my change from 12/14/06!
  || 01/25/07 GHL 8.402   Added Timestamp related columns 
  || 03/27/07 RTC 8.41    (7915) Added Client Division and Client Product columns 
  || 10/10/07 CRG 8.5     Added GLCompany, Class, and OfficeID
  || 11/06/07 CRG 8.5     (12657) Added Task Priority  
  || 01/29/08 GHL 8.503   (19631) Added hint with ProjectKey (tTask51 index)  to join with tTask. 
  ||                                    For some reason was doing a table scan
  || 02/06/08 CRG 1.0.0.0 Added ASC_Selected
  || 10/13/08 QMD 10.0.1.0(36501) Added CustomFieldKey for projects
  || 10/27/08 RTC 10.0.1.1 (38647) Wrapped 'Project Type Name' with isnull in case no project type is specified on the project  
  || 03/17/09 RTC 10.5	  Removed user defined fields.
  || 09/15/09 GWG 10.510  Added fields to default project number, name, task and user for addinga  new activity
  || 01/22/10 RLB 10.517  (73008) Added Project Full Name
  || 02/10/10 GWG 10.518  Added Project Closed to be able to find people assigned to non closed jobs for staff schedule
  || 07/29/10 GHL 10.533  (86321) Removed Active flag. Because was causing confusion among users.
  || 08/13/10 RLB 10.533   (87534) Added Parent Company
  || 11/1/10  RLB 10.537  (89862)  Added few fields  to display task health on listing
  || 11/2/10  RLB 10.537  (91358) Added Client Primary Contact
  || 11/16/10 CRG 10.5.3.8 Added PlanDuration.
  ||                       Also, for the Assigned Staff field, if UserName is null, then returning the service Description.
  || 03/05/11 GWG 10.5.4.2 Added To Do Count
  || 03/28/11 GHL 10.5.4.3 (107252) Added TaskUserKey to help when UserKey is null, added ServiceKey
  || 07/27/11 RLB 10.5.4.6 (114500) Added Line Number
  || 01/09/12 MFT 10.5.5.2 (112748) Added Hide from Client
  || 01/09/12 MFT 10.5.5.2 (111249) Added ptu subquery for Actual Hours
  || 01/20/12 GWG 10.5.5.2 Fixed the actual hours query
  || 10/26/10 RLB 10.5.5.4 (65197) Added Billing Contact
  || 04/20/12 CRG 10.5.5.5 (140685) Now defaulting the SegmentColor based on the TaskStatus if there is not Segment, or the Segment does not have a color defined
  || 04/25/12 GHL 10.5.5.5 Added GLCompanyKey for map/restrict
  || 05/22/12 GHL 10.5.5.6 (143650) Added ProjectKey when calculating ActualHours. This way the index IX_tTime10 is used in the proper order
  ||                        query went from 2min to 10sec 
  || 07/26/12 GWG 10.5.5.8 added 1 2 3 to priority label so it sorts in order
  || 09/02/12 GWG 10.5.5.9 Actual Hours are filtered to the Person as well as task now
  || 10/09/12 WDF 10.5.6.1 (151302) Added KeyPersons(1-6) to output
  || 10/10/12 WDF 10.5.6.1 (152558) Added Billing Method
  || 11/07/12 MFT 10.5.6.2 Added To Do Items and modified Open To Do Items to check AssignedUserKey
  || 11/26/12 WDF 10.5.6.2 (152986) Added Assigned Staff Department and Office
  || 06/27/13 RLB 10.5.6.9 Enhancement added DisplayName
  || 07/9/13  GWG 10.5.6.9 Added in an or condition so null services are counted on hours
  || 11/04/13 WDF 10.5.7.4 (193655) Added Summary Task fields
  || 11/15/13 RLB 10.5.7.4 (191407) Added Yes OR No for tax 1 and 2
  || 07/01/14 QMD 10.5.8.1 (221006) ProjectFullName, FormattedName and TaskHours
  || 01/19/15 WDF 10.5.8.8 (242835) Added ISNULL to percentage fields
  || 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
*/

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.ProjectKey
	,p.CustomFieldKey
	,t.TaskKey
	,CAST(t.TaskKey as varchar) + '_' + CAST(tu.UserKey as varchar) as TaskUserKey
	,tu.TaskUserKey as TaskUserKeyPK
	,CASE 
		WHEN ts.SegmentColor IS NOT NULL THEN ts.SegmentColor
		ELSE 
			CASE t.TaskStatus
				WHEN 1 THEN 65280 --Green
				WHEN 2 THEN 16776960 --Yellow
				WHEN 3 THEN 16711680 --Red
			END
	END AS SegmentColor
	,p.ProjectNumber 
	,p.ProjectName
	,t.TaskID
	,t.TaskName	
    ,st.TaskID AS [SummaryTaskID] 
    ,st.TaskName AS [SummaryTaskName] 
    ,ISNULL(st.TaskID, '') + '-' + ISNULL(st.TaskName, '') AS [SummaryTask]
	,ts.SegmentName as [Timeline Segment]
	,ISNULL(t.TimelineSegmentDisplayName, ts.DisplayName) as [DisplayName]
	,taun.UserName
	,p.ProjectNumber + ' - ' + p.ProjectName  as [Project Full Name]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,Case p.Closed When 1 then 'YES' else 'NO' end as [Project Closed]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID as [Client ID]
	,pc.CompanyName as [Parent Company]
	,p.ClientProjectNumber [Client Project Number]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,isnull(pt.ProjectTypeName, '') as [Project Type]
	,cd.DivisionName as [Client Division]
	,cd.DivisionID as [Client Division ID]
	,cpr.ProductName as [Client Product]
	,cpr.ProductID as [Client Product ID]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,dbo.fFormatDateNoTime(p.CreatedDate) as [Project Created Date]
 	,Case p.BillingMethod
		When 1 then 'Time and Materials'
		When 2 then 'Fix Fee'
		When 3 then 'Retainer'
		end as [Billing Method]
	,u1.FirstName + ' ' + u1.LastName as [Client Primary Contact]
	,bc.FirstName + ' ' + bc.LastName as [Billing Contact]
	,kp1.FirstName + ' ' + kp1.LastName AS [Key Person 1]
	,kp2.FirstName + ' ' + kp2.LastName AS [Key Person 2]
	,kp3.FirstName + ' ' + kp3.LastName AS [Key Person 3]
	,kp4.FirstName + ' ' + kp4.LastName AS [Key Person 4]
	,kp5.FirstName + ' ' + kp5.LastName AS [Key Person 5]
	,kp6.FirstName + ' ' + kp6.LastName AS [Key Person 6]
	,cp.CampaignName as [Campaign Name]
	,o.OfficeName as [Project Office]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,t.TaskStatus
	,t.TaskType
	,t.ScheduleTask
	,t.PlanStart
	,t.PlanComplete
	,ISNULL(t.PercComp, 0) as PercComp
	,t.ScheduleNote
	,p.ProjectNumber + ' - ' + p.ProjectName  as ProjectFullName
	,ISNULL(t.TaskID + '-', '') + t.TaskName as FormattedName 
	,tu.Hours as TaskHours
	,t.Description as [Task Description]
	,Case t.Taxable When 1 then 'YES' else 'NO' end as [Task Taxable]
	,Case t.Taxable2 When 1 then 'YES' else 'NO' end as [Task Taxable 2]
	,t.PlanStart as [Task Plan Start Date]
	,t.PlanComplete as [Task Plan Completion Date]
	,t.ActStart as [Task Actual Start Date]
	,t.ActComplete as [Task Actual Completion Date]
	,ISNULL(t.PercComp, 0) as [Task Percentage Complete]
	,t.BaseStart as [Task Baseline Start Date]
	,t.BaseComplete as [Task Baseline Completion Date]
	,Case t.MoneyTask When 1 then 'YES' else 'NO' end as [Track Budgets]
	,Case t.ScheduleTask When 1 then 'YES' else 'NO' end as [Track Schedules]
	,t.EstHours as [Original Budget Hours]
	,t.EstLabor as [Original Budget Labor]
	,t.BudgetExpenses as [Original Budget Net Expense]
	,t.EstExpenses as [Original Budget Gross Expense]
	,t.ApprovedCOHours as [Approved Change Order Hours]
	,t.ApprovedCOLabor as [Approved Change Order Labor]
	,t.ApprovedCOExpense as [Approved Change Order Gross Expense]
	,t.DueBy as [Due By]
	,t.AssignedNames as [Assigned People]
	,CAST(t.Description as varchar (4000)) as [Description of Work]
	,tu.ActStart as [Assignment Actual Start Date]
	,tu.ActComplete as [Assignment Actual Completion Date]
	,t.PlanStart as [Assignment Plan Start Date]
	,t.PlanComplete as [Assignment Plan Completion Date]
	,t.PlanDuration as [Assignment Duration]
	,ISNULL(tu.PercComp, 0) as [Assignment Percentage Complete]
	,t.Comments as [Assignment Comments]
	,Case t.Priority When 1 then '1 - High' When 2 then '2 - Med' When 3 Then '3 - Low' end as [Assignment Priority]
	,Case t.PredecessorsComplete When 1 then 'YES' else 'NO' end as [Predecessors Completed]
	,Case tu.ReviewedByTraffic When 1 then 'YES' else 'NO' end as [Traffic Review Complete]
	,tu.ReviewedByDate as [Traffic Review Date]
	,tr.UserName as [Traffic Review By]
	,am.FirstName + ' ' + am.LastName [Account Manager]
    ,taun.UserName as [Assigned Staff]
	,dpt.DepartmentName as [Assigned Staff Department]
	,dpt.DepartmentKey
	,tof.OfficeName as [Assigned Staff Office]
	,tof.OfficeKey
	,tas.Description as [Assigned Role]
	,tu.UserKey
	,tu.ServiceKey
	--for backward compatability with user's saved listings
	,ISNULL(tu.PercComp, 0) as [Assigned Percentage of Work]
	,t.TaskName  as [Assignment Subject]
	,t.ProjectOrder as [Line Number]
	,tu.Hours as [Allocated Hours]
	,tat.TaskAssignmentType as [Task Type]
	,tu.CompletedByDate as [Time Completed]
	,tsu.FirstName + ' ' + tsu.LastName as [Time Completed By]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,CASE t.Priority
		WHEN 1 THEN '1 - High'
		WHEN 2 THEN '2 - Medium'
		WHEN 3 THEN '3 - Low'
	END AS [Task Priority]
	,0 AS ASC_Selected
	,t.PlanDuration
	,t.HideFromClient AS [Hide from Client]
    ,ISNULL((
		Select Sum(ActualHours) from tTime (nolock)
		Where p.ProjectKey = tTime.ProjectKey -- uses index IX_tTime10 in proper order, i.e. ProjectKey first
		and t.TaskKey = ISNULL(tTime.DetailTaskKey, tTime.TaskKey)
		and tu.UserKey = tTime.UserKey
		and (ISNULL(pr.ShowActualHours, 0) = 1 OR tu.ServiceKey is null OR tu.ServiceKey = tTime.ServiceKey)
		), 0)
		As [Actual Hours]
	,(SELECT COUNT(*) FROM tActivity a (nolock) WHERE a.ActivityEntity = 'ToDo' AND a.TaskKey = t.TaskKey AND (a.AssignedUserKey = tu.UserKey OR a.AssignedUserKey IS NULL)) AS [To Do Items]
	,(SELECT COUNT(*) FROM tActivity a (nolock) WHERE a.ActivityEntity = 'ToDo' AND a.TaskKey = t.TaskKey AND (a.AssignedUserKey = tu.UserKey OR a.AssignedUserKey IS NULL) AND a.Completed = 0) AS [Open To Do Items]
	,rd.DeliverableName as [Deliverable Name]
From
	tProject p (nolock)
	inner join tTask t with  (nolock, index=tTask51) on p.ProjectKey = t.ProjectKey
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	inner join tPreference pr (nolock) on p.CompanyKey = pr.CompanyKey
	left outer join tTask st (NOLOCK) on t.SummaryTaskKey = st.TaskKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tTimelineSegment ts (nolock) on t.TimelineSegmentKey = ts.TimelineSegmentKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	left outer join tClientProduct cpr (nolock) on p.ClientProductKey = cpr.ClientProductKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join vUserName tr (nolock) on t.ReviewedByKey = tr.UserKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join vUserName taun (nolock) on tu.UserKey = taun.UserKey
	left outer join tDepartment dpt (nolock) on taun.DepartmentKey = dpt.DepartmentKey
	left outer join tOffice tof (nolock) on taun.OfficeKey = tof.OfficeKey
	left outer join tTaskAssignmentType tat (nolock) on t.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
	left outer join tUser tsu (nolock) on tu.CompletedByKey = tsu.UserKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tCompany pc (nolock) on cl.ParentCompanyKey = pc.CompanyKey
	left outer join tUser u1 (nolock) on cl.PrimaryContact = u1.UserKey
	left outer join tService tas (nolock) on tu.ServiceKey = tas.ServiceKey
	left outer join tUser bc (nolock) on p.BillingContact = bc.UserKey
	left outer join tUser kp1 (nolock) on p.KeyPeople1 = kp1.UserKey
	left outer join tUser kp2 (nolock) on p.KeyPeople2 = kp2.UserKey
	left outer join tUser kp3 (nolock) on p.KeyPeople3 = kp3.UserKey
	left outer join tUser kp4 (nolock) on p.KeyPeople4 = kp4.UserKey
	left outer join tUser kp5 (nolock) on p.KeyPeople5 = kp5.UserKey
	left outer join tUser kp6 (nolock) on p.KeyPeople6 = kp6.UserKey
	LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey
	
	
Where
	p.Active = 1 
And 	ISNULL(ps.OnHold, 0) = 0
And	t.TaskType = 2
GO
