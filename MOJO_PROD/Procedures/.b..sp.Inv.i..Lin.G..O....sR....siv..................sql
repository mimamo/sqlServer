USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrdersRecursive]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrdersRecursive]
	(
		@InvoiceKey int,
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4),
		@BCClientLink int,
		@IOClientLink int
	)

AS --Encrypt

/*  Who When        Rel     What
||  GHL 06/23/2006  8.35    Clone of sptInvoiceLineGetOrders for summary lines
||  GHL 04/25/2007  8.5     Added Quantity to support new group by order
||  MFT 01/21/09  10.0.1.7  Added VendorNameID field (concatentation of VendorID and VendorName)
*/ 

    DECLARE @ChildLineKey INT
    SELECT @ChildLineKey = -1
    
    WHILE (1=1)
    BEGIN
		SELECT @ChildLineKey = MIN(InvoiceLineKey)
		FROM   tInvoiceLine (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey 
		AND    ParentLineKey = @InvoiceLineKey
		AND    InvoiceLineKey > @ChildLineKey
		
		IF @ChildLineKey IS NULL
			BREAK
			
		-- Do inserts in expense table
	
	-- Same query as in sptInvoiceLineGetOrders
	-- But replace InvoiceLineKey by @ChildLineKey
	
if (@Type = 1 and @IOClientLink = 2) or (@Type = 2 and @BCClientLink = 2) -- link to division & product via estimate
	insert #tOrder
	Select
	    po.PurchaseOrderNumber
       ,pod.LineNumber 
       ,po.PODate
	   ,pod.DetailOrderDate
	   ,pod.DetailOrderEndDate
	   ,pod.ShortDescription 
	   ,pod.UserDate1
	   ,pod.UserDate2
	   ,pod.UserDate3
	   ,pod.UserDate4
	   ,pod.UserDate5
	   ,pod.UserDate6
	   ,pod.OrderDays
	   ,pod.OrderTime
	   ,pod.OrderLength
                      
		,pod.Quantity * @Percentage as pQuantity,
		pod.Quantity  as Quantity,
		pod.UnitCost * @Percentage as pUnitCost,
		pod.AmountBilled * @Percentage as pAmountBilled,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		left(me.EstimateName,100) as EstimateName,
		cp.ClientProductKey,
		left(cp.ProductName,100) as ClientProduct,
		cd.ClientDivisionKey,
		left(cd.DivisionName,100) as ClientDivision,
		mm.MediaMarketKey,
		left(mm.MarketName,100) as MarketName,
		cm.CompanyMediaKey,
		c.CompanyName as VendorName,
		c.CompanyKey as VendorKey,
		c.VendorID as VendorID,
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		pod.InvoiceLineKey = @ChildLineKey and
		po.POKind = @Type
		and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 

else  -- link to division & product via project

	insert #tOrder
	Select
		po.PurchaseOrderNumber
       ,pod.LineNumber 
       ,po.PODate
	   ,pod.DetailOrderDate
	   ,pod.DetailOrderEndDate
	   ,pod.ShortDescription 
	   ,pod.UserDate1
	   ,pod.UserDate2
	   ,pod.UserDate3
	   ,pod.UserDate4
	   ,pod.UserDate5
	   ,pod.UserDate6
	   ,pod.OrderDays
	   ,pod.OrderTime
	   ,pod.OrderLength
        
		,pod.Quantity * @Percentage as pQuantity,
		pod.Quantity  as Quantity,
		pod.UnitCost * @Percentage as pUnitCost,
		pod.AmountBilled * @Percentage as pAmountBilled,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		left(me.EstimateName,100) as EstimateName,
		cp.ClientProductKey,
		left(cp.ProductName,100) as ClientProduct,
		cd.ClientDivisionKey,
		left(cd.DivisionName,100) as ClientDivision,
		mm.MediaMarketKey,
		left(mm.MarketName,100) as MarketName,
		cm.CompanyMediaKey,
		c.CompanyName as VendorName,
		c.CompanyKey as VendorKey,
		c.VendorID as VendorID,
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tProject pr (nolock) on pod.ProjectKey = pr.ProjectKey
		left outer join tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		pod.InvoiceLineKey = @ChildLineKey and
		po.POKind = @Type
		and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 

	EXEC sptInvoiceLineGetOrdersRecursive @InvoiceKey, @ChildLineKey, @Type,
			@Percentage, @BCClientLink, @IOClientLink
		
	END
GO
