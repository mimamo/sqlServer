USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaRevisionReasonUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaRevisionReasonUpdate]
	@MediaRevisionReasonKey int,
	@CompanyKey int,
	@ReasonID varchar(6),
	@Description varchar(100),
	@Active smallint

AS -- Encrypt

/*
|| When      Who Rel      What
|| 09/01/09  MAS 10.5.0.8 Added insert logic
*/

IF EXISTS (SELECT 1
			FROM tMediaRevisionReason (NOLOCK)
			WHERE CompanyKey = @CompanyKey
			AND   ReasonID = @ReasonID
			AND   MediaRevisionReasonKey <> @MediaRevisionReasonKey)
		RETURN -1

IF @MediaRevisionReasonKey <= 0 
	BEGIN
		IF @Active IS NULL
			SELECT @Active = 1

		INSERT tMediaRevisionReason
			(
			CompanyKey,
			ReasonID,
			Description,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ReasonID,
			@Description,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN				
		UPDATE
			tMediaRevisionReason
		SET
			CompanyKey = @CompanyKey,
			ReasonID = @ReasonID,
			Description = @Description,
			Active = @Active
		WHERE
			MediaRevisionReasonKey = @MediaRevisionReasonKey 

		RETURN @MediaRevisionReasonKey
	END
GO
