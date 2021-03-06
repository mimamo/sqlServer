USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaInsertionOrder]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaInsertionOrder]
	(
	@CompanyKey int
	,@MediaOrderKey int
	,@PurchaseOrderKey int
	)
AS --Encrypt

/*
  || When     Who Rel    What
  || 06/09/14 GHL 10.581 Created for the new media order printouts 
  ||                     All labels and fields must be listed here, the report will use the properties
  ||                     CanGrow/CanShrink to display or hide on the report
  || 06/24/14 GHL 10.581 When an order was added to a grouping for the first time, we need to flag it on the printout
  || 07/11/14 GHL 10.582 Added display status: blank or NEW or REVISED or CANCEL when printing by publication
  || 07/17/14 GHL 10.582 Added changes of premiumID
  || 07/17/14 GHL 10.582 Fixed changes of premiumID
  || 07/24/14 GHL 10.582 Need to capture when things are added (added: Added space/position/caption/purchase units)
  || 09/16/14 GHL 10.584 Info such as Description/DetailOrderDate is stored at last POD for LineNumber = 1
  || 10/17/14 GHL 10.584 Added Order Emailed when checking Order Printed
*/

	SET NOCOUNT ON

	create table #order (
		MediaOrderKey int null
		,MediaOrderRevision int null -- needed for the top revision
		,MediaOrderCurrentPrinted datetime null 
		,MediaOrderLastPrinted datetime null 
		,MediaWorksheetKey int null

		-- PO info
		,PurchaseOrderKey int null
		,Status int null
		,Revision int null
		,InternalID int null
		,JustAddedToMediaOrder int null
		,PurchaseOrderNumber varchar(30) null
		,DeliveryInstructions varchar(1000) null -- called Materials on printout, does not seem to be updated on the UI
		,Cancelled int null
		,DisplayStatus varchar(25) null -- blank or NEW or REVISED or CANCEL

		,PurchaseOrderTotal money null
		,TotalNonTaxAmount money null
		,SalesTaxAmount money null
		,CompanyMediaKey int null

		,MediaPrintSpaceKey int null
		,MediaPrintSpaceID varchar(500) null
		 
        ,MediaPrintPositionKey int null
		,MediaPrintPositionID varchar(500) null
		
		,MediaUnitTypeKey int null
		,MediaUnitTypeID varchar(50) null

		-- POD info
		,ShortDescription varchar(500) null -- called Ad on printout,  I am truncating
		,DetailOrderDate smalldatetime null

		,Quantity decimal(24,4)
		,UnitCost money null -- will need to be formatted in vb
		,UnitRate money null	
		,TotalCost money null -- Sum of PODs
		,GrossAmount money null -- Sum of PODs

		,Premiums varchar(6000) null 
		,PremiumTotalCost money null -- Sum of PODs
		,PremiumGrossAmount money null -- Sum of PODs
		
		,CancelledTotalCost money null
		,CancelledGrossAmount money null
		,CancelledPremiumTotalCost money null
		,CancelledPremiumGrossAmount money null

		-- changes tracked for display
		,OldMediaPrintSpaceID varchar(500) null
		,OldMediaPrintPositionID varchar(500) null
		,OldShortDescription varchar(500) null -- I am truncating from text field to 500 chars
		,OldDetailOrderDate smalldatetime null -- new!!!!!!!!!!!
		,OldUnitRate decimal(24,4) null 
		,OldUnitCost decimal(24,4) null 
		,OldMediaUnitTypeID varchar(500) null
		
		,PremiumChanges varchar(6000) null -- Just a place holder at this time, we will format text in VB from #premchanges
		,DetailOrderDateString  varchar (100) null  -- Just a place holder at this time, we will format text in VB 
		,OldDetailOrderDateString  varchar (100) null  -- Just a place holder at this time, we will format text in VB
		,OldTotalCostString  varchar (100) null  -- Just a place holder at this time, we will format text in VB
		,OldRateString varchar(100) null -- Just a place holder at this time, we will format text in VB
		,RateString varchar(100) null -- Just a place holder at this time, we will format text in VB

		,InfoPODKey int null -- POD key where special info is stored (should be last POD for LineNumber = 1)
	
		,UserDate1 smalldatetime null
		,UserDate2 smalldatetime null
		,UserDate3 smalldatetime null
		,UserDate4 smalldatetime null
		,UserDate5 smalldatetime null
		,UserDate6 smalldatetime null

		,UserDate1Label varchar(500) null
		,UserDate2Label varchar(500) null
		,UserDate3Label varchar(500) null
		,UserDate4Label varchar(500) null
		,UserDate5Label varchar(500) null
		,UserDate6Label varchar(500) null

		,PurchaseUnitsLabel varchar(20) null
		,RateLabel varchar(15) null
		,PositionLabel varchar(15) null
		,PremiumsLabel varchar(15) null
		,AdLabel varchar(15) null
		,MaterialsLabel varchar(15) null
	)

	create table #premium (
		PurchaseOrderKey int null
		,PurchaseOrderDetailKey int null
		,LineNumber int null
		,ShortDescription varchar(500) null
		,TotalCost money null
		,GrossAmount money null
		,MediaPremiumKey int null
		,PremiumID varchar(500) null
		,Cancelled int null
	)

	-- These are the changes of premiums
	-- Added/Deleted or Change of TotalCost
	create table #premchanges (
	    PurchaseOrderKey int null
		,PremiumID varchar(50) null
		,Action varchar(200) null -- Premium or Field Change (for TotalCost/GrossAmount)
		,FieldName varchar(50) null -- TotalCost/GrossAmount
		,Comments varchar(200) null -- will hold the 'Added PremiumXX' or 'Deleted PremiumYYY'  
		,OldValue money null -- when changing TotalCost/GrossAmount
		,ActionDate datetime null 
		,MediaOrderLastPrinted datetime null
	)

	/*
	DECLARE @SQL AS VARCHAR(8000)
	select @SQL = 'insert #order (PurchaseOrderKey)  '
	select @SQL = @SQL + ' select PurchaseOrderKey from tPurchaseOrder (nolock) '
	select @SQL = @SQL + ' where PurchaseOrderKey in ( ' + @POKeys + ')'
	exec (@SQL)
	*/

	if isnull(@MediaOrderKey, 0) > 0
	begin
		insert #order (PurchaseOrderKey)
		select PurchaseOrderKey from tPurchaseOrder (nolock)
		where  MediaOrderKey = @MediaOrderKey
	end
	else
	begin
		insert #order (PurchaseOrderKey)
		select PurchaseOrderKey from tPurchaseOrder (nolock)
		where  PurchaseOrderKey = @PurchaseOrderKey
	end

	/* this is what tPurchaseOrder Update does
	IF @MediaPrintSpaceKey > 0
	SELECT	@MediaPrintSpaceID = NULL
	
	IF @MediaPrintPositionKey > 0
	SELECT	@MediaPrintPositionID = NULL
	*/


	/*
	1 - Capture current values
	*/

	-- capture data from the MO and the PO
	update #order
	set    #order.MediaWorksheetKey = po.MediaWorksheetKey
	      ,#order.MediaOrderKey = po.MediaOrderKey
	      ,#order.MediaOrderRevision = mo.Revision
		  ,#order.PurchaseOrderNumber = po.PurchaseOrderNumber
		  ,#order.Status = po.Status
		  ,#order.Revision = po.Revision
		  ,#order.InternalID = po.InternalID

		  ,#order.DeliveryInstructions = po.DeliveryInstructions
		  ,#order.Cancelled = po.Cancelled
		  ,#order.PurchaseOrderTotal = ISNULL(po.PurchaseOrderTotal, 0)
		  ,#order.TotalNonTaxAmount = ISNULL(po.PurchaseOrderTotal, 0) - ISNULL(po.SalesTaxAmount, 0)
		  ,#order.SalesTaxAmount = ISNULL(po.SalesTaxAmount, 0)
		  ,#order.CompanyMediaKey = po.CompanyMediaKey

	      ,#order.MediaPrintSpaceKey = po.MediaPrintSpaceKey
	      ,#order.MediaPrintSpaceID = po.MediaPrintSpaceID

		  ,#order.MediaPrintPositionKey = po.MediaPrintPositionKey
	      ,#order.MediaPrintPositionID = po.MediaPrintPositionID

		  ,#order.MediaUnitTypeKey = po.MediaUnitTypeKey
	      
	from   tPurchaseOrder po (nolock)
		left outer join tMediaOrder mo (nolock) on po.MediaOrderKey = mo.MediaOrderKey
	where  po.PurchaseOrderKey = #order.PurchaseOrderKey

	-- zero everything if cancelled
	update #order
	set    PurchaseOrderTotal = 0, TotalNonTaxAmount = 0, SalesTaxAmount = 0
	where  Cancelled = 1

	-- recalc if only the premiums were cancelled
	update #order
	set    #order.TotalNonTaxAmount = (
		select sum(pod.TotalCost) from tPurchaseOrderDetail pod (nolock) 
		where pod.PurchaseOrderKey = #order.PurchaseOrderKey 
		and   isnull(pod.Cancelled, 0) = 0
	)
	where  isnull(#order.Cancelled, 0) = 0

	update #order
	set    #order.SalesTaxAmount = (
		select sum(pod.SalesTaxAmount) from tPurchaseOrderDetail pod (nolock) 
		where pod.PurchaseOrderKey = #order.PurchaseOrderKey 
		and   isnull(pod.Cancelled, 0) = 0
	)
	where  isnull(#order.Cancelled, 0) = 0

	update #order
	set    #order.PurchaseOrderTotal = isnull(#order.TotalNonTaxAmount, 0) + isnull(#order.SalesTaxAmount, 0)
	where  isnull(#order.Cancelled, 0) = 0

	-- get data from the last POD as for LineNumber = 1
	update #order
	set    #order.InfoPODKey = (select max(pod.PurchaseOrderDetailKey) 
		from tPurchaseOrderDetail pod (nolock)
		where pod.PurchaseOrderKey = #order.PurchaseOrderKey
		and  pod.LineNumber = 1
		)
	
	-- It looks like the POD stuff is at the top
	-- UnitCost and UnitRate values???? already determined by Matt as suspect
	update #order
	set    #order.ShortDescription = substring(pod.ShortDescription, 1, 500)
	      ,#order.DetailOrderDate = pod.DetailOrderDate
	      ,#order.UnitRate = pod.UnitRate
		  ,#order.UnitCost = pod.UnitCost

		  ,#order.UserDate1 = pod.UserDate1
		  ,#order.UserDate2 = pod.UserDate2
		  ,#order.UserDate3 = pod.UserDate3
		  ,#order.UserDate4 = pod.UserDate4
		  ,#order.UserDate5 = pod.UserDate5
		  ,#order.UserDate6 = pod.UserDate6

	from   tPurchaseOrderDetail pod (nolock)
	where  pod.PurchaseOrderDetailKey = #order.InfoPODKey

	-- we need to sum the POD for Net and Gross
	update #order
	set    #order.TotalCost= (select sum(pod.TotalCost)
		from tPurchaseOrderDetail pod (nolock)
		where PurchaseOrderKey = #order.PurchaseOrderKey
		and   LineNumber = 1 -- Main Buy line
		and   isnull(pod.Cancelled, 0) = 0
		)

	update #order
	set    #order.GrossAmount= (select sum(pod.GrossAmount)
		from tPurchaseOrderDetail pod (nolock)
		where PurchaseOrderKey = #order.PurchaseOrderKey
		and   LineNumber = 1 -- Main Buy line
		and   isnull(pod.Cancelled, 0) = 0
		)

	update #order
	set    #order.Quantity= (select sum(pod.Quantity)
		from tPurchaseOrderDetail pod (nolock)
		where PurchaseOrderKey = #order.PurchaseOrderKey
		and   LineNumber = 1 -- Main Buy line
		)

	--UnitCost and UnitRate not reliable, recalc
	update #order
	set    #order.UnitCost= case when isnull(#order.Quantity, 0) = 0 then #order.TotalCost else #order.TotalCost /#order.Quantity  end
	      ,#order.UnitRate= case when isnull(#order.Quantity, 0) = 0 then #order.GrossAmount else #order.GrossAmount /#order.Quantity end

	update #order
	set    #order.PremiumTotalCost= (select sum(pod.TotalCost)
		from tPurchaseOrderDetail pod (nolock)
		where PurchaseOrderKey = #order.PurchaseOrderKey
		and   LineNumber > 1 -- Premiums
		)

	update #order
	set    #order.PremiumGrossAmount= (select sum(pod.GrossAmount)
		from tPurchaseOrderDetail pod (nolock)
		where PurchaseOrderKey = #order.PurchaseOrderKey
		and   LineNumber > 1 -- Premiums
		)

	-- now get stuff from media space and position
	update #order
	set    #order.MediaPrintSpaceID = ms.SpaceID
	from   tMediaSpace ms (nolock)
	where  #order.MediaPrintSpaceKey = ms.MediaSpaceKey 
	and    #order.MediaPrintSpaceKey > 0

	update #order
		--for the positions, Susan wants the PositionName vs PositionID
	set    #order.MediaPrintPositionID = mp.PositionName
	from   tMediaPosition mp (nolock)
	where  #order.MediaPrintPositionKey = mp.MediaPositionKey 
	and    #order.MediaPrintPositionKey > 0

	update #order
	set    #order.MediaUnitTypeID = mut.UnitTypeID
	from   tMediaUnitType mut (nolock)
	where  #order.MediaUnitTypeKey = mut.MediaUnitTypeKey 
	
	/*
	2 - Capture old values using the table tMediaBuyRevisionHistory
	*/

	-- we should have at least a current printed date
	update #order
	set    #order.MediaOrderCurrentPrinted = (select max(hist.ActionDate)
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tMediaOrder' and hist.EntityKey = #order.MediaOrderKey
	and    hist.Action in ( 'Order Printed', 'Order Emailed')
	)

	
	/*
	-- but we may not have that one, if this is the first printout
	update #order
	set    #order.MediaOrderLastPrinted = (select max(hist.ActionDate)
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tMediaOrder' and hist.EntityKey = #order.MediaOrderKey
	and    hist.Action in ( 'Order Printed', 'Order Emailed')
	and    isnull(#order.MediaOrderRevision, 0) <> isnull(hist.Revision, 0) -- if the revision is the same, nothing has changed
	)
	*/

	-- but we may not have that one, if this is the first printout
	-- This one looks more accurate
	
	update #order
	set    #order.MediaOrderLastPrinted = (select min(hist.ActionDate)
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tMediaOrder' and hist.EntityKey = #order.MediaOrderKey
	and    hist.Action in ( 'Order Printed', 'Order Emailed')
	and    isnull(#order.MediaOrderRevision, 0) - 1 = isnull(hist.Revision, 0) -- if the revision is the same, nothing has changed
	)
	
	-- 6/24/14 added for new requirement by Susan to flag newly added 
	update #order
	set    #order.JustAddedToMediaOrder = 1
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tMediaOrder' and hist.EntityKey = #order.MediaOrderKey
	and    hist.Action = 'Buy Line Added'
	and    hist.NewInt = #order.PurchaseOrderKey
	and    hist.ActionDate > #order.MediaOrderLastPrinted
	and    #order.MediaOrderLastPrinted is not null

	-- Display Status, this replaces JustAddedToMediaOrder
	update #order
	set    #order.DisplayStatus = '(REVISED)'
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tPurchaseOrder' and hist.EntityKey = #order.PurchaseOrderKey
	and    hist.Action in ( 'Field Change', 'Premium')
	and    hist.ActionDate > #order.MediaOrderLastPrinted
	and    #order.MediaOrderLastPrinted is not null

	update #order
	set    #order.DisplayStatus = '(NEW)'
	from   tMediaBuyRevisionHistory hist (nolock) 
	where  hist.Entity = 'tMediaOrder' and hist.EntityKey = #order.MediaOrderKey
	and    hist.Action = 'Buy Line Added'
	and    hist.NewInt = #order.PurchaseOrderKey
	and    hist.ActionDate > #order.MediaOrderLastPrinted
	and    #order.MediaOrderLastPrinted is not null

	update #order
	set    #order.DisplayStatus = '(CANCEL)'
	where  #order.Cancelled = 1

	declare @POKey int
	declare @PODKey int
	declare @MediaOrderLastPrinted datetime
	declare @OldMediaPrintSpaceID varchar(500)
	declare @OldMediaPrintPositionID varchar(500)
	declare @OldShortDescription varchar(500)
	declare @OldMediaUnitTypeID varchar(500) --new
	declare @OldUnitRate decimal(24,4)
	declare @OldUnitCost decimal(24,4)
	declare @OldDetailOrderDate smalldatetime
	declare @ActionDate datetime

	select @POKey = 0
	while (1=1)
	begin
		select @POKey = min(PurchaseOrderKey)
		from   #order 
		where  PurchaseOrderKey > @POKey

		if @POKey is null
			break

		select @MediaOrderLastPrinted = MediaOrderLastPrinted from #order where  PurchaseOrderKey = @POKey
		
		select @ActionDate = null

		select @OldMediaPrintSpaceID = null, @OldMediaPrintPositionID = null, @OldShortDescription = null
		      ,@OldMediaUnitTypeID = null, @OldDetailOrderDate = null, @OldUnitRate = null, @OldUnitCost = null
			 
		-- get the oldest change, in case they change several times
		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'MediaPrintSpaceID'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			-- we could set it to isnull(OldString, 'blank') to have it displayed like 'Changed from blank'
			select @OldMediaPrintSpaceID = OldString
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'MediaPrintSpaceID'
			and    hist.ActionDate = @ActionDate

			if @OldMediaPrintSpaceID is null
				select  @OldMediaPrintSpaceID = 'Added space'
		end
		
		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'MediaPrintPositionID'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldMediaPrintPositionID = OldString
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'MediaPrintPositionID'
			and    hist.ActionDate = @ActionDate

			if @OldMediaPrintPositionID is null
				select  @OldMediaPrintPositionID = 'Added position'
		end

		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'ShortDescription'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldShortDescription = OldString
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'ShortDescription'
			and    hist.ActionDate = @ActionDate

			if @OldShortDescription is null
				select  @OldShortDescription = 'Added caption'
		end

		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'MediaUnitTypeID'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldMediaUnitTypeID = OldString
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'MediaUnitTypeID'
			and    hist.ActionDate = @ActionDate

			if @OldMediaUnitTypeID is null
				select  @OldMediaUnitTypeID = 'Added purchase units'
		end

		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'DetailOrderDate'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldDetailOrderDate = OldDate
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'DetailOrderDate'
			and    hist.ActionDate = @ActionDate
		end
		
		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'UnitCost'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldUnitCost = OldDecimal
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'UnitCost'
			and    hist.ActionDate = @ActionDate
		end

		select @ActionDate = null

		select @ActionDate = min(ActionDate)
		from   tMediaBuyRevisionHistory hist (nolock) 
		where  hist.Entity = 'tPurchaseOrder' 
		and    hist.EntityKey = @POKey
		and    hist.Action = 'Field Change'
		and    hist.FieldName = 'UnitRate'
		--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
		and    hist.ActionDate > @MediaOrderLastPrinted
		
		if @ActionDate is not null
		begin
			select @OldUnitRate = OldDecimal
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'UnitRate'
			and    hist.ActionDate = @ActionDate
		end

		update #order 
		set OldMediaPrintSpaceID = @OldMediaPrintSpaceID
			,OldMediaPrintPositionID = @OldMediaPrintPositionID
			,OldShortDescription = @OldShortDescription 
			,OldMediaUnitTypeID = @OldMediaUnitTypeID 
			,OldDetailOrderDate = @OldDetailOrderDate
			,OldUnitCost = @OldUnitCost
			,OldUnitRate = @OldUnitRate 
		where PurchaseOrderKey = @POKey

	end

	/*
	3 - Take care of the Premiums
		Premiums are concatenated 
		7/16/14 not displayed on report (meeting GG, Susan, Gil) keep logic in place in case
	*/

	-- pick up all premiums added or removed, the comments should be good to be displayed
	insert #premchanges(PurchaseOrderKey,PremiumID, Action, Comments, OldValue, ActionDate, MediaOrderLastPrinted )
	select hist.EntityKey, hist.PremiumID, hist.Action, hist.Comments, null, hist.ActionDate, o.MediaOrderLastPrinted 
	from   tMediaBuyRevisionHistory hist (nolock) 
		inner join #order o on o.PurchaseOrderKey = hist.EntityKey
	where hist.Entity = 'tPurchaseOrder'
	and hist.Action = 'Premium'
	--and (o.MediaOrderLastPrinted is null or hist.ActionDate > o.MediaOrderLastPrinted) 		
	and    hist.ActionDate > o.MediaOrderLastPrinted
		
----------------------------------------------------------------------------------------------------------------------
/*
select hist.EntityKey, hist.PremiumID, hist.Action, hist.Comments, null, hist.ActionDate, o.MediaOrderLastPrinted
	from   tMediaBuyRevisionHistory hist (nolock) 
		inner join #order o on o.PurchaseOrderKey = hist.EntityKey
	where hist.Entity = 'tPurchaseOrder'
	and hist.Action = 'Premium'
	--and (o.MediaOrderLastPrinted is null or hist.ActionDate > o.MediaOrderLastPrinted) 		
	and    hist.ActionDate > o.MediaOrderLastPrinted
*/	
	declare @Premiums varchar(6000)
	declare @PremiumID varchar(6000)
	declare @OldPremiumID varchar(6000)
	declare @LineNumber int
	declare @PremiumAmount money
	declare @MediaPremiumKey int
	declare @ShortDescription varchar(500)
	declare @OldValue money
	
	-- careful here, we have several rows per premium
	insert #premium (PurchaseOrderKey,PurchaseOrderDetailKey,LineNumber,TotalCost,GrossAmount,MediaPremiumKey,PremiumID, ShortDescription, Cancelled)
	select pod.PurchaseOrderKey,pod.PurchaseOrderDetailKey,pod.LineNumber,pod.TotalCost,pod.GrossAmount,pod.MediaPremiumKey,null,substring(pod.ShortDescription, 1, 500), isnull(pod.Cancelled, 0)
	from   tPurchaseOrderDetail pod (nolock)
	inner join #order o on pod.PurchaseOrderKey = o.PurchaseOrderKey
	where pod.LineNumber > 1 -- these are premiums
	--and   isnull(pod.Cancelled, 0) = 0

	-- Now remove the ones which have all pods for a line # cancelled, those are premiums completely cancelled, we do not keep 
	select @POKey = 0
	while (1=1)
	begin
		select @POKey = min(PurchaseOrderKey)
		from   #order 
		where  PurchaseOrderKey > @POKey

		if @POKey is null
			break

		select @LineNumber = 1 -- must be greater than 1
 		while (1=1)
		begin
			select @LineNumber = min(LineNumber)
			from   #premium (nolock)
			where  PurchaseOrderKey = @POKey
			and    LineNumber > @LineNumber

			if @LineNumber is null
				break
		
			if (select count(*) from #premium where PurchaseOrderKey = @POKey and LineNumber = @LineNumber)
					= 
			   (select count(*) from #premium where PurchaseOrderKey = @POKey and LineNumber = @LineNumber and Cancelled = 1)
			   delete #premium where PurchaseOrderKey = @POKey and LineNumber = @LineNumber
		end

	end

	-- Problem is if we change premiums, we could have several PODs for the same line number, so the premiumID could change
	-- The more meaningful premiumID is the last one
	-- Also we could go:
	-- from premium key to premium key
	-- or from premium key to premium desc
	-- or from premium dec to premium desc
	-- or from premium desc to premium key
	
	/* we need to that in the loop below
	update #premium
	set    #premium.PremiumID = mp.PremiumID
	from   tMediaPremium mp (nolock)
	where  #premium.MediaPremiumKey = mp.MediaPremiumKey
  
	-- take care of the manual premiums
	update #premium
	set    PremiumID = ShortDescription
	where  PremiumID is null
	*/

	select @POKey = 0
	while (1=1)
	begin
		select @POKey = min(PurchaseOrderKey)
		from   #order 
		where  PurchaseOrderKey > @POKey

		if @POKey is null
			break

		select @MediaOrderLastPrinted = MediaOrderLastPrinted from #order where  PurchaseOrderKey = @POKey
		
		select @Premiums = ''

		select @LineNumber = 1 -- must be greater than 1
 		while (1=1)
		begin
			select @LineNumber = min(LineNumber)
			from   #premium (nolock)
			where  PurchaseOrderKey = @POKey
			and    LineNumber > @LineNumber

			if @LineNumber is null
				break

			-- to get the premium ID, go to the max POD
			select @PODKey = max(PurchaseOrderDetailKey) from #premium 
			where  PurchaseOrderKey = @POKey
			and    LineNumber = @LineNumber

			select @MediaPremiumKey = MediaPremiumKey 
			      ,@ShortDescription = ShortDescription  
			from #premium
			where  PurchaseOrderKey = @POKey
			and    LineNumber = @LineNumber
			and    PurchaseOrderDetailKey = @PODKey

			if isnull(@MediaPremiumKey, 0) > 0
				select @PremiumID = PremiumID
				from   tMediaPremium (nolock)
				where  MediaPremiumKey = @MediaPremiumKey
			else
				select @PremiumID = @ShortDescription

			-- and I set that premium ID for all recs of the same line number
			update  #premium
			set     PremiumID = @PremiumID
			where  PurchaseOrderKey = @POKey
			and    LineNumber = @LineNumber
			
			-- changes of premiums' net
			select @ActionDate = null, @OldValue = null

			select @ActionDate = min(ActionDate)
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'TotalCost'
			--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
			and    hist.ActionDate > @MediaOrderLastPrinted
			and    LineNumber = @LineNumber -- should be the line number for a premium

			if @ActionDate is not null
			begin
				select @OldValue = OldMoney
				from   tMediaBuyRevisionHistory hist (nolock) 
				where  hist.Entity = 'tPurchaseOrder' 
				and    hist.EntityKey = @POKey
				and    hist.Action = 'Field Change'
				and    hist.FieldName = 'TotalCost'
				and    hist.ActionDate = @ActionDate
				and    LineNumber = @LineNumber -- should be the line number for a premium
			end

			if @OldValue is not null
			begin
				insert #premchanges(PurchaseOrderKey,PremiumID, Action, FieldName, Comments, OldValue)
				values (@POKey, @PremiumID, 'Field Change', 'TotalCost', null, @OldValue)
			end
			
			-- changes of premiums' gross
			select @ActionDate = null, @OldValue = null

			select @ActionDate = min(ActionDate)
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'GrossAmount'
			--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
			and    hist.ActionDate > @MediaOrderLastPrinted
			and    LineNumber = @LineNumber -- should be the line number for a premium

			if @ActionDate is not null
			begin
				select @OldValue = OldMoney
				from   tMediaBuyRevisionHistory hist (nolock) 
				where  hist.Entity = 'tPurchaseOrder' 
				and    hist.EntityKey = @POKey
				and    hist.Action = 'Field Change'
				and    hist.FieldName = 'GrossAmount'
				and    hist.ActionDate = @ActionDate
				and    LineNumber = @LineNumber -- should be the line number for a premium
			end

			if @OldValue is not null
			begin
				insert #premchanges(PurchaseOrderKey,PremiumID, Action, FieldName, Comments, OldValue)
				values (@POKey, @PremiumID, 'Field Change', 'GrossAmount', null, @OldValue)
			end
			
			 
			select @PremiumAmount = sum( isnull(TotalCost, 0) + isnull(GrossAmount, 0))
			from   #premium (nolock)
			where  PurchaseOrderKey = @POKey
			and    LineNumber = @LineNumber 
		
			-- only if not zero, no:misunderstood Susan
			--if isnull(@PremiumAmount, 0) <> 0
			--begin	
				if len(@Premiums) = 0
					select @Premiums = @PremiumID
				else
					select @Premiums = @Premiums + ', ' + @PremiumID
			--end

			if len(@Premiums) > 0
			update #order set Premiums = @Premiums where PurchaseOrderKey = @POKey

			-- Added changes of premium
			select @ActionDate = null, @OldPremiumID = null

			select @ActionDate = min(ActionDate)
			from   tMediaBuyRevisionHistory hist (nolock) 
			where  hist.Entity = 'tPurchaseOrder' 
			and    hist.EntityKey = @POKey
			and    hist.Action = 'Field Change'
			and    hist.FieldName = 'PremiumID'
			--and    (@MediaOrderLastPrinted is null or hist.ActionDate > @MediaOrderLastPrinted)
			and    hist.ActionDate > @MediaOrderLastPrinted
			and    LineNumber = @LineNumber -- should be the line number for a premium
			
			if @ActionDate is not null
			begin
				select @OldPremiumID = OldString
				from   tMediaBuyRevisionHistory hist (nolock) 
				where  hist.Entity = 'tPurchaseOrder' 
				and    hist.EntityKey = @POKey
				and    hist.Action = 'Field Change'
				and    hist.FieldName = 'PremiumID'
				and    hist.ActionDate = @ActionDate
				and    LineNumber = @LineNumber -- should be the line number for a premium
			end

			if @OldPremiumID is not null
			begin
				insert #premchanges(PurchaseOrderKey,PremiumID, Action, Comments, OldTotalCost)
				values (@POKey, @PremiumID, 'Premium', 'Premium changed from ' + @OldPremiumID, null)
			end

		end

	end

	-- testing...
	--update #order set MediaPrintSpaceID = 'AAA BBB CCC DDD EEE FFF GGG HHH JJJ KKK LLL MMM NNN OOO PPP QQQ RRR SSS TTT UUU BBBB VVVVV'
	--update #order set MediaPrintSpaceID = null
	--update #order set MediaPrintPositionID = 'AAA BBB CCC DDD EEE FFF GGG HHH JJJ KKK LLL MMM NNN OOO PPP QQQ RRR SSS TTT UUU BBBB VVVVV'
	
	-- Take care of all labels and textboxes
	update #order
	set    UnitRate = isnull(UnitRate, 0), UnitCost = isnull(UnitCost, 0) 
	      ,OldUnitRate = isnull(OldUnitRate, 0), OldUnitCost = isnull(OldUnitCost, 0) 

	-- this we may have to redo in VB for correct formatting
	update #order 
	set RateLabel = 'Rate:'
	--where isnull(Quantity, 0) <> 1 -- last change from Susan, show all the time

	update #order
	set    OldMediaPrintSpaceID = 'Changed from: ' + OldMediaPrintSpaceID
	where  OldMediaPrintSpaceID is not null
	and    OldMediaPrintSpaceID <> 'Added space'

	update #order
	set    OldMediaPrintPositionID = 'Changed from: ' + OldMediaPrintPositionID
	where  OldMediaPrintPositionID is not null
	and    OldMediaPrintPositionID <> 'Added position'

	update #order
	set    OldMediaUnitTypeID = 'Changed from: ' + OldMediaUnitTypeID
	where  OldMediaUnitTypeID is not null
	and    OldMediaUnitTypeID <> 'Added purchase units'

	update #order
	set    OldShortDescription = 'Changed from: ' + OldShortDescription
	where  OldShortDescription is not null
	and    OldShortDescription <> 'Added caption'

	update #order
	set    PurchaseUnitsLabel = 'Purchase Units: '
	where  MediaUnitTypeID is not null

	update #order
	set    PremiumsLabel = 'Premiums: '
	where  Premiums is not null

	-- set to null, so that the CanShrink works
	update #order
	set    PremiumGrossAmount = null
	      ,PremiumTotalCost = null
	where  Premiums is null

	update #order
	set    PositionLabel = 'Position: '
	where  isnull(MediaPrintPositionKey, 0) <> 0 or MediaPrintPositionID is not null
	or OldMediaPrintPositionID is not null

	update #order
	set    AdLabel = 'Ad: '
	where  ShortDescription is not null or OldShortDescription is not null

	update #order
	set    MaterialsLabel = 'Materials: '
	where  DeliveryInstructions is not null 

	-- Now take care of the Cancelled stuff
	update #order
	set    CancelledTotalCost = -1 * TotalCost
	      ,CancelledGrossAmount = -1 * GrossAmount
		  ,CancelledPremiumTotalCost = -1 * PremiumTotalCost
	      ,CancelledPremiumGrossAmount = -1 * PremiumGrossAmount
	where  isnull(Cancelled,0) = 1 

	-- Now the Date labels
	update #order
	set    #order.UserDate1Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint1' 
	and    #order.UserDate1 is not null -- do not show if the UserDate1 is blabk

	update #order
	set    #order.UserDate2Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint2' 
	and    #order.UserDate2 is not null

	update #order
	set    #order.UserDate3Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint3' 
	and    #order.UserDate3 is not null

	update #order
	set    #order.UserDate4Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint4' 
	and    #order.UserDate4 is not null

	update #order
	set    #order.UserDate5Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint5' 
	and    #order.UserDate5 is not null

	update #order
	set    #order.UserDate6Label = st.StringSingular + ': '
	from   tStringCompany st (nolock)
	where  st.CompanyKey = @CompanyKey
	and    st.StringID = 'MediaPrint6' 
	and    #order.UserDate6 is not null

	-- add what is missing and return
	select o.*

	    ,v_addr.Address1
		,v_addr.Address2
		,v_addr.Address3
		,v_addr.City
		,v_addr.PostalCode
		,v_addr.Country

		,cm.Name as StationName
	    ,cm.Address1 as CMAddress1
	    ,cm.Address2 as CMAddress2
	    ,cm.Address3 as CMAddress3
	    ,cm.City as CMCity
	    ,cm.State as CMState
	    ,cm.PostalCode as CMPostalCode
	    ,cm.Country as CMCountry
	    
		,mw.WorksheetName
		,cl.CompanyName as ClientName
		,p.ProjectNumber
		,p.ProjectName
		,isnull(p.ProjectNumber + ' - ', '') + isnull(p.ProjectName, '') as ProjectFullName 
		,cp.ProductName
		,ca.CampaignID
		,ca.CampaignName
		,isnull(ca.CampaignID + ' - ', '') + isnull(ca.CampaignName, '') as CampaignFullName 
		
	from #order o
		inner join tPurchaseOrder po (nolock) on o.PurchaseOrderKey = po.PurchaseOrderKey 
		left outer join tCompanyMedia cm (nolock) on o.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaWorksheet mw (nolock) on o.MediaWorksheetKey = mw.MediaWorksheetKey 
		left outer join tCompany cl (nolock) on mw.ClientKey = cl.CompanyKey 
		left outer join tProject p (nolock) on mw.ProjectKey = p.ProjectKey
		left outer join tCampaign ca (nolock) on p.CampaignKey = ca.CampaignKey
		left outer join tClientProduct cp (nolock) on mw.ClientProductKey = cp.ClientProductKey
		left outer join tCompany ven (nolock) on po.VendorKey = ven.CompanyKey
		left outer join tAddress v_addr (nolock) on ven.DefaultAddressKey = v_addr.AddressKey
	order by o.PurchaseOrderNumber, o.InternalID

	-- also add the premiums for the single mode
	select PurchaseOrderKey, LineNumber, PremiumID, Sum(TotalCost) as TotalCost, Sum(GrossAmount) as GrossAmount 
	from #premium
	group by PurchaseOrderKey, LineNumber, PremiumID
	--having Sum(isnull(TotalCost, 0) + isnull(GrossAmount, 0)) <> 0
	order by LineNumber

	-- and the premium changes for the display of changes on the report
	select * from #premchanges


	RETURN 1
GO
