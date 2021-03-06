USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vBillingItemSelect]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
|| When     Who Rel   What
|| 07/09/07 GHL 8.5    Added restriction on ERs (VoucherDetailKey null)
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
|| 02/19/08 GHL 8.5    (21165) Added Expense receipt info for VI
|| 04/10/08 GHL 8.503 (24671) Changed inner join tItem to left outer join to handle cases
||                                    when there is no item
|| 05/03/08 GHL 8.509 (25312) Prevent selection if write off + wip out key . Also corrected BillingStatus
|| 09/10/09 GHL 10.5   Added filtering of TransferToKey null
|| 06/20/13 GHL 10.569 (181813) Chanded Description and TypeName for credit card charges
|| 11/13/14 GHL 10.586 Added Title info for Abelson Taylor
*/

CREATE VIEW [dbo].[vBillingItemSelect]

as
Select
	'LABOR' as Type
	,'Labor' as TypeName
	,Cast(t.TimeKey as varchar(200)) as TranKey
	,t.ProjectKey
	,t.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,s.ServiceCode as ItemID
	,s.Description as ItemName
	,s.ServiceCode + ' - ' + s.Description as ItemFullName
	,s.ServiceKey as ItemKey
	,ti.TitleKey
	,ti.TitleName
	,ti.TitleID
	,ActualHours as Quantity
	,ActualRate as UnitCost
	,ROUND(ActualHours * ActualRate, 2) as TotalCost
	,ROUND(ActualHours * ActualRate, 2) as BillableCost
	,ROUND(BilledHours * BilledRate, 2) as AmountBilled
	,u.FirstName + ' ' + u.LastName as Description
	,ta.TaskName as Description2
	,u.FirstName + ' ' + u.LastName as PersonItem
	,WorkDate as TransactionDate
	,NULL As TransactionDate2
	,Case ts.Status When 4 then
		Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey = 0 then 'Marked Billed'
		When WriteOff = 0 and InvoiceLineKey > 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'Unbilled'
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
        ,t.InvoiceLineKey as InvoiceLineKey
	,'' as ReasonID
from 
	tTime t (nolock)
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
	left outer join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
where isnull(t.InvoiceLineKey,0) = 0  -- cannot be invoiced
  and (not exists (
		select 1 
		from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                           	inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
                           where bd.Entity = 'tTime' and bd.EntityGuid = t.TimeKey
		and     b.Status < 5
         ))
  and ts.Status = 4
  and not (t.WriteOff = 1 and t.WIPPostingOutKey <> 0) 
  and t.TransferToKey is null

Union ALL

Select
	'EXPRPT' as Type
	,'Expense Report' as TypeName
	,Cast(er.ExpenseReceiptKey as varchar(200)) as TranKey
	,er.ProjectKey
	,er.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName
	,null as TitleID
	,er.ActualQty as Quantity
	,er.ActualUnitCost as UnitCost
	,er.ActualCost as TotalCost
	,er.BillableCost as BillableCost
	,er.AmountBilled
	,'Person: ' + u.FirstName + ' ' + u.LastName + ' Report: ' +rtrim( ee.EnvelopeNumber) + ' ' + er.Description as Description
	,er.Description as Description2
	,i.ItemName as PersonItem
	,er.ExpenseDate as TransactionDate
	,NULL As TransactionDate2
	,Case ee.Status When 4 then Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey = 0 then 'Marked Billed'
		When WriteOff = 0 and InvoiceLineKey > 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'Unbilled'
		END Else 'Unapproved' END as BillingStatus
	,WIPPostingInKey
	,WIPPostingOutKey
	,er.WriteOff as WriteOff
	,ee.Status as Status
	,er.TransferComment
	,NULL AS Comments
	,er.Comments AS TransactionComments
	,ISNULL(er.OnHold, 0) 
        ,er.InvoiceLineKey as InvoiceLineKey
	,'' as ReasonID
from
	tExpenseReceipt er (nolock)
	inner join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
	inner join tUser u (nolock) on ee.UserKey = u.UserKey
	left outer join tTask ta (nolock) on er.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
where isnull(er.InvoiceLineKey,0) = 0  -- cannot be invoiced
  and (not exists (
		select 1 from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                           	inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
                         where bd.Entity = 'tExpenseReceipt' and bd.EntityKey = er.ExpenseReceiptKey
		and     b.Status < 5
))
  and ee.Status = 4
  and er.VoucherDetailKey IS NULL 
  and not (er.WriteOff = 1 and er.WIPPostingOutKey <> 0) 
  and er.TransferToKey is null

Union ALL

Select
	'MISCCOST' as Type
	,'Misc Cost' as TypeName
	,Cast(mc.MiscCostKey as varchar(200)) as TranKey
	,mc.ProjectKey
	,mc.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName
	,null as TitleID
	,mc.Quantity
	,mc.UnitCost
	,mc.TotalCost
	,mc.BillableCost
	,mc.AmountBilled
	,mc.ShortDescription as Description
	,mc.ShortDescription as Description2
	,i.ItemName as PersonItem
	,mc.ExpenseDate as TransactionDate
	,NULL As TransactionDate2
	,Case
		When WriteOff = 1 Then 'Writeoff'
		When WriteOff = 0 and InvoiceLineKey = 0 then 'Marked Billed'
		When WriteOff = 0 and InvoiceLineKey > 0 then 'Billed'
		When WriteOff = 0 and InvoiceLineKey is null then 'Unbilled'
		END as BillingStatus
	,WIPPostingInKey
	,WIPPostingOutKey
	,mc.WriteOff as WriteOff
	,4 as Status
	,mc.TransferComment
	,NULL AS Comments
	,mc.LongDescription AS TransactionComments
	,ISNULL(mc.OnHold, 0) 
        ,mc.InvoiceLineKey as InvoiceLineKey
	,'' as ReasonID
from
	tMiscCost mc (nolock)
	left outer join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
where isnull(mc.InvoiceLineKey,0) = 0  -- cannot be invoiced
  and (not exists (
		select 1 from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                           inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
		where bd.Entity = 'tMiscCost' and bd.EntityKey = mc.MiscCostKey
		and     b.Status < 5
))
  and not (mc.WriteOff = 1 and mc.WIPPostingOutKey <> 0) 
 and mc.TransferToKey is null

Union ALL

Select
	'VOUCHER' as Type
	,case when isnull(v.CreditCard, 0) = 0 then 'Vendor Invoice' else 'Credit Card Charge' end as TypeName
	,Cast(vd.VoucherDetailKey as varchar(200)) as TranKey
	,vd.ProjectKey
	,vd.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName
	,null as TitleID
	,vd.Quantity
	,vd.UnitCost
	,vd.TotalCost
	,vd.BillableCost
	,vd.AmountBilled
	,case when isnull(v.CreditCard, 0) = 0 then 
	'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '') + ' Invoice: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '')  
	else
		case when v.BoughtFrom = '' then
		'Credit Card Charge. Purchased From: ?' + ' Ref: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '')  
		else	
		'Credit Card Charge. Purchased From: ' + ISNULL(v.BoughtFrom, '?') + ' Ref: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '')  
		end
	end as Description
	,'Vendor: ' + ISNULL(c.VendorID, '?') + ' Invoice: ' + ISNULL(v.InvoiceNumber, '?') + ' ' + ISNULL(vd.ShortDescription, '') as Description2
	,i.ItemName as PersonItem
	,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
	,NULL As TransactionDate2
	,Case v.Status When 4 Then Case
		When vd.WriteOff = 1 Then 'Writeoff'
		When vd.WriteOff = 0 and vd.InvoiceLineKey = 0 then 'Marked Billed'
		When vd.WriteOff = 0 and vd.InvoiceLineKey > 0 then 'Billed'
		When vd.WriteOff = 0 and vd.InvoiceLineKey is null then 'Unbilled'
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
             ,vd.InvoiceLineKey as InvoiceLineKey
	,'' as ReasonID
from
	tVoucherDetail vd (nolock)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
	left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	left outer join tUser u (nolock) on ee.UserKey = u.UserKey

where isnull(vd.InvoiceLineKey,0) = 0  -- cannot be invoiced
  and (not exists (select 1 from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                           	inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
                         where bd.Entity = 'tVoucherDetail' and bd.EntityKey = vd.VoucherDetailKey
		and     b.Status < 5
))
  and v.Status = 4
  and not (vd.WriteOff = 1 and vd.WIPPostingOutKey <> 0) 
  and vd.TransferToKey is null  

UNION ALL

Select
	'ORDER' as Type
	,Case po.POKind When 0 then 'Purchase Order'
					When 1 then 'Insertion Order'
					When 2 then 'Broadcast Order' end as TypeName
	,cast(pod.PurchaseOrderDetailKey as varchar(200)) as TranKey
	,pod.ProjectKey
	,pod.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName
	,null as TitleID
	,pod.Quantity
	,pod.UnitCost
	,pod.TotalCost
    ,case po.BillAt
 		 -- gross
         when 0 then BillableCost
		 -- net
         when 1 then TotalCost
         -- commission only
         when 2 then BillableCost - TotalCost
     end as BillableCost
	,pod.AmountBilled
	,'Vendor: ' + c.VendorID + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, 0) as Description
	,'Vendor: ' + c.VendorID + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, 0) as Description2
	,i.ItemName as PersonItem
	,Case po.POKind When 0 then CONVERT( VARCHAR(50), po.PODate, 101)
			When 1 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101) 
			When 2 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101)
              End As TransactionDate
	 ,Case po.POKind When 0 then CONVERT( VARCHAR(50), po.PODate, 101)
			When 1 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101) 
			When 2 then CONVERT( VARCHAR(50), pod.DetailOrderDate, 101)+ '+' +CONVERT( VARCHAR(50), pod.DetailOrderEndDate, 101)
              End As TransactionDate2
	,Case po.Status When 4 Then Case
		When InvoiceLineKey = 0 then 'Marked Billed'
		When InvoiceLineKey > 0 then 'Billed'
		When InvoiceLineKey is null then 'Unbilled'
		END ELSE 'Unapproved' END as BillingStatus
	,0
	,0
	,0
	,po.Status
	,''
	,NULL AS Comments
	,pod.LongDescription AS TransactionComments
	,ISNULL(pod.OnHold, 0) 
        ,pod.InvoiceLineKey as InvoiceLineKey
	,mrr.ReasonID
from
	tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey	
where isnull(pod.InvoiceLineKey,0) = 0  -- cannot be invoiced
  and (not exists (select 1 from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                           	inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
                         where bd.Entity = 'tPurchaseOrderDetail' and bd.EntityKey = pod.PurchaseOrderDetailKey
		and     b.Status < 5		
))
  and (ISNULL(AppliedCost, 0) = 0 and pod.Closed = 0)
  and po.Status = 4
 and pod.TransferToKey is null
GO
