USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketGet]
	@MediaMarketKey int

AS --Encrypt

		SELECT *
		FROM tMediaMarket (nolock)
		WHERE
			MediaMarketKey = @MediaMarketKey

	RETURN 1
GO
