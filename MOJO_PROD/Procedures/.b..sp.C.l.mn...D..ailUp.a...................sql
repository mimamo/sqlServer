USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptColumnSetDetailUpdate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptColumnSetDetailUpdate]
	@ColumnSetDetailKey int = NULL,
	@ColumnSetKey int,
	@DisplayOrder int,
	@HeaderLabel varchar(200),
	@Source smallint,
	@Period varchar(20),
	@StartOffset int,
	@EndOffset int,
	@Calculation varchar(500),
	@YearOffset int
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/28/12 MFT 10.560 Created
*/

IF ISNULL(@ColumnSetDetailKey, 0) > 0
	BEGIN
		UPDATE
			tColumnSetDetail
		SET
			DisplayOrder = @DisplayOrder,
			HeaderLabel = @HeaderLabel,
			Source = @Source,
			Period = @Period,
			StartOffset = @StartOffset,
			EndOffset = @EndOffset,
			Calculation = @Calculation,
			YearOffset = @YearOffset
		WHERE
			ColumnSetDetailKey = @ColumnSetDetailKey
	END
ELSE
	BEGIN
		INSERT INTO
			tColumnSetDetail
			(
				ColumnSetKey,
				DisplayOrder,
				HeaderLabel,
				Source,
				Period,
				StartOffset,
				EndOffset,
				Calculation,
				YearOffset
			)
		VALUES
			(
				@ColumnSetKey,
				@DisplayOrder,
				@HeaderLabel,
				@Source,
				@Period,
				@StartOffset,
				@EndOffset,
				@Calculation,
				@YearOffset
			)
		
		SELECT @ColumnSetDetailKey = SCOPE_IDENTITY()
	END

RETURN @ColumnSetDetailKey
GO
