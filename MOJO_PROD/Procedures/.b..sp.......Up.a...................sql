USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceUpdate]
	@SourceKey int,
	@CompanyKey int,
	@SourceName varchar(200),
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 09/01/09  MAS 10.5.0.8 Added insert logic
*/


IF @SourceKey <= 0
	BEGIN
		INSERT tSource
			(
			CompanyKey,
			SourceName,
			Active,
			LastModified
			)

		VALUES
			(
			@CompanyKey,
			@SourceName,
			@Active,
			GetDate()
			)
		
		RETURN @@IDENTITY		
	END
ELSE
	BEGIN
		UPDATE
			tSource
		SET
			CompanyKey = @CompanyKey,
			SourceName = @SourceName,
			Active = @Active,
			LastModified = GetDate()
		WHERE
			SourceKey = @SourceKey 

		RETURN @SourceKey
	END
GO
