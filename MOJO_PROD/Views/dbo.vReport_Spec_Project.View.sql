USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Spec_Project]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel     What
  || 07/10/07 GHL  8.5     Added restriction on ERs
  || 04/07/11 RLB 10.5.4.3 (108045) Removed Project Short Name
  || 09/21/11 RLB 10.5.4.8 (119193) Added Project Close Date 
  || 03/07/12 GHL 10.5.5.4 (103259) Added [Opportunity Name]
  || 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
  || 07/01/13 WDF 10.5.6.9 (181053) Added Project Level custom fields
  || 09/26/14 WDF 10.5.8.4 (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
  || 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
  */


CREATE  View [dbo].[vReport_Spec_Project]

As

Select
	 p.CompanyKey
	,ss.CustomFieldKey
	,p.CustomFieldKey as CustomFieldKey2
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,cl.CompanyName as [Client Name]
	,p.ClientProjectNumber [Client Project Number]
	,bu.FirstName + ' ' + bu.LastName as [Client Billing Contact]
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
	,Case NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,Case Closed When 1 then 'YES' else 'NO' end as [Closed Project]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,pt.ProjectTypeName as [Project Type]
	,p.StatusNotes as [Project Status Note]
	,p.DetailedNotes as [Project Status Description]
	,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Due Date]
	,p.CreatedDate as [Created Date]
	,p.ProjectCloseDate as [Project Close Date]
	,cu.FirstName + ' ' + cu.LastName as [Created By]
	,o.OfficeName as [Office]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,p.EstHours as [Estimate Hours]
	,p.EstLabor as [Estimate Labor]
	,p.BudgetExpenses as [Estimate Expense Net]
	,p.EstExpenses as [Estimate Expense Gross]
	,p.ApprovedCOHours as [Approved CO Hours]
	,p.ApprovedCOLabor as [Approved CO Labor]
	,p.ApprovedCOExpense as [Approved CO Expense Gross]
	,p.EstHours + p.ApprovedCOHours as [Estimate Total Hours]
	,p.EstLabor + p.ApprovedCOLabor as [Estimate Total Labor]
	,p.EstExpenses + p.ApprovedCOExpense as [Estimate Total Gross Expense]
	,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Estimate Total]
	,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Hours]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor Cost]
	,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and tExpenseReceipt.VoucherDetailKey is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Billable Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey and WriteOff = 1) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and tExpenseReceipt.VoucherDetailKey is null and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and WriteOff = 1) as [Transaction Writeoff Amount]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 0 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Billed]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed]
	,ss.Subject as [Spec Sheet Subject]
	,ss.Description as [Spec Sheet Description]
	,ss.DisplayOrder as [Spec Sheet Display Order]
	,fs.FieldSetName as [Spec Sheet Type]
	,l.Subject as [Opportunity Name]
	,p.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
From
	tProject p (nolock)
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tUser bu (nolock) on p.BillingContact = bu.UserKey
	left outer join tUser cu (nolock) on p.CreatedByKey = cu.UserKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	inner join (Select * from tSpecSheet (nolock) Where Entity = 'Project') as ss on p.ProjectKey = ss.EntityKey
	inner join tFieldSet fs (nolock) on ss.FieldSetKey = fs.FieldSetKey
	left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
