USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailPrebill]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailPrebill]

	(
		@PurchaseOrderDetailKey int,
		@UserKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 02/23/07 GHL 8.4   Added Project Rollup
|| 05/14/07 BSH 8.4.3 Defaulted Class from Order to be passed to the Invoice. 
|| 08/07/07 GHL 8.5   Added call to Invoice Summary
|| 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
|| 10/04/07	BSH 8.5   Added GLCompanyKey, OfficeKey, DepartmentKey, reqd. params for Invoice Inserts. 
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
|| 10/21/09 GHL 10.513 Moved sptInvoiceLineUpdateTotals outside of SQL tran because it creates a temp table 
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 10/01/13 GHL 10.573 Added multi currency logic and calculate AmountBilled from PTotalCost (not TotalCost)
|| 11/07/13 GHL 10.574 pod.AccruedCost is in HC
|| 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
*/

Declare @CurKey int, @ProjectKey int, @PostSalesUsingDetail tinyint
declare @ClassKey int
declare @NewInvoiceKey int	
declare @NewInvoiceLineKey int
Declare @PurchaseOrderKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContact varchar(100)
declare @PrimaryContactKey int 
declare @DefaultSalesAccountKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @ProjectName varchar(100)
declare @DefaultARAccountKey int
declare @InvoiceAmount money
Declare @InvoiceTemplateKey int, @SalesTaxKey int, @SalesTax2Key int, @BillAt smallint, @GLCompanyKey int
Declare @Taxable int, @Taxable2 int
Declare @LayoutKey int
Declare @PCurrencyID varchar(10)
Declare @PExchangeRate decimal(24,7) -- Billing or Project Exchange Rate
Declare @ExchangeRate decimal(24,7) -- Exchange Rate on the PO

If not exists(Select 1 from tPurchaseOrderDetail (NOLOCK) 
	Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey and ISNULL(AmountBilled, 0) = 0 and ISNULL(AppliedCost, 0) = 0)
	Return -1
	
Select @ProjectKey = ProjectKey, @PurchaseOrderKey = PurchaseOrderKey, @ClassKey = ClassKey
       ,@Taxable = isnull(Taxable,0),@Taxable2 = isnull(Taxable2, 0) 
	   ,@PCurrencyID = PCurrencyID, @PExchangeRate = isnull(PExchangeRate, 1)
from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
if ISNULL(@ProjectKey, 0) = 0
	Return -2
	
Select @ClientKey = ClientKey, @CompanyKey = CompanyKey from tProject (NOLOCK) Where ProjectKey = @ProjectKey
if ISNULL(@ClientKey, 0) = 0
	Return -3
	
Select @BillAt = ISNULL(BillAt, 0)
      ,@ExchangeRate = ISNULL(ExchangeRate, 1) 
From tPurchaseOrder (NOLOCK) Where PurchaseOrderKey = @PurchaseOrderKey

select @TodaysDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)

Select @InvoiceTemplateKey = ISNULL(InvoiceTemplateKey, 0)
, @SalesTaxKey = SalesTaxKey, @SalesTax2Key = SalesTax2Key
, @LayoutKey = LayoutKey
from tCompany Where CompanyKey = @ClientKey

--get invoice defaults
select @CompanyKey = p.CompanyKey
		,@BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
	    ,@PrimaryContactKey = u.UserKey
	    ,@ProjectName = p.ProjectName
	    ,@DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, 0)
	    ,@GLCompanyKey = p.GLCompanyKey
	from tProject p (nolock) 
		inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tUser u (nolock) on p.BillingContact = u.UserKey
	where p.ProjectKey = @ProjectKey

if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = DefaultSalesAccountKey
		From tPreference (NOLOCK) 
		Where CompanyKey = @CompanyKey
		
--get default AR accont key
	select @DefaultARAccountKey = DefaultARAccountKey, @PostSalesUsingDetail = PostSalesUsingDetail
	  from tPreference (NOLOCK) 
	 where CompanyKey = @CompanyKey
	 
	 
	--encapsulate entire update in a transaction
	begin tran

	exec @RetVal = sptInvoiceInsert
		@CompanyKey
		,@ClientKey
		,@BillingContact
		,@PrimaryContactKey
		,NULL									-- Address Key
		,0										-- Advance Bill
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
		,@GLCompanyKey                          --GLCompany
		,NULL                                   --NULL
		,0										--OpeningTransaction
		,@LayoutKey
		,@PCurrencyID
		,@PExchangeRate
		,0 -- do not request new rate
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
		,@ProjectName					-- Line Subject
		,null                 		-- Line description
		,2                    		-- Bill From 
		,0							-- Quantity
		,0							-- Unit Amount
		,0							-- Line Amount
		,2							-- line type
		,0							-- parent line key
		,@DefaultSalesAccountKey	-- Default Sales AccountKey
		,NULL                    	-- Class Key
		,@Taxable							-- Taxable
		,@Taxable2							-- Taxable2
		,NULL						-- Work TypeKey
		,@PostSalesUsingDetail
		,NULL						-- @Entity
		,NULL						-- @EntityKey
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
			, AccruedCost = ROUND(TotalCost * @ExchangeRate, 2)
			, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		else if @BillAt = 1  --Net
			Update tPurchaseOrderDetail Set AmountBilled = ISNULL(PTotalCost, TotalCost)
			, AccruedCost = ROUND(TotalCost * @ExchangeRate, 2)
			, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		else if @BillAt = 2 --Commission Only
			Update tPurchaseOrderDetail Set AmountBilled = BillableCost - ISNULL(PTotalCost, TotalCost)
			, AccruedCost = 0, InvoiceLineKey = @NewInvoiceLineKey
			Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				
	commit transaction
		
	exec sptInvoiceLineUpdateTotals @NewInvoiceLineKey
			
	-- rollup for the projects in the po and all trantypes = -1 (including billing) 
	exec sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1
		
	return @NewInvoiceKey
GO
