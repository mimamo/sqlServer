USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetUpdate]
	@ColumnSetKey int = NULL,
	@CompanyKey int,
	@SetName varchar(500)

AS --Encrypt

/*
|| When     Who Rel    What
|| 09/28/12 MFT 10.560 Created
*/

IF ISNULL(@ColumnSetKey, 0) = 0
	BEGIN
		INSERT INTO
			tColumnSet
			(
				CompanyKey,
				SetName
			)
		VALUES
			(
				@CompanyKey,
				@SetName
			)
		
		SELECT @ColumnSetKey = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		UPDATE
			tColumnSet
		SET
			SetName = @SetName
		WHERE
			ColumnSetKey = @ColumnSetKey
	END

RETURN @ColumnSetKey
GO
