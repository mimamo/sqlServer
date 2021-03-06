USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditInsertFromAdvanceBill]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditInsertFromAdvanceBill]
	(
		@AdvBillInvoiceKey int
		,@oCreditInvoiceKey int output
		,@oNewInvoiceKey int output
	)
AS --Encrypt
	
	SET NOCOUNT ON
	
/*
   Need a way to clean up their unapplied advance bills (positive and negative).
              
   I (MW) tried writing off the advance bill and that only removes the open amount on the advance bill, 
   but the unapplied amount on that advance bill is still available to be applied to other client invoices.
         
   Add an action to advance billing invoices that have an open unapplied amount. action is "Create Credit".
   This would apply the open advance billing amount to itself (effectively closing it down). 
   Then a credit for the same amount is created (negative invoice). 
   Header goes to ar and the line goes to the advance billing account in system preferences. 
   the description for the line is "Credit Client for Unused Advance Bill Amount"
   
   This will unaccrue the amount out of the adv bill account
*/	
	
/*
|| When     Who Rel    What
|| 05/08/07 GHL 8.5    Creation for enhancement 6668.
|| 05/14/07 GHL 8.5    Create a tInvoiceAdvanceBill record rather than a tInvoiceCredit record
||                     The tInvoiceAdvanceBill record is just a trick to close the adv bill
|| 05/14/07 GHL 8.5    If taxes, only allow if unposted 
|| 11/19/07 GHL 8.5    Added GLCompanyKey, OfficeKey
|| 06/18/08 GHL 8.513  Added OpeningTransaction
|| 03/30/09 GHL 10.022 Instead of creating a tInvoiceAdvanceBill against the Advance Bill
||                     Must create a new invoice and apply tInvoiceAdvanceBill against new one
||                     Same posting dates for new invoice and credit memo
||                     Must return 2 new invoice keys back and open up 2 windows
|| 05/14/09 GHL 10.025 Changed GL accounts for both new invoices to AR/Sales instead of
||                     AR/AB for credit memo
||                     AR/AR for regular invoice
|| 11/11/09 GHL 10.513 (67884) Added calls to sptInvoiceRollupAmounts because we removed
||                     sptInvoiceRecalcAmounts from sptInvoiceLineInsert (because Sales Taxes
||                     are entered on the UI and a separate call is made in the UI to do the rollup)
|| 03/24/10 GHL 10.521 Added LayoutKey
|| 12/10/12 GHL 10.563 Added handling of taxes (SalesTaxKey, SalesTax2Key and tInvoiceLineTax)
||                     when creating credit and regular invoices
|| 5/9/13   GWG 10.567 When there was tax on the advance it was not properly calculating
|| 10/01/13 GHL 10.573 Added multi currency logic
|| 01/03/14 WDF 10.576 (188500) Added @CreatedByKey
*/
	
	-- My vars for amount validation
	Declare @AppliedAdvBill money
			,@InvoiceTotalAmount money
			,@OpenAmount money
			,@SalesTaxAmount money
			,@SalesTax1Amount money
			,@SalesTax2Amount money


	-- My vars for invoice creation
	Declare @RetVal int
			,@CompanyKey int
 			,@ClientKey int
 			,@InvoiceDate smalldatetime 
			,@PostingDate smalldatetime 
 			,@DueDate smalldatetime
 			,@ContactName varchar(100) 
			,@AddressKey int
 			,@PrimaryContactKey int
 			,@ARAccountKey int
 			,@SalesAccountKey int
 			,@ClassKey int
 			,@ProjectKey int
 			,@ApprovedByKey int
 			,@NewInvoiceKey int
 			,@NewInvoiceLineKey int
 			,@Posted int
 			,@GLCompanyKey int
 			,@OfficeKey int
			,@SalesTaxKey int
			,@SalesTax2Key int
			,@Taxable int
			,@Taxable2 int
 		    ,@Taxable3 int
			,@CurrencyID varchar(10)
			,@ExchangeRate decimal(24,7)
			,@CreatedByKey int
				
	create table #tax (
		SalesTaxKey int null
		,SalesTaxAmount money null
		,AppliedAmount money null
		,OpenAmount money null
		,Type int null
		)

	-- Capture what was applied
	Select @AppliedAdvBill = Sum(Amount) 
	from   tInvoiceAdvanceBill (nolock) 
	Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
	
	
	insert #tax (SalesTaxKey, SalesTaxAmount, Type)
	select SalesTaxKey, Sum(SalesTaxAmount), Type
	from   tInvoiceTax (nolock)
	where  InvoiceKey = @AdvBillInvoiceKey
	group by SalesTaxKey, Type

	update #tax
	set    #tax.AppliedAmount = ISNULL((
		select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock) where iabt.AdvBillInvoiceKey = @AdvBillInvoiceKey
		and  iabt.SalesTaxKey = #tax.SalesTaxKey
		), 0)

	update #tax
	set    OpenAmount = isnull(SalesTaxAmount,0) - isnull(AppliedAmount, 0) 

	delete #tax where OpenAmount <= 0
		
	select @Taxable = 0
	select @Taxable2 = 0
	select @Taxable3 = 0

	select @SalesTax1Amount =  sum(OpenAmount) from #tax where Type = 1
	select @SalesTax2Amount =  sum(OpenAmount) from #tax where Type = 2
	select @SalesTaxAmount =  sum(OpenAmount) from #tax where Type = 3 -- will be corrected later

	select @SalesTax1Amount =  isnull(@SalesTax1Amount, 0)
	select @SalesTax2Amount =  isnull(@SalesTax2Amount, 0)
	select @SalesTaxAmount =  isnull(@SalesTaxAmount, 0)

	if @SalesTax1Amount <> 0
		select @Taxable = 1
	if @SalesTax2Amount <> 0
		select @Taxable2 = 1
    if @SalesTaxAmount <> 0
		select @Taxable3 = 1

    select @SalesTaxAmount =  sum(OpenAmount) from #tax
	select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)

	Select @InvoiceTotalAmount = InvoiceTotalAmount
		  --,@SalesTaxAmount = ISNULL(SalesTaxAmount, 0)
		  ,@CompanyKey = CompanyKey
		  ,@ClientKey = ClientKey
		  ,@ContactName = ContactName
		  ,@AddressKey = AddressKey
		  ,@PrimaryContactKey = PrimaryContactKey
		  ,@ARAccountKey = ARAccountKey
		  ,@ClassKey = ClassKey
		  ,@ProjectKey = ProjectKey
		  ,@ApprovedByKey = ApprovedByKey
		  ,@Posted = Posted
		  ,@GLCompanyKey = GLCompanyKey
		  ,@OfficeKey = OfficeKey
		  ,@SalesTaxKey = SalesTaxKey
		  ,@SalesTax2Key = SalesTax2Key
		  ,@CurrencyID = CurrencyID
		  ,@ExchangeRate = isnull(ExchangeRate, 1) 
		  ,@CreatedByKey = CreatedByKey 
	From tInvoice (nolock) 
	Where InvoiceKey = @AdvBillInvoiceKey
	
	IF @@ROWCOUNT = 0
		Return 1
		
	-- commented out 4/10/09 could not explain why 	
	--IF @Posted = 1 AND @SalesTaxAmount > 0
	--	Return -1
	
	-- Perfom same validations than when inserting Advance Bill record 
	-- Not sure of case when advance billing is negative
	
	-- Same validation as inserting Advance Bill
	Select @OpenAmount = ISNULL(@InvoiceTotalAmount, 0) - ISNULL(@AppliedAdvBill, 0)
	
	if @OpenAmount <= 0
		Return -2 	
		
    declare @LineTotalAmount money
	select @LineTotalAmount = isnull(@OpenAmount, 0) - isnull(@SalesTaxAmount, 0)
  	
  	-- Make it a credit memo (i.e. negative)
 	Select @OpenAmount = -1 * @OpenAmount
 	      ,@SalesTaxAmount = -1 * @SalesTaxAmount
		  ,@SalesTax1Amount = -1 * @SalesTax1Amount
		  ,@SalesTax2Amount = -1 * @SalesTax2Amount
		  ,@LineTotalAmount = -1 * @LineTotalAmount


 	Select @SalesAccountKey = DefaultSalesAccountKey
 	From   tCompany (nolock)
 	Where  CompanyKey = @ClientKey
 	
 	If isnull(@SalesAccountKey, 0) = 0
		Select @SalesAccountKey = DefaultSalesAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey
	
 	Select @InvoiceDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
	Select @PostingDate = @InvoiceDate, @DueDate = @InvoiceDate
 			
 	If Not Exists (Select 1 From tGLAccount (nolock) Where GLAccountKey = @ARAccountKey)
 		Return -3

 	If Not Exists (Select 1 From tGLAccount (nolock) Where GLAccountKey = @SalesAccountKey)
 		Return -4
 			
	/*				
	|| Create an invoice (Credit Memo) AR/SALES
	*/

	Declare @LineSubject varchar(100)
	Select @LineSubject = 'Credit Client for Unused Advance Bill Amount'

	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@ContactName
						,@PrimaryContactKey
						,@AddressKey
						,0										--AdvanceBill 
						,null               					--InvoiceNumber
						,@InvoiceDate        					--InvoiceDate
						,@DueDate					  			--Due Date
						,@PostingDate				 			--Posting Date
						,null			  						--TermsKey
						,@ARAccountKey							--Default AR Account
						,@ClassKey								--ClassKey
						,@ProjectKey							--Project Key
						,@LineSubject				 			--HeaderComment
						,@SalesTaxKey							 		--SalesTaxKey 
						,@SalesTax2Key							 		--SalesTax2Key 
						,null									--Invoice Template Key
						,@ApprovedByKey							--ApprovedBy Key
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
						,0
						,@CreatedByKey
						,@GLCompanyKey 
						,@OfficeKey
						,0										--OpeningTransaction
						,null									--LayoutKey	
						,@CurrencyID
						,@ExchangeRate
						,0 -- do not request new exchange rate	
						,@NewInvoiceKey output
	if @@ERROR <> 0 
	  begin
		return -5					   	
	  end
	if @RetVal <> 1 
	 begin
		return -5					   	
	  end
	  
 
	--create single invoice line
	exec @RetVal = sptInvoiceLineInsertMassBilling
					@NewInvoiceKey				-- Invoice Key
					,@ProjectKey				-- ProjectKey
					,null						-- TaskKey
					,@LineSubject				-- Line Subject
					,null				        -- Line description
					,1							-- Bill From 
					,1							-- Quantity
					,@LineTotalAmount			-- Unit Amount
					,@LineTotalAmount			-- Total Amount
					,2							-- line type
					,0							-- parent line key
					,@SalesAccountKey			-- Default Sales AccountKey
					,@ClassKey					-- Class Key
					,0							-- Taxable
					,0							-- Taxable2
					,null						-- Work TypeKey
					,0							-- PostSalesUsingDetail
					,null						-- Entity
					,null						-- EntityKey
					,@OfficeKey					
					,null						-- DepartmentKey
					,@NewInvoiceLineKey output
					
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -6					   	
		end					  
	if @RetVal <> 1 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -6					   	
		end 
	  
	-- now set up the tax amounts
	update tInvoiceLine
	set    Taxable = @Taxable
	      ,Taxable2 = @Taxable2
		  ,SalesTaxAmount = @SalesTaxAmount
		  ,SalesTax1Amount = @SalesTax1Amount
		  ,SalesTax2Amount = @SalesTax2Amount
	where InvoiceLineKey = @NewInvoiceLineKey

	if @Taxable3 = 1
		insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
		select @NewInvoiceLineKey, SalesTaxKey, -1 * OpenAmount
		from   #tax
		where  Type = 3

	-- rollup amounts from line to invoice
	exec sptInvoiceRollupAmounts @NewInvoiceKey
	  
	select @oCreditInvoiceKey = @NewInvoiceKey	
	  
	  
	-- Make it positive again
 	Select @OpenAmount = -1 * @OpenAmount
 	      ,@SalesTaxAmount = -1 * @SalesTaxAmount
		  ,@SalesTax1Amount = -1 * @SalesTax1Amount
		  ,@SalesTax2Amount = -1 * @SalesTax2Amount
		  ,@LineTotalAmount = -1 * @LineTotalAmount

	 select @LineTotalAmount = isnull(@OpenAmount, 0) - isnull(@SalesTaxAmount, 0)

	/*				
	|| Create another invoice -- Posting should be AR/AR
	*/

	Select @LineSubject = 'New Invoice for Unused Advance Bill Amount'

	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@ContactName
						,@PrimaryContactKey
						,@AddressKey
						,0										--AdvanceBill 
						,null               					--InvoiceNumber
						,@InvoiceDate        					--InvoiceDate
						,@DueDate					  			--Due Date
						,@PostingDate				 			--Posting Date
						,null			  						--TermsKey
						,@ARAccountKey							--Default AR Account
						,@ClassKey								--ClassKey
						,@ProjectKey							--Project Key
						,@LineSubject				 			--HeaderComment
						,@SalesTaxKey							 		--SalesTaxKey 
						,@SalesTax2Key							 		--SalesTax2Key 
						,null									--Invoice Template Key
						,@ApprovedByKey							--ApprovedBy Key
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
						,0
						,@CreatedByKey
						,@GLCompanyKey 
						,@OfficeKey
						,0										--OpeningTransaction	
						,null									--LayoutKey		
						,@CurrencyID
						,@ExchangeRate
						,0 -- do not request new exchange rate														
						,@NewInvoiceKey output
	if @@ERROR <> 0 
	  begin
		exec sptInvoiceDelete @oCreditInvoiceKey
		return -5					   	
	  end
	if @RetVal <> 1 
	 begin
		exec sptInvoiceDelete @oCreditInvoiceKey
		return -5					   	
	  end
	  	  
	--create single invoice line
	exec @RetVal = sptInvoiceLineInsertMassBilling
					@NewInvoiceKey				-- Invoice Key
					,@ProjectKey				-- ProjectKey
					,null						-- TaskKey
					,@LineSubject				-- Line Subject
					,null				        -- Line description
					,1							-- Bill From 
					,1							-- Quantity
					,@LineTotalAmount		-- Unit Amount
					,@LineTotalAmount		-- Line Amount
					,2							-- line type
					,0							-- parent line key
					,@SalesAccountKey			-- Default Sales AccountKey
					,@ClassKey					-- Class Key
					,0							-- Taxable
					,0							-- Taxable2
					,null						-- Work TypeKey
					,0							-- PostSalesUsingDetail
					,null						-- Entity
					,null						-- EntityKey
					,@OfficeKey					
					,null						-- DepartmentKey
					,@NewInvoiceLineKey output
					
	if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @oCreditInvoiceKey
			exec sptInvoiceDelete @NewInvoiceKey
		return -6					   	
		end					  
	if @RetVal <> 1 
		begin
			exec sptInvoiceDelete @oCreditInvoiceKey
			exec sptInvoiceDelete @NewInvoiceKey
		return -6					   	
		end 

	-- now set up the tax amounts
	update tInvoiceLine
	set    Taxable = @Taxable
	      ,Taxable2 = @Taxable2
		  ,SalesTaxAmount = @SalesTaxAmount
		  ,SalesTax1Amount = @SalesTax1Amount
		  ,SalesTax2Amount = @SalesTax2Amount
	where InvoiceLineKey = @NewInvoiceLineKey

	if @Taxable3 = 1
		insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
		select @NewInvoiceLineKey, SalesTaxKey, OpenAmount
		from   #tax
		where  Type = 3

	-- rollup amounts from line to invoice
	exec sptInvoiceRollupAmounts @NewInvoiceKey

	select @oNewInvoiceKey = @NewInvoiceKey
		

	Insert tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount)
	Values (@oNewInvoiceKey, @AdvBillInvoiceKey, @OpenAmount)

	if @@ERROR <> 0
		begin
		exec sptInvoiceDelete @oCreditInvoiceKey
		exec sptInvoiceDelete @oNewInvoiceKey
		return -7					   	
		end 
		
	Insert tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
	select @oNewInvoiceKey, @AdvBillInvoiceKey, SalesTaxKey, OpenAmount
	from   #tax

	Select @AppliedAdvBill = Sum(Amount) from tInvoiceAdvanceBill (nolock) 
	Where InvoiceKey = @oNewInvoiceKey and InvoiceKey <> AdvBillInvoiceKey

	Update tInvoice Set RetainerAmount = ISNULL(@AppliedAdvBill, 0) 
	Where InvoiceKey = @oNewInvoiceKey

	exec sptInvoiceUpdateAmountPaid @oCreditInvoiceKey
	exec sptInvoiceUpdateAmountPaid @oNewInvoiceKey
  	exec sptInvoiceUpdateAmountPaid @AdvBillInvoiceKey
  
	RETURN 1
GO
