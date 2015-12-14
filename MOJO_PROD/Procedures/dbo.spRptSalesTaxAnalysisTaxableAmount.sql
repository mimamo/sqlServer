USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxAnalysisTaxableAmount]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxAnalysisTaxableAmount]
	(
	@CompanyKey int
	,@Debug int = 0
	)
	
AS
	SET NOCOUNT ON

/* Assume	

create table #invoices (
	InvoiceKey int null 
	,ParentInvoiceKey int null -- needed to get to the parent invoice to calc TaxableSales
	,PercentageSplit decimal(24,4) null
	,AmountReceived money null
	,PaymentDate datetime null
	,HasAB int
	,HasABNoTax int
	,HasABTax int
	,TaxableSales money null
	,Type varchar(50) null --'Collected Taxes' or 'Paid Taxes'
) 

The purpose of this stored procedure is to calculate TaxableSales independently of the Taxable/Taxable2 flags

insert #invoices (InvoiceKey, HasAB, HasABTax, Type) values (623, 1, 1, 'Collected Taxes')

exec spRptSalesTaxAnalysisTaxableAmount 100

*/
	update #invoices
	set    #invoices.HasAB = isnull(#invoices.HasAB, 0)
	      ,#invoices.HasABNoTax = isnull(#invoices.HasABNoTax, 0)
		  ,#invoices.HasABTax = isnull(#invoices.HasABTax, 0)

	-- make sure that ParentInvoiceKey is not 0
	update #invoices
	set    #invoices.ParentInvoiceKey = null
	where  #invoices.ParentInvoiceKey = 0

	-- I assume that this is not function of the sales tax applied

	-- process first the general case when there are no advance bill applications
	
	update #invoices
	set    #invoices.TaxableSales = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#invoices.ParentInvoiceKey, #invoices.InvoiceKey)  
		and    il.SalesTaxAmount <> 0
		),0)
	where #invoices.Type = 'Collected Taxes'
	and   #invoices.HasAB = 0 -- no AB application

	-- process then the case when there are advance bill applications AND no taxes

	update #invoices
	set    #invoices.TaxableSales = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#invoices.ParentInvoiceKey, #invoices.InvoiceKey) 
		and    il.SalesTaxAmount <> 0
		),0)
	where #invoices.Type = 'Collected Taxes'
	and   #invoices.HasAB = 1 -- AB application
	and   #invoices.HasABTax = 0 -- no taxes
	 
	-- take in account % split
	UPDATE #invoices
	SET    #invoices.TaxableSales = (#invoices.TaxableSales * #invoices.PercentageSplit) / 100
	WHERE  #invoices.Type = 'Collected Taxes'
	AND    ISNULL(#invoices.ParentInvoiceKey, 0) > 0   

	update #invoices
	set    #invoices.TaxableSales = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		where  vd.VoucherKey = #invoices.InvoiceKey 
		and    vd.SalesTaxAmount <> 0
		),0)
	where #invoices.Type = 'Paid Taxes'
	
	-- now look at the advance bill applications with taxes
	
	create table #lines(InvoiceKey int null, InvoiceLineKey int null, TotalAmount money null
			, SalesTaxKey int null, SalesTaxAmount money null, Taxable int null, UpdateFlag int null)

	create table #iabt(InvoiceKey int null, SalesTaxKey int null, Amount money null, RealTaxAmount money null, Taxable int null)
	
	insert #lines (InvoiceKey, InvoiceLineKey, SalesTaxKey, SalesTaxAmount, Taxable)
	select it.InvoiceKey, it.InvoiceLineKey, it.SalesTaxKey, it.SalesTaxAmount, 0
	from   tInvoiceTax it (nolock)
	inner join #invoices i on it.InvoiceKey = isnull(i.ParentInvoiceKey, i.InvoiceKey)
	where i.HasAB = 1
	and   i.HasABTax = 1 -- Has taxes 

	update #lines
	set    #lines.TotalAmount = il.TotalAmount
	from   tInvoiceLine il (nolock)
	where  #lines.InvoiceLineKey = il.InvoiceLineKey

	insert #iabt(InvoiceKey, SalesTaxKey, Amount, RealTaxAmount, Taxable)
	select iabt.InvoiceKey, iabt.SalesTaxKey, sum(iabt.Amount), 0, 0
	from   tInvoiceAdvanceBillTax iabt (nolock)
	inner join #invoices i on iabt.InvoiceKey = i.InvoiceKey
	group by iabt.InvoiceKey, iabt.SalesTaxKey

	update #iabt
	set    #iabt.RealTaxAmount = lines.SalesTaxAmount
	from ( 
	    select #lines.InvoiceKey, #lines.SalesTaxKey, sum(#lines.SalesTaxAmount) as SalesTaxAmount
 		from   #lines
		group by #lines.InvoiceKey, #lines.SalesTaxKey
		) as lines
	where #iabt.InvoiceKey = lines.InvoiceKey
	and   #iabt.SalesTaxKey = lines.SalesTaxKey
	
	update #iabt
	set    Taxable = 1
	where  Amount <> RealTaxAmount

	update #lines
	set    #lines.Taxable = #iabt.Taxable
	from   #iabt
	where  #lines.InvoiceKey = #iabt.InvoiceKey
	and    #lines.SalesTaxKey = #iabt.SalesTaxKey

	-- the line is taxable if it has a tax that we cannot find in the ab
	update #lines
	set    #lines.UpdateFlag = 0

	update #lines
	set    #lines.UpdateFlag = 1 -- found 
	from   #iabt
	where  #lines.InvoiceKey = #iabt.InvoiceKey
	and    #lines.SalesTaxKey = #iabt.SalesTaxKey	

	update #lines
	set    #lines.Taxable = 1
	where  #lines.UpdateFlag = 0 -- could not be found
	and    #lines.SalesTaxAmount <> 0

	update #invoices
	set    #invoices.TaxableSales = ISNULL((
		select sum(lines.TotalAmount)
		from 
			(
			 select distinct #lines.InvoiceKey, #lines.InvoiceLineKey, #lines.TotalAmount
			 from   #lines
			 where  #lines.Taxable = 1
			) as lines
		where lines.InvoiceKey = #invoices.InvoiceKey 

	),0)
	where #invoices.Type = 'Collected Taxes'
	and   #invoices.HasAB = 1 -- AB application
	and   #invoices.HasABTax = 1 -- has taxes

	-- take in account % split
	UPDATE #invoices
	SET    #invoices.TaxableSales = (#invoices.TaxableSales * #invoices.PercentageSplit) / 100
	WHERE  #invoices.Type = 'Collected Taxes'
	AND    ISNULL(#invoices.ParentInvoiceKey, 0) > 0   
	and   #invoices.HasAB = 1 -- AB application
	and   #invoices.HasABTax = 1 -- has taxes

	if @Debug = 1
	begin
		select * from #lines
		select * from #iabt
		select i2.InvoiceNumber, i.* from #invoices i left join tInvoice i2 (nolock) on i.InvoiceKey = i2.InvoiceKey
	end

	RETURN 1
GO
