USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vBillingGetTransactions]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
|| When     Who Rel   What
|| 10/17/06 CRG 8.35  Now showing Billing Detail comments if available.
|| 12/07/06 GHL 8.4    Change join to tService via tBillingDetail rather than tTime
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
|| 02/19/08 GHL 8.5    Trimming now envelope number to look better on reports
|| 02/19/08 GHL 8.5    (21165) Added Expense receipt info for VI in Comments section now
|| 04/10/08 GHL 8.503 (24671) Changed inner join tItem to left outer join to handle cases
||                                    when there is no item
|| 02/08/12 GHL 10.552 (123900) Added AsOfDate (i.e. Postimg Date for Write Offs, etc..) to show on grid 
|| 06/20/13 GHL 10.569 (181813) Chanded Description and TypeName for credit card charges
|| 11/13/14 GHL 10.586 Added Title info for Abelson Taylor
*/

CREATE VIEW [dbo].[vBillingGetTransactions]

as
Select
    b.BillingKey
    ,bd.BillingDetailKey	
    ,bd.Action as BillingAction
	,'LABOR' as Type
	,'Labor' as TypeName
	,Cast(t.TimeKey as varchar(200)) as TranKey
	,t.ProjectKey
	,t.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,CASE
		WHEN ta.TaskID IS NULL THEN ta.TaskName
		ELSE ta.TaskID + ' - ' + ta.TaskName
	END as TaskFullName
	,s.ServiceCode as ItemID
	,s.Description as ItemName
	,s.ServiceCode + ' - ' + s.Description as ItemFullName
	,s.ServiceKey as ItemKey
	,ti.TitleKey
	,ti.TitleName
	,ti.TitleID
	,bd.Quantity as Quantity
	,bd.Rate as UnitCost
	,ROUND(ActualHours * ActualRate, 2) as TotalCost
	,ROUND(bd.Quantity * bd.Rate, 2) as BillableCost
	,ROUND(BilledHours * BilledRate, 2) as AmountBilled
	,u.FirstName + ' ' + u.LastName as Description
	,ta.TaskName as Description2
	,u.FirstName + ' ' + u.LastName as PersonItem
	,WorkDate as TransactionDate
	,NULL As TransactionDate2
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
    	,t.InvoiceLineKey as InvoiceLineKey
    	,case 
	when bd.Action = 0 then 'Write Off'
        when bd.Action = 1 then 'Bill'
        when bd.Action = 2 then 'Mark As Billed'
        when bd.Action = 3 then 'Mark As On Hold'
        when bd.Action = 4 then 'Mark On Hold Item As Billable'
        when bd.Action = 5 then 'Transfer'
        when bd.Action = 7 then 'Do Not Bill'
	 end as BillingActionDesc
	,bd.EditorKey	
	,bd.EditComments
	,edit.FirstName
	,edit.MiddleName
	,edit.LastName
	,'' as ReasonID	
	,bd.Comments as BillingComments
	,bd.AsOfDate
from 
	tTime t (nolock)
	inner join tBillingDetail bd (nolock) on t.TimeKey = bd.EntityGuid
	inner join tBilling b(nolock) on bd.BillingKey = b.BillingKey
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	left outer join tService s (nolock) on bd.ServiceKey = s.ServiceKey
	left outer join tUser edit (nolock) on bd.EditorKey = edit.UserKey
	left outer join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
where bd.Entity = 'tTime'


Union ALL

Select
	b.BillingKey
    ,bd.BillingDetailKey	
    ,bd.Action as BillingAction
	,'EXPRPT' as Type
	,'Expense Report' as TypeName
	,Cast(er.ExpenseReceiptKey as varchar(200)) as TranKey
	,er.ProjectKey
	,er.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,CASE
		WHEN ta.TaskID IS NULL THEN ta.TaskName
		ELSE ta.TaskID + ' - ' + ta.TaskName
	END as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName
	,null as TitleID
	,bd.Quantity as Quantity
	,bd.Rate as UnitCost
	,er.ActualCost as TotalCost
	,bd.Total as BillableCost
	,er.AmountBilled
	,'Person: ' + u.FirstName + ' ' + u.LastName + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description as Description
	,er.Description as Description2
	,i.ItemName as PersonItem
	,er.ExpenseDate as TransactionDate
	,NULL As TransactionDate2
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
    ,er.InvoiceLineKey as InvoiceLineKey
    ,case 
		when bd.Action = 0 then 'Write Off'
        when bd.Action = 1 then 'Bill'
        when bd.Action = 2 then 'Mark As Billed'
        when bd.Action = 3 then 'Mark As On Hold'
        when bd.Action = 4 then 'Mark On Hold Item As Billable'
        when bd.Action = 5 then 'Transfer'
        when bd.Action = 7 then 'Do Not Bill'
	 end as BillingActionDesc
	,bd.EditorKey	
	,bd.EditComments
	,edit.FirstName
	,edit.MiddleName
	,edit.LastName
	,'' as ReasonID
	,bd.Comments as BillingComments
	,bd.AsOfDate
from
	tExpenseReceipt er (nolock)
    inner join tBillingDetail bd (nolock) on er.ExpenseReceiptKey = bd.EntityKey
    inner join tBilling b(nolock) on bd.BillingKey = b.BillingKey
	inner join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
	inner join tUser u (nolock) on ee.UserKey = u.UserKey
	left outer join tTask ta (nolock) on er.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	left outer join tUser edit (nolock) on bd.EditorKey = edit.UserKey
where bd.Entity = 'tExpenseReceipt'


Union ALL

Select
	b.BillingKey
    ,bd.BillingDetailKey	
    ,bd.Action as BillingAction
	,'MISCCOST' as Type
	,'Misc Cost' as TypeName
	,Cast(mc.MiscCostKey as varchar(200)) as TranKey
	,mc.ProjectKey
	,mc.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,CASE
		WHEN ta.TaskID IS NULL THEN ta.TaskName
		ELSE ta.TaskID + ' - ' + ta.TaskName
	END as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName	
	,null as TitleID
	,bd.Quantity
	,bd.Rate as UnitCost
	,mc.TotalCost
	,bd.Total as BillableCost
	,mc.AmountBilled
	,mc.ShortDescription as Description
	,mc.ShortDescription as Description2
	,i.ItemName as PersonItem
	,mc.ExpenseDate as TransactionDate
	,NULL As TransactionDate2
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
    ,mc.InvoiceLineKey as InvoiceLineKey
    ,case 
		when bd.Action = 0 then 'Write Off'
        when bd.Action = 1 then 'Bill'
        when bd.Action = 2 then 'Mark As Billed'
        when bd.Action = 3 then 'Mark As On Hold'
        when bd.Action = 4 then 'Mark On Hold Item As Billable'
        when bd.Action = 5 then 'Transfer'
        when bd.Action = 7 then 'Do Not Bill'
	 end as BillingActionDesc
	,bd.EditorKey	
	,bd.EditComments
	,edit.FirstName
	,edit.MiddleName
	,edit.LastName
	,'' as ReasonID
	,bd.Comments as BillingComments
	,bd.AsOfDate
from
	tMiscCost mc (nolock)
    inner join tBillingDetail bd (nolock) on mc.MiscCostKey = bd.EntityKey
    inner join tBilling b(nolock) on bd.BillingKey = b.BillingKey
	left outer join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	left outer join tUser edit (nolock) on bd.EditorKey = edit.UserKey
where bd.Entity = 'tMiscCost'

Union ALL

Select
	b.BillingKey
    ,bd.BillingDetailKey	
    ,bd.Action as BillingAction
	,'VOUCHER' as Type
	,case when isnull(v.CreditCard, 0) = 0 then 'Vendor Invoice' else 'Credit Card Charge' end as TypeName
	,Cast(vd.VoucherDetailKey as varchar(200)) as TranKey
	,vd.ProjectKey
	,vd.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,CASE
		WHEN ta.TaskID IS NULL THEN ta.TaskName
		ELSE ta.TaskID + ' - ' + ta.TaskName
	END as TaskFullName
	,i.ItemID
	,i.ItemName
	,i.ItemID + ' - ' + i.ItemName as ItemFullName
	,i.ItemKey
	,null as TitleKey
	,null as TitleName	
	,null as TitleID
	,bd.Quantity
	,bd.Rate as UnitCost
	,vd.TotalCost
	,bd.Total as BillableCost
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
	,'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '') + ' Invoice: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '') as Description2
	,i.ItemName as PersonItem
	,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
	,NULL As TransactionDate2
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
    ,vd.InvoiceLineKey as InvoiceLineKey
    ,case 
		when bd.Action = 0 then 'Write Off'
        when bd.Action = 1 then 'Bill'
        when bd.Action = 2 then 'Mark As Billed'
        when bd.Action = 3 then 'Mark As On Hold'
        when bd.Action = 4 then 'Mark On Hold Item As Billable'
        when bd.Action = 5 then 'Transfer'
        when bd.Action = 7 then 'Do Not Bill'
	 end as BillingActionDesc
	,bd.EditorKey	
	,bd.EditComments
	,edit.FirstName
	,edit.MiddleName
	,edit.LastName
	,'' as ReasonID
	,bd.Comments as BillingComments
	,bd.AsOfDate
from
	tVoucherDetail vd (nolock)
    inner join tBillingDetail bd (nolock) on vd.VoucherDetailKey = bd.EntityKey
    inner join tBilling b(nolock) on bd.BillingKey = b.BillingKey
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tUser edit (nolock) on bd.EditorKey = edit.UserKey
	left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
	left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	left outer join tUser u (nolock) on ee.UserKey = u.UserKey

where bd.Entity = 'tVoucherDetail'


UNION ALL

Select
	b.BillingKey
    ,bd.BillingDetailKey	
    ,bd.Action as BillingAction
	,'ORDER' as Type
	,Case po.POKind When 0 then 'Purchase Order'
					When 1 then 'Insertion Order'
					When 2 then 'Broadcast Order' end as TypeName
	,cast(pod.PurchaseOrderDetailKey as varchar(200)) as TranKey
	,pod.ProjectKey
	,pod.TaskKey
	,ta.TaskID as TaskID
	,ta.TaskName
	,CASE
		WHEN ta.TaskID IS NULL THEN ta.TaskName
		ELSE ta.TaskID + ' - ' + ta.TaskName
	END as TaskFullName
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
    ,bd.Total as BillableCost
	,pod.AmountBilled
 	,'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') as Description
	,'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') as Description2
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
		When InvoiceLineKey >= 0 then 'Billed'
		When InvoiceLineKey is null then 'UnBilled'
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
    ,case 
		when bd.Action = 0 then 'Write Off'
        when bd.Action = 1 then 'Bill'
        when bd.Action = 2 then 'Mark As Billed'
        when bd.Action = 3 then 'Mark As On Hold'
        when bd.Action = 4 then 'Mark On Hold Item As Billable'
        when bd.Action = 5 then 'Transfer'
        when bd.Action = 7 then 'Do Not Bill'
	 end as BillingActionDesc
	,bd.EditorKey	
	,bd.EditComments
	,edit.FirstName
	,edit.MiddleName
	,edit.LastName
	,mrr.ReasonID
	,bd.Comments as BillingComments
	,bd.AsOfDate
from
	tPurchaseOrderDetail pod (nolock)
    inner join tBillingDetail bd (nolock) on pod.PurchaseOrderDetailKey = bd.EntityKey
    inner join tBilling b(nolock) on bd.BillingKey = b.BillingKey
	inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	left outer join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tUser edit (nolock) on bd.EditorKey = edit.UserKey
	left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey
where bd.Entity = 'tPurchaseOrderDetail'
GO
