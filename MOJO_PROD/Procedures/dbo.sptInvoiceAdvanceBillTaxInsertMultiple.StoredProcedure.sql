USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxInsertMultiple]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxInsertMultiple]
	(
		@InvoiceKey int
		,@AdvBillInvoiceKey int
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 01/10/13 GHL 10.564 (164168) Creation. Added the possiblity to alter tInvoiceAdvanceBill.Amount
||                     and increase taxes when applied SalesAmount = 0
|| 01/14/13 GHL 10.564 Limit the invoice advance applied amounts to the open amount on the real invoice
||                     i.e. take amount received in consideration
*/

	SET NOCOUNT ON
	
	-- Please note:
	-- Sales Tax 1 on Header: SalesTaxKey but SalesTax1Amount
	-- Sales Tax 2 on Header: SalesTax2Key and SalesTax2Amount
	
	-- Assume done in VB
	/*
	create table #Applied (
		SalesTaxKey INT NULL,
		SalesTaxID VARCHAR(100) null,
		Amount money null,
		ErrorReturn int null
		)
	*/

Declare @OpenAmount money
Declare @OtherAppliedAmount money
Declare @CurrAppliedAmount money

-- cannot overapply the real invoice...calculate open amount without retainer amount (because it is recalced here)
Select @OpenAmount = ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(AmountReceived, 0)
 	From tInvoice (nolock) Where InvoiceKey = @InvoiceKey

-- calculate the other applications for this real invoice
Select @OtherAppliedAmount = sum(Amount) from tInvoiceAdvanceBill (nolock)
where  InvoiceKey = @InvoiceKey
and    AdvBillInvoiceKey <> @AdvBillInvoiceKey -- but not for this Adv Bill, it is being edited

-- now calculate the applied amounts being currently edited
select @CurrAppliedAmount = sum(Amount) 
from   #Applied

select @OtherAppliedAmount = isnull(@OtherAppliedAmount, 0)
      ,@CurrAppliedAmount = isnull(@CurrAppliedAmount, 0)

-- this can only be >= 0
if @CurrAppliedAmount < 0
	return -1

If @OpenAmount - (@OtherAppliedAmount + @CurrAppliedAmount ) < 0
	return -2

	-- same code as sptInvoiceAdvanceBillTaxGetList

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
	SELECT SalesTaxKey, ISNULL(SalesTax1Amount, 0), 1
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @AdvBillInvoiceKey  
	AND    ISNULL(SalesTaxKey, 0) > 0
	
	-- Sales Tax 2 on Header
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT SalesTax2Key, ISNULL(SalesTax2Amount, 0), 1
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @AdvBillInvoiceKey  
	AND    ISNULL(SalesTax2Key, 0) > 0
	
	-- Not so simple here for taxes on the lines, must be grouped
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT it.SalesTaxKey, ISNULL(SUM(it.SalesTaxAmount), 0), 1
	FROM   tInvoiceTax it (NOLOCK)
	WHERE  it.InvoiceKey = @AdvBillInvoiceKey
	AND    it.Type = 3
	GROUP BY it.SalesTaxKey
	
	-- Process the real invoice	
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT SalesTaxKey, 0, 1
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey  
	AND    ISNULL(SalesTaxKey, 0) > 0
	AND    SalesTaxKey NOT IN (SELECT SalesTaxKey FROM #tTax)
	
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT SalesTax2Key, 0, 1
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @InvoiceKey  
	AND    ISNULL(SalesTax2Key, 0) > 0
	AND    SalesTax2Key NOT IN (SELECT SalesTaxKey FROM #tTax)
	
	INSERT #tTax (SalesTaxKey, AdvBillAmount, EnableEdit)
	SELECT it.SalesTaxKey, 0, 1
	FROM   tInvoiceTax it (NOLOCK)
	WHERE  it.InvoiceKey = @InvoiceKey
	AND    it.Type = 3
	AND    it.SalesTaxKey NOT IN (SELECT SalesTaxKey FROM #tTax)
	GROUP BY it.SalesTaxKey
	
	UPDATE #tTax
	SET    #tTax.Amount = 
	ISNULL(
		(SELECT tInvoice.SalesTax1Amount
		FROM   tInvoice (NOLOCK)
		WHERE  tInvoice.InvoiceKey = @InvoiceKey  
		AND    tInvoice.SalesTaxKey = #tTax.SalesTaxKey)
	,0)

--select * from #tTax
	
	UPDATE #tTax
	SET    #tTax.Amount = 
	ISNULL(
		(SELECT tInvoice.SalesTax2Amount
		FROM   tInvoice (NOLOCK)
		WHERE  tInvoice.InvoiceKey = @InvoiceKey  
		AND    tInvoice.SalesTax2Key = #tTax.SalesTaxKey)
	,0)
	WHERE ISNULL(#tTax.Amount, 0) = 0
			 
--select * from #tTax
	 
	-- group again
	UPDATE #tTax
	SET    #tTax.Amount =
	ISNULL( 
		(SELECT SUM(it.SalesTaxAmount)
		FROM   tInvoiceTax it (NOLOCK)
		WHERE  it.InvoiceKey = @InvoiceKey  
		AND    it.Type = 3
		AND    it.SalesTaxKey = #tTax.SalesTaxKey
		)
	,0)
	WHERE ISNULL(#tTax.Amount, 0) = 0
	
--select * from #tTax
	
	UPDATE #tTax
	SET    #tTax.Amount = ISNULL(#tTax.Amount, 0)
	

--select * from #tTax
	
	-- Get amount for this adv bill/invoice/ tax
	UPDATE #tTax 
	SET    #tTax.AppliedAmount = 
	ISNULL(
		(SELECT iabt.Amount 
		FROM   tInvoiceAdvanceBillTax iabt (NOLOCK)
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
		FROM   tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey <> @InvoiceKey -- we could remove this, just for display purpose
		)
	,0)
	
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
		FROM   tInvoiceAdvanceBillTax iabt (NOLOCK)
		WHERE  iabt.AdvBillInvoiceKey <> @AdvBillInvoiceKey
		AND    iabt.SalesTaxKey = #tTax.SalesTaxKey
		AND    iabt.InvoiceKey = @InvoiceKey -- we could remove this, just for display purpose
		)
	,0)
	
--select * from #tTax
		
	UPDATE #tTax
	SET	   #tTax.UnappliedAmount = ISNULL(#tTax.Amount, 0) - ISNULL(#tTax.TotalAppliedAmount, 0)
	
	UPDATE #tTax
	SET	   #tTax.UnappliedAmount = 0
	WHERE  #tTax.UnappliedAmount < 0 

	-- now sales

	insert #tTax (SalesTaxKey, AdvBillAmount, Amount, EnableEdit)
	select 0, TotalNonTaxAmount, 0, 1
	from   tInvoice (nolock)
	where  InvoiceKey = @AdvBillInvoiceKey

	update #tTax
	set    #tTax.Amount = isnull((
		select TotalNonTaxAmount
		from   tInvoice (nolock)
		where  InvoiceKey = @InvoiceKey
	),0)
	where SalesTaxKey = 0   

	-- The taxes must be on both invoices
	UPDATE #tTax 
	SET    #tTax.EnableEdit = 0
	WHERE ISNULL(AdvBillAmount, 0) = 0 OR ISNULL(Amount, 0) = 0 

	declare @SalesApplied money
	declare @TaxesApplied money

	select @SalesApplied = Amount 
	from   tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iab.InvoiceKey = @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   tInvoiceAdvanceBillTax iabt (nolock)
	where  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iabt.InvoiceKey = @InvoiceKey
	  
	select @SalesApplied = isnull(@SalesApplied, 0) - isnull(@TaxesApplied, 0)
	update #tTax set AppliedAmount = isnull(@SalesApplied, 0) where SalesTaxKey = 0


	select @SalesApplied = sum(Amount) 
	from   tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iab.InvoiceKey <> @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   tInvoiceAdvanceBillTax iabt (nolock)
	where  iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    iabt.InvoiceKey <> @InvoiceKey
	
	select @SalesApplied = isnull(@SalesApplied, 0) - isnull(@TaxesApplied, 0)
	update #tTax set AdvBillTotalAppliedAmount = isnull(@SalesApplied, 0) where SalesTaxKey = 0



	select @SalesApplied = sum(Amount) 
	from   tInvoiceAdvanceBill iab (nolock)
	where  iab.AdvBillInvoiceKey <> @AdvBillInvoiceKey
	and    iab.InvoiceKey = @InvoiceKey
	
	select @TaxesApplied = sum(Amount)
	from   tInvoiceAdvanceBillTax iabt (nolock)
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


	-- Now start validation and inserts

	update #Applied
	set    #Applied.SalesTaxID = st.SalesTaxID
	from   tSalesTax st (nolock) 
	where  #Applied.SalesTaxKey = st.SalesTaxKey

	update #Applied
	set    #Applied.SalesTaxID = 'SALES'
	where  #Applied.SalesTaxKey = 0

	declare @kErrABOverApplied int		select @kErrABOverApplied = -1
	declare @kErrOverApplied int		select @kErrOverApplied = -2

	-- overwrite the applied amounts with what the user wants
	update  #Applied
	set     #Applied.Amount = ROUND(ABS(isnull(#Applied.Amount, 0)), 2)
	
	update  #tTax
	set     #tTax.AppliedAmount = #Applied.Amount
	from    #Applied
	where   #tTax.SalesTaxKey = #Applied.SalesTaxKey
	
	update  #Applied 
	set     #Applied.ErrorReturn = 0

	update  #Applied 
	set     #Applied.ErrorReturn = @kErrABOverApplied
	from    #tTax
	where   #Applied.SalesTaxKey = #tTax.SalesTaxKey
	and     #tTax.AppliedAmount >  #tTax.AdvBillUnappliedAmount  				

	update  #Applied 
	set     #Applied.ErrorReturn = @kErrOverApplied
	from    #tTax
	where   #Applied.SalesTaxKey = #tTax.SalesTaxKey
	and     #tTax.AppliedAmount >  #tTax.UnappliedAmount  				

	if exists (select 1 from #Applied where ErrorReturn <> 0) 
		return -3

	update #tTax
	set    UpdateFlag = 0

	update #tTax
	set    UpdateFlag = 1 -- Update
	where  AppliedAmount <> 0
	and    EnableEdit = 1

	delete tInvoiceAdvanceBillTax
	where  InvoiceKey = @InvoiceKey
	and    AdvBillInvoiceKey = @AdvBillInvoiceKey

	insert tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
	select @InvoiceKey, @AdvBillInvoiceKey, SalesTaxKey, AppliedAmount
	from   #tTax 
	where  #tTax.SalesTaxKey <> 0
	and    #tTax.UpdateFlag = 1

	declare @TotalApplied money

	select @TotalApplied = AppliedAmount -- sales applied
	from   #tTax 
	where  SalesTaxKey = 0

	-- + tax applied
	select @TotalApplied = isnull(@TotalApplied, 0) + sum(AppliedAmount)
	from   #tTax 
	where  #tTax.SalesTaxKey <> 0
	and    #tTax.UpdateFlag = 1

	update tInvoiceAdvanceBill
	set    Amount = isnull(@TotalApplied, 0)   
	where  InvoiceKey = @InvoiceKey
	and    AdvBillInvoiceKey = @AdvBillInvoiceKey

	Select @TotalApplied = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey and InvoiceKey <> AdvBillInvoiceKey

	Update tInvoice Set RetainerAmount = ISNULL(@TotalApplied, 0) Where InvoiceKey = @InvoiceKey

	exec sptInvoiceUpdateAmountPaid @InvoiceKey

	RETURN 1
GO
