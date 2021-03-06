USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxAB]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxAB]
	(
	@CompanyKey int
	,@SalesTaxKey int
	,@StartDate datetime
	,@EndDate datetime
	,@GLCompanyKey int = -1 -- -1 All, 0 Blank, >0 
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel     What
  || 03/12/10 GHL 10.520  Created for new logic for Advance Bills in spRptSalesTaxAnalysis
  || 08/23/10 GHL 10.534  (87948) Issue at Hawse Design was that the Collected/Paid was missing the AB contribution
  ||                      My findings were that the reason for that, was that the Taxable fields were resulting in SalesTaxAmount = 0
  ||                      I removed all the checks on SalesTaxAmount = 0 
  || 04/05/11 GHL 10.542  (107282) Double dipping on taxes in the following situation:
  ||                      2 AB invoices $5000 tax=$327 and $2500/$163.55 receipts fully applied
  ||                      1 real invoice $7500 tax=$490.55
  ||                      The report shows $490.55 * 2 for the 3 invoices
  ||                      Decided to rollback changes made for 87948
  */

  /*
  Initial reason for this stored procedure

  An Advance Bill may not have sales taxes 
  A Real Invoice applied to this Advance Bill may have sales taxes
  When receipts are applied to the AB, we must recognize sales taxes
  This sp merges 2 things: receipts on AB invoices (and no taxes) with taxes on Real invoices

  Also a tech note:
  Initially tInvoiceTax records were created only if the Taxable fields were set on the invoice lines
  The Australians requested that tInvoiceTax records would be created if SalesTaxKey, SalesTax2Key 
  were set on the header, this is why I delete records where SalesTaxAmount = 0 in the original design
  ....This is why @ShowTaxAppliedLinesOnly was added to sptRptSalesTaxAnalysis

  */

	/* Assume done
	
	CREATE TABLE #abtaxes (
		ABInvoiceKey int null
		,ABInvoiceTotalAmount money null
		,CheckKey int null
		,CAApplAmount money null
		,InvoiceKey int null
		,ParentInvoiceKey int null
        ,PercentageSplit decimal(24,4) null
		,ABApplAmount money null
		,InvoiceTotalAmount money null
		,SalesTaxKey int null
		,SalesAmount money null
		,SalesTaxAmount money null
		,SalesTaxType INT NULL  -- 1 SalesTax1, 2 SalesTax2, 3 Other Taxes 
		,CalculatedTaxAmount money null
		,CalculatedTaxablePlusTax money null
		,CalculatedCollectedAmount money null
		,CheckDate smalldatetime null
		,UpdateFlag int null
		)

	*/
	
	
	create table #invoice (InvoiceKey int null, ABInvoiceKey int null, InvoiceID int NOT NULL IDENTITY(1,1))
	create table #check (CheckKey int null, ABInvoiceKey int null, CheckID int NOT NULL IDENTITY(1,1))
	create table #invoice_check (InvoiceKey int null, CheckKey int null, ABInvoiceKey int null)
	
	-- list of regular invoices linked to Advance Bill invoices 
	insert #invoice (InvoiceKey, ABInvoiceKey)
	select i.InvoiceKey, iab.AdvBillInvoiceKey
	from   tInvoice i (nolock)
	    inner join tInvoiceAdvanceBill iab (nolock) on i.InvoiceKey = iab.InvoiceKey
	where  i.CompanyKey = @CompanyKey
	and    i.PostingDate >= @StartDate
	and    i.PostingDate <= @EndDate
	
	
	-- list of checks applied to AB invoices listed above

	insert #check (CheckKey, ABInvoiceKey)
	select ca.CheckKey, iab.AdvBillInvoiceKey
	from   tCheck c (nolock)
		inner join tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
	    inner join tInvoiceAdvanceBill iab (nolock) on i.InvoiceKey = iab.AdvBillInvoiceKey
	where  i.CompanyKey = @CompanyKey
	-- Note: c.PostingDate >= @StartDate could be removed 
	-- and we could insert directly into #invoice_check
	-- this would probably eliminate the logic in the 2 loops below
	and    c.PostingDate >= @StartDate  
	and    c.PostingDate <= @EndDate
	
	--select * from #invoice
	--select * from #check

	declare @InvoiceID int
	declare @CheckID int
	declare @ABInvoiceKey int
	declare @InvoiceKey int
	declare @CheckKey int
	
	select @InvoiceID = -1
	while (1=1)
	begin
		select @InvoiceID = min(InvoiceID)
		from   #invoice 
		where  InvoiceID > @InvoiceID
		
		if @InvoiceID is null
			break
			
		select @InvoiceKey = InvoiceKey
		      ,@ABInvoiceKey = ABInvoiceKey
		from   #invoice 
		where  InvoiceID = @InvoiceID
		 
		select @CheckKey = -1
		while (1=1)
		begin
			select @CheckKey = min(ca.CheckKey)
			from   tCheckAppl ca (nolock)
				inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey
			where ca.InvoiceKey = @ABInvoiceKey
			and   ca.CheckKey > @CheckKey
			and   c.PostingDate <= @EndDate
			
			if @CheckKey is null
				break
				
			if not exists (select 1 from #invoice_check 
			where InvoiceKey = @InvoiceKey and CheckKey = @CheckKey and ABInvoiceKey = @ABInvoiceKey)
			 	insert #invoice_check (InvoiceKey, CheckKey, ABInvoiceKey)
			 	values (@InvoiceKey, @CheckKey, @ABInvoiceKey)
			 	 
		end   
		      	
	end

	select @CheckID = -1
	while (1=1)
	begin
		select @CheckID = min(CheckID)
		from   #check 
		where  CheckID > @CheckID
		
		if @CheckID is null
			break
			
		select @CheckKey = CheckKey
		      ,@ABInvoiceKey = ABInvoiceKey
		from   #check 
		where  CheckID = @CheckID
		 
		select @InvoiceKey = -1
		while (1=1)
		begin
			select @InvoiceKey = min(iab.InvoiceKey)
			from   tInvoiceAdvanceBill iab (nolock) 
				inner join tInvoice i (nolock) on iab.InvoiceKey = i.InvoiceKey
			where iab.AdvBillInvoiceKey = @ABInvoiceKey
			and   i.InvoiceKey > @InvoiceKey
			and   i.PostingDate <= @EndDate
			
			if @InvoiceKey is null
				break
				
			if not exists (select 1 from #invoice_check 
			where InvoiceKey = @InvoiceKey and CheckKey = @CheckKey and ABInvoiceKey = @ABInvoiceKey)
			 	insert #invoice_check (InvoiceKey, CheckKey, ABInvoiceKey)
			 	values (@InvoiceKey, @CheckKey, @ABInvoiceKey)
			 	 
		end   
		      	
	end
	
	--select * from #invoice_check

	insert #abtaxes (ABInvoiceKey, ABInvoiceTotalAmount
	    , CheckKey, CAApplAmount
		, InvoiceKey, ParentInvoiceKey, PercentageSplit
		, ABApplAmount, InvoiceTotalAmount, SalesAmount
		, SalesTaxKey, SalesTaxType, SalesTaxAmount, UpdateFlag)	
		
	select ab_i.InvoiceKey, ab_i.InvoiceTotalAmount
		, ca.CheckKey, ca.Amount 
		, real_i.InvoiceKey, real_i.ParentInvoiceKey, real_i.PercentageSplit 
		, iab.Amount, real_i.InvoiceTotalAmount, 0
		, real_tax.SalesTaxKey, real_tax.Type, real_tax.SalesTaxAmount, 0 
		
	from  #invoice_check ic (nolock)
	inner join tInvoice ab_i (nolock) on ic.ABInvoiceKey = ab_i.InvoiceKey 
	inner join tInvoice real_i (nolock) on ic.InvoiceKey = real_i.InvoiceKey
	inner join tInvoiceAdvanceBill iab (nolock) on ic.ABInvoiceKey = iab.AdvBillInvoiceKey and ic.InvoiceKey = iab.InvoiceKey
	inner join tCheckAppl ca (nolock) on ic.ABInvoiceKey = ca.InvoiceKey and ic.CheckKey = ca.CheckKey 
	
	-- taxes for the real invoice
	inner join (
		select it.InvoiceKey , it.SalesTaxKey, it.Type, SUM(it.SalesTaxAmount) as SalesTaxAmount
		from   tInvoiceTax it (nolock)
		   inner join tInvoice t_i (nolock) on it.InvoiceKey = t_i.InvoiceKey
		where	t_i.CompanyKey = @CompanyKey
		-- Request from Australians and MW that if the lines are not taxable
		-- we must have tInvoiceTax records even if SalesTaxKey <> 0
		-- filter them out here
		--and     it.SalesTaxAmount <> 0    -- REMOVED! for 87948
		and     it.SalesTaxAmount <> 0    -- PUT BACK! for 107282
		group by it.InvoiceKey, it.SalesTaxKey, it.Type
		) as real_tax on real_i.InvoiceKey = real_tax.InvoiceKey
	
	where (@SalesTaxKey = 0 or real_tax.SalesTaxKey = @SalesTaxKey) 
	and	 (@GLCompanyKey = -1 or isnull(ab_i.GLCompanyKey, 0) = @GLCompanyKey) 
	
	
	-- we must correct the sales part just like we do in spRptSalesTaxAnalysis
	update #abtaxes
	set    #abtaxes.SalesAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#abtaxes.ParentInvoiceKey, #abtaxes.InvoiceKey)
		and    il.Taxable = 1	
	),0)
	where  #abtaxes.SalesTaxType = 1
	
	update #abtaxes
	set    #abtaxes.SalesAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#abtaxes.ParentInvoiceKey, #abtaxes.InvoiceKey)
		and    il.Taxable = 1	
	),0)
	where  #abtaxes.SalesTaxType = 2

	update #abtaxes
	set    #abtaxes.SalesAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		       inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey 
		where  il.InvoiceKey = isnull(#abtaxes.ParentInvoiceKey, #abtaxes.InvoiceKey)
		and    ilt.SalesTaxKey = #abtaxes.SalesTaxKey
	),0)
	where  #abtaxes.SalesTaxType = 3

	UPDATE #abtaxes
	SET    #abtaxes.SalesAmount = (#abtaxes.SalesAmount * #abtaxes.PercentageSplit) / 100
	WHERE  ISNULL(#abtaxes.ParentInvoiceKey, 0) > 0   

	--select * from #abtaxes
	
	-- only take AB invoice if the tax is not on the AB, ie if AB tInvoiceTax.SalesTaxAmount = 0
	-- All this process is done for AB invoices without Sales Taxes, otherwise there is a risk of double dipping
	update #abtaxes
	set    #abtaxes.UpdateFlag = 1
	from   tInvoiceTax it (nolock)
	where  #abtaxes.ABInvoiceKey = it.InvoiceKey
	and    #abtaxes.SalesTaxKey = it.SalesTaxKey
	and    it.SalesTaxAmount <> 0
	
	--delete #abtaxes where UpdateFlag = 1 -- REMOVED! for 87948
	delete #abtaxes where UpdateFlag = 1 -- PUT BACK! for 107282

	/*
	Explanation of the calculation
	After payment of an Adv Bill invoice, the application of a real invoice is worth
	
                              ABApplAmount * CAApplAmount
    CalculatedABApplAmount = ---------------------  
                              ABInvoiceTotalAmount
	
	then
	
                            CalculatedABApplAmount * SalesTaxAmount
     CalculatedTaxAmount = ---------------------------------------
							        InvoiceTotalAmount    
	
	same calculations for the sales part
	*/
	
	update #abtaxes
	set    CalculatedTaxAmount = (ABApplAmount * CAApplAmount * SalesTaxAmount) / (ABInvoiceTotalAmount * InvoiceTotalAmount)
	where (ABInvoiceTotalAmount * InvoiceTotalAmount) <> 0
	
	update #abtaxes
	set    CalculatedTaxAmount = 0
	where (ABInvoiceTotalAmount * InvoiceTotalAmount) = 0
				
	--delete #abtaxes where CalculatedTaxAmount = 0 -- REMOVED! for 87948
	delete #abtaxes where CalculatedTaxAmount = 0 -- PUT BACK for 107282

	update #abtaxes
	set    CalculatedTaxablePlusTax = (ABApplAmount * CAApplAmount * (SalesAmount + SalesTaxAmount) )/ (ABInvoiceTotalAmount * InvoiceTotalAmount)
	where (ABInvoiceTotalAmount * InvoiceTotalAmount) <> 0
	
	update #abtaxes
	set    CalculatedTaxablePlusTax = 0
	where (ABInvoiceTotalAmount * InvoiceTotalAmount) = 0
				
	update #abtaxes
	set    CalculatedCollectedAmount = (ABApplAmount * CAApplAmount ) / ABInvoiceTotalAmount 
	where  ABInvoiceTotalAmount  <> 0
	
	update #abtaxes
	set    CalculatedCollectedAmount = 0
	where  ABInvoiceTotalAmount = 0
				
				
	update #abtaxes
	set    #abtaxes.CheckDate = c.CheckDate
	from   tCheck c (nolock) 
	where  #abtaxes.CheckKey = c.CheckKey 
				
	--select * from #abtaxes

	RETURN 1
GO
