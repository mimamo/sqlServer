USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketGetList]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tMediaMarket (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By MarketName
	RETURN 1
GO
