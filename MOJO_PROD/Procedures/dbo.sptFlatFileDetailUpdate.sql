USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFlatFileDetailUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFlatFileDetailUpdate]
		@FlatFileDetailKey int = NULL,
		@FlatFileKey int,
		@StartIndex smallint,
		@EndIndex smallint,
		@FieldCaption varchar(100),
		@FieldValue varchar(300),
		@ValueIsFieldName tinyint,
		@VoidOverrideValue varchar(300),
		@Alignment tinyint,
		@Placeholder char(1),
		@RecordType smallint,
		@Required tinyint,
		@Format smallint,
		@GroupingFunction smallint
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/17/12 MFT 10.555 Created
|| 05/22/12 MFT 10.556 Added RecordType, Required and Format
|| 05/25/12 MFT 10.556 Added GroupingFunction
|| 07/10/12 MFT 10.558 Added VoidOverrideValue
*/

IF ISNULL(@FlatFileDetailKey, 0) > 0
	BEGIN
		UPDATE
			tFlatFileDetail
		SET
			FlatFileKey = @FlatFileKey,
			StartIndex = @StartIndex,
			EndIndex = @EndIndex,
			FieldCaption = @FieldCaption,
			FieldValue = @FieldValue,
			ValueIsFieldName = @ValueIsFieldName,
			VoidOverrideValue = @VoidOverrideValue,
			Alignment = @Alignment,
			Placeholder = @Placeholder,
			RecordType = @RecordType,
			Required = @Required,
			Format = @Format,
			GroupingFunction = @GroupingFunction
		WHERE
			FlatFileDetailKey = @FlatFileDetailKey
	END
ELSE
	BEGIN
		INSERT INTO
			tFlatFileDetail
			(
				FlatFileKey,
				StartIndex,
				EndIndex,
				FieldCaption,
				FieldValue,
				ValueIsFieldName,
				VoidOverrideValue,
				Alignment,
				Placeholder,
				RecordType,
				Required,
				Format,
				GroupingFunction
			)
			VALUES
			(
				@FlatFileKey,
				@StartIndex,
				@EndIndex,
				@FieldCaption,
				@FieldValue,
				@ValueIsFieldName,
				@VoidOverrideValue,
				@Alignment,
				@Placeholder,
				@RecordType,
				@Required,
				@Format,
				@GroupingFunction
			)
		
		SELECT @FlatFileDetailKey = SCOPE_IDENTITY()
	END
RETURN @FlatFileDetailKey
GO
