USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGenerateRecurring]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGenerateRecurring]

	(
		@InvoiceKey int,
		@CompanyKey int,
		@RecurringInterval smallint,
		@RecurringCount int
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 02/23/07 GHL 8.4    Added project rollup  
  || 03/29/07 CRG 8.4.1  (8730) Fixed DueDate calculation for quarterly recurring. 
  || 10/6/07  GWG 8.5    Added hooks for company,office and department 
  || 03/31/09 RLB 10.022 (49960) Added sptInvoiceRecalcAmounts to invoice creation loop so that recurring invoices hit tInvoiceSummary
  || 03/31/09 RLB 10.022 (50067) Added PrimaryContactKey to newly created Invoices since it was not being passed in before       
  || 02/12/10 GHL 10.518 (74670) Added tax info...also removed call to sptInvoiceRecalcAmount and added call to sptInvoiceSummary                    
  || 02/19/10 GHL 10.518 Reviewed capture of @@ERROR and @@IDENTITY
  || 09/19/13 MFT 10.572 (190447) Added	LayoutKey in INSERT statement
  || 01/03/14 WDF 10.576 (188500) Added CreatedByKey, DateCreated to Insert tInvoice
 */
  	
if @RecurringCount = 0
	Return 1
	
If exists(Select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey and RecurringParentKey > 0)
	return -1

create table #newkeys (InvoiceKey int null)

Begin Transaction

Update tInvoice Set RecurringParentKey = @InvoiceKey Where InvoiceKey = @InvoiceKey
if @@ERROR <> 0 
begin
	rollback tran
	return -3
end

Declare @Loop int, @CurOrder int, @RetVal INTEGER, @NextTranNo VARCHAR(100), @NewKey int, @Error int
Declare @CurInvoiceDate smalldatetime, @CurDueDate smalldatetime, @InvoiceDate smalldatetime, @DueDate smalldatetime
Select @CurInvoiceDate = InvoiceDate, @CurDueDate = DueDate from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

Select @Loop = 0

While @Loop < @RecurringCount
BEGIN

	Select @Loop = @Loop + 1
	
 -- Get the next number
	EXEC spGetNextTranNo
		@CompanyKey,
		'AR', -- TranType
		@RetVal OUTPUT,
		@NextTranNo OUTPUT

	IF @RetVal <> 1
		begin
			rollback tran
			return -3					   	
		end
		

	IF @RecurringInterval = 1
		SELECT @InvoiceDate = DATEADD(month, @Loop, @CurInvoiceDate), @DueDate = DATEADD(month, @Loop, @CurDueDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	IF @RecurringInterval = 2
		SELECT @InvoiceDate = DATEADD(month, 3 * @Loop, @CurInvoiceDate), @DueDate = DATEADD(month, 3 * @Loop, @CurDueDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	IF @RecurringInterval = 3
		SELECT @InvoiceDate = DATEADD(year, @Loop, @CurInvoiceDate), @DueDate = DATEADD(year, @Loop, @CurDueDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end

	INSERT tInvoice
	(
		CompanyKey,
		ClientKey,
		ContactName,
		BillingContactKey,
		AdvanceBill,
		InvoiceNumber,
		InvoiceDate,
		PostingDate,
		DueDate,
		RecurringParentKey,
		TermsKey,
		ARAccountKey,
		GLCompanyKey,
		OfficeKey,
		ClassKey,
		ProjectKey,
		RetainerAmount,
		WriteoffAmount,
		DiscountAmount,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		TotalNonTaxAmount,
		InvoiceTotalAmount,
		AmountReceived,
		HeaderComment,
		SalesTaxKey,
		SalesTax2Key,
		InvoiceStatus,
		ApprovedDate,
		ApprovedByKey,
		ApprovalComments,
		Posted,
		Downloaded,
		InvoiceTemplateKey,
		LayoutKey,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		PrimaryContactKey,
		CreatedByKey,
		DateCreated
	)
	Select
		CompanyKey,
		ClientKey,
		ContactName,
		BillingContactKey,
		AdvanceBill,
		RTRIM(@NextTranNo),
		@InvoiceDate,
		@InvoiceDate,
		@DueDate,
		RecurringParentKey,
		TermsKey,
		ARAccountKey,
		GLCompanyKey,
		OfficeKey,
		ClassKey,
		ProjectKey,
		0,
		0,
		DiscountAmount,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		TotalNonTaxAmount,
		InvoiceTotalAmount,
		0,
		HeaderComment,
		SalesTaxKey,
		SalesTax2Key,
		InvoiceStatus,
		ApprovedDate,
		ApprovedByKey,
		ApprovalComments,
		0,
		0,
		InvoiceTemplateKey,
		LayoutKey,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		PrimaryContactKey,
		CreatedByKey,
		DateCreated
	From tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
	select @Error = @@ERROR, @NewKey = @@Identity
	
	if @Error <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	Insert #newkeys (InvoiceKey) values (@NewKey)
		
	exec sptInvoiceGenerateRecurringLines @InvoiceKey, @NewKey, 0 , 0
	
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end

	-- removed since the sales taxes are now copied from the original invoice 
	-- also some temp tables are created within a SQL tran which is not recommended	
    --EXEC sptInvoiceRecalcAmounts @NewKey

END	

Commit Transaction

select @NewKey = -1
while (1=1)
begin
	select @NewKey = min(InvoiceKey)
	from   #newkeys
	where  InvoiceKey > @NewKey
	
	if @NewKey is null
		break
		
	exec sptInvoiceSummary @NewKey	 
	
end

-- Rollup does not have to be in transaction
-- Rollup for entity @InvoiceKey since same projects have been copied from that invoice to the other ones
EXEC sptProjectRollupUpdateEntity 'tInvoice', @InvoiceKey
GO
