USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataMediaMarketGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataMediaMarketGetList]

	@CompanyKey int


AS --Encrypt

	SELECT 
		MediaMarketKey,
		MarketID,
		MarketName,
		Active,
		ISNULL(LinkID, '0') as LinkID
	FROM 
		tMediaMarket (NOLOCK) 
	WHERE
		CompanyKey = @CompanyKey

	RETURN 1
GO
