USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailBCGetAppliedSpots]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailBCGetAppliedSpots]
	(
	@PurchaseOrderKey int,
	@PurchaseOrderDetailKey int	
	)
AS --Encrypt

/*
|| 06/25/13 GHL 10.5.6.9	Created to populate the 'Applied Spots' grid on bc_details
||                          Similar to the 'Billed Spots' already displayed
*/

SET NOCOUNT ON 

declare @LineNumber int
declare @AdjustmentNumber int

if @PurchaseOrderDetailKey = 0 
		select @LineNumber = 1
			  ,@AdjustmentNumber = 0
		  from tPurchaseOrder po (nolock) 
		 where PurchaseOrderKey = @PurchaseOrderKey
	else
		select @LineNumber = pod.LineNumber
			  ,@AdjustmentNumber = isnull(pod.AdjustmentNumber, 0)
		  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
         and   TransferToKey is null

Select 
	pod.PurchaseOrderDetailKey 
	,pod.DetailOrderDate 
	,pod.Quantity   
	
	,v.InvoiceDate 
	,v.InvoiceNumber 
	,v.VoucherKey 
	
	,vd.VoucherDetailKey
	,vd.Quantity as AppliedQuantity
	,vd.TotalCost
	,vd.BillableCost

from tPurchaseOrderDetail pod (nolock)
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		left outer join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
where pod.PurchaseOrderKey = @PurchaseOrderKey
and pod.LineNumber = @LineNumber
and isnull(pod.AdjustmentNumber, 0) = @AdjustmentNumber
and   pod.TransferToKey is null
and   vd.TransferToKey is null
order by pod.AdjustmentNumber, pod.DetailOrderDate

	RETURN
GO
