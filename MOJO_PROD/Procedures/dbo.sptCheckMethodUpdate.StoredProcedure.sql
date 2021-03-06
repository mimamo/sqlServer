USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckMethodUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckMethodUpdate]
	@CheckMethodKey int,
	@CompanyKey int,
	@CheckMethod varchar(100),
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 09/01/09  MAS 10.5.0.8 Added insert logic
*/

IF @CheckMethodKey <= 0
	BEGIN
		INSERT tCheckMethod
			(
			CompanyKey,
			CheckMethod,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@CheckMethod,
			@Active
			)
		
		RETURN @@IDENTITY	
	END
ELSE
	BEGIN
		UPDATE
			tCheckMethod
		SET
			CompanyKey = @CompanyKey,
			CheckMethod = @CheckMethod,
			Active = @Active
		WHERE
			CheckMethodKey = @CheckMethodKey 

		RETURN @CheckMethodKey
	END
GO
