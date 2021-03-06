USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceRecalcAmountsConversion]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceRecalcAmountsConversion]
	(
		@InvoiceKey INT
		,@CreateTemp INT = 1
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/26/07 GHL 8.5   Storing and rounding tax amounts at line level to help with invoice summary  
  ||                    + added call to sptInvoiceSummary since we summarize sales tax now
  */
  
  
/*  
Add to spConvertDB10512

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, il.InvoiceLineKey, i.SalesTaxKey, 1, isnull(il.SalesTax1Amount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
and   isnull(i.SalesTaxKey, 0) >0
and   il.Taxable = 1
--and   il.SalesTax1Amount <> 0

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, il.InvoiceLineKey, i.SalesTax2Key, 2, isnull(il.SalesTax2Amount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
and   isnull(i.SalesTax2Key, 0) >0
and   il.Taxable2 = 1
--and   il.SalesTax2Amount <> 0

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
select i.InvoiceKey, ilt.InvoiceLineKey, ilt.SalesTaxKey, 3, isnull(ilt.SalesTaxAmount, 0)
from   tInvoice i (nolock)
inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey
where isnull(i.ParentInvoiceKey, 0) = 0 -- not a child
and   isnull(i.ParentInvoice, 0) = 0 -- not a parent
--and   ilt.SalesTaxAmount <> 0



declare @InvoiceKey int
select @InvoiceKey = -1
while (1=1)
begin
	select @InvoiceKey = min(InvoiceKey)
    from tInvoice (nolock)
    where InvoiceKey > @InvoiceKey
	and  isnull(ParentInvoiceKey, 0) > 0 -- must be a child
	and   isnull(ParentInvoice, 0) = 0 -- not a parent

	if @InvoiceKey is null
		break

	exec sptInvoiceRecalcAmountsConversion @InvoiceKey
 
end


*/

	set nocount on

	declare @LineInvoiceKey int  -- invoice where lines are
	declare @SalesTax1Key int
	declare @SalesTax1Amount MONEY
	declare @SalesTax2Key int
	declare @SalesTax2Amount MONEY
	declare @SalesTaxAmount MONEY
	declare @TotalNonTaxAmount MONEY
	declare @InvoiceTotalAmount MONEY 
	declare @ParentInvoice tinyint
	declare @ParentInvoiceKey int
	declare @PercentageSplit decimal(24,4)
	declare @CurrInvoiceKey int
	declare @NonPiggyBackSalesTaxAmount MONEY
	declare @LineTotalAmount MONEY
	declare @CurrSalesTaxKey int	
	declare @CurrSalesTaxRate DECIMAL(24,4)		
	declare @CurrPiggyBackTax tinyint
	declare @CurrSalesTaxAmount MONEY
	declare @CurrInvoiceLineKey int
	declare @CurrInvoiceLineID int
							
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

		For Each tInvoiceLine
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

			For Each tInvoiceLineTax
				Get SalesTax info
			If Not PiggyBack
				Add to tInvoiceLineTax.SalesTaxAmount 
				Add to NonPiggyBackSalesTaxAmount 
			Next

			TotalAmount = TotalAmount + NonPiggyBackSalesTaxAmount

			If SalesTax1 is PiggyBack
				Add to SalesTax1Amount 
				
			If SalesTax2 is PiggyBack
				Add to SalesTax2Amount 

			For Each tInvoiceLineTax
				Get SalesTax info
			If PiggyBack
				Add to tInvoiceLineTax.SalesTaxAmount 
			Next

		Next
		*/
							   	   
	Select 
		@ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0),
		@LineInvoiceKey = @InvoiceKey,
		@PercentageSplit = PercentageSplit,
		@ParentInvoice = ISNULL(ParentInvoice, 0),
		@SalesTax1Key = ISNULL(SalesTaxKey, 0),
		@SalesTax2Key = ISNULL(SalesTax2Key, 0)
	from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
	if @ParentInvoiceKey = 0
		return 1
	if @ParentInvoice = 1
		return 1
		
	if @ParentInvoiceKey = 0
		Select @PercentageSplit = 1
	ELSE
		Select @LineInvoiceKey = @ParentInvoiceKey, @PercentageSplit = @PercentageSplit / 100
		
	if @CreateTemp = 1	
	create table #tInvoiceTax (
	    InvoiceLineID int identity(1,1) not null
		,InvoiceKey int null
		,InvoiceLineKey int null
		,SalesTaxKey int null
		,LineTotalAmount money null
		,SalesTaxAmount money null
		,Type smallint null -- 1 = 'SalesTax1', 2 = 'SalesTax2', 3 = 'OtherTax'
		,TaxRate decimal(24,4) null
		,PiggyBackTax tinyint null
		)
		
	truncate table #tInvoiceTax
		
	-- In the case of a child invoice, the SalesTax1Key and SalesTax2Key must come for the child invoice
	-- but the lines come from the parent invoice  	
	
	-- In the case of a parent invoice or a regular invoice, everything comes from one invoice 

	if @SalesTax1Key > 0
	insert #tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, LineTotalAmount, Type)
	select  @InvoiceKey, il.InvoiceLineKey, @SalesTax1Key, isnull(il.TotalAmount, 0), 1
	from    tInvoiceLine il (nolock)
	where   il.InvoiceKey = @LineInvoiceKey -- point to the invoice where lines are
	and     isnull(Taxable, 0) = 1
		

	if @SalesTax2Key > 0
	insert #tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, LineTotalAmount, Type)
	select  @InvoiceKey, il.InvoiceLineKey, @SalesTax2Key, isnull(il.TotalAmount, 0), 2 
	from    tInvoiceLine il (nolock)
	where   il.InvoiceKey = @LineInvoiceKey -- point to the invoice where lines are
	and     isnull(Taxable2, 0) = 1
	
	-- other taxes
	insert #tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, LineTotalAmount, Type)
	select  @InvoiceKey, il.InvoiceLineKey, ilt.SalesTaxKey, isnull(il.TotalAmount, 0), 3 
	from    tInvoiceLine il (nolock)
		inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey 
	where   il.InvoiceKey = @LineInvoiceKey -- point to the invoice where lines are
	
	update #tInvoiceTax
	set    #tInvoiceTax.TaxRate = isnull(st.TaxRate, 0)
	      ,#tInvoiceTax.PiggyBackTax = isnull(st.PiggyBackTax, 0)
	from   tSalesTax st (nolock)
	where  #tInvoiceTax.SalesTaxKey = st.SalesTaxKey


	-- Loop through each invoice line 
	SELECT @CurrInvoiceLineKey = -1	
	WHILE (1=1)
	BEGIN
		SELECT @CurrInvoiceLineKey = MIN(InvoiceLineKey)
		FROM   #tInvoiceTax 	
		WHERE  InvoiceLineKey > @CurrInvoiceLineKey
		
		IF @CurrInvoiceLineKey IS NULL
			BREAK

		SELECT @LineTotalAmount = LineTotalAmount
		FROM   #tInvoiceTax 	
		WHERE  InvoiceLineKey = @CurrInvoiceLineKey
	
		SELECT @NonPiggyBackSalesTaxAmount  = 0

		-- Loop through each NON piggy back tax
		SELECT @CurrSalesTaxKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrSalesTaxKey = MIN(SalesTaxKey)
			FROM   #tInvoiceTax 	
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxKey > @CurrSalesTaxKey
			AND    PiggyBackTax = 0
			
			IF @CurrSalesTaxKey IS NULL
				BREAK

			SELECT @CurrInvoiceLineID = InvoiceLineID
			       ,@CurrSalesTaxRate = TaxRate
			FROM   #tInvoiceTax 	
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxKey = @CurrSalesTaxKey
			
			SELECT @CurrSalesTaxAmount = 0
		
			IF @CurrSalesTaxRate > 0
			BEGIN
				-- tax = Line Total Amount * Tax Rate / 100
				-- tax = tax * @PercentageSplit
				-- tax = (Line Total Amount * Tax Rate * @PercentageSplit) / 100
				SELECT @CurrSalesTaxAmount = ROUND(((@LineTotalAmount * @CurrSalesTaxRate * @PercentageSplit) / 100) , 2)
			END
			
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)
			
			SELECT @NonPiggyBackSalesTaxAmount = @NonPiggyBackSalesTaxAmount + @CurrSalesTaxAmount
			
			UPDATE #tInvoiceTax 
			SET    SalesTaxAmount = @CurrSalesTaxAmount
			WHERE  InvoiceLineID = @CurrInvoiceLineID
			
		END -- sales tax loop
	
		SELECT @LineTotalAmount = @LineTotalAmount + @NonPiggyBackSalesTaxAmount
	
		-- Loop through each piggy back tax
		SELECT @CurrSalesTaxKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrSalesTaxKey = MIN(SalesTaxKey)
			FROM   #tInvoiceTax 	
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxKey > @CurrSalesTaxKey
			AND    PiggyBackTax = 1
			
			IF @CurrSalesTaxKey IS NULL
				BREAK

			SELECT @CurrInvoiceLineID = InvoiceLineID
			       ,@CurrSalesTaxRate = TaxRate
			FROM   #tInvoiceTax 	
			WHERE  InvoiceLineKey = @CurrInvoiceLineKey
			AND    SalesTaxKey = @CurrSalesTaxKey
			
			SELECT @CurrSalesTaxAmount = 0
		
			IF @CurrSalesTaxRate > 0
			BEGIN
				-- tax = Line Total Amount * Tax Rate / 100
				-- tax = tax * @PercentageSplit
				-- tax = (Line Total Amount * Tax Rate * @PercentageSplit) / 100
				SELECT @CurrSalesTaxAmount = ROUND(((@LineTotalAmount * @CurrSalesTaxRate * @PercentageSplit) / 100) , 2)
			END
			
			SELECT @CurrSalesTaxAmount = ISNULL(@CurrSalesTaxAmount, 0)
						
			UPDATE #tInvoiceTax 
			SET    SalesTaxAmount = @CurrSalesTaxAmount
			WHERE  InvoiceLineID = @CurrInvoiceLineID
			
		END -- sales tax loop
		
	END -- invoice line loop
	
		
--select * from #tInvoiceTax


		UPDATE #tInvoiceTax 
		SET SalesTaxAmount = ISNULL(SalesTaxAmount, 0)
		
		DELETE tInvoiceTax where InvoiceKey = @InvoiceKey
		
		INSERT tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SalesTaxAmount)
		SELECT InvoiceKey, InvoiceLineKey, SalesTaxKey, Type, SUM(SalesTaxAmount)
		FROM   #tInvoiceTax
		GROUP BY InvoiceKey, InvoiceLineKey, SalesTaxKey, Type
		
			
	
						
	return 1
GO
