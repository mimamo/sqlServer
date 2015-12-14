USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractGet]
	@CompanyMediaContractKey int,
	@CompanyMediaKey int = NULL

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/17/13 MFT 10.569  Created
|| 06/27/13 MFT 10.569  Added MediaUnitType
|| 08/27/13 MFT 10.571  Added @CompanyMediaKey param, ItemKey and gets for Spaces & Positions lists
|| 11/04/13 MFT 10.574  Added subquery for QtyUn/Approved AmtUn/Approved
|| 03/04/14 GHL 10.577  Added isnull when comparing MediaSpaceKey and MediaPositionKey to fix join with BuyTotals
*/

/*
	The CompanyMediaKey is passed into the Contract
	form in addMode; Passing it as a param makes it
	possible to return init data to the form when
	CompanyMediaContractKey = 0
*/
SELECT
	cc.*,
	cm.StationID,
	cm.Name AS CompanyMediaName,
	cm.MediaKind,
	mu.UnitTypeID,
	mu.UnitTypeName,
	(SELECT ItemKey FROM tCompanyMedia (nolock) WHERE CompanyMediaKey =  ISNULL(cm.CompanyMediaKey, @CompanyMediaKey)) AS ItemKey
FROM
	tCompanyMediaContract cc (nolock)
	INNER JOIN tCompanyMedia cm (nolock) ON cc.CompanyMediaKey = cm.CompanyMediaKey
	LEFT JOIN tMediaUnitType mu (nolock) ON cc.MediaUnitTypeKey = mu.MediaUnitTypeKey
WHERE CompanyMediaContractKey = @CompanyMediaContractKey

SELECT
	ccd.*,
	ISNULL(cc.CompanyMediaKey, @CompanyMediaKey) AS CompanyMediaKey,
	ms.SpaceID,
	ms.SpaceName,
	ms.SpaceShortName,
	mp.PositionID,
	mp.PositionName,
	mp.PositionShortName,
	ISNULL(BuyTotals.QtyApproved, 0) AS QtyApproved,
	ISNULL(BuyTotals.QtyUnapproved, 0) AS QtyUnapproved,
	ISNULL(BuyTotals.QtyApproved, 0) + ISNULL(BuyTotals.QtyUnapproved, 0) AS QtyTotal,
	CASE cc.CostBase WHEN 1 THEN ISNULL(BuyTotals.AmtApprovedGross, 0) ELSE ISNULL(BuyTotals.AmtApprovedNet, 0) END AS AmtApproved,
	CASE cc.CostBase WHEN 1 THEN ISNULL(BuyTotals.AmtUnapprovedGross, 0) ELSE ISNULL(BuyTotals.AmtUnapprovedNet, 0) END AS AmtUnapproved,
	CASE cc.CostBase WHEN 1 THEN ISNULL(BuyTotals.AmtApprovedGross, 0) + ISNULL(BuyTotals.AmtUnapprovedGross, 0) ELSE ISNULL(BuyTotals.AmtApprovedNet, 0) + ISNULL(BuyTotals.AmtUnapprovedNet, 0) END AS AmtTotal
FROM
	tCompanyMediaContract cc (nolock)
	INNER JOIN tCompanyMediaContractDetail ccd (nolock) ON cc.CompanyMediaContractKey = ccd.CompanyMediaContractKey
	LEFT JOIN tMediaSpace ms (nolock) ON ccd.MediaSpaceKey = ms.MediaSpaceKey
	LEFT JOIN tMediaPosition mp (nolock) ON ccd.MediaPositionKey = mp.MediaPositionKey
	LEFT JOIN
	(
		SELECT
			SUM(QtyApproved) AS QtyApproved,
			SUM(QtyUnapproved) AS QtyUnapproved,
			MediaPrintPositionKey,
			MediaPrintSpaceKey,
			SUM(AmtApprovedGross) AS AmtApprovedGross,
			SUM(AmtUnapprovedGross) AS AmtUnapprovedGross,
			SUM(AmtApprovedNet) AS AmtApprovedNet,
			SUM(AmtUnapprovedNet) AS AmtUnapprovedNet
		FROM
			(
				SELECT
					CASE Status WHEN 4 THEN SUM(Quantity) ELSE 0 END AS QtyApproved,
					CASE WHEN Status < 4 THEN SUM(Quantity) ELSE 0 END AS QtyUnapproved,
					CASE Status WHEN 4 THEN SUM(GrossAmount) ELSE 0 END AS AmtApprovedGross,
					CASE WHEN Status < 4 THEN SUM(GrossAmount) ELSE 0 END AS AmtUnapprovedGross,
					CASE Status WHEN 4 THEN SUM(TotalCost) ELSE 0 END AS AmtApprovedNet,
					CASE WHEN Status < 4 THEN SUM(TotalCost) ELSE 0 END AS AmtUnapprovedNet,
					ISNULL(MediaPrintPositionKey, 0) AS MediaPrintPositionKey,
					ISNULL(MediaPrintSpaceKey, 0) AS MediaPrintSpaceKey
				FROM
					tPurchaseOrder po (nolock)
					INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
				WHERE
					CompanyMediaPrintContractKey = @CompanyMediaContractKey
				GROUP BY
					Status,
					MediaPrintPositionKey,
					MediaPrintSpaceKey
			) a
		GROUP BY
			MediaPrintPositionKey,
			MediaPrintSpaceKey
	) BuyTotals ON isnull(ccd.MediaSpaceKey, 0) = BuyTotals.MediaPrintSpaceKey 
		AND isnull(ccd.MediaPositionKey, 0) = BuyTotals.MediaPrintPositionKey
WHERE cc.CompanyMediaContractKey = @CompanyMediaContractKey

SELECT
	MediaSpaceKey
FROM
	tCompanyMediaSpace (nolock)
WHERE
	CompanyMediaKey = ISNULL(@CompanyMediaKey, 0)

SELECT
	MediaPositionKey
FROM
	tCompanyMediaPosition (nolock)
WHERE
	CompanyMediaKey = ISNULL(@CompanyMediaKey, 0)
GO
