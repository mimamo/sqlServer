USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextUpdate]
	@StandardTextKey int,
	@CompanyKey int,
	@Type varchar(20),
	@TextName varchar(100),
	@StandardText text,
	@Active tinyint

AS --Encrypt

/*
|| When      Who Rel      What
|| 09/04/09  MAS 10.5.0.9 Added insert logic

*/
IF @StandardTextKey <= 0 
	BEGIN
		INSERT tStandardText
			(
			CompanyKey,
			Type,
			TextName,
			StandardText,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@Type,
			@TextName,
			@StandardText,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tStandardText
		SET
			CompanyKey = @CompanyKey,
			Type = @Type,
			TextName = @TextName,
			StandardText = @StandardText,
			Active = @Active
		WHERE
			StandardTextKey = @StandardTextKey 

		RETURN @StandardTextKey
	END
GO
