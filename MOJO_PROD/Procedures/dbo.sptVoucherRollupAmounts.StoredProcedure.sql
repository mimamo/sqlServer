USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherRollupAmounts]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherRollupAmounts]
	(
	@VoucherKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 10/16/09 GHL 10.512 (65742) Create tVoucherTax records even if Tax Amount = 0
  ||                             Only if there are some lines
  || 03/23/12 GHL 10.554 Added VoucherDetailKey in inserts
  */
  
	DECLARE @VoucherTotal MONEY
	        ,@SalesTaxAmount MONEY
			,@SalesTax1Amount MONEY
			,@SalesTax2Amount MONEY
	        ,@SalesTaxKey INT
	        ,@SalesTax2Key INT
	        ,@NumberLines INT
	    
	select @SalesTaxKey = SalesTaxKey
	       ,@SalesTax2Key = SalesTax2Key
	from   tVoucher (NOLOCK)
	Where VoucherKey = @VoucherKey
	               
	select @SalesTaxKey = isnull(@SalesTaxKey, 0)
	       ,@SalesTax2Key = isnull(@SalesTax2Key, 0)
	             
	select @VoucherTotal = Sum(TotalCost) 
	      ,@SalesTaxAmount = Sum(SalesTaxAmount)
	      ,@SalesTax1Amount = Sum(SalesTax1Amount)
	      ,@SalesTax2Amount = Sum(SalesTax2Amount)	      
	from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey
	
	select @VoucherTotal = ISNULL(@VoucherTotal, 0) + ISNULL(@SalesTaxAmount, 0)
	
	UPDATE tVoucher
	SET    VoucherTotal = @VoucherTotal
			,SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
			,SalesTax1Amount = ISNULL(@SalesTax1Amount, 0)
			,SalesTax2Amount = ISNULL(@SalesTax2Amount, 0)			
	WHERE  VoucherKey = @VoucherKey
	
	DELETE tVoucherTax
	WHERE  VoucherKey = @VoucherKey
	
	SELECT @NumberLines = COUNT(*)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  VoucherKey = @VoucherKey
	
	IF @SalesTaxKey > 0 AND @NumberLines > 0
	INSERT tVoucherTax (VoucherKey, VoucherDetailKey, SalesTaxKey, Type, SalesTaxAmount)
	SELECT @VoucherKey, VoucherDetailKey, @SalesTaxKey, 1, ISNULL(SalesTax1Amount,0)
	FROM   tVoucherDetail vd (NOLOCK)
	WHERE  vd.VoucherKey = @VoucherKey

	IF @SalesTax2Key > 0 AND @NumberLines > 0
	INSERT tVoucherTax (VoucherKey, VoucherDetailKey, SalesTaxKey, Type, SalesTaxAmount)
	SELECT @VoucherKey, VoucherDetailKey, @SalesTax2Key, 2, ISNULL(SalesTax2Amount,0)
	FROM   tVoucherDetail vd (NOLOCK)
	WHERE  vd.VoucherKey = @VoucherKey

	INSERT tVoucherTax (VoucherKey, VoucherDetailKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @VoucherKey, vd.VoucherDetailKey, vdt.SalesTaxKey, SUM(vdt.SalesTaxAmount), 3
	FROM   tVoucherDetailTax vdt (NOLOCK)
		INNER JOIN tVoucherDetail vd (NOLOCK) ON vdt.VoucherDetailKey = vd.VoucherDetailKey
	WHERE vd.VoucherKey = @VoucherKey
	AND   vdt.SalesTaxKey NOT IN (@SalesTaxKey, @SalesTax2Key)
	GROUP BY vdt.SalesTaxKey, vd.VoucherDetailKey
	
	RETURN 1
GO
