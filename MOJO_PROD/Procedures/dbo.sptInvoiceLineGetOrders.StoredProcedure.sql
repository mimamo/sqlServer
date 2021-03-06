USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrders]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrders]
	(
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4)
	)

AS --Encrypt

/*  Who When        Rel       What
||  GHL 04/12/2006  8.3       Changed ISNULL(cm.StationID, c.VendorID) to cm.StationID
||                            United Concepts complained that it was showing wrong Publication or Station
||                            Also causing problems with the report's groups and sorts
||  GHL 05/19/2006  8.4       Added Vendor info since Nerland did not like the change made in 83 
||  GHL 05/07/2008  8.510     (21995) Added Item for new grouping
||  MFT 01/21/2009  10.0.1.7  Added VendorNameID field (concatentation of VendorID and VendorName)
||  MFT 04/28/2010  10.5.2.2  Split out orders w/ vouchers into seperate unioned query
||  MFT 05/25/2010  10.5.3.0  Removed tVoucherDetail NULL requirment from "top" queries;
||                            Corrected "bottom" queries to match InvoiceLinkKey to tVoucherDetail
||  MFT 11/12/2012  10.5.6.2  Added pod.DetailOrderDate to the ORDER BY 2nd to CompanyMedia.Name 
||  WDF 08/14/2013  10.5.7.1  Added EstimateID
||  MFT 12/04/2013  10.5.7.5  Added pNet and pCommission (197741)
*/ 
declare @IOClientLink smallint
declare @BCClientLink smallint
declare @CompanyKey int

select @CompanyKey = co.CompanyKey
  from tCompany co (nolock) inner join tInvoice inv (nolock) on co.CompanyKey = inv.CompanyKey
       inner join tInvoiceLine invl (nolock) on inv.InvoiceKey = invl.InvoiceKey
 where invl.InvoiceLineKey = @InvoiceLineKey   
       
select @BCClientLink = isnull(BCClientLink,1),
       @IOClientLink = isnull(IOClientLink,1)
  from tPreference (nolock)
 where CompanyKey = @CompanyKey

Select @Percentage = @Percentage / 100

if (@Type = 1 and @IOClientLink = 2) or (@Type = 2 and @BCClientLink = 2) -- link to division & product via estimate
	Select
		pod.*,
		pod.Quantity * @Percentage as pQuantity,
		pod.UnitCost * @Percentage as pUnitCost,
		pod.AmountBilled * @Percentage as pAmountBilled,
		pod.TotalCost * @Percentage as pNet,
		(pod.AmountBilled * @Percentage) - (pod.TotalCost * @Percentage) as pCommission,
		po.PurchaseOrderNumber,
		po.PODate,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		me.EstimateID,
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
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
		i.ItemName,
		i.ItemKey
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
		pod.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type AND
		(pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 		
		
	UNION ALL
		
	Select
		pod.*,
		vd.Quantity * @Percentage as pQuantity,
		vd.UnitCost * @Percentage as pUnitCost,
		vd.AmountBilled * @Percentage as pAmountBilled,
		vd.TotalCost * @Percentage as pNet,
		(vd.AmountBilled * @Percentage) - (vd.TotalCost * @Percentage) as pCommission,
		po.PurchaseOrderNumber,
		po.PODate,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		me.EstimateID,
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
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
		i.ItemName,
		i.ItemKey
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type
		and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
	Order By cm.Name, pod.DetailOrderDate, po.PODate, po.PurchaseOrderNumber, pod.LineNumber

else  -- link to division & product via project

	Select
		pod.*,
		pod.Quantity * @Percentage as pQuantity,
		pod.UnitCost * @Percentage as pUnitCost,
		pod.AmountBilled * @Percentage as pAmountBilled,
		pod.TotalCost * @Percentage as pNet,
		(pod.AmountBilled * @Percentage) - (pod.TotalCost * @Percentage) as pCommission,
		po.PurchaseOrderNumber,
		po.PODate,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		me.EstimateID,
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
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
		i.ItemName,
		i.ItemKey
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
		pod.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type AND
		(pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled
				
	UNION ALL

	Select
		pod.*,
		vd.Quantity * @Percentage as pQuantity,
		vd.UnitCost * @Percentage as pUnitCost,
		vd.AmountBilled * @Percentage as pAmountBilled,
		vd.TotalCost * @Percentage as pNet,
		(vd.AmountBilled * @Percentage) - (vd.TotalCost * @Percentage) as pCommission,
		po.PurchaseOrderNumber,
		po.PODate,
		cm.StationID as StationID,
		cm.Name as StationName,
		po.MediaEstimateKey,
		me.EstimateID,
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
		ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
		i.ItemName,
		i.ItemKey
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tProject pr (nolock) on pod.ProjectKey = pr.ProjectKey
		left outer join tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type and
		(vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
	Order By cm.Name, pod.DetailOrderDate, po.PODate, po.PurchaseOrderNumber, pod.LineNumber
GO
