USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketGetLookupList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketGetLookupList]

	@CompanyKey int,
	@SearchValue varchar(250),
	@POKind int,
	@ItemKey int = null

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/26/14 PLC 10.576  Added @POKind and @ItemKey
|| 01/27/14 GHL 10.576  Fixed query
|| 03/18/14 PLC 10.577  Removed ItemKey
|| 03/19/14   PLC added item key back in temp
*/

		SELECT m.*
		FROM tMediaMarket m (nolock)
		WHERE
			m.CompanyKey = @CompanyKey and
			Active = 1 and 
			(@POKind is null Or POKind = @POKind) and
			(MarketID like @SearchValue + '%' or MarketName like @SearchValue + '%')

		
		Order By m.MarketName
		

	RETURN 1
GO
