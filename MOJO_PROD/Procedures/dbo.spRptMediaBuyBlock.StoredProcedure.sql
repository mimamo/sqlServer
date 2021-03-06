USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaBuyBlock]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaBuyBlock]
	@MediaWorksheetKey int,
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@CostBase tinyint = 1,
	@BlockSpan tinyint = 1,
	@WorksheetStartDate datetime = NULL OUTPUT,
	@WorksheetEndDate datetime = NULL OUTPUT
AS

/*  Who When        Rel       What
||  MFT 01/30/2014  10.5.7.6  Created
||  MFT 03/21/2014  10.5.7.8  Fixed @EndDate calc error
||  MFT 03/24/2014  10.5.7.8  Added Client Cost case logic
||  MFT 03/26/2014  10.5.7.8  Removed cursors
||  MFT 03/31/2014  10.5.7.8  Changed Space to use SpaceName rather than SpaceID
||  GHL 10/28/2014  10.5.8.5  Do not include cancelled PO and PODs (premiums)
||  GHL 10/29/2014  10.5.8.5  Added taxes  
*/

DECLARE
	@UpdateKey int,
	@UpdateValue varchar(50),
	@PurchaseOrderKey int
DECLARE @Buys table
	(
		PurchaseOrderKey int,
		Premiums varchar(1000),
		ClientInvoices varchar(1000),
		VendorInvoices varchar(1000),
		Taxes varchar(250)
	)
DECLARE @Premiums table
	(
		PremiumBuyKey int PRIMARY KEY
			IDENTITY(1, 1),
		PremiumID varchar(50),
		PurchaseOrderKey int,
		Inserted bit
			DEFAULT(0)
	)
DECLARE @ClientInvoices table
	(
		InvoiceBuyKey int PRIMARY KEY
			IDENTITY(1, 1),
		InvoiceNumber varchar(50),
		PurchaseOrderKey int,
		Inserted bit
			DEFAULT(0)
	)
DECLARE @VendorInvoices table
	(
		InvoiceBuyKey int PRIMARY KEY
			IDENTITY(1, 1),
		InvoiceNumber varchar(50),
		PurchaseOrderKey int,
		Inserted bit
			DEFAULT(0)
	)

DECLARE @Taxes table
	(
		SalesTaxBuyKey int PRIMARY KEY
			IDENTITY(1, 1),
		SalesTaxID varchar(50),
		PurchaseOrderKey int,
		Inserted bit
			DEFAULT(0)
	)

--If no start/end dates are passed in, use the worksheet
SELECT
	@WorksheetStartDate = StartDate,
	@WorksheetEndDate = EndDate,
	@StartDate = ISNULL(@StartDate, StartDate),
	@EndDate = ISNULL(@EndDate, EndDate)
FROM
	tMediaWorksheet
WHERE
	MediaWorksheetKey = @MediaWorksheetKey

--Restrict the start date to the first month of the worksheet
IF @StartDate < @WorksheetStartDate
	SELECT @StartDate = @WorksheetStartDate

--Restrict the end date to a single block (likely to happen if set in previous call)
IF @BlockSpan = 1 --One month
	BEGIN
		IF (DATEPART(m, @StartDate) != DATEPART(m, @EndDate) AND DATEPART(yyyy, @StartDate) = DATEPART(yyyy, @EndDate)) OR
		DATEPART(yyyy, @StartDate) != DATEPART(yyyy, @EndDate) OR
		@EndDate < @StartDate
			SELECT @EndDate =	DATEADD(d, -1, CAST(DATEPART(yyyy, DATEADD(m, 1, @StartDate)) AS varchar(4)) + '/' + CAST(DATEPART(m, DATEADD(m, 1, @StartDate)) AS varchar(2)) + '/1')
	END
ELSE --One week
	BEGIN
		IF NOT @EndDate BETWEEN @StartDate AND DATEADD(d, 6, @StartDate)
			SELECT @EndDate =	DATEADD(d, 6, @StartDate)
	END

--Popluate @Buys
INSERT INTO
	@Buys (PurchaseOrderKey)
SELECT
	po.PurchaseOrderKey
FROM
	tMediaWorksheet ws (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON ws.MediaWorksheetKey = po.MediaWorksheetKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.LineType = 'order' AND pod.LineNumber = 1
	LEFT JOIN tMediaPosition mp (nolock) ON po.MediaPrintPositionKey = mp.MediaPositionKey
WHERE
	ws.MediaWorksheetKey = @MediaWorksheetKey AND isnull(po.Cancelled, 0) = 0 AND isnull(pod.Cancelled, 0) = 0 AND
	DetailOrderDate BETWEEN @StartDate AND @EndDate

--Populate @Premiums
INSERT INTO @Premiums
	(
		PremiumID,
		PurchaseOrderKey
	)
SELECT
	PremiumID,
	pod.PurchaseOrderKey
FROM
	tPurchaseOrderDetail pod (nolock)
	INNER JOIN tMediaPremium mp (nolock) ON pod.MediaPremiumKey = mp.MediaPremiumKey
	INNER JOIN @Buys b ON b.PurchaseOrderKey = pod.PurchaseOrderKey
WHERE
	LineType = 'prem'
AND isnull(pod.Cancelled, 0) = 0
GROUP BY
	PremiumID,
	pod.PurchaseOrderKey

--Populate @ClientInvoices
INSERT INTO @ClientInvoices
	(
		InvoiceNumber,
		PurchaseOrderKey
	)
SELECT
	InvoiceNumber,
	pod.PurchaseOrderKey
FROM
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock) ON i.InvoiceKey = il.InvoiceKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON il.InvoiceLineKey = pod.InvoiceLineKey
	INNER JOIN @Buys b ON b.PurchaseOrderKey = pod.PurchaseOrderKey
WHERE isnull(pod.Cancelled, 0) = 0
GROUP BY
	InvoiceNumber,
	pod.PurchaseOrderKey

--Populate @VendorInvoices
INSERT INTO @VendorInvoices
	(
		InvoiceNumber,
		PurchaseOrderKey
	)
SELECT
	InvoiceNumber,
	pod.PurchaseOrderKey
FROM
	tVoucherDetail vd (nolock)
	INNER JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	INNER JOIN @Buys b ON b.PurchaseOrderKey = pod.PurchaseOrderKey
WHERE isnull(pod.Cancelled, 0) = 0
GROUP BY
	InvoiceNumber,
	pod.PurchaseOrderKey

--Populate @Taxes
INSERT INTO @Taxes
	(
		SalesTaxID,
		PurchaseOrderKey
	)
SELECT distinct
	SalesTaxID,
	b.PurchaseOrderKey
FROM
	tSalesTax st (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON st.SalesTaxKey = po.SalesTaxKey
	INNER JOIN @Buys b ON b.PurchaseOrderKey = po.PurchaseOrderKey

INSERT INTO @Taxes
	(
		SalesTaxID,
		PurchaseOrderKey
	)
SELECT distinct
	SalesTaxID,
	b.PurchaseOrderKey
FROM
	tSalesTax st (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON st.SalesTaxKey = po.SalesTax2Key
	INNER JOIN @Buys b ON b.PurchaseOrderKey = po.PurchaseOrderKey

--Set Premiums string
SELECT TOP 1
	@UpdateKey = PremiumBuyKey,
	@UpdateValue = PremiumID,
	@PurchaseOrderKey = PurchaseOrderKey
FROM
	@Premiums
WHERE
	Inserted = 0
ORDER BY
	PremiumBuyKey

WHILE @UpdateKey IS NOT NULL
	BEGIN
		UPDATE @Buys
		SET Premiums = ISNULL(Premiums, '') + CASE LEN(ISNULL(Premiums, '')) WHEN 0 THEN '' ELSE ', ' END + @UpdateValue
		WHERE PurchaseOrderKey = @PurchaseOrderKey
		
		UPDATE @Premiums
		SET Inserted = 1
		WHERE PremiumBuyKey = @UpdateKey
		
		SELECT @UpdateKey = NULL
		SELECT TOP 1
			@UpdateKey = PremiumBuyKey,
			@UpdateValue = PremiumID,
			@PurchaseOrderKey = PurchaseOrderKey
		FROM
			@Premiums
		WHERE
			Inserted = 0
		ORDER BY
			PremiumBuyKey
	END

--Set ClientInvoices string
SELECT TOP 1
	@UpdateKey = InvoiceBuyKey,
	@UpdateValue = InvoiceNumber,
	@PurchaseOrderKey = PurchaseOrderKey
FROM
	@ClientInvoices
WHERE
	Inserted = 0
ORDER BY
	InvoiceBuyKey

WHILE @UpdateKey IS NOT NULL
	BEGIN
		UPDATE @Buys
		SET ClientInvoices = ISNULL(ClientInvoices, '') + CASE LEN(ISNULL(ClientInvoices, '')) WHEN 0 THEN '' ELSE ', ' END + @UpdateValue
		WHERE PurchaseOrderKey = @PurchaseOrderKey
		
		UPDATE @ClientInvoices
		SET Inserted = 1
		WHERE InvoiceBuyKey = @UpdateKey
				
		SELECT @UpdateKey = NULL
		SELECT TOP 1
			@UpdateKey = InvoiceBuyKey,
			@UpdateValue = InvoiceNumber,
			@PurchaseOrderKey = PurchaseOrderKey
		FROM
			@ClientInvoices
		WHERE
			Inserted = 0
		ORDER BY
			InvoiceBuyKey
	END

--Set VendorInvoices string
SELECT TOP 1
	@UpdateKey = InvoiceBuyKey,
	@UpdateValue = InvoiceNumber,
	@PurchaseOrderKey = PurchaseOrderKey
FROM
	@VendorInvoices
WHERE
	Inserted = 0
ORDER BY
	InvoiceBuyKey

WHILE @UpdateKey IS NOT NULL
	BEGIN
		UPDATE @Buys
		SET VendorInvoices = ISNULL(VendorInvoices, '') + CASE LEN(ISNULL(VendorInvoices, '')) WHEN 0 THEN '' ELSE ', ' END + @UpdateValue
		WHERE PurchaseOrderKey = @PurchaseOrderKey
		
		UPDATE @VendorInvoices
		SET Inserted = 1
		WHERE InvoiceBuyKey = @UpdateKey

		SELECT @UpdateKey = NULL
		SELECT TOP 1
			@UpdateKey = InvoiceBuyKey,
			@UpdateValue = InvoiceNumber,
			@PurchaseOrderKey = PurchaseOrderKey
		FROM
			@VendorInvoices
		WHERE
			Inserted = 0
		ORDER BY
			InvoiceBuyKey
	END

--Set Taxes string
SELECT TOP 1
	@UpdateKey = SalesTaxBuyKey,
	@UpdateValue = SalesTaxID,
	@PurchaseOrderKey = PurchaseOrderKey
FROM
	@Taxes
WHERE
	Inserted = 0
ORDER BY
	SalesTaxBuyKey

WHILE @UpdateKey IS NOT NULL
	BEGIN
		UPDATE @Buys
		SET Taxes = ISNULL(Taxes, '') + CASE LEN(ISNULL(Taxes, '')) WHEN 0 THEN '' ELSE ', ' END + @UpdateValue
		WHERE PurchaseOrderKey = @PurchaseOrderKey
		
		UPDATE @Taxes
		SET Inserted = 1
		WHERE SalesTaxBuyKey = @UpdateKey

		SELECT @UpdateKey = NULL
		SELECT TOP 1
			@UpdateKey = SalesTaxBuyKey,
			@UpdateValue = SalesTaxID,
			@PurchaseOrderKey = PurchaseOrderKey
		FROM
			@Taxes
		WHERE
			Inserted = 0
		ORDER BY
			SalesTaxBuyKey
	END

SELECT
	ws.*,
	ws.WorksheetID + ' - ' + ws.WorksheetName AS Worksheet,
	ws.StartDate AS WorksheetStartDate,
	ws.EndDate As WorksheetEndDate,
	mk.MarketID + ' - ' + mk.MarketName AS Market,
	po.*,
	pod.ShortDescription AS AdCaption,
	pod.DetailOrderDate AS IssueDate,
	pod.UserDate1 AS UserDate1_,
	pod.UserDate2 AS UserDate2_,
	
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

	g.SalesTaxAmount as Tax,

	CASE @CostBase WHEN 1 THEN g.GrossAmount + g.SalesTaxAmount WHEN 2 THEN g.TotalCost + g.SalesTaxAmount ELSE
		CASE po.BillingBase
			WHEN 1 THEN --Gross Plus
				CASE po.BillingAdjBase
					WHEN 1 THEN --Net
						g.GrossAmount + ((po.BillingAdjPercent * 0.01) * g.TotalCost) + g.SalesTaxAmount
					WHEN 2 THEN --Gross 
						g.GrossAmount + ((po.BillingAdjPercent * 0.01) * g.GrossAmount) + g.SalesTaxAmount
				END
			WHEN 2 THEN --Gross Minus
				CASE po.BillingAdjBase
					WHEN 1 THEN --Net
						g.GrossAmount - ((po.BillingAdjPercent * 0.01) * g.TotalCost) + g.SalesTaxAmount
					WHEN 2 THEN --Gross
						g.GrossAmount - ((po.BillingAdjPercent * 0.01) * g.GrossAmount) + g.SalesTaxAmount
				END
			WHEN 3 THEN --Net Plus
				CASE po.BillingAdjBase
					WHEN 1 THEN --Net
						g.TotalCost + ((po.BillingAdjPercent * 0.01) * g.TotalCost) + g.SalesTaxAmount
					WHEN 2 THEN --Gross
						g.TotalCost + ((po.BillingAdjPercent * 0.01) * g.GrossAmount) + g.SalesTaxAmount
				END
			WHEN 4 THEN --Net Minus
				CASE po.BillingAdjBase
					WHEN 1 THEN --Net
						g.TotalCost - ((po.BillingAdjPercent * 0.01) * g.TotalCost) + g.SalesTaxAmount
					WHEN 2 THEN --Gross
						g.TotalCost - ((po.BillingAdjPercent * 0.01) * g.GrossAmount) + g.SalesTaxAmount
				END
		END
	END AS CostAndTax,

	cm.StationID + ' - ' + cm.Name AS Publication,
	cm.Name as PublicationName,
	cm.StationID AS PublicationID,
	cm.Circulation,
	cm.Frequency AS PublicationFrequency,
	cl.CompanyName AS ClientName,
	cmp.CampaignName,
	cmp.CampaignID + ' - ' + cmp.CampaignName AS Campaign,
	ISNULL(cprod.ProductName, cprodp.ProductName) AS ProductName,
	p.ProjectNumber + ' - ' + p.ProjectName AS Project,
	p.ProjectNumber,
	p.ProjectName,
	p.StartDate AS ProjectStartDate,
	p.CompleteDate AS ProjectEndDate,
	ISNULL(mp.PositionID, ISNULL(po.MediaPrintPositionID, '')) AS Position,
	mp.PositionName,
	ISNULL(ms.SpaceName, ISNULL(po.MediaPrintSpaceID, '')) AS Space,
	b.Premiums,
	b.ClientInvoices,
	b.VendorInvoices,
	b.Taxes
FROM
	tMediaWorksheet ws (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON ws.MediaWorksheetKey = po.MediaWorksheetKey
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.LineType = 'order' AND pod.LineNumber = 1
	INNER JOIN (SELECT PurchaseOrderKey
		, SUM(GrossAmount) AS GrossAmount
		, SUM(TotalCost) AS TotalCost
		, SUM(SalesTaxAmount) AS SalesTaxAmount 
		FROM tPurchaseOrderDetail (nolock)
		WHERE isnull(tPurchaseOrderDetail.Cancelled, 0) = 0 
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
ORDER BY
	cm.Name
GO
