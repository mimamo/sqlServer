USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailChangeClose]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailChangeClose]

	(
		@PurchaseOrderDetailKey int
		,@Closed tinyint
		,@UserKey int
		,@PostingDate datetime = null
		,@CompleteAccrual int = 1
		,@ProcessAllSpots int = 1 -- Passing in a 2 will close the spot and all adjustment lines.
		,@AffectBilling int = 1 -- mark as billed or unbilled
		,@VoucherKey int output
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/02/07 RTC 8.4.0.3 8141 - Close only the PODs with the same line and adjustment number. Adjustment lines were also being closed.
|| 03/01/07 GHL 8.4     Added project rollup section
|| 10/01/07 GHL 8.5     Added logic for DateClosed  
|| 04/27/09 GHL 10.024  Added accrual completion logic
|| 05/20/09 GHL 10.024  Only do accrual completion if Closed = 1
|| 09/14/09 GHL 10.5    Added logic for Transfers
|| 02/01/12 GHL 10.552  Added PostingDate param + CompleteAccrual
|| 09/12/12 GHL 10.560  (154152) When closing/opening BOs, added parameter to close/open all spots or a single spot
|| 12/14/12 WDF 10.563 (162210) Added LastUpdateBy to tPurchaseOrder update
|| 12/19/12 MAS 10.563 (162955) When @ProcessAllSpots = 2 - close the spot and all of it's adjustment lines. 
|| 09/02/14 GHL 10.584 (228260) When closing, mark as billed, when opening, mark as unbilled
|| 10/23/14 GHL 10.585 (233784, 233644) AmountBilled = 0 if order is applied to VI
*/

Declare @PurchaseOrderKey int
declare @POKind smallint
declare @LineNumber int
declare @AdjustmentNumber int
declare @ProjectKey int
declare @DetailOrderDate smalldatetime, @DetailOrderEndDate smalldatetime

Declare @Today smalldatetime
Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)

if @PostingDate is null
	select @PostingDate = @Today

	select @PurchaseOrderKey = po.PurchaseOrderKey
		  ,@ProjectKey = pod.ProjectKey
		  ,@POKind = po.POKind
	      ,@LineNumber = pod.LineNumber
	      ,@AdjustmentNumber = pod.AdjustmentNumber
	      ,@DetailOrderDate = DetailOrderDate
		  ,@DetailOrderEndDate = DetailOrderEndDate
	  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if @POKind = 2 And @ProcessAllSpots = 2
	begin
		-- update the spot and all of it's adjustments
		update tPurchaseOrderDetail
		   set Closed = @Closed
			  ,DateClosed = case when @Closed = 1 then
				case when DateClosed is null then @PostingDate else DateClosed end 
				else null end 
		 where PurchaseOrderKey = @PurchaseOrderKey
		   and LineNumber = @LineNumber
		   and DetailOrderDate = @DetailOrderDate
		   and DetailOrderEndDate = @DetailOrderEndDate
		   and TransferToKey is null

		   if @AffectBilling = 1
				if @Closed = 1
				begin
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
					and tPurchaseOrderDetail.LineNumber = @LineNumber
					and tPurchaseOrderDetail.DetailOrderDate = @DetailOrderDate
					and tPurchaseOrderDetail.DetailOrderEndDate = @DetailOrderEndDate
					and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey

					-- But if applied to a vendor invoice, AmountBilled = 0
					update tPurchaseOrderDetail
					set    tPurchaseOrderDetail.AmountBilled = 0
					from   tVoucherDetail vd (nolock)
					where  tPurchaseOrderDetail.PurchaseOrderKey = @PurchaseOrderKey
					and    tPurchaseOrderDetail.TransferToKey is null
					and    isnull(tPurchaseOrderDetail.InvoiceLineKey, 0) = 0 -- if not prebilled  
					and tPurchaseOrderDetail.LineNumber = @LineNumber
					and tPurchaseOrderDetail.DetailOrderDate = @DetailOrderDate
					and tPurchaseOrderDetail.DetailOrderEndDate = @DetailOrderEndDate
					and tPurchaseOrderDetail.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				end
				else
					update tPurchaseOrderDetail
					set    InvoiceLineKey = null
						  ,AmountBilled = 0
						  ,DateBilled = null
					where  PurchaseOrderKey = @PurchaseOrderKey
					and    TransferToKey is null
					and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled  
					and LineNumber = @LineNumber
					and DetailOrderDate = @DetailOrderDate
					and DetailOrderEndDate = @DetailOrderEndDate
				
	end
	else	
		if @POKind = 2 And @ProcessAllSpots = 1
		begin
			--update all spots with the same line number and Adjustment number
			update tPurchaseOrderDetail
			   set Closed = @Closed
				  ,DateClosed = case when @Closed = 1 then
					case when DateClosed is null then @PostingDate else DateClosed end 
					else null end 
			 where PurchaseOrderKey = @PurchaseOrderKey
			   and LineNumber = @LineNumber
			   and AdjustmentNumber = @AdjustmentNumber
			   and TransferToKey is null

			if @AffectBilling = 1
				if @Closed = 1
					update tPurchaseOrderDetail
					set    InvoiceLineKey = 0
						  ,AmountBilled = BillableCost
						  ,DateBilled = isnull(DateBilled, @PostingDate)
					where  PurchaseOrderKey = @PurchaseOrderKey
					and    TransferToKey is null
					and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled  
					and LineNumber = @LineNumber
					and AdjustmentNumber = @AdjustmentNumber
				else
					update tPurchaseOrderDetail
					set    InvoiceLineKey = null
						  ,AmountBilled = 0
						  ,DateBilled = null
					where  PurchaseOrderKey = @PurchaseOrderKey
					and    TransferToKey is null
					and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled  
					and LineNumber = @LineNumber
			        and AdjustmentNumber = @AdjustmentNumber
		
		end
		else
		begin
			update tPurchaseOrderDetail
			   set Closed = @Closed 
				   ,DateClosed = case when @Closed = 1 then
					case when DateClosed is null then @PostingDate else DateClosed end 
					else null end 
			 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
			  and TransferToKey is null

			  if @AffectBilling = 1
				if @Closed = 1
					update tPurchaseOrderDetail
					set    InvoiceLineKey = 0
						  ,AmountBilled = BillableCost
						  ,DateBilled = isnull(DateBilled, @PostingDate)
					where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
					and    TransferToKey is null
					and    isnull(InvoiceLineKey, 0) = 0 -- if not prebilled  
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
		update tPurchaseOrder set Closed = 0, LastUpdateBy = @UserKey where PurchaseOrderKey = @PurchaseOrderKey
	else
		update tPurchaseOrder set Closed = 1, LastUpdateBy = @UserKey where PurchaseOrderKey = @PurchaseOrderKey
		
/*
|| This sp creates vouchers to fix orders accrual problems    
|| Returns are:
||  -1	-- nothing to unaccrue, no voucher created
||  -2	-- error creating voucher
||  1	-- voucher created to unaccrue
*/

	Declare @RetVal int
	select @RetVal = 0

	if @Closed = 1
	begin
		if @CompleteAccrual = 1
			Exec @RetVal = sptPurchaseOrderCompleteAccrual NULL ,@PurchaseOrderDetailKey, @UserKey, @PostingDate, @VoucherKey output
		
		If @RetVal <> 1
			Select @VoucherKey = NULL 
	end


		EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
GO
