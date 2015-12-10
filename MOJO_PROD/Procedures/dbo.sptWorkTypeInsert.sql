USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeInsert]
	@CompanyKey int,
	@WorkTypeID varchar(100),
	@WorkTypeName varchar(200),
	@Description varchar(500),
	@StandardPrice money,
	@GLAccountKey int,
	@ClassKey int,
	@Active tinyint,
	@Taxable tinyint = 0,
	@Taxable2 tinyint = 0,	
	@DepartmentKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 04/25/07 GHL 8.5  Added Taxable fields. Enh 7150
|| 09/15/09 GHL 10.510  (61782) Added DepartmentKey
*/

	if exists(select 1 from tWorkType (NOLOCK) where WorkTypeID = @WorkTypeID and CompanyKey = @CompanyKey)
		return -1

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
		DepartmentKey
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
		@DepartmentKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
