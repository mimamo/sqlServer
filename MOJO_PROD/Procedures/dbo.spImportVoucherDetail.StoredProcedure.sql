USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportVoucherDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportVoucherDetail]

	(
		@CompanyKey int,
		@VoucherKey int,
		@ProjectNumber varchar(100),
		@TaskID varchar(50),
		@LineDescription varchar(500),
		@ItemID varchar(50),
		@Quantity decimal(9,3),
		@UnitCost money,
		@UnitDescription varchar(100),
		@TotalCost money,
		@Billable varchar(20),
		@Markup decimal(9,3),
		@BillableAmount money,
		@AmountBilled money,
		@ExpenseAccountNumber varchar(50),
		@ExpenseClassID varchar(50),
		@ExpenseOfficeID varchar(50),
		@Billed tinyint,
		@WriteOff tinyint,
		@Taxable tinyint,
		@Taxable2 tinyint
		
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/8/07   CRG 8.4.3.8 (13984) Removed TaskType restriction on Task validation.
|| 09/21/09  GHL 10.5    Using now sptVoucherRecalcAmounts (taxes editable now on the voucher lines)
|| 04/08/11 RLB 10.543   (108265) Added OfficeKey
*/

Declare @ProjectKey int, @TaskKey int, @CurTran int, @ItemKey int, @Retval int, @InvoiceLineKey int, @ExpenseAccountKey int, @DClassKey int, @DOfficeKey int

if not @ProjectNumber is null
BEGIN
	Select @ProjectKey = ProjectKey from tProject (nolock) Where CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber and Closed = 0
	if @ProjectKey is null
		Return -1
END
if not @TaskID is null
BEGIN
	Select @TaskKey = TaskKey from tTask (nolock) Where ProjectKey = @ProjectKey and TaskID = @TaskID and TrackBudget = 1
	if @TaskKey is null
		Return -2
END

if @ProjectKey is not null 
begin
	if @TaskKey is null and (select isnull(RequireTasks, 1) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1 
		Return -3
end
	
if @ProjectKey is null and @TaskKey is not null
	return -4
	
if not @ItemID is null
BEGIN
	Select @ItemKey = ItemKey from tItem (nolock) Where CompanyKey = @CompanyKey and ItemID = @ItemID
	if @ItemKey is null
		Return -5
END

Select @TotalCost = ISNULL(@TotalCost, ISNULL(@Quantity, 0) * isnull(@UnitCost, 0))
if ISNULL(@Billable, 1) = 1
	Select @BillableAmount = ISNULL(@BillableAmount, @TotalCost * (1.0 + (Cast(ISNULL(@Markup, 0) as float) / 100.0)))
else
	Select @BillableAmount = 0
	
if not @ExpenseAccountNumber is null
BEGIN
	Select @ExpenseAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountNumber = @ExpenseAccountNumber and Rollup = 0
	if @ExpenseAccountKey is null
		return -6
END

if not @ExpenseClassID is null
BEGIN
	Select @DClassKey = ClassKey from tClass (nolock) Where CompanyKey = @CompanyKey and ClassID = @ExpenseClassID
	if @DClassKey is null
		Return -7
END

if @DClassKey is null and (select ISNULL(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
	Return -7

if not @ExpenseOfficeID is null
BEGIN
	Select @DOfficeKey = OfficeKey from tOffice (nolock) Where CompanyKey = @CompanyKey and OfficeID = @ExpenseOfficeID
	if @DOfficeKey is null
		Return -9
END

if @DOfficeKey is null and (select ISNULL(RequireOffice, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
	Return -9


if @ProjectKey is not null
BEGIN
if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
	return -8
	
if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 0)
	return -8
END
   
DECLARE @NextNumber INT

SELECT @NextNumber = ISNULL(MAX(LineNumber), 0) + 1
FROM   tVoucherDetail (NOLOCK)
WHERE  VoucherKey = @VoucherKey
	
if @WriteOff = 1
BEGIN
	Select @InvoiceLineKey = NULL, @AmountBilled = 0
END
ELSE
BEGIN
	if @Billed = 1
		Select @InvoiceLineKey = 0, @AmountBilled = ISNULL(@AmountBilled, ISNULL(@BillableAmount, 0)), @WriteOff = 0
	else
		Select @InvoiceLineKey = NULL, @WriteOff = 0, @AmountBilled = 0
END 

INSERT tVoucherDetail
	(
	VoucherKey,
	LineNumber,
	PurchaseOrderDetailKey,
	ProjectKey,
	TaskKey,
	ItemKey,
	ClassKey,
	OfficeKey,
	ShortDescription,
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
	Taxable,
	Taxable2	
	)

VALUES
	(
	@VoucherKey,
	@NextNumber,
	NULL,
	@ProjectKey,
	@TaskKey,
	@ItemKey,
	@DClassKey,
	@DOfficeKey,
	@LineDescription,
	@Quantity,
	@UnitCost,
	@UnitDescription,
	@TotalCost,
	@Billable,
	@Markup,
	@BillableAmount,
	@AmountBilled,
	@InvoiceLineKey,
	@WriteOff,
	@ExpenseAccountKey,
	@Taxable,
	@Taxable2	
	)

	EXEC sptVoucherRecalcAmounts @VoucherKey
GO
