USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContactInsert]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContactInsert]
	@CompanyMediaKey int,
	@UserKey int
AS --Encrypt

	INSERT tCompanyMediaContact
		(
		CompanyMediaKey,
		UserKey
		)

	VALUES
		(
		@CompanyMediaKey,
		@UserKey
		)
	
	RETURN 1
GO
