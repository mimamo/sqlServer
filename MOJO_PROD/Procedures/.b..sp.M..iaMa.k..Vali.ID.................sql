USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketValidID]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptMediaMarketValidID]

	(
		@CompanyKey int,
		@MarketID varchar(50)
	)

AS --Encrypt

Declare @MediaMarketKey int

Select @MediaMarketKey = MediaMarketKey
From tMediaMarket (nolock)
Where
	CompanyKey = @CompanyKey and
	MarketID = @MarketID
	
	
Return ISNULL(@MediaMarketKey, 0)
GO
