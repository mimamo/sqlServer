USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPremiumUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPremiumUpdate]
	@MediaPremiumKey int = NULL,
	@CompanyKey int,
	@POKind smallint,
	@ItemKey int,
	@PremiumName varchar(300),
	@PremiumShortName varchar(100),
	@PremiumID varchar(50),
	@Description varchar(MAX),
	@Active tinyint

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/08/13 MFT 10.570  Created
*/

IF EXISTS(SELECT * FROM tMediaPremium (nolock) 
          WHERE PremiumID = @PremiumID 
          AND ItemKey = ISNULL(@ItemKey, 0)
          AND MediaPremiumKey <> ISNULL(@MediaPremiumKey, 0))
	RETURN -1

IF ISNULL(@MediaPremiumKey, 0) > 0
	UPDATE tMediaPremium
	SET
		POKind = @POKind,
		ItemKey = @ItemKey,
		PremiumName = @PremiumName,
		PremiumShortName = @PremiumShortName,
		PremiumID = @PremiumID,
		Description = @Description,
		Active = @Active
	WHERE
		MediaPremiumKey = @MediaPremiumKey
ELSE
	BEGIN
		INSERT INTO tMediaPremium
		(
			CompanyKey,
			POKind,
			ItemKey,
			PremiumName,
			PremiumShortName,
			PremiumID,
			Description,
			Active
		)
		VALUES
		(
			@CompanyKey,
			@POKind,
			@ItemKey,
			@PremiumName,
			@PremiumShortName,
			@PremiumID,
			@Description,
			@Active
		)
		
		SELECT @MediaPremiumKey = SCOPE_IDENTITY()
	END

RETURN @MediaPremiumKey
GO
