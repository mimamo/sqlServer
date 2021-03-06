USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderSpotChangeClose]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderSpotChangeClose]

	(
		@PurchaseOrderDetailKey int,
		@Closed tinyint,
		@AffectBilling int = 1
	)

AS --encrypt

/*
|| When     Who Rel     What
|| 03/01/07 GHL 8.4   Added project rollup section
|| 10/01/07 GHL 8.5     Added logic for DateClosed  
|| 09/03/14 GHL 10.584  (228260) Take in account Cancelled flags when closing/opening
|| 10/23/14 GHL 10.585 (233784, 233644) AmountBilled = 0 if order is applied to VI
*/
Declare @PurchaseOrderKey int
        ,@ProjectKey int

Declare @POCancelled int, @PODCancelled int 

Declare @Today smalldatetime
Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)


	select @PurchaseOrderKey = pod.PurchaseOrderKey
			,@ProjectKey = pod.ProjectKey
			,@POCancelled = isnull(po.Cancelled, 0)
			,@PODCancelled = isnull(pod.Cancelled, 0)
	from tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if (@PODCancelled = 1 Or @POCancelled = 1)
		Select @Closed = 1

	update tPurchaseOrderDetail
	set Closed = @Closed 
		,DateClosed = case when @Closed = 1 then
				case when DateClosed is null then @Today else DateClosed end 
				else null end 
	where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if @AffectBilling = 1
	begin
		if @Closed = 1
		begin
			update tPurchaseOrderDetail
			set    tPurchaseOrderDetail.InvoiceLineKey = 0
					,tPurchaseOrderDetail.AmountBilled =  CASE isnull(po.BillAt, 0) 
						WHEN 0 THEN ISNULL(tPurchaseOrderDetail.BillableCost, 0)
						WHEN 1 THEN ISNULL(tPurchaseOrderDetail.TotalCost,0)
						WHEN 2 THEN ISNULL(tPurchaseOrderDetail.BillableCost,0) - ISNULL(tPurchaseOrderDetail.TotalCost,0) 
					END
					,tPurchaseOrderDetail.DateBilled = isnull(tPurchaseOrderDetail.DateBilled, @Today)
			from   tPurchaseOrder po (nolock)
			where  tPurchaseOrderDetail.PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
			and    tPurchaseOrderDetail.TransferToKey is null
			and    isnull(tPurchaseOrderDetail.InvoiceLineKey, 0) = 0 -- if not prebilled
			and    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey

			-- But if applied to a vendor invoice, AmountBilled = 0
			UPDATE tPurchaseOrderDetail
			SET    tPurchaseOrderDetail.AmountBilled = 0 -- BillableCost
			FROM   tVoucherDetail vd (nolock)
			WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			AND    isnull(tPurchaseOrderDetail.InvoiceLineKey, 0) = 0 -- not prebilled
			AND    tPurchaseOrderDetail.TransferToKey is null
			AND    tPurchaseOrderDetail.PurchaseOrderDetailKey  = vd.PurchaseOrderDetailKey  
		end
		else
			update tPurchaseOrderDetail
			set    InvoiceLineKey = null
					,AmountBilled = 0
					,DateBilled = null
			where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
			and    TransferToKey is null
			and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled 
	end

	If exists(select 1 from tPurchaseOrderDetail (nolock) where PurchaseOrderKey = @PurchaseOrderKey and isnull(Closed, 0) = 0)
		update tPurchaseOrder set Closed = 0 where PurchaseOrderKey = @PurchaseOrderKey
	else
		update tPurchaseOrder set Closed = 1 where PurchaseOrderKey = @PurchaseOrderKey

	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
GO
