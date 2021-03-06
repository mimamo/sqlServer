USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Tasks]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vReport_Tasks]
AS

/*
|| When     Who Rel     What
|| 10/12/06 WES 8.3567  Added Task Status Light
|| 10/13/06 WES 8.3567  Added Custom Fields Key
|| 02/21/06 GWG 8.4004  Added Total Allocated Hours
|| 03/26/07 RTC 8.4.1   (8689) Added the client division and product from the invoice detail project.
|| 05/01/07 CRG 8.5     (9052) Added Track Percent Complete Separate
|| 05/01/07 CRG 8.5     (8989) Added Project Task Status
|| 07/10/07 GHL 8.5     Added restriction on ER
|| 10/11/07 CRG 8.5     Added GLCompany and Class
|| 10/30/07 CRG	8.5     Modified to use tInvoiceSummary
|| 11/01/07 GHL 8.5     (15534) Added Account Manager
|| 11/06/07 CRG 8.5     (13650) Added Task Days
|| 11/06/07 CRG 8.5     (9147) Added Client ID
|| 11/06/07 CRG 8.5     (12657) Added Task Priority
|| 01/11/10 RLB 10.516  (71887) Added Billing Item
|| 01/22/10 RLB 10.517  (73008) Added Project Full Name
|| 02/1/10  RLB 10.518  (73008) Added Task Assignment Type
|| 11/15/10 RLB 10.538  (75709) Added Last Task Due Date and Earliest Task Start Date
|| 12/14/10 RLB 10.539  (96081) Added Non Billable Project
|| 04/07/11 RLB 10.543 (108045) Removed Project Short Name
|| 09/21/11 RLB 10.548 (119193) Added Project Close Date 
|| 04/24/12 GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 07/11/12 GWG 10.558  Track budget was point to MoneyTask, not TrackBudget
|| 09/20/12 GWG 10.560  Added Summary Task
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 12/12/12 WDF 10.5.6.3 (147399) Add Task EventStart/EventEnd times
|| 5/15/13  GWG 10.5.6.7 Added Exclude from Status
|| 11/15/13 RLB 10.5.7.4 (191407) Added Yes OR No for tax 1 and tax 2 on summary and detail tasks
|| 12/09/13 RLB 10.5.7.5 (193859) added Client Billing Contact
|| 1/11/14  GWG 10.5.7.6 Added Assigned peoples names
|| 12/4/14  GWG 10.5.8.7 Added indented task name
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
*/

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.CustomFieldKey
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,p.ProjectNumber + ' - ' + p.ProjectName  as [Project Full Name]
	,cl.CustomerID as [Client ID]
	,cl.CompanyName as [Client Name]
	,p.ClientProjectNumber [Client Project Number]
	,ps.ProjectStatus as [Project Status]
	,p.CreatedDate as [Created Date]
	,p.ProjectCloseDate as [Project Close Date]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,cp.CampaignName as [Campaign Name]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,cd.DivisionName as [Division Name]
	,cd.DivisionID as [Division ID]
	,pd.ProductName as [Product Name]
	,pd.ProductID as [Product ID]
 	,kp1.UserName as [Key People 1]
	,kp2.UserName as [Key People 2]
	,kp3.UserName as [Key People 3]
	,kp4.UserName as [Key People 4]
	,kp5.UserName as [Key People 5]
	,kp6.UserName as [Key People 6]
	,am.UserName as [Account Manager]
	,bu.UserName as [Client Billing Contact]
	,o.OfficeName as [Office]
	,tat.TaskAssignmentType as [Task Assignment Type]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,t.TaskID + ' ' + t.TaskName as [Task Full Name]
	,STUFF(t.TaskName, 1, 0, REPLICATE ( '     ' ,t.TaskLevel )) as [Indented Task Name]
	,st.TaskID as [Summary Task ID]
	,st.TaskName as [Summary Task Name]
	,st.TaskID + ' ' + st.TaskName as [Summary Task Full Name]
	,Case ISNULL(st.Taxable, 0) When 1 then 'YES' else 'NO' end as [Summary Task Taxable]
	,Case ISNULL(st.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Summary Task Taxable 2]
	,t.Description as [Task Description]
	,Case t.TaskType When 1 Then 'Summary' else 'Tracking' end as [Task Type]
	,Case ISNULL(t.Taxable, 0) When 1 then 'YES' else 'NO' end as [Task Taxable]
	,Case ISNULL(t.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Task Taxable 2]
	,t.PlanStart as [Plan Start Date]
	,t.PlanComplete as [Plan Completion Date]
	,(Select MAX(tTask.PlanComplete) from tTask (nolock) Where tTask.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,(Select MIN(tTask.PlanStart) from tTask (nolock) Where tTask.ProjectKey = p.ProjectKey) as [Earliest Task Start Date]
	,t.ActStart as [Actual Start Date]
	,t.ActComplete as [Actual Completion Date]
	,substring(CONVERT(VARCHAR, t.EventStart, 100),13, 5) + ' ' + RIGHT(CONVERT(VARCHAR, t.EventStart, 100),2) as [Start Time]
	,substring(CONVERT(VARCHAR, t.EventEnd, 100),13, 5) + ' ' + RIGHT(CONVERT(VARCHAR, t.EventEnd, 100),2) as [End Time]
	,t.PercComp as [Percentage Complete]
	,t.BaseStart as [Baseline Start Date]
	,t.BaseComplete as [Baseline Completion Date]
	,t.Comments as [Task Status Comments]
	,t.ProjectOrder as [Task Line Number]
	,wt.WorkTypeID + ' - ' + wt.WorkTypeName as [Billing Item]
	,t.AssignedNames as [Assigned People]
	,Case t.TrackBudget When 1 then 'YES' else 'NO' end as [Track Budgets]
	,Case t.ScheduleTask When 1 then 'YES' else 'NO' end as [Track Schedules]
	,Case p.NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,CASE t.TaskStatus WHEN 1 THEN 'Green' WHEN 2 THEN 'Yellow' WHEN 3 THEN 'Red' END as [Task Status Light]
	,Case t.ExcludeFromStatus When 1 then 'YES' else 'NO' end as [Exclude From Status]
	,t.HourlyRate as [Task Hourly Rate]
	,t.EstHours as [Original Budget Hours]
	,t.BudgetLabor as [Original Budget Net Labor]
	,t.EstLabor as [Original Budget Labor]
	,t.BudgetExpenses as [Original Budget Net Expense]
	,t.EstExpenses as [Original Budget Gross Expense]
	,t.ApprovedCOHours as [Approved Change Order Hours]
	,t.ApprovedCOBudgetLabor as [Approved Change Order Net Labor]
	,t.ApprovedCOLabor as [Approved Change Order Labor]
	,t.ApprovedCOBudgetExp as [Approved Change Order Net Expense]
	,t.ApprovedCOExpense as [Approved Change Order Gross Expense]
	,t.EstExpenses + t.ApprovedCOExpense as [Estimate Total Gross Expense]
	,t.EstLabor + t.ApprovedCOLabor + t.EstExpenses + t.ApprovedCOExpense as [Estimate Total]
	,t.EstLabor + t.ApprovedCOLabor + t.EstExpenses + t.ApprovedCOExpense - t.BudgetExpenses - t.BudgetLabor - t.ApprovedCOBudgetLabor - t.ApprovedCOBudgetExp  as [Estimate Profit]
	,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.TaskKey = t.TaskKey) as [Actual Hours]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.TaskKey = t.TaskKey) as [Actual Labor]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.TaskKey = t.TaskKey) as [Actual Labor Cost]
	,(Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.TaskKey = t.TaskKey) + 
	 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.TaskKey = t.TaskKey And  tExpenseReceipt.VoucherDetailKey is null ) + 
	 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.TaskKey = t.TaskKey) as [Actual Net Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.TaskKey = t.TaskKey) +
	 (Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.TaskKey = t.TaskKey) + 
	 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.TaskKey = t.TaskKey And  tExpenseReceipt.VoucherDetailKey is null ) + 
	 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.TaskKey = t.TaskKey) as [Actual Total]	
	,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.TaskKey = t.TaskKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.TaskKey = t.TaskKey And  tExpenseReceipt.VoucherDetailKey is null ) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.TaskKey = t.TaskKey) as [Actual Billable Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.TaskKey = t.TaskKey and WriteOff = 1) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.TaskKey = t.TaskKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.TaskKey = t.TaskKey And  tExpenseReceipt.VoucherDetailKey is null and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.TaskKey = t.TaskKey and WriteOff = 1) as [Transaction Writeoff Amount]
	,(Select ISNULL(Sum(Amount), 0) from tInvoiceSummary (nolock) inner join tInvoice (nolock) on tInvoiceSummary.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 0 and tInvoiceSummary.TaskKey = t.TaskKey) as [Amount Billed]
	,(Select ISNULL(Sum(Amount), 0) from tInvoiceSummary (nolock) inner join tInvoice (nolock) on tInvoiceSummary.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceSummary.TaskKey = t.TaskKey) as [Amount Advance Billed]
	,(Select Sum(ISNULL(TotalCost, 0) - ISNULL(AppliedCost, 0)) 
			from tPurchaseOrderDetail (nolock) 
			inner join tPurchaseOrder (nolock) on tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey
		 	Where tPurchaseOrderDetail.TaskKey = t.TaskKey 
			and tPurchaseOrderDetail.Closed = 0) as [Open Purchase Orders]
	,ISNULL((Select Sum(ISNULL(Hours, 0)) from tTaskUser tu (nolock) Where tu.TaskKey = t.TaskKey), 0) as [Total Allocated Hours]
	,CASE t.PercCompSeparate WHEN 1 THEN 'YES' ELSE 'NO' END AS [Separate Percent Complete]
	,CASE p.TaskStatus
		WHEN 0 THEN 'Green'
		WHEN 1 THEN 'Green'
		WHEN 2 THEN 'Yellow'
		WHEN 3 THEN 'Red'
		ELSE 'Green'
	END AS [Project Task Status]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,CASE t.ScheduleTask
		WHEN 1 THEN t.PlanDuration
		ELSE NULL
	END AS [Task Days]
	,CASE t.Priority
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END AS [Task Priority]
	,ts.SegmentName as [Timeline Segment]
	,p.ProjectKey
From
	tProject p (nolock)
	inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join vUserName kp1 (nolock) on p.KeyPeople1 = kp1.UserKey
	left outer join vUserName kp2 (nolock) on p.KeyPeople2 = kp2.UserKey
	left outer join vUserName kp3 (nolock) on p.KeyPeople3 = kp3.UserKey
	left outer join vUserName kp4 (nolock) on p.KeyPeople4 = kp4.UserKey
	left outer join vUserName kp5 (nolock) on p.KeyPeople5 = kp5.UserKey
	left outer join vUserName kp6 (nolock) on p.KeyPeople6 = kp6.UserKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	left outer join tClientProduct pd (nolock) on p.ClientProductKey = pd.ClientProductKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join vUserName am (nolock) on p.AccountManager = am.UserKey
	left outer join tWorkType wt (nolock) on t.WorkTypeKey = wt.WorkTypeKey
	left outer join tTaskAssignmentType tat (nolock) on t.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
	left outer join tTimelineSegment ts (nolock) on t.TimelineSegmentKey = ts.TimelineSegmentKey
	left outer join vUserName bu (nolock) on p.BillingContact = bu.UserKey
GO
