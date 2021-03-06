USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDVoucher]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDVoucher]

	(
		@ProjectKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 03/17/08 CRG 1.0.0.0 Added columns for new Project Budget View        
*/

	Select
		ta.TaskID,
		ta.TaskKey,
		c.CompanyName,
		c.VendorID,
		isnull(i.ItemName, '[No Item]') As ItemName,
		isnull(i.ItemKey, 0) As ItemKey,
		v.VoucherKey,
		v.InvoiceDate,
		v.InvoiceNumber,
		vd.ProjectKey,
		vd.ShortDescription,
		vd.Quantity,
		vd.UnitCost,
		vd.TotalCost,
		vd.BillableCost,
		vd.InvoiceLineKey,
		vd.WriteOff,
		ISNULL(c.VendorID, '') + '-' + ISNULL(c.CompanyName, '') AS VendorIDName,
		v.PostingDate,
		vd.UnitRate,
		vd.Billable,
		vd.AmountBilled,
		inv.InvoiceNumber AS ClientInvoiceNumber,
		inv.InvoiceDate AS ClientInvoiceDate,
		inv.PostingDate AS ClientInvoicePostingDate,
		CASE vd.WriteOff
			WHEN 1 THEN vd.DateBilled
			ELSE NULL
		END AS WriteOffDate,
		wor.ReasonName AS WriteOffReason,
		CASE vd.WIPPostingInKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedIntoWIP,
		CASE vd.WIPPostingOutKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedOutOfWIP,
		vd.TransferComment,
		po.PurchaseOrderNumber,
		CASE v.Status
			WHEN 4 THEN 1
			ELSE 0
		END AS ApprovalStatus, --Used for grid filtering		
		CASE 
			WHEN vd.InvoiceLineKey IS NULL THEN
				CASE vd.WriteOff
					WHEN 1 THEN 'Written Off'
					ELSE 'Unbilled'
				END
			ELSE 'Billed'
		END AS BillingStatus
	From
		tVoucherDetail vd (nolock)
		Inner Join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
		Inner Join tTask ta (nolock) on ta.TaskKey = vd.TaskKey
		Inner Join tCompany c (nolock) on c.CompanyKey = v.VendorKey
		Left Outer Join tItem i (nolock) on vd.ItemKey = i.ItemKey
		LEFT JOIN tInvoiceLine il (nolock) ON vd.InvoiceLineKey = il.InvoiceLineKey
		LEFT JOIN tInvoice inv (nolock) ON il.InvoiceKey = inv.InvoiceKey
		LEFT JOIN tWriteOffReason wor (nolock) ON vd.WriteOffReasonKey = wor.WriteOffReasonKey
		LEFT JOIN tPurchaseOrderDetail pod (nolock) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		LEFT JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where
		vd.ProjectKey = @ProjectKey
	ORDER BY v.InvoiceNumber
GO
