USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionOrderAccrualGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionOrderAccrualGet]
	(
	@PurchaseOrderKey int
	,@PurchaseOrderDetailKey int = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel      What
  || 05/08/09 GHL 10.0.2.5 Creation to show Accrual Balance details on PO Header
  || 07/17/13 GHL 10.5.7.0 Added sort and detail order date for media   
  */

	SET NOCOUNT ON
	
	SELECT toa.*
			,toa.AccrualAmount - toa.UnaccrualAmount as AccruedAmount
			,po.PurchaseOrderNumber
			,po.POKind
			,pod.LineNumber
			,pod.AdjustmentNumber
			,pod.ShortDescription
			,isnull(pod.DetailOrderDate, po.PODate) as DetailOrderDate
			,CASE WHEN toa.Entity = 'INVOICE' THEN i.InvoiceNumber ELSE v.InvoiceNumber END  
			as InvoiceNumber
			,vd.LineNumber as VoucherLineNumber
	FROM   tPurchaseOrderDetail pod (NOLOCK)
		INNER JOIN tTransactionOrderAccrual toa (NOLOCK) 
			ON pod.PurchaseOrderDetailKey = toa.PurchaseOrderDetailKey
		INNER JOIN tPurchaseOrder po (NOLOCK) 
			ON pod.PurchaseOrderKey = po.PurchaseOrderKey	
		LEFT OUTER JOIN tVoucherDetail vd (NOLOCK) 
			ON toa.VoucherDetailKey = vd.VoucherDetailKey
		LEFT OUTER JOIN tVoucher v (NOLOCK) 
			ON vd.VoucherKey = v.VoucherKey
		LEFT OUTER JOIN tInvoice i (NOLOCK)
			ON toa.EntityKey = i.InvoiceKey AND toa.Entity = 'INVOICE'	
	WHERE pod.PurchaseOrderKey = @PurchaseOrderKey
	AND   (@PurchaseOrderDetailKey IS NULL OR
			pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		   )
	ORDER BY pod.LineNumber, pod.AdjustmentNumber, pod.DetailOrderDate
			   	
	RETURN 1
GO
