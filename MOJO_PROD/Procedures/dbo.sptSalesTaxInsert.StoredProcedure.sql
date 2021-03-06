USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSalesTaxInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSalesTaxInsert]
	@CompanyKey int,
	@SalesTaxID varchar(100),
	@SalesTaxName varchar(100),
	@Description varchar(300),
	@PayTo int,
	@PayableGLAccountKey int,
	@APPayableGLAccountKey int,
	@TaxRate decimal(24,4),
	@Active int,
	@PiggyBackTax tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/17/07 GHL 8.4.2 Added checking of unique task ids          
  */

	IF EXISTS (SELECT 1
			   FROM   tSalesTax (NOLOCK)
			   WHERE  CompanyKey = @CompanyKey
			   AND    SalesTaxID = @SalesTaxID
			   )
			   RETURN -1
			    
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
		Active,
		PiggyBackTax
		)

	VALUES
		(
		@CompanyKey,
		@SalesTaxID,
		@SalesTaxName,
		@Description,
		@PayTo,
		@PayableGLAccountKey,
		@APPayableGLAccountKey,
		@TaxRate,
		@Active,
		@PiggyBackTax
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
