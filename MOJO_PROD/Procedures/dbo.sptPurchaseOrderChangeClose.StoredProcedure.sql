USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderChangeClose]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderChangeClose]

	(
		@PurchaseOrderKey int,
		@Closed tinyint,
		@UserKey int,
		@AffectBilling int = 1
	)

AS

 /*
  || When     Who Rel   What
  || 03/01/07 GHL 8.4   Added project rollup section
  || 04/17/07 BSH 8.4.5 DateUpdated needed to be updated.
  || 10/01/07 GHL 8.5   Added logic for DateClosed  
  || 09/14/09 GHL 10.5  Added logic for Transfers
  || 01/17/11 GHL 10.430 Added call to sptPurchaseOrderCompleteAccrual to unaccrue prebilled orders
  || 12/14/12 WDF 10.563 (162210) Added LastUpdateBy
  || 09/02/14 GHL 10.584 (228260) When closing, mark as billed, when opening, mark as unbilled
  || 10/23/14 GHL 10.585 (233784, 233644) AmountBilled = 0 if order is applied to VI
  */

Declare @Today smalldatetime
Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)

Update tPurchaseOrder 
Set    Closed = @Closed
      ,DateUpdated = @Today
      ,LastUpdateBy = @UserKey
Where PurchaseOrderKey = @PurchaseOrderKey

Update tPurchaseOrderDetail 
Set    Closed = @Closed 
      ,DateClosed = case when @Closed = 1 then
			case when DateClosed is null then @Today else DateClosed end 
			else null end   
Where PurchaseOrderKey = @PurchaseOrderKey
And   TransferToKey is null

If @AffectBilling = 1
begin
	If @Closed = 1
	begin
		-- close, mark as billed
		update tPurchaseOrderDetail
		set    tPurchaseOrderDetail.InvoiceLineKey = 0
			  ,tPurchaseOrderDetail.AmountBilled = CASE isnull(po.BillAt, 0) 
						WHEN 0 THEN ISNULL(tPurchaseOrderDetail.BillableCost, 0)
						WHEN 1 THEN ISNULL(tPurchaseOrderDetail.TotalCost,0)
						WHEN 2 THEN ISNULL(tPurchaseOrderDetail.BillableCost,0) - ISNULL(tPurchaseOrderDetail.TotalCost,0) 
					END
			  ,tPurchaseOrderDetail.DateBilled = isnull(tPurchaseOrderDetail.DateBilled, @Today)
		from   tPurchaseOrder po (nolock)
		where  tPurchaseOrderDetail.PurchaseOrderKey = @PurchaseOrderKey
		and    tPurchaseOrderDetail.TransferToKey is null
		and    isnull(tPurchaseOrderDetail.InvoiceLineKey, 0) = 0 -- if not prebilled 
		and    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey   

		-- But if applied to a vendor invoice, AmountBilled = 0
		UPDATE tPurchaseOrderDetail
		SET    tPurchaseOrderDetail.AmountBilled = 0 -- BillableCost
		FROM   tVoucherDetail vd (nolock)
		WHERE  tPurchaseOrderDetail.PurchaseOrderKey = @PurchaseOrderKey
		AND    isnull(tPurchaseOrderDetail.InvoiceLineKey, 0) = 0 -- not prebilled
		AND    tPurchaseOrderDetail.TransferToKey is null
		AND    tPurchaseOrderDetail.PurchaseOrderDetailKey  = vd.PurchaseOrderDetailKey
	end
	else
		-- reopen, mark billable
		update tPurchaseOrderDetail
		set    InvoiceLineKey = null
			  ,AmountBilled = 0
			  ,DateBilled = null
		where  PurchaseOrderKey = @PurchaseOrderKey
		and    TransferToKey is null
		and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled  
end
	     

EXEC sptProjectRollupUpdateEntity 'tPurchaseOrder', @PurchaseOrderKey

/*
|| This sp creates vouchers to fix orders accrual problems    
|| Returns are:
||  -1	-- nothing to unaccrue, no voucher created
||  -2	-- error creating voucher
||  1	-- voucher created to unaccrue
*/

If @Closed = 0
	RETURN 1

Declare @RetVal int, @VoucherKey int
Exec @RetVal = sptPurchaseOrderCompleteAccrual @PurchaseOrderKey , NULL, NULL, NULL, @VoucherKey output
If @RetVal <> 1
	Select @VoucherKey = NULL
GO
