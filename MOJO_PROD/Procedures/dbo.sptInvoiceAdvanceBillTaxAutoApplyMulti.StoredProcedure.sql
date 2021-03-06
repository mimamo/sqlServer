USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxAutoApplyMulti]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxAutoApplyMulti]
	(
	@InvoiceKey int -- This is the current invoice, should be 0 if new
	,@IsAdvanceBill int
	,@InvoiceTotalAmount money
	)
AS --Encrypt
	SET NOCOUNT ON

/*
|| When     Who Rel    What
|| 10/20/10 GHL 10.357 Added checking of sales amount on advance bills
|| 11/01/10 GHL 10.537 Corrected AppliedSalesTax
|| 11/02/10 GHL 10.537 Added protection against nulls
|| 06/07/13 GHL 10.568 (177255) In the case when the current invoice is a real invoice
||                     and the other invoices are advance bills, I added some code to reduce the application amount
||                     when we try to apply too much of the Sales ammount on the AB
*/

/*
	--most of the data about the current invoice will be on the client side and would have been gathered in the temp tables
	--however the data about the other invoices is only in the database and will have to be pulled and merged in the temp tables

	--I assume that the inputs are:
	
	-- the current taxes for the invoice...could come from tInvoiceLineTax or tInvoiceTax... so take always SUM(Amount) 
	CREATE TABLE #tInvoiceTax (InvoiceKey int null, SalesTaxKey int null, SalesTaxAmount money null)

	-- the current + new IAB records for the invoice
	CREATE TABLE #tInvoiceAdvanceBill (InvoiceKey int null, AdvBillInvoiceKey int null
		, Amount money null, InvoiceTotalAmount money null, TotalNonTaxAmount money null, OpenSalesTax money null, AppliedSalesTax money null, IsNew int null, HasErrors int null)

	-- the current IABT records for the invoice (the new have to be recalculated)
	CREATE TABLE #tInvoiceAdvanceBillTax (InvoiceKey int null, AdvBillInvoiceKey int null, SalesTaxKey int null
		, Amount money null, IsNew int null, , HasErrors int null)


	--Examples:
	insert #tInvoiceTax (InvoiceKey, SalesTaxKey, SalesTaxAmount) values (1064, 7, 975.60)
	insert #tInvoiceTax (InvoiceKey, SalesTaxKey, SalesTaxAmount) values (1064, 8, 1070.78)
	
	insert #tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount, IsNew) values (693, 1064, 100, 0)
	insert #tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount, IsNew) values (709, 1064, 100, 1)
	 
    insert #tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, Amount, SalesTaxKey, IsNew) values (693, 1064, 7.84, 7, 0)
	
*/


	-- we only have in the db the records for InvoiceKey
	
	Declare @AdvBillAmount money
	Declare @AdvBillTaxAmount money

	-- calculate the TotalNonTaxAmount here if this is an AB
	declare @TotalNonTaxAmount money
	declare @SalesTaxAmount money
	declare @OverAppliedSales money

	if @IsAdvanceBill = 1
	begin
		select @SalesTaxAmount = SUM(SalesTaxAmount)
		from   #tInvoiceTax 
		where  InvoiceKey = @InvoiceKey

		select @TotalNonTaxAmount = isnull(@InvoiceTotalAmount, 0) - isnull(@SalesTaxAmount, 0)
		
		select @AdvBillAmount = sum(Amount)
		from   #tInvoiceAdvanceBill 
		Where  AdvBillInvoiceKey = @InvoiceKey
		and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications
		and    IsNew = 0

	end
	 
	 -- protection against nulls
	 select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)
	       ,@TotalNonTaxAmount = isnull(@TotalNonTaxAmount, 0)
		   ,@AdvBillAmount = isnull(@AdvBillAmount, 0)

	-- If this is an AdvanceBill, we will need the InvoiceTotalAmount for each real invoice (to calc math proportion during tax insert)
	If @IsAdvanceBill = 1
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.InvoiceTotalAmount = i.InvoiceTotalAmount
		from   tInvoice i (nolock)
		where  #tInvoiceAdvanceBill.InvoiceKey = i.InvoiceKey
	
	-- different issue here but same table, we need InvoiceTotalAmount and TotalNonTaxAmount to determine if we overapplied sales 
	If @IsAdvanceBill = 0
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.InvoiceTotalAmount = i.InvoiceTotalAmount
		      ,#tInvoiceAdvanceBill.TotalNonTaxAmount = i.TotalNonTaxAmount
		from   tInvoice i (nolock)
		where  #tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey


	-- Insert the missing tax records
	
	If @IsAdvanceBill = 1
		-- the current invoice is AB
		insert #tInvoiceTax (InvoiceKey, SalesTaxKey, SalesTaxAmount)
		select it.InvoiceKey, it.SalesTaxKey, it.SalesTaxAmount
		from   tInvoiceTax it (nolock)
		where  it.InvoiceKey in (select InvoiceKey from #tInvoiceAdvanceBill)  
		and    it.InvoiceKey <> @InvoiceKey

	else
		-- the current invoice is real
		insert #tInvoiceTax (InvoiceKey, SalesTaxKey, SalesTaxAmount)
		select it.InvoiceKey, it.SalesTaxKey, it.SalesTaxAmount
		from   tInvoiceTax it (nolock)
		where  it.InvoiceKey in (select AdvBillInvoiceKey from #tInvoiceAdvanceBill)  
		and    it.InvoiceKey <> @InvoiceKey 


	-- Insert the missing tax records from tInvoiceAdvanceBillTax..this concerns only the AB invoices
	
	If @IsAdvanceBill = 1
		-- the current invoice is AB
		-- everything should be in the temp db
		select @IsAdvanceBill = 1
	else
		-- the current invoice is real
		-- we will need to calculate what is already applied for the AdvBill other than this invoice
		insert #tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount, IsNew)
		select iabt.InvoiceKey, iabt.AdvBillInvoiceKey, iabt.SalesTaxKey, iabt.Amount, 0
		from   tInvoiceAdvanceBillTax iabt (nolock)
		where  iabt.AdvBillInvoiceKey in (select AdvBillInvoiceKey from #tInvoiceAdvanceBill)  
		and    iabt.InvoiceKey <> @InvoiceKey

	declare @IABAmount money
	declare @LoopInvoiceKey int
	declare @AdvBillInvoiceKey int
	
	if @IsAdvanceBill = 1
	begin
		select @LoopInvoiceKey = -1

		while (1=1)
		begin
			-- LoopInvoiceKey is a real invoice
			select @LoopInvoiceKey = min(InvoiceKey)
			from   #tInvoiceAdvanceBill 
			where  InvoiceKey > @LoopInvoiceKey
			and    IsNew = 1

			if @LoopInvoiceKey is null
				break

			select @IABAmount = Amount
			      ,@InvoiceTotalAmount = InvoiceTotalAmount
			from   #tInvoiceAdvanceBill 
			where  InvoiceKey = @LoopInvoiceKey

			select @IABAmount = isnull(@IABAmount, 0)
			      ,@InvoiceTotalAmount = isnull(@InvoiceTotalAmount, 0)

			-- LoopInvoiceKey is a real invoice
			-- InvoiceKey is a advance bill invoice
			exec sptInvoiceAdvanceBillTaxAutoApplyTemp @LoopInvoiceKey, @InvoiceKey, @IABAmount, @InvoiceTotalAmount

			-- after each loop, determine if we did not over apply the sales on the AB
			select @AdvBillAmount = isnull(@AdvBillAmount, 0) + isnull(@IABAmount, 0)

			select @AdvBillTaxAmount = sum(Amount)
			from   #tInvoiceAdvanceBillTax (NOLOCK)
			Where  AdvBillInvoiceKey = @InvoiceKey
			and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

			if (isnull(@AdvBillAmount,0) - isnull(@AdvBillTaxAmount,0)) > isnull(@TotalNonTaxAmount, 0) 
			begin
				-- flag this invoice and all invoices after this one as bad
				update #tInvoiceAdvanceBill set HasErrors = 1 where InvoiceKey >= @LoopInvoiceKey
				update #tInvoiceAdvanceBillTax set HasErrors = 1 where InvoiceKey >= @LoopInvoiceKey
				
				-- and break because we are over applying the sales amount 
				break
			end 
		end

	end
	else
	begin
		-- the invoice is a real invoice

		select @AdvBillInvoiceKey = -1

		while (1=1)
		begin
			-- LoopInvoiceKey is a Advance Bill invoice
			select @AdvBillInvoiceKey = min(AdvBillInvoiceKey)
			from   #tInvoiceAdvanceBill 
			where  AdvBillInvoiceKey > @AdvBillInvoiceKey
			and    IsNew = 1

			if @AdvBillInvoiceKey is null
				break

			select @IABAmount = Amount
			      ,@TotalNonTaxAmount = TotalNonTaxAmount
			from   #tInvoiceAdvanceBill 
			where  AdvBillInvoiceKey = @AdvBillInvoiceKey

			select @IABAmount = isnull(@IABAmount, 0)
			      ,@TotalNonTaxAmount = isnull(@TotalNonTaxAmount, 0)

			-- Loop InvoiceKey AdvBillInvoiceKey is a Advance Bill invoice
			-- InvoiceKey is a real invoice, @InvoiceTotalAmount is amount on real invoice
			exec sptInvoiceAdvanceBillTaxAutoApplyTemp @InvoiceKey, @AdvBillInvoiceKey, @IABAmount, @InvoiceTotalAmount

			-- now check whether we over applied the sales on this AB
			
			-- careful here because we do not have everything we need in #tInvoiceAdvanceBill
			-- so go after the permanent tInvoiceAdvanceBill
			 
			select @AdvBillAmount = sum(Amount)
			from   tInvoiceAdvanceBill (NOLOCK)
			Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
			and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

			-- and add the current appl
			select @AdvBillAmount = isnull(@AdvBillAmount,0) + isnull(@IABAmount, 0)
			
			select @AdvBillTaxAmount = sum(Amount)
			from   #tInvoiceAdvanceBillTax (NOLOCK)
			Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
			and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

			if (isnull(@AdvBillAmount,0) - isnull(@AdvBillTaxAmount,0)) > isnull(@TotalNonTaxAmount,0)
			begin
				-- calc the sales over applied on the AB
				select @OverAppliedSales = isnull(@AdvBillAmount,0) - isnull(@AdvBillTaxAmount,0) - isnull(@TotalNonTaxAmount,0)

				-- try to reduce the IAB applic amount
				select @IABAmount = @IABAmount - @OverAppliedSales 

				-- recalc the IAB tax amount for this appl
				select @AdvBillTaxAmount = sum(Amount)
				from   #tInvoiceAdvanceBillTax (NOLOCK)
				Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
				and    InvoiceKey = @InvoiceKey

				-- if the total IAB amount > 0 and we can cover the tax applied, apply that reduced value 
				if (@IABAmount > 0 and @IABAmount >= @AdvBillTaxAmount) 
				begin 
					update #tInvoiceAdvanceBill 
					set    Amount = @IABAmount
					      ,UnappliedAmount = OriginalOpenAmount - @IABAmount
					where  AdvBillInvoiceKey = @AdvBillInvoiceKey
				end
				else
				begin
					-- flag this invoice and ONLY THIS ONE as bad
					update #tInvoiceAdvanceBill set HasErrors = 1 where AdvBillInvoiceKey = @AdvBillInvoiceKey
					update #tInvoiceAdvanceBillTax set HasErrors = 1 where AdvBillInvoiceKey = @AdvBillInvoiceKey
				end

				-- and DO NOT break because we have to process the other ones  
				--break
			end

		end


	end
	
	-- the results should be in #tInvoiceAdvanceBillTax

	-- Calculate AppliedSalesTax and OpenSalesTax

	if @IsAdvanceBill = 1
		-- the current invoice is ab, we want info on real invoices
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.AppliedSalesTax = ISNULL((
			select sum(iabt.Amount)
			from   #tInvoiceAdvanceBillTax iabt
			where  #tInvoiceAdvanceBill.InvoiceKey = iabt.InvoiceKey        
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

	else
		-- the current invoice is real, we want info on adv bill
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.AppliedSalesTax = ISNULL((
			select sum(iabt.Amount)
			from   #tInvoiceAdvanceBillTax iabt
			where  #tInvoiceAdvanceBill.AdvBillInvoiceKey = iabt.AdvBillInvoiceKey        
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

	if @IsAdvanceBill = 1
		-- the current invoice is ab, we want info on real invoices
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.OpenSalesTax = ISNULL((
			select sum(it.SalesTaxAmount)
			from   #tInvoiceTax it
			where  #tInvoiceAdvanceBill.InvoiceKey = it.InvoiceKey        
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

	else
		-- the current invoice is real, we want info on adv bill
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.OpenSalesTax = ISNULL((
			select sum(it.SalesTaxAmount)
			from   #tInvoiceTax it
			where  #tInvoiceAdvanceBill.AdvBillInvoiceKey = it.InvoiceKey        
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

    update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.OpenSalesTax = isnull(#tInvoiceAdvanceBill.OpenSalesTax, 0) - isnull(#tInvoiceAdvanceBill.AppliedSalesTax, 0)
	where  #tInvoiceAdvanceBill.IsNew = 1

	-- Now recalc the AppliedSalesTax for this each application only

	if @IsAdvanceBill = 1
		-- the current invoice is ab, we want info on real invoices
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.AppliedSalesTax = ISNULL((
			select sum(iabt.Amount)
			from   #tInvoiceAdvanceBillTax iabt
			where  #tInvoiceAdvanceBill.InvoiceKey = iabt.InvoiceKey
			and    #tInvoiceAdvanceBill.AdvBillInvoiceKey = iabt.AdvBillInvoiceKey        
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

	else
		-- the current invoice is real, we want info on adv bill
		update #tInvoiceAdvanceBill
		set    #tInvoiceAdvanceBill.AppliedSalesTax = ISNULL((
			select sum(iabt.Amount)
			from   #tInvoiceAdvanceBillTax iabt
			where  #tInvoiceAdvanceBill.AdvBillInvoiceKey = iabt.AdvBillInvoiceKey        
			and    #tInvoiceAdvanceBill.InvoiceKey = iabt.InvoiceKey
		),0)
		where #tInvoiceAdvanceBill.IsNew = 1

	--select * from #tInvoiceAdvanceBill
	--select * from #tInvoiceAdvanceBillTax

	if exists (select 1 from #tInvoiceAdvanceBill where isnull(HasErrors, 0) != 0)
		RETURN -1
	else
		RETURN 1
GO
