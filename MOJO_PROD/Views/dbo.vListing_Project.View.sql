USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Project]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Project]
AS

  /*
  || When     Who Rel     What
  || 03/05/07 GHL 8.4     Added join with project rollup table to improve perfo           
  || 04/16/07 GHL 8.4     Added Actual Expense Net. Bug 8898       
  || 04/19/07 GHL 8.4     Corrected Get Markup From. Bug 8958    
  || 04/23/07 GWG 8.42    Added Parent Company on the client  
  || 04/27/07 CRG 8.5     Added Actual Project Total
  || 10/10/07 CRG 8.5     Added GLCompany, Class, and Office (OfficeID only, OfficeName was already there)     
  || 11/08/07 GHL 8.5     Synch'ed names with flash reports
  || 11/07/07 CRG 8.5     Added Client Billing Contact Email
  || 11/07/07 CRG 8.4.4.0 (15872) Added Service Rate Sheet
  || 11/20/07 GHL 8.5     Changed w/o Orders to wo Orders because this crashes the report engine
  || 11/28/07 GHL 8.5    (16797) Added Open Orders Gross + Net
  || 11/28/07 GHL 8.5    (16801) Added Last Task Due Date
  || 02/27/08 GHL 8.5    Added hint on index for CompanyKey
  || 10/16/08 GHL 10.011 (34827)(36763) Removed Orders from Total Costs
  || 11/17/08 GHL 10.013 (40529) Added Account Manager Active field
  || 03/17/09 RTC 10.5	  Removed user defined fields.
  || 08/25/09 GHL 10.508  (60402)Using now VoucherOutsideCostsGross in [Total Costs Gross wo Orders] rather than VoucherGross
  ||                      so that they are equal when orders prebilled = 0  
  || 08/25/09 GHL 10.508  (61462) Added roll.OpenOrderNet to [Total Costs Net]
  || 11/18/09 GWG 10.513  Added the custom field key from tCompany to include thier user defined fields.
  || 11/19/09 GWG 10.513  Added ISNULL(roll.AdvanceBilledOpen, 0) as [Amount Advance Billed Open]
  || 01/11/10 RLB 10.516  Added Billing Method (71832)
  || 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
  || 06/21/10 GHL 10.531 (83389) Modified [Total Gross Unbilled] to use OpenOrderUnbilled instead of OpenOrderGross
  ||                      Also removed OrderPrebilled from [Total Gross] because OpenOrderGross includes now prebilled orders
  || 08/15/10 GWG 10.533  Added task status and project perc comp for changes to the proto listing
  || 08/24/10 GWG 10.534  Added project color and plan start/complete as hidden fields
  || 11/15/10 GHL 10.538  (93504) Added OrderPrebilled to TotalGross
  || 02/08/11 RLB 10.541  (101805) Added Campaign Segment
  || 04/07/11 RLB 10.543 (108045) Removed Project Short Name
  || 04/22/11 RLB 10.543 (109178) Added Retainer Name
  || 07/27/11 RLB 10.546 (96614) Added Account Team
  || 09/08/11 GHL 10.548 Added Billed Amount wo Taxes
  || 09/21/11 RLB 10.548 (119193) Added Project Close Date to listing
  || 03/01/12 GHL 10.553 (135218) [Total Gross wo Orders] uses now VoucherOutsideCostsGross instead of VoucherGross
  || 03/07/12 GHL 10.554 (103259) Added [Opportunity Name]
  || 03/29/12 MFT 10.554 Added GLCompanyKey in order to map/restrict
  || 05/05/12 GWG 10.555 Added Requested By and Request Type
  || 08/17/12 RLB 10.559 (151960) Added Billing Group Code
  || 08/27/12 RLB 10.559 Added Schedule Status Color to match the ProjectTraffic View
  || 09/28/12 GHL 10.560 Getting now BillingGroupCode from tBillingGroup
  || 11/07/12 KMC 10.562 (158998) Added DoNotPostWIP
  || 12/14/12 WDF 10.563 (162624) Changed BillingMethod 'Fix Fee' to 'Fixed Fee'
  || 08/02/13 GHL 10.570 (185610) Added individual expense Gross amounts
  || 10/07/13 GHL 10.573  Added Currency info
  || 10/16/13 GWG 10.573 Added the max work date from tTime (request from Integer)
  || 03/31/14 GHL 10.578 (186315) Added Open Orders Gross Unbilled for On deck request
  || 09/26/14 WDF 10.584 (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
  || 10/15/14 WDF 10.585 (Abelson Taylor) Added Title Rate Sheet
  || 10/15/14 WDF 10.586 (228961) Added FinancialStatusImage
  || 12/16/14 RLB 10.587 (239555) Added Flight Start and End Dates as well as Flight Interval from project setup accounting
  || 1/15/15  GWG 10.588 Added Item Rate Sheet
  || 1/26/15  GHL 10.588 Added Biling Group Description for Abelson Taylor
  || 01/27/15 WDF 10.588 (Abelson Taylor) Added Division and Product ID
  || 04/05/15 GWG 10.590 Added Earliest Task Start Date
  */

Select
	 p.CompanyKey
	,p.ProjectKey
	,p.ClientKey
	,p.BillingContact
	,p.ProjectNumber
	,p.ProjectName
	,p.CustomFieldKey
	,cl.CustomFieldKey as CustomFieldKey2
	,ISNULL(p.TaskStatus, 1) as ProjectTaskStatus
	,Case p.TaskStatus When 1 then 'Green' When 2 then 'Yellow' When 3 then 'Red' else 'Green' end as [Schedule Status Color]
	,ISNULL(p.ProjectColor, '#000000') as ProjectColor
	,p.StartDate
	,p.CompleteDate
	,ISNULL(p.PercComp, 0) as [Progress]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,cl.CustomerID as [Client ID]
	,cl.CustomerID + ' - ' + cl.CompanyName  as [Client ID and Name]
	,cl.CompanyName as [Client Name]
	,pc.CompanyName as [Parent Company]
	,p.ClientProjectNumber [Client Project Number]
	,bu.FirstName + ' ' + bu.LastName as [Client Billing Contact]
	,bu.Email as [Client Billing Contact Email]
	,Case p.BillingMethod
		When 1 then 'Time and Materials'
		When 2 then 'Fixed Fee'
		When 3 then 'Retainer'
		end as [Billing Method]
	,Case p.GetRateFrom 
        when 9 then 'Billing Title'
        when 10 then 'Billing Title Rate Sheet'
		When 1 then 'Client'
		When 2 then 'Project'
		When 3 then 'Project User'
		When 4 then 'Service'
		When 5 then 'Service Rate Sheet'
		When 6 then 'Task'
		end as [Get Labor Rate From]
	,Case p.GetMarkupFrom 
		When 1 then 'Client'
		When 2 then 'Project'
		When 3 then 'Item'
		When 4 then 'Item Rate Sheet'
		When 5 then 'Task'
		end as [Get Markup From]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
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
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,p.CreatedDate as [Created Date]
	,p.ProjectCloseDate as [Project Close Date]
	,bg.BillingGroupCode as [Billing Group Code]
	,bg.Description as [Billing Group Description]
	,put.TeamName as [Account Team]
	,(SELECT MAX(t.PlanComplete) FROM tTask t (NOLOCK) WHERE t.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,(Select MIN(tTask.PlanStart) from tTask (nolock) Where tTask.ProjectKey = p.ProjectKey) as [Earliest Task Start Date]
	,CAST(p.Description AS VARCHAR(8000)) as [Project Description]
	,cu.FirstName + ' ' + cu.LastName as [Created By]
	,o.OfficeName as [Office]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
    ,Case am.Active When 1 then 'YES' else 'NO' end as [Account Manager Active]
	,u1.FirstName + ' ' + u1.LastName as [Key Person 1]
	,u2.FirstName + ' ' + u2.LastName as [Key Person 2]
	,u3.FirstName + ' ' + u3.LastName as [Key Person 3]
	,u4.FirstName + ' ' + u4.LastName as [Key Person 4]
	,u5.FirstName + ' ' + u5.LastName as [Key Person 5]
	,u6.FirstName + ' ' + u6.LastName as [Key Person 6]
	,cam.CampaignName as [Campaign Name]
	,cam.CampaignID as [Campaign ID]
	,cs.SegmentName as [Campaign Segment]
	,pr.RequestID as [Project Request ID]
	,pr.RequestedBy as [Project Requested By]
	,prd.RequestName as [Project Request Type]
	,p.FlightStartDate as [Flight Start Date]
	,p.FlightEndDate as [Flight End Date]
	,Case ISNULL(p.FlightInterval, 1) 
		When 1 then 'Daily'
		When 2 then 'Weekly'
		When 3 then 'Summary'
		else 'None'
		end as [Flight Interval]
	,rt.Title as [Retainer Name]
	,p.ClientNotes as [Client Notes]
	,Case p.DoNotPostWIP WHEN 1 THEN 'YES' ELSE 'NO' END as [Do Not Post WIP]
	,Case p.Template WHEN 1 THEN 'YES' ELSE 'NO' END as [Template Project]

	-- Budgeted data
	,p.EstHours as [Original Budget Hours] -- [Estimate Hours]
	,p.EstLabor as  [Original Budget Labor Gross] -- [Estimate Labor]
	,p.BudgetLabor as [Original Budget Labor Net]
	,p.BudgetExpenses as [Original Budget Expense Net] -- [Estimate Expense Net]
	,p.EstExpenses as [Original Budget Expense Gross] -- [Estimate Expense Gross]
	,p.ApprovedCOHours as [CO Budget Hours] -- [Approved CO Hours]
	,p.ApprovedCOLabor as [CO Budget Labor Gross] -- [Approved CO Labor]
	,p.ApprovedCOBudgetLabor as [CO Budget Labor Net]
	,p.ApprovedCOBudgetExp as [CO Budget Expense Net]-- [Approved CO Expense Net]
	,p.ApprovedCOExpense as [CO Budget Expense Gross]-- [Approved CO Expense Gross]
	,p.EstHours + p.ApprovedCOHours as [Current Budget Hours] -- [Estimate Total Hours]
	,p.EstLabor + p.ApprovedCOLabor as [Current Budget Labor Gross] -- [Estimate Total Labor]
	,p.EstExpenses + p.ApprovedCOExpense as [Current Budget Expense Gross] --[Estimate Total Gross Expense]
	,p.BudgetExpenses + p.ApprovedCOBudgetExp as [Current Budget Expense Net] --[Estimate Total Net Expense]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Current Total Budget wo Taxes] -- [Estimate Total]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense + ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) as [Current Total Budget] --New field
	,CASE 
		WHEN (p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) = 0 THEN 1
		WHEN (ISNULL(roll.LaborGross, 0) + ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) + ISNULL(roll.OpenOrderGross, 0) )  > 
				p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense THEN 3
		ELSE 1
		END AS FinancialStatusImage
	-- Actual data
	,ISNULL(roll.Hours, 0) as [Actual Hours]
	,ISNULL(roll.LaborGross, 0) as [Labor Gross] -- [Actual Labor]
	,ISNULL(roll.LaborNet, 0) as [Labor Net] --  [Actual Labor Cost]
	,ISNULL(roll.OpenOrderGross, 0) as [Open Orders Gross] 
	,ISNULL(roll.OpenOrderNet, 0) as [Open Orders Net] 
	,ISNULL(roll.OpenOrderUnbilled, 0) as [Open Orders Gross Unbilled]  
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) as [Total Costs Gross wo Orders] -- [Actual Billable Expense] 
    ,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) + ISNULL(roll.OrderPrebilled, 0)  as [Total Costs Gross] -- New field to match report
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net wo Orders] -- [Actual Net Expense]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) + ISNULL(roll.OpenOrderNet, 0) as [Total Costs Net] -- New field!!!
	,ISNULL(roll.LaborWriteOff, 0) + ISNULL(roll.MiscCostWriteOff, 0) + ISNULL(roll.ExpReceiptWriteOff, 0) + ISNULL(roll.VoucherWriteOff, 0) as [Transaction Writeoff Amount] -- No change, not in report
	,ISNULL(roll.BilledAmount, 0) as [Amount Billed]-- No change same as report
	,ISNULL(roll.BilledAmountNoTax, 0) as [Amount Billed wo Taxes]
	,ISNULL(roll.BilledAmountApproved, 0) as [Amount Billed Approved]
	,ISNULL(roll.AdvanceBilled, 0) as [Amount Advance Billed]-- No change same as report
	,ISNULL(roll.AdvanceBilledOpen, 0) as [Amount Advance Billed Open]
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) as [Total Gross Unbilled wo Orders] -- [Unbilled Total] 
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) + ISNULL(roll.OpenOrderUnbilled, 0) as [Total Gross Unbilled] -- New field

	,ISNULL(roll.LaborGross, 0) + ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) as [Total Gross wo Orders] --  [Actual Project Total]
	,ISNULL(roll.LaborGross, 0) + ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) + ISNULL(roll.OrderPrebilled, 0) + ISNULL(roll.OpenOrderUnbilled, 0) as [Total Gross]

	,ISNULL(roll.MiscCostGross, 0) as [Misc Cost Gross]
	,ISNULL(roll.ExpReceiptGross, 0) as [Expense Receipt Gross]
	,ISNULL(roll.VoucherGross, 0) as [Vendor Invoice Gross]
	
	,glc.GLCompanyKey
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,trs.RateSheetName as [Service Rate Sheet]
	,tirs.RateSheetName as [Title Rate Sheet]
	,irs.RateSheetName as [Item Rate Sheet]
	,l.Subject as [Opportunity Name]
	,p.CurrencyID as [Currency]
	,(Select Max(WorkDate) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Date of Last Time Entry]
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
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 0 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Billed]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) 
	  Where tTime.ProjectKey = p.ProjectKey and DateBilled is null) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and DateBilled is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and DateBilled is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and DateBilled is null) as [Unbilled Total]
             */

From
	tProject p with  (index=IX_tProject, nolock)
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompany pc (nolock) on cl.ParentCompanyKey = pc.CompanyKey
	left outer join tCampaign cam (nolock) on p.CampaignKey = cam.CampaignKey
	left outer join tUser bu (nolock) on p.BillingContact = bu.UserKey
	left outer join tUser cu (nolock) on p.CreatedByKey = cu.UserKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	left outer join tClientProduct cpr (nolock) on p.ClientProductKey = cpr.ClientProductKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tUser u1 (nolock) on p.KeyPeople1 = u1.UserKey
	left outer join tUser u2 (nolock) on p.KeyPeople2 = u2.UserKey
	left outer join tUser u3 (nolock) on p.KeyPeople3 = u3.UserKey
	left outer join tUser u4 (nolock) on p.KeyPeople4 = u4.UserKey
	left outer join tUser u5 (nolock) on p.KeyPeople5 = u5.UserKey
	left outer join tUser u6 (nolock) on p.KeyPeople6 = u6.UserKey
	left outer join tRequest pr (nolock) on pr.RequestKey = p.RequestKey
	left outer join tRequestDef prd (nolock) on pr.RequestDefKey = prd.RequestDefKey
	left outer join tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
	left outer join tTitleRateSheet tirs (nolock) on p.TitleRateSheetKey = tirs.TitleRateSheetKey
	left outer join tItemRateSheet irs (nolock) on p.ItemRateSheetKey = irs.ItemRateSheetKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey
	left outer join tRetainer rt (nolock) on p.RetainerKey = rt.RetainerKey
	left outer join tTeam put (nolock) on p.TeamKey = put.TeamKey
	left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
GO
