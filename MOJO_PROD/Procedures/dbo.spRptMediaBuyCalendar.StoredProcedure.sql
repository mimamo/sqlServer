USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaBuyCalendar]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaBuyCalendar]
	@MediaWorksheetKey int,
	@CostBase tinyint = 1,
	@StartDate datetime = NULL OUTPUT,
	@EndDate datetime = NULL OUTPUT
AS

/*  Who When        Rel       What
||  MFT 01/30/2013  10.5.7.6  Created
||  MFT 03/24/2014  10.5.7.8  Added Client Cost case logic
||  MFT 04/21/2014  10.5.7.9  Changed SpaceID to SpaceName
||  GHL 10/28/2014  10.5.8.5  Do not include cancelled PO and PODs (premiums)
*/

--This functions as the filter list for both data sets selected
DECLARE @Buys table
	(
		PurchaseOrderKey int,
		DetailOrderDate datetime,
		ProjectKey int
	)

SELECT
	@StartDate = ISNULL(@StartDate, StartDate),
	@EndDate = ISNULL(@EndDate, EndDate)
FROM
	tMediaWorksheet
WHERE
	MediaWorksheetKey = @MediaWorksheetKey

INSERT INTO
	@Buys
SELECT
	po.PurchaseOrderKey,
	pod.DetailOrderDate,
	ws.ProjectKey
FROM
	tMediaWorksheet ws (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON ws.MediaWorksheetKey = po.MediaWorksheetKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.LineType = 'order' AND pod.LineNumber = 1
	LEFT JOIN tMediaPosition mp (nolock) ON po.MediaPrintPositionKey = mp.MediaPositionKey
WHERE
	ws.MediaWorksheetKey = @MediaWorksheetKey AND isnull(po.Cancelled, 0) = 0 AND isnull(pod.Cancelled, 0) = 0 AND
	DetailOrderDate BETWEEN @StartDate AND @EndDate

SELECT
	ws.WorksheetID + ' - ' + ws.WorksheetName AS Worksheet,
	ws.StartDate AS WorksheetStartDate,
	ws.EndDate As WorksheetEndDate,
	ws.*,
	mk.MarketID + ' - ' + mk.MarketName AS Market,
	po.*,
	pod.LongDescription AS Comment,
	pod.ShortDescription AS AdCaption,
	pod.DetailOrderDate,
	CASE @CostBase WHEN 1 THEN g.GrossAmount WHEN 2 THEN g.TotalCost ELSE
			CASE po.BillingBase
				WHEN 1 THEN --Gross Plus
					CASE po.BillingAdjBase
						WHEN 1 THEN --Net
							g.GrossAmount + ((po.BillingAdjPercent * 0.01) * g.TotalCost)
						WHEN 2 THEN --Gross
							g.GrossAmount + ((po.BillingAdjPercent * 0.01) * g.GrossAmount)
					END
				WHEN 2 THEN --Gross Minus
					CASE po.BillingAdjBase
						WHEN 1 THEN --Net
							g.GrossAmount - ((po.BillingAdjPercent * 0.01) * g.TotalCost)
						WHEN 2 THEN --Gross
							g.GrossAmount - ((po.BillingAdjPercent * 0.01) * g.GrossAmount)
					END
				WHEN 3 THEN --Net Plus
					CASE po.BillingAdjBase
						WHEN 1 THEN --Net
							g.TotalCost + ((po.BillingAdjPercent * 0.01) * g.TotalCost)
						WHEN 2 THEN --Gross
							g.TotalCost + ((po.BillingAdjPercent * 0.01) * g.GrossAmount)
					END
				WHEN 4 THEN --Net Minus
					CASE po.BillingAdjBase
						WHEN 1 THEN --Net
							g.TotalCost - ((po.BillingAdjPercent * 0.01) * g.TotalCost)
						WHEN 2 THEN --Gross
							g.TotalCost - ((po.BillingAdjPercent * 0.01) * g.GrossAmount)
					END
			END
	END AS Cost,
	cm.StationID + ' - ' + cm.Name AS Publication,
	cm.Name as PublicationName,
	cm.StationID AS PublicationID,
	cm.Circulation,
	cm.Frequency AS PublicationFrequency,
	p.ProjectNumber + ' - ' + p.ProjectName AS Project,
	p.ProjectNumber,
	p.ProjectName,
	p.StartDate AS ProjectStartDate,
	p.CompleteDate AS ProjectEndDate,
	p.StartDate,
	cl.CompanyName AS ClientName,
	cmp.CampaignName,
	cmp.CampaignID + ' - ' + cmp.CampaignName AS Campaign,
	ISNULL(cprod.ProductName, cprodp.ProductName) AS ProductName,
	ISNULL(mp.PositionName, ISNULL(po.MediaPrintPositionID, '')) AS Position,
	mp.PositionName,
	ISNULL(ms.SpaceName, ISNULL(po.MediaPrintSpaceID, '')) AS SpaceID,
	st1.SalesTaxID AS SalesTax1ID,
	st2.SalesTaxID AS SalesTax2ID
FROM
	tMediaWorksheet ws (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON ws.MediaWorksheetKey = po.MediaWorksheetKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.LineType = 'order' AND pod.LineNumber = 1
	INNER JOIN (SELECT PurchaseOrderKey, SUM(GrossAmount) AS GrossAmount, SUM(TotalCost) AS TotalCost 
		FROM tPurchaseOrderDetail (nolock)
		where isnull(tPurchaseOrderDetail.Cancelled, 0) = 0 
		GROUP BY PurchaseOrderKey) g ON po.PurchaseOrderKey = g.PurchaseOrderKey
	INNER JOIN tCompanyMedia cm (nolock) ON po.CompanyMediaKey = cm.CompanyMediaKey
	INNER JOIN tCompany cl (nolock) ON ws.ClientKey = cl.CompanyKey
	INNER JOIN @Buys b ON b.PurchaseOrderKey = po.PurchaseOrderKey
	LEFT JOIN tMediaPosition mp (nolock) ON po.MediaPrintPositionKey = mp.MediaPositionKey
	LEFT JOIN tProject p (nolock) ON ws.ProjectKey = p.ProjectKey
	LEFT JOIN tCampaign cmp (nolock) ON p.CampaignKey = cmp.CampaignKey
	LEFT JOIN tClientProduct cprod (nolock) ON ws.ClientProductKey = cprod.ClientProductKey
	LEFT JOIN tClientProduct cprodp (nolock) ON p.ClientProductKey = cprodp.ClientProductKey
	LEFT JOIN tMediaSpace ms (nolock) ON po.MediaPrintSpaceKey = ms.MediaSpaceKey
	LEFT JOIN tMediaMarket mk (nolock) ON po.MediaMarketKey = mk.MediaMarketKey
	LEFT JOIN tSalesTax st1 (nolock) ON po.SalesTaxKey = st1.SalesTaxKey
	LEFT JOIN tSalesTax st2 (nolock) ON po.SalesTax2Key = st2.SalesTaxKey
ORDER BY
	cm.Name,
	po.PurchaseOrderNumber

SELECT DISTINCT
	pod.PurchaseOrderKey,
	mp.MediaPremiumKey,
	ISNULL(mp.Description, PremiumName) AS Description
FROM
	tPurchaseOrderDetail pod (nolock)
	INNER JOIN tMediaPremium mp (nolock) ON pod.MediaPremiumKey = mp.MediaPremiumKey
WHERE
	LineType = 'prem' AND isnull(pod.Cancelled, 0) = 0 AND
	PurchaseOrderKey IN
	(
		SELECT PurchaseOrderKey
		FROM @Buys
	)
ORDER BY
	pod.PurchaseOrderKey,
	mp.MediaPremiumKey
GO
