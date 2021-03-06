USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyUpdate]
	@CompanyKey int,
	@GLCompanyKey int,
	@GLCompanyID varchar(50),
	@GLCompanyName varchar(500),
	@Active tinyint,
	@AddressKey int,@PrintedName varchar(500),
	@WebSite varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@EINNumber varchar(30),
	@StateEINNumber varchar(30),
	@BankAccountKey int = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/27/08  GHL 10.011 (34982) Added EINNumber, etc.. for 1099 purpose.
|| 3/01/10   RLB 10.519  Added insert logic
|| 06/03/11  GHL 10.455  Added Bank Account parameter 
*/


if @GLCompanyKey > 0
BEGIN
	If exists (Select 1 from tGLCompany (nolock) where GLCompanyID = @GLCompanyID and GLCompanyKey <> @GLCompanyKey)
	RETURN - 1

	UPDATE
		tGLCompany
	SET
		GLCompanyID = @GLCompanyID,
		GLCompanyName = @GLCompanyName,
		Active = @Active,
		AddressKey = @AddressKey,
		PrintedName = @PrintedName,
		WebSite = @WebSite,
		Phone = @Phone,
		Fax = @Fax,
		EINNumber = @EINNumber,
		StateEINNumber = @StateEINNumber,
		BankAccountKey = @BankAccountKey
	WHERE
		GLCompanyKey = @GLCompanyKey 

	RETURN @GLCompanyKey
END
ELSE
BEGIN

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
		StateEINNumber,
		BankAccountKey
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
		@StateEINNumber,
		@BankAccountKey
		)

	RETURN @@IDENTITY
End
GO
