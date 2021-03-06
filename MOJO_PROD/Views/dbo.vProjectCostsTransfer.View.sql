USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectCostsTransfer]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel     What
  || 05/23/07 GHL 8.422  Added rounding of PO TotalCost to fix rounding errors in reports. Bug 9306
  || 07/09/07 GHL 8.5    Added restriction of ER where VoucherDetailKey is null
  || 07/10/07 QMD 8.5    Expense Type reference changed to tItem
  || 02/01/08 GHL 8.5   (20123)  Removed restriction of ER where VoucherDetailKey is nul
  ||                     Added LinkVoucherDetailKey
  || 02/19/08 GHL 8.5    Added rtrim(EnvelopeNumber) to look better on reports
  || 02/19/08 GHL 8.5    (21165) Added Expense receipt info for VI in Comments section now
  || 04/10/08 GHL 8.508  (24671) Changed join type between tItem and tExpenseReceipt (case no item)
  || 10/15/08 GHL 10.010 (36763) Corrected BillableCost for IO/BO to account for po.BillAt
  || 08/27/09 GHL 10.5   Added Transfer logic. Query only where TransferInKey is not null
  ||                     Select TransferOutDate as DateBilled to show on the grid
  || 07/28/11 GHL 10.546 (117156) Added TransferInDate to help out with debugging
  || 10/08/13 GHL 10.573 Using now Net = PTotalCost for multi currency
  || 12/05/13 RLB 10.575 (197891) Added SummaryTaskKey for new billing transactions screen 
  || 11/06/14 GHL 10.586 For Abelson customization, do not take title adjustments
  || 01/06/15 GHL 10.588 For Abelson customization, do not take adjustments from undoing writeoffs after posting to WIP
  */


CREATE VIEW [dbo].[vProjectCostsTransfer]

as
Select
	'LABOR' as Type
	,'Labor' as TypeName
	,ts.CompanyKey
	,Cast(t.TimeKey as varchar(200)) as TranKey
	,t.ProjectKey
	,t.TaskKey
	,t.TransferInDate
	,t.TransferOutDate AS DateBilled
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,ta.SummaryTaskKey
	,s.ServiceCode as ItemID
	,s.Description as ItemName
	,s.ServiceCode + ' - ' + s.Description as ItemFullName
	,s.ServiceKey as ItemKey
	,ActualHours as Quantity
	,ActualRate as UnitCost
	,ROUND(ActualHours * ActualRate, 2) as TotalCost
	,ROUND(ActualHours * ActualRate, 2) as BillableCost
	,ISNULL(ROUND(BilledHours * BilledRate, 2), 0) as AmountBilled
	,u.FirstName + ' ' + u.LastName as Description
	,ta.TaskName as Description2
	,u.FirstName + ' ' + u.LastName as PersonItem
	,WorkDate as TransactionDate
	,WorkDate as TransactionDate2
	,InvoiceLineKey
	,Case When ISNULL(t.InvoiceLineKey, 0) = 0 then NULL
		else
			(Select rtrim(ltrim(InvoiceNumber))
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = t.InvoiceLineKey) 
		end as BillingInvoiceNumber
	,Case ts.Status When 4 then
		Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey >= 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'UnBilled'
		END 
		
	Else
		'Unapproved' END as BillingStatus
	,WIPPostingInKey
	,WIPPostingOutKey
	,t.WriteOff as WriteOff
	,ts.Status as Status
	,t.TransferComment
	,t.Comments
	,t.Comments AS TransactionComments
	,ISNULL(t.OnHold, 0) AS OnHold
    ,NULL as LinkVoucherDetailKey
from 
	tTime t (nolock)
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
where t.TransferToKey is not null And isnull(t.IsAdjustment,0) = 0 -- do not take title adjustment

Union ALL

Select
	'EXPRPT' as Type
	,'Expense Report' as TypeName
	,ee.CompanyKey
	,Cast(er.ExpenseReceiptKey as varchar(200)) as TranKey
	,er.ProjectKey
	,er.TaskKey
	,er.TransferInDate
	,er.TransferOutDate AS DateBilled
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,ta.SummaryTaskKey
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,er.ActualQty as Quantity
	,er.ActualUnitCost as UnitCost
	,er.PTotalCost as TotalCost
	,er.BillableCost as BillableCost
	,ISNULL(er.AmountBilled,0)
	,'Person: ' + u.FirstName + ' ' + u.LastName + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description  as Description
	,er.Description as Description2
	,i.ItemName as PersonItem
	,er.ExpenseDate as TransactionDate
	,er.ExpenseDate as TransactionDate2
	,er.InvoiceLineKey
	,Case When ISNULL(er.InvoiceLineKey, 0) = 0 then NULL
		else
			(Select rtrim(ltrim(InvoiceNumber)) 
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = er.InvoiceLineKey) 
		end as BillingInvoiceNumber	
	,Case ee.Status When 4 then Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey >= 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'UnBilled'
		END Else 'Unapproved' END as BillingStatus
	,WIPPostingInKey
	,WIPPostingOutKey
	,er.WriteOff as WriteOff
	,ee.Status as Status
	,er.TransferComment
	,NULL AS Comments
	,er.Comments AS TransactionComments
	,ISNULL(er.OnHold, 0) 
	,er.VoucherDetailKey as LinkVoucherDetailKey
from
	tExpenseReceipt er (nolock)
	inner join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
	inner join tUser u (nolock) on ee.UserKey = u.UserKey
	left outer join tTask ta (nolock) on er.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
where er.TransferToKey is not null And isnull(er.AdjustmentType,0) = 0

Union ALL

Select
	'MISCCOST' as Type
	,'Misc Cost' as TypeName
	,p.CompanyKey
	,Cast(mc.MiscCostKey as varchar(200)) as TranKey
	,mc.ProjectKey
	,mc.TaskKey
	,mc.TransferInDate
	,mc.TransferOutDate AS DateBilled
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,ta.SummaryTaskKey
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,mc.Quantity
	,mc.UnitCost
	,mc.TotalCost
	,mc.BillableCost
	,ISNULL(mc.AmountBilled,0)
	,mc.ShortDescription as Description
	,mc.ShortDescription as Description2
	,i.ItemName as PersonItem
	,mc.ExpenseDate as TransactionDate
	,mc.ExpenseDate as TransactionDate2
	,mc.InvoiceLineKey
	,Case When ISNULL(mc.InvoiceLineKey, 0) = 0 then NULL
		else
			(Select rtrim(ltrim(InvoiceNumber)) 
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = mc.InvoiceLineKey) 
		end as BillingInvoiceNumber
	,Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey >= 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'UnBilled'
		END as BillingStatus
	,WIPPostingInKey
	,WIPPostingOutKey
	,mc.WriteOff as WriteOff
	,4 as Status
	,mc.TransferComment
	,NULL AS Comments
	,mc.LongDescription AS TransactionComments
	,ISNULL(mc.OnHold, 0) 
    ,NULL as LinkVoucherDetailKey
from
	tMiscCost mc (nolock)
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
where mc.TransferToKey is not null And isnull(mc.AdjustmentType,0) = 0

Union ALL

Select
	'VOUCHER' as Type
	,'Vendor Invoice' as TypeName
	,v.CompanyKey
	,Cast(vd.VoucherDetailKey as varchar(200)) as TranKey
	,vd.ProjectKey
	,vd.TaskKey
	,vd.TransferInDate
	,vd.TransferOutDate AS DateBilled
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,ta.SummaryTaskKey
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,vd.Quantity
	,vd.UnitCost
	,vd.PTotalCost as TotalCost
	,vd.BillableCost
	,ISNULL(vd.AmountBilled,0)
	,'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '?') + ' Invoice: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '') as Description
	,'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '?') + ' Invoice: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '') as Description2
	,i.ItemName as PersonItem
	,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
	,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate2
	,vd.InvoiceLineKey
	,Case When ISNULL(vd.InvoiceLineKey, 0) = 0 then NULL
		else
			(Select rtrim(ltrim(InvoiceNumber)) 
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = vd.InvoiceLineKey) 
		end as BillingInvoiceNumber
	,Case v.Status When 4 Then Case
		When vd.WriteOff = 1 Then 'Writeoff'
		When vd.WriteOff = 0 and vd.InvoiceLineKey >= 0 then 'Billed'
		When vd.WriteOff = 0 and vd.InvoiceLineKey is null then 'UnBilled'
		END ELSE 'Unapproved' END as BillingStatus
	,vd.WIPPostingInKey
	,vd.WIPPostingOutKey
	,vd.WriteOff as WriteOff
	,v.Status as Status
	,vd.TransferComment
	,CASE WHEN er.ExpenseReceiptKey IS NULL THEN NULL
	ELSE	' -- Converted from expense receipt -- Person: ' + u.FirstName + ' ' + u.LastName  + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
	END AS Comments
	,vd.ShortDescription AS TransactionComments
	,ISNULL(vd.OnHold, 0) 
    ,NULL as LinkVoucherDetailKey
from
	tVoucherDetail vd (nolock)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
	left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	left outer join tUser u (nolock) on ee.UserKey = u.UserKey
where vd.TransferToKey is not null And isnull(vd.AdjustmentType,0) = 0


UNION ALL

Select
	'ORDER' as Type
	,Case po.POKind When 0 then 'Purchase Order'
					When 1 then 'Insertion Order'
					When 2 then 'Broadcast Order' end as TypeName
	,po.CompanyKey
	,cast(pod.PurchaseOrderDetailKey as varchar(200)) as TranKey
	,pod.ProjectKey
	,pod.TaskKey
	,pod.TransferInDate
	,pod.TransferOutDate AS DateBilled
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,ta.SummaryTaskKey
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,pod.Quantity
	,pod.UnitCost
	,ROUND(pod.PTotalCost, 2) as TotalCost
 	,CASE po.BillAt 
		WHEN 0 THEN ISNULL(pod.BillableCost, 0)
		WHEN 1 THEN ISNULL(pod.PTotalCost,0)
		WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
	END as BillableCost
	,ISNULL(pod.AmountBilled,0)
	,'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') as Description
	,'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') as Description2
	,i.ItemName as PersonItem
	 ,Case po.POKind When 0 then CONVERT( VARCHAR(50), po.PODate, 101)
			When 1 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101) 
			When 2 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101)
              End As TransactionDate
	 ,Case po.POKind When 0 then CONVERT( VARCHAR(50), po.PODate, 101)
			When 1 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101) 
			When 2 then CONVERT( VARCHAR(50), pod.DetailOrderEndDate, 101)
              End As TransactionDate2
	,pod.InvoiceLineKey
	,Case When ISNULL(pod.InvoiceLineKey, 0) = 0 then NULL
		else
			(Select rtrim(ltrim(InvoiceNumber)) 
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = pod.InvoiceLineKey) 
		end as BillingInvoiceNumber
	,Case po.Status When 4 Then Case
		When InvoiceLineKey >= 0 then 'Billed'
		When InvoiceLineKey is null then 'UnBilled'
		END ELSE 'Unapproved' END as BillingStatus
	,0
	,0
	,0
	,po.Status
	,pod.TransferComment
	,NULL AS Comments
	,pod.LongDescription AS TransactionComments
	,ISNULL(pod.OnHold, 0) 
    ,NULL as LinkVoucherDetailKey

from
	tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
Where
	--(InvoiceLineKey > 0 or (ISNULL(AppliedCost, 0) = 0 and pod.Closed = 0))
    pod.TransferToKey is not null
GO
