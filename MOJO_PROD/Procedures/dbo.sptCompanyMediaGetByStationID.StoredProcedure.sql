USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaGetByStationID]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaGetByStationID]
	@StationID varchar(50),
	@MediaKind smallint, 
	@CompanyKey int

AS --Encrypt

SELECT 
	 cm.*	
	,c.CompanyName
	,c.VendorID
	,mm.MarketName
	,mm.MarketID
	,i.ItemID
	,i.ItemName
FROM 	
	tCompanyMedia cm (nolock)
	INNER JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
	left outer join tMediaMarket mm (nolock) ON cm.MediaMarketKey = mm.MediaMarketKey 	
	left outer join tItem i (nolock) on cm.ItemKey = i.ItemKey	
WHERE
	cm.StationID = @StationID AND cm.CompanyKey = @CompanyKey and cm.MediaKind = @MediaKind

	RETURN 1
GO
