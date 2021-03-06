USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_ProjectTraffic]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE          View [dbo].[vListing_ProjectTraffic]
AS

 /*
  || When     Who Rel   What
  || 03/05/07 GHL 8.4   Added join with project rollup table to improve perfo      
  || 03/07/07 GHL 8.4   Changed AmountBilled             
  || 04/13/07 GHL 8.4   Reading now new column tProject.TaskStatus         
  || 04/16/07 GHL 8.4   Added Actual Expense Net. Bug 8898             
  || 10/10/07 CRG 8.5   Added GLCompany, Class, and Office (OfficeID only, OfficeName was already there)     
  || 11/08/07 GHL 8.5   Synch'ed names with flash reports
  || 11/20/07 GHL 8.5     Changed w/o Orders to wo Orders because this crashes the report engine
  || 10/16/08 GHL 10.011 (34827)(36763) Removed Orders from Total Costs
  || 03/15/10 RLB 10.520 (76755)Added Last Task Due Date
  || 09/15/10 RLB 10.535 (87834)Added Project Request ID  
  || 10/10/10 GWG 10.536  Added Parent Company on the client
  || 04/07/11 RLB 10.543 (108045) Removed Project Short Name 
  || 10/26/11 GHL 10.549 (124319) Added net of prebilled orders to Total Costs Net
  || 12/08/11 RLB 10.551 (113729) Added  Account Manager Active
  || 04/25/12 GHL 10555   Added GLCompanyKey for map/restrict
  */

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.ProjectKey
	,p.CampaignKey
	,p.CustomFieldKey
	,ISNULL(p.TaskStatus, 1) as ProjectTaskStatus
	,Case p.TaskStatus When 1 then 'Green' When 2 then 'Yellow' When 3 then 'Red' else 'Green' end as [Schedule Status Color]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,cl.CustomerID as [Client ID]
	,cl.CustomerID + ' - ' + cl.CompanyName  as [Client ID and Name]
	,cl.CompanyName as [Client Name]
	,p.ClientProjectNumber [Client Project Number]
	,bu.FirstName + ' ' + bu.LastName as [Client Billing Contact]
	,pc.CompanyName as [Parent Company]
	,Case NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,Case Closed When 1 then 'YES' else 'NO' end as [Closed Project]
	,ps.ProjectStatus as [Project Status]
	,rq.RequestID as [Project Request ID]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,p.CreatedDate as [Created Date]
	,(SELECT MAX(t.PlanComplete) FROM tTask t (NOLOCK) WHERE t.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,cd.DivisionName as [Client Division]
	,cp.ProductName as [Client Product]
	,cu.FirstName + ' ' + cu.LastName as [Created By]
	,o.OfficeName as [Office]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,Case am.Active When 1 then 'YES' else 'NO' end as [Account Manager Active]
	,CAST(p.Description AS VARCHAR(8000)) as [Project Description]
	,cam.CampaignName as [Campaign Name]
	,cam.CampaignID as [Campaign ID]
	,p.ClientNotes as [Client Notes]

	-- Budgeted data
	,p.EstHours as [Original Budget Hours] -- [Estimate Hours]
	,p.EstLabor as  [Original Budget Labor Gross] -- [Estimate Labor]
	,p.BudgetExpenses as [Original Budget Expense Net] -- [Estimate Expense Net]
	,p.EstExpenses as [Original Budget Expense Gross] -- [Estimate Expense Gross]
	,p.ApprovedCOHours as [CO Budget Hours] -- [Approved CO Hours]
	,p.ApprovedCOLabor as [CO Budget Labor Gross] -- [Approved CO Labor]
	,p.ApprovedCOExpense as [CO Budget Expense Gross]-- [Approved CO Expense Gross]
	,p.EstHours + p.ApprovedCOHours as [Current Budget Hours] -- [Estimate Total Hours]
	,p.EstLabor + p.ApprovedCOLabor as [Current Budget Labor Gross] -- [Estimate Total Labor]
	,p.EstExpenses + p.ApprovedCOExpense as [Current Budget Expense Gross] --[Estimate Total Gross Expense]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Current Total Budget wo Taxes] -- [Estimate Total]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense + ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) as [Current Total Budget] --New field


	-- Actual data 
	,ISNULL(roll.Hours, 0) as [Actual Hours]
	,ISNULL(roll.LaborGross, 0) as [Labor Gross] -- [Actual Labor]
	,ISNULL(roll.LaborNet, 0) as [Labor Net] --  [Actual Labor Cost]
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) as [Total Costs Gross wo Orders] -- [Actual Billable Expense] 
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) + ISNULL(roll.OrderPrebilled, 0)  as [Total Costs Gross] -- New field to match report
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net wo Orders] -- [Actual Net Expense]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) 
	-- no need to change tProjectRollup since tPurchaseOrderDetail is small and we have a good index for this query 
	+ ISNULL((
		select SUM(pod.TotalCost) from tPurchaseOrderDetail pod (nolock) where p.ProjectKey = pod.ProjectKey and pod.InvoiceLineKey > 0
	),0)
	as [Total Costs Net] -- New field!!!
	,ISNULL(roll.LaborWriteOff, 0) + ISNULL(roll.MiscCostWriteOff, 0) + ISNULL(roll.ExpReceiptWriteOff, 0) + ISNULL(roll.VoucherWriteOff, 0) as [Transaction Writeoff Amount] -- No change, not in report
	,ISNULL(roll.BilledAmount, 0) as [Amount Billed]-- No change same as report

	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,o.OfficeID as [Office ID]

	/*
             ,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Hours]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor Cost]
	,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Billable Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey and WriteOff = 1) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and WriteOff = 1) as [Transaction Writeoff Amount]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) Where tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Billed]
	*/
From
	tProject p (nolock)
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCampaign cam (nolock) on p.CampaignKey = cam.CampaignKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompany pc (nolock) on cl.ParentCompanyKey = pc.CompanyKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	left outer join tClientProduct cp (nolock) on p.ClientProductKey = cp.ClientProductKey
	left outer join tUser bu (nolock) on p.BillingContact = bu.UserKey
	left outer join tUser cu (nolock) on p.CreatedByKey = cu.UserKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tRequest rq (nolock) on p.RequestKey = rq.RequestKey
GO
