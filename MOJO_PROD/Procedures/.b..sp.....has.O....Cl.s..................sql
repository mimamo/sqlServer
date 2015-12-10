USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderClose]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderClose]
	(
	@PurchaseOrderKey int
	,@UserKey int
	,@PostingDate datetime = null
	,@PrebilledOnly int = 0
	,@MarkBilled int = 1
	,@VoucherKey int output
	)
AS --Encrypt

 /*
  || When     Who Rel   What
  || 03/01/07 GHL 8.4   Added project rollup section
  || 04/17/07 BSH 8.4.5 DateUpdated needed to be updated.
  || 10/01/07 GHL 8.5   Added logic for DateClosed
  || 04/27/09 GHL 10.024 Added accrual completion logic
  || 11/19/10 MFT 10.538 Removed requirement that lines exist in order to close PO
  || 02/01/12 GHL 10.552 Added params PostingDate + @PrebilledOnly
  || 12/14/12 WDF 10.563 (162210) Added LastUpdateBY
  || 09/02/14 GHL 10.584 (228260) When closing, mark as billed, when opening, mark as unbilled
  || 10/23/14 GHL 10.585 (233784, 233644) AmountBilled = 0 if order is applied to VI
  */
  
Declare @Today smalldatetime

Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)

if @PostingDate is null
	select @PostingDate = @Today

if @PrebilledOnly = 0
begin
	-- do not overwrite the date closed if it was closed earlier
	UPDATE tPurchaseOrderDetail
	SET    Closed = 1
			 ,DateClosed = CASE WHEN DateClosed IS NULL THEN @PostingDate ELSE DateClosed END 
	WHERE  PurchaseOrderKey = @PurchaseOrderKey

	if @MarkBilled = 1
	begin
		-- Mark as Billed
		update tPurchaseOrderDetail
		set    tPurchaseOrderDetail.InvoiceLineKey = 0
			  ,tPurchaseOrderDetail.AmountBilled = CASE isnull(po.BillAt, 0) 
						WHEN 0 THEN ISNULL(tPurchaseOrderDetail.BillableCost, 0)
						WHEN 1 THEN ISNULL(tPurchaseOrderDetail.TotalCost,0)
						WHEN 2 THEN ISNULL(tPurchaseOrderDetail.BillableCost,0) - ISNULL(tPurchaseOrderDetail.TotalCost,0) 
					END
			  ,tPurchaseOrderDetail.DateBilled = isnull(tPurchaseOrderDetail.DateBilled, @PostingDate)
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

end
else
begin
	-- do not overwrite the date closed if it was closed earlier
	UPDATE tPurchaseOrderDetail
	SET    Closed = 1
			 ,DateClosed = CASE WHEN DateClosed IS NULL THEN @PostingDate ELSE DateClosed END 
	WHERE  PurchaseOrderKey = @PurchaseOrderKey
	AND    isnull(InvoiceLineKey, 0) > 0

end


if @PrebilledOnly = 0
begin
	UPDATE tPurchaseOrder
	SET    Closed = 1
			,DateUpdated = @PostingDate
			,LastUpdateBy = @UserKey
	WHERE  PurchaseOrderKey = @PurchaseOrderKey
end
else
begin
	If not exists(select 1 from tPurchaseOrderDetail (nolock) where PurchaseOrderKey = @PurchaseOrderKey and isnull(Closed, 0) = 0)
		UPDATE tPurchaseOrder
		SET    Closed = 1
				,DateUpdated = @PostingDate
				,LastUpdateBy = @UserKey
		WHERE  PurchaseOrderKey = @PurchaseOrderKey
end

/*
|| This sp creates vouchers to fix orders accrual problems    
|| Returns are:
||  -1	-- nothing to unaccrue, no voucher created
||  -2	-- error creating voucher
||  1	-- voucher created to unaccrue
*/

Declare @RetVal int

Exec @RetVal = sptPurchaseOrderCompleteAccrual @PurchaseOrderKey , NULL, @UserKey, @PostingDate, @VoucherKey output

If @RetVal <> 1
	Select @VoucherKey = NULL


EXEC sptProjectRollupUpdateEntity 'tPurchaseOrder', @PurchaseOrderKey
GO
