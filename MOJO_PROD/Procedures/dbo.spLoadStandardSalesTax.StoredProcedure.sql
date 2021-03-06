USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardSalesTax]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardSalesTax]
	@CompanyKey int,
	@SalesTaxID varchar(100),
	@SalesTaxName varchar(100),
	@Description varchar(300),
	@PayTo varchar(50),
	@PayableGLAccount varchar(100),
	@APPayableGLAccount varchar(100),
	@TaxRate decimal(24,4),
	@Active int
AS --Encrypt

/*
|| When     Who Rel  What
|| 10/13/09 GHL 10.512 (65248) Clone of spImport sp for load standard
*/


Declare @PayableGLAccountKey int
Declare @APPayableGLAccountKey int
Declare @PayToKey int

if exists(select 1 from tSalesTax (nolock) where CompanyKey = @CompanyKey and SalesTaxID = @SalesTaxID)
	return -1

select @PayableGLAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountNumber = @PayableGLAccount
select @APPayableGLAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountNumber = @APPayableGLAccount
select @PayToKey = CompanyKey from tCompany (nolock) where OwnerCompanyKey = @CompanyKey and VendorID = @PayTo

	IF @Active IS NULL
		SELECT @Active = 1

	INSERT tSalesTax
		(
		CompanyKey,
		SalesTaxID,
		SalesTaxName,
		Description,
		PayTo,
		PayableGLAccountKey,
		APPayableGLAccountKey,
		TaxRate,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@SalesTaxID,
		@SalesTaxName,
		@Description,
		@PayToKey,
		@PayableGLAccountKey,
		@APPayableGLAccountKey,
		@TaxRate,
		ISNULL(@Active, 1)
		)
	

	RETURN 1
GO
