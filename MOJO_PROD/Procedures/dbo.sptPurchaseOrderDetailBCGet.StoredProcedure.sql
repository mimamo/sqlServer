USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailBCGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailBCGet]

	 @PurchaseOrderKey int
	,@PurchaseOrderDetailKey int
	,@Interval int -- 1=daily, 2=weekly, 3=summary


AS --Encrypt

/*
|| 02/07/08 BSH 8.5.0.3		(20499) Get InvoiceKey and InvoiceNumber for SpotsBilled Grid.
|| 08/27/09 GHL 10.5		Added filter on TransferToKey NULL
|| 07/06/10 MAS 10.5.3.2	(83929)Change the way weekly spots are grouped.  Rather than just grouping them into
||							4 week months, we're now using dates to break them up.  
|| 07/29/09 MAS 10.5.3.3	(83675)AutoAdjustmentLines lines have their Invoice info in tVoucherDetail
|| 03/24/11 MAS 10.5.4.2	(106043)Added the SUMS for Quantity,BillableCost,TotalCost and AmountBilled.  It does this
||							based on PurchaseOrderKey,LineNumber, AdjustmentNumber, DetailOrderDate
|| 04/28/11 MAS 10.5.4.3	(109897)Modified the "SUMS" Query to use t.DetailOrderDate = pod.DetailOrderDate
|| 03/11/13 WDF 10.5.6.6	(171017) Added a PreBilled flag
*/

declare @LineNumber int
declare @AdjustmentNumber int
declare @CurrentDate smalldatetime
declare @FlightStartDate smalldatetime
declare @FlightEndDate smalldatetime
declare @DetailOrderDate smalldatetime
declare @DetailOrderEndDate smalldatetime
declare @SpotGridLineNbr int
declare @IntervalGroup int
declare @IntervalGroupCnt int
declare @IntervalMonth int


	create table #tFlightSpot
	            (PurchaseOrderDetailKey int
	            ,SpotGridLineNbr int
	            ,DetailOrderDate smalldatetime null
	            ,DetailOrderEndDate smalldatetime null
	            ,IntervalGroup int null
	            ,Quantity decimal(24,4) null
	            ,UserDate1 smalldatetime null
	            ,UserDate2 smalldatetime null
	            ,UserDate3 smalldatetime null
	            ,UserDate4 smalldatetime null
	            ,UserDate5 smalldatetime null
	            ,UserDate6 smalldatetime null
	            ,BillableCost money null
	            ,TotalCost money null
	            ,InvoiceLineKey int null
	            ,InvoiceNumber varchar(35) null
	            ,InvoiceKey int null
	            ,DateBilled smalldatetime null
	            ,AmountBilled decimal (24,4) null
	            ,Closed tinyint
	            ,PreBilled tinyint
	            )
	            
	if @PurchaseOrderDetailKey = 0 -- handle new line
		select @LineNumber = 1
			  ,@AdjustmentNumber = 0
			  ,@FlightStartDate = po.FlightStartDate
			  ,@FlightEndDate = po.FlightEndDate
			  ,@DetailOrderDate = getdate()
			  ,@DetailOrderEndDate = getdate()
		  from tPurchaseOrder po (nolock) 
		 where PurchaseOrderKey = @PurchaseOrderKey
	else
		select @LineNumber = pod.LineNumber
			  ,@AdjustmentNumber = isnull(pod.AdjustmentNumber, 0)
			  ,@FlightStartDate = po.FlightStartDate
			  ,@FlightEndDate = po.FlightEndDate
			  ,@DetailOrderDate = isnull(pod.DetailOrderDate,getdate())
			  ,@DetailOrderEndDate = isnull(pod.DetailOrderEndDate,getdate())
		  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
         and   TransferToKey is null
         
	if @Interval = 3
		begin
			select @FlightStartDate = @DetailOrderDate	
			select @FlightEndDate = @DetailOrderEndDate		
		end

	-- due to existing data scenarios, make sure dates will work
	if @FlightStartDate is null
		begin
			if @FlightEndDate is not null
				select @FlightStartDate = @FlightEndDate
			else
				select @FlightStartDate = getdate()
		end
	if @FlightEndDate is null
		begin
			if @FlightStartDate is not null
				select @FlightEndDate = @FlightStartDate
			else
				select @FlightEndDate = getdate()
		end
							
	if @PurchaseOrderDetailKey <> 0 and @LineNumber is null
		return -1
		
	select @CurrentDate = @FlightStartDate
	select @SpotGridLineNbr = 1
	select @IntervalGroup = 1
	select @IntervalGroupCnt = 1
	select @IntervalMonth = DATEPART(month, DATEADD(d,7,@CurrentDate))
	while 1=1
		begin 
			
			if @Interval = 1
					insert #tFlightSpot (DetailOrderDate,DetailOrderEndDate,SpotGridLineNbr,IntervalGroup)
					values (@CurrentDate,@CurrentDate,@SpotGridLineNbr,@IntervalGroup)
			if @Interval = 2
					insert #tFlightSpot (DetailOrderDate,DetailOrderEndDate,SpotGridLineNbr,IntervalGroup)
					values (@CurrentDate,dateadd(d,6,@CurrentDate),@SpotGridLineNbr,@IntervalGroup)
			if @Interval = 3
					insert #tFlightSpot (DetailOrderDate,DetailOrderEndDate,SpotGridLineNbr,IntervalGroup)
					values (@FlightStartDate,@FlightEndDate,@SpotGridLineNbr,@IntervalGroup)
						
			if @Interval = 1 
			    begin
					if datediff(d,@CurrentDate,@FlightEndDate) <= 0 
						break
				end
			if @Interval = 2 
			    begin
					if datediff(d,@CurrentDate,@FlightEndDate) <= 6
						break
				end
			if @Interval = 3 
				break
							
			select @SpotGridLineNbr = @SpotGridLineNbr + 1
			select @IntervalGroupCnt = @IntervalGroupCnt + 1

			if @Interval = 1  -- daily
				begin
					if @IntervalGroupCnt = 8
						begin
							select @IntervalGroupCnt = 1
							select @IntervalGroup = @IntervalGroup + 1
						end
						
					select @CurrentDate = dateadd(d,1,@CurrentDate)
				end
			else
				begin
					
					select @CurrentDate = dateadd(d,7,@CurrentDate)
					
					-- Partial weeks get rolled forward into the next month grouping.
					if DATEPART(month, dateadd(d,6,@CurrentDate)) <> @IntervalMonth 
						begin
							select @IntervalGroup = @IntervalGroup + 1
							select @IntervalMonth = DATEPART(month, DATEADD(d,6,@CurrentDate))
						end									
				end
							
		end
	
	if @PurchaseOrderDetailKey <> 0 
		update #tFlightSpot
		set PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			,Quantity = isnull(t.Quantity ,0)
			,UserDate1 = pod.UserDate1
			,UserDate2 = pod.UserDate2
			,UserDate3 = pod.UserDate3
			,UserDate4 = pod.UserDate4
			,UserDate5 = pod.UserDate5
			,UserDate6 = pod.UserDate6
			,BillableCost = ISNULL(t.BillableCost,0)
			,TotalCost = isnull(t.TotalCost,0)
			,InvoiceLineKey =  isnull(pod.InvoiceLineKey,0)
			,InvoiceNumber = inv.InvoiceNumber
			,InvoiceKey = inv.InvoiceKey
			,DateBilled = pod.DateBilled
			,AmountBilled = ISNULL(t.AmountBilled,0)
			,Closed = pod.Closed
			,PreBilled = Case 
			               when ISNULL(pod.InvoiceLineKey,0) > 0 then 1
			               else 0
			              end
		from tPurchaseOrderDetail pod (nolock)
				left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
				left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
				inner join (Select SUM(Quantity) as Quantity,
					SUM(TotalCost) as TotalCost,
					SUM(BillableCost) as BillableCost,
					SUM(AmountBilled) as AmountBilled,
					PurchaseOrderKey, LineNumber, AdjustmentNumber, DetailOrderDate
					from tPurchaseOrderDetail
					where PurchaseOrderKey = @PurchaseOrderKey
					group by PurchaseOrderKey,LineNumber, AdjustmentNumber, DetailOrderDate
				)t on t.LineNumber = pod.LineNumber
					and isnull(t.AdjustmentNumber, 0) = pod.AdjustmentNumber
					and t.DetailOrderDate = pod.DetailOrderDate				
		where pod.PurchaseOrderKey = @PurchaseOrderKey
		and pod.LineNumber = @LineNumber
		and isnull(pod.AdjustmentNumber, 0) = @AdjustmentNumber
		and #tFlightSpot.DetailOrderDate = pod.DetailOrderDate
		--and #tFlightSpot.DetailOrderEndDate = pod.DetailOrderEndDate
		and   pod.TransferToKey is null
		
		-- Update Autoadjustment records with the Invoice info from tVoucherDetail
		update #tFlightSpot
		set InvoiceLineKey =  isnull(il.InvoiceLineKey,0)
			,InvoiceNumber = inv.InvoiceNumber
			,InvoiceKey = inv.InvoiceKey
			,DateBilled = vd.DateBilled
			,AmountBilled = vd.AmountBilled
			,Closed = pod.Closed
		from tPurchaseOrderDetail pod (nolock)
				left outer join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				left outer join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
				left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
		where pod.PurchaseOrderKey = @PurchaseOrderKey
		and pod.LineNumber = @LineNumber
		and isnull(pod.AdjustmentNumber, 0) = @AdjustmentNumber
		and isnull(pod.InvoiceLineKey,0) = 0
		and #tFlightSpot.DetailOrderDate = pod.DetailOrderDate
		--and #tFlightSpot.DetailOrderEndDate = pod.DetailOrderEndDate
		and   pod.TransferToKey is null
			 
			 
	select * from #tFlightSpot
  order by SpotGridLineNbr
	
	return 1
GO
