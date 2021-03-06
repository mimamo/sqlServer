USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderRevisionLogComments]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderRevisionLogComments]
	(
	@PurchaseOrderKey int
	)
AS
	SET NOCOUNT ON

/*
|| When     Who Rel      What
|| 05/02/14 GHL 10.5.7.9 Creation to get details on PO revision action log
*/
	create table #revchanges (
		ShowAdjustmentsAsSingleLine int null

		,LineNumber int null -- 1 Buy, > 1 premiums 
		,MediaPremiumKey int null
		,MaxPurchaseOrderDetailKey int null
		,CountRecs int null

		,OldQuantity decimal(24,4) null
		,OldQuantity1 decimal(24,4) null
		,OldQuantity2 decimal(24,4) null
		,OldTotalCost money null
		,OldGrossAmount money null
		,OldBillableCost money null

		,NewQuantity decimal(24,4) null
		,NewQuantity1 decimal(24,4) null
		,NewQuantity2 decimal(24,4) null
		,NewTotalCost money null
		,NewGrossAmount money null
		,NewBillableCost money null

		,OldShortDescription varchar(max) null
		,OldDetailOrderDate datetime null

		,NewShortDescription varchar(max) null
		,NewDetailOrderDate datetime null

		,OldMediaPrintSpaceKey int null
		,OldMediaPrintPositionKey int null
		,OldCompanyMediaPrintContractKey int null
		,OldMediaPrintSpaceID varchar(500) null

		,NewMediaPrintSpaceKey int null
		,NewMediaPrintPositionKey int null
		,NewCompanyMediaPrintContractKey int null
		,NewMediaPrintSpaceID varchar(500) null
	)


	declare	@ShowAdjustmentsAsSingleLine tinyint

		SELECT	@ShowAdjustmentsAsSingleLine = ISNULL(po.ShowAdjustmentsAsSingleLine, 1)
		FROM	tPurchaseOrder po (nolock)
		WHERE	po.PurchaseOrderKey = @PurchaseOrderKey

		insert #revchanges (ShowAdjustmentsAsSingleLine, LineNumber, MediaPremiumKey, MaxPurchaseOrderDetailKey, CountRecs)
		select @ShowAdjustmentsAsSingleLine, LineNumber, MediaPremiumKey, Max(PurchaseOrderDetailKey), COUNT(PurchaseOrderDetailKey)
		from   tPurchaseOrderDetail  (nolock)
		where  PurchaseOrderKey = @PurchaseOrderKey
		group by LineNumber, MediaPremiumKey

		if @ShowAdjustmentsAsSingleLine = 1
		begin
			-- Adjusts are a single line
			-- the last pod contains the difference

			update #revchanges
			set    #revchanges.OldQuantity = (
				select sum(pod.Quantity)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)
				,#revchanges.OldQuantity1 = (
				select sum(pod.Quantity1)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)
				,#revchanges.OldQuantity2 = (
				select sum(pod.Quantity2)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)
				,#revchanges.OldTotalCost = (
				select sum(pod.TotalCost)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)
				,#revchanges.OldGrossAmount = (
				select sum(pod.GrossAmount)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)
				,#revchanges.OldBillableCost = (
				select sum(pod.BillableCost)
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = #revchanges.LineNumber
				and    pod.PurchaseOrderDetailKey < #revchanges.MaxPurchaseOrderDetailKey
				)

				-- temporary new values
				update #revchanges
				set    #revchanges.NewQuantity = pod.Quantity
					  ,#revchanges.NewQuantity1 = pod.Quantity1
					  ,#revchanges.NewQuantity2 = pod.Quantity2
					  ,#revchanges.NewTotalCost = pod.TotalCost
					  ,#revchanges.NewGrossAmount = pod.GrossAmount
					  ,#revchanges.NewBillableCost = pod.BillableCost
				from   tPurchaseOrderDetail pod (nolock)
				where  pod.PurchaseOrderDetailKey = #revchanges.MaxPurchaseOrderDetailKey 

				-- now add the previous
				update #revchanges
				set    #revchanges.NewQuantity = isnull(#revchanges.NewQuantity, 0) + isnull(#revchanges.OldQuantity, 0)
	 				  ,#revchanges.NewQuantity1 = isnull(#revchanges.NewQuantity1, 0) + isnull(#revchanges.OldQuantity1, 0)
	 				  ,#revchanges.NewQuantity2 = isnull(#revchanges.NewQuantity2, 0) + isnull(#revchanges.OldQuantity2, 0)
	 				  ,#revchanges.NewTotalCost = isnull(#revchanges.NewTotalCost, 0) + isnull(#revchanges.OldTotalCost, 0)
					  ,#revchanges.NewGrossAmount = isnull(#revchanges.NewGrossAmount, 0) + isnull(#revchanges.OldGrossAmount, 0)
					  ,#revchanges.NewBillableCost = isnull(#revchanges.NewBillableCost, 0) + isnull(#revchanges.OldBillableCost, 0)
		end
		else
		begin
			-- Adjusts are 2 lines, 1 reversal, 1 new value
			update #revchanges
			set    #revchanges.OldQuantity = -1 * pod.Quantity -- Multiply by -1 because it is a reversal
			       ,#revchanges.OldQuantity1 = -1 * pod.Quantity1 -- Multiply by -1 because it is a reversal
			       ,#revchanges.OldQuantity2 = -1 * pod.Quantity2 -- Multiply by -1 because it is a reversal
			      ,#revchanges.OldTotalCost = -1 * pod.TotalCost
				  ,#revchanges.OldGrossAmount = -1 * pod.GrossAmount
				  ,#revchanges.OldBillableCost = -1 * pod.BillableCost
			from   tPurchaseOrderDetail pod (nolock)
			where  pod.PurchaseOrderDetailKey = #revchanges.MaxPurchaseOrderDetailKey - 1 -- may not be there
			and    pod.PurchaseOrderKey = @PurchaseOrderKey  -- otherwise we might pick another PO
			and    pod.LineNumber = #revchanges.LineNumber
				
			update #revchanges
			set    #revchanges.NewQuantity = pod.Quantity
			      ,#revchanges.NewQuantity1 = pod.Quantity1
			      ,#revchanges.NewQuantity2 = pod.Quantity2
			      ,#revchanges.NewTotalCost = pod.TotalCost
				  ,#revchanges.NewGrossAmount = pod.GrossAmount
				  ,#revchanges.NewBillableCost = pod.BillableCost
			from   tPurchaseOrderDetail pod (nolock)
			where  pod.PurchaseOrderDetailKey = #revchanges.MaxPurchaseOrderDetailKey 
			
		end

		-- If the old quantities are null, make them equal to the new
		-- they could not be found
		update #revchanges
		set    OldQuantity = isnull(OldQuantity, NewQuantity)
			   ,OldQuantity1 = isnull(OldQuantity1, NewQuantity1)
			   ,OldQuantity2 = isnull(OldQuantity2, NewQuantity2)
			   ,OldTotalCost = isnull(OldTotalCost, NewTotalCost)
			   ,OldGrossAmount = isnull(OldGrossAmount, NewGrossAmount)
			   ,OldBillableCost = isnull(OldBillableCost, NewBillableCost)
		where LineNumber = 1	

		-- short description and DetailOrderDate should be at the top of the details, LineNumber = 1
		update #revchanges
		set    #revchanges.OldShortDescription = isnull(pod.OldShortDescription, pod.ShortDescription)
		      ,#revchanges.NewShortDescription = pod.ShortDescription
			  ,#revchanges.OldDetailOrderDate = isnull(pod.OldDetailOrderDate, pod.DetailOrderDate)
			  ,#revchanges.NewDetailOrderDate = pod.DetailOrderDate

			  ,#revchanges.OldMediaPrintSpaceKey = isnull(pod.OldMediaPrintSpaceKey, po.MediaPrintSpaceKey)
			  ,#revchanges.OldMediaPrintPositionKey = isnull(pod.OldMediaPrintPositionKey, po.MediaPrintPositionKey)
			  ,#revchanges.OldCompanyMediaPrintContractKey = isnull(pod.OldCompanyMediaPrintContractKey, po.CompanyMediaPrintContractKey)
			  ,#revchanges.OldMediaPrintSpaceID = isnull(pod.OldMediaPrintSpaceID, po.MediaPrintSpaceID)

		from   tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		where  pod.PurchaseOrderKey = @PurchaseOrderKey
		and    pod.LineNumber = 1
		and    #revchanges.LineNumber = 1
		and    pod.LineType = 'order' -- this is the top
		
		update #revchanges
		set    #revchanges.NewMediaPrintSpaceKey = po.MediaPrintSpaceKey
			  ,#revchanges.NewMediaPrintPositionKey = po.MediaPrintPositionKey
			  ,#revchanges.NewCompanyMediaPrintContractKey = po.CompanyMediaPrintContractKey
			  ,#revchanges.NewMediaPrintSpaceID = po.MediaPrintSpaceID
		from   tPurchaseOrder po (nolock)
		where  po.PurchaseOrderKey = @PurchaseOrderKey
		and    #revchanges.LineNumber = 1
		

		select rev.* 
		      ,mp.PremiumID as PremiumID
			  ,ms.SpaceID as NewMediaPrintSpaceID2
			  ,mpos.PositionID as NewMediaPrintPositionID
			  ,con.ContractID as NewCompanyMediaPrintContractID
		from #revchanges rev
			left outer join tMediaPremium mp (nolock) on rev.MediaPremiumKey = mp.MediaPremiumKey
			left outer join tMediaSpace ms (nolock) on rev.NewMediaPrintSpaceKey = ms.MediaSpaceKey 
			left outer join tMediaPosition mpos (nolock) on rev.NewMediaPrintPositionKey = mpos.MediaPositionKey 
			left outer join tCompanyMediaContract con (nolock) on rev.NewCompanyMediaPrintContractKey = con.CompanyMediaContractKey 

		order by rev.LineNumber

	RETURN 1
GO
