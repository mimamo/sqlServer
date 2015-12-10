USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSalesTaxUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSalesTaxUpdate]
	@SalesTaxKey int,
	@CompanyKey int,
	@SalesTaxID varchar(100),
	@SalesTaxName varchar(100),
	@Description varchar(300),
	@PayTo int,
	@PayableGLAccountKey int,
	@APPayableGLAccountKey int,
	@TaxRate decimal(24,4),
	@Active int,
	@PiggyBackTax tinyint
AS --Encrypt

  /*
  || When     Who Rel      What
  || 04/17/07 GHL 8.4.2    Added checking of unique task ids
  || 07/29/09 MFT 10.5.0.5 Added insert logic
  */

	IF EXISTS (SELECT 1
			FROM   tSalesTax (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    SalesTaxKey <> @SalesTaxKey
			AND    SalesTaxID = @SalesTaxID
			)
			RETURN -1
	
	IF @SalesTaxKey > 0
		BEGIN
			UPDATE
				tSalesTax
			SET
				CompanyKey = @CompanyKey,
				SalesTaxID = @SalesTaxID,
				SalesTaxName = @SalesTaxName,
				Description = @Description,
				PayTo = @PayTo,
				PayableGLAccountKey = @PayableGLAccountKey,
				APPayableGLAccountKey = @APPayableGLAccountKey,
				TaxRate = @TaxRate,
				Active = @Active,
				PiggyBackTax = @PiggyBackTax
			WHERE
				SalesTaxKey = @SalesTaxKey
			
			RETURN @SalesTaxKey
		END
	ELSE
		BEGIN
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
			
			RETURN @@IDENTITY
		END
GO
