USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceWriteOff]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceWriteOff]

	(
		@InvoiceKey int,
		@DoWriteOff tinyint = 1
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 01/10/10 GWG 10.5.1.7 (64805) Modified the opening transaction flag so that the write off is not tagged as an opening transaction
|| 03/24/10 GHL 10.5.2.1 (77535) 2 issues in 1:
||                        1) when creating the credit memo for the write off, do not insert with a project
||                        because the logic for project split billing will kick in. Just update the project afterwards
||                        2) for child invoices, we must get the invoice lines from the parent, not the child
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 09/07/11 GWG 10.548 Added changes to just close the invoice and not do the credit part. Gets sales account and does not call the create credit part.
|| 10/12/11 GHL 10.548 (123530) Added querying of defaults on lines for Office/Class/Department
||                     This was a problem when the original lines are TM and say PostSalesUsingDetail = 1
||                     and Office is missing and Pref say Office is required. The new lines are FF and Office is missing
|| 10/01/13 GHL 10.573 Added multi currency logic
|| 01/03/14 WDF 10.576 (188500) Added CreatedByKey
|| 04/14/14 GHL 10.579 (212782) Using now: Select @Percent = cast(@WriteOffAmount as float) / cast(@InvoiceTotal as float)
||                      instead of Select @Percent = @WriteOffAmount / @InvoiceTotal  because 1.58/32837.5 was calculated as 0
*/

Declare @WriteoffAccountKey int
Declare @CompanyKey int
Declare @ARAccountKey int
Declare @WriteOffAmount money
Declare @BillingContact varchar(100)
Declare @PrimaryContactKey int
Declare @AddressKey int
Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @GLClosedDate smalldatetime
Declare @Memo varchar(500), @TotalNonTaxAmount money
Declare @ClientKey int, @ProjectKey int
Declare @TransactionDate smalldatetime
Declare @InvoiceNumber varchar(100)
Declare @RetVal int, @SalesTaxKey int, @SalesTax2Key int, @InvoiceTemplateKey int, @TermsKey int, @ClassKey int, @ApprovedByKey int
Declare @NewInvoiceKey int, @InvoiceTotal money, @Percent float, @NonTaxPercent float
Declare @GLCompanyKey int, @OfficeKey int, @OpeningTransaction tinyint, @LayoutKey int
Declare @CurrencyID varchar(10), @ExchangeRate decimal(24,7), @CreatedByKey int
Declare @ParentInvoiceKey int
Declare @PercentageSplit decimal(24,4) 
Declare @LineInvoiceKey int -- invoice where the lines are
Declare @ParentPercent decimal (20,8) -- like in spGLPostInvoice
Select @TransactionDate = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as datetime)

	
Select
	 @WriteoffAccountKey = CASE WHEN @DoWriteOff = 1 THEN ISNULL(p.WriteOffAccountKey, 0) ELSE ISNULL(p.DefaultSalesAccountKey, 0) END
	,@CompanyKey = i.CompanyKey
	,@ARAccountKey = ISNULL(i.ARAccountKey, 0)
	,@InvoiceNumber = ltrim(rtrim(i.InvoiceNumber))
	,@ClientKey = i.ClientKey
	,@ProjectKey = i.ProjectKey
	,@BillingContact = BillingContact
	,@PrimaryContactKey = i.PrimaryContactKey
	,@AddressKey = i.AddressKey
	,@SalesTaxKey = SalesTaxKey
	,@SalesTax2Key = SalesTax2Key
	,@InvoiceTemplateKey = InvoiceTemplateKey
	,@TermsKey = TermsKey
	,@ClassKey = ClassKey
	,@ApprovedByKey = ApprovedByKey
	,@InvoiceTotal = ISNULL(i.InvoiceTotalAmount, 0)
	,@WriteOffAmount = Case When @DoWriteOff = 1 then ISNULL(i.BilledAmount, 0) - ISNULL(i.PaymentAmount, 0) else ISNULL(i.BilledAmount, 0) - ISNULL(i.AdvanceApplied, 0) END
	,@TotalNonTaxAmount = ISNULL(i.TotalNonTaxAmount, 0)
	,@GLCompanyKey = GLCompanyKey
	,@OfficeKey = OfficeKey
	,@OpeningTransaction = 0
	,@ParentInvoiceKey = isnull(ParentInvoiceKey, 0)
	,@PercentageSplit = isnull(PercentageSplit, 100)
	,@LayoutKey = i.LayoutKey
	,@CurrencyID = i.CurrencyID
	,@ExchangeRate = i.ExchangeRate 
	,@CreatedByKey = i.CreatedByKey
from
	vInvoice i (nolock)
	inner join tPreference p (nolock) on i.CompanyKey = p.CompanyKey
Where
	i.InvoiceKey = @InvoiceKey
	
	
IF @WriteoffAccountKey = 0
	return -1
	
if @ARAccountKey = 0
	return -2
		
If @WriteOffAmount = 0
	return -3
	
If @InvoiceTotal <= 0
	return -4

-- percent due to write off	
Select @Percent = cast(@WriteOffAmount as float) / cast(@InvoiceTotal as float)

-- percent due to split billing
if @ParentInvoiceKey > 0
	select @LineInvoiceKey = @ParentInvoiceKey 
	      ,@ParentPercent = @PercentageSplit / 100.0
else
	select @LineInvoiceKey = @InvoiceKey 
	      ,@ParentPercent = 1

exec @RetVal = sptInvoiceInsert
					@CompanyKey
					,@ClientKey
					,@BillingContact
					,@PrimaryContactKey 
					,@AddressKey
					,0
					,null               					--InvoiceNbumber
					,@TransactionDate        				--InvoiceDate
					,@TransactionDate				        --Due Date
					,@TransactionDate				        --Posting Date
					,@TermsKey			   					--TermsKey
					,@ARAccountKey							--Default AR Account
					,@ClassKey								--ClassKey
					,null--@ProjectKey						-- no project so that the split billing will not work
					,null  									--HeaderComment
					,@SalesTaxKey					 		--SalesTaxKey 
					,@SalesTax2Key					 		--SalesTax2Key 
					,@InvoiceTemplateKey					--Invoice Template Key
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
					,0										--Emailed
					,@CreatedByKey
					,@GLCompanyKey
					,@OfficeKey
					,@OpeningTransaction
					,@LayoutKey
					,@CurrencyID
					,@ExchangeRate
					,0 -- do not request another rate
					,@NewInvoiceKey output


if @RetVal <> 1
	return  -5
	
-- now update the project
update tInvoice set ProjectKey = @ProjectKey where InvoiceKey = @NewInvoiceKey
	
Declare @HeaderClassKey int
Declare @ProjectClassKey int
Declare @LineClassKey int

Declare @HeaderOfficeKey int
Declare @ProjectOfficeKey int
Declare @LineOfficeKey int

Declare @ItemDepartmentKey int
Declare @LineDepartmentKey int

Declare @Entity varchar(20)
Declare @EntityKey int

-- we already pulled class and office from the header
select @HeaderClassKey = @ClassKey
select @HeaderOfficeKey = @OfficeKey

Declare @CurLine int, @LastLine int, @Amt money, @UnitAmt money
Select @CurLine = -1
While 1=1
BEGIN

	Select @CurLine = MIN(InvoiceLineKey) From tInvoiceLine (nolock) Where InvoiceKey = @LineInvoiceKey and LineType = 2 and InvoiceLineKey > @CurLine
	if @CurLine is null
		Break
		
	Select @Amt = il.TotalAmount
	       ,@LineClassKey = il.ClassKey
		   ,@LineOfficeKey = il.OfficeKey
		   ,@LineDepartmentKey = il.DepartmentKey
		   ,@ProjectClassKey = p.ClassKey
		   ,@ProjectOfficeKey = p.OfficeKey 
	from tInvoiceLine il (nolock) 
	left outer join tProject p (nolock) on il.ProjectKey = p.ProjectKey	
	Where il.InvoiceLineKey = @CurLine

	-- line first, then default from project then default from header
	if isnull(@LineOfficeKey, 0) = 0 
	begin
		if isnull(@ProjectOfficeKey, 0) > 0
			select @LineOfficeKey = @ProjectOfficeKey
		else
			select @LineOfficeKey = @HeaderOfficeKey 
	end

	-- line first, then default from project then default from header
	if isnull(@LineClassKey, 0) = 0 
	begin
		if isnull(@ProjectClassKey, 0) > 0
			select @LineClassKey = @ProjectClassKey
		else
			select @LineClassKey = @HeaderClassKey 
	end

	-- line first, then default from item
	if isnull(@LineDepartmentKey, 0) = 0 
	begin
		if @Entity = 'tService' and isnull(@EntityKey, 0) >0
			select @ItemDepartmentKey = DepartmentKey from tService (nolock) where ServiceKey = @EntityKey  

		if @Entity = 'tItem' and isnull(@EntityKey, 0) >0
			select @ItemDepartmentKey = DepartmentKey from tItem (nolock) where ItemKey = @EntityKey  
 
		if isnull(@ItemDepartmentKey, 0) > 0
			select @LineDepartmentKey = @ItemDepartmentKey
	end

	-- Apply first the percentage due to split billing
	select @Amt = @Amt * @ParentPercent       
	
	-- then Apply the percentage due to the write off
	if @DoWriteOff = 1
		select @Amt = Round(@Amt * -1 * @Percent, 2)
	else
		-- not a negative amount if just closing the advance
		select @Amt = Round(@Amt * @Percent, 2)

	INSERT tInvoiceLine
	(
		InvoiceKey,
		ProjectKey,
		TaskKey,
		LineSubject,
		LineDescription,
		BillFrom,
		Quantity,
		UnitAmount,
		TotalAmount,
		DisplayOrder,
		LineType,
		ParentLineKey,
		SalesAccountKey,
		ClassKey,
		Taxable,
		Taxable2,
		WorkTypeKey,
		PostSalesUsingDetail,
		Entity,
		EntityKey,
		OfficeKey,
		DepartmentKey
	)
	Select
		@NewInvoiceKey,
		ProjectKey,
		TaskKey,
		LineSubject,
		LineDescription,
		1, -- Fixed fee....all lines even if T&M are converted to FF
		0,
		0,
		@Amt,
		DisplayOrder,
		2,
		0,
		@WriteoffAccountKey,
		@LineClassKey,
		Taxable,
		Taxable2,
		WorkTypeKey,
		0,
		Entity,
		EntityKey,
		@LineOfficeKey,
		@LineDepartmentKey		
		From tInvoiceLine (nolock) Where InvoiceLineKey = @CurLine
 
	Select @LastLine = @@IDENTITY

	Insert tInvoiceLineTax
	(
		InvoiceLineKey,
		SalesTaxKey,
		SalesTaxAmount
	)
	Select
		@LastLine,
		SalesTaxKey,
		0
	From tInvoiceLineTax (nolock)
	Where InvoiceLineKey = @CurLine
	
	
 
END

Declare @WOTot money, @Diff money, @LastLineAmt money, @Quant decimal(24,4)

 
exec sptInvoiceRecalcAmounts @NewInvoiceKey 
exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0

Declare @DiffWO money
Declare @IncrWO money

Select @WOTot = InvoiceTotalAmount from tInvoice (NOLOCK) Where InvoiceKey = @NewInvoiceKey
if ABS(@WOTot) > ABS(@WriteOffAmount)
BEGIN	
	While 1=1
	BEGIN
		Select @DiffWO =  ABS(@WOTot) - ABS(@WriteOffAmount)

		If @DiffWO > 10
			Select @IncrWO = ROUND(@DiffWO / 10.0, 2)
		Else
			Select @IncrWO = .01
					
		Update tInvoiceLine Set TotalAmount = TotalAmount + @IncrWO Where InvoiceKey = @NewInvoiceKey
		exec sptInvoiceRecalcAmounts @NewInvoiceKey
		Select @WOTot = InvoiceTotalAmount from tInvoice (NOLOCK) Where InvoiceKey = @NewInvoiceKey
		if ABS(@WOTot) <= ABS(@WriteOffAmount)
			Break

	END
END

if ABS(@WOTot) <> ABS(@WriteOffAmount)
BEGIN
	Declare @LineCount as int, @AdjAmt money
	Select @LineCount = Max(DisplayOrder) + 1 from tInvoiceLine (nolock) Where InvoiceKey = @NewInvoiceKey
	if @DoWriteOff = 1
		Select @AdjAmt = (ABS(@WriteOffAmount) - ABS(@WOTot)) * -1
	else
		-- not a negative amount if just closing the advance
		Select @AdjAmt = (ABS(@WriteOffAmount) - ABS(@WOTot))
	
	
	INSERT tInvoiceLine
	(
		InvoiceKey,	LineSubject, BillFrom, Quantity, UnitAmount, TotalAmount, DisplayOrder, LineType, ParentLineKey, SalesAccountKey, ClassKey, Taxable, Taxable2, WorkTypeKey, PostSalesUsingDetail, Entity, EntityKey
	)
	Values
	(
		@NewInvoiceKey, 'Adjusting Line', 1, 0, 0, @AdjAmt, @LineCount, 2, 0, @WriteoffAccountKey, NULL, 0, 0, NULL, 0, NULL, NULL
	)
	exec sptInvoiceRecalcAmounts @NewInvoiceKey
END

if @DoWriteOff = 1
	exec sptInvoiceCreditInsert @InvoiceKey, @NewInvoiceKey, NULL, @WriteOffAmount
else
	exec sptInvoiceAdvanceBillInsert @NewInvoiceKey, @InvoiceKey, @WriteOffAmount

return @NewInvoiceKey
GO
