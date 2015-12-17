USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectTrans]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProjectTrans]
as

/*
|| When     Who Rel     What
|| 12/21/06 CRG 8.4     Added GLAccountKey
|| 07/10/07 QMD 8.5     Expense Type reference changed to tItem
|| 10/26/07 CRG 8.4.3.9 (14565) Modified to add a column for CostRate for use by vReport_Transactions_NetLabor
|| 11/07/07 CRG 8.5     (9205) Added ClassKey
|| 02/01/08 GHL 8.503   (20472) Added TranKey, UIDTranKey to join with expense receipts in vReport_Transactions
|| 04/10/08 GHL 8.508   (24671) Changed join type between tItem/tExpenseReceipt (case when no item)
|| 04/08/09 GHL 10.022  (50462) Added VendorKey  to add to vReport_Transactions
|| 04/24/09 MFT 10.024	(51139) Added DepartmentName to add to vReport_Transactions and vReport_Transactions_NetLabor
|| 04/28/09 GHL 10.024  (51139) Get department from the lines for misc cost and vouchers only 
|| 06/15/09 GHL 10.027  (54845) Added Transaction Number to get v.InvoiceNumber, ee.EnvelopeNumber + user
|| 09/11/09 GHL 10.5     Added TransferToKey 
|| 01/19/10 GHL 10.517  (72527) Added Billing Item info from service/item
||                       considered as defaults if there is no layout on the project 
|| 01/22/10 RLB 10.517  (72862) If no item on voucher line will pull lines expense account
|| 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
|| 07/13/11 RLB 10.546  (114349) Added Sales Expense Account
|| 04/23/12 GHL 10.555  Added GLCompanyKey for map/restrict
||                       --> tTime/tExpenseReceipt
||							p.GLCompanySource = 0 then p.GLCompanyKey
||							p.GLCompanySource = 1 then u.GLCompanyKey
||							p.GLCompanySource is null i.e. no project then u.GLCompanyKey
||                       --> tMiscCost
||							p.GLCompanyKey
||                       --> tVoucherDetail
||							isnull(vd.TargetGLCompanyKey, v.GLCompanyKey)
|| 08/22/12 RLB 10.559  (151545) since labor TotalCost is gross going to add a new net field TotalCostNet
|| 01/29/15 GHL 10.588  Added titles for Abelson
|| 03/20/15 WDF 10.590 (AbelsonTaylor) Added AdjustmentType
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
	,ROUND(ActualHours * t.CostRate, 2) as TotalCostNet
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
	,NULL as SalesAccountKey
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
    ,t.TitleKey
    ,tt.TitleName
    ,tt.TitleID
    ,t.IsAdjustment as AdjustmentType
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
	,er.ActualCost as TotalCostNet
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
	,i.SalesAccountKey
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
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
    ,er.AdjustmentType as AdjustmentType

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
	,mc.TotalCost as TotalCostNet
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
	,i.SalesAccountKey
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
    ,null as TitleKey
    ,null as TitleName
	,null as TitleID
    ,mc.AdjustmentType as AdjustmentType
	
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
	,vd.TotalCost as TotalCostNet
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
	,isnull(i.ExpenseAccountKey, vd.ExpenseAccountKey)
	,i.SalesAccountKey
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
    ,null as TitleKey
    ,null as TitleName
	,null as TitleID
    ,vd.AdjustmentType as AdjustmentType
from
	tVoucherDetail vd (nolock)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
    left outer join tWorkTypeCustom wtcust (nolock) on i.WorkTypeKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = vd.ProjectKey
	LEFT JOIN tDepartment d (nolock) on vd.DepartmentKey = d.DepartmentKey
    left outer join tUser u (nolock) on v.CreatedByKey = u.UserKey
GO
