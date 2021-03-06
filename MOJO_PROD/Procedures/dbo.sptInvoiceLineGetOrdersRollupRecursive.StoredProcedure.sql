USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrdersRollupRecursive]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrdersRollupRecursive]
	(
		@InvoiceKey int,
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4),
		@IOClientLink int,
		@BCClientLink int 
	)

AS --Encrypt

/*  Who When        Rel     What
||  GHL 06/23/2006  8.35    Clone of sptInvoiceLineGetOrdersRollup for summary lines
||  GHL 05/07/2008  8.510   (21995) Added Item as rollup
||  GWG 05/28/10    10.530  Including vouchers in with the orders
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
	
	-- Same query as in sptInvoiceLineGetOrdersRollup
	-- But replace InvoiceLineKey by @ChildLineKey
				
		if (@Type = 1 and @IOClientLink = 2) or (@Type = 2 and @BCClientLink = 2) -- link to division & product via estimate
		BEGIN
			INSERT #IL
			Select
				ISNULL(pod.Quantity * @Percentage, 0) as pQuantity,
				ISNULL(pod.AmountBilled * @Percentage, 0) as pAmountBilled,
				left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
				left(cp.ProductName,100) as ClientProduct, cp.ClientProductKey,
				left(me.EstimateName,100) as EstimateName, po.MediaEstimateKey,
				left(mm.MarketName,100) as MarketName, mm.MediaMarketKey,
				cm.Name as StationName, cm.CompanyMediaKey,
				c.CompanyName as VendorName, c.CompanyKey,
				i.ItemName As ItemName, i.ItemKey
			From
				tPurchaseOrderDetail pod (nolock) 
				inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
				left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
				left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
				left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
				left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
				left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Where
				pod.InvoiceLineKey = @ChildLineKey and
				po.POKind = @Type
				and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
			--Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber

			INSERT #IL
			Select
				ISNULL(vd.Quantity * @Percentage, 0) as pQuantity,
				ISNULL(vd.AmountBilled * @Percentage, 0) as pAmountBilled,
				left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
				left(cp.ProductName,100) as ClientProduct, cp.ClientProductKey,
				left(me.EstimateName,100) as EstimateName, po.MediaEstimateKey,
				left(mm.MarketName,100) as MarketName, mm.MediaMarketKey,
				cm.Name as StationName, cm.CompanyMediaKey,
				c.CompanyName as VendorName, c.CompanyKey,
				i.ItemName As ItemName, i.ItemKey
			From
				tPurchaseOrderDetail pod (nolock) 
				inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
				left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
				left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
				left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
				left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
				left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Where
				vd.InvoiceLineKey = @ChildLineKey and
				po.POKind = @Type
				and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
			--Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber
		END
		ELSE  -- link to division & product via project
		BEGIN
			INSERT #IL
			Select
				ISNULL(pod.Quantity * @Percentage, 0) as pQuantity,
				ISNULL(pod.AmountBilled * @Percentage, 0) as pAmountBilled,
				left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
				left(cp.ProductName,100) as ClientProduct,cp.ClientProductKey,
				left(me.EstimateName,100) as EstimateName,po.MediaEstimateKey,
				left(mm.MarketName,100) as MarketName,mm.MediaMarketKey,
				cm.Name as StationName, cm.CompanyMediaKey,
				c.CompanyName as VendorName, c.CompanyKey,
				i.ItemName As ItemName, i.ItemKey
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
				left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Where
				pod.InvoiceLineKey = @ChildLineKey and
				po.POKind = @Type
				and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
			--Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber

			INSERT #IL
			Select
				ISNULL(vd.Quantity * @Percentage, 0) as pQuantity,
				ISNULL(vd.AmountBilled * @Percentage, 0) as pAmountBilled,
				left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
				left(cp.ProductName,100) as ClientProduct,cp.ClientProductKey,
				left(me.EstimateName,100) as EstimateName,po.MediaEstimateKey,
				left(mm.MarketName,100) as MarketName,mm.MediaMarketKey,
				cm.Name as StationName, cm.CompanyMediaKey,
				c.CompanyName as VendorName, c.CompanyKey,
				i.ItemName As ItemName, i.ItemKey
			From
				tPurchaseOrderDetail pod (nolock) 
				inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
				left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
				left outer join tProject pr (nolock) on pod.ProjectKey = pr.ProjectKey
				left outer join tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
				left outer join tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
				left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
				left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
			Where
				vd.InvoiceLineKey = @ChildLineKey and
				po.POKind = @Type
				and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
			--Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber

		END

	EXEC sptInvoiceLineGetOrdersRollupRecursive @InvoiceKey, @ChildLineKey, @Type,
			@Percentage, @BCClientLink, @IOClientLink

END

RETURN 1
GO
