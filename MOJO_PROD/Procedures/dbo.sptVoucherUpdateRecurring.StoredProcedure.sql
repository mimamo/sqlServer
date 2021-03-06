USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateRecurring]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateRecurring]

	(
		@SourceVoucherKey int,
		@TargetVoucherKey int
	)

AS

  /*
  || When     Who Rel    What
  || 02/15/07 GHL 8.4    Added project rollup section       
  || 10/16/13 GHL 10.573 Added GrossAmount,Commission          
  */
  
if exists(select 1 from tVoucherDetail (NOLOCK) WHERE VoucherKey = @SourceVoucherKey and ISNULL(PurchaseOrderDetailKey, 0) > 0)
	return -1
if exists(select 1 from tVoucherDetail (NOLOCK) WHERE VoucherKey = @TargetVoucherKey and ISNULL(PurchaseOrderDetailKey, 0) > 0)
	return -1
if exists(select 1 from tVoucher (NOLOCK) Where VoucherKey = @TargetVoucherKey and (Posted = 1 or AmountPaid > 0))
	return -1

Declare @RecurringParentKey int,
	@DateReceived smalldatetime,
	@DateCreated smalldatetime,
	@APAccountKey int,
	@ClassKey int,
	@CreatedByKey int,
	@TermsPercent decimal(5),
	@TermsDays int,
	@TermsNet int,
	@Description varchar(500),
	@PurchaseOrderKey int,
	@VoucherTotal money,
	@ApprovedDate smalldatetime,
	@ApprovedByKey int,
	@Status smallint,
	@ApprovalComments varchar(500),
	@GLCompanyKey int,
	@ProjectKey int,
	@OfficeKey int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@SalesTax1Amount money,
	@SalesTax2Amount  money,
	@SalesTaxAmount  money,
	@Error int
	
	
	Select
		@RecurringParentKey = RecurringParentKey,
		@DateReceived = DateReceived,
		@DateCreated = DateCreated,
		@APAccountKey = APAccountKey,
		@ClassKey = ClassKey,
		@CreatedByKey = CreatedByKey,
		@TermsPercent = TermsPercent,
		@TermsDays = TermsDays,
		@TermsNet = TermsNet,
		@Description = Description,
		@VoucherTotal = VoucherTotal,
		@ApprovedDate = ApprovedDate,
		@ApprovedByKey = ApprovedByKey,
		@Status = Status,
		@ApprovalComments = ApprovalComments,
		@ProjectKey = ProjectKey,
		@GLCompanyKey = GLCompanyKey,
		@OfficeKey = OfficeKey,
		@SalesTaxKey = SalesTaxKey,
		@SalesTax2Key = SalesTax2Key,
		@SalesTax1Amount = SalesTax1Amount,
		@SalesTax2Amount = SalesTax2Amount,
		@SalesTaxAmount = SalesTaxAmount
	From tVoucher (NOLOCK)
	WHERE VoucherKey = @SourceVoucherKey 

Begin Transaction

	Delete tVoucherTax Where VoucherKey = @TargetVoucherKey
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end

	Delete tVoucherDetailTax
	from   tVoucherDetail vd (nolock)
	Where  tVoucherDetailTax.VoucherDetailKey = vd.VoucherDetailKey
	And    vd.VoucherKey = @TargetVoucherKey
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end

	Delete tVoucherDetail Where VoucherKey = @TargetVoucherKey
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
		
	UPDATE
		tVoucher
	SET
		RecurringParentKey = @RecurringParentKey,
		DateReceived = @DateReceived,
		DateCreated = @DateCreated,
		APAccountKey = @APAccountKey,
		ClassKey = @ClassKey,
		CreatedByKey = @CreatedByKey,
		TermsPercent = @TermsPercent,
		TermsDays = @TermsDays,
		TermsNet = @TermsNet,
		Description = @Description,
		VoucherTotal = @VoucherTotal,
		ApprovedDate = @ApprovedDate,
		ApprovedByKey = @ApprovedByKey,
		Status = @Status,
		ApprovalComments = @ApprovalComments,
		ProjectKey = @ProjectKey,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		SalesTax1Amount = @SalesTax1Amount,
		SalesTax2Amount = @SalesTax2Amount,
		SalesTaxAmount = @SalesTaxAmount
	WHERE
		VoucherKey = @TargetVoucherKey 
		
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
		
	INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @TargetVoucherKey, SalesTaxKey, SalesTaxAmount, Type
	FROM   tVoucherTax  (NOLOCK)
	WHERE  VoucherKey = @SourceVoucherKey	

	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
-- we must do this in a loop because of the taxes
	
DECLARE @SourceVoucherDetailKey int, @TargetVoucherDetailKey int

SELECT @SourceVoucherDetailKey = -1
WHILE (1=1)
BEGIN
	SELECT @SourceVoucherDetailKey = MIN(VoucherDetailKey)
	FROM   tVoucherDetail (nolock)
	WHERE  VoucherDetailKey > @SourceVoucherDetailKey
	AND    VoucherKey = @SourceVoucherKey
	AND    TransferToKey IS NULL -- why copy transferred voucher lines?...No reason to 
	
	IF @SourceVoucherDetailKey IS NULL
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
		@TargetVoucherKey,
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
	Where VoucherDetailKey = @SourceVoucherDetailKey
  
	select @Error = @@ERROR, @TargetVoucherDetailKey = @@IDENTITY
	
	if @Error <> 0 
	begin
		rollback tran
		return -3					   	
	end

	INSERT tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
	SELECT @TargetVoucherDetailKey, SalesTaxKey, SalesTaxAmount
	FROM   tVoucherDetailTax  (NOLOCK)
	WHERE  VoucherDetailKey = @SourceVoucherDetailKey	
	
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end

END

	
Commit Transaction

exec sptProjectRollupUpdateEntity 'tVoucher', @SourceVoucherKey
GO
