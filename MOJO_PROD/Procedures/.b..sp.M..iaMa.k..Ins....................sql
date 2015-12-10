USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaMarketInsert]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaMarketInsert]
	@CompanyKey int,
	@MarketID varchar(50),
	@MarketName varchar(200),
	@POKind smallint,
	@Active tinyint,
	@Rank int,
	@oIdentity INT OUTPUT
AS --Encrypt
/*
|| When      Who Rel      What
|| 01/24/14  PLC 10.576   Added ItemKey
|| 02/21/14  PLC 10.577   Removed ItemKey and added BroadcastType
|| 03/05/14  PLC 10.577   Removed BroadcastType
*/
if exists(Select 1 from tMediaMarket (nolock) 
Where CompanyKey = @CompanyKey 
and MarketID = @MarketID 
and POKind = @POKind)
	Return -1
	
	INSERT tMediaMarket
		(
		CompanyKey,
		MarketID,
		MarketName,
		Active,
		Rank
		)

	VALUES
		(
		@CompanyKey,
		@MarketID,
		@MarketName,
		@Active,
		@Rank
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
