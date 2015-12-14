USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingChangeStatus]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingChangeStatus]
(
	@BillingKey int,
    @UserKey int,
	@Status smallint,
	@ApprovalComments varchar(300) = null
)

as --Encrypt

  /*
  || When     Who Rel   What
  || 09/12/06 GHL 8.35  Removed restriction on existence of tBillingFixedFee records for fixed fee  
  ||                    So that the fixed fee billing worksheet can be approved and invoiced with transactions only 
  ||                    (Bug 6485 Architectural Dimensions LLC)
  || 04/28/08 GHL 8.509 Added comments parameter because we can enter now comments directly on the flash approval screen 
  || 06/06/08 GHL 8.512 (27863) Added validation of transfers	
  || 07/29/09 GHL 10.505 (57778) Do not prevent the users from creating an invoice with 0 amount
  || 08/26/09 GHL 10.508 (60195) Modified the logic when we set the invoiced status
  ||                     we must take in account the # of details with action = bill regardless of amount (resend)
  || 10/28/09 GHL 10.513 (64875) When unapproving master worksheets, change the master worksheet 
  ||                     to 1 (In Review) instead of 2 (Send to Approval). 
  ||                     This was expecially wrong if the current status of the master is 1. 
  || 04/16/10 GHL 10.521 When we approve a master billing worksheet, approve the child worksheets
  || 09/26/13 WDF 10.573 (188654) Added UserKey
  ||                      
  */
  
Declare @CurStatus smallint, @ParentWorksheetKey int, @ParentWorksheet smallint, @AdvBillAmt money, @ToInvoice int
Declare @FF money, @Labor money, @Expense money, @RetainerAmount money
Declare @SalesTaxKey int, @SalesTax2Key int, @TermsKey int, @DefaultSalesAccountKey int, @ClassKey int, @CompanyKey int, @RequireClasses int
Declare @BillingMethod smallint
Declare @RetVal int
Declare @BillCount int
Declare @ChildBillingKey int
Declare @ChildApprovalError int

Select 
	@CurStatus = Status, 
	@ParentWorksheetKey = ISNULL(ParentWorksheetKey, 0), 
	@ParentWorksheet = ParentWorksheet,
	@SalesTaxKey = SalesTaxKey, 
	@SalesTax2Key = @SalesTax2Key, 
	@DefaultSalesAccountKey = DefaultSalesAccountKey, 
	@ClassKey = ClassKey,
	@CompanyKey = CompanyKey,
	@BillingMethod = BillingMethod
from tBilling (nolock) Where BillingKey = @BillingKey

-- check if we have anything to change
if @CurStatus = @Status
	return 1

Select @RequireClasses = ISNULL(RequireClasses, 0)
From tPreference (nolock)
Where CompanyKey = @CompanyKey 

if @CurStatus = 4 and @Status < 4
	Update tBilling Set Status = 1, ApprovalComments = @ApprovalComments Where BillingKey = @ParentWorksheetKey

Select @ToInvoice = 0

if @Status = 4
BEGIN

	Select @AdvBillAmt = Sum(Amount) from tBillingPayment (NOLOCK) Where BillingKey = @BillingKey
	

	if @ParentWorksheet = 1
		Select @FF = Sum(FFTotal), @Labor = Sum(LaborTotal), @Expense = Sum(ExpenseTotal) 
		From tBilling (nolock) Where ParentWorksheetKey = @BillingKey
	else
		Select @FF = FFTotal, @Labor = LaborTotal, @Expense = ExpenseTotal
		From tBilling (nolock) Where BillingKey = @BillingKey


	-- Do not perform this check if no @AdvBillAmt (problem when @FF + @Labor + @Expense < 0)
	if @AdvBillAmt is not null
		if ISNULL(@AdvBillAmt, 0) > ISNULL(@FF, 0) + ISNULL(@Labor, 0) + ISNULL(@Expense, 0)
			return -1
		
	if @SalesTaxKey > 0
		if not exists(Select 1 from tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey)
			return -2
	if @SalesTax2Key > 0
		if not exists(Select 1 from tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key)
			return -3
	if @DefaultSalesAccountKey > 0
		if not exists(Select 1 from tGLAccount (nolock) Where GLAccountKey = @DefaultSalesAccountKey)
			return -4
	if @ClassKey > 0
		if not exists(Select 1 from tClass (nolock) Where ClassKey = @ClassKey)
			return -5
	if (ISNULL(@ClassKey, 0) = 0) And (@RequireClasses = 1) And (@ParentWorksheetKey = 0)
		return -6

	exec @RetVal = sptBillingValidateTransfers @BillingKey
	if @RetVal <> 1
		return -8 
			
	if @ParentWorksheet = 1
	BEGIN 
		/*
		-- Children must all be approved or invoiced
		if exists (select 1 From tBilling (nolock) 
					Where CompanyKey = @CompanyKey
					And   ParentWorksheetKey = @BillingKey
					And   Status < 4)   
		return -7  
		*/
		
		-- Approve children if there are not approved
		select @ChildApprovalError = 0
		if exists (select 1 From tBilling (nolock) 
					Where CompanyKey = @CompanyKey
					And   ParentWorksheetKey = @BillingKey
					And   Status < 4)
		begin
			select @ChildBillingKey = -1
			while (1=1)
			begin	
				select @ChildBillingKey = min(BillingKey)
				from   tBilling (nolock)
				Where CompanyKey = @CompanyKey
				And   ParentWorksheetKey = @BillingKey
				And   Status < 4
				And   BillingKey > @ChildBillingKey
				
				if @ChildBillingKey is null
					break
					
				exec @RetVal = sptBillingChangeStatus @ChildBillingKey, @UserKey, 4, null
				if @RetVal < 0
					select @ChildApprovalError = 1 	
			end
		end       
		if @ChildApprovalError = 1
			return -7
			
		-- If Children are all invoiced
		if not exists (select 1 From tBilling (nolock) 
					Where CompanyKey = @CompanyKey
					And   ParentWorksheetKey = @BillingKey
					And   Status <> 5)
			-- Then the master should be invoiced		   
			select @ToInvoice = 1  
	END
	ELSE
	BEGIN
		select @RetainerAmount = ISNULL(RetainerAmount, 0)
		From tBilling (NOLOCK)
		Where BillingKey = @BillingKey
		
		select @BillCount = count(*)
		from   tBillingDetail (nolock)
		Where  BillingKey = @BillingKey
		and    Action = 1 -- to bill
		-- regardless of Amount = 0
		
		-- only do this if there was nothing to bill
		If @BillCount = 0 
			If (@RetainerAmount + @FF + @Labor + @Expense) = 0
				-- Then the ws should be invoiced 
				select @ToInvoice = 1
		
	END
END

if @CurStatus = 5
	if exists(Select 1 from tBilling (nolock) Where BillingKey = @BillingKey and InvoiceKey is not null)
		return -10

	

If @ToInvoice = 1
	Update tBilling Set Status = 5, ApprovalComments = @ApprovalComments  Where BillingKey = @BillingKey
Else
	Update tBilling Set Status = @Status, ApprovalComments = @ApprovalComments  Where BillingKey = @BillingKey

--Upon approval, perform actions which do not require invoices
If @Status = 4 
	exec spBillingProcessNoInvoice @BillingKey, @UserKey


RETURN 1
GO
