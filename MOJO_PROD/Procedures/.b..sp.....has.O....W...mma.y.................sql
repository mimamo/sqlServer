USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderWSSummary]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderWSSummary]
	@CompanyKey int,
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 10/29/13  CRG 10.5.7.3 Created
|| 12/13/13  RLB 10.5.7.5 Rewrite
|| 03/31/14  CRG 10.5.7.8 Modified to pull the DetailOrderDate only from the "order" lines because that is the true date for the BuyLine
|| 04/03/14  CRG 10.5.7.8 Added ability to filter the list based on POKeys loaded into a temp table before this SP is called
|| 07/23/14  GHL 10.5.8.2 Filter out cancelled premiums (they are on PODs no POs)
|| 10/06/14  GHL 10.5.8.5 Added Taxes 
|| 11/03/14  GHL 10.5.8.5 Added Taxes to Totals
*/

/* Assume created in VB
	CREATE TABLE #POKeys (PurchaseOrderKey int NULL)
*/

	-- create temp table of the main order lines to use for the DetailOrderDate (since it's the one with the current date for the BuyLine)
	SELECT	pod.PurchaseOrderKey, pod.DetailOrderDate, po.CompanyMediaKey, po.MediaMarketKey, po.ItemKey
	INTO	#orderlines
	FROM	tPurchaseOrderDetail pod (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE	po.CompanyKey = @CompanyKey
	AND		po.MediaWorksheetKey = @MediaWorksheetKey
	AND		pod.LineType = 'order'

	--IF POKeys are in the temp table from VB, then we need to remove any PO's that are not in the list
	IF EXISTS (SELECT NULL FROM #POKeys)
		DELETE	#orderlines
		WHERE	PurchaseOrderKey NOT IN (SELECT PurchaseOrderKey FROM #POKeys)
	
    -- summary Publications
	CREATE TABLE #mainWorksheetPublicationSummary
		(CompanyMediaName varchar(250) NULL, 
		MonthEntity varchar(50) NULL, 
		NumberOfBuys int NULL, 
		TotalGross money NULL, 
		TotalNet money NULL, 
		TotalClient money NULL,
		SalesTax1Amount money NULL,
		SalesTax2Amount money NULL,
		DisplayOrder int null)
	
	-- summary Markets
	CREATE TABLE #mainWorksheetMarketSummary
		( MediaMarketName varchar(200) NULL,  
		MonthEntity varchar(50) NULL, 
		NumberOfBuys int NULL, 
		TotalGross money NULL, 
		TotalNet money NULL, 
		TotalClient money NULL,
		SalesTax1Amount money NULL,
		SalesTax2Amount money NULL,
		DisplayOrder int null)

    -- summary for items
	CREATE TABLE #mainWorksheetItemSummary
		(ItemName varchar(200),  
		MonthEntity varchar(50) NULL, 
		NumberOfBuys int NULL, 
		TotalGross money NULL, 
		TotalNet money NULL, 
		TotalClient money NULL,
		SalesTax1Amount money NULL,
		SalesTax2Amount money NULL,
		DisplayOrder int null)
		
		-- used to calculate month buckets
	DECLARE @SummaryWorksheetStartDate smalldatetime, 
		    @SummaryWorksheetEndDate smalldatetime, 
		    @CurrentStartDate smalldatetime,
		    @CurrentEndDate smalldatetime,
		    @MonthEntity varchar(50),
		    @DisplayOrder int
		    
	-- Set Worksheet start, end Dates and bucket start, end dates
	SELECT @SummaryWorksheetStartDate = StartDate, @SummaryWorksheetEndDate = EndDate  from tMediaWorksheet (nolock) where MediaWorksheetKey = @MediaWorksheetKey
	
	SELECT @CurrentStartDate = cast(cast(datepart(mm, @SummaryWorksheetStartDate) as varchar(2)) + '/01/' + cast(datepart(yyyy,@SummaryWorksheetStartDate) as varchar(4)) as datetime)
	SELECT @CurrentEndDate = DATEADD(mm, 1, @CurrentStartDate)
	
	-- Start to set month buckets
	SELECT @DisplayOrder = 0
	
	WHILE 1=1
		BEGIN
			if @CurrentStartDate IS NULL
				BREAK
			if @CurrentEndDate IS NULL
				BREAK
			
			if @CurrentStartDate > @SummaryWorksheetEndDate
				BREAK
				
			if @CurrentEndDate > @SummaryWorksheetEndDate
				select @CurrentEndDate = @SummaryWorksheetEndDate
	        
	        SELECT @MonthEntity = DATENAME(month,@CurrentStartDate)
	        
	        SELECT @DisplayOrder = @DisplayOrder + 1
	
	        -- select for Summary Publication data
			INSERT	#mainWorksheetPublicationSummary
					(CompanyMediaName,
					MonthEntity,
					DisplayOrder,
					NumberOfBuys,
					TotalGross,
					TotalNet,
					TotalClient,
					SalesTax1Amount,
					SalesTax2Amount
					)
			SELECT	ISNULL(cm.Name, 'None'),
					@MonthEntity,
					@DisplayOrder,
					publicationData.NumberOfBuys,
					SUM(pod.GrossAmount) AS TotalGross,
					SUM(pod.TotalCost) AS TotalNet,
					SUM(pod.BillableCost) AS TotalClient,
					SUM(pod.SalesTax1Amount) AS SalesTax1Amount,
					SUM(pod.SalesTax2Amount) AS SalesTax2Amount
			FROM	tPurchaseOrderDetail pod (nolock)
			INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN #orderlines (nolock) ON po.PurchaseOrderKey = #orderlines.PurchaseOrderKey
			LEFT OUTER JOIN  tCompanyMedia cm (nolock) ON po.CompanyMediaKey = cm.CompanyMediaKey
			LEFT OUTER JOIN (select		#orderlines.CompanyMediaKey, count(*) as NumberOfBuys		
								from	#orderlines
								where	#orderlines.DetailOrderDate > = @CurrentStartDate 
								and		#orderlines.DetailOrderDate < @CurrentEndDate
								group by #orderlines.CompanyMediaKey) as publicationData ON po.CompanyMediaKey = publicationData.CompanyMediaKey
			WHERE po.CompanyKey = @CompanyKey	
			AND po.MediaWorksheetKey = @MediaWorksheetKey 
			AND #orderlines.DetailOrderDate > = @CurrentStartDate 
			AND #orderlines.DetailOrderDate < @CurrentEndDate
			AND isnull(pod.Cancelled, 0) = 0
			GROUP BY cm.Name, publicationData.NumberOfBuys
			
			 -- select for Summary Market data
			INSERT	#mainWorksheetMarketSummary
					(MediaMarketName,
					MonthEntity,
					DisplayOrder,
					NumberOfBuys,
					TotalGross,
					TotalNet,
					TotalClient,
					SalesTax1Amount,
					SalesTax2Amount
					)
			SELECT	ISNULL(mm.MarketName, 'None'),
					@MonthEntity,
					@DisplayOrder,
					marketData.NumberOfBuys,
					SUM(pod.GrossAmount) AS TotalGross,
					SUM(pod.TotalCost) AS TotalNet,
					SUM(pod.BillableCost) AS TotalClient,
					SUM(pod.SalesTax1Amount) AS SalesTax1Amount,
					SUM(pod.SalesTax2Amount) AS SalesTax2Amount
			FROM	tPurchaseOrderDetail pod (nolock)
			INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN #orderlines (nolock) ON po.PurchaseOrderKey = #orderlines.PurchaseOrderKey
			LEFT OUTER JOIN  tMediaMarket mm (nolock) ON po.MediaMarketKey = mm.MediaMarketKey
			LEFT OUTER JOIN (select isnull(#orderlines.MediaMarketKey, 0) as MediaMarketKey, count(*) as NumberOfBuys		
								from	#orderlines
								where	#orderlines.DetailOrderDate > = @CurrentStartDate 
								and		#orderlines.DetailOrderDate < @CurrentEndDate
								group by #orderlines.MediaMarketKey) as marketData ON ISNULL(po.MediaMarketKey, 0) = marketData.MediaMarketKey
			WHERE po.CompanyKey = @CompanyKey	
			AND po.MediaWorksheetKey = @MediaWorksheetKey 
			AND #orderlines.DetailOrderDate > = @CurrentStartDate 
			AND #orderlines.DetailOrderDate < @CurrentEndDate
			AND isnull(pod.Cancelled, 0) = 0
			GROUP BY mm.MarketName, marketData.NumberOfBuys


			-- select for Item Summary on the PO's
			INSERT	#mainWorksheetItemSummary
					(ItemName,
					MonthEntity,
					DisplayOrder,
					NumberOfBuys,
					TotalGross,
					TotalNet,
					TotalClient,
					SalesTax1Amount,
					SalesTax2Amount
					)
			SELECT	ISNULL(i.ItemName, 'None'),
					@MonthEntity,
					@DisplayOrder,
					itemData.NumberOfBuys,
					SUM(pod.GrossAmount) AS TotalGross,
					SUM(pod.TotalCost) AS TotalNet,
					SUM(pod.BillableCost) AS TotalClient,
					SUM(pod.SalesTax1Amount) AS SalesTax1Amount,
					SUM(pod.SalesTax2Amount) AS SalesTax2Amount
			FROM	tPurchaseOrderDetail pod (nolock)
			INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tItem i (nolock) on pod.ItemKey = i.ItemKey
			INNER JOIN #orderlines (nolock) ON po.PurchaseOrderKey = #orderlines.PurchaseOrderKey
			LEFT OUTER JOIN (select #orderlines.ItemKey, count(*) as NumberOfBuys		
								from	#orderlines (nolock)
								where	#orderlines.DetailOrderDate > = @CurrentStartDate 
								and		#orderlines.DetailOrderDate < @CurrentEndDate
								group by #orderlines.ItemKey) as itemData ON pod.ItemKey = itemData.ItemKey
			WHERE po.CompanyKey = @CompanyKey	
			AND po.MediaWorksheetKey = @MediaWorksheetKey 
			AND #orderlines.DetailOrderDate > = @CurrentStartDate 
			AND #orderlines.DetailOrderDate < @CurrentEndDate
			AND isnull(pod.Cancelled, 0) = 0
			GROUP BY i.ItemName, itemData.NumberOfBuys
			
			SELECT @CurrentStartDate = DATEADD(mm, 1, @CurrentStartDate)
			SELECT @CurrentEndDate = DATEADD(mm, 1, @CurrentStartDate)
	END
	
	-- SM's request, add taxes to Totals
	update #mainWorksheetPublicationSummary
	set    TotalNet = isnull(TotalNet, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
	      ,TotalGross = isnull(TotalGross, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
		  ,TotalClient = isnull(TotalClient, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)

	update #mainWorksheetMarketSummary
	set    TotalNet = isnull(TotalNet, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
	      ,TotalGross = isnull(TotalGross, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
		  ,TotalClient = isnull(TotalClient, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)

	update #mainWorksheetItemSummary
	set    TotalNet = isnull(TotalNet, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
	      ,TotalGross = isnull(TotalGross, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)
		  ,TotalClient = isnull(TotalClient, 0) + isnull(SalesTax1Amount, 0) + + isnull(SalesTax2Amount, 0)

	select * from #mainWorksheetPublicationSummary Order by DisplayOrder
	
	select * from #mainWorksheetMarketSummary Order by DisplayOrder

	select * from #mainWorksheetItemSummary Order by DisplayOrder
GO
