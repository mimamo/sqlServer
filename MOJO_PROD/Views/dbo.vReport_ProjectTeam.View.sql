USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ProjectTeam]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_ProjectTeam]
AS

/*
|| When     Who Rel      What
|| 12/29/08 CRG 10.0.1.5 Created for Enhancement 39387
|| 03/17/09  RTC 10.5	  Removed user defined fields.
|| 10/6/09  CRG 10.5.1.2 (64424) Added Parent Company Name and Parent Active
|| 04/07/11 RLB 10.543 (108045) Removed Project Short Name
|| 08/30/11 RLB 10.547  (118280) Added Campaign Full Name and Campaign ID
|| 04/24/12  GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 08/02/12 RLB 10.558   (150535) Added project close date
|| 08/17/12 RLB 10.559 (151960) Added Billing Group Code
|| 09/28/12 GHL 10.560 Getting now BillingGroupCode from tBillingGroup
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 09/26/14 WDF 10.584 (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
|| 01/27/15 WDF 10.588 (Abelson Taylor) Added Division and Product ID
|| 01/28/15 GHL 10.588 (Abelson Taylor) Added title name from user in the team
*/

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.CustomFieldKey
	,rn.Title as [Retainer Name]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
 	,kp1.UserName as [Key People 1]
	,kp2.UserName as [Key People 2]
	,kp3.UserName as [Key People 3]
	,kp4.UserName as [Key People 4]
	,kp5.UserName as [Key People 5]
	,kp6.UserName as [Key People 6]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID as [Client ID]
	,cl.CustomerID + ' - ' + cl.CompanyName as [Client Full Name]
	,p.ClientProjectNumber [Client Project Number]
	,bu.FirstName + ' ' + bu.LastName as [Client Billing Contact]
	,bu.Email as [Client Billing Contact Email]
	,bu.Phone1 as [Client Billing Contact Phone]
	,Case p.GetRateFrom 
	    when 9 then 'Billing Title'
	    when 10 then 'Billing Title Rate Sheet'
		When 1 then 'Client'
		When 2 then 'Project'
		When 3 then 'Project / User'
		When 4 then 'Service'
		When 5 then 'Service Rate Sheet'
		When 6 then 'Task'
		end as [Get Labor Rate From]
	,Case p.BillingMethod 
		When 1 then 'Time and Materials'
		When 2 then 'Fixed Fee'
		When 3 then 'Retainer'
		end as [Billing Method]
	,Case NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,Case Closed When 1 then 'YES' else 'NO' end as [Closed Project]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,cd.DivisionName as [Client Division]
	,cd.DivisionID as [Client Division ID]
	,cpr.ProductName as [Client Product]
	,cpr.ProductID as [Client Product ID]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,p.Description as [Project Description]
	,p.ClientNotes as [Client Notes]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,p.ProjectCloseDate as [Project Close Date]
	,bg.BillingGroupCode as [Billing Group Code]
	,(SELECT MAX(t.PlanComplete) FROM tTask t (NOLOCK) WHERE t.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,p.CreatedDate as [Created Date]
	,cu.FirstName + ' ' + cu.LastName as [Created By]
	,o.OfficeName as [Office]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,cp.CampaignName as [Campaign Name]
	,cp.CampaignID as [Campaign ID]
	,cp.CampaignID + '-' + cp.CampaignName as [Campaign Full Name]
	,pr.RequestID as [Project Request ID]

	-- Budgeted data
	,p.EstHours as [Original Budget Hours] -- [Estimate Hours]
	,p.BudgetLabor as [Original Budget Labor Net] -- [Estimate Labor Net]
	,p.EstLabor as [Original Budget Labor Gross] -- [Estimate Labor]
	,p.BudgetExpenses as [Original Budget Expense Net] --  [Estimate Expense Net]
	,p.EstExpenses as [Original Budget Expense Gross] -- [Estimate Expense Gross]
	,p.ApprovedCOHours as [CO Budget Hours] -- [Approved CO Hours]
	,p.ApprovedCOBudgetLabor as [CO Budget Labor Net] -- [Approved CO Labor Net]
	,p.ApprovedCOLabor as [CO Budget Labor Gross] -- [Approved CO Labor]
	,p.ApprovedCOBudgetExp as [CO Budget Expense Net] -- [Approved CO Expense Net]
	,p.ApprovedCOExpense as [CO Budget Expense Gross] -- [Approved CO Expense Gross]
	,p.EstHours + p.ApprovedCOHours as [Current Budget Hours] -- [Estimate Total Hours]
	,p.EstLabor + p.ApprovedCOLabor as [Current Budget Labor Gross] --[Estimate Total Labor]
	,p.EstExpenses + p.ApprovedCOExpense as [Current Budget Expense Gross] --[Estimate Total Gross Expense]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Current Total Budget wo Taxes] -- [Estimate Total]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense + ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) as [Current Total Budget] --[Total with Tax]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense - p.BudgetExpenses - p.BudgetLabor - p.ApprovedCOBudgetLabor - p.ApprovedCOBudgetExp  as [Estimate Profit] -- No change, not in report
	,p.PercComp as [Percentage Complete]
	,t.TeamName as [Project Team]
	-- Actual data
	,ISNULL(roll.Hours, 0) as [Actual Hours]
	,ISNULL(roll.LaborGross, 0) as [Labor Gross] -- [Actual Labor]
	,ISNULL(roll.LaborNet, 0) as [Labor Net]--[Actual Labor Cost]
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) as [Total Costs Gross wo Orders] -- [Actual Billable Expense] 
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) + ISNULL(roll.OrderPrebilled, 0)  as [Total Costs Gross] -- New field to match report
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) + ISNULL(roll.LaborGross, 0) as [Actual Gross Total]

	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net wo Orders] -- [Actual Net Expense]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net] -- New field!!!
	,ISNULL(roll.LaborWriteOff, 0) + ISNULL(roll.MiscCostWriteOff, 0) + ISNULL(roll.ExpReceiptWriteOff, 0) + ISNULL(roll.VoucherWriteOff, 0) as [Transaction Writeoff Amount] -- No change, not in report
	,ISNULL(roll.BilledAmount, 0) as [Amount Billed] -- No change same as report
	,ISNULL(roll.AdvanceBilled, 0) as [Amount Advance Billed] -- No change same as report 
	,ISNULL(roll.OpenOrderNet, 0) as [Open Orders Net] -- [Open Purchase Orders]
	,ISNULL(roll.OpenOrderGross, 0) as [Open Orders Gross Unbilled] -- New field!!! 
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) as [Total Gross Unbilled wo Orders] -- [Unbilled Total] 
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) as [Total Gross Unbilled] -- New field

	-- Comparisons
	,ISNULL(roll.LaborNet, 0) - ISNULL(p.BudgetLabor, 0) - ISNULL(p.ApprovedCOBudgetLabor, 0) as [Labor Variance Net]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) - ISNULL(p.BudgetExpenses, 0) - ISNULL(p.ApprovedCOBudgetExp, 0) as [Expense Variance Net]
	,ISNULL(roll.LaborGross, 0) - ISNULL(p.EstLabor, 0) - ISNULL(p.ApprovedCOLabor, 0) as [Labor Variance Gross]
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) - ISNULL(p.EstExpenses, 0) - ISNULL(p.ApprovedCOExpense, 0) as  [Expense Variance Gross]

	,CASE WHEN (p.EstHours + p.ApprovedCOHours) = 0 THEN ISNULL(roll.Hours, 0) * 100 ELSE ROUND(  (ISNULL(roll.Hours, 0) * 100) / (p.EstHours + p.ApprovedCOHours), 3) END as [Percent Actual vs Budget Hours]  
	,CASE WHEN (p.EstLabor + p.ApprovedCOLabor) = 0 THEN ISNULL(roll.LaborGross, 0) * 100 ELSE ROUND(  (ISNULL(roll.LaborGross, 0) * 100) / (p.EstLabor + p.ApprovedCOLabor), 3) END as [Percent Actual vs Budget Labor Gross]  
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,trs.RateSheetName as [Service Rate Sheet]
	,au.UserName as [Team Member]
	,parentCompany.CompanyName as [Parent Company Name]
	,Case cp.Active When 1 then 'YES' else 'NO' end as [Campaign Active]
	,p.ProjectKey
	,tt.TitleName as [Billing Title Name]
	,tt.TitleID as [Billing Title ID]
From
	tProject p (nolock)
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompany parentCompany (nolock) on cl.ParentCompanyKey = parentCompany.CompanyKey
	left outer join tUser bu (nolock) on p.BillingContact = bu.UserKey
	left outer join tUser cu (nolock) on p.CreatedByKey = cu.UserKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	left outer join tClientProduct cpr (nolock) on p.ClientProductKey = cpr.ClientProductKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tRequest pr (nolock) on pr.RequestKey = p.RequestKey
	left outer join vUserName kp1 (nolock) on p.KeyPeople1 = kp1.UserKey
	left outer join vUserName kp2 (nolock) on p.KeyPeople2 = kp2.UserKey
	left outer join vUserName kp3 (nolock) on p.KeyPeople3 = kp3.UserKey
	left outer join vUserName kp4 (nolock) on p.KeyPeople4 = kp4.UserKey
	left outer join vUserName kp5 (nolock) on p.KeyPeople5 = kp5.UserKey
	left outer join vUserName kp6 (nolock) on p.KeyPeople6 = kp6.UserKey
	left outer join tRetainer rn (nolock) on p.RetainerKey = rn.RetainerKey
	left outer join tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
	left outer join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join vUserName au (nolock) on a.UserKey = au.UserKey
	left outer join tTitle tt (nolock) on au.TitleKey = tt.TitleKey
	left outer join tTeam t (nolock) on p.TeamKey = t.TeamKey
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
GO
