USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrdersByOrder]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrdersByOrder]
	(
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4)
	)

AS --Encrypt

/*  Who When       Rel       What
||  GHL 04/24/07   8.5       Creation for Enh 6878. Clone of sptInvoiceLineGetOrders
||  MFT 01/21/09   10.0.1.7  Added VendorNameID field (concatentation of VendorID and VendorName)
||  MFT 05/25/2010 10.5.3.0  Split out orders w/ vouchers into seperate unioned query
||  GWG 05/26/10   10.5.3.0  Fixed last change
||  GHL 04/23/12   10.5.5.5  (140964) Had to group again the data by PO, because we had duplicates in the case when
||                           - ILK1 is linked to POD1 linked to PO1
||                           - ILK1 is linked to VD1 linked to POD2 linked to PO1
*/ 

Select @Percentage = @Percentage / 100


select
		po.PurchaseOrderNumber
		,po.PODate
		,po.StationID
		,po.StationName
		,po.MediaEstimateKey
		,po.EstimateName
		,po.MediaMarketKey
		,po.MarketName
		,po.CompanyMediaKey
		,po.VendorName
		,po.VendorKey
		,po.VendorID
		,po.VendorNameID
		,SUM(po.pQuantity) as pQuantity
		,SUM(po.pAmountBilled) as pAmountBilled

		,CASE
		WHEN SUM(po.pQuantity) = 0 THEN SUM(po.pAmountBilled) 
		ELSE (SUM(po.pAmountBilled)) / SUM(po.pQuantity)
		END AS pUnitCost

		,MIN(po.DetailOrderDate) as DetailOrderDate
		,MAX(po.DetailOrderEndDate) as DetailOrderEndDate
		,MAX(po.UserDate1) as UserDate1
		,MAX(po.UserDate2) as UserDate2
		,MAX(po.UserDate3) as UserDate3
		,MAX(po.UserDate4) as UserDate4
		,MAX(po.UserDate5) as UserDate5
		,MAX(po.UserDate6) as UserDate6

from 
	(
Select
	po.PurchaseOrderNumber,
	po.PODate,
	cm.StationID as StationID,
	cm.Name as StationName,
	po.MediaEstimateKey,
	left(me.EstimateName,100) as EstimateName,
	mm.MediaMarketKey,
	left(mm.MarketName,100) as MarketName,
	cm.CompanyMediaKey,
	c.CompanyName as VendorName,
	c.CompanyKey as VendorKey,
	c.VendorID as VendorID,
	ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
	
	-- Grouped pod values
	SUM(pod.Quantity) * @Percentage as pQuantity,
	SUM(pod.AmountBilled) * @Percentage as pAmountBilled,
	CASE
		WHEN SUM(pod.Quantity) = 0 THEN SUM(pod.AmountBilled) * @Percentage
		ELSE (SUM(pod.AmountBilled) * @Percentage) / SUM(pod.Quantity)
	END AS pUnitCost,
	MIN(pod.DetailOrderDate) as DetailOrderDate,
	MAX(pod.DetailOrderEndDate) as DetailOrderEndDate,
	MAX(pod.UserDate1) as UserDate1,
	MAX(pod.UserDate2) as UserDate2,
	MAX(pod.UserDate3) as UserDate3,
	MAX(pod.UserDate4) as UserDate4,
	MAX(pod.UserDate5) as UserDate5,
	MAX(pod.UserDate6) as UserDate6
From
	tPurchaseOrderDetail pod (nolock) 
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
Where
	pod.InvoiceLineKey = @InvoiceLineKey and
	po.POKind = @Type
	and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
GROUP BY
	po.PurchaseOrderNumber,
	po.PODate,
	cm.StationID,
	cm.Name,
	po.MediaEstimateKey,
	left(me.EstimateName,100),
	mm.MediaMarketKey,
	left(mm.MarketName,100),
	cm.CompanyMediaKey,
	c.CompanyName,
	c.CompanyKey,
	c.VendorID

UNION ALL

Select
	po.PurchaseOrderNumber,
	po.PODate,
	cm.StationID as StationID,
	cm.Name as StationName,
	po.MediaEstimateKey,
	left(me.EstimateName,100) as EstimateName,
	mm.MediaMarketKey,
	left(mm.MarketName,100) as MarketName,
	cm.CompanyMediaKey,
	c.CompanyName as VendorName,
	c.CompanyKey as VendorKey,
	c.VendorID as VendorID,
	ISNULL(c.VendorID + '-', '') + ISNULL(c.CompanyName, '') as VendorNameID,
	
	-- Grouped pod values
	SUM(vd.Quantity) * @Percentage as pQuantity,
	SUM(vd.AmountBilled) * @Percentage as pAmountBilled,
	CASE
		WHEN SUM(vd.Quantity) = 0 THEN SUM(vd.AmountBilled) * @Percentage
		ELSE (SUM(vd.AmountBilled) * @Percentage) / SUM(vd.Quantity)
	END AS pUnitCost,
	MIN(pod.DetailOrderDate) as DetailOrderDate,
	MAX(pod.DetailOrderEndDate) as DetailOrderEndDate,
	MAX(pod.UserDate1) as UserDate1,
	MAX(pod.UserDate2) as UserDate2,
	MAX(pod.UserDate3) as UserDate3,
	MAX(pod.UserDate4) as UserDate4,
	MAX(pod.UserDate5) as UserDate5,
	MAX(pod.UserDate6) as UserDate6
From
	tPurchaseOrderDetail pod (nolock) 
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
	inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
Where
	vd.InvoiceLineKey = @InvoiceLineKey and
	po.POKind = @Type
	and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
GROUP BY
	po.PurchaseOrderNumber,
	po.PODate,
	cm.StationID,
	cm.Name,
	po.MediaEstimateKey,
	left(me.EstimateName,100),
	mm.MediaMarketKey,
	left(mm.MarketName,100),
	cm.CompanyMediaKey,
	c.CompanyName,
	c.CompanyKey,
	c.VendorID

--ORDER BY po.PurchaseOrderNumber

	) as po


	group by
		po.PurchaseOrderNumber
		,po.PODate
		,po.StationID
		,po.StationName
		,po.MediaEstimateKey
		,po.EstimateName
		,po.MediaMarketKey
		,po.MarketName
		,po.CompanyMediaKey
		,po.VendorName
		,po.VendorKey
		,po.VendorID
		,po.VendorNameID

ORDER BY
	po.PurchaseOrderNumber
GO
