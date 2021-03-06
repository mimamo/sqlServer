USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxAnalysis]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxAnalysis]
	(
		@CompanyKey int,
		@SalesTaxKey int, 
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@ShowCollected tinyint,
		@ShowPaid tinyint,
		@PaidInvoicesOnly tinyint,
		@ShowTaxAppliedLinesOnly tinyint,
		@GLCompanyKey int = -1, -- -1 All, 0 Blank, >0
		@UserKey int = null,
		@CurrencyID varchar(10) = null,
		@DetailsOnly int = 0
	)

AS --Encrypt

--exec spRptSalesTaxAnalysisOld @CompanyKey,@SalesTaxKey,@StartDate,@EndDate,@ShowCollected,@ShowPaid,@PaidInvoicesOnly,@ShowTaxAppliedLinesOnly,@GLCompanyKey 
--return
	
  /*
  || When     Who Rel     What
  || 01/12/07 GWG 8.4001  Changed the joins on paid only so that it shows if the payment is in the window
  || 05/15/07 GHL 8.5     Added support of tInvoiceAdvanceBillTax. Enh 6553
  || 02/26/08 GHL 8.5     Fixed problem with 2 InvoiceDates when Paid Only case
  || 04/29/08 GHL 8.509   (25531) Fixed problem with rounding issues with CollectableAmount and TaxablePlusTax
  || 05/26/08 GHL 8.512   (26981) When moving to a temp table, invoice date was set in #taxes.PostingDate
  ||                      Setting it now in #taxes.InvoiceDate. Also changed SalesTaxRate to TaxRate to show on report
  || 06/03/08 GHL 8.512   (27484) With split billing, the sales taxes are not shown on either parent or child
  ||                       Parent has lines, but no taxes on header, and child has no lines but taxes on header
  ||                       Problem was with Lines.TotalAmount since child has no lines
  ||                       Decided to query invoices where ParentInvoice = 0 only (i.e children) but modified where clause
  ||                       with Lines to ISNULL(i.ParentInvoiceKey, i.InvoiceKey) = Lines.InvoiceKey to get the lines from
  ||                       the parent invoice when there is one  
  || 03/19/09 GHL 10.021   Adjusted TaxableAmount according to Percentsplit for split billing
  || 07/10/09 GHL 10.504   (56758) Added GLCompanyKey parameter
  || 07/15/09 GHL 10.504   (45187) Added tax summary (+ taking in account now adv bills)
  || 08/25/09 GHL 10.508   (59770) Corrected the way AdvBillAmount is used
  || 09/22/09 GHL 10.5     Added support of other taxes on voucher lines
  || 09/30/09 GHL 10.5     Using now tInvoiceTax and tVoucherTax
  || 03/11/10 GHL 10.519   Fixed bad join with advbilltax.SalesTaxKey
  || 03/12/10 GHL 10.520   Added logic for Advance Bills
  ||                       Even if there are no taxes on the advance bill, we must recognize taxes 
  ||                       if they exist on the real invoice
  || 05/21/10 RLB 10.523   (81169) On Deck Change to removed invoice lines with no applied tax
  || 07/20/10 GHL 10.532   (85615) Reviewed logic for advance bills, see below...SalesTaxAmount was multiplied
  ||                       by the number of advance bills applied. Changed Sum(SalesTaxAmount) to Min(SalesTaxAmount) 
  || 07/26/10 MFT 10.532   Added unions for tPaymentDetail and tCheckAppl (GWG Fixed tax calculations)
  || 08/19/10 RLB 10.532  (86458)Added InvoiceTotalAmount to Taxes Summary
  || 08/23/10 GHL 10.534  (87948) Issue at Hawse Design was that the Collected/Paid was missing the AB contribution
  ||                      My findings were that the reason for that, was that the Taxable fields were resulting in SalesTaxAmount = 0
  ||                      I removed all the checks on SalesTaxAmount = 0 in spRptSalesTaxAB
  ||                      And I added a delete if SalesTaxAmount = 0 in this stored procedure
  || 9/22/10 GWG 10.535   Added a final order by to the last select SalesTaxID, Type, PostingDate, InvoiceNumber
  || 3/29/11 GWG 10.542   Added a comment on advance bill removal.
  || 5/11/11 GHL 10.544   (109459/107282) Changed the way we handle real invoices linked to Advance Bills
  ||                      If there no taxes on the AB application, this is considered as a payment
  ||                      If there are taxes on the AB application, we consider that sales and taxes are simply reduced on the real invoice
  ||                      Also we determine that lines are considered taxable by comparing records in tInvoiceTax and tInvoiceAdvanceBillTax
  ||                      If they are different, the lines will be considered taxable
  ||                      Calling now: spRptSalesTaxTaxableAmount and spRptSalesTaxRealInvoice 
  || 08/15/11 GHL 10.547  (118624) Calculating now TaxableAmounts in 2 modes
  ||                       1) Based on il.SalesTaxAmount <> 0 for the bottom 2nd summary grid
  ||                       2) Based on il.Taxable/il.Taxable2 for the top listing
  || 09/02/11 GHL 10.547  (119937) If ShowTaxAppliedOnly, delete records where TaxableAmount = 0
  ||                       instead of records where TaxAmount = 0 
  || 04/10/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 05/24/12 GHL 10.556  (143871) The issue is with the second summary. it shows:
  ||                       - Total Taxable
  ||                       - Total Non Taxable
  ||                       - Total w/o Tax     
  ||                       Total Taxable was OK, but Total w/o Tax and Total Non Taxable should include all invoices without taxes
  ||                       not included in the report until now...had to change all inner join with tInvoiceTax to left joins
  ||                       Then added a delete of #taxes at the end so that they are not dispalyed on the report  
  || 02/20/13 GHL 10.565  (166724) Problem inverse from 143871. This time Total w/o Tax is too big (instead of too small)
  ||                       when there no taxes on Adv Bills (payments) we are not reducing the sales on the real, thus we are
  ||                       double dipping on totals. Decided to filter out the adv bill without taxes
  || 04/05/13 GHL 10.566   (172558) Catapult was comparing Corp PL and Total w/o taxes. Some invoices were not in #taxes
  ||                       So I am adding them up at the end of the report
  || 07/18/13 WDF 10.570  (176497) Added VoucherID
  || 03/13/14 GHL 10.578   Added Currency filter
  || 04/30/14 GHL 10.579   (214601) Added GLCompany in query for extra sales at the bottom 
  || 03/03/15 GHL 10.590   (247006) Added #details for a drilldown for the Total w/o Tax
 */
  
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

SELECT @SalesTaxKey = ISNULL(@SalesTaxKey, 0)
		,@ShowCollected = ISNULL(@ShowCollected, 0)
		,@ShowPaid = ISNULL(@ShowPaid, 0)
		,@PaidInvoicesOnly = ISNULL(@PaidInvoicesOnly, 0)
	    ,@GLCompanyKey = ISNULL(@GLCompanyKey, 0)
	    	
DECLARE @PaidSign AS smallmoney
DECLARE @InvoiceKey as int
DECLARE @AdvBillInvoiceKey as int

	IF @ShowCollected = 1
		SELECT @PaidSign = -1.0
	ELSE
		SELECT @PaidSign = 1.0

/* Assume done in VB

CREATE TABLE #taxes_summary (
	SalesTaxKey int null
	,SalesTaxID VARCHAR(100) NULL, SalesTaxName VARCHAR(100) NULL, SalesTaxFullName VARCHAR(200) NULL
    ,TaxCollected MONEY NULL, TaxPaid MONEY NULL, VAT MONEY NULL
    ,SalesTaxableAmount MONEY NULL,PurchaseTaxableAmount MONEY NULL, InvoiceTotalAmount MONEY NULL) 	

-- This is a new summary table added 4/25/11
CREATE TABLE #summary (
	TotalName varchar(30) null
	,Collected money null
	,Paid money null
	,Net money null
)

-- used to capture details for the Total w/o Tax
CREATE TABLE #details (InvoiceKey int null
    ,Source varchar(25) null
    ,Amount money null
)

*/


CREATE TABLE #taxes (
		-- Invoice info
		InvoiceKey int null
        ,ParentInvoiceKey int null
        ,PercentageSplit decimal(24,4) null
        ,PostingDate DATETIME NULL
        ,Type VARCHAR(25) NULL	-- 'Collected Taxes' or 'Paid Taxes'
		,Source VARCHAR(25) NULL -- 'AppliedToAB', 'Invoice', 'Voucher', 'Check', 'Payment'
        ,InvoiceNumber VARCHAR(50) NULL
        ,InvoiceDate DATETIME NULL
        ,CompanyName VARCHAR(255) NULL
		
		-- Sales Tax Info
		,SalesTaxKey INT NULL
		,SalesTaxID VARCHAR(100) NULL
		,SalesTaxName VARCHAR(100) NULL
		,TaxRate DECIMAL(24,4) NULL
		,PiggyBackTax INT NULL
		,SalesTaxType INT NULL  -- 1 SalesTax1, 2 SalesTax2, 3 Other Taxes, only purpose is to link to tInvoiceLine.Taxable/Taxable2
		
		-- this is what we display
		,InvoiceTotalAmount MONEY NULL
		,SalesTaxAmount MONEY NULL -- will always contain tInvoiceTax.SalesTaxAmount - tInvoiceAdvanceBilltax.Amount
		,TaxableAmount MONEY NULL	   -- taxable amounts based on Taxable flags (1 rec per InvoiceKey/SalesTaxKey)
		,PaidCollected MONEY NULL
		,CollectableAmount MONEY NULL
		,TaxablePlusTax MONEY NULL
		
		,UpdateFlag int null
		
		-- Added 5/10/11 for final calculations
		,TotalNonTaxAmount money null
		,OrigSalesTaxAmount money null --may not be needed
		,CollectableTaxableAmount MONEY NULL -- this is the missing part on the UI, = TaxableAmount * PaidCollected / InvoiceTotalAmount
		,CollectableSales money null -- for the bottom summary

		-- Added 8/15/11 after complaints by Australians
		,TaxableAmountNoFlags MONEY NULL -- taxable amounts NOT based on Taxable flags (1 rec per InvoiceKey)
		,CollectableTaxableAmountNoFlags money null -- Collectable Taxable Sales for 2nd bottom grid
		)


-- capture AmountReceived by all invoices during the period
create table #checkappl (
	InvoiceKey int null
	,Amount money null
	,PaymentDate datetime null
	,Type varchar(50) null -- 'Collected Taxes' or 'Paid Taxes'
)

-- this is to capture the list of invoices with Advance Bills
-- can be Advance Bill applications without IABT = 0 

-- can be Advance Bill applications with IABT <> 0 considered as Payment
-- PAYMENT DATE WILL BE POSTING DATE OF REAL INVOICE
 
-- they also must have SalesTaxKey...so link with tInvoiceTax
create table #realinvoices (
	InvoiceKey int null
	,PostingDate datetime null
	,HasAB int
	,HasABNoTax int -- reverse logic but we need to flag real invoices applied to AB without a tax: they are payments 
	,HasABTax int -- if there are taxes, we need calc TaxableAmount in a different way
	,UpdateFlag int
)
 

-- final list of invoices involved in the report
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

-- no matter what, we need to determine which invoices are applied to AB
-- because the Taxable amount will be calculated differently
if @ShowCollected = 1
begin
	
	-- determine real invoices linked to AB

	insert #realinvoices (InvoiceKey, PostingDate, HasAB, HasABNoTax, HasABTax)
	select Distinct i.InvoiceKey, i.PostingDate, 0, 0, 0
	from   tInvoice i (nolock)
		-- changed for issue 143871
		--inner join tInvoiceTax it (nolock) on i.InvoiceKey = it.InvoiceKey
	Where	i.CompanyKey = @CompanyKey 
	and		i.PostingDate >= @StartDate    -- when considered as payment we need posting dates on invoices
	and		i.PostingDate <= @EndDate 
	and     i.ParentInvoice = 0 -- added to fix 27484
	and     i.AdvanceBill = 0 -- must be a real invoice
	--and		(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') 

	update #realinvoices 
	set    #realinvoices.HasAB = 1
	from   tInvoiceAdvanceBill iab (nolock)
	where  #realinvoices.InvoiceKey = iab.InvoiceKey

	-- now we can delete if they are not applied
	delete #realinvoices where isnull(HasAB, 0) = 0

	select @InvoiceKey = -1
	while (1=1)
	begin
		select @InvoiceKey = min(InvoiceKey)
		from   #realinvoices
		where  InvoiceKey > @InvoiceKey

		if @InvoiceKey is null
			break

		select @AdvBillInvoiceKey =-1
		while (1=1)
		begin
			select @AdvBillInvoiceKey = min(AdvBillInvoiceKey)
			from   tInvoiceAdvanceBill (nolock)
			where  InvoiceKey = @InvoiceKey
			and    AdvBillInvoiceKey > @AdvBillInvoiceKey

			if @AdvBillInvoiceKey is null
				break

			-- they could have both types of AB applications
			-- we need to know both
			-- If HasABTax = 1, we need to recalc TaxableAmount differently
			-- If HasABNoTax = 1, the AB invoice is considered a payment, the real invoice is considered 'Paid'
			if exists (select 1
				from tInvoiceAdvanceBillTax (nolock)
				where  InvoiceKey = @InvoiceKey
				and    AdvBillInvoiceKey = @AdvBillInvoiceKey
				)
				update #realinvoices
				set    #realinvoices.HasABTax = 1
				where  InvoiceKey = @InvoiceKey
			else
				update #realinvoices
				set    #realinvoices.HasABNoTax = 1
				where  InvoiceKey = @InvoiceKey
			
		end

	end


end -- @ShowCollected = 1



if @PaidInvoicesOnly = 1
begin
	
	if @ShowCollected = 1
	begin

		-- get all checks received applied against ALL invoices
		insert #checkappl (InvoiceKey, Amount, PaymentDate, Type)
		Select tCheckAppl.InvoiceKey, Sum(tCheckAppl.Amount),Min(tCheck.CheckDate), 'Collected Taxes'
		from	tCheckAppl (nolock) 
		inner join tCheck (nolock) on tCheckAppl.CheckKey = tCheck.CheckKey
		Where	tCheck.CompanyKey = @CompanyKey 
		And     tCheck.PostingDate >= @StartDate 
		And		tCheck.PostingDate <= @EndDate
		And     isnull(tCheckAppl.InvoiceKey, 0) > 0
		Group by tCheckAppl.InvoiceKey

		-- insert in paid invoices table, the invoices with receipts directly applied
		insert #invoices (InvoiceKey, AmountReceived, PaymentDate, Type)
		select i.InvoiceKey, ca.Amount, ca.PaymentDate, ca.Type
		from   #checkappl ca
		inner  join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		Where  i.CompanyKey = @CompanyKey 
		and    i.ParentInvoice = 0 -- added to fix 27484
		and    ca.Type ='Collected Taxes'
		--and	   (@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
	    
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)
		and isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') 


		-- now insert  in paid invoices table, the invoices with AB invoices and no taxes
		-- they are considered as payment
		insert #invoices (InvoiceKey, AmountReceived, PaymentDate, Type)
		select ri.InvoiceKey, 0, ri.PostingDate, 'Collected Taxes'
		from   #realinvoices ri
		where  ri.InvoiceKey not in (select InvoiceKey from #invoices)
		and    ri.HasABNoTax = 1

		update #invoices
		set    #invoices.HasAB = isnull(ri.HasAB, 0)
		      ,#invoices.HasABNoTax = isnull(ri.HasABNoTax, 0)
			  ,#invoices.HasABTax = isnull(ri.HasABTax, 0)
		from   #realinvoices ri
		where  #invoices.InvoiceKey = ri.InvoiceKey
	end


	if @ShowPaid = 1
	begin
		
		-- get all payment details
		insert #checkappl (InvoiceKey, Amount, PaymentDate, Type)
		Select tPaymentDetail.VoucherKey, Sum(tPaymentDetail.Amount),Min(tPayment.PaymentDate), 'Paid Taxes'
		from	tPaymentDetail (nolock) 
		inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
		Where tPayment.CompanyKey = @CompanyKey 
		And   tPayment.PostingDate >= @StartDate
		And   tPayment.PostingDate <= @EndDate
		And   isnull(tPaymentDetail.VoucherKey, 0) > 0
		Group by tPaymentDetail.VoucherKey

		-- insert invoices with receipts directly applied
		insert #invoices (InvoiceKey, AmountReceived, PaymentDate, Type)
		select v.VoucherKey, ca.Amount, ca.PaymentDate, ca.Type
		from   #checkappl ca
		inner  join tVoucher v (nolock) on ca.InvoiceKey = v.VoucherKey
		Where  v.CompanyKey = @CompanyKey 
		and    ca.Type ='Paid Taxes'
		--and	   (@GLCompanyKey = -1 or isnull(v.GLCompanyKey, 0) = @GLCompanyKey) 
	    AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)
		and isnull(v.CurrencyID, '') = isnull(@CurrencyID, '') 

	end

end

if @PaidInvoicesOnly = 0
begin
	
	if @ShowCollected = 1
	begin
		insert #invoices (InvoiceKey, Type)
		select Distinct i.InvoiceKey, 'Collected Taxes'
		from   tInvoice i (nolock)
			--changed for issue 143871
			--inner join tInvoiceTax it (nolock) on i.InvoiceKey = it.InvoiceKey
		Where	i.CompanyKey = @CompanyKey 
		and		i.PostingDate >= @StartDate    
		and		i.PostingDate <= @EndDate 
		and     i.ParentInvoice = 0 -- added to fix 27484
		--and		(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)
		and isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') 


		update #invoices 
		set    #invoices.AmountReceived = ISNULL((
			select Sum(tCheckAppl.Amount)
			from	tCheckAppl (nolock) 
			inner join tCheck (nolock) on tCheckAppl.CheckKey = tCheck.CheckKey
			Where	tCheck.CompanyKey = @CompanyKey 
			And		tCheck.PostingDate <= @EndDate -- do not check the PostingDate against StartDate!!! 
			And     tCheckAppl.InvoiceKey = #invoices.InvoiceKey 
		),0)  
		where Type = 'Collected Taxes'

		update #invoices 
		set    #invoices.PaymentDate = ISNULL((
			select min(tCheck.CheckDate)
			from	tCheckAppl (nolock) 
			inner join tCheck (nolock) on tCheckAppl.CheckKey = tCheck.CheckKey
			Where	tCheck.CompanyKey = @CompanyKey 
			And		tCheck.PostingDate <= @EndDate
			And     tCheckAppl.InvoiceKey = #invoices.InvoiceKey 
		),0)  
		where Type = 'Collected Taxes'

		update #invoices
		set    #invoices.HasAB = isnull(ri.HasAB, 0)
		      ,#invoices.HasABNoTax = isnull(ri.HasABNoTax, 0)
			  ,#invoices.HasABTax = isnull(ri.HasABTax, 0)
		from   #realinvoices ri
		where  #invoices.InvoiceKey = ri.InvoiceKey

	end

	if @ShowPaid = 1
	begin
		insert #invoices (InvoiceKey, Type)
		select Distinct v.VoucherKey, 'Paid Taxes'
		from   tVoucher v (nolock)
			--changed for issue 143871
			--inner join tVoucherTax vt (nolock) on v.VoucherKey = v.VoucherKey
		Where	v.CompanyKey = @CompanyKey 
		and		v.PostingDate >= @StartDate    -- when considered as payment we need posting dates on invoices
		and		v.PostingDate <= @EndDate 
		--and		(@GLCompanyKey = -1 or isnull(v.GLCompanyKey, 0) = @GLCompanyKey)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)
		and isnull(v.CurrencyID, '') = isnull(@CurrencyID, '') 

		update #invoices 
		set    #invoices.AmountReceived = ISNULL((
			select Sum(tPaymentDetail.Amount)
			from	tPaymentDetail (nolock) 
			inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
			Where	tPayment.CompanyKey = @CompanyKey 
			And		tPayment.PostingDate <= @EndDate -- do not check the PostingDate against StartDate!!! 
			And     tPaymentDetail.VoucherKey = #invoices.InvoiceKey 
		),0)  
		where Type = 'Paid Taxes'

		update #invoices 
		set    #invoices.PaymentDate = ISNULL((
			select min(tPayment.PaymentDate)
			from	tPaymentDetail (nolock) 
			inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
			Where	tPayment.CompanyKey = @CompanyKey 
			And		tPayment.PostingDate <= @EndDate -- do not check the PostingDate against StartDate!!! 
			And     tPaymentDetail.VoucherKey = #invoices.InvoiceKey 
		),0)  
		where Type = 'Paid Taxes'
		
	end

end
 
-- now calculate the TaxableSales on all invoices...will use #invoices

-- the calculation uses the lines, need to point to the parent invoice
update #invoices 
set    #invoices.ParentInvoiceKey = i.ParentInvoiceKey
       ,#invoices.PercentageSplit = i.PercentageSplit
from   tInvoice i (nolock)
where  #invoices.InvoiceKey = i.InvoiceKey
and    #invoices.Type = 'Collected Taxes' 

-- results will be in #invoices.TaxableSales
exec spRptSalesTaxAnalysisTaxableAmount @CompanyKey

--select * from #realinvoices
--select * from #invoices

create table #realtaxes (
			InvoiceKey int null
			,SalesTaxKey int null
	
			-- this has to be displayed on the report 
			,InvoiceTotalAmount money null	-- Invoice Total on UI

			,TaxableAmount money null	-- Taxable Sales based on Taxable Flags on UI
			,TaxableAmountNoFlags money null		-- Taxable Sales on UI
			
			,SalesTaxAmount money null		-- Tax Amount on UI
			,PaidCollected money null		-- Collected/Paid on UI
			
			,CollectableAmount money null	-- Collectable Tax Amount on UI 
			,TaxablePlusTax money null      -- TaxablePlusTax on UI = CollectableTaxableAmount + CollectableAmount
			,CollectableTaxableAmount money null -- Collectable Taxable Sales
			,CollectableTaxableAmountNoFlags money null -- Collectable Taxable Sales for 2nd bottom grid
											
			,CollectableSales money null	-- for 2nd bottom summary
			
			,TotalNonTaxAmount money null	-- needed for final summary section
			,OrigSalesTaxAmount money null
			,IABTAmount money null			-- debug only

			,SalesTaxType int null
		)


Declare @AmountReceived money
Declare @TaxableSales money
Declare @ParentInvoiceKey int 
Declare @PercentageSplit decimal(24, 4)
Declare @CreateTemp int   select @CreateTemp = 0

select @InvoiceKey = -1
while (1=1)
begin
	select @InvoiceKey = min(InvoiceKey)
	from   #invoices
	where  InvoiceKey > @InvoiceKey
	and    HasAB = 1
	
	if @InvoiceKey is null
		break

	select @AmountReceived = AmountReceived
			,@TaxableSales = TaxableSales
			,@ParentInvoiceKey = ParentInvoiceKey
			,@PercentageSplit = PercentageSplit
	from  #invoices
	where InvoiceKey = @InvoiceKey

	-- this is to caluclate the impact on AB applications with AB tax applications
	-- values have to be reduced
	-- results will be added to #realtaxes
	exec spRptSalesTaxRealInvoice @InvoiceKey, @ParentInvoiceKey, @PercentageSplit, @PaidInvoicesOnly, @CreateTemp, @TaxableSales, @AmountReceived 

end

--select * from #checkappl
--select * from #realinvoices
--select * from #invoices
--select * from #realtaxes

	-- put in the table, the taxes from real invoices applied to AB (they are in #realtaxes)
	Insert #taxes (InvoiceKey,ParentInvoiceKey,PercentageSplit,PostingDate,Type,Source,InvoiceNumber,InvoiceDate,CompanyName 
		,SalesTaxKey,SalesTaxID,SalesTaxName,TaxRate,PiggyBackTax,SalesTaxType 
		,InvoiceTotalAmount,SalesTaxAmount,TaxableAmount,TaxableAmountNoFlags,PaidCollected,CollectableAmount,TaxablePlusTax,CollectableTaxableAmount,CollectableSales 
		,UpdateFlag,TotalNonTaxAmount,OrigSalesTaxAmount
		
		,CollectableTaxableAmountNoFlags 
		)

		Select
			i.InvoiceKey,
			i.ParentInvoiceKey,
			i.PercentageSplit,
			case when @PaidInvoicesOnly = 0 then i.PostingDate else null end, -- as PostingDate,
			'Collected Taxes' As Type,
			'AppliedToAB' As Source,
			i.InvoiceNumber,
			case when @PaidInvoicesOnly = 0 then i.InvoiceDate else i2.PaymentDate end, -- as InvoiceDate,
			c.CustomerID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			taxes.SalesTaxType, -- SalesTaxType was only used in the past to calculate TaxableAmount based on tInvoiceLine.Taxable/Taxable2 
			
			taxes.InvoiceTotalAmount,
			taxes.SalesTaxAmount,
			taxes.TaxableAmount, 
			taxes.TaxableAmountNoFlags, 
			taxes.PaidCollected,
			taxes.CollectableAmount,
			taxes.TaxablePlusTax,
			taxes.CollectableTaxableAmount,
			taxes.CollectableSales
			
			,0 
			,i.TotalNonTaxAmount
			,taxes.OrigSalesTaxAmount
			,taxes.CollectableTaxableAmountNoFlags
		From #realtaxes taxes 
		inner join tInvoice i (nolock) on taxes.InvoiceKey = i.InvoiceKey 
		inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		--changed for issue 143871
		--inner join tSalesTax st (nolock) on taxes.SalesTaxKey = st.SalesTaxKey
		left join tSalesTax st (nolock) on taxes.SalesTaxKey = st.SalesTaxKey
		inner join #invoices i2 (nolock) on i.InvoiceKey = i2.InvoiceKey and i2.Type = 'Collected Taxes' -- to get the PaymentDate

		--SELECT * FROM #taxes Order By SalesTaxID, Type, PostingDate, InvoiceNumber

-- now insert the other stuff

if @ShowCollected = 1
	-- put in the table, the invoices not applied to AB
	Insert #taxes (InvoiceKey,ParentInvoiceKey,PercentageSplit,PostingDate,Type,Source,InvoiceNumber,InvoiceDate,CompanyName 
		,SalesTaxKey,SalesTaxID,SalesTaxName,TaxRate,PiggyBackTax,SalesTaxType 
		,InvoiceTotalAmount,SalesTaxAmount,TaxableAmountNoFlags,PaidCollected,CollectableAmount,TaxablePlusTax 
		,UpdateFlag,TotalNonTaxAmount,OrigSalesTaxAmount 
		)
	Select
		i.InvoiceKey,
		i.ParentInvoiceKey,
		i.PercentageSplit,
		case when @PaidInvoicesOnly = 0 then i.PostingDate else null end, -- as PostingDate,
		'Collected Taxes' As Type,
		'Invoice' As Source,
		i.InvoiceNumber,
		case when @PaidInvoicesOnly = 0 then i.InvoiceDate else i2.PaymentDate end, -- as InvoiceDate,
		c.CustomerID + ' - ' + c.CompanyName As CompanyName,
			
		st.SalesTaxKey,
		st.SalesTaxID,
		st.SalesTaxName,
		st.TaxRate,
		st.PiggyBackTax,
		Taxes.Type As SalesTaxType,

		i.InvoiceTotalAmount,
		Taxes.SalesTaxAmount as SalesTaxAmount,
		i2.TaxableSales as TaxableAmountNoFlags, 
		isnull(i2.AmountReceived, 0) as PaidCollected
		,0,0 -- CollectableAmount,TaxablePlusTax  will be recalced differently based on @PaidInvoicesOnly
			
		,0,i.TotalNonTaxAmount
		,Taxes.SalesTaxAmount as OrigSalesTaxAmount
			 
	From #invoices i2 (nolock)
	inner join tInvoice i (nolock) on i2.InvoiceKey = i.InvoiceKey 
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	--changed for issue 143871
	--inner join 
	left  join 
			(Select i3.InvoiceKey, it.SalesTaxKey, it.Type, SUM(it.SalesTaxAmount) As SalesTaxAmount
			From tInvoiceTax it (nolock)
			Inner Join tInvoice i3 (nolock) On it.InvoiceKey = i3.InvoiceKey
			Where i3.CompanyKey = @CompanyKey -- only reason to join with tInvoice i3 was to reduce dataset
			Group By i3.InvoiceKey, it.SalesTaxKey, it.Type) 
		As Taxes On Taxes.InvoiceKey = i.InvoiceKey
	--changed for issue 143871
	--inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
	left join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
	where i2.Type = 'Collected Taxes'
	and   i2.HasAB = 0 -- only if not applied to AB
	

if @ShowPaid = 1
	-- put in the table, the vouchers 
	Insert #taxes (InvoiceKey,ParentInvoiceKey,PercentageSplit,PostingDate,Type,Source,InvoiceNumber,InvoiceDate,CompanyName 
		,SalesTaxKey,SalesTaxID,SalesTaxName,TaxRate,PiggyBackTax,SalesTaxType 
		,InvoiceTotalAmount,SalesTaxAmount,TaxableAmountNoFlags,PaidCollected,CollectableAmount,TaxablePlusTax 
		,UpdateFlag,TotalNonTaxAmount,OrigSalesTaxAmount 
		)
	Select
		i.VoucherKey,
		NULL, -- i.ParentInvoiceKey,
		NULL, --i.PercentageSplit,
		case when @PaidInvoicesOnly = 0 then i.PostingDate else null end, -- as PostingDate,
		'Paid Taxes' As Type,
		'Voucher' As Source,
		i.InvoiceNumber,
		case when @PaidInvoicesOnly = 0 then i.InvoiceDate else i2.PaymentDate end, -- as InvoiceDate,
		c.VendorID + ' - ' + c.CompanyName As CompanyName,
			
		st.SalesTaxKey,
		st.SalesTaxID,
		st.SalesTaxName,
		st.TaxRate,
		st.PiggyBackTax,
		Taxes.Type  AS SalesTaxType,

		i.VoucherTotal AS InvoiceTotalAmount,
		Taxes.SalesTaxAmount as SalesTaxAmount,
		i2.TaxableSales as TaxableAmountNoFlags, 
		isnull(i2.AmountReceived, 0) as PaidCollected
		,0,0 -- CollectableAmount,TaxablePlusTax  will be recalced differently based on @PaidInvoicesOnly
			
		,0,(isnull(i.VoucherTotal, 0) - isnull(i.SalesTaxAmount, 0))  
		,Taxes.SalesTaxAmount as OrigSalesTaxAmount
			 
	From #invoices i2 (nolock)
	inner join tVoucher i (nolock) on i2.InvoiceKey = i.VoucherKey 
	inner join tCompany c (nolock) on i.VendorKey = c.CompanyKey
	--changed for issue 143871
	--inner join
	left join 
			(Select i3.VoucherKey, vt.SalesTaxKey, vt.Type, SUM(vt.SalesTaxAmount) As SalesTaxAmount
			From tVoucherTax vt (nolock)
			Inner Join tVoucher i3 (nolock) On vt.VoucherKey = i3.VoucherKey
			Where i3.CompanyKey = @CompanyKey -- only reason to join with tInvoice i3 was to reduce dataset
			Group By i3.VoucherKey, vt.SalesTaxKey, vt.Type) 
		As Taxes On Taxes.VoucherKey = i.VoucherKey
	--changed for issue 143871
	--inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
	left join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
	where i2.Type = 'Paid Taxes'
	
	-- now add payments and checks applied to GL accounts with tax

	if @ShowPaid = 1
		-- must be grouped by PaymentKey, SalesTaxKey
	Insert #taxes (InvoiceKey,ParentInvoiceKey,PercentageSplit,PostingDate,Type,Source,InvoiceNumber,InvoiceDate,CompanyName 
		,SalesTaxKey,SalesTaxID,SalesTaxName,TaxRate,PiggyBackTax,SalesTaxType 
		,InvoiceTotalAmount,SalesTaxAmount,TaxableAmountNoFlags,PaidCollected,CollectableAmount,TaxablePlusTax,CollectableTaxableAmount,CollectableSales 
		,UpdateFlag,TotalNonTaxAmount,OrigSalesTaxAmount 
		)
		SELECT
			p.PaymentKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			pay.PostingDate,
			'Collected Taxes' As Type,
			'Check' As Source,
			pay.CheckNumber,
			pay.PaymentDate,
			co.VendorID + ' - ' + co.CompanyName As CompanyName,

			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			0,  --SalesTaxType
			
			pay.PaymentAmount,  --InvoiceTotalAmount
			p.Amount,  --SalesTaxAmount
			isnull((
				select sum(Amount) 
				from tPaymentDetail (nolock) where PaymentKey = p.PaymentKey and VoucherKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- TaxableAmount
			p.Amount,  --PaidCollected
			p.Amount,  --CollectableAmount
			p.Amount +isnull((
				select sum(Amount) 
				from tPaymentDetail (nolock) where PaymentKey = p.PaymentKey and VoucherKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  --TaxablePlusTax
			isnull((
				select sum(Amount) 
				from tPaymentDetail (nolock) where PaymentKey = p.PaymentKey and VoucherKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- CollectableTaxableAmount
			isnull((
				select sum(Amount) 
				from tPaymentDetail (nolock) where PaymentKey = p.PaymentKey and VoucherKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- CollectableSales
			0,  -- UpdateFlag
			0,  -- TotalNonTaxAmount
			p.Amount  -- OrigSalesTaxAmount
	from 
		(
	select pa.PaymentKey, pa.VendorKey, pd.SalesTaxKey, sum(Amount) As Amount
	from   tPayment pa (nolock)
	inner join tPaymentDetail pd (nolock) on pa.PaymentKey = pd.PaymentKey
	WHERE  pa.CompanyKey = @CompanyKey 
	and	   pa.PostingDate >= @StartDate
	and    pa.PostingDate <= @EndDate
	--and    (@GLCompanyKey = -1 OR ISNULL(pa.GLCompanyKey, 0) = @GLCompanyKey)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(pa.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(pa.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and isnull(pa.CurrencyID, '') = isnull(@CurrencyID, '') 
	and 	pd.SalesTaxKey > 0 
	group by pa.PaymentKey, pa.VendorKey, pd.SalesTaxKey
		) as p
	INNER JOIN tPayment pay (nolock) on pay.PaymentKey = p.PaymentKey
	INNER JOIN tSalesTax st (nolock) ON p.SalesTaxKey = st.SalesTaxKey
	INNER JOIN tCompany co (nolock) ON p.VendorKey = co.CompanyKey

	
			
	if @ShowCollected = 1
	-- must be grouped by CheckKey, SalesTaxKey
	Insert #taxes (InvoiceKey,ParentInvoiceKey,PercentageSplit,PostingDate,Type,Source,InvoiceNumber,InvoiceDate,CompanyName 
		,SalesTaxKey,SalesTaxID,SalesTaxName,TaxRate,PiggyBackTax,SalesTaxType 
		,InvoiceTotalAmount,SalesTaxAmount,TaxableAmountNoFlags,PaidCollected,CollectableAmount,TaxablePlusTax,CollectableTaxableAmount,CollectableSales 
		,UpdateFlag,TotalNonTaxAmount,OrigSalesTaxAmount 
		)
		SELECT
			ch.CheckKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			chk.PostingDate,
			'Collected Taxes' As Type,
			'Check' As Source,
			chk.ReferenceNumber,
			chk.CheckDate,
			co.CustomerID + ' - ' + co.CompanyName As CompanyName,

			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			0,  --SalesTaxType
			
			chk.CheckAmount,  --InvoiceTotalAmount
			ch.Amount,  --SalesTaxAmount
			isnull((
				select sum(Amount) 
				from tCheckAppl (nolock) where CheckKey = ch.CheckKey and InvoiceKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- TaxableAmount
			ch.Amount,  --PaidCollected
			ch.Amount,  --CollectableAmount
			ch.Amount +isnull((
				select sum(Amount) 
				from tCheckAppl (nolock) where CheckKey = ch.CheckKey and InvoiceKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  --TaxablePlusTax
			isnull((
				select sum(Amount) 
				from tCheckAppl (nolock) where CheckKey = ch.CheckKey and InvoiceKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- CollectableTaxableAmount
			isnull((
				select sum(Amount) 
				from tCheckAppl (nolock) where CheckKey = ch.CheckKey and InvoiceKey is null and isnull(SalesTaxKey, 0) = 0 
				),0),  -- CollectableSales
			0,  -- UpdateFlag
			0,  -- TotalNonTaxAmount
			ch.Amount  -- OrigSalesTaxAmount
	from 
		(
	select c.CheckKey, c.ClientKey, ca.SalesTaxKey, sum(Amount) As Amount
	from   tCheck c (nolock)
	inner join tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey
	WHERE  c.CompanyKey = @CompanyKey 
	and	   c.PostingDate >= @StartDate
	and    c.PostingDate <= @EndDate
	--and    (@GLCompanyKey = -1 OR ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') 
	and 	ca.SalesTaxKey > 0 
	group by c.CheckKey, c.ClientKey, ca.SalesTaxKey
		) as ch
	INNER JOIN tCheck chk (nolock) on ch.CheckKey = chk.CheckKey
	INNER JOIN tSalesTax st (nolock) ON ch.SalesTaxKey = st.SalesTaxKey
	INNER JOIN tCompany co (nolock) ON ch.ClientKey = co.CompanyKey

	-- now calculate the TaxableAmountFlags for entities other than invoices applied to AB
	update #taxes
	set    #taxes.TaxableAmount = #taxes.TaxableAmountNoFlags
	where  #taxes.Source = 'Check'

	-- invoices			
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    il.Taxable = 1	
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and    #taxes.Source <> 'AppliedToAB'
	and #taxes.SalesTaxType = 1
	
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    il.Taxable2 = 1	
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and    #taxes.Source <> 'AppliedToAB'
	and    #taxes.SalesTaxType = 2

	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		       inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey 
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    ilt.SalesTaxKey = #taxes.SalesTaxKey
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and    #taxes.Source <> 'AppliedToAB'
	and    #taxes.SalesTaxType = 3

	UPDATE #taxes
	SET    #taxes.TaxableAmount = (#taxes.TaxableAmount * #taxes.PercentageSplit) / 100
	WHERE  #taxes.Type = 'Collected Taxes'
	AND    ISNULL(#taxes.ParentInvoiceKey, 0) > 0   

	-- vouchers
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vd.Taxable = 1	
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 1
	
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vd.Taxable2 = 1	
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 2

	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		       inner join tVoucherDetailTax vdt (nolock) on vd.VoucherDetailKey = vdt.VoucherDetailKey 
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vdt.SalesTaxKey = #taxes.SalesTaxKey
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 3
				
	UPDATE #taxes
	SET    #taxes.TaxableAmount =  #taxes.TaxableAmount 
	      ,#taxes.TaxableAmountNoFlags =  #taxes.TaxableAmountNoFlags 
	WHERE  #taxes.Type = 'Paid Taxes'

	-- now calculate CollectableAmount,TaxablePlusTax
	UPDATE #taxes 
	SET		CollectableAmount = ISNULL(SalesTaxAmount, 0)
	       ,CollectableTaxableAmount = ISNULL(TaxableAmount, 0)
		   ,CollectableSales = ISNULL(TotalNonTaxAmount, 0)
		   ,TaxablePlusTax = ISNULL(TaxableAmount, 0) + ISNULL(SalesTaxAmount, 0)
		   ,CollectableTaxableAmountNoFlags = ISNULL(TaxableAmountNoFlags, 0)
	 WHERE  Source in ( 'Invoice', 'Voucher') -- No real invoices linked to AB 

	 if @PaidInvoicesOnly = 1
	 begin
		UPDATE #taxes 
		SET	    CollectableAmount = (ISNULL(CollectableAmount, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE  Source in ( 'Invoice', 'Voucher')  
		AND   ISNULL(InvoiceTotalAmount, 0) <> 0 

		UPDATE #taxes 
		SET	    CollectableTaxableAmount = (ISNULL(CollectableTaxableAmount, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE  Source in ( 'Invoice', 'Voucher')  
		AND   ISNULL(InvoiceTotalAmount, 0) <> 0 
		
		UPDATE #taxes 
		SET	    TaxablePlusTax = (ISNULL(TaxablePlusTax, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE  Source in ( 'Invoice', 'Voucher')  
		AND   ISNULL(InvoiceTotalAmount, 0) <> 0 
	 

		-- for 2nd bottom summary grid	 
		UPDATE #taxes 
		SET	    CollectableSales = (ISNULL(CollectableSales, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE  Source in ( 'Invoice', 'Voucher')  
		AND   ISNULL(InvoiceTotalAmount, 0) <> 0 
	 
		UPDATE #taxes 
		SET	    CollectableTaxableAmountNoFlags = (ISNULL(CollectableTaxableAmountNoFlags, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE  Source in ( 'Invoice', 'Voucher')  
		AND   ISNULL(InvoiceTotalAmount, 0) <> 0 

	 end


  /* Summary

05/10/11 GHL 10.543  (109459,107282) Creation to show at the bottom of the Sales Tax Report a summary
                      as described below
 
                            Collected                         Paid                       Net
Total Taxable             
Total Non Taxable         
Total w/o Tax             
Total Tax                
Total w Tax              

*/


declare @TotalTaxableC money,@TotalNonTaxableC money,@TotalwoTaxC money ,@TotalTaxC money ,@TotalwTaxC money  
declare @TotalTaxableP money,@TotalNonTaxableP money,@TotalwoTaxP money ,@TotalTaxP money ,@TotalwTaxP money  

/*

		TotalTaxable = sum of CollectableTaxableAmount
		TotalNonTaxable = TotalwoTax - TotalTaxable 
		TotalwoTax = sum of CollectableSales
		TotalTax =  sum of CollectableAmount
		TotalwTax money null -- will be calculated at the end
		
*/


update #taxes set UpdateFlag = 0
--166724 do not take adv bills without taxes, they are considered payments

update #taxes
set    #taxes.UpdateFlag = 1
from   tInvoice i (nolock)
where  #taxes.InvoiceKey = i.InvoiceKey
and    i.AdvanceBill = 1
and    isnull(i.SalesTaxAmount, 0) = 0 

-- select distinct because of multiple taxkey per invoice
-- also include Source because we have checks in there too
select @TotalTaxableC = sum(CollectableTaxableAmountNoFlags)
from (
	 select distinct InvoiceKey, Source, CollectableTaxableAmountNoFlags
	 from   #taxes
	 where  Type = 'Collected Taxes' 
	 ) as taxes

select @TotalwoTaxC = sum(CollectableSales)
from (
	 select distinct InvoiceKey, Source, CollectableSales
	 from   #taxes
	 where  Type = 'Collected Taxes' 
	 and    UpdateFlag = 0
	 ) as taxes

-- for the drill down
insert #details (InvoiceKey, Source, Amount)
select distinct InvoiceKey, Source, CollectableSales
	 from   #taxes
	 where  Type = 'Collected Taxes' 
	 and    UpdateFlag = 0
	 
-- these would be invoices not in the #taxes
-- see issue 172558 some invoices are posted but not in #taxes, so I add them up here
declare @ExtraSales money
select @ExtraSales = SUM(i.InvoiceTotalAmount - i.SalesTaxAmount)
from   tInvoice i (nolock)
where  i.CompanyKey = @CompanyKey
and    i.InvoiceKey not in (select InvoiceKey from #taxes)
and    i.PostingDate >= @StartDate and i.PostingDate <= @EndDate 
-- added for 214601
AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)

if @PaidInvoicesOnly = 0
begin
	select @TotalwoTaxC = isnull(@TotalwoTaxC, 0) + isnull(@ExtraSales, 0)

	insert #details (InvoiceKey, Source, Amount)
	select InvoiceKey, 'Invoice', isnull(InvoiceTotalAmount, 0) - isnull(SalesTaxAmount, 0)
	from   tInvoice i (nolock)
	where  i.CompanyKey = @CompanyKey
	and    i.InvoiceKey not in (select InvoiceKey from #taxes)
	and    i.PostingDate >= @StartDate and i.PostingDate <= @EndDate 
	-- added for 214601
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
				)	
end

select @TotalNonTaxableC = isnull(@TotalwoTaxC, 0) - isnull(@TotalTaxableC, 0)

select @TotalTaxC = sum(CollectableAmount)
from   #taxes
where  Type = 'Collected Taxes'   

select @TotalwTaxC = isnull(@TotalwoTaxC, 0) + isnull(@TotalTaxC, 0)


-- select distinct because of multiple taxkey
select @TotalTaxableP = sum(CollectableTaxableAmountNoFlags)
from (
	 select distinct InvoiceKey, Source, CollectableTaxableAmountNoFlags
	 from   #taxes
	 where  Type = 'Paid Taxes' 
	 ) as taxes

select @TotalwoTaxP = sum(CollectableSales)
from (
	 select distinct InvoiceKey, Source, CollectableSales
	 from   #taxes
	 where  Type = 'Paid Taxes' 
	 ) as taxes

select @TotalNonTaxableP = isnull(@TotalwoTaxP, 0) - isnull(@TotalTaxableP, 0)

select @TotalTaxP = sum(CollectableAmount)
from   #taxes
where  Type = 'Paid Taxes'   

select @TotalwTaxP = isnull(@TotalwoTaxP, 0) + isnull(@TotalTaxP, 0)


	if @SalesTaxKey >0
	delete #taxes 
	where  SalesTaxKey <> @SalesTaxKey

	update #taxes set UpdateFlag = 0

	update #taxes 
	set    #taxes.UpdateFlag = 1
	from   tInvoiceTax (nolock)
	where  #taxes.InvoiceKey = tInvoiceTax.InvoiceKey
	and    #taxes.Source in ( 'Invoice', 'AppliedToAB')
	  
    update #taxes 
	set    #taxes.UpdateFlag = 1
	from   tVoucherTax (nolock)
	where  #taxes.InvoiceKey = tVoucherTax.VoucherKey
	and    #taxes.Source = 'Voucher'
	
	-- delete them if not really a tax
	delete  #taxes where UpdateFlag = 0
	

	
 /*
 CREATE TABLE #summary (
	TotalName varchar(30) null
	,Collected money null
	,Paid money null
	,Net money null
                           Collected                         Paid                       Net
Total Taxable             
Total Non Taxable         
Total w/o Tax             
Total Tax                
Total w Tax              

*/

truncate table #summary
insert #summary (TotalName, Collected, Paid, Net)
values ('Total Taxable', isnull(@TotalTaxableC, 0), isnull(@TotalTaxableP, 0), isnull(@TotalTaxableC, 0) - isnull(@TotalTaxableP, 0) )
insert #summary (TotalName, Collected, Paid, Net)
values ('Total Non Taxable', isnull(@TotalNonTaxableC, 0), isnull(@TotalNonTaxableP, 0), isnull(@TotalNonTaxableC, 0) - isnull(@TotalNonTaxableP, 0) )
insert #summary (TotalName, Collected, Paid, Net)
values ('Total w/o Tax', isnull(@TotalwoTaxC, 0), isnull(@TotalwoTaxP, 0), isnull(@TotalwoTaxC, 0) - isnull(@TotalwoTaxP, 0) )
insert #summary (TotalName, Collected, Paid, Net)
values ('Total Tax', isnull(@TotalTaxC, 0), isnull(@TotalTaxP, 0), isnull(@TotalTaxC, 0) - isnull(@TotalTaxP, 0) )
insert #summary (TotalName, Collected, Paid, Net)
values ('Total w Tax', isnull(@TotalwTaxC, 0), isnull(@TotalwTaxP, 0), isnull(@TotalwTaxC, 0) - isnull(@TotalwTaxP, 0) )
   
	TRUNCATE TABLE #taxes_summary
		
	INSERT 	#taxes_summary (SalesTaxID,SalesTaxName,SalesTaxFullName,TaxCollected,TaxPaid,VAT,SalesTaxableAmount,PurchaseTaxableAmount,InvoiceTotalAmount) 	
    SELECT SalesTaxID,SalesTaxName,SalesTaxID + ' - ' + SalesTaxName 
    ,SUM(TaxCollected),SUM(TaxPaid),SUM(TaxCollected)-SUM(TaxPaid)
    ,SUM(SalesTaxableAmount),SUM(PurchaseTaxableAmount), SUM(InvoiceTotalAmount)
    FROM  
		(
    SELECT SalesTaxID, SalesTaxName
         , SUM(CollectableAmount)	AS TaxCollected
         , CAST(0 AS MONEY)			AS TaxPaid
         , SUM(TaxableAmount)		AS SalesTaxableAmount 
         , CAST(0 AS MONEY)			AS PurchaseTaxableAmount
		 , Sum(InvoiceTotalAmount)  AS InvoiceTotalAmount
    FROM  #taxes
    WHERE Type = 'Collected Taxes'
	--and    #taxes.SalesTaxAmount <> 0
	GROUP BY SalesTaxID, SalesTaxName
    
    UNION ALL
    
	SELECT SalesTaxID, SalesTaxName
         , CAST(0 AS MONEY)							AS TaxCollected
         , SUM(CollectableAmount)					AS TaxPaid
         , CAST(0 AS MONEY)							AS SalesTaxableAmount 
         , SUM(TaxableAmount)						AS PurchaseTaxableAmount
		 , Sum(InvoiceTotalAmount)                  AS InvoiceTotalAmount
    FROM  #taxes
    WHERE Type = 'Paid Taxes'
	--and    #taxes.SalesTaxAmount <> 0
    GROUP BY SalesTaxID, SalesTaxName
		) AS tax
	
	GROUP BY SalesTaxID, SalesTaxName
	ORDER BY SalesTaxName

	-- now take in account the PaidSign
	UPDATE #taxes
	set    InvoiceTotalAmount = @PaidSign * InvoiceTotalAmount
	      ,SalesTaxAmount = @PaidSign * SalesTaxAmount
	      ,TaxableAmount = @PaidSign * TaxableAmount
	      ,TaxableAmountNoFlags = @PaidSign * TaxableAmountNoFlags
	      ,PaidCollected = @PaidSign * PaidCollected
	      ,CollectableAmount = @PaidSign * CollectableAmount
	      ,TaxablePlusTax = @PaidSign * TaxablePlusTax
	      ,TotalNonTaxAmount = @PaidSign * TotalNonTaxAmount
	      ,OrigSalesTaxAmount = @PaidSign * OrigSalesTaxAmount
		  ,CollectableTaxableAmount = @PaidSign * CollectableTaxableAmount
		  ,CollectableTaxableAmountNoFlags = @PaidSign * CollectableTaxableAmountNoFlags
		  ,CollectableSales = @PaidSign * CollectableSales
	where  Type = 'Paid Taxes'
		
	-- if header has SalesTaxKey but no line Taxable removed them to give clients option to view it
	-- the way the report was before the Australian change
	--IF @ShowTaxAppliedLinesOnly = 1
	--	delete #taxes
	--	where  #taxes.SalesTaxAmount = 0
	
	IF @ShowTaxAppliedLinesOnly = 1
		delete #taxes
		where  isnull(TaxableAmount, 0) = 0
	
	/*
	Notes Gil 9/2/11
	There are 2 ways to look at the @ShowTaxAppliedLinesOnly
	
	1) can mean: only show where tax amount <> 0
	2) or: only show where taxable flag is set i.e taxable amount <> 0
	 
	Problem is that the users in AU and UK mark a line as Taxable and set Tax Amount = 0
	*/

	if @DetailsOnly = 0
	SELECT v.VoucherID, t.* 
	      ,isnull(t.TaxableAmount, 0) + isnull(t.SalesTaxAmount, 0) as Total
	  FROM #taxes t LEFT JOIN tVoucher v (nolock) ON (v.VoucherKey = t.InvoiceKey AND
	                                                  t.Source = 'Voucher')
	 where  (@SalesTaxKey = 0 Or t.SalesTaxKey = @SalesTaxKey)
	Order By t.SalesTaxID, Type, t.PostingDate, t.InvoiceNumber
	

	RETURN 1
GO
