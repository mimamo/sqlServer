USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectTransPOInvoice]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProjectTransPOInvoice]
as
/*
|| When     Who Rel  What
|| 12/21/06 CRG 8.4  Added GLAccountKey
|| 05/18/07 GHL 8.5  Cloned from vProjectTrans, added PO and InvoiceLineKey > 0
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
|| 02/07/08 GHL 8.503 Using CostRate now to calculate TotalCost or NET  for tTime
|| 04/10/08 GHL 8.508 (24671) Changed join type between tItem/tExpenseReceipt (case when no item)
|| 09/24/08 GHL 10.009 (35422) Added SalesAccountKey obtained from service or item
||                     Renamed GLAccountKey as ExpenseAccountKey for consistency 
|| 11/24/08 GHL 10.013 (39482) Users want to see tExpenseReceipt.ExpenseDate
||                      or tVoucherDetail.SourceDate instead of tVoucher.InvoiceDate 
|| 02/24/09 GWG 10.020 Modified the Billable amount and the billed difference columns for the expenses.
|| 10/13/09 GHL 10.512 (64451) Added Vendor ID and Name
|| 10/28/09 GHL 10.512 (66856) Added Purchase Order Number
|| 11/15/09 GWG 10.514 Modified the join to services through the billed service rather than the normal one. And modified certain fields for Billed Hrs and Billed Rate
|| 12/10/09 GHL 10.514 (68925) Added Media Estimate ID + Name
|| 03/14/11 GHL 10.542 (105923) Added invoice info such as InvoiceKey, InvoiceNumber to force IX_tTime_3
||                      Found out that if InvoiceNumber is pulled from vReport_Invoice_Transactions, there is table scan on tTime
||                      If InvoiceNumber is pulled here, there is no table scan on tTime
|| 04/23/12 GHL 10.555  Added GLCompanyKey for map/restrict
||                       --> tTime/tExpenseReceipt
||							p.GLCompanySource = 0 then p.GLCompanyKey
||							p.GLCompanySource = 1 then u.GLCompanyKey
||							p.GLCompanySource is null i.e. no project then u.GLCompanyKey
||                       --> tMiscCost
||							p.GLCompanyKey
||                       --> tVoucherDetail
||							isnull(vd.TargetGLCompanyKey, v.GLCompanyKey)
||                       -->tPurchaseOrderDetail
||                          po.GLCompanyKey
|| 06/15/12 GWG 10.556  Fixed GL Company for orders. was set to CompanyKey, not GLCompanyKey
|| 03/22/13 WDF 10.566  (172390) Added BilledComment
|| 01/28/15 GHL 10.588  Added title for Abelson
|| 03/27/15 WDF 10.590 (231686) Added ItemType and TotalCostNet
*/

Select
	'LABOR' as Type
	,iv.CompanyKey -- from invoice
	,case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey
	,t.TimeSheetKey as ParentKey
	,t.ProjectKey
	,t.TaskKey
	,'Service Items' as ItemType
	,s.ServiceCode as ItemID
	,s.Description as ItemName
	,BilledHours as Quantity
	,BilledRate as UnitCost
	,ROUND(ActualHours * t.CostRate, 2) as TotalCostNet
	,ROUND(ActualHours * ISNULL(CostRate, ActualRate), 2) as TotalCost
	,ROUND(ActualHours * ActualRate, 2) as BillableCost
	,ROUND(BilledHours * BilledRate, 2) as AmountBilled
	,u.FirstName + ' ' + u.LastName COLLATE LATIN1_GENERAL_CI_AS as Description
	,t.WorkDate as TransactionDate
	
	,il.InvoiceLineKey
	,iv.InvoiceKey
	,iv.InvoiceNumber
    ,iv.InvoiceDate
    ,iv.PostingDate
    ,iv.DueDate
    ,iv.AdvanceBill
    ,iv.InvoiceStatus
    ,iv.Posted
    ,iv.ContactName
    ,upc.FirstName + ' ' + upc.LastName as PrimaryContactName
    ,iv.ClientKey
    ,cl.CompanyName AS ClientName 
	,cl.CustomerID
	
    ,t.WriteOff
	,ts.Status
	,WIPPostingInKey
	,WIPPostingOutKey
	,t.OnHold
	,t.WriteOffReasonKey
	,t.Comments as Comments
	,ROUND(t.ActualRate * t.ActualHours, 2) - ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0) as BilledDifference
	,NULL as ExpenseAccountKey
	,t.DateBilled
    ,s.GLAccountKey as SalesAccountKey
    ,NULL as VendorID
    ,NULL as VendorName
    ,NULL as PurchaseOrderNumber
    ,NULL as MediaEstimateID
    ,NULL as MediaEstimateName
    ,t.BilledComment
    ,t.TitleKey
    ,tt.TitleName
    ,tt.TitleID
from 
	tTime t (nolock)
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
	left outer join tService s (nolock) on t.BilledService = s.ServiceKey
	inner join tInvoiceLine il (nolock) on  t.InvoiceLineKey = il.InvoiceLineKey
	inner join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
    inner join tCompany cl (nolock) on iv.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser upc (nolock) on iv.PrimaryContactKey = upc.UserKey
    left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tTitle tt (nolock) on t.TitleKey = tt.TitleKey
	
--where 	t.InvoiceLineKey > 0

Union ALL

Select
	'EXPRPT' as Type
	,iv.CompanyKey
	,case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey
	,er.ExpenseEnvelopeKey as ParentKey
	,er.ProjectKey
	,er.TaskKey
	,CASE i.ItemType
	   WHEN 0 THEN 'Purchase Items'
	   WHEN 1 THEN 'Print Items'
	   WHEN 2 THEN 'Broadcast Items'
	   ELSE 'OTHER'
	  END AS ItemType
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
	
	,il.InvoiceLineKey
	,iv.InvoiceKey
	,iv.InvoiceNumber
    ,iv.InvoiceDate
    ,iv.PostingDate
    ,iv.DueDate
    ,iv.AdvanceBill
    ,iv.InvoiceStatus
    ,iv.Posted
    ,iv.ContactName
    ,u.FirstName + ' ' + u.LastName as PrimaryContactName
    ,iv.ClientKey
    ,cl.CompanyName AS ClientName 
	,cl.CustomerID

    ,er.WriteOff
	,ee.Status
	,WIPPostingInKey
	,WIPPostingOutKey
	,er.OnHold
	,er.WriteOffReasonKey
	,er.Comments as Comments
	,er.BillableCost - er.AmountBilled
	,i.ExpenseAccountKey AS ExpenseAccountKey
	,er.DateBilled
    ,i.SalesAccountKey as SalesAccountKey
    ,NULL as VendorID
    ,NULL as VendorName
    ,NULL as PurchaseOrderNumber
    ,NULL as MediaEstimateID
    ,NULL as MediaEstimateName
    ,er.BilledComment
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
from
	tExpenseReceipt er (nolock)
	inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	inner join tInvoiceLine il (nolock)  on er.InvoiceLineKey = il.InvoiceLineKey
	inner join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
    inner join tCompany cl (nolock) on iv.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on iv.PrimaryContactKey = u.UserKey
	left outer join tProject p (nolock) on er.ProjectKey = p.ProjectKey

--where 	er.InvoiceLineKey > 0

Union ALL

Select
	'MISCCOST' as Type
	,iv.CompanyKey
	,p.GLCompanyKey
	,mc.MiscCostKey as ParentKey
	,mc.ProjectKey
	,mc.TaskKey
	,CASE i.ItemType
	   WHEN 0 THEN 'Purchase Items'
	   WHEN 1 THEN 'Print Items'
	   WHEN 2 THEN 'Broadcast Items'
	   ELSE 'OTHER'
	  END AS ItemType
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

	,il.InvoiceLineKey
	,iv.InvoiceKey
	,iv.InvoiceNumber
    ,iv.InvoiceDate
    ,iv.PostingDate
    ,iv.DueDate
    ,iv.AdvanceBill
    ,iv.InvoiceStatus
    ,iv.Posted
    ,iv.ContactName
    ,u.FirstName + ' ' + u.LastName as PrimaryContactName
    ,iv.ClientKey
    ,cl.CompanyName AS ClientName 
	,cl.CustomerID

	,mc.WriteOff
	,4
	,WIPPostingInKey
	,WIPPostingOutKey
	,mc.OnHold
	,mc.WriteOffReasonKey
	,mc.LongDescription as Comments
	,mc.BillableCost - mc.AmountBilled
	,i.ExpenseAccountKey
	,mc.DateBilled
    ,i.SalesAccountKey as SalesAccountKey
    ,NULL as VendorID
    ,NULL as VendorName
    ,NULL as PurchaseOrderNumber
    ,NULL as MediaEstimateID
    ,NULL as MediaEstimateName
    ,mc.BilledComment
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
from
	tMiscCost mc (nolock)
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	inner join tInvoiceLine il (nolock) on  mc.InvoiceLineKey = il.InvoiceLineKey
	inner join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
    inner join tCompany cl (nolock) on iv.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on iv.PrimaryContactKey = u.UserKey

--where 	mc.InvoiceLineKey > 0

Union ALL

Select
	'VOUCHER' as Type
	,iv.CompanyKey
	,ISNULL(vd.TargetGLCompanyKey, v.GLCompanyKey) as GLCompanyKey
	,vd.VoucherKey as ParentKey
	,vd.ProjectKey
	,vd.TaskKey
	,CASE i.ItemType
	   WHEN 0 THEN 'Purchase Items'
	   WHEN 1 THEN 'Print Items'
	   WHEN 2 THEN 'Broadcast Items'
	   ELSE 'OTHER'
	  END AS ItemType
	,i.ItemID
	,i.ItemName as ItemName
	,vd.Quantity
	,vd.UnitCost
	,vd.TotalCost as TotalCostNet
	,vd.TotalCost
	,vd.BillableCost
	,vd.AmountBilled
	,vd.ShortDescription COLLATE LATIN1_GENERAL_CI_AS as Description
	,Isnull(vd.SourceDate, v.InvoiceDate) as TransactionDate

	,il.InvoiceLineKey
	,iv.InvoiceKey
	,iv.InvoiceNumber
    ,iv.InvoiceDate
    ,iv.PostingDate
    ,iv.DueDate
    ,iv.AdvanceBill
    ,iv.InvoiceStatus
    ,iv.Posted
    ,iv.ContactName
    ,u.FirstName + ' ' + u.LastName as PrimaryContactName
    ,iv.ClientKey
    ,cl.CompanyName AS ClientName 
	,cl.CustomerID

	,vd.WriteOff
	,v.Status
	,vd.WIPPostingInKey
	,vd.WIPPostingOutKey
	,vd.OnHold
	,vd.WriteOffReasonKey
	,vd.ShortDescription as Comments
	,vd.BillableCost - vd.AmountBilled
	,i.ExpenseAccountKey
	,vd.DateBilled
    ,i.SalesAccountKey as SalesAccountKey
    ,c.VendorID
    ,c.CompanyName as VendorName
    ,po.PurchaseOrderNumber as PurchaseOrderNumber
    ,me.EstimateID as MediaEstimateID
    ,me.EstimateName as MediaEstimateName
    ,vd.BilledComment
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
from
	tVoucherDetail vd (nolock)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
    left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
    left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
    left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	inner join tInvoiceLine il (nolock) on  vd.InvoiceLineKey = il.InvoiceLineKey
	inner join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
    inner join tCompany cl (nolock) on iv.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on iv.PrimaryContactKey = u.UserKey

--where 	vd.InvoiceLineKey > 0


Union ALL

Select
	'PO' as Type
	,iv.CompanyKey
	,po.GLCompanyKey
	,po.PurchaseOrderKey as ParentKey
	,pod.ProjectKey
	,pod.TaskKey
	,CASE i.ItemType
	   WHEN 0 THEN 'Purchase Items'
	   WHEN 1 THEN 'Print Items'
	   WHEN 2 THEN 'Broadcast Items'
	   ELSE 'OTHER'
	  END AS ItemType
	,i.ItemID
	,i.ItemName as ItemName
	,pod.Quantity
	,CASE WHEN pod.Quantity = 0 THEN pod.TotalCost - ISNULL(pod.AppliedCost, 0) ELSE CAST((pod.TotalCost - ISNULL(pod.AppliedCost, 0)) / pod.Quantity AS MONEY) END
	,pod.TotalCost as TotalCostNet
	,pod.TotalCost
	,CASE po.BillAt 
		WHEN 0 THEN ISNULL(pod.BillableCost, 0)
		WHEN 1 THEN ISNULL(pod.TotalCost,0)
		WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.TotalCost,0) END
	,pod.AmountBilled
	,pod.ShortDescription COLLATE LATIN1_GENERAL_CI_AS as Description
	,po.PODate as TransactionDate

	,il.InvoiceLineKey
	,iv.InvoiceKey
	,iv.InvoiceNumber
    ,iv.InvoiceDate
    ,iv.PostingDate
    ,iv.DueDate
    ,iv.AdvanceBill
    ,iv.InvoiceStatus
    ,iv.Posted
    ,iv.ContactName
    ,u.FirstName + ' ' + u.LastName as PrimaryContactName
    ,iv.ClientKey
    ,cl.CompanyName AS ClientName 
	,cl.CustomerID

	,0 -- WriteOff
	,po.Status
	,0 -- WIPPostingInKey
	,0 -- WIPPostingOutKey
	,pod.OnHold
	,0 -- WriteOffReasonKey
	,pod.ShortDescription as Comments
	,pod.AmountBilled - CASE po.BillAt 
		WHEN 0 THEN ISNULL(pod.BillableCost, 0)
		WHEN 1 THEN ISNULL(pod.TotalCost,0)
		WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.TotalCost,0) END
	,i.ExpenseAccountKey
	,pod.DateBilled
    ,i.SalesAccountKey as SalesAccountKey
    ,c.VendorID
    ,c.CompanyName as VendorName
    ,po.PurchaseOrderNumber as PurchaseOrderNumber
    ,me.EstimateID as MediaEstimateID
    ,me.EstimateName as MediaEstimateName
    ,pod.BilledComment
    ,null as TitleKey
    ,null as TitleName
    ,null as TitleID
from
	tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey
    left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	inner join tInvoiceLine il (nolock) on  pod.InvoiceLineKey = il.InvoiceLineKey
	inner join tInvoice iv (nolock) on il.InvoiceKey = iv.InvoiceKey
    inner join tCompany cl (nolock) on iv.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on iv.PrimaryContactKey = u.UserKey

--Where	pod.InvoiceLineKey > 0
GO
