USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderPrebill]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderPrebill]

	(
		@PurchaseOrderKey int,
		@UserKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 02/23/07 GHL 8.4   Added project rollup
|| 05/14/07 BSH 8.4.3 Defaulted Class from Order to be passed to the Invoice.
|| 08/07/07 GHL 8.5   Added invoice summary rollup 
|| 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
|| 10/03/07 BSH 8.5   Added GLCompanyKey and OfficeKey parameters required by the InvoiceInsert sp. 
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
|| 10/21/09 GHL 10.513 Moved sptInvoiceLineUpdateTotals outside of SQL tran because it creates a temp table 
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 10/01/13 GHL 10.573 Added multi currency logic and calculate AmountBilled from PTotalCost (not TotalCost)
|| 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
|| 10/10/14 GHL 10.585 (232692) Request a new exchange rate when creating the invoice 
*/

Declare @CurKey int, @ProjectKey int, @PostSalesUsingDetail tinyint
declare @ClassKey int
declare @NewInvoiceKey int	
declare @NewInvoiceLineKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContact varchar(100) 
declare @PrimaryContactKey int
declare @DefaultSalesAccountKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @LineSubject varchar(100)
declare @DefaultARAccountKey int
declare @InvoiceAmount money
Declare @InvoiceTemplateKey int, @SalesTaxKey int, @SalesTax2Key int, @BillAt smallint
declare @IOClientLink smallint
declare @BCClientLink smallint
declare @POKind smallint 
declare @MediaEstimateKey int
declare @GLCompanyKey int
declare @LayoutKey int
declare @MultiCurrency int
declare @PCurrencyID varchar(10)
declare @CurrencyCount int
declare @PExchangeRate decimal(24, 7) -- Project Exchange Rate
declare @ExchangeRate decimal(24, 7)  -- PO Exchange Rate

If not exists(Select 1 from tPurchaseOrderDetail (nolock)
	Where PurchaseOrderKey = @PurchaseOrderKey and ISNULL(AmountBilled, 0) = 0 and ISNULL(AppliedCost, 0) = 0)
	Return -1

if exists(Select 1 from tPurchaseOrderDetail pd (nolock) inner join tProject p (nolock) on pd.ProjectKey = p.ProjectKey
	Where p.Closed = 1 and pd.PurchaseOrderKey = @PurchaseOrderKey)
	Return -4
	
Select @ProjectKey = ProjectKey,
       @CompanyKey = CompanyKey,
       @BillAt = ISNULL(BillAt, 0),
       @POKind = POKind,
       @ClassKey = ClassKey,
       @MediaEstimateKey = MediaEstimateKey,
       @GLCompanyKey = GLCompanyKey,
	   @ExchangeRate = ISNULL(ExchangeRate, 1)
  from tPurchaseOrder (nolock)
 Where PurchaseOrderKey = @PurchaseOrderKey
 
--get preferences - default AR account key, client link setings
select @DefaultARAccountKey = DefaultARAccountKey,
	   @PostSalesUsingDetail = PostSalesUsingDetail,
	   @IOClientLink = IOClientLink,
	   @BCClientLink = BCClientLink,
	   @MultiCurrency = isnull(MultiCurrency, 0)
  from tPreference (nolock)
 where CompanyKey = @CompanyKey
	 
if (@POKind = 1 and @IOClientLink = 1) or (@POKind = 2 and @BCClientLink = 1)
	begin	 
		if isnull(@ProjectKey, 0) = 0
			return -2
		
		select @ClientKey = ClientKey from tProject (nolock) Where ProjectKey = @ProjectKey
		if isnull(@ClientKey, 0) = 0
			return -3

		--get invoice defaults
		select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100),
			   @PrimaryContactKey = u.UserKey,
			   @LineSubject = p.ProjectName
		  from tProject p (nolock) 
			   left outer join tUser u (nolock) on p.BillingContact = u.UserKey
		 where p.ProjectKey = @ProjectKey			
	end

if (@POKind = 1 and @IOClientLink = 2) or (@POKind = 2 and @BCClientLink = 2)
	begin	 
		if isnull(@MediaEstimateKey, 0) = 0
			return -7
		
		select @ClientKey = ClientKey,
		       @LineSubject = left(isnull(EstimateName,EstimateID),100)
		  from tMediaEstimate (nolock) 
		 where MediaEstimateKey = @MediaEstimateKey
		 
		if isnull(@ClientKey, 0) = 0
			return -8
			
		--get invoice defaults
		if isnull(@ProjectKey, 0) <> 0 					
		    select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				  ,@PrimaryContactKey = u.UserKey
		      from tProject p (nolock) 
			       left outer join tUser u (nolock) on p.BillingContact = u.UserKey
		     where p.ProjectKey = @ProjectKey		
	end
	
-- Added this statement because the case @POKind = 0 is missing above
IF ISNULL(@ClientKey, 0) = 0
BEGIN
	if ISNULL(@ProjectKey, 0) = 0
		Return -2
		
		--get invoice defaults
		select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100),
			   @PrimaryContactKey = u.UserKey,	
			   @LineSubject = p.ProjectName,
			   @ClientKey = ClientKey
		  from tProject p (nolock) 
			   left outer join tUser u (nolock) on p.BillingContact = u.UserKey
		 where p.ProjectKey = @ProjectKey			

		if ISNULL(@ClientKey, 0) = 0
			Return -3
END	
	
-- At this time, I can only create an invoice if all lines have the same currency
if @MultiCurrency = 0
begin
	select @PCurrencyID = null
	      ,@PExchangeRate = 1 
end
else
begin
	select @CurrencyCount = count(distinct isnull(PCurrencyID, '')) from tPurchaseOrderDetail (nolock) 
	where PurchaseOrderKey = @PurchaseOrderKey
	
	if  @CurrencyCount > 1
		Return -9

	-- get info from any detail line
	select @PCurrencyID = PCurrencyID, @PExchangeRate = isnull(PExchangeRate, 1) 
	from tPurchaseOrderDetail (nolock) 
	where PurchaseOrderKey = @PurchaseOrderKey

	if @PCurrencyID = ''
		select @PCurrencyID = null

	if isnull(@PExchangeRate, 0) <= 0
		select @PExchangeRate = 1
end

select @TodaysDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)

Select @InvoiceTemplateKey = ISNULL(InvoiceTemplateKey, 0),
       @SalesTaxKey = SalesTaxKey,
       @SalesTax2Key = SalesTax2Key,
       @DefaultSalesAccountKey = isnull(DefaultSalesAccountKey, 0),
       @LayoutKey = LayoutKey
from tCompany (nolock) Where CompanyKey = @ClientKey

--get invoice defaults
if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = DefaultSalesAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey
	 
	 
	--encapsulate entire update in a transaction
	begin tran

	exec @RetVal = sptInvoiceInsert
		@CompanyKey
		,@ClientKey
		,@BillingContact
		,@PrimaryContactKey
		,NULL									-- Address Key
		,0
		,null               					--InvoiceNbumber
		,@TodaysDate        					--InvoiceDate
		,@TodaysDate				        	--Due Date
		,@TodaysDate				        	--Posting Date
		,null			   						--TermsKey
		,@DefaultARAccountKey					--Default AR Account
		,@ClassKey								--ClassKey
		,@ProjectKey							--ProjectKey
		,null               					--HeaderComment
		,@SalesTaxKey					 		--SalesTaxKey
		,@SalesTax2Key					 		--SalesTax2Key
		,@InvoiceTemplateKey					--Invoice Template Key
		,@UserKey								--ApprovedBy Key
		,NULL									--User Defined 1
		,NULL									--User Defined 2
		,NULL									--User Defined 3
		,NULL									--User Defined 4
		,NULL									--User Defined 5
		,NULL									--User Defined 6
		,NULL									--User Defined 7
		,NULL									--User Defined 8
		,NULL									--User Defined 9
		,NULL									--User Defined 10
		,0
		,0
		,0
		,0										--Emailed
		,@UserKey								--CreatedByKey
		,@GLCompanyKey
		,NULL                                   --OfficeKey
		,0										--OpeningTransaction
		,@LayoutKey
		,@PCurrencyID
		,@PExchangeRate
		,1 -- Request for new rate
		,@NewInvoiceKey output
	if @RetVal <> 1 
	  begin
		rollback tran
		return -5					   	
	  end
	if @@ERROR <> 0 
	  begin
		rollback tran
		return -5					   	
	  end
		
	if @PostSalesUsingDetail = 1
		Select @DefaultSalesAccountKey = NULL

	--create single invoice line
	exec @RetVal = sptInvoiceLineInsert
		@NewInvoiceKey				-- Invoice Key
		,@ProjectKey					-- ProjectKey
		,NULL							-- TaskKey
		,@LineSubject					-- Line Subject
		,null                 		-- Line description
		,2             		-- Bill From 
		,0							-- Quantity
		,0							-- Unit Amount
		,0							-- Line Amount
		,2							-- line type
		,0							-- parent line key
		,@DefaultSalesAccountKey		-- Default Sales AccountKey
		,NULL                    		-- Class Key
		,0							-- Taxable
		,0							-- Taxable2
		,NULL						-- Work TypeKey
		,@PostSalesUsingDetail
		,NULL						-- Entity
		,NULL						-- EntityKey
		,NULL                       -- OfficeKey
		,NULL                       -- DepartmentKey
		,@NewInvoiceLineKey output
					  
		if @RetVal <> 1 
		  begin
			rollback tran
			return -6					   	
		  end
		if @@ERROR <> 0 
		  begin
			rollback tran
			return -6					   	
		  end			
		  
		if @BillAt = 0  --Gross
			Update tPurchaseOrderDetail Set AmountBilled = BillableCost
			, AccruedCost = Round(TotalCost *@ExchangeRate, 2)
			, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderKey = @PurchaseOrderKey and ISNULL(AmountBilled, 0) = 0 and ISNULL(AppliedCost, 0) = 0
		else if @BillAt = 1  --Net
			Update tPurchaseOrderDetail Set AmountBilled = ISNULL(PTotalCost, TotalCost)
			, AccruedCost = Round(TotalCost *@ExchangeRate, 2)
			, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderKey = @PurchaseOrderKey and ISNULL(AmountBilled, 0) = 0 and ISNULL(AppliedCost, 0) = 0
		else if @BillAt = 2 --Commission Only
			Update tPurchaseOrderDetail Set AmountBilled = BillableCost - ISNULL(PTotalCost, TotalCost), AccruedCost = 0, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderKey = @PurchaseOrderKey and ISNULL(AmountBilled, 0) = 0 and ISNULL(AppliedCost, 0) = 0
			
	commit transaction

	exec sptInvoiceLineUpdateTotals @NewInvoiceLineKey

	-- rollup for all projects in the po and all trantypes (including billing) 
	Declare @RecalcAll int
	Select @RecalcAll = 1 
	exec sptProjectRollupUpdateEntity 'tPurchaseOrder', @PurchaseOrderKey, 1
			
	return @NewInvoiceKey
GO
