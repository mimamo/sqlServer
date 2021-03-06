USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherRecalcAmountsConversion]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherRecalcAmountsConversion]
	(
		@VoucherKey INT
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/16/09 GHL 10.5  Clone of sptInvoiceRecalcAmounts  
  || 09/23/09 GHL 10.5  Added tVoucherTax records
  */
  
	set nocount on

	DECLARE @SalesTax1Key int
		   ,@SalesTax1Rate DECIMAL(24,4)
	       ,@SalesTax1Amount MONEY
	       ,@SalesTax1PiggyBack tinyint
	       ,@SalesTax2Key int
	       ,@SalesTax2Rate DECIMAL(24,4)
	       ,@SalesTax2Amount MONEY
	       ,@SalesTax2PiggyBack tinyint
	       ,@SalesTaxAmount MONEY
	       ,@TotalNonTaxAmount MONEY
	       ,@VoucherTotal MONEY 
	       
	-- Added for other taxes      
	DECLARE @NonPiggyBackSalesTaxAmount MONEY
			,@LineTotalAmount MONEY
			,@LineTaxable tinyint
			,@LineTaxable2 tinyint
			,@CurrSalesTaxKey int	
			,@CurrSalesTaxRate DECIMAL(24,4)		
			,@CurrPiggyBackTax tinyint
			,@CurrSalesTaxAmount MONEY
			,@CurrVoucherDetailKey int
			
		/*
		|| Example:
		|| Line Amount = 1000
		|| T1 5% PiggyBack
		|| T2 10% 
		|| T3 10% PiggyBack 
		|| T4 10%
		|| 
		|| Non PiggyBack taxes (from T2 and T4) = 100 + 100
		|| New Line Amount = 1000 + 200 = 1200
		||
		|| T1 tax = 1200 * 5% = 60
		|| T3 tax = 1200 * 10% = 120
		|| Final total amount = 1200 + 180 = 1380
		*/

		/* Algorithm
				
		SalesTax1Amount = 0
		SalesTax2Amount = 0

		For Each tVoucherDetail
			Get TotalAmount
			
			NonPiggyBackSalesTaxAmount = 0

			Get SalesTax1 info
			If Not PiggyBack
				Add to SalesTax1Amount 
				Add to NonPiggyBackSalesTaxAmount 
			 
			Get SalesTax2 info
			If Not PiggyBack
				Add to SalesTax2Amount 
				Add to NonPiggyBackSalesTaxAmount 

			For Each tVoucherDetailTax
				Get SalesTax info
			If Not PiggyBack
				Add to tVoucherDetailTax.SalesTaxAmount 
				Add to NonPiggyBackSalesTaxAmount 
			Next

			TotalAmount = TotalAmount + NonPiggyBackSalesTaxAmount

			If SalesTax1 is PiggyBack
				Add to SalesTax1Amount 
				
			If SalesTax2 is PiggyBack
				Add to SalesTax2Amount 

			For Each tVoucherDetailTax
				Get SalesTax info
			If PiggyBack
				Add to tVoucherDetailTax.SalesTaxAmount 
			Next

		Next
		*/
							   	   
	Select 
		@SalesTax1Key = SalesTaxKey,
		@SalesTax2Key = SalesTax2Key
	from tVoucher (nolock) Where VoucherKey = @VoucherKey
		
	if ISNULL(@SalesTax1Key, 0) = 0
		Select @SalesTax1Rate = 0
	else
		Select @SalesTax1Rate = TaxRate, @SalesTax1PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTax1Key
		
	if ISNULL(@SalesTax2Key, 0) = 0
		Select @SalesTax2Rate = 0
	else
		Select @SalesTax2Rate = TaxRate, @SalesTax2PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
				  	
	-- Loop through each Line
	SELECT @CurrVoucherDetailKey = -1	
	WHILE (1=1)
	BEGIN
		SELECT @CurrVoucherDetailKey = MIN(VoucherDetailKey)
		FROM   tVoucherDetail (NOLOCK)	
		WHERE  VoucherKey = @VoucherKey
		AND    VoucherDetailKey > @CurrVoucherDetailKey
		
		IF @CurrVoucherDetailKey IS NULL
			BREAK
		
		-- Initialize Line buckets
		SELECT @NonPiggyBackSalesTaxAmount  = 0
				,@SalesTax1Amount = 0
				,@SalesTax2Amount = 0
	
		SELECT @LineTotalAmount = ISNULL(TotalCost, 0)
			  ,@LineTaxable		= ISNULL(Taxable, 0)
			  ,@LineTaxable2	= ISNULL(Taxable2, 0)			  
		FROM   tVoucherDetail (NOLOCK)
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey	
		
		/*
		|| Process non piggy back taxes first!!!!
		*/
		
		IF @SalesTax1Rate > 0 AND @SalesTax1PiggyBack = 0 AND @LineTaxable = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax1Rate) / 100
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
								
			SELECT @SalesTax1Amount = @SalesTax1Amount + @CurrSalesTaxAmount
			SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
		END

		IF @SalesTax2Rate > 0 AND @SalesTax2PiggyBack = 0 AND @LineTaxable2 = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax2Rate) / 100
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
		
			SELECT @SalesTax2Amount = @SalesTax2Amount + @CurrSalesTaxAmount
			SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
		END
		
		
		/*
		|| Then process piggy back taxes!!!!
		*/
		
		-- Refresh first the line total amount with the other taxes
		SELECT @LineTotalAmount = @LineTotalAmount + @NonPiggyBackSalesTaxAmount 

		IF @SalesTax1Rate > 0 AND @SalesTax1PiggyBack = 1 AND @LineTaxable = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax1Rate) / 100		
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)

			SELECT @SalesTax1Amount = @SalesTax1Amount + @CurrSalesTaxAmount
		END

		IF @SalesTax2Rate > 0 AND @SalesTax2PiggyBack = 1 AND @LineTaxable2 = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax2Rate) / 100
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)

			SELECT @SalesTax2Amount = @SalesTax2Amount + @CurrSalesTaxAmount
		END
		
		 
		UPDATE tVoucherDetail
		SET    SalesTax1Amount = @SalesTax1Amount
				,SalesTax2Amount = @SalesTax2Amount
				,SalesTaxAmount = @SalesTax1Amount + @SalesTax2Amount 
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey		 
				
	END	
				
	SELECT  @SalesTax1Amount = SUM(SalesTax1Amount)
			,@SalesTax2Amount = SUM(SalesTax2Amount)
	FROM    tVoucherDetail (NOLOCK)
	WHERE   VoucherKey = @VoucherKey
	
	SELECT  @SalesTax1Amount = ISNULL(@SalesTax1Amount,0)
			,@SalesTax2Amount = ISNULL(@SalesTax2Amount,0)
					
	-- now get the sales amounts on tVoucher
	DECLARE @VoucherSalesTax1Amount money
	DECLARE @VoucherSalesTax2Amount money
	
	SELECT  @VoucherSalesTax1Amount = SalesTax1Amount 
	       ,@VoucherSalesTax2Amount = SalesTax2Amount
	FROM    tVoucher (nolock)
	WHERE   VoucherKey = @VoucherKey
	

	SELECT  @VoucherSalesTax1Amount = ISNULL(@VoucherSalesTax1Amount,0)
			,@VoucherSalesTax2Amount = ISNULL(@VoucherSalesTax2Amount,0)

	IF @SalesTax1Key > 0 AND ISNULL(@VoucherSalesTax1Amount, 0) <> 0
	INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @VoucherKey, @SalesTax1Key, @VoucherSalesTax1Amount, 1
	
	IF @SalesTax2Key > 0 AND ISNULL(@VoucherSalesTax2Amount, 0) <> 0
	INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @VoucherKey, @SalesTax2Key, @VoucherSalesTax2Amount, 2

	
	SELECT  @VoucherSalesTax1Amount = @VoucherSalesTax1Amount - @SalesTax1Amount
	SELECT  @VoucherSalesTax2Amount = @VoucherSalesTax2Amount - @SalesTax2Amount
	
	IF (@VoucherSalesTax1Amount <> 0) 
	BEGIN
		SELECT @CurrVoucherDetailKey = MAX(VoucherDetailKey)
		FROM   tVoucherDetail (nolock)
		WHERE  VoucherKey = @VoucherKey
		AND    Taxable = 1
		
		
		UPDATE tVoucherDetail
		SET    SalesTax1Amount = SalesTax1Amount + @VoucherSalesTax1Amount
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey
	END
	
	IF (@VoucherSalesTax2Amount <> 0) 
	BEGIN
		SELECT @CurrVoucherDetailKey = MAX(VoucherDetailKey)
		FROM   tVoucherDetail (nolock)
		WHERE  VoucherKey = @VoucherKey
		AND    Taxable2 = 1
		
		
		UPDATE tVoucherDetail
		SET    SalesTax2Amount = SalesTax2Amount + @VoucherSalesTax2Amount
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey
	END
		
		
	return 1
GO
