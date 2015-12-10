USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxGetListTemp]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxGetListTemp]
	(
		@InvoiceKey int
		,@AdvBillInvoiceKey int
		,@IsAdvanceBill int -- current invoice is the advance bill
		,@TotalNonTaxAmount money = null -- Sales Amount for the current invoice i.e. real or adv bill 
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 04/26/07 GHL 8.5  Creation for enhancement 6523.
|| 05/01/07 GHL 8.5  Display Union of taxes instead of Intersection of taxes
||                   Enable editing only if tax amounts on adv bill invoice and real invoice are > 0
|| 05/14/07 GHL 8.5  Modified OpenSalesTax since Adv Bill can be applied to itself
|| 09/30/09 GHL 10.5 Using now tInvoiceTax instead of tInvoice LineTax
|| 10/18/10 GHL 10.537 Cloned sptInvoiceAdvanceBillTaxGetList but reading now temp tables
*/

	SET NOCOUNT ON
	
	-- Please note:
	-- Sales Tax 1 on Header: SalesTaxKey but SalesTax1Amount
	-- Sales Tax 2 on Header: SalesTax2Key and SalesTax2Amount
	

	-- insert missing records
	-- client and server side data should be merged into #tInvoiceTax and #tInvoiceAdvanceBillTax
	
	declare @RealTotalNonTaxAmount money 
	declare @AdvBillTotalNonTaxAmount money 

	IF @IsAdvanceBill = 0
	BEGIN
		-- if this is a real invoice, we need the info on the advance bill
		select @RealTotalNonTaxAmount = @TotalNonTaxAmount
		select @AdvBillTotalNonTaxAmount = TotalNonTaxAmount from tInvoice (nolock) where InvoiceKey = @AdvBillInvoiceKey

		insert #tInvoiceTax (InvoiceKey, SalesTaxAmount, SalesTaxKey) 
		select InvoiceKey, sum(SalesTaxAmount), SalesTaxKey
		from   tInvoiceTax (nolock)
		where  InvoiceKey = @AdvBillInvoiceKey
		group by InvoiceKey, SalesTaxKey
		
		insert #tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
		select InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount
		from   tInvoiceAdvanceBillTax (nolock)
		where  AdvBillInvoiceKey = @AdvBillInvoiceKey
		and    InvoiceKey <> @InvoiceKey -- because they should be already there      

		insert #tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount)
		select InvoiceKey, AdvBillInvoiceKey, Amount
		from   tInvoiceAdvanceBill (nolock)
		where  AdvBillInvoiceKey = @AdvBillInvoiceKey
		and    InvoiceKey <> @InvoiceKey -- because they should be already there      

	END
	ELSE
	BEGIN
		-- if this is a AB invoice, we need the info on the real bill
		select @RealTotalNonTaxAmount = TotalNonTaxAmount from tInvoice (nolock) where InvoiceKey = @InvoiceKey
		select @AdvBillTotalNonTaxAmount = @TotalNonTaxAmount 

		insert #tInvoiceTax (InvoiceKey, SalesTaxAmount, SalesTaxKey) 
		select InvoiceKey, sum(SalesTaxAmount), SalesTaxKey
		from   tInvoiceTax (nolock)
		where  InvoiceKey = @InvoiceKey
		group by InvoiceKey, SalesTaxKey
		

		insert #tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
		select InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount
		from   tInvoiceAdvanceBillTax (nolock)
		where  InvoiceKey = @InvoiceKey
		and    AdvBillInvoiceKey <> @AdvBillInvoiceKey -- because they should be already there      
	
		insert #tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount)
		select InvoiceKey, AdvBillInvoiceKey, Amount
		from   tInvoiceAdvanceBill (nolock)
		where  InvoiceKey = @InvoiceKey
		and    AdvBillInvoiceKey <> @AdvBillInvoiceKey -- because they should be already there      
	
	END
	

	
	CREATE TABLE #tTax (
		SalesTaxKey INT NULL,
		SalesTaxID VARCHAR(100) null,
		AdvBillAmount MONEY NULL,		-- Sales Tax amount on adv bill invoice 
		AdvBillTotalAppliedAmount MONEY NULL,
		AdvBillUnappliedAmount MONEY NULL,
		
		AppliedAmount MONEY NULL,		-- Applied amount for this adv bill/ real invoice/ sales tax
		
		Amount MONEY NULL,				-- Sales Tax amount on this real invoice
		TotalAppliedAmount MONEY NULL,		-- Applied amount for this adv bill/ real invoice/ sales tax
		UnappliedAmount MONEY NULL,	-- Unapplied for this adv bill / sales tax (displayed on grid)
		
		UpdateFlag INT NULL,
		EnableEdit INT NULL 
		)
		
	-- Process the Advance bill invoice first
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)	
	SELECT SalesTaxKey, SUM(SalesTaxAmount), 1
	FROM   #tInvoiceTax (NOLOCK)
	WHERE  InvoiceKey = @AdvBillInvoiceKey
	AND    SalesTaxKey > 0  
	GROUP BY SalesTaxKey 

	-- Process the real invoice	
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT DISTINCT SalesTaxKey, 0, 1
	FROM   #tInvoiceTax (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey  
	AND    ISNULL(SalesTaxKey, 0) > 0
	AND    SalesTaxKey NOT IN (SELECT SalesTaxKey FROM #tTax)

	UPDATE #tTax
	SET    #tTax.Amount = 
	ISNULL(
		(SELECT SUM(#tInvoiceTax.SalesTaxAmount)
		FROM   #tInvoiceTax (NOLOCK)
		WHERE  #tInvoiceTax.InvoiceKey = @InvoiceKey  
		AND    #tInvoiceTax.SalesTaxKey = #tTax.SalesTaxKey)
	,0)

--select * from #tTax
	
	UPDATE #tTax
	SET    #tTax.Amount = ISNULL(#tTax.Amount, 0)
	
	-- The taxes must be on both invoices
	UPDATE #tTax 
	SET    #tTax.EnableEdit = 0
	WHERE ISNULL(AdvBillAmount, 0) = 0 OR ISNULL(Amount, 0) = 0 

--select * from #tTax
	
	-- Get amount for this adv bill/invoice/ tax
	UPDATE #tTax 
	SET    #tTax.AppliedAmount = 
	ISNULL(
		(SELECT iabt.Amount 
		FROM   #tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.InvoiceKey = @InvoiceKey
		AND    iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		)
	,0)
	
--select * from #tTax

	-- Get all total applied amount	this adv bill/ tax
	UPDATE #tTax 
	SET    #tTax.AdvBillTotalAppliedAmount = 
	ISNULL(
		(SELECT SUM(iabt.Amount) 
		FROM   #tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey <> @InvoiceKey -- we could remove this, just for display purpose
		)
	,0)

--select * from #tInvoiceAdvanceBillTax	
--select * from #tTax
		
	UPDATE #tTax
	SET	   #tTax.AdvBillUnappliedAmount = ISNULL(#tTax.AdvBillAmount, 0) - ISNULL(#tTax.AdvBillTotalAppliedAmount, 0)
		  ,#tTax.AppliedAmount = ISNULL(#tTax.AppliedAmount, 0)
	
	UPDATE #tTax
	SET	   #tTax.AdvBillUnappliedAmount = 0
	WHERE  #tTax.AdvBillUnappliedAmount < 0 

	-- Get all total applied amount	this real inv/ tax
	UPDATE #tTax 
	SET    #tTax.TotalAppliedAmount = 
	ISNULL(
		(SELECT SUM(iabt.Amount) 
		FROM   #tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey <> @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey = @InvoiceKey -- we could remove this, just for display purpose
		)
	,0)

	UPDATE #tTax
	SET	   #tTax.UnappliedAmount = ISNULL(#tTax.Amount, 0) - ISNULL(#tTax.TotalAppliedAmount, 0)
	
	UPDATE #tTax
	SET	   #tTax.UnappliedAmount = 0
	WHERE  #tTax.UnappliedAmount < 0 


-- now sales

	insert #tTax (SalesTaxKey, AdvBillAmount, Amount, EnableEdit)
	select 0, @AdvBillTotalNonTaxAmount, @RealTotalNonTaxAmount, 1
	

	-- The taxess must be on both invoices
	UPDATE #tTax 
	SET    #tTax.EnableEdit = 0
	WHERE ISNULL(AdvBillAmount, 0) = 0 OR ISNULL(Amount, 0) = 0 


	declare @SalesApplied money
	declare @TaxesApplied money

	select @SalesApplied = Amount 
	from   #tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iab.InvoiceKey = @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   #tInvoiceAdvanceBillTax iabt (nolock)
	where  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iabt.InvoiceKey = @InvoiceKey
	  
	select @SalesApplied = isnull(@SalesApplied, 0) - isnull(@TaxesApplied, 0)
	update #tTax set AppliedAmount = isnull(@SalesApplied, 0) where SalesTaxKey = 0


	select @SalesApplied = sum(Amount) 
	from   #tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iab.InvoiceKey <> @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   #tInvoiceAdvanceBillTax iabt (nolock)
	where  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iabt.InvoiceKey <> @InvoiceKey
	
	select @SalesApplied = isnull(@SalesApplied, 0) - isnull(@TaxesApplied, 0)
	update #tTax set AdvBillTotalAppliedAmount = isnull(@SalesApplied, 0) where SalesTaxKey = 0



	select @SalesApplied = sum(Amount) 
	from   #tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey <> @AdvBillInvoiceKey
	and    iab.InvoiceKey = @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   #tInvoiceAdvanceBillTax iabt (nolock)
	where  iabt.AdvBillInvoiceKey <> @AdvBillInvoiceKey
	and    iabt.InvoiceKey = @InvoiceKey
	
	select @SalesApplied = isnull(@SalesApplied, 0) - isnull(@TaxesApplied, 0)
	update #tTax set TotalAppliedAmount = isnull(@SalesApplied, 0) where SalesTaxKey = 0

	update #tTax set AdvBillUnappliedAmount =isnull(AdvBillAmount, 0) - isnull(AdvBillTotalAppliedAmount, 0) 
	where SalesTaxKey = 0

	update #tTax set UnappliedAmount =isnull(Amount, 0) - isnull(TotalAppliedAmount, 0) 
	where SalesTaxKey = 0

	update #tTax
	set    #tTax.SalesTaxID = st.SalesTaxID
	from   tSalesTax st (nolock) 
	where  #tTax.SalesTaxKey = st.SalesTaxKey

	update #tTax
	set    #tTax.SalesTaxID = 'SALES'
	where  #tTax.SalesTaxKey = 0



--select * from #tTax
		  		
	-- Just to display at the bottom of the screen	  			
	/*
	DECLARE @AdvBillOpenSalesTax MONEY
	SELECT @AdvBillOpenSalesTax = 
		ISNULL((SELECT SUM(UnappliedAdvBillAmount) FROM #tTax),0)
		- ISNULL((SELECT SUM(AppliedAmount) FROM #tTax),0)
	IF @AdvBillOpenSalesTax < 0
		SELECT @AdvBillOpenSalesTax = 0
			    
	DECLARE @OpenSalesTax MONEY
	SELECT @OpenSalesTax = 
		ISNULL((SELECT SUM(Amount) FROM #tTax),0)
		- ISNULL((SELECT SUM(AppliedAmount) FROM #tTax),0)
	IF @OpenSalesTax < 0
		SELECT @OpenSalesTax = 0
	*/

	DECLARE @AdvBillOpenSalesTax MONEY
	SELECT @AdvBillOpenSalesTax = 
		ISNULL((SELECT SUM(SalesTaxAmount) FROM #tInvoiceTax (NOLOCK) WHERE InvoiceKey = @AdvBillInvoiceKey), 0)
	  - ISNULL((SELECT SUM(Amount) FROM #tInvoiceAdvanceBillTax (NOLOCK) 
				WHERE AdvBillInvoiceKey =@AdvBillInvoiceKey)   
			, 0)
	IF @AdvBillOpenSalesTax < 0
		SELECT @AdvBillOpenSalesTax = 0
			    
	DECLARE @OpenSalesTax MONEY
	SELECT @OpenSalesTax = 
		ISNULL((SELECT SUM(SalesTaxAmount) FROM #tInvoiceTax (NOLOCK) WHERE InvoiceKey = @InvoiceKey), 0)
	  - ISNULL((SELECT SUM(Amount) FROM #tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE InvoiceKey =@InvoiceKey
				OR AdvBillInvoiceKey =@InvoiceKey)   
			, 0)
	IF @OpenSalesTax < 0
		SELECT @OpenSalesTax = 0
		
-- calculate OpenAmount, but do not include the contribution from this current application
Declare @OpenAmount money
Declare @OtherAppliedAmount money

-- cannot overapply the real invoice...calculate open amount without retainer amount (because it is recalced here)
Select @OpenAmount = ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(AmountReceived, 0)
 	From tInvoice (nolock) Where InvoiceKey = @InvoiceKey

-- calculate the other applications for this real invoice
Select @OtherAppliedAmount = sum(Amount) from tInvoiceAdvanceBill (nolock)
where  InvoiceKey = @InvoiceKey
and    AdvBillInvoiceKey <> @AdvBillInvoiceKey -- but not for this Adv Bill, it is being edited

					
Select @OpenAmount = isnull(@OpenAmount, 0) + isnull(@OtherAppliedAmount, 0)
							    
	SELECT b.*, isnull(st.SalesTaxID, 'SALES') as SalesTaxID, isnull(st.SalesTaxName, '') as SalesTaxName
	, @AdvBillOpenSalesTax AS AdvBillOpenSalesTax, @OpenSalesTax AS OpenSalesTax, @OpenAmount as OpenAmount   
	FROM #tTax b	
		LEFT JOIN tSalesTax st (NOLOCK) ON st.SalesTaxKey = b.SalesTaxKey
	ORDER BY b.EnableEdit DESC
				
	RETURN 1
GO
