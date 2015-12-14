USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherRecalcLineAmounts]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherRecalcLineAmounts]
	(
		@VoucherKey INT
		,@VoucherDetailKey INT
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/16/09 GHL 10.5  Clone of sptVoucherRecalcAmounts for one line
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
			,@OtherSalesTaxAmount MONEY
			
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
		AND    VoucherDetailKey = @VoucherDetailKey
		
		IF @CurrVoucherDetailKey IS NULL
			BREAK
		
		-- Initialize Line buckets
		SELECT @NonPiggyBackSalesTaxAmount  = 0
				,@SalesTax1Amount = 0
				,@SalesTax2Amount = 0
				,@OtherSalesTaxAmount = 0

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
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
								
			SELECT @SalesTax1Amount = @SalesTax1Amount + @CurrSalesTaxAmount
			SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
		END

		IF @SalesTax2Rate > 0 AND @SalesTax2PiggyBack = 0 AND @LineTaxable2 = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax2Rate) / 100
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
			
			SELECT @SalesTax2Amount = @SalesTax2Amount + @CurrSalesTaxAmount
			SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
		END
		
		-- Loop though other non piggy back taxes
		SELECT @CurrSalesTaxKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrSalesTaxKey = MIN(SalesTaxKey)
			FROM   tVoucherDetailTax (NOLOCK)
			WHERE  VoucherDetailKey = @CurrVoucherDetailKey
			AND    SalesTaxKey > @CurrSalesTaxKey
			
			IF @CurrSalesTaxKey IS NULL
				BREAK
		
			SELECT @CurrSalesTaxRate = ISNULL(TaxRate, 0)
				  ,@CurrPiggyBackTax = ISNULL(PiggyBackTax, 0)					
			FROM   tSalesTax (NOLOCK)
			WHERE  SalesTaxKey = @CurrSalesTaxKey

			IF @CurrSalesTaxRate > 0 AND @CurrPiggyBackTax = 0 
			BEGIN
				-- Round here since it is stored in the database
				SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @CurrSalesTaxRate) / 100
				SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
				SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
				
				UPDATE tVoucherDetailTax 
				SET    SalesTaxAmount = @CurrSalesTaxAmount
				WHERE  VoucherDetailKey = @CurrVoucherDetailKey
				AND    SalesTaxKey    = @CurrSalesTaxKey
				 
				SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
				SELECT @OtherSalesTaxAmount = @OtherSalesTaxAmount + @CurrSalesTaxAmount 
			END
			
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
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
			
			SELECT @SalesTax1Amount = @SalesTax1Amount + @CurrSalesTaxAmount
		END

		IF @SalesTax2Rate > 0 AND @SalesTax2PiggyBack = 1 AND @LineTaxable2 = 1
		BEGIN
			SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @SalesTax2Rate) / 100
			SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
			
			SELECT @SalesTax2Amount = @SalesTax2Amount + @CurrSalesTaxAmount
		END
		
		-- Loop though other piggy back taxes
		SELECT @CurrSalesTaxKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrSalesTaxKey = MIN(SalesTaxKey)
			FROM   tVoucherDetailTax (NOLOCK)
			WHERE  VoucherDetailKey = @CurrVoucherDetailKey
			AND    SalesTaxKey > @CurrSalesTaxKey
			
			IF @CurrSalesTaxKey IS NULL
				BREAK
		
			SELECT @CurrSalesTaxRate = ISNULL(TaxRate, 0)
				  ,@CurrPiggyBackTax = ISNULL(PiggyBackTax, 0)					
			FROM   tSalesTax (NOLOCK)
			WHERE  SalesTaxKey = @CurrSalesTaxKey

			IF @CurrSalesTaxRate > 0 AND @CurrPiggyBackTax = 1 
			BEGIN
				-- Round here since it is stored in the database
				SELECT @CurrSalesTaxAmount = (@LineTotalAmount * @CurrSalesTaxRate) / 100
				SELECT @CurrSalesTaxAmount = ROUND(@CurrSalesTaxAmount, 2)
				SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)				
				
				UPDATE tVoucherDetailTax 
				SET    SalesTaxAmount = @CurrSalesTaxAmount
				WHERE  VoucherDetailKey = @CurrVoucherDetailKey
				AND    SalesTaxKey    = @CurrSalesTaxKey

				SELECT @OtherSalesTaxAmount = @OtherSalesTaxAmount + @CurrSalesTaxAmount 

			END
			
		END
		 
		UPDATE tVoucherDetail
		SET    SalesTax1Amount = @SalesTax1Amount
				,SalesTax2Amount = @SalesTax2Amount
				,SalesTaxAmount = @SalesTax1Amount + @SalesTax2Amount + @OtherSalesTaxAmount
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey		 
				
	END	
				
	-- And rollup detail records at the header level
	EXEC sptVoucherRollupAmounts @VoucherKey
	
	return 1
GO
