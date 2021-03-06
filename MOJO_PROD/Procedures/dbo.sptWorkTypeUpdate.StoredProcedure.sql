USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeUpdate]
	@WorkTypeKey int,
	@CompanyKey int,
	@WorkTypeID varchar(100),
	@WorkTypeName varchar(200),
	@Description text,
	@StandardPrice money,
	@GLAccountKey int,
	@ClassKey int,
	@Active tinyint,
	@Taxable tinyint = 0,
	@Taxable2 tinyint = 0,
	@DepartmentKey int,
	@DisplayOrder int = 0

AS --Encrypt

/*
|| When     Who Rel			What
|| 04/25/07 GHL 8.5			Added Taxable fields. Enh 7150
|| 09/01/09 MAS 10.5.0.8	Added insert logic
|| 09/15/09 GHL 10.510      (61782) Added DepartmentKey
|| 11/1/09  GWG 10.5.13     Changed Description to be a text field.
|| 04/26/10 RLB 10.521      Added Display Order 
|| 5/6/11   CRG 10.5.4.4    (110628) Added call to sptLayoutBillingInsertNewWorkType
*/

if exists(select 1 from tWorkType (NOLOCK) where WorkTypeID = @WorkTypeID and CompanyKey = @CompanyKey and WorkTypeKey <> @WorkTypeKey)
	return -1

IF @WorkTypeKey <= 0
	BEGIN
	INSERT tWorkType
			(
			CompanyKey,
			WorkTypeID,
			WorkTypeName,
			Description,
			StandardPrice,
			GLAccountKey,
			ClassKey,
			Active,
			Taxable,
			Taxable2,
			DepartmentKey,
			DisplayOrder
			)

		VALUES
			(
			@CompanyKey,
			@WorkTypeID,
			@WorkTypeName,
			@Description,
			@StandardPrice,
			@GLAccountKey,
			@ClassKey,
			@Active,
			@Taxable,
			@Taxable2,
			@DepartmentKey,
			@DisplayOrder
			)
		
		SELECT	@WorkTypeKey = @@IDENTITY

		DECLARE @RetVal int
		EXEC @RetVal = sptLayoutBillingInsertNewWorkType @WorkTypeKey

		IF @RetVal <= 0
			RETURN @RetVal
		ELSE
			RETURN @WorkTypeKey
	END
ELSE
	BEGIN
		UPDATE
			tWorkType
		SET
			CompanyKey = @CompanyKey,
			WorkTypeID = @WorkTypeID,
			WorkTypeName = @WorkTypeName,
			Description = @Description,
			StandardPrice = @StandardPrice,
			GLAccountKey = @GLAccountKey,
			ClassKey = @ClassKey,
			Active = @Active,
			Taxable = @Taxable,
			Taxable2 = @Taxable2,
			DepartmentKey = @DepartmentKey,
			DisplayOrder = @DisplayOrder		
		WHERE
			WorkTypeKey = @WorkTypeKey 

		RETURN @WorkTypeKey
	END
GO
