USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Project]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Project]
AS

/*
|| When     Who Rel     What
|| 10/12/06 WES 8.3567  Added Retainer Name
|| 02/12/07 GWG 8.4004  Added Billing Contact email and phone
|| 04/04/07 GWG 8.5     Added Client ID and full name
|| 04/04/07 GHL 8.411   Using now tProjectRollup to improve performance
|| 04/04/07 GHL 8.42    Added % Actual vs Budget Hours & Labor Gross
|| 05/16/07 GHL  8.421  Added Percentage Complete
|| 07/20/07 GWG 8.432   Modified the variances to include change orders
|| 10/11/07 CRG 8.5     Added GLCompany and Class
|| 11/07/07 GHL 8.5     Corrected  [Labor Variance Net]
|| 11/08/07 GHL 8.5     Synch'ed names with flash reports
|| 11/07/07 CRG 8.5     (9759) Added Actual Gross Total
|| 11/07/07 CRG 8.4.4.0 (15872) Added Service Rate Sheet
|| 11/20/07 GHL 8.5     Changed w/o Orders to wo Orders because this crashes the report engine
|| 11/28/07 GHL 8.5    (16801) Added Last Task Due Date
|| 10/16/08 GHL 10.011 (34827)(36763) Removed Orders from Total Costs
|| 02/03/09 MAS 10.0.1.8 (43997) Added the LaborUnbilled column
|| 02/20/09 GHL 10.0.1.9 (44636) Added Open Amount of Adv Bill column
|| 03/17/09 RTC 10.5	  Removed user defined fields.
|| 05/15/09 GHL 10.0.1.5 (52321) Added Campaign summary data
||                       Users can then compare project data vs campaign data  
|| 06/12/09 MAS 10.0.1.7 (54233) Added Campaign CustomField
|| 07/09/09 GHL 10.504 (56867) Added Billed Amount without tax  
|| 09/15/09 GHL 10.510 (63067) Added Project Full Name
|| 10/6/09  CRG 10.5.1.2 (64424) Added Parent Company Name and Parent Active
|| 10/22/09 GHL 10.5.1.3 (66272) Added Adv Bill w/o Tax
|| 11/04/09 GHL 10.5.1.3 (67443) Added Adv Bill Open
|| 12/22/09 GHL 10.5.1.5  Added GetMarkupFrom
|| 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
|| 04/14/10 RLB 10.521  (40446) Added Company Type
|| 07/30/10 RLB 10.533  Added Inside Cost Gross Unbilled and Outside Cost Gross Unbilled 
|| 02/01/11 RLB 10.541  Added campaign segment
|| 04/07/11 RLB 10.543 (108045) Removed Project Short Name
|| 08/30/11 RLB 10.547  (118280) Added Campaign Full Name and Campaign ID
|| 09/21/11 RLB 10.548 (119193) Added Project Close Date 
|| 03/07/12 GHL 10.554 (103259) Added [Opportunity Name]
|| 04/24/12 GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 08/17/12 RLB 10.559 (151960) Added Billing Group Code
|| 09/28/12 GHL 10.560 Getting now BillingGroupCode from tBillingGroup
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 11/07/12 KMC 10.562 (158998) Added DoNotPostWIP
|| 03/06/13 GHL 10.566 (167702) Added Expense WO and Labor WO
|| 04/09/13 GHL 10.566 (174154) Changed Open Order Unbilled to tProjectRollup.OpenOrderUnbilled
||                      rather than OpenOrderGross
|| 08/02/13 GHL 10.570 (185610) Added individual expense Gross amounts
|| 09/26/14 WDF 10.584 (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
|| 10/15/14 WDF 10.585 (Abelson Taylor) Added Title Rate Sheet
|| 01/27/15 WDF 10.588 (Abelson Taylor) Added Division and Product ID
|| 01/26/15 GHL 10.588 Added Billing Group Description for Abelson Taylor
*/

Select
	 p.CompanyKey
	,p.GLCompanyKey
	,p.CustomFieldKey
	,cp.CustomFieldKey as CustomFieldKey2
	,rn.Title as [Retainer Name]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
    ,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
 	,kp1.UserName as [Key People 1]
	,kp2.UserName as [Key People 2]
	,kp3.UserName as [Key People 3]
	,kp4.UserName as [Key People 4]
	,kp5.UserName as [Key People 5]
	,kp6.UserName as [Key People 6]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID as [Client ID]
	,cl.CustomerID + ' - ' + cl.CompanyName as [Client Full Name]
	,ct.CompanyTypeName as [Company Type]
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
     ,Case p.GetMarkupFrom 
		When 1 then 'Client'
		When 2 then 'Project'
		When 3 then 'Item'
		When 4 then 'Item Rate Sheet'
		When 5 then 'Task'
		end as [Get Expense Rate From]
	,Case p.BillingMethod 
		When 1 then 'Time and Materials'
		When 2 then 'Fixed Fee'
		When 3 then 'Retainer'
		end as [Billing Method]
	,Case NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,Case Closed When 1 then 'YES' else 'NO' end as [Closed Project]
	,Case ISNULL(cp.MultipleSegments, 0) When 1 then 'YES' else 'NO' end as [Contains Segments]
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
	,(SELECT MAX(t.PlanComplete) FROM tTask t (NOLOCK) WHERE t.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,p.CreatedDate as [Created Date]
	,p.ProjectCloseDate as [Project Close Date]
	,bg.BillingGroupCode as [Billing Group Code]
	,bg.Description as [Billing Group Description]
	,cu.FirstName + ' ' + cu.LastName as [Created By]
	,o.OfficeName as [Office]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,cp.CampaignName as [Campaign Name]
	,cp.CampaignID as [Campaign ID]
	,cp.CampaignID + '-' + cp.CampaignName as [Campaign Full Name]
	,cs.SegmentName as [Campaign Segment]
	,pr.RequestID as [Project Request ID]
	,Case p.DoNotPostWIP WHEN 1 THEN 'YES' ELSE 'NO' END as [Do Not Post WIP]

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

	-- Actual data
	,ISNULL(roll.Hours, 0) as [Actual Hours]
	,ISNULL(roll.LaborGross, 0) as [Labor Gross] -- [Actual Labor]
	,ISNULL(roll.LaborNet, 0) as [Labor Net]--[Actual Labor Cost]
	,ISNULL(roll.LaborUnbilled, 0) as [Labor Unbilled]
	,ISNULL(roll.VoucherUnbilled, 0) as [Outside Costs Gross Unbilled]
	,ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) as [Inside Costs Gross Unbilled]
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) as [Total Costs Gross wo Orders] -- [Actual Billable Expense] 
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherOutsideCostsGross, 0) + ISNULL(roll.OrderPrebilled, 0)  as [Total Costs Gross] -- New field to match report
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) + ISNULL(roll.LaborGross, 0) as [Actual Gross Total]

	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net wo Orders] -- [Actual Net Expense]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) as [Total Costs Net] -- New field!!!
	,ISNULL(roll.LaborWriteOff, 0) + ISNULL(roll.MiscCostWriteOff, 0) + ISNULL(roll.ExpReceiptWriteOff, 0) + ISNULL(roll.VoucherWriteOff, 0) as [Transaction Writeoff Amount] -- No change, not in report
	,ISNULL(roll.MiscCostWriteOff, 0) + ISNULL(roll.ExpReceiptWriteOff, 0) + ISNULL(roll.VoucherWriteOff, 0) as [Expense Writeoff Amount] 
	,ISNULL(roll.LaborWriteOff, 0) as [Labor Writeoff Amount]  
	,ISNULL(roll.BilledAmount, 0) as [Amount Billed] -- No change same as report
	,ISNULL(roll.BilledAmountApproved, 0) as [Amount Billed Approved] 
	,ISNULL(roll.BilledAmountNoTax, 0) as [Amount Billed wo Tax] 
	,ISNULL(roll.AdvanceBilled, 0) as [Amount Advance Billed] -- No change same as report 
    ,ISNULL(roll.AdvanceBilledOpen, 0) as [Amount Advance Billed Open]  
	,ISNULL(roll.OpenOrderNet, 0) as [Open Orders Net] -- [Open Purchase Orders]
	,ISNULL(roll.OpenOrderUnbilled, 0) as [Open Orders Gross Unbilled] -- New field!!! 
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) as [Total Gross Unbilled wo Orders] -- [Unbilled Total] 
	,ISNULL(roll.LaborUnbilled, 0) + ISNULL(roll.MiscCostUnbilled, 0) + ISNULL(roll.ExpReceiptUnbilled, 0) + ISNULL(roll.VoucherUnbilled, 0) as [Total Gross Unbilled] -- New field

	-- Comparisons
	,ISNULL(roll.LaborNet, 0) - ISNULL(p.BudgetLabor, 0) - ISNULL(p.ApprovedCOBudgetLabor, 0) as [Labor Variance Net]
	,ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0) - ISNULL(p.BudgetExpenses, 0) - ISNULL(p.ApprovedCOBudgetExp, 0) as [Expense Variance Net]
	,ISNULL(roll.LaborGross, 0) - ISNULL(p.EstLabor, 0) - ISNULL(p.ApprovedCOLabor, 0) as [Labor Variance Gross]
	,ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0) - ISNULL(p.EstExpenses, 0) - ISNULL(p.ApprovedCOExpense, 0) as  [Expense Variance Gross]

	,ISNULL(roll.OpenOrderGross, 0) as [Open Orders Gross] 
	,ISNULL(roll.MiscCostGross, 0) as [Misc Cost Gross]
	,ISNULL(roll.ExpReceiptGross, 0) as [Expense Receipt Gross]
	,ISNULL(roll.VoucherGross, 0) as [Vendor Invoice Gross]
	
	,CASE WHEN (p.EstHours + p.ApprovedCOHours) = 0 THEN ISNULL(roll.Hours, 0) * 100 ELSE ROUND(  (ISNULL(roll.Hours, 0) * 100) / (p.EstHours + p.ApprovedCOHours), 3) END as [Percent Actual vs Budget Hours]  
	,CASE WHEN (p.EstLabor + p.ApprovedCOLabor) = 0 THEN ISNULL(roll.LaborGross, 0) * 100 ELSE ROUND(  (ISNULL(roll.LaborGross, 0) * 100) / (p.EstLabor + p.ApprovedCOLabor), 3) END as [Percent Actual vs Budget Labor Gross]  
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,trs.RateSheetName as [Service Rate Sheet]
	,tirs.RateSheetName as [Title Rate Sheet]
    ,ISNULL((
		SELECT SUM(ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0)
				- ISNULL(i.WriteoffAmount, 0) - ISNULL(i.DiscountAmount, 0) )
		FROM tInvoice i (NOLOCK)
		WHERE i.ProjectKey = p.ProjectKey
		AND i.AdvanceBill = 1
	),0) as [Open Amount of Adv Bill]

	,ISNULL((
		SELECT SUM(isum.Amount) -- i.e. do not take isum.SalesTaxAmount
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 1
		AND   isum.ProjectKey = p.ProjectKey
	), 0) as [Amount Advance Billed wo Tax]

	-- campaign summary
	,vcs.BudgetHours as [Campaign Budget Hours]
	,vcs.BudgetLabor as [Campaign Budget Labor]
	,vcs.BudgetExpenseNet as [Campaign Budget Expense Net]
	,vcs.BudgetExpenseGross as [Campaign Budget Expense Gross]
	,vcs.ActualExpenseNet as [Campaign Actual Expense Net]
	,vcs.ActualExpenseGross as [Campaign Actual Expense Gross]
	,vcs.OpenOrdersNet as [Campaign Open Orders Net]
	,vcs.OpenOrdersGross as [Campaign Open Orders Gross]

	,parentCompany.CompanyName as [Parent Company Name]
	,Case cp.Active When 1 then 'YES' else 'NO' end as [Campaign Active]
	,l.Subject as [Opportunity Name]
	,p.ProjectKey
/*
	,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Hours]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor Cost]
	,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Billable Expense]
	,(Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Net Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey and WriteOff = 1) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and WriteOff = 1) as [Transaction Writeoff Amount]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 0 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Billed]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed]
	,(Select Sum(ISNULL(TotalCost, 0) - ISNULL(AppliedCost, 0)) from tPurchaseOrderDetail (nolock) inner join tPurchaseOrder (nolock) on tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey
		 Where tPurchaseOrderDetail.ProjectKey = p.ProjectKey and tPurchaseOrderDetail.Closed = 0) as [Open Purchase Orders]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) 
	  Where tTime.ProjectKey = p.ProjectKey and DateBilled is null) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and DateBilled is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and DateBilled is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and DateBilled is null) as [Unbilled Total]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) - ISNULL(p.BudgetLabor, 0) as [Labor Variance Net]
	,((Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey)) - ISNULL(p.BudgetExpenses, 0) as [Expense Variance Net]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) - ISNULL(p.EstLabor, 0) as [Labor Variance Gross]
	,((Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey)) - ISNULL(p.EstExpenses, 0) as [Expense Variance Gross]
*/

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
	left outer join tTitleRateSheet tirs (nolock) on p.TitleRateSheetKey = tirs.TitleRateSheetKey
    left outer join vCampaignSummary vcs (nolock) on p.CampaignKey = vcs.CampaignKey
	left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
GO
