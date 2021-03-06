USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPositionUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPositionUpdate]
	@MediaPositionKey int,
	@CompanyKey int,
	@PositionID varchar(50),
	@PositionName varchar(500),
	@PositionShortName varchar(50),
	@Description varchar(MAX), 
	@DisplayOrder tinyint,
	@POKind smallint,
	@ItemKey int,
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
*/

if exists(Select 1 from tMediaPosition (nolock) 
		  Where CompanyKey = @CompanyKey 
		  AND PositionID = @PositionID 
		  AND ISNULL(ItemKey, 0) = ISNULL(@ItemKey, 0)
		  AND MediaPositionKey <> @MediaPositionKey)
	Return -1

IF 	@MediaPositionKey <= 0
	BEGIN
		INSERT tMediaPosition
			(
			CompanyKey,
			PositionID,
			PositionName,
			PositionShortName,
			Description,
			POKind,
			ItemKey,
			DisplayOrder,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@PositionID,
			@PositionName,
			@PositionShortName,
			@Description,
			@POKind,
			@ItemKey,
			@DisplayOrder,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaPosition
		SET
			PositionID = @PositionID,
			PositionName = @PositionName,
			PositionShortName = @PositionShortName,
			Description = @Description,
			POKind = @POKind,
			ItemKey = @ItemKey,
			DisplayOrder = @DisplayOrder,
			Active = @Active
		WHERE
			MediaPositionKey = @MediaPositionKey 

		RETURN @MediaPositionKey
	END
GO
