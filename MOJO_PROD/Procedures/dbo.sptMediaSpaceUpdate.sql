USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaSpaceUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaSpaceUpdate]
	@MediaSpaceKey int,
	@CompanyKey int,
	@SpaceID varchar(50),
	@SpaceName varchar(500),
	@SpaceShortName varchar(50),
	@Description varchar(MAX),
	@MediaUnitTypeKey int,
	@Qty1 decimal(24, 4),
	@Qty2 decimal(24, 4),
	@Active tinyint,
	@ItemKey int,
	@POKind smallint

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
*/

if exists(Select 1 from tMediaSpace (nolock) 
		  Where CompanyKey = @CompanyKey 
		  AND SpaceID = @SpaceID		  
		  AND POKind = @POKind
		  AND ISNULL(ItemKey, 0) = ISNULL(@ItemKey, 0)
		  AND MediaSpaceKey <> @MediaSpaceKey)
	Return -1

IF 	@MediaSpaceKey <= 0
	BEGIN
		INSERT tMediaSpace
			(
			CompanyKey,
			SpaceID,
			SpaceName,
			SpaceShortName,
			Description,
			MediaUnitTypeKey,
			Qty1,
			Qty2,
			Active,
			ItemKey,
			POKind
			)

		VALUES
			(
			@CompanyKey,
			@SpaceID,
			@SpaceName,
			@SpaceShortName,
			@Description,
			@MediaUnitTypeKey,
			@Qty1,
			@Qty2,
			@Active,
			@ItemKey,
			@POKind
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaSpace
		SET
			SpaceID = @SpaceID,
			SpaceName = @SpaceName,
			SpaceShortName = @SpaceShortName,
			Description = @Description,
			MediaUnitTypeKey = @MediaUnitTypeKey,
			Qty1 = @Qty1,
			Qty2 = @Qty2,
			Active = @Active,
			ItemKey = @ItemKey,
			POKind = @POKind
		WHERE
			MediaSpaceKey = @MediaSpaceKey 

		RETURN @MediaSpaceKey
	END
GO
