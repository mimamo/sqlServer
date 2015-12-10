USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeInsert]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeInsert]
	@CompanyKey int,
	@CompanyTypeName varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tCompanyType
		(
		CompanyKey,
		CompanyTypeName
		)

	VALUES
		(
		@CompanyKey,
		@CompanyTypeName
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
