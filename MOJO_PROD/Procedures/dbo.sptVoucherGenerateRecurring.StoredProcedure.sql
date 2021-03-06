USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGenerateRecurring]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGenerateRecurring]

	(
		@VoucherKey int,
		@CompanyKey int,
		@RecurringInterval smallint,
		@RecurringCount int
	)

AS --Encrypt
	
  /*
  || When     Who Rel     What
  || 12/19/06 GHL 8.4     Added check of maximum value for InvoiceNumber
  || 02/20/07 GHL 8.4     Added project rollup section
  || 04/30/07 BSH 8.4.2.1 Corrected Due date calculation on quarterly recurrence.
  || 10/09/07 BSH 8.5     Added GLCompanyKey and OfficeKey to the generate.
  || 08/27/09 RLB 10.5.0.8 Fixed application error if InvoiceName had decimal in it  
  || 02/12/10 GHL 10.518  (74670) Added tax info       
  || 01/21/13 GHL 10.564  (165194) Starting now at @CurCount = 2 for Invoice Numbers which are strings     
  || 02/07/13 GHL 10.565  (167854) Added VoucherID for a customization for Spark44  
  */
  	
if @RecurringCount = 0
	Return 1
	
if exists(select 1 from tVoucherDetail (NOLOCK) WHERE VoucherKey = @VoucherKey and ISNULL(PurchaseOrderDetailKey, 0) > 0)
	return -1
	
If exists(Select 1 from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey and RecurringParentKey > 0)
	return -1

Begin Transaction

Update tVoucher Set RecurringParentKey = @VoucherKey Where VoucherKey = @VoucherKey
if @@ERROR <> 0 
begin
	rollback tran
	return -3					   	
end

Declare @Loop int, @CurCount int, @VendorKey int, @RetVal INTEGER, @CreditCard int
Declare @NextTranNo VARCHAR(100), @InvoiceNumber varchar(100), @NewKey int, @NewDetailKey int
Declare @CurInvoiceDate smalldatetime, @CurDueDate smalldatetime, @InvoiceDate smalldatetime, @DueDate smalldatetime

Select @CurInvoiceDate = InvoiceDate, @CurDueDate = DueDate
, @VendorKey = VendorKey, @InvoiceNumber = RTRIM(LTRIM(InvoiceNumber)) 
, @CreditCard = isnull(CreditCard, 0)
from tVoucher Where VoucherKey = @VoucherKey

Select @Loop = 0

Declare @AddToInvoiceNumber int
if ISNUMERIC(@InvoiceNumber) = 1 AND CHARINDEX('.',@InvoiceNumber) = 0
	if Cast(@InvoiceNumber as float) < 2147483647 -- Check with a float to prevent overflow
		select @AddToInvoiceNumber =1
	else
		select @AddToInvoiceNumber = 0
else
	select @AddToInvoiceNumber = 0

if @AddToInvoiceNumber = 1
	select @CurCount =1 -- If we increment a number, start at 1
else
	select @CurCount =2 -- users want to see 'Monthly Bill 2013-2' as first recurrence

While @Loop < @RecurringCount
BEGIN

	Select @Loop = @Loop + 1
	
 -- Get the next number
	While 1=1
	BEGIN
		if ISNUMERIC(@InvoiceNumber) = 1 AND CHARINDEX('.',@InvoiceNumber) = 0 
			if Cast(@InvoiceNumber as float) < 2147483647 -- Check with a float to prevent overflow
				-- But use an int
				Select @NextTranNo = Cast(Cast(@InvoiceNumber as integer) + @CurCount as Varchar)
			else
				Select @NextTranNo = @InvoiceNumber + '-' + CAST(@CurCount as Varchar)
			
		else
			Select @NextTranNo = @InvoiceNumber + '-' + CAST(@CurCount as Varchar)
	
		if exists(Select 1 from tVoucher (NOLOCK) Where VendorKey = @VendorKey and RTRIM(LTRIM(InvoiceNumber)) = @NextTranNo)
			Select @CurCount = @CurCount + 1
		else
			begin
			Select @CurCount = @CurCount + 1
			Break
			end
	END
	
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

	Declare @VoucherID int
	if @CreditCard = 0
		Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 from tVoucher (nolock) 
		Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0

	INSERT tVoucher
		(
		CompanyKey,
		VendorKey,
		InvoiceDate,
		PostingDate,
		InvoiceNumber,
		RecurringParentKey,
		DateReceived,
		DateCreated,
		APAccountKey,
		ClassKey,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		DueDate,
		Description,
		VoucherTotal,
		AmountPaid,
		ApprovedDate,
		ApprovedByKey,
		Status,
		ApprovalComments,
		Posted,
		Downloaded,
		ProjectKey,
		GLCompanyKey,
		OfficeKey,
		SalesTaxKey,
		SalesTax2Key,
		SalesTax1Amount,
		SalesTax2Amount,
		SalesTaxAmount,
		VoucherID
		)
	Select
		CompanyKey,
		VendorKey,
		@InvoiceDate,
		@InvoiceDate,
		@NextTranNo,
		RecurringParentKey,
		DateReceived,
		DateCreated,
		APAccountKey,
		ClassKey,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		@DueDate,
		Description,
		VoucherTotal,
		0,
		ApprovedDate,
		ApprovedByKey,
		Status,
		ApprovalComments,
		0,
		0,
		ProjectKey,
		GLCompanyKey,
		OfficeKey,
		SalesTaxKey,
		SalesTax2Key,
		SalesTax1Amount,
		SalesTax2Amount,
		SalesTaxAmount,
		@VoucherID

	From tVoucher Where VoucherKey = @VoucherKey
	
	Select @NewKey = @@Identity

	INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @NewKey, SalesTaxKey, SalesTaxAmount, Type
	FROM   tVoucherTax  (NOLOCK)
	WHERE  VoucherKey = @VoucherKey	
	
-- we must do this in a loop because of the taxes
	
DECLARE @VoucherDetailKey int
SELECT @VoucherDetailKey = -1
WHILE (1=1)
BEGIN
	SELECT @VoucherDetailKey = MIN(VoucherDetailKey)
	FROM   tVoucherDetail (nolock)
	WHERE  VoucherDetailKey > @VoucherDetailKey
	AND    VoucherKey = @VoucherKey
	AND    TransferToKey IS NULL -- why copy transferred voucher lines?...No reason to 
	
	IF @VoucherDetailKey IS NULL
		BREAK
		
	INSERT tVoucherDetail
		(
		VoucherKey,
		LineNumber,
		PurchaseOrderDetailKey,
		ProjectKey,
		TaskKey,
		ShortDescription,
		ItemKey,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		Billable,
		Markup,
		BillableCost,
		AmountBilled,
		InvoiceLineKey,
		WriteOff,
		ExpenseAccountKey,
		ClassKey,
		QuantityBilled,
		WIPPostingInKey,
		WIPPostingOutKey,
		TransferComment,
		OfficeKey,
		DepartmentKey,
		Taxable,
		Taxable2,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		PTotalCost,
		Commission,
		GrossAmount
		)
	SELECT
		@NewKey,
		LineNumber,
		NULL,
		ProjectKey,
		TaskKey,
		ShortDescription,
		ItemKey,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		Billable,
		Markup,
		BillableCost,
		0,
		NULL,
		0,
		ExpenseAccountKey,
		ClassKey,
		0,
		0,
		0,
		NULL,
		OfficeKey,
		DepartmentKey,
		Taxable,
		Taxable2,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		PTotalCost,
		Commission,
		GrossAmount
		
	FROM tVoucherDetail 
	Where VoucherDetailKey = @VoucherDetailKey
  
	SELECT @NewDetailKey = @@IDENTITY
	

	INSERT tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
	SELECT @NewDetailKey, SalesTaxKey, SalesTaxAmount
	FROM   tVoucherDetailTax  (NOLOCK)
	WHERE  VoucherDetailKey = @VoucherDetailKey	
	
END


		 		
END	-- Recurring loop

Commit Transaction

-- Rollup does not have to be in transaction
-- Rollup for entity @VoucherKey since same projects have been copied from that voucher to the other ones
EXEC sptProjectRollupUpdateEntity 'tVoucher', @VoucherKey
GO
