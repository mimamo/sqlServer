USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetGetExport]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetGetExport]
	@CompanyKey int
AS

/*
|| When     Who Rel      What
|| 01/24/12 MFT 10.5.5.2 Created
*/ 

SELECT
	rs.RateSheetName,
	rs.Active,
	i.ItemID,
	ISNULL(rsd.Markup, ISNULL(i.Markup, 0)) AS Markup,
	CASE i.UseUnitRate WHEN 1 THEN ISNULL(rsd.UnitRate, i.UnitRate) ELSE ISNULL(i.UnitRate, 0) END AS UnitRate
FROM
	tItemRateSheet rs (nolock)
	LEFT JOIN tItemRateSheetDetail rsd (nolock) ON rs.ItemRateSheetKey = rsd.ItemRateSheetKey
	LEFT JOIN tItem i (nolock) ON rsd.ItemKey = i.ItemKey
WHERE
	rs.CompanyKey = @CompanyKey
GO
