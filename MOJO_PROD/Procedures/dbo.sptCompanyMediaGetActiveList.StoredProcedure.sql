USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaGetActiveList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaGetActiveList]
	@CompanyKey int,
	@MediaType smallint

AS

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
	MediaKind = @MediaType and cm.CompanyKey = @CompanyKey and cm.Active = 1

	RETURN 1
GO
