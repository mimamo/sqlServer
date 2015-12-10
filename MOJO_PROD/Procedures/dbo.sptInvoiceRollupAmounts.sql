USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceRollupAmounts]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceRollupAmounts]
	(
	@InvoiceKey int
	,@InvoiceTaxRecordsOnly int = 0
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/15/09 GHL 10.512 Added update of transactions DateBilled
  || 09/21/10 GHL 10.535 1)Added @InvoiceTaxRecordsOnly so that we can choose to do 
  ||                     only tInvoiceTax when updating form flex
  ||                     2)Limiting now to detail lines
  || 05/16/13 GHL 10.567 (178596) Added checking of LineType = 2 when rolling up amounts from tInvoiceLine
  || 06/05/13 GHL 10.568 (179672) Checking now if invoice is paid/posted before changing split
  */
  
	SET NOCOUNT ON
	
	DECLARE @LineInvoiceKey INT -- invoice where the lines are
	        ,@SalesTaxAmount MONEY
			,@SalesTax1Amount MONEY
			,@SalesTax2Amount MONEY
	        ,@SalesTax1Key INT
	        ,@SalesTax2Key INT
	        ,@TotalNonTaxAmount MONEY
	        ,@InvoiceTotalAmount MONEY 
	        ,@ParentInvoice tinyint
	        ,@PercentageSplit decimal(24,4)
	        ,@ParentInvoiceKey INT
	        ,@CurrInvoiceKey INT
			        
	Select 
		@ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0),
		@LineInvoiceKey = @InvoiceKey,
		@PercentageSplit = PercentageSplit,
		@ParentInvoice = ISNULL(ParentInvoice, 0),
		@SalesTax1Key = isnull(SalesTaxKey, 0),
		@SalesTax2Key = isnull(SalesTax2Key, 0)
	from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
	if @ParentInvoiceKey = 0
		Select @PercentageSplit = 1
	ELSE
		Select @LineInvoiceKey = @ParentInvoiceKey, @PercentageSplit = @PercentageSplit / 100
		
	
	-- If this is a parent invoice               	
	if @ParentInvoice = 1
	BEGIN	
		SELECT  @SalesTaxAmount = 0, @SalesTax1Amount = 0, @SalesTax2Amount = 0, @TotalNonTaxAmount = 0, @InvoiceTotalAmount = 0

		UPDATE tInvoice
		SET    SalesTaxAmount     = @SalesTaxAmount
			  ,SalesTax1Amount	  = @SalesTax1Amount
			  ,SalesTax2Amount	  = @SalesTax2Amount
			  ,TotalNonTaxAmount  = @TotalNonTaxAmount  
			  ,InvoiceTotalAmount = @InvoiceTotalAmount
		WHERE InvoiceKey          = @InvoiceKey
		
		DELETE tInvoiceTax
		WHERE  InvoiceKey = @InvoiceKey

		EXEC sptInvoiceSummary @InvoiceKey
		
	END	
	
	-- if this is a regular invoice
	if @ParentInvoice = 0 And @ParentInvoiceKey = 0
	BEGIN			
		if @InvoiceTaxRecordsOnly = 0
		begin

			SELECT  @SalesTaxAmount = SUM(SalesTaxAmount)
					,@SalesTax1Amount = SUM(SalesTax1Amount)
					,@SalesTax2Amount = SUM(SalesTax2Amount)
					,@TotalNonTaxAmount = SUM(TotalAmount)
			FROM    tInvoiceLine (NOLOCK)
			WHERE   InvoiceKey = @InvoiceKey
			AND     LineType = 2

			SELECT  @SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
					,@SalesTax1Amount = ISNULL(@SalesTax1Amount,0)
					,@SalesTax2Amount = ISNULL(@SalesTax2Amount,0)
					,@TotalNonTaxAmount = ISNULL(@TotalNonTaxAmount,0)
		
			SELECT  @InvoiceTotalAmount = @SalesTaxAmount + @TotalNonTaxAmount
	      
			UPDATE tInvoice
			SET    SalesTaxAmount     = @SalesTaxAmount
				  ,SalesTax1Amount	  = @SalesTax1Amount
				  ,SalesTax2Amount	  = @SalesTax2Amount
				  ,TotalNonTaxAmount  = @TotalNonTaxAmount  
				  ,InvoiceTotalAmount = @InvoiceTotalAmount
			WHERE InvoiceKey         = @InvoiceKey
		end

		DELETE tInvoiceTax
		WHERE  InvoiceKey = @InvoiceKey
		
		IF @SalesTax1Key > 0
			INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
			SELECT @InvoiceKey, InvoiceLineKey, @SalesTax1Key, 1, ISNULL(SalesTax1Amount,0)
			FROM   tInvoiceLine il (NOLOCK)
			WHERE  il.InvoiceKey = @LineInvoiceKey
			AND    il.LineType = 2

		IF @SalesTax2Key > 0
			INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
			SELECT @InvoiceKey, InvoiceLineKey, @SalesTax2Key, 2, ISNULL(SalesTax2Amount,0)
			FROM   tInvoiceLine il (NOLOCK)
			WHERE  il.InvoiceKey = @LineInvoiceKey
			AND    il.LineType = 2

		INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
		SELECT @InvoiceKey, ilt.InvoiceLineKey, ilt.SalesTaxKey, 3, ISNULL(ilt.SalesTaxAmount,0)
		FROM   tInvoiceLineTax ilt (NOLOCK)
			INNER JOIN tInvoiceLine il (NOLOCK) ON ilt.InvoiceLineKey = il.InvoiceLineKey
		WHERE il.InvoiceKey = @LineInvoiceKey
		AND   ilt.SalesTaxKey NOT IN (@SalesTax1Key, @SalesTax2Key)
			
		EXEC sptInvoiceSummary @InvoiceKey
		
	END

	-- if this is a child invoice
	if @ParentInvoice = 0 And @ParentInvoiceKey > 0
	BEGIN			
	    -- get the info from the parent invoice first and store into tInvoiceTax FIRST
		-- By doing so, we should limit rounding errors between header and tax lines due to X by @PercentageSplit
			
		DELETE tInvoiceTax
		WHERE  InvoiceKey = @InvoiceKey
		
		IF @SalesTax1Key > 0
			INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
			SELECT @InvoiceKey, InvoiceLineKey, @SalesTax1Key, 1, ROUND(ISNULL(SalesTax1Amount,0) * @PercentageSplit, 2)
			FROM   tInvoiceLine il (NOLOCK)
			WHERE  il.InvoiceKey = @LineInvoiceKey
			AND    il.LineType = 2

		IF @SalesTax2Key > 0
			INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
			SELECT @InvoiceKey, InvoiceLineKey, @SalesTax2Key, 2, ROUND(ISNULL(SalesTax2Amount,0) * @PercentageSplit, 2)
			FROM   tInvoiceLine il (NOLOCK)
			WHERE  il.InvoiceKey = @LineInvoiceKey
			AND    il.LineType = 2

		INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
		SELECT @InvoiceKey, ilt.InvoiceLineKey, ilt.SalesTaxKey, 3, ROUND(ISNULL(ilt.SalesTaxAmount,0) * @PercentageSplit, 2)
		FROM   tInvoiceLineTax ilt (NOLOCK)
			INNER JOIN tInvoiceLine il (NOLOCK) ON ilt.InvoiceLineKey = il.InvoiceLineKey
		WHERE il.InvoiceKey = @LineInvoiceKey
		AND   ilt.SalesTaxKey NOT IN (@SalesTax1Key, @SalesTax2Key)
		
		SELECT  @SalesTax1Amount = SUM(SalesTaxAmount)
		FROM    tInvoiceTax (NOLOCK)
		WHERE   InvoiceKey = @InvoiceKey
		AND     Type = 1
		
		SELECT  @SalesTax2Amount = SUM(SalesTaxAmount)
		FROM    tInvoiceTax (NOLOCK)
		WHERE   InvoiceKey = @InvoiceKey
		AND     Type = 2
		
		SELECT  @SalesTaxAmount = SUM(SalesTaxAmount)
		FROM    tInvoiceTax (NOLOCK)
		WHERE   InvoiceKey = @InvoiceKey
		
		-- This is how spGLPostInvoice does it (i.e SUM(Rounds))
		SELECT @TotalNonTaxAmount = SUM(ROUND(ISNULL(il.TotalAmount, 0) * @PercentageSplit, 2))
		FROM   tInvoiceLine il (NOLOCK)
		WHERE  il.InvoiceKey = @LineInvoiceKey
		
		SELECT  @SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
				,@SalesTax1Amount = ISNULL(@SalesTax1Amount,0)
				,@SalesTax2Amount = ISNULL(@SalesTax2Amount,0) 
				,@TotalNonTaxAmount = ISNULL(@TotalNonTaxAmount,0) 
						
		SELECT  @InvoiceTotalAmount = @SalesTaxAmount + @TotalNonTaxAmount
	      
		UPDATE tInvoice
		SET    SalesTaxAmount     = @SalesTaxAmount
			  ,SalesTax1Amount	  = @SalesTax1Amount
			  ,SalesTax2Amount	  = @SalesTax2Amount
			  ,TotalNonTaxAmount  = @TotalNonTaxAmount  
			  ,InvoiceTotalAmount = @InvoiceTotalAmount
		WHERE InvoiceKey         = @InvoiceKey
		
		EXEC sptInvoiceSummary @InvoiceKey
		
	END
		
	-- Return early if this is a child invoice
	if @ParentInvoiceKey > 0
		return 1
	else
	BEGIN
		if @ParentInvoice = 1
		BEGIN
			Select @CurrInvoiceKey = -1
			While 1=1
			BEGIN
				Select @CurrInvoiceKey = Min(InvoiceKey) 
				from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey and InvoiceKey > @CurrInvoiceKey
				and  Posted = 0 
				and  isnull(AmountReceived, 0) = 0

				if @CurrInvoiceKey is null
					Break
				exec sptInvoiceRollupAmounts @CurrInvoiceKey
			END
		END
	END

	Declare @InvoiceDate smalldatetime

if @InvoiceTaxRecordsOnly = 0
begin

	Select @InvoiceDate = PostingDate from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	Update tTime
	Set DateBilled = @InvoiceDate
	From tInvoiceLine (nolock)
	Where
		tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tExpenseReceipt
	Set DateBilled = @InvoiceDate
	From tInvoiceLine (nolock)
	Where
		tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tMiscCost
	Set DateBilled = @InvoiceDate
	From tInvoiceLine (nolock)
	Where
		tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tVoucherDetail
	Set DateBilled = @InvoiceDate
	From tInvoiceLine (nolock)
	Where
		tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
	
	Update tPurchaseOrderDetail
	Set DateBilled = @InvoiceDate
	From tInvoiceLine (nolock)
	Where
		tPurchaseOrderDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey

end
		
	RETURN 1
GO
