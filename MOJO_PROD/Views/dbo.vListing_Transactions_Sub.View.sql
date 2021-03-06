USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Transactions_Sub]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Transactions_Sub]
as

/*
|| When     Who Rel     What
|| 09/18/13 GWG 10.5.7.2 Works as the underlying data for vListing_Transaction and [vListing_ProjectTransactions]
|| 01/21/15 GHL 10.5.8.8 For Abelson Taylor, added Adjustment Type + Title
|| 04/14/15 RLB 10.5.9.1 (253333) For vouchers only pull detail expense account first
|| 04/15/15 RLB 10.5.9.1 (253333) added a new field call SourceDescription which matches the old transaction screen data wise
*/

Select
	'LABOR' as Type
	,ts.CompanyKey
	,case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey
	,t.TimeSheetKey as ParentKey
	,t.ProjectKey
	,t.TaskKey
    ,t.ServiceKey as ItemKey
	,s.ServiceCode as ItemID
	,s.Description as ItemName
	,ActualHours as Quantity
	,ActualRate as UnitCost
	,ROUND(ActualHours * ActualRate, 2) as TotalCost
	,ROUND(ActualHours * ActualRate, 2) as BillableCost
	,ROUND(BilledHours * BilledRate, 2) as AmountBilled
	,u.FirstName + ' ' + u.LastName COLLATE LATIN1_GENERAL_CI_AS as Description
	,t.WorkDate as TransactionDate
	,t.InvoiceLineKey
	,t.WriteOff
	,ts.Status
	,WIPPostingInKey
	,WIPPostingOutKey
	,t.OnHold
	,t.WriteOffReasonKey
	,t.Comments as Comments
	,ROUND(t.ActualRate * t.ActualHours, 2) - ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0) as BilledDifference
	,NULL as GLAccountKey
	,t.DateBilled
	,t.TransferComment
	,t.CostRate
	,s.ClassKey
	,t.TimeKey AS UIDTranKey
	,NULL AS TranKey
    ,NULL AS TranNumber
	,NULL AS VendorKey
	,d.DepartmentName
    ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByUser
	,t.TransferToKey AS UIDTransferToKey
    ,NULL AS TransferToKey
    ,wt.WorkTypeID
    ,isnull(wtcust.Subject, wt.WorkTypeName) as WorkTypeName
    ,t.TransferInDate
    ,t.TransferOutDate
    ,t.IsAdjustment as AdjustmentType
    ,t.TitleKey
    ,tt.TitleName
    ,tt.TitleID
    ,u.FirstName + ' ' + u.LastName COLLATE LATIN1_GENERAL_CI_AS as SourceDescription
from 
	tTime t (nolock)
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
	left outer join tWorkType wt (nolock) on s.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on s.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = t.ProjectKey
	LEFT JOIN tDepartment d (nolock) on s.DepartmentKey = d.DepartmentKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tTitle tt (nolock) on t.TitleKey = tt.TitleKey

Union ALL

Select
	'EXPRPT' as Type
	,ee.CompanyKey
	,case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey
	,er.ExpenseEnvelopeKey as ParentKey
	,er.ProjectKey
	,er.TaskKey
	,er.ItemKey 
	,i.ItemID
	,i.ItemName
	,er.ActualQty as Quantity
	,er.ActualUnitCost as UnitCost
	,er.ActualCost as TotalCost
	,er.BillableCost as BillableCost
	,er.AmountBilled
	,er.Description COLLATE LATIN1_GENERAL_CI_AS as Description
	,er.ExpenseDate as TransactionDate
	,er.InvoiceLineKey
	,er.WriteOff
	,ee.Status
	,WIPPostingInKey
	,WIPPostingOutKey
	,er.OnHold
	,er.WriteOffReasonKey
	,er.Comments as Comments
	,NULL
	,i.ExpenseAccountKey AS ExpenseGLAccountKey
	,er.DateBilled
	,er.TransferComment
	,NULL
	,i.ClassKey
	,NULL AS UIDTranKey
	,er.ExpenseReceiptKey AS TranKey
    ,ee.EnvelopeNumber AS TranNumber
	,ee.VendorKey
	,d.DepartmentName
    ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByUser
    ,NULL AS UIDTransferToKey
	,er.TransferToKey AS TransferToKey
    ,wt.WorkTypeID
    ,isnull(wtcust.Subject, wt.WorkTypeName)
    ,er.TransferInDate
    ,er.TransferOutDate
    ,er.AdjustmentType as AdjustmentType
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
    ,'Person: ' + u.FirstName + ' ' + u.LastName + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description  as SourceDescription
from
	tExpenseReceipt er (nolock)
	inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on i.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = er.ProjectKey
	LEFT JOIN tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey
    left outer join tUser u (nolock) on ee.UserKey = u.UserKey
    left outer join tProject p (nolock) on er.ProjectKey = p.ProjectKey

where   er.VoucherDetailKey is null

Union ALL

Select
	'MISCCOST' as Type
	,p.CompanyKey
	,p.GLCompanyKey
	,mc.MiscCostKey as ParentKey
	,mc.ProjectKey
	,mc.TaskKey
	,mc.ItemKey 
	,i.ItemID
	,i.ItemName as ItemName
	,mc.Quantity
	,mc.UnitCost
	,mc.TotalCost
	,mc.BillableCost
	,mc.AmountBilled
	,mc.ShortDescription COLLATE LATIN1_GENERAL_CI_AS as Description
	,mc.ExpenseDate as TransactionDate
	,mc.InvoiceLineKey
	,mc.WriteOff
	,4
	,WIPPostingInKey
	,WIPPostingOutKey
	,mc.OnHold
	,mc.WriteOffReasonKey
	,mc.LongDescription as Comments
	,NULL
	,i.ExpenseAccountKey
	,mc.DateBilled
	,mc.TransferComment
	,NULL
	,mc.ClassKey
	,NULL AS UIDTranKey
	,mc.MiscCostKey AS TranKey
    ,null AS TranKey
	,NULL AS VendorKey
	,d.DepartmentName
    ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByUser
	,NULL AS UIDTransferToKey
	,mc.TransferToKey AS TransferToKey
    ,wt.WorkTypeID
    ,isnull(wtcust.Subject, wt.WorkTypeName)
    ,mc.TransferInDate
    ,mc.TransferOutDate
    ,mc.AdjustmentType as AdjustmentType
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
    ,mc.ShortDescription as SourceDescription
from
	tMiscCost mc (nolock)
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on i.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = mc.ProjectKey
	LEFT JOIN tDepartment d (nolock) on mc.DepartmentKey = d.DepartmentKey
    left outer join tUser u (nolock) on mc.EnteredByKey = u.UserKey

Union ALL

Select
	'VOUCHER' as Type
	,v.CompanyKey
	,ISNULL(vd.TargetGLCompanyKey, v.GLCompanyKey) as GLCompanyKey
	,vd.VoucherKey as ParentKey
	,vd.ProjectKey
	,vd.TaskKey
	,vd.ItemKey 
	,i.ItemID
	,i.ItemName as ItemName
	,vd.Quantity
	,vd.UnitCost
	,vd.TotalCost
	,vd.BillableCost
	,vd.AmountBilled
	,vd.ShortDescription COLLATE LATIN1_GENERAL_CI_AS as Description
	,v.InvoiceDate as TransactionDate
	,vd.InvoiceLineKey
	,vd.WriteOff
	,v.Status
	,WIPPostingInKey
	,WIPPostingOutKey
	,vd.OnHold
	,vd.WriteOffReasonKey
	,vd.ShortDescription as Comments
	,NULL
	,isnull(vd.ExpenseAccountKey, i.ExpenseAccountKey)
	,vd.DateBilled
	,vd.TransferComment
	,NULL
	,vd.ClassKey
	,NULL AS UIDTranKey
	,vd.VoucherDetailKey AS TranKey
    ,v.InvoiceNumber AS TranNumber
	,v.VendorKey
	,d.DepartmentName
    ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByUser
	,NULL AS UIDTransferToKey
	,vd.TransferToKey AS TransferToKey
    ,wt.WorkTypeID
    ,isnull(wtcust.Subject, wt.WorkTypeName)
    ,vd.TransferInDate
    ,vd.TransferOutDate
    ,vd.AdjustmentType as AdjustmentType
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
    ,ISNULL('VendorID: ' + c.VendorID, '') + ISNULL(' - ' + c.CompanyName + '; ', '') + ISNULL('Invoice: ' + v.InvoiceNumber + '; ', '') + ISNULL(vd.ShortDescription, '') as SourceDescription
from
	tVoucherDetail vd (nolock)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on i.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = vd.ProjectKey
	LEFT JOIN tDepartment d (nolock) on vd.DepartmentKey = d.DepartmentKey
    left outer join tUser u (nolock) on v.CreatedByKey = u.UserKey

Union ALL

Select
	'OPENORDER' as Type
	,po.CompanyKey
	,po.GLCompanyKey
	,pod.PurchaseOrderKey as ParentKey
	,pod.ProjectKey
	,pod.TaskKey
	,pod.ItemKey 
	,i.ItemID
	,i.ItemName as ItemName
	,pod.Quantity
	,pod.UnitCost
	,pod.TotalCost
	,pod.BillableCost
	,pod.AmountBilled
	,pod.ShortDescription COLLATE LATIN1_GENERAL_CI_AS as Description
	,Case po.PODate 
		When 1 then po.FlightStartDate
		When 2 then po.FlightStartDate
		Else po.PODate
	 end as TransactionDate
	,pod.InvoiceLineKey
	,0 as WriteOff
	,po.Status
	,0 as WIPPostingInKey
	,0 as WIPPostingOutKey
	,pod.OnHold
	,0 as WriteOffReasonKey
	,pod.ShortDescription as Comments
	,NULL -- CostRate
	,i.ExpenseAccountKey
	,pod.DateBilled
	,pod.TransferComment
	,NULL
	,pod.ClassKey
	,NULL AS UIDTranKey
	,pod.PurchaseOrderDetailKey AS TranKey
    ,po.PurchaseOrderNumber AS TranNumber
	,po.VendorKey
	,d.DepartmentName
    ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByUser
	,NULL AS UIDTransferToKey
	,pod.TransferToKey AS TransferToKey
    ,wt.WorkTypeID
    ,isnull(wtcust.Subject, wt.WorkTypeName)
    ,pod.TransferInDate
    ,pod.TransferOutDate
    ,NULL as AdjustmentType -- At this time, there is no WIP adjustment for PO details
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
    ,'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') as SourceDescription
from
	tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on i.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = pod.ProjectKey
	LEFT JOIN tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
    left outer join tUser u (nolock) on po.CreatedByKey = u.UserKey
where (InvoiceLineKey > 0 or (ISNULL(AppliedCost, 0) = 0 and pod.Closed = 0))
GO
