USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListDelete]
	@MarketingListKey int

AS --Encrypt

	DELETE
	FROM tMarketingListList
	WHERE
		MarketingListKey = @MarketingListKey 

	DELETE
	FROM tMarketingList
	WHERE
		MarketingListKey = @MarketingListKey 

	RETURN 1
GO
