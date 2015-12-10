USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxRealInvoice]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxRealInvoice]
	(
	@InvoiceKey int
	,@ParentInvoiceKey int 
	,@PercentageSplit decimal(24, 4)
	,@PaidInvoicesOnly int 
	,@CreateTemp int = 1
	,@TaxableSales money = null		-- calculated by spRptSalesTaxTaxableAmount (one per invoice, not based on flags)
	,@AmountReceived money = null   -- queried in spRptSalesTaxAnalysis
	,@StartDate smalldatetime = null -- to determine if we include receipts only (vs receipts + AB payments)
	,@EndDate smalldatetime = null
	,@Debug int = 0
	)
AS
	SET NOCOUNT ON

/*
  || When     Who Rel     What
  || 08/15/11 GHL 10.547  (118624) Calculating now TaxableAmounts in 2 modes
  ||                       1) Based on il.SalesTaxAmount <> 0
  ||                       2) Based on il.Taxable/il.Taxable2
  ||                      Also the purpose of this stored procedure is to calculate the impact 
  ||                      of Advance Bill application where taxes are involved (reduced sales and taxes)
  || 09/21/11 GHL 10.548 (121949) Fixed typo with Taxable2 flag
  ||						'and    il.Taxable2 = 1' instead of 'and    il.Taxable = 2'
*/ 

	if @CreateTemp = 1
		create table #realtaxes (
			InvoiceKey int null
			,SalesTaxKey int null
	
			-- this has to be displayed on the report 
			,InvoiceTotalAmount money null	-- Invoice Total on UI

			,TaxableAmount money null		-- Taxable Sales on UI
			,TaxableAmountNoFlags money null	-- Taxable Sales based on Flags on UI


			,SalesTaxAmount money null		-- Tax Amount on UI
			,PaidCollected money null		-- Collected/Paid on UI
			
			,CollectableAmount money null	-- Collectable Tax Amount on UI 
			,TaxablePlusTax money null      -- TaxablePlusTax on UI = CollectableTaxableAmount + CollectableAmount
			,CollectableTaxableAmount money null -- Collectable Taxable Sales
			,CollectableTaxableAmountNoFlags money null -- Collectable Taxable Sales for 2nd bottom grid
											
			,CollectableSales money null	-- Total Sales for 2nd bottom summary
			
			,TotalNonTaxAmount money null	-- needed for final summary section
			,OrigSalesTaxAmount money null
			,IABTAmount money null			-- debug only

			,SalesTaxType int null
		)


	declare @PostingDate datetime
	declare @InvoiceTotalAmount money
	declare @TotalNonTaxAmount money
	declare @IncludeABPayment int
	
	select @InvoiceTotalAmount = InvoiceTotalAmount
	     , @TotalNonTaxAmount = TotalNonTaxAmount
		 , @PostingDate = PostingDate
	from   tInvoice (nolock)
	where  InvoiceKey = @InvoiceKey

	if @StartDate is not null and @EndDate is not null
	begin  
		if @PostingDate >= @StartDate and @PostingDate <= @EndDate
			select @IncludeABPayment = 1
		else
			select @IncludeABPayment = 0
	end
	else
	begin
		-- in cases when we test a single invoice, we do not have dates
		select @IncludeABPayment = 1
	end

	insert #realtaxes(InvoiceKey, SalesTaxKey, SalesTaxType, OrigSalesTaxAmount)
	select InvoiceKey, SalesTaxKey, Type, Sum(SalesTaxAmount)
	from   tInvoiceTax (nolock)
	where  InvoiceKey = @InvoiceKey
	group by InvoiceKey, SalesTaxKey, Type

	-- Taxable Amounts based on flags
	update #realtaxes
	set    #realtaxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(@ParentInvoiceKey, @InvoiceKey)
		and    il.Taxable = 1	
	),0)
	where  #realtaxes.InvoiceKey = @InvoiceKey
	and		#realtaxes.SalesTaxType = 1
	
	update #realtaxes
	set    #realtaxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(@ParentInvoiceKey, @InvoiceKey)
		and    il.Taxable2 = 1	
	),0)
	where  #realtaxes.InvoiceKey = @InvoiceKey
	and		#realtaxes.SalesTaxType = 2
	
	update #realtaxes
	set    #realtaxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		       inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey 
		where  il.InvoiceKey = isnull(@ParentInvoiceKey, @InvoiceKey)
		and    ilt.SalesTaxKey = #realtaxes.SalesTaxKey
	),0)
	where  #realtaxes.InvoiceKey = @InvoiceKey
	and    #realtaxes.SalesTaxType = 3



	-- we will calculate the reduced amounts based on IAB applications with IABT applications
	-- reduced taxes must be calculated in #realtaxes because they are function of tax
	declare @ReducedSales money
	declare @ReducedTotal money
	declare @ReducedTaxableSales money
	declare @TotalIABAmount money -- Total amount applied to AB (sales + taxes)
	declare @TotalIABTAmount money -- Total taxes amount applied to AB 
	declare @TotalIABSAmount money -- Total sales amount applied to AB
	declare @TotalIABAmountPayment money -- Total amount applied to AB (considered as payments)
	

	create table #iab(AdvBillInvoiceKey int null, IABAmount money null, IABTAmount money null, IsABPayment int null)
	
	insert #iab(AdvBillInvoiceKey, IABAmount, IsABPayment)
	select AdvBillInvoiceKey, Amount, 0   
	from   tInvoiceAdvanceBill iab (nolock)
	where  iab.InvoiceKey = @InvoiceKey

	update #iab
	set    #iab.IABTAmount = ISNULL((
		select sum(iabt.Amount)
		from   tInvoiceAdvanceBillTax iabt (nolock)
		where  iabt.InvoiceKey = @InvoiceKey
		and    iabt.AdvBillInvoiceKey = #iab.AdvBillInvoiceKey 
	),0)

	update #iab
	set    #iab.IABAmount = isnull(IABAmount, 0)
	      ,#iab.IABTAmount = isnull(IABTAmount, 0)


	-- if no taxes, this was a payment
	update #iab 
	set    IsABPayment = 1
	where  IABTAmount = 0

	--select * from #iab

	select @TotalIABAmount = sum(IABAmount) from #iab
	select @TotalIABTAmount = sum(IABTAmount) from #iab
	select @TotalIABSAmount = isnull(@TotalIABAmount, 0) - isnull(@TotalIABTAmount, 0) 
	select @TotalIABAmountPayment = sum(IABAmount) from #iab where IsABPayment = 1
	
	-- to help with debugging
	if @Debug = 1
	begin
	update #realtaxes 
		set    #realtaxes.IABTAmount = ISNULL((
			select sum(Amount) from tInvoiceAdvanceBillTax iabt (nolock) where #realtaxes.SalesTaxKey = iabt.SalesTaxKey and iabt.InvoiceKey = @InvoiceKey  
		),0)  
		where #realtaxes.InvoiceKey = @InvoiceKey
	end

	-- ReducedSales = TotalNonTaxAmount - (sum(iab.Amount) - sum(iabt.Amount)) where IBATAmount <> 0, i.e. NOT a payment
	select @ReducedSales = sum(IABAmount - IABTAmount)
	from   #iab
	where  #iab.IsABPayment = 0

	select @ReducedSales = isnull(@TotalNonTaxAmount, 0) - isnull(@ReducedSales, 0) 
	
	-- ReducedTotal = InvoiceTotalAmount - sum(iab.Amount)  where IBATAmount <> 0
	select @ReducedTotal = sum(IABAmount)
	from   #iab
	where  #iab.IsABPayment = 0

	select @ReducedTotal = isnull(@InvoiceTotalAmount, 0) - isnull(@ReducedTotal, 0) 
	
	-- @ReducedTaxableSales = (@TaxableSales * @ReducedSales) / @TotalNonTaxAmount
	if @TotalNonTaxAmount <> 0
		select @ReducedTaxableSales = (@TaxableSales * @ReducedSales) / @TotalNonTaxAmount
	else
		select @ReducedTaxableSales = 0

	if @Debug = 1
	select @InvoiceTotalAmount as InvoiceTotalAmount, @TotalNonTaxAmount as TotalNonTaxAmount
	,@TaxableSales as TaxableSales, @AmountReceived as AmountReceived
	,@ReducedTotal as ReducedTotal
	,@ReducedSales as ReducedSales
	,@ReducedTaxableSales as ReducedTaxableSales
	,@TotalIABAmount as TotalIABAmount
	,@TotalIABTAmount as TotalIABTAmount
	,@TotalIABSAmount as TotalIABSAmount 
	,@TotalIABAmountPayment as TotalIABAmountPayment
	
	-- simple case when PaidInvoicesOnly = 0
	if @PaidInvoicesOnly = 0
	begin
		-- This is the Reduced Tax, has to be done in temp table
		-- One calculation per tax
		update #realtaxes
		set    #realtaxes.SalesTaxAmount = OrigSalesTaxAmount - ISNULL((
			select sum(iabt.Amount)
			from   tInvoiceAdvanceBillTax iabt (nolock)
			where  iabt.InvoiceKey = @InvoiceKey
			and    iabt.SalesTaxKey = #realtaxes.SalesTaxKey 
		),0)
		where #realtaxes.InvoiceKey = @InvoiceKey
	
		/*
		update #realtaxes
		set    InvoiceTotalAmount = @InvoiceTotalAmount
		      ,CollectableAmount = SalesTaxAmount	-- Collectable Amount on UI
			  ,TaxableAmount = @ReducedTaxableSales
		      ,CollectableTaxableAmount = @ReducedTaxableSales
			  ,CollectableSales = @ReducedSales
		where  #realtaxes.InvoiceKey = @InvoiceKey
		*/

		update #realtaxes
		set    InvoiceTotalAmount = @InvoiceTotalAmount
		      ,CollectableAmount = SalesTaxAmount	-- Collectable Amount on UI
			  ,CollectableSales = @ReducedSales -- goes to the second bottom grid
			  ,TaxableAmountNoFlags = @ReducedTaxableSales -- taxable sales not linked to flags
		where  #realtaxes.InvoiceKey = @InvoiceKey

		if @IncludeABPayment = 1
			update #realtaxes
			set    PaidCollected = isnull(@AmountReceived, 0)	+ isnull(@TotalIABAmountPayment, 0) 
			where #realtaxes.InvoiceKey = @InvoiceKey
		else
			update #realtaxes
			set    PaidCollected = isnull(@AmountReceived, 0)	
			where #realtaxes.InvoiceKey = @InvoiceKey
		
		-- now we need to recalc the taxable amounts linked to flags
		if @TotalNonTaxAmount <> 0
			update #realtaxes
			set    TaxableAmount = (TaxableAmount * @ReducedSales) / @TotalNonTaxAmount
			where  #realtaxes.InvoiceKey = @InvoiceKey
		else
			update #realtaxes
			set    TaxableAmount = 0
			where  #realtaxes.InvoiceKey = @InvoiceKey
		
		-- this has to be displayed on the report 
		update #realtaxes
		set   CollectableTaxableAmount = isnull(TaxableAmount, 0)
			  ,TaxablePlusTax = isnull(TaxableAmount, 0) + isnull(SalesTaxAmount, 0) -- TaxablePlusTax on UI 
			  ,CollectableTaxableAmountNoFlags = isnull(TaxableAmountNoFlags, 0)
		where #realtaxes.InvoiceKey = @InvoiceKey
		
	end

	if @PaidInvoicesOnly = 1
	begin
		-- Set first PaidCollected because everything depends on it
		if @IncludeABPayment = 1
			update #realtaxes
			set    PaidCollected = isnull(@AmountReceived, 0)	+ isnull(@TotalIABAmountPayment, 0) 
			where #realtaxes.InvoiceKey = @InvoiceKey
		else
			update #realtaxes
			set    PaidCollected = isnull(@AmountReceived, 0)	
			where #realtaxes.InvoiceKey = @InvoiceKey


		/* TAXES */

		-- This is still valid
		-- This is the Reduced Tax, has to be done in temp table, instead of in this SP above
		-- One calculation per tax
		update #realtaxes
		set    #realtaxes.SalesTaxAmount = OrigSalesTaxAmount - ISNULL((
			select sum(iabt.Amount)
			from   tInvoiceAdvanceBillTax iabt (nolock)
			where  iabt.InvoiceKey = @InvoiceKey
			and    iabt.SalesTaxKey = #realtaxes.SalesTaxKey 
		),0)
		where #realtaxes.InvoiceKey = @InvoiceKey


		-- Collectable amounts 
		if @ReducedTotal <> 0
			update #realtaxes
			set    #realtaxes.CollectableAmount = (SalesTaxAmount  * PaidCollected) / @ReducedTotal
			where #realtaxes.InvoiceKey = @InvoiceKey
		 else
		 	update #realtaxes
			set    #realtaxes.CollectableAmount = 0
			where #realtaxes.InvoiceKey = @InvoiceKey
		
		
		/* TAXABLE SALES */

		-- these do not depend on the Taxable flags
		update #realtaxes
		set    TaxableAmountNoFlags = @ReducedTaxableSales -- this is used for 2nd bottom grid
		where  #realtaxes.InvoiceKey = @InvoiceKey

		if @ReducedTotal <> 0
			update #realtaxes
			set    #realtaxes.CollectableTaxableAmountNoFlags = (TaxableAmountNoFlags * PaidCollected) / @ReducedTotal
			where #realtaxes.InvoiceKey = @InvoiceKey
		 else
		 	update #realtaxes
			set    #realtaxes.CollectableTaxableAmountNoFlags = 0
			where #realtaxes.InvoiceKey = @InvoiceKey

		
		-- these depend on the Taxable flags
		if @TotalNonTaxAmount <> 0
			update #realtaxes
			set    TaxableAmount = (TaxableAmount * @ReducedSales) / @TotalNonTaxAmount
			where  #realtaxes.InvoiceKey = @InvoiceKey
		else
			update #realtaxes
			set    TaxableAmount = 0
			where  #realtaxes.InvoiceKey = @InvoiceKey

		if @ReducedTotal <> 0
			update #realtaxes
			set    #realtaxes.CollectableTaxableAmount = (TaxableAmount * PaidCollected) / @ReducedTotal
			where #realtaxes.InvoiceKey = @InvoiceKey
		 else
		 	update #realtaxes
			set    #realtaxes.CollectableTaxableAmount = 0
			where #realtaxes.InvoiceKey = @InvoiceKey

		
		if @ReducedTotal <> 0
			update #realtaxes
			set    #realtaxes.CollectableSales = (@ReducedSales * PaidCollected) / @ReducedTotal
			where #realtaxes.InvoiceKey = @InvoiceKey
		 else
		 	update #realtaxes
			set    #realtaxes.CollectableSales = 0
			where #realtaxes.InvoiceKey = @InvoiceKey

		-- this has to be displayed on the report 
		update #realtaxes
		set    #realtaxes.InvoiceTotalAmount = @InvoiceTotalAmount
			--,TaxableAmount money null			-- Taxable Sales on UI
			--,SalesTaxAmount money null		-- Tax Amount on UI
			--,PaidCollected = isnull(@AmountReceived, 0) + isnull(@TotalIABAmountPayment, 0) -- should we also include AdvBills???????
			--,CollectableAmount money null	-- Collectable Amount on UI
			,TaxablePlusTax = isnull(CollectableTaxableAmount, 0) + isnull(CollectableAmount, 0) -- TaxablePlusTax on UI 
		where  #realtaxes.InvoiceKey = @InvoiceKey

	end

	if @Debug = 1
	select * from #realtaxes

	RETURN
GO
