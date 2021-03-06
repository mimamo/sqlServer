USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ProjectByItemTitle]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vReport_ProjectByItemTitle]
AS

/*
|| When      Who Rel     What
|| 01/30/15  GHL 10.588 (Abelson Taylor) Cloned vReport_ProjectByItem for titles
*/

SELECT	v.CompanyKey
       , p.GLCompanyKey
		,v.Entity
		,v.EntityKey
		,v.ProjectKey
		,p.CustomFieldKey
		,p.ProjectName AS [Project Name]
		,p.ProjectNumber as [Project Number]
		,cl.CompanyName as [Client Name]
		,cl.CustomerID as [Client ID]
		,cl.CustomerID + '-' + cl.CompanyName as [Client Full Name]
		,p.ClientProjectNumber [Client Project Number]
		,ps.ProjectStatus as [Project Status]
		,pbs.ProjectBillingStatus as [Project Billing Status]
		,ISNULL(pt.ProjectTypeName, '') as [Project Type]
		,p.StatusNotes as [Project Status Note]
		,p.DetailedNotes as [Project Status Description]
		,ISNULL(am.FirstName, '') + ' ' + ISNULL(am.LastName, '') as [Account Manager]
		,cp.CampaignName as [Campaign Name]
		,cp.CampaignID as [Campaign ID]
		,cp.CampaignID + '-' + cp.CampaignName as [Campaign Full Name]
		,cs.SegmentName as [Campaign Segment]
		,Case p.Active When 1 then 'YES' else 'NO' end as [Active]
		,p.StartDate as [Project Start Date]
		,p.CompleteDate as [Project Due Date]
		,p.ProjectCloseDate as [Project Close Date]
		,p.CreatedDate as [Created Date]
		,Case p.BillingMethod 
			When 1 then 'Time and Materials'
			When 2 then 'Fixed Fee'
			When 3 then 'Retainer'
			end as [Billing Method]
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
		,u.FirstName + ' ' + u.LastName as [Primary Contact]
		,o.OfficeName as [Office]
		,v.ItemID AS [Item Title ID]
		,v.ItemName AS [Item Name]
	
		,CASE WHEN v.Entity = 'tTitle' THEN ebi.Qty ELSE 0 END AS [Original Budget Hours]
		,CASE WHEN v.Entity = 'tTitle' THEN ebi.Net ELSE 0 END AS [Original Budget Net Labor]
		,CASE WHEN v.Entity = 'tTitle' THEN ebi.Gross ELSE 0 END AS [Original Budget Gross Labor]
		,CASE WHEN v.Entity = 'tItem' THEN ebi.Net ELSE 0 END AS [Original Budget Net Expense]
		,CASE WHEN v.Entity = 'tItem' THEN ebi.Gross ELSE 0 END AS [Original Budget Gross Expense]

		,CASE WHEN v.Entity = 'tTitle' THEN ebi.COQty ELSE 0 END AS [Approved Change Order Hours]
		,CASE WHEN v.Entity = 'tTitle' THEN ebi.CONet ELSE 0 END AS [Approved Change Order Net Labor]
		,CASE WHEN v.Entity = 'tTitle' THEN ebi.COGross ELSE 0 END AS [Approved Change Order Gross Labor]
		,CASE WHEN v.Entity = 'tItem' THEN ebi.CONet ELSE 0 END AS [Approved Change Order Net Expense]
		,CASE WHEN v.Entity = 'tItem' THEN ebi.COGross ELSE 0 END AS [Approved Change Order Gross Expense]
		
		,CASE WHEN v.Entity = 'tTitle' THEN ISNULL(ebi.Qty, 0) + ISNULL(ebi.COQty, 0) ELSE 0 END AS [Current Budget Hours]
		,CASE WHEN v.Entity = 'tTitle' THEN ISNULL(ebi.Net, 0) + ISNULL(ebi.CONet, 0) ELSE 0 END AS [Current Budget Net Labor]
		,CASE WHEN v.Entity = 'tTitle' THEN ISNULL(ebi.Gross, 0) + ISNULL(ebi.COGross, 0) ELSE 0 END AS [Current Budget Gross Labor]
		,CASE WHEN v.Entity = 'tItem' THEN ISNULL(ebi.Net, 0) + ISNULL(ebi.CONet, 0) ELSE 0 END AS [Current Budget Net Expense]
		,CASE WHEN v.Entity = 'tItem' THEN ISNULL(ebi.Gross, 0) + ISNULL(ebi.COGross, 0) ELSE 0 END AS [Current Budget Gross Expense]

		,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.TitleKey = v.EntityKey AND v.Entity = 'tTitle' AND tTime.ProjectKey = v.ProjectKey) as [Actual Hours]
		,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.TitleKey = v.EntityKey AND v.Entity = 'tTitle' AND tTime.ProjectKey = v.ProjectKey) as [Actual Labor]
		,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.TitleKey = v.EntityKey AND v.Entity = 'tTitle' AND tTime.ProjectKey = v.ProjectKey) as [Actual Labor Cost]
		,(Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ItemKey = v.EntityKey AND v.Entity = 'tItem' AND tMiscCost.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ItemKey = v.EntityKey AND v.Entity = 'tItem' And tExpenseReceipt.VoucherDetailKey is null AND tExpenseReceipt.ProjectKey = v.ProjectKey ) + 
		 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ItemKey = v.EntityKey AND v.Entity = 'tItem' AND tVoucherDetail.ProjectKey = v.ProjectKey) as [Actual Net Expense]
		,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.TitleKey = v.EntityKey AND v.Entity = 'tTitle' AND tTime.ProjectKey = v.ProjectKey) +
		 (Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ItemKey = v.EntityKey AND v.Entity = 'tItem' AND tMiscCost.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ItemKey = v.EntityKey AND v.Entity = 'tItem' And tExpenseReceipt.VoucherDetailKey is null AND tExpenseReceipt.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ItemKey = v.EntityKey AND v.Entity = 'tItem' AND tVoucherDetail.ProjectKey = v.ProjectKey) as [Actual Total]	
		,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ItemKey = v.EntityKey AND v.Entity = 'tItem' AND tMiscCost.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ItemKey = v.EntityKey AND v.Entity = 'tItem' And tExpenseReceipt.VoucherDetailKey is null AND tExpenseReceipt.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(BillableCost), 0) from tPurchaseOrderDetail (nolock) Where tPurchaseOrderDetail.ItemKey = v.EntityKey AND v.Entity = 'tItem' And tPurchaseOrderDetail.InvoiceLineKey > 0 AND tPurchaseOrderDetail.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ItemKey =v.EntityKey AND v.Entity = 'tItem' AND tVoucherDetail.ProjectKey = v.ProjectKey) as [Actual Billable Expense]
		,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.TitleKey = v.EntityKey AND v.Entity = 'tTitle' and WriteOff = 1 AND tTime.ProjectKey = v.ProjectKey) +
		 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ItemKey = v.EntityKey AND v.Entity = 'tItem' and WriteOff = 1 AND tMiscCost.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ItemKey = v.EntityKey AND v.Entity = 'tItem' And tExpenseReceipt.VoucherDetailKey is null and WriteOff = 1 AND tExpenseReceipt.ProjectKey = v.ProjectKey) + 
		 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ItemKey = v.EntityKey AND v.Entity = 'tItem' and WriteOff = 1 AND tVoucherDetail.ProjectKey = v.ProjectKey) as [Transaction Writeoff Amount]
		,(Select ISNULL(Sum(Amount), 0) from tInvoiceSummary (nolock) inner join tInvoice (nolock) on tInvoiceSummary.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 0 and tInvoiceSummary.Entity = v.Entity collate database_default AND tInvoiceSummary.EntityKey = v.EntityKey AND tInvoiceSummary.ProjectKey = v.ProjectKey) as [Amount Billed]
		,(Select ISNULL(Sum(Amount), 0) from tInvoiceSummary (nolock) inner join tInvoice (nolock) on tInvoiceSummary.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceSummary.Entity = v.Entity collate database_default AND tInvoiceSummary.EntityKey = v.EntityKey AND tInvoiceSummary.ProjectKey = v.ProjectKey) as [Amount Advance Billed]
		,(Select Sum(ISNULL(TotalCost, 0) - ISNULL(AppliedCost, 0)) 
				from tPurchaseOrderDetail (nolock) 
				inner join tPurchaseOrder (nolock) on tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey
			 	Where tPurchaseOrderDetail.ItemKey = v.EntityKey 
				AND v.Entity = 'tItem'
				AND tPurchaseOrderDetail.ProjectKey = v.ProjectKey
				and tPurchaseOrderDetail.Closed = 0) as [Open Purchase Orders]
		,glc.GLCompanyID as [Company ID]
		,glc.GLCompanyName as [Company Name]
		,cla.ClassID as [Class ID]
		,cla.ClassName as [Class Name]
        ,case when p.LayoutKey is not null then wt.WorkTypeID 
		      else 
                  case when v.Entity = 'tItem' then wti.WorkTypeID else wts.WorkTypeID end 
         end as [Billing Item ID] 
        ,case when p.LayoutKey is not null then isnull(wtcust.Subject, wt.WorkTypeName) 
		      else 
                  case when v.Entity = 'tItem' then isnull(wtcusti.Subject, wti.WorkTypeName) else isnull(wtcusts.Subject, wts.WorkTypeName) end 
         end as [Billing Item Name] 
        ,l.Subject as [Opportunity Name]
        ,case v.Entity
           when 'tItem' then dpt.DepartmentName
           else dpt2.DepartmentName
         end as [Department Name]
FROM	vProject_ItemsTitles v
INNER JOIN tProject p (nolock) ON v.ProjectKey = p.ProjectKey
INNER JOIN tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
LEFT JOIN vProjectEstByItemTitle ebi (nolock) ON v.ProjectKey = ebi.ProjectKey AND v.Entity = ebi.Entity collate database_default AND v.EntityKey = ebi.EntityKey
LEFT JOIN tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
LEFT JOIN tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
LEFT JOIN tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
LEFT JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
LEFT JOIN tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
LEFT JOIN vUserName kp1 (nolock) on p.KeyPeople1 = kp1.UserKey
LEFT JOIN vUserName kp2 (nolock) on p.KeyPeople2 = kp2.UserKey
LEFT JOIN vUserName kp3 (nolock) on p.KeyPeople3 = kp3.UserKey
LEFT JOIN vUserName kp4 (nolock) on p.KeyPeople4 = kp4.UserKey
LEFT JOIN vUserName kp5 (nolock) on p.KeyPeople5 = kp5.UserKey
LEFT JOIN vUserName kp6 (nolock) on p.KeyPeople6 = kp6.UserKey
LEFT JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
LEFT JOIN tClientProduct pd (nolock) on p.ClientProductKey = pd.ClientProductKey
LEFT JOIN tClass cla (nolock) on p.ClassKey = cla.ClassKey
LEFT JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey

left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity collate database_default = v.Entity and lb.EntityKey = v.EntityKey
left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

left outer join tItem it (nolock) on v.Entity = 'tItem' and v.EntityKey = it.ItemKey
left outer join tDepartment dpt (nolock) on it.DepartmentKey = dpt.DepartmentKey
left outer join tWorkType wti (nolock) on it.WorkTypeKey = wti.WorkTypeKey 
left outer join tWorkTypeCustom wtcusti (nolock) on it.WorkTypeKey = wtcusti.WorkTypeKey and wtcusti.Entity = 'tProject' and wtcusti.EntityKey = p.ProjectKey

left outer join tTitle s (nolock) on v.Entity = 'tTitle' and v.EntityKey = s.TitleKey
left outer join tDepartment dpt2 (nolock) on s.DepartmentKey = dpt2.DepartmentKey
left outer join tWorkType wts (nolock) on s.WorkTypeKey = wts.WorkTypeKey 
left outer join tWorkTypeCustom wtcusts (nolock) on s.WorkTypeKey = wtcusts.WorkTypeKey and wtcusts.Entity = 'tProject' and wtcusts.EntityKey = p.ProjectKey

left outer join tUser u (nolock) on p.BillingContact = u.UserKey
left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey
left outer join tUser am (nolock) on p.AccountManager = am.UserKey
left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
GO
