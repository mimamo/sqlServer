USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyInsert]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyInsert]
	@CompanyKey int,
	@GLCompanyID varchar(50),
	@GLCompanyName varchar(500),
	@Active tinyint,
	@AddressKey int,
	@PrintedName varchar(500),
	@WebSite varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@EINNumber varchar(30),
	@StateEINNumber varchar(30),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/27/08  GHL 10.011 (34982) Added EINNumber, etc.. for 1099 purpose.
*/

	If exists (Select 1 from tGLCompany (nolock) where GLCompanyID = @GLCompanyID and CompanyKey = @CompanyKey)
	RETURN - 1
	
	INSERT tGLCompany
		(
		CompanyKey,
		GLCompanyID,
		GLCompanyName,
		Active,
		AddressKey,
		PrintedName,
		WebSite,
		Phone,
		Fax,
		EINNumber,
		StateEINNumber
		)

	VALUES
		(
		@CompanyKey,
		@GLCompanyID,
		@GLCompanyName,
		@Active,
		@AddressKey,
		@PrintedName,
		@WebSite,
		@Phone,
		@Fax,
		@EINNumber,
		@StateEINNumber
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
