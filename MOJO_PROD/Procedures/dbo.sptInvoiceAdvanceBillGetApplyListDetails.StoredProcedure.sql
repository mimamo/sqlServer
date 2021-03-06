USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillGetApplyListDetails]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillGetApplyListDetails]
	(
	@ClientKey int, -- must be set when InvoiceKey = 0
	@GLCompanyKey int, -- must be set when InvoiceKey = 0
	@InvoiceKey int, -- may be 0
	@AdvanceBill tinyint,
	@CurrencyID varchar(10) = null 
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 05/23/10 GHL 10.568 Created to support modification of the Add Advance Bill screen
||                     where we display both advance bills and advance bill tax details 
|| 09/27/13 GHL 10.572 Added multi currency and void info
*/
	SET NOCOUNT ON

	Declare @ParentCompanyKey int

	SELECT @ParentCompanyKey = ParentCompanyKey
		FROM   tCompany (NOLOCK)
		WHERE  CompanyKey = @ClientKey
	
	SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)

	create table #advbill (
		InvoiceKey int null
		,InvoiceNumber varchar(50) null
		,InvoiceDate smalldatetime null
		,InvoiceTotalAmount money null
		,TotalNonTaxAmount money null
		,SalesTaxAmount money null
		,OpenAmount money null -- open in terms of InvoiceTotalAmount - AmountReceived

		,AppliedAmount money null
		,AppliedSalesAmount money null
		,AppliedTaxAmount money null 
		
		,UnappliedAmount money null
		,UnappliedSalesAmount money null
		,UnappliedTaxAmount money null

	)

	create table #advbilltax (
		InvoiceKey int null
		,SalesTaxKey int null
		,SalesTaxAmount money null
		
		,AppliedAmount money null
		,UnappliedAmount money null
	)

	if @AdvanceBill = 0
	begin
		-- if the current invoice is a real invoice, we need a list of advance bills
		-- we will determine if we keep them later

		insert #advbill (InvoiceKey, InvoiceNumber, InvoiceDate, InvoiceTotalAmount, TotalNonTaxAmount, SalesTaxAmount, OpenAmount)
		select InvoiceKey, InvoiceNumber, InvoiceDate, InvoiceTotalAmount, TotalNonTaxAmount, SalesTaxAmount
		     ,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
		from tInvoice i (nolock)
		Where
			i.AdvanceBill = 1 and
			i.InvoiceStatus = 4 and
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND
			i.ClientKey IN (SELECT CompanyKey from tCompany (NOLOCK) WHERE CompanyKey = @ClientKey 
				OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
				OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
			i.InvoiceTotalAmount > 0 and
			i.InvoiceKey not in (Select AdvBillInvoiceKey from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey) 
	

		update #advbill
		set    #advbill.AppliedAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
			Where tInvoiceAdvanceBill.AdvBillInvoiceKey = #advbill.InvoiceKey
		),0)

		update #advbill
		set    #advbill.AppliedTaxAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
			Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = #advbill.InvoiceKey
		),0)

		update #advbill
		set    #advbill.AppliedSalesAmount = isnull(#advbill.AppliedAmount, 0) - isnull(#advbill.AppliedTaxAmount, 0)
		
		update #advbill
		set    #advbill.UnappliedAmount = isnull(#advbill.InvoiceTotalAmount, 0) - isnull(#advbill.AppliedAmount, 0)
		      ,#advbill.UnappliedSalesAmount = isnull(#advbill.TotalNonTaxAmount, 0) - isnull(#advbill.AppliedSalesAmount, 0)
		      ,#advbill.UnappliedTaxAmount = isnull(#advbill.SalesTaxAmount, 0) - isnull(#advbill.AppliedTaxAmount, 0)
		      
		-- delete if there is nothing left to apply
		delete #advbill where UnappliedAmount <= 0
	end
	else
	begin
		-- This is an Adv Bill
		-- Looking for Non Adv Bill That are open

		insert #advbill (InvoiceKey, InvoiceNumber, InvoiceDate, InvoiceTotalAmount, TotalNonTaxAmount, SalesTaxAmount, OpenAmount)
		Select
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.InvoiceTotalAmount, 
			i.TotalNonTaxAmount, 
			i.SalesTaxAmount,
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
		From
			tInvoice i (nolock)
		Where
			i.AdvanceBill = 0 and
			i.InvoiceStatus = 4 and
			i.Posted = 0 and
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND
			i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey 
				OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
				OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  
			and
			((ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) 
			- isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
			 ) > 0)
			and
			i.InvoiceKey not in (Select InvoiceKey from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey)
	
		update #advbill
		set    #advbill.AppliedAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
			Where tInvoiceAdvanceBill.AdvBillInvoiceKey = #advbill.InvoiceKey
		),0)

		update #advbill
		set    #advbill.AppliedTaxAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
			Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = #advbill.InvoiceKey
		),0)

		update #advbill
		set    #advbill.AppliedSalesAmount = isnull(#advbill.AppliedAmount, 0) - isnull(#advbill.AppliedTaxAmount, 0)
		
		update #advbill
		set    #advbill.UnappliedAmount = isnull(#advbill.InvoiceTotalAmount, 0) - isnull(#advbill.AppliedAmount, 0)
		      ,#advbill.UnappliedSalesAmount = isnull(#advbill.TotalNonTaxAmount, 0) - isnull(#advbill.AppliedSalesAmount, 0)
		      ,#advbill.UnappliedTaxAmount = isnull(#advbill.SalesTaxAmount, 0) - isnull(#advbill.AppliedTaxAmount, 0)

       -- what really matters on real invoices is that UnappliedAmount = OpenAmount
		update #advbill
		set    #advbill.UnappliedAmount = #advbill.OpenAmount
	    
		
	end

	insert #advbilltax (InvoiceKey,SalesTaxKey,SalesTaxAmount)
	select it.InvoiceKey, it.SalesTaxKey, Sum(it.SalesTaxAmount)
	from   tInvoiceTax it (nolock)
		inner join #advbill ab on it.InvoiceKey = ab.InvoiceKey
	group by it.InvoiceKey, it.SalesTaxKey

	if @AdvanceBill = 0
	begin
		update #advbilltax
		set    #advbilltax.AppliedAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
			Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = #advbilltax.InvoiceKey
			And   tInvoiceAdvanceBillTax.SalesTaxKey = #advbilltax.SalesTaxKey
		),0)
	end
	else
	begin
		update #advbilltax
		set    #advbilltax.AppliedAmount = isnull((
			Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
			Where tInvoiceAdvanceBillTax.InvoiceKey = #advbilltax.InvoiceKey
			And   tInvoiceAdvanceBillTax.SalesTaxKey = #advbilltax.SalesTaxKey
		),0)
	end

	update #advbilltax
	set    #advbilltax.UnappliedAmount = isnull(#advbilltax.SalesTaxAmount, 0) - isnull(#advbilltax.AppliedAmount, 0)

	select * 
	      ,UnappliedAmount as OrigUnappliedAmount
		  ,UnappliedSalesAmount as OrigUnappliedSalesAmount
		  ,UnappliedTaxAmount as OrigUnappliedTaxAmount
	from #advbill
	
	select abt.*  
		  ,abt.UnappliedAmount as OrigUnappliedAmount
		  ,st.SalesTaxID
		  ,st.SalesTaxName
	from #advbilltax abt
		inner join tSalesTax st (nolock) on abt.SalesTaxKey = st.SalesTaxKey
	where abt.UnappliedAmount > 0 -- or do we display them without editing

	RETURN 1
GO
