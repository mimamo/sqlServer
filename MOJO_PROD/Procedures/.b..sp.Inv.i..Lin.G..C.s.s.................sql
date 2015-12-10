USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetCosts]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetCosts]
(
	@InvoiceLineKey int
	,@InvoiceKey int = null
)

as --Encrypt

/*
|| When     Who Rel    What
|| 05/24/06 GHL 8.3    Added field BillableCostOnLine to take in account the Prebill BillAt
||                     McClain reported that PO with BillAt=AtNet should bill at TotalCost not BillableCost  
|| 07/09/07 GHL 8.5    Added restriction on ER
|| 07/31/07 GHL 8.5    Removed ref to expense type
|| 08/02/07 GHL 8.5    Pulling now transactions only linked to the line (not all transactions for project)
|| 08/07/07 GHL 8.5    Added ProjectKey to facilitate project rollup in UI
|| 02/19/08 GHL 8.5    (21165) Added Expense receipt info for VI in Comments section now
|| 05/04/09 GHL 10.024 (52605) Getting now BillingComments from transaction BilledComment
||                    transaction BilledComment should be set when we generate the invoice 
||                    from a billing WS tBillingDetail.EditComents 
|| 09/15/09 GWG 10.510 Modified the transaction date for orders to pull the insertion date and start date for orders.
|| 04/30/10 GHL 10.522 Added InvoiceKey param to pull records for whole invoice
|| 11/16/10 GHL 10.538 Changed tMiscCost inner join tUser to left outer join because some misc costs have null EnteredBy 
|| 04/19/12 GHL 10.555 (140727) Added BilledItem info to edit on flex client edit screen
|| 06/01/12 GHL 10.556 Modified BillingComments like in sptInvoiceLineExpenseGetAll for consistency
|| 01/04/13 GHL 10.563 Added Order # for Vendor invoices to help debugging + added VI label to separate PO and VI #s (6/27/13)
|| 11/11/13 MFT 10.574 (196005) Altered VI label for clarity
|| 12/16/13 GHL 10.575 (199849) Altered VI label for even better clarity
|| 3/10/14  GHL 10.578 Change inner join with ERs to an outer join for companies that do not use items
|| 10/31/14 GHL 10.585 Added Worksheet ID for the new media screens
*/
	
Declare @CompanyKey int

If isnull(@InvoiceKey, 0) = 0 
	Select @CompanyKey = CompanyKey 
	from   tInvoice i (nolock) 
	inner  join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
	where  il.InvoiceLineKey = @InvoiceLineKey
else
	Select @CompanyKey = CompanyKey 
	from   tInvoice (nolock)
	Where  InvoiceKey = @InvoiceKey

If isnull(@InvoiceKey, 0) = 0 
	-- pull costs for a single invoice line

	Select
		er.InvoiceLineKey
		,er.ProjectKey
		,er.TaskKey
		,'ER' as Type
		,er.ExpenseReceiptKey as KeyFld
		,i.ItemID
		,i.ItemName
		,er.ActualQty as Quantity
		,er.ActualUnitCost as UnitCost
		,er.ActualCost as TotalCost
		,er.BillableCost as BillableCost
		,er.BillableCost as BillableCostOnLine
		,er.AmountBilled
		,er.Description as Description
		,er.ExpenseDate as TransactionDate
		,u.FirstName + ' ' + u.LastName as SourceName
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(er.BilledComment, er.Comments) as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(er.BilledItem, er.ItemKey) as BilledItem
		,case when er.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when er.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  

	from
		tExpenseReceipt er (nolock)
		inner join tUser u (nolock) on er.UserKey = u.UserKey
		left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on er.BilledItem = bi.ItemKey
		left outer join tProject p (nolock) on er.ProjectKey = p.ProjectKey
	Where
		er.InvoiceLineKey = @InvoiceLineKey 

	Union ALL
	
	Select
		mc.InvoiceLineKey
		,mc.ProjectKey
		,mc.TaskKey
		,'MC' as Type
		,mc.MiscCostKey as KeyFld
		,i.ItemID
		,i.ItemName
		,mc.Quantity
		,mc.UnitCost
		,mc.TotalCost
		,mc.BillableCost
		,mc.BillableCost as BillableCostOnLine
		,mc.AmountBilled
		,mc.ShortDescription as Description
		,mc.ExpenseDate as TransactionDate
		,u.FirstName + ' ' + u.LastName as SourceName
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(mc.BilledComment, mc.LongDescription) as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(mc.BilledItem, mc.ItemKey) as BilledItem
		,case when mc.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when mc.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID
	from
		tMiscCost mc (nolock)
		left outer join tUser u (nolock) on mc.EnteredByKey = u.UserKey
		left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on mc.BilledItem = bi.ItemKey
		left outer join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	Where
		mc.InvoiceLineKey = @InvoiceLineKey

	Union ALL
	
	Select
		vd.InvoiceLineKey
		,vd.ProjectKey
		,vd.TaskKey
		,'VO' as Type
		,vd.VoucherDetailKey as KeyFld
		,i.ItemID
		,i.ItemName
		,vd.Quantity
		,vd.UnitCost
		,vd.TotalCost
		,vd.BillableCost
		,vd.BillableCost as BillableCostOnLine
		,vd.AmountBilled
		,vd.ShortDescription as Description
		,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
		,case when isnull(vd.PurchaseOrderDetailKey, 0) > 0 
			then 
				case when po.POKind = 0 then 'PO: ' + po.PurchaseOrderNumber + ' on VI: ' + v.InvoiceNumber 
				     when po.POKind = 1 then isnull('IO: ' + po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber +  isnull(' WS: ' + mw.WorksheetID, '')
				     when po.POKind = 2 then isnull('BO: ' + po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber +  isnull(' WS: ' + mw.WorksheetID, '')
 			         else isnull(po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber +  isnull(' WS: ' + mw.WorksheetID, '')
				end
			else 'VI: ' + v.InvoiceNumber
			end as SourceName
		
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,CASE WHEN er.ExpenseReceiptKey IS NULL THEN c.CompanyName
		ELSE	' -- Converted from expense receipt -- Person: ' + u.FirstName + ' ' + u.LastName  + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
		END AS Comments
		,CAST(vd.BilledComment as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(vd.BilledItem, vd.ItemKey) as BilledItem
		,case when vd.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when vd.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on vd.BilledItem = bi.ItemKey
		left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
		left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		left outer join tUser u (nolock) on ee.UserKey = u.UserKey
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		left outer join tMediaWorksheet mw (nolock) on po.MediaWorksheetKey = mw.MediaWorksheetKey

	Where
		vd.InvoiceLineKey = @InvoiceLineKey
	
Union ALL
	
	Select
		pod.InvoiceLineKey
		,pod.ProjectKey
		,pod.TaskKey
		,'PO' as Type
		,pod.PurchaseOrderDetailKey as KeyFld
		,i.ItemID
		,i.ItemName
		,pod.Quantity
		,pod.UnitCost
		,pod.TotalCost
		,pod.BillableCost
		,CASE 
			WHEN po.BillAt = 0 THEN pod.BillableCost -- At Gross
			WHEN po.BillAt = 1 THEN pod.TotalCost -- At Net
			WHEN po.BillAt = 2 THEN pod.BillableCost - pod.TotalCost -- At Commission
		END AS BillableCostOnLine
		,pod.AmountBilled
		,pod.ShortDescription as Description
		,(Case po.POKind 
			When 0 then po.PODate
			When 1 then pod.DetailOrderDate 
			When 2 then pod.DetailOrderDate end)
			as TransactionDate
		,(Case po.POKind 
			When 0 then 'PO: ' + po.PurchaseOrderNumber 
			When 1 then isnull('IO: ' + po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '') 
			When 2 then isnull('BO: ' + po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '')
			Else isnull(po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '')
			end)
			as SourceName
		,mrr.ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(pod.BilledComment, pod.LongDescription) as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(pod.BilledItem, pod.ItemKey) as BilledItem
		,case when pod.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when pod.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on pod.BilledItem = bi.ItemKey
		left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey
		left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		left outer join tMediaWorksheet mw (nolock) on po.MediaWorksheetKey = mw.MediaWorksheetKey
	Where
		pod.InvoiceLineKey = @InvoiceLineKey AND
		po.CompanyKey = @CompanyKey

else
	-- pull costs for the whole invoice

	Select
		er.InvoiceLineKey
		,er.ProjectKey
		,er.TaskKey
		,'ER' as Type
		,er.ExpenseReceiptKey as KeyFld
		,i.ItemID
		,i.ItemName
		,er.ActualQty as Quantity
		,er.ActualUnitCost as UnitCost
		,er.ActualCost as TotalCost
		,er.BillableCost as BillableCost
		,er.BillableCost as BillableCostOnLine
		,er.AmountBilled
		,er.Description as Description
		,er.ExpenseDate as TransactionDate
		,u.FirstName + ' ' + u.LastName as SourceName
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(er.BilledComment, er.Comments) as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(er.BilledItem, er.ItemKey) as BilledItem
		,case when er.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when er.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tExpenseReceipt er (nolock)
		inner join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
		inner join tUser u (nolock) on er.UserKey = u.UserKey
		left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on er.BilledItem = bi.ItemKey
		left outer join tProject p (nolock) on er.ProjectKey = p.ProjectKey
	Where
		il.InvoiceKey = @InvoiceKey 

	Union ALL
	
	Select
		mc.InvoiceLineKey
		,mc.ProjectKey
		,mc.TaskKey
		,'MC' as Type
		,mc.MiscCostKey as KeyFld
		,i.ItemID
		,i.ItemName
		,mc.Quantity
		,mc.UnitCost
		,mc.TotalCost
		,mc.BillableCost
		,mc.BillableCost as BillableCostOnLine
		,mc.AmountBilled
		,mc.ShortDescription as Description
		,mc.ExpenseDate as TransactionDate
		,u.FirstName + ' ' + u.LastName as SourceName
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(mc.BilledComment, mc.LongDescription) as VARCHAR(6000)) as BillingComments
	
		-- for flex lookup
		,isnull(mc.BilledItem, mc.ItemKey) as BilledItem
		,case when mc.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when mc.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tMiscCost mc (nolock)
		inner join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey
		left outer join tUser u (nolock) on mc.EnteredByKey = u.UserKey
		left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on mc.BilledItem = bi.ItemKey
		left outer join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	Where
		il.InvoiceKey = @InvoiceKey

	Union ALL
	
	Select
		vd.InvoiceLineKey
		,vd.ProjectKey
		,vd.TaskKey
		,'VO' as Type
		,vd.VoucherDetailKey as KeyFld
		,i.ItemID
		,i.ItemName
		,vd.Quantity
		,vd.UnitCost
		,vd.TotalCost
		,vd.BillableCost
		,vd.BillableCost as BillableCostOnLine
		,vd.AmountBilled
		,vd.ShortDescription as Description
		,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
		,case when isnull(vd.PurchaseOrderDetailKey, 0) > 0 
			then 
				case when po.POKind = 0 then isnull('PO: ' + po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber
				     when po.POKind = 1 then isnull('IO: ' + po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber + isnull(' WS: ' + mw.WorksheetID, '')
				     when po.POKind = 2 then isnull('BO: ' + po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber + isnull(' WS: ' + mw.WorksheetID, '')
			         else isnull(po.PurchaseOrderNumber, '') + ' on VI: ' + v.InvoiceNumber
				end
			else 'VI: ' + v.InvoiceNumber
			end as SourceName
		
		,'' as ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,CASE WHEN er.ExpenseReceiptKey IS NULL THEN c.CompanyName
		ELSE	' -- Converted from expense receipt -- Person: ' + u.FirstName + ' ' + u.LastName  + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
		END AS Comments
		,CAST(vd.BilledComment as VARCHAR(6000)) as BillingComments
	
		-- for flex lookup
		,isnull(vd.BilledItem, vd.ItemKey) as BilledItem
		,case when vd.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when vd.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tVoucherDetail vd (nolock)
		inner join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on vd.BilledItem = bi.ItemKey	
		left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
		left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		left outer join tUser u (nolock) on ee.UserKey = u.UserKey
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		left outer join tMediaWorksheet mw (nolock) on po.MediaWorksheetKey = mw.MediaWorksheetKey
	Where
		il.InvoiceKey = @InvoiceKey
	
Union ALL
	
	Select
		pod.InvoiceLineKey
		,pod.ProjectKey
		,pod.TaskKey
		,'PO' as Type
		,pod.PurchaseOrderDetailKey as KeyFld
		,i.ItemID
		,i.ItemName
		,pod.Quantity
		,pod.UnitCost
		,pod.TotalCost
		,pod.BillableCost
		,CASE 
			WHEN po.BillAt = 0 THEN pod.BillableCost -- At Gross
			WHEN po.BillAt = 1 THEN pod.TotalCost -- At Net
			WHEN po.BillAt = 2 THEN pod.BillableCost - pod.TotalCost -- At Commission
		END AS BillableCostOnLine
		,pod.AmountBilled
		,pod.ShortDescription as Description
		,(Case po.POKind 
			When 0 then po.PODate
			When 1 then pod.DetailOrderDate 
			When 2 then pod.DetailOrderDate end)
			as TransactionDate
		,(Case po.POKind 
			When 0 then isnull('PO: ' + po.PurchaseOrderNumber, '') 
			When 1 then isnull('IO: ' + po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '')
			When 2 then isnull('BO: ' + po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '')
			Else isnull(po.PurchaseOrderNumber, '') + isnull(' WS: ' + mw.WorksheetID, '')
			end)
			as SourceName
		,mrr.ReasonID		
		,isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName
		,NULL AS Comments
		,CAST(ISNULL(pod.BilledComment, pod.LongDescription) as VARCHAR(6000)) as BillingComments

		-- for flex lookup
		,isnull(pod.BilledItem, pod.ItemKey) as BilledItem
		,case when pod.BilledItem is null then i.ItemName else bi.ItemName end as BilledItemName
		,case when pod.BilledItem is null then i.ItemID else bi.ItemID end as BilledItemID  
	from
		tPurchaseOrderDetail pod (nolock) 
		inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
		left outer join tItem bi (nolock) on pod.BilledItem = bi.ItemKey
		left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey
		left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		left outer join tMediaWorksheet mw (nolock) on po.MediaWorksheetKey = mw.MediaWorksheetKey 
	Where
		il.InvoiceKey = @InvoiceKey AND
		po.CompanyKey = @CompanyKey
GO
