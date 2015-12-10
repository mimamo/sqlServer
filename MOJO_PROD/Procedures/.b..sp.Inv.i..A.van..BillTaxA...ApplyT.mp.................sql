USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxAutoApplyTemp]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxAutoApplyTemp]
	(
		@InvoiceKey INT
		,@AdvBillInvoiceKey INT
		,@AppliedAmount MONEY -- This is the amount on tInvoiceAdvanceBill
		,@InvoiceTotalAmount MONEY -- We need the invoice total amount on the real invoice to perform a math application
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 04/30/07 GHL 8.5  Creation for enhancement 6523.
|| 09/30/09 GHL 10.5 Using now tInvoiceTax instead of tInvoice LineTax
|| 01/12/13 GHL 10.563 (164761) In order to resolve rounding errors, we must determine if this is the last application
*/
	SET NOCOUNT ON
		
	declare @ABLastApplication int
	select @ABLastApplication = 0
	
	declare @ABInvoiceTotalAmount money
	declare @ABAppliedAmount money

	select @ABInvoiceTotalAmount = InvoiceTotalAmount from tInvoice (nolock) where InvoiceKey = @AdvBillInvoiceKey
	select @ABAppliedAmount = sum(Amount) from tInvoiceAdvanceBill (nolock) 
	where AdvBillInvoiceKey = @AdvBillInvoiceKey
	and   InvoiceKey <> @InvoiceKey
	select @ABAppliedAmount = isnull(@ABAppliedAmount,0) 

	if @AppliedAmount + @ABAppliedAmount = @ABInvoiceTotalAmount
		select @ABLastApplication = 1 

	-- Please note:
	-- Sales Tax 1 on Header: SalesTaxKey but SalesTax1Amount
	-- Sales Tax 2 on Header: SalesTax2Key and SalesTax2Amount
	
	CREATE TABLE #tTax (
		SalesTaxKey INT NULL,
		AdvBillAmount MONEY NULL,				-- Sales Tax amount on adv bill invoice 
		AdvBillTotalAppliedAmount MONEY NULL,	-- Total applied amount for this adv bill / sales tax 
		AdvBillUnappliedAmount MONEY NULL,		-- Unapplied for this adv bill / sales tax 
		
		Amount MONEY NULL,						-- Sales Tax amount on this real invoice
		TotalAppliedAmount MONEY NULL,			-- real invoice/ sales tax
		UnappliedAmount MONEY NULL,				-- unapplied for real invoice/sales tax
		GPFlag INT NULL -- my general purpose flag
		)
	
	-- The sales taxes must be on the advance bill invoice and the real invoice 
	
	-- Get the Advance bill taxes
	
	INSERT #tTax (SalesTaxKey, AdvBillAmount, GPFlag)
	SELECT SalesTaxKey, SUM(SalesTaxAmount), 0
	FROM   #tInvoiceTax (NOLOCK)
	WHERE  InvoiceKey = @AdvBillInvoiceKey  
	GROUP BY SalesTaxKey 
	
	
	-- Process the real invoice	
	UPDATE #tTax
	SET    #tTax.Amount = 
	ISNULL(
		(SELECT SUM(SalesTaxAmount)
		FROM   #tInvoiceTax (NOLOCK)
		WHERE  #tInvoiceTax.InvoiceKey = @InvoiceKey  
		AND    #tInvoiceTax.SalesTaxKey = #tTax.SalesTaxKey)
	,0)

   --select * from #tTax
	
	UPDATE #tTax
	SET    #tTax.Amount = ISNULL(#tTax.Amount, 0)
	
	-- The taxes must be on both invoices
	-- Delete if one amount = 0
	DELETE #tTax WHERE ISNULL(AdvBillAmount, 0) = 0 OR ISNULL(Amount, 0) = 0 
	
    --select * from #tTax

	-- Get all total applied amount	
	UPDATE #tTax 
	SET    #tTax.AdvBillTotalAppliedAmount = 
	ISNULL(
		(SELECT SUM(iabt.Amount) 
		FROM   #tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey <> @InvoiceKey 
		)
	,0)

	-- Get all total applied amount	for the real invoice
	UPDATE #tTax 
	SET    #tTax.TotalAppliedAmount = 
	ISNULL(
		(SELECT SUM(iabt.Amount) 
		FROM   #tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey <> @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey = @InvoiceKey 
		)
	,0)

	
  --select * from #tTax
		
	UPDATE #tTax
	SET	   #tTax.AdvBillUnappliedAmount = ISNULL(#tTax.AdvBillAmount, 0) - ISNULL(#tTax.AdvBillTotalAppliedAmount, 0)
	      ,#tTax.UnappliedAmount = ISNULL(#tTax.Amount, 0) - ISNULL(#tTax.TotalAppliedAmount, 0)
	
	UPDATE #tTax
	SET	   #tTax.AdvBillUnappliedAmount = 0
	WHERE  #tTax.AdvBillUnappliedAmount < 0 

	UPDATE #tTax
	SET	   #tTax.UnappliedAmount = 0
	WHERE  #tTax.UnappliedAmount < 0 

	DECLARE @SalesTaxKey INT
			,@SalesTaxAmount MONEY
			,@AdvBillUnappliedAmount MONEY
			,@UnappliedAmount MONEY
	
			
	/*
	SELECT @InvoiceTotalAmount = InvoiceTotalAmount
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey
	*/
				
	SELECT @InvoiceTotalAmount = ISNULL(@InvoiceTotalAmount, 0)
	IF @InvoiceTotalAmount = 0
		RETURN 1

	DELETE #tInvoiceAdvanceBillTax WHERE AdvBillInvoiceKey = @AdvBillInvoiceKey AND InvoiceKey = @InvoiceKey
					
	SELECT @SalesTaxKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @SalesTaxKey = MIN(SalesTaxKey)
		FROM   #tTax
		WHERE  SalesTaxKey > @SalesTaxKey
	
		IF @SalesTaxKey IS NULL
			BREAK
		
		-- Sales Tax for the real invoice	
		SELECT @SalesTaxAmount = Amount
			   ,@AdvBillUnappliedAmount = AdvBillUnappliedAmount
			   ,@UnappliedAmount = UnappliedAmount
		FROM   #tTax	
		WHERE  SalesTaxKey = @SalesTaxKey
		
		-- Should be a function of the @AppliedAmount			
		SELECT @SalesTaxAmount = (@SalesTaxAmount * @AppliedAmount) / @InvoiceTotalAmount					
		SELECT @SalesTaxAmount = ROUND(@SalesTaxAmount, 2) -- needed? rounding errors?
		
		-- If this is the last application, try to apply the whole unapplied amount on AB
		-- so that if there is a rounding error at the end, it will be removed
		If @ABLastApplication = 1
			select @SalesTaxAmount = @AdvBillUnappliedAmount

		-- cannot over apply on both sides
		IF @SalesTaxAmount > @AdvBillUnappliedAmount
			SELECT @SalesTaxAmount = @AdvBillUnappliedAmount
			
		IF @SalesTaxAmount > @UnappliedAmount
			SELECT @SalesTaxAmount = @UnappliedAmount

		IF @SalesTaxAmount > 0
		BEGIN
			INSERT #tInvoiceAdvanceBillTax(InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount, IsNew)
			VALUES (@InvoiceKey, @AdvBillInvoiceKey, @SalesTaxKey, @SalesTaxAmount, 1)
		END	
							
	END
			
	
	
	
	RETURN 1
GO
