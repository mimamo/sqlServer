USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketUpdate]
	@MediaMarketKey int,
	@CompanyKey int,
	@POKind smallint,
	@MarketID varchar(50),
	@MarketName varchar(200),
	@Active tinyint,
	@Rank int 

AS --Encrypt
/*
|| When      Who Rel      What
|| 09/01/09  MAS 10.5.0.8 Added insert logic
|| 01/24/14  PLC 10.576   Added ItemKey
|| 02/21/14  PLC 10.577   Removed ItemKey and added BroadcastType
|| 02/21/14  PLC 10.577   Removed BroadcastType
*/

if exists(Select 1 from tMediaMarket (nolock) 
Where CompanyKey = @CompanyKey 
and MarketID = @MarketID 
and POKind = @POKind
and MediaMarketKey <> @MediaMarketKey)
	Return -1

IF 	@MediaMarketKey <= 0
	BEGIN
		INSERT tMediaMarket
			(
			CompanyKey,
			POKind,
			MarketID,
			MarketName,
			Active,
			Rank
			)

		VALUES
			(
			@CompanyKey,
			@POKind,
			@MarketID,
			@MarketName,
			@Active,
			@Rank
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaMarket
		SET
			CompanyKey = @CompanyKey,
			MarketID = @MarketID,
			MarketName = @MarketName,
			Active = @Active,
			Rank = @Rank
		WHERE
			MediaMarketKey = @MediaMarketKey 

		RETURN @MediaMarketKey
	END
GO
