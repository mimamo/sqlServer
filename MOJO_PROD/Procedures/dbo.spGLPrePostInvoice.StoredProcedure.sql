USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostInvoice]

	(
		@CompanyKey int,
		@InvoiceKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/23/06 CRG 8.35  Modified to match the posting routine.
|| 05/02/07 GHL 8.5   Added changes for advance bill sales taxes
|| 06/08/07 GHL 8.43  (9450) Added protection against null GL account keys
||                    in PostSalesUsingDetail case. Causing unbalanced GL 
|| 10/24/07 GHL 8.5   Lifted ambiguity on tInvoiceLine.SalesTaxAmount
*/

Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @InvoiceStatus smallint
Declare @GLKey int
Declare @CurKey int
Declare @GLClosedDate smalldatetime
--Declare @InvoiceType smallint
Declare @TranDate smalldatetime

-- Transaction Variables
Declare @TransactionDate smalldatetime
Declare @EntityKey int
Declare @GLAccountKey int
Declare @Amount money
Declare @Standard money
Declare @ClassKey int
Declare @Memo varchar(500)
Declare @ProjectKey int
Declare @ClientKey int
Declare @RetVal int
Declare @HeaderType char(1)
Declare @DetailType char(1)
Declare @SalesTaxKey int
Declare @SalesTaxAccountKey int
Declare @SalesTaxAmount money
Declare @AdvBillAmount money
Declare @AdvBillTaxAmount money
Declare @AdvBillNoTaxAmount money
Declare @AdvBillAccountKey int
Declare @InvoiceNumber varchar(100)
Declare @LineSubject varchar(100)
Declare @CheckType smallint
Declare @ApplAmount money
Declare @ApplAccountKey int
Declare @CheckNo varchar(100)
Declare @PostUsingDetail as tinyint
Declare @CurAcctKey int
Declare @CurClassKey int
Declare @Posted tinyint
Declare @TrackOverUnder tinyint
Declare @LaborOU int
Declare @ExpenseOU int
Declare @POAccruedExpenseAccountKey int
Declare @POPrebillAccrualAccountKey int
Declare @SalesTax2Key int
Declare @SalesTax2AccountKey int
Declare @SalesTax2Amount money

Select
	 @RequireAccounts = ISNULL(RequireGLAccounts, 0)
	,@PostToGL = ISNULL(PostToGL, 0)
	,@GLClosedDate = GLClosedDate
	,@TrackOverUnder = TrackOverUnder
	,@LaborOU = LaborOverUnderAccountKey
	,@ExpenseOU = ExpenseOverUnderAccountKey
	,@POAccruedExpenseAccountKey = POAccruedExpenseAccountKey
	,@POPrebillAccrualAccountKey = POPrebillAccrualAccountKey
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey


Select 
	 @InvoiceStatus = InvoiceStatus
	,@TransactionDate = PostingDate
	,@EntityKey = InvoiceKey
	,@GLAccountKey = ARAccountKey
	,@Amount = BilledAmount
	,@AdvBillAmount = ISNULL(RetainerAmount, 0)
	,@SalesTaxKey = SalesTaxKey
	,@SalesTaxAmount = ISNULL(SalesTax1Amount, 0)
	,@SalesTax2Key = SalesTax2Key
	,@SalesTax2Amount = ISNULL(SalesTax2Amount, 0)
	,@ClassKey = ClassKey
	,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
	,@ProjectKey = NULL
	,@ClientKey = ClientKey
	,@Posted = Posted
From vInvoice (nolock)
Where InvoiceKey = @InvoiceKey
	
Select @AdvBillTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBillTax (NOLOCK)
Where  InvoiceKey = @InvoiceKey
Select @AdvBillTaxAmount = ISNULL(@AdvBillTaxAmount, 0)
	  ,@AdvBillNoTaxAmount = @AdvBillAmount - ISNULL(@AdvBillTaxAmount, 0)

	if exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @InvoiceKey and ISNULL(PostSalesUsingDetail, 0) = 1)
		-- create a temp table to hold the GL Keys and amounts
		create table #tLineDetail
			(
			InvoiceLineKey int null
			,GLAccountKey int null
			,ClassKey int null
			,Type char(1) null
			,Amount money null 
			,Standard money null           
			)



	-- Post the header
	Select @Memo = 'Invoice #' + @InvoiceNumber
	if @Amount <> 0
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @GLAccountKey, @Amount, @ClassKey, @Memo, @ProjectKey, @ClientKey

	-- if there is a sales tax amount, post it
	if @SalesTaxAmount <> 0
	BEGIN
		Select @SalesTaxAccountKey = ISNULL(PayableGLAccountKey, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey
		Select @Memo = 'Sales Tax for Invoice #' + @InvoiceNumber
		exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @SalesTaxAccountKey, @SalesTaxAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
	END

	-- if there is a sales tax 2 amount, post it
	if @SalesTax2Amount <> 0
	BEGIN
		Select @SalesTax2AccountKey = ISNULL(PayableGLAccountKey, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
		Select @Memo = 'Sales Tax 2 for Invoice #' + @InvoiceNumber
		exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @SalesTax2AccountKey, @SalesTax2Amount, @ClassKey, @Memo, @ProjectKey, @ClientKey
	END

	-- If there are some other taxes, post them
	Declare @CurrSalesTaxKey Int
			,@CurrSalesTaxAccountKey Int
			,@CurrSalesTaxName Varchar(100)
			,@CurrSalesTaxAmount Money
			
	Select @CurrSalesTaxKey = -1
	While (1=1)
	Begin
		Select @CurrSalesTaxKey = Min(b.SalesTaxKey)
		From (Select Distinct SalesTaxKey 
				From tInvoiceLineTax ilt (nolock)
				Inner join tInvoiceLine il (nolock) On ilt.InvoiceLineKey = il.InvoiceLineKey
				Where il.InvoiceKey = @InvoiceKey
			 ) As b
		Where b.SalesTaxKey > @CurrSalesTaxKey 
		
		If @CurrSalesTaxKey Is Null
			Break
	
		Select @CurrSalesTaxAccountKey = ISNULL(PayableGLAccountKey, 0) 
			  ,@CurrSalesTaxName = SalesTaxName		
		from tSalesTax (nolock)
			inner join tGLAccount (nolock) on tSalesTax.PayableGLAccountKey = tGLAccount.GLAccountKey
		Where SalesTaxKey = @CurrSalesTaxKey
		
		Select @CurrSalesTaxAmount = Sum(ilt.SalesTaxAmount)
		From   tInvoiceLineTax ilt (nolock)
			Inner Join tInvoiceLine il (nolock) On ilt.InvoiceLineKey = il.InvoiceLineKey
		Where  il.InvoiceKey = @InvoiceKey
		And    ilt.SalesTaxKey = @CurrSalesTaxKey
		
		Select @Memo = @CurrSalesTaxName + ' Sales Tax for Invoice #' + @InvoiceNumber

		If @CurrSalesTaxAmount <> 0
			exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @CurrSalesTaxAccountKey, @CurrSalesTaxAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
	End

	/*
	** Process reversal of the Advance Bill if required
	*/

	-- Debit Deferred Revenue
	if @AdvBillNoTaxAmount <> 0
	BEGIN
		Select @AdvBillAccountKey = ISNULL(AdvBillAccountKey, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
		Select @Memo = 'Advance Billing for Invoice #' + @InvoiceNumber + ' Debit Deferred Revenue'
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @AdvBillAccountKey, @AdvBillNoTaxAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
	END

	-- Debit Advance Bill Sales Taxes
	SELECT @CurrSalesTaxKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrSalesTaxKey = MIN(SalesTaxKey)
		FROM   tInvoiceAdvanceBillTax (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    SalesTaxKey > @CurrSalesTaxKey 
		
		IF @CurrSalesTaxKey IS NULL
			BREAK
			
		-- Must take sum because we could have several adv billings
		SELECT @AdvBillTaxAmount = SUM(Amount)  
		FROM   tInvoiceAdvanceBillTax (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    SalesTaxKey = @CurrSalesTaxKey 
		SELECT @AdvBillTaxAmount = ISNULL(@AdvBillTaxAmount, 0)
		
		IF @AdvBillTaxAmount <> 0
		BEGIN
			Select @CurrSalesTaxAccountKey = ISNULL(PayableGLAccountKey, 0) 
				  ,@CurrSalesTaxName = SalesTaxName		
			from tSalesTax (nolock)
				inner join tGLAccount (nolock) on tSalesTax.PayableGLAccountKey = tGLAccount.GLAccountKey
			Where SalesTaxKey = @CurrSalesTaxKey
		
			-- no need to validate the GLAccount keys for the sales taxes
			-- because the sales taxes should be the same as on the invoice
			-- and they should have been validated above

			Select @Memo = 'Advance Billing for Invoice #' + @InvoiceNumber + ' Debit sales tax ' + @CurrSalesTaxName

			exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @CurrSalesTaxAccountKey, @AdvBillTaxAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
		END
		 	
	END

	-- Reverse the prepayments (only for those checks that have not been posted)
	Select @CurKey = -1
	While 1=1
	BEGIN
		Select @CurKey = Min(CheckApplKey) from tCheckAppl (nolock) inner join tCheck on tCheckAppl.CheckKey = tCheck.CheckKey
			Where InvoiceKey = @InvoiceKey and tCheckAppl.Prepay = 1 and CheckApplKey > @CurKey
		if @CurKey is null
			break

		Select @ApplAmount = tCheckAppl.Amount, @ApplAccountKey = ISNULL(tCheck.PrepayAccountKey, 0), @CheckNo = tCheck.ReferenceNumber
		from tCheckAppl (nolock) inner join tCheck on tCheckAppl.CheckKey = tCheck.CheckKey
		Where CheckApplKey = @CurKey
		
		Select @Memo = Left('Prepayment Reversal Check #' + @CheckNo, 500)

		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @ApplAccountKey, @ApplAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
		exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @GLAccountKey, @ApplAmount, @ClassKey, @Memo, @ProjectKey, @ClientKey
	END

	--Insert the Prebill accruals
	Declare @POAmount money
	Select @POAmount = Sum(TotalCost) from tPurchaseOrderDetail (nolock)
		inner join tInvoiceLine on tPurchaseOrderDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey
		Where InvoiceKey = @InvoiceKey
	
	if ISNULL(@POAmount, 0) <> 0
	BEGIN
		exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @POPrebillAccrualAccountKey, @POAmount, @ClassKey, 'Prebill Accrual', @ProjectKey, @ClientKey
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @POAccruedExpenseAccountKey, @POAmount, @ClassKey, 'Prebill Accrual', @ProjectKey, @ClientKey

	END	

	-- Post the detail lines
	Select @CurKey = -1
	While 1=1
	BEGIN
		Select @CurKey = Min(InvoiceLineKey) from tInvoiceLine (nolock) Where InvoiceKey = @InvoiceKey and InvoiceLineKey > @CurKey and LineType = 2
		if @CurKey is null
			break
			
		Select 
			 @GLAccountKey = SalesAccountKey
			,@Amount = TotalAmount
			,@ClassKey = ClassKey
			,@ProjectKey = ProjectKey
			,@LineSubject = LineSubject
			,@PostUsingDetail = ISNULL(PostSalesUsingDetail, 0)
		From tInvoiceLine (nolock)
		Where InvoiceLineKey = @CurKey
		
		Select @Memo = Left('Invoice #' + @InvoiceNumber + ' ' + rtrim(ltrim(@LineSubject)), 500)
		

		if @PostUsingDetail = 1 -- Use detail to determine sales account
		begin
			if ISNULL(@TrackOverUnder, 0) = 1
			-- Post detail using overunder tracking ***********************************************************
			BEGIN

			-- Need to determine amounts and gl accounts based on detail for the line
				-- Insert the labor
				if @LaborOU is null or @ExpenseOU is null
					return -21
				
				Delete #tLineDetail
				
				insert #tLineDetail(InvoiceLineKey, GLAccountKey, ClassKey, Type, Amount, Standard)
				Select @CurKey, ISNULL(SalesAccountKey, 0) , ISNULL(ClassKey, 0), 'L', Sum(Amount), Sum(Standard)
				from vSalesGLDetail
				Where InvoiceLineKey = @CurKey and Type = 'L'
				Group By ISNULL(SalesAccountKey, 0), ISNULL(ClassKey, 0)
				
				-- Insert the expenses
				insert #tLineDetail(InvoiceLineKey, GLAccountKey, ClassKey, Type, Amount, Standard)
				Select @CurKey, ISNULL(SalesAccountKey, 0) , ISNULL(ClassKey, 0), 'E', Sum(Amount), Sum(Standard)
				from vSalesGLDetail
				Where InvoiceLineKey = @CurKey and Type <> 'L'
				Group By ISNULL(SalesAccountKey, 0), ISNULL(ClassKey, 0)
				
				-- Labor Loop
				select @CurAcctKey = -1
				while 1=1
				begin
					Select @CurAcctKey = Min(GLAccountKey) from #tLineDetail 
					Where InvoiceLineKey = @CurKey 
						and GLAccountKey > @CurAcctKey
						and Type = 'L'
						
					if @CurAcctKey is null
						break
					
					Select @CurClassKey = -1
					While 1=1
					begin
						Select @CurClassKey = Min(ClassKey) from #tLineDetail 
						Where InvoiceLineKey = @CurKey 
							and GLAccountKey = @CurAcctKey 
							and Type = 'L'
							and ClassKey > @CurClassKey
						
						if @CurClassKey is null
							Break
							
						Select @Amount = ISNULL(Amount, 0), @Standard = ISNULL(Standard, 0) from #tLineDetail 
						Where GLAccountKey = @CurAcctKey 
							and ISNULL(ClassKey, 0) = ISNULL(@CurClassKey, 0) 
							and Type = 'L'
							and InvoiceLineKey = @CurKey
						
						if @Standard <> 0  -- Insert the standard to the normal sales account
							exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @CurAcctKey, @Standard, @CurClassKey, @Memo, @ProjectKey, @ClientKey
						if @Amount - @Standard <> 0
						BEGIN
							Select @Amount = @Amount - @Standard
							exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @LaborOU, @Amount, @CurClassKey, @Memo, @ProjectKey, @ClientKey
						END
					end
				end
				
				-- Expenses Loop
				select @CurAcctKey = -1
				while 1=1
				begin
					Select @CurAcctKey = Min(GLAccountKey) from #tLineDetail 
					Where InvoiceLineKey = @CurKey 
						and GLAccountKey > @CurAcctKey
						and Type = 'E'
						
					if @CurAcctKey is null
						break
					
					Select @CurClassKey = -1
					While 1=1
					begin
						Select @CurClassKey = Min(ClassKey) from #tLineDetail 
						Where InvoiceLineKey = @CurKey 
							and GLAccountKey = @CurAcctKey 
							and Type = 'E'
							and ClassKey > @CurClassKey
					
						if @CurClassKey is null
							Break
						
						Select @Amount = ISNULL(Amount, 0), @Standard = ISNULL(Standard, 0) from #tLineDetail 
						Where GLAccountKey = @CurAcctKey 
							and ISNULL(ClassKey, 0) = ISNULL(@CurClassKey, 0) 
							and Type = 'E'
							and InvoiceLineKey = @CurKey
						
						if @Standard <> 0  -- Insert the standard to the normal sales account
							exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @CurAcctKey, @Standard, @CurClassKey, @Memo, @ProjectKey, @ClientKey
						if @Amount - @Standard <> 0
						BEGIN
							Select @Amount = @Amount - @Standard
							exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @ExpenseOU, @Amount, @CurClassKey, @Memo, @ProjectKey, @ClientKey
						END
					end
				end
			END
			ELSE
			BEGIN
			-- Need to determine amounts and gl accounts based on detail for the line
				insert #tLineDetail(InvoiceLineKey, GLAccountKey, ClassKey, Amount)
				Select @CurKey, ISNULL(SalesAccountKey, 0) , ISNULL(ClassKey, 0), Sum(Amount)
				from vSalesGLDetail
				Where InvoiceLineKey = @CurKey
				Group By ISNULL(SalesAccountKey, 0), ISNULL(ClassKey, 0)

				select @CurAcctKey = -1
				while 1=1
				begin
					Select @CurAcctKey = Min(GLAccountKey) from #tLineDetail Where InvoiceLineKey = @CurKey and GLAccountKey > @CurAcctKey
					if @CurAcctKey is null
						break
					
					Select @CurClassKey = -1
					While 1=1
					begin
											
						Select @CurClassKey = Min(ClassKey) from #tLineDetail 
						Where InvoiceLineKey = @CurKey 
							and GLAccountKey = @CurAcctKey 
							and ClassKey > @CurClassKey
							
						if @CurClassKey is null
							Break	
						
						Select @Amount = ISNULL(Amount, 0) from #tLineDetail 
						Where GLAccountKey = @CurAcctKey 
							and ISNULL(ClassKey, 0) = ISNULL(@CurClassKey, 0) 
							and InvoiceLineKey = @CurKey
						
						if ISNULL(@Amount, 0) <> 0 
							exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @CurAcctKey, @Amount, @CurClassKey, @Memo, @ProjectKey, @ClientKey
					end
				end
			END
			
		end
		else
			exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'INVOICE', @EntityKey, @InvoiceNumber, @GLAccountKey, @Amount, @ClassKey, @Memo, @ProjectKey, @ClientKey

	END
	

return 1
GO
