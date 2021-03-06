USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherRecalcSalesTax]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherRecalcSalesTax]
	@VoucherKey int
	,@SalesTax1Amount MONEY OUTPUT
	,@SalesTax2Amount MONEY OUTPUT
	
AS --Encrypt


Declare	 @SalesTax1Key int
		,@SalesTax1Rate DECIMAL(24,4)
	    ,@SalesTax1PiggyBack tinyint
	    ,@SalesTax2Key int
	    ,@SalesTax2Rate DECIMAL(24,4)
	    ,@SalesTax2PiggyBack tinyint

SELECT	@SalesTax1Amount = 0
	   ,@SalesTax2Amount = 0
		
-- Get voucher info		
Select  @SalesTax1Key	= SalesTaxKey
		,@SalesTax2Key	= SalesTax2Key
from tVoucher (nolock) 
Where VoucherKey = @VoucherKey
	
	
if ISNULL(@SalesTax1Key, 0) = 0
	Select @SalesTax1Rate = 0
else
	Select @SalesTax1Rate = TaxRate, @SalesTax1PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) 
	Where SalesTaxKey = @SalesTax1Key
	
if ISNULL(@SalesTax2Key, 0) = 0
	Select @SalesTax2Rate = 0
else
	Select @SalesTax2Rate = TaxRate, @SalesTax2PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) 
	Where SalesTaxKey = @SalesTax2Key
			
IF @SalesTax1Rate = 0 AND @SalesTax2Rate = 0	
	RETURN 1

IF @SalesTax1Rate = 0 
	BEGIN
		SELECT @SalesTax1Amount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
		BEGIN			
			SELECT @SalesTax1Amount = SUM(ISNULL(vd.TotalCost, 0) * ISNULL(vd.Taxable, 0) * @SalesTax1Rate / 100)
			FROM   tVoucherDetail vd (NOLOCK)
			WHERE  vd.VoucherKey = @VoucherKey				
		END
		ELSE
		BEGIN
			SELECT @SalesTax1Amount = SUM(
			(ISNULL(vd.TotalCost, 0) 
			+ (ISNULL(vd.TotalCost, 0) * ISNULL(vd.Taxable2, 0) * @SalesTax2Rate / 100)
			)
				* ISNULL(vd.Taxable, 0) * @SalesTax1Rate / 100)
			FROM   tVoucherDetail vd (NOLOCK)
			WHERE  vd.VoucherKey = @VoucherKey						
		END
	END

IF @SalesTax2Rate = 0 
	BEGIN
		SELECT @SalesTax2Amount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
		BEGIN
			SELECT @SalesTax2Amount = SUM(ISNULL(vd.TotalCost, 0) * ISNULL(vd.Taxable2, 0) * @SalesTax2Rate / 100)
			FROM   tVoucherDetail vd (NOLOCK)
			WHERE  vd.VoucherKey = @VoucherKey							
		END
		ELSE
		BEGIN
			SELECT @SalesTax2Amount = SUM(
			(ISNULL(vd.TotalCost, 0) 
			+ (ISNULL(vd.TotalCost, 0) * ISNULL(vd.Taxable, 0) * @SalesTax1Rate / 100)
			)	* ISNULL(vd.Taxable2, 0) * @SalesTax2Rate / 100)
			FROM   tVoucherDetail vd (NOLOCK)
			WHERE  vd.VoucherKey = @VoucherKey								
		END
	END

SELECT @SalesTax1Amount = ISNULL(@SalesTax1Amount, 0)
      ,@SalesTax2Amount = ISNULL(@SalesTax2Amount, 0)  

SELECT @SalesTax1Amount = ROUND(@SalesTax1Amount, 2)
      ,@SalesTax2Amount = ROUND(@SalesTax2Amount, 2)  

RETURN 1
GO
