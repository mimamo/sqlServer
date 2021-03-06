USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaInsertionOrderGetEntities]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaInsertionOrderGetEntities]
	(
	@MediaWorksheetKey int
	)
AS --Encrypt

	SET NOCOUNT ON

/*
  || When     Who Rel    What
  || 06/09/14 GHL 10.581 Created for the new media order printouts 
  ||                     The purpose is to get a list of entities to print in the order in which it is
  ||                     on the Insertion Order list (when we do not print from the media worksheet)
  ||                     The entities will be tMediaOrder or tPurchaseOrder
*/

	/* Assume done in VB
	
	-- the SortKey identities guarantees that the sort selected on the listing is maintained 
	create table #io (PurchaseOrderKey int null, SortKey int identity(1,1) )
	
	*/

	create table #io2 (Entity varchar(50) null
				, EntityKey int null
				, PurchaseOrderKey int null
				, MediaOrderKey int null
				, MediaWorksheetKey int null
				, OneBuyPerOrder int null
				, PurchaseOrderNumber varchar(50) null
				, InternalID int null
				, SortKey int null
				)

	-- insert from the original array, by default they are entity tPurchaseOrder
	insert #io2 (Entity, EntityKey, PurchaseOrderKey,SortKey)
	select 'tPurchaseOrder', PurchaseOrderKey, PurchaseOrderKey, SortKey
	from    #io

	update #io2
	set    #io2.MediaOrderKey = po.MediaOrderKey
	      ,#io2.MediaWorksheetKey = po.MediaWorksheetKey
		  ,#io2.PurchaseOrderNumber = po.PurchaseOrderNumber
		  ,#io2.InternalID = po.InternalID
	from   tPurchaseOrder po (nolock)
	where  #io2.PurchaseOrderKey =  po.PurchaseOrderKey
	
	update #io2
	set    #io2.OneBuyPerOrder = mw.OneBuyPerOrder
	from   tMediaWorksheet mw (nolock)
	where  #io2.MediaWorksheetKey = mw.MediaWorksheetKey 

	update #io2
	set    #io2.OneBuyPerOrder = isnull(#io2.OneBuyPerOrder, 0)
	      ,#io2.InternalID = isnull(#io2.InternalID, 0)
	
	-- Now change the entities if we have a media order
	update #io2
	set    #io2.Entity = 'tMediaOrder'
	      ,#io2.EntityKey = #io2.MediaOrderKey
	where  #io2.MediaOrderKey > 0

	-- Now do the grouping / merging by Entity PO or MO
	if isnull(@MediaWorksheetKey,0) > 0
		-- we print from a worksheet
		select Entity, EntityKey, MediaOrderKey, MediaWorksheetKey,OneBuyPerOrder, PurchaseOrderNumber
		, min(InternalID) as InternalID
		,0 as SortKey
		from #io2
		group by Entity, EntityKey, MediaOrderKey, MediaWorksheetKey,OneBuyPerOrder, PurchaseOrderNumber
		order by PurchaseOrderNumber, InternalID

	else
		-- we print from the IO listing, try to follow the same order 
		select Entity, EntityKey, MediaOrderKey, MediaWorksheetKey,OneBuyPerOrder, PurchaseOrderNumber
		,0 as InternalID
		,min(SortKey) as SortKey
		from #io2
		group by Entity, EntityKey, MediaOrderKey, MediaWorksheetKey,OneBuyPerOrder, PurchaseOrderNumber
		order by SortKey



	RETURN 1
GO
