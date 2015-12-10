USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailGetList]
	@VoucherKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/19/08 GHL 8.5     (21547) Sorting now by VoucherDetailKey because users complain about change of
||                       position of the lines
|| 08/27/09 GHL 10.5    Added filter on TransferToKey NULL
|| 04/04/11 MFT 10.542  Added ProjectName, TaskName and ItemName
|| 08/11/11 GHL 10.547  Added CustomerID, ClientName + DepartmentName + OfficeID + OfficeName for flex lookups
|| 09/09/11 GHL 10.547  Added TotalCostWithTax for CreditCardEdit.mxml
|| 12/05/11 GHL 10.550  Added POKind to help out with the commissions/markups + PurchaseOrderKey
|| 12/08/11 GHL 10.550  Added PO info required for prebilled logic
|| 12/12/11 GHL 10.550  Corrected PO Cost fields 
|| 12/29/11 GHL 10.551  Added project costing info similarly to sptVoucherDetailGet for Flex app
|| 01/18/12 GHL 10.552  Added InvoiceNumber and BillingID and MarkedBilled to show on grids
|| 05/11/12 GHL 10.556  (142898) Added InvoiceNumber for the prebilled PO
|| 05/21/12 GHL 10.556  Addd Company ID/Name for TargetGLCompanyKey
|| 06/29/12 GHL 10.557  Added ProjectGLCompanyKey to help with validations
|| 09/22/12 GHL 10.560  (153619) Added po PODate pod DetailOrderDate and DetailOrderEndDate + pod BillableCost
||                      to show on voucher flex screen 
|| 12/14/12 GHL 10.563  Added Line + Adjustment field for POD flex lookup
|| 04/17/12 GHL 10.567  Added POLineAdjustment to help out with Media Accrued Order issues
|| 04/30/12 GHL 10.567  Added POLinkID to help out with Media Accrued Order issues
|| 10/15/13 GHL 10.573  Changes for GrossAmount
|| 10/30/13 GHL 10.573  Added AppliedPTotalCost = sum of vd.PTotalCost applied to a POD (needed for multi currency)  
|| 10/22/14 GHL 10.585 (228260) When closing, mark as billed, when opening, mark as unbilled
||                      For this reason, look at InvoiceLineKey to calculate POAmountBilled
|| 02/11/15 GHL 10.589  Added media worksheet info for the new media screens
|| 02/25/15 GHL 10.589  Added MORE media worksheet info for the new media screens
*/

declare @ExchangeRate decimal(24, 7) -- This is the vendor exchange rate

select @ExchangeRate = isnull(ExchangeRate, 1) from tVoucher (nolock) where VoucherKey = @VoucherKey
 
SELECT vd.*
		,po.PurchaseOrderKey
		,po.PurchaseOrderNumber
		,po.POKind
		,po.PODate
		,pod.LineNumber AS POLineNumber
		,pod.AdjustmentNumber As POAdjustmentNumber 
		,pod.DetailOrderDate
		,pod.DetailOrderEndDate
		,p.ProjectNumber
		,p.ProjectName
		,p.GetMarkupFrom
		,p.ItemRateSheetKey
		,p.GLCompanyKey as ProjectGLCompanyKey
  		,t.TaskID
		,t.TaskName
		,gl.AccountNumber
		,gl.AccountName
		,cl.ClassID
		,i.ItemID
		,i.ItemName
		
		,mrr.ReasonID 				
		,c.CustomerID
		,c.CompanyName as ClientName
		,d.DepartmentName
		,o.OfficeID
		,o.OfficeName

		,glc.GLCompanyID
		,glc.GLCompanyName

		,isnull(vd.TotalCost, 0) + isnull(vd.SalesTaxAmount, 0) as TotalCostWithTax

		-- POD info required for prebilled logic in Flex...similar to sptVoucherDetailGet
		,pod.TotalCost as POTotalCost
		,case when pod.InvoiceLineKey > 0 then pod.AmountBilled else 0 end as POAmountBilled
		,pod.BillableCost as POBillableCost
		
		,ISNULL((SELECT SUM(vd2.TotalCost)
						FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedCost 
		/*
       ,ISNULL((SELECT SUM(vd2.TotalCost * (1 + vd2.Markup / 100)) 
			   			FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedBillableCost 
		*/

		-- this must be calculated in the project currency
		,ISNULL((SELECT SUM(
							case when isnull(vd2.PExchangeRate, 0) = 0
							then round((vd2.GrossAmount * @ExchangeRate), 2)
							else round((vd2.GrossAmount * @ExchangeRate) / vd2.PExchangeRate, 2)
						    end
							) 
			   			FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedBillableCost 
		,ISNULL((SELECT SUM(vd2.PTotalCost) 
			   			FROM tVoucherDetail vd2 (NOLOCK)
						WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey -- same POD
						AND   vd2.VoucherDetailKey <> vd.VoucherDetailKey             -- but diff VD
						), 0) AS POOtherAppliedPTotalCost 

		,inv.InvoiceKey
		,inv.InvoiceNumber as BilledInvoiceNumber
		
		,case when isnull(inv.InvoiceKey, 0) = 0 then bill.BillingKey else 0 end as BillingKey
		,case when isnull(inv.InvoiceKey, 0) = 0 then 
			case when bill.BillingID is null then ''
			else cast (bill.BillingID as varchar(50)) end  
		else '' end as BillingID 
		,case when vd.InvoiceLineKey = 0 then 1 else 0 end as MarkedBilled  

		,pod_inv.InvoiceKey as PrebilledInvoiceKey
		,pod_inv.InvoiceNumber as PrebilledInvoiceNumber
		
		, po.PurchaseOrderNumber 
		+ ' ' + cast(pod.LineNumber as varchar(20)) 
		+ '.' + isnull(cast(pod.AdjustmentNumber as varchar(20)), '0') 
		as POLineAdjustment
		, pod.LinkID as POLinkID
		,isnull(po.BillAt, 0) as BillAt
		,case when po.BillAt = 0 then 'Gross'
			  when po.BillAt = 1 then 'Net'
			  when po.BillAt = 2 then 'Commission'
			  else ''
		end as BillAtDescription
		,po.MediaWorksheetKey
		,mws.WorksheetID
		,po.InternalID
		,mo.Revision as MediaOrderRevision

FROM tVoucherDetail vd (NOLOCK)
	LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	LEFT OUTER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tTask t (NOLOCK) ON vd.TaskKey = t.TaskKey 
	LEFT OUTER JOIN tGLAccount gl (nolock) on vd.ExpenseAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tClass cl (nolock) on vd.ClassKey = cl.ClassKey	
	LEFT OUTER JOIN tItem i (nolock) on vd.ItemKey = i.ItemKey
	left outer join tMediaRevisionReason mrr (nolock) on pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey
	left outer join tCompany c (nolock) on vd.ClientKey = c.CompanyKey		
	left outer join tDepartment d (nolock) on vd.DepartmentKey = d.DepartmentKey
	left outer join tOffice o (nolock) on vd.OfficeKey = o.OfficeKey
	left outer join tGLCompany glc (nolock) on vd.TargetGLCompanyKey = glc.GLCompanyKey 

	left outer join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
	left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey

	left outer join tInvoiceLine pod_il (nolock) on pod.InvoiceLineKey = pod_il.InvoiceLineKey
	left outer join tInvoice pod_inv (nolock) on pod_il.InvoiceKey = pod_inv.InvoiceKey

	left outer join (
		select max(b.BillingKey) as BillingKey, max(b.BillingID) as BillingID, vd2.VoucherDetailKey
		from   tBillingDetail bd (nolock)
		inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
		inner join tVoucherDetail vd2 (nolock) on bd.EntityKey = vd2.VoucherDetailKey
		where b.Status < 5 -- not invoiced
		and  bd.Entity = 'tVoucherDetail'
		and  vd2.VoucherKey = @VoucherKey
		group by vd2.VoucherDetailKey
	) as bill on bill.VoucherDetailKey = vd.VoucherDetailKey

	left outer join tMediaWorksheet mws (nolock) on po.MediaWorksheetKey = mws.MediaWorksheetKey
	left outer join tMediaOrder mo (nolock) on po.MediaOrderKey = mo.MediaOrderKey
WHERE vd.VoucherKey = @VoucherKey
AND   vd.TransferToKey IS NULL
ORDER BY vd.VoucherDetailKey	

RETURN 1
GO
