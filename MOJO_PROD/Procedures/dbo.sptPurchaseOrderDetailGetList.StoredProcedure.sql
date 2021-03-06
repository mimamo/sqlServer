USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailGetList]
	@PurchaseOrderKey int
	
AS --Encrypt

/*
|| When     Who Rel      What
|| 08/27/09 GHL 10.5     Added filter on TransferToKey NULL
|| 07/20/10 MFT 10.532   Added FieldSetName and FieldSetKey
|| 08/02/10 MFT 10.533   Added OfficeName and DepartmentName
|| 08/03/10 MFT 10.533   Set ISNULL for FieldSetName and FieldSetKey
|| 10/13/10 MFT 10.536   Added BillingDetail subquery and FormattedLineNumber
|| 08/19/13 CRG 10.5.7.1 Added join to tMediaPremium
|| 10/17/13 MFT 10.5.7.3 Added tVoucherDetail/PrebillAmount subquery & tInvoiceLine/tInvoice joins
|| 10/30/13 CRG 10.5.7.3 Added DateBilled and ClientBillingStatus
|| 12/11/13 GHL 10.5.7.5 Added InvoiceKey so that we can load the invoice screen from the PO screen 
|| 01/07/14 CRG 10.5.7.6 Added Detail VendorID and CompanyName
|| 03/19/14 CRG 10.5.7.8 Now using ShortDescription to hold the Premium name when a user has entered a free form premium
|| 06/02/14 GHL 10.5.8.0 Added revision of the media order (SM's request)
|| 09/11/14 GHL 10.5.8.4 Added LastAdjustment field for new media screens (to point to the most recent POD)
|| 10/28/14 GHL 10.5.8.5 Added vendor invoice to show on the new media screens (SM's request) 
|| 11/18/14 GHL 10.5.8.6 Added client invoice linked to vendor invoice linked to POD detail (SM's request)
|| 12/11/14 GHL 10.5.8.7 Added amount billed on the vendor invoice linked to POD detail (SM's request)
*/

-- For new media screen, SM's request. 
-- Need client invoice linked to vendor invoice linked to PO detail 
-- in addition to client invoice linked to PO detail
create table #vi_invoices (PurchaseOrderDetailKey int null, VoucherDetailKey int null, AmountBilled money null
    , VoucherKey int null, VendorInvoiceNumber varchar(50) null
	, VIInvoiceKey int null,  VIInvoiceNumber varchar(50) null)

insert #vi_invoices (PurchaseOrderDetailKey)
select PurchaseOrderDetailKey 
from   tPurchaseOrderDetail (nolock)
where  PurchaseOrderKey = @PurchaseOrderKey

-- take the max because this is a 1-to-many relationship
update #vi_invoices
set    #vi_invoices.VoucherDetailKey = isnull((
	select max(vd.VoucherDetailKey) 
	from tVoucherDetail vd (nolock) 
	where vd.PurchaseOrderDetailKey = #vi_invoices.PurchaseOrderDetailKey
	),0)

update #vi_invoices
set    #vi_invoices.VoucherKey = v.VoucherKey
      ,#vi_invoices.VendorInvoiceNumber = v.InvoiceNumber
	  ,#vi_invoices.AmountBilled = vd.AmountBilled
from   tVoucherDetail vd (nolock)
	   ,tVoucher v (nolock)
where  #vi_invoices.VoucherDetailKey = vd.VoucherDetailKey
and    vd.VoucherKey = v.VoucherKey

update #vi_invoices
set    #vi_invoices.VIInvoiceKey = i.InvoiceKey
      ,#vi_invoices.VIInvoiceNumber = i.InvoiceNumber
from   tInvoiceLine il (nolock)    
       ,tInvoice i (nolock)
	   ,tVoucherDetail vd (nolock)
where  #vi_invoices.VoucherDetailKey = vd.VoucherDetailKey
and    vd.InvoiceLineKey = il.InvoiceLineKey
and    il.InvoiceKey = i.InvoiceKey

	SELECT
		'' AS Error, '' AS EditLine,
		po.*,
		CASE WHEN ISNULL(po.AdjustmentNumber, 0) > 0 THEN LTRIM(STR(po.LineNumber)) + '.' + LTRIM(STR(po.AdjustmentNumber)) ELSE LTRIM(STR(po.LineNumber)) END AS FormattedLineNumber,
		ISNULL(fs.FieldSetName, 'General') AS FieldSetName,
		ISNULL(fs.FieldSetKey, 0) AS FieldSetKey,
		p.ProjectNumber,
		p.ProjectName,
		t.TaskID,
		t.TaskName,
		i.ItemID,
		i.ItemName,
		cl.ClassID,
		cl.ClassName,
		mrr.ReasonID,
		o.OfficeName,
		d.DepartmentName,
		ISNULL(bd.BillingDetail, 0) AS BillingDetail,
		ISNULL(mp.PremiumID, po.ShortDescription) AS PremiumID,
		mp.PremiumShortName,
		ISNULL(mp.PremiumName, po.ShortDescription) AS PremiumName,
		vd.PrebillAmount AS AmountUnaccrued,
		ISNULL(po.AccruedCost, 0) - isnull(vd.PrebillAmount, 0) AS OpenAccrual,
		vd.TotalCost AS AmountApplied,
		case when vd.PurchaseOrderDetailKey is null then 0 else 1 end As Applied,
		inv.InvoiceKey,
		inv.InvoiceNumber,
		inv.InvoiceDate AS DateBilled,
		CASE inv.InvoiceStatus
			WHEN 1 THEN 'Not Sent for Approval'
			WHEN 2 THEN 'Sent for Approval'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN
				CASE inv.Posted
					WHEN 1 THEN 'Posted'
					ELSE 'Approved'
				END
		END AS ClientBillingStatus,
		dv.VendorID,
		dv.CompanyName,
		
		-- for new media screens
		por.Revision,
		mo.Revision as MediaOrderRevision,
		case when adjustments.LineNumber is null then 0 else 1 end as LastAdjustment,
		#vi_invoices.VoucherKey,
		#vi_invoices.VendorInvoiceNumber,
		#vi_invoices.VIInvoiceKey,
		#vi_invoices.VIInvoiceNumber,
		#vi_invoices.AmountBilled as VIAmountBilled
	FROM 
		tPurchaseOrderDetail po (nolock)
		left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on po.TaskKey = t.TaskKey
		left outer join tItem i (nolock) on po.ItemKey = i.ItemKey
		left outer join tClass cl (nolock) on po.ClassKey = cl.ClassKey
		left outer join tOffice o (nolock) on po.OfficeKey = o.OfficeKey
		left outer join tDepartment d (nolock) on po.DepartmentKey = d.DepartmentKey
		left outer join tMediaRevisionReason mrr (nolock) on po.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey
		left outer join tObjectFieldSet ofs (nolock) on po.CustomFieldKey = ofs.ObjectFieldSetKey
		left outer join tFieldSet fs (nolock) on fs.FieldSetKey = ofs.FieldSetKey
		left outer join tMediaPremium mp (nolock) ON po.MediaPremiumKey = mp.MediaPremiumKey
		left outer join tInvoiceLine il (nolock) ON po.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice inv (nolock) ON il.InvoiceKey = inv.InvoiceKey
		left outer join tCompany dv (nolock) ON po.DetailVendorKey = dv.CompanyKey
		left outer join tPurchaseOrder por (nolock) on po.PurchaseOrderKey = por.PurchaseOrderKey 
		left outer join tMediaOrder mo (nolock) on por.MediaOrderKey = mo.MediaOrderKey
 		left outer join #vi_invoices (nolock) on po.PurchaseOrderDetailKey = #vi_invoices.PurchaseOrderDetailKey 
		left outer join
		(
			SELECT
				bd.EntityKey AS PurchaseOrderDetailKey,
				1 AS BillingDetail
			FROM
				tBillingDetail bd (nolock)
				INNER JOIN tBilling b (nolock)
					ON bd.BillingKey = b.BillingKey
			WHERE
				bd.Entity = 'tPurchaseOrderDetail' AND
				b.Status < 5
			GROUP BY
				bd.EntityKey
		) bd
			ON bd.PurchaseOrderDetailKey = po.PurchaseOrderDetailKey
		left outer join
		(
			SELECT
				PurchaseOrderDetailKey,
				SUM(PrebillAmount) AS PrebillAmount,
				SUM(TotalCost) AS TotalCost
			FROM
				tVoucherDetail (nolock)
			GROUP BY
				PurchaseOrderDetailKey
		) vd ON po.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey

		-- this is used for the new media screens
		left outer join
		(
		select max(pod.PurchaseOrderDetailKey) as PurchaseOrderDetailKey
		      ,pod.LineNumber
		from tPurchaseOrderDetail pod (nolock)
		where pod.PurchaseOrderKey = @PurchaseOrderKey
		group by pod.LineNumber  
		) adjustments on po.PurchaseOrderDetailKey = adjustments.PurchaseOrderDetailKey
		 
	WHERE po.PurchaseOrderKey = @PurchaseOrderKey
		AND po.TransferToKey IS NULL
	ORDER BY
		po.LineNumber, po.AdjustmentNumber, po.PurchaseOrderDetailKey

	RETURN 1
GO
