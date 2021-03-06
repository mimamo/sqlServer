USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetDetailGetCompanyList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetDetailGetCompanyList]
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 09/11/07 CRG 8.5   (9833)Created to load all of the rate sheets for a company when the Flash screen is loaded.
*/

SELECT	rsd.*
FROM	tItemRateSheetDetail rsd (nolock)
INNER JOIN tItemRateSheet rs (nolock) ON rsd.ItemRateSheetKey = rs.ItemRateSheetKey
WHERE	rs.CompanyKey = @CompanyKey
GO
