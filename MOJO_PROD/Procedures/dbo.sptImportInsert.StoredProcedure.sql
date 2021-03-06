USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptImportInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptImportInsert]
	@CompanyKey int,
	@UserKey int,
	@ImportType int,
	@Delimiter smallint,
	@TextQualifier smallint,
	@FileName as varchar(300),
	@OriginalFileName as varchar(300)
AS --Encrypt

	INSERT tImport
		(
		CompanyKey,
		UserKey,
		ImportType,
		Delimiter,
		TextQualifier,
		FileName,
		OriginalFileName,
		DateAdded
		)

	VALUES
		(
		@CompanyKey,
		@UserKey,
		@ImportType,
		@Delimiter,
		@TextQualifier,
		@FileName,
		@OriginalFileName,
		GETDATE()
		)
	

	RETURN 1
GO
