USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileUpdate]
	@FlatFileKey int = NULL,
	@Type tinyint,
	@LayoutName varchar(100),
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
*/

IF ISNULL(@FlatFileKey, 0) = 0
	BEGIN
		INSERT INTO
			tFlatFile
			(
				Type,
				LayoutName,
				CompanyKey
			)
		VALUES
			(
				@Type,
				@LayoutName,
				@CompanyKey
			)
		
		SELECT @FlatFileKey = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		UPDATE
			tFlatFile
		SET
			LayoutName = @LayoutName
		WHERE
			FlatFileKey = @FlatFileKey
	END

RETURN @FlatFileKey
GO
