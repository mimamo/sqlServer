USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportWorkType]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportWorkType]
	@CompanyKey int,
	@WorkTypeID varchar(100),
	@WorkTypeName varchar(200),
	@Description varchar(500),
	@StandardPrice money,
	@GLAccount varchar(100),
	@ClassID varchar(100)
AS --Encrypt

	if exists(select 1 from tWorkType (nolock) where WorkTypeID = @WorkTypeID and CompanyKey = @CompanyKey)
		return -1

Declare @GLAccountKey int, @ClassKey int

Select @GLAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @GLAccount and CompanyKey = @CompanyKey
Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
	return -2
	
	INSERT tWorkType
		(
		CompanyKey,
		WorkTypeID,
		WorkTypeName,
		Description,
		StandardPrice,
		GLAccountKey,
		ClassKey
		)

	VALUES
		(
		@CompanyKey,
		@WorkTypeID,
		@WorkTypeName,
		@Description,
		@StandardPrice,
		@GLAccountKey,
		@ClassKey
		)

	RETURN 1
GO
