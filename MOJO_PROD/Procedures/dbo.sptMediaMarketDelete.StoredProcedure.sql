USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketDelete]
	@MediaMarketKey int

AS --Encrypt

if exists(Select 1 from tCompanyMedia (nolock) Where MediaMarketKey = @MediaMarketKey)
	return -1
	
	
	DELETE
	FROM tMediaMarket
	WHERE
		MediaMarketKey = @MediaMarketKey 

	RETURN 1
GO
