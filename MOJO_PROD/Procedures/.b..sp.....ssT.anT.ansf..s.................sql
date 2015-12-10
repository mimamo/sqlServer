USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransfers]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransfers]

	(
		@UserKey int,
		@ToProjectKey int,
		@ToTaskKey int,
		@TranType varchar(8),
		@TranKey varchar(100),
		@TransferDate smalldatetime,
		@CheckBillingDetail int = 1, -- Set to 0 to allow for transfers between billing worksheets
	    @TransferComment varchar(400) = null
	)

AS

  /*
  || When     Who Rel     What
  || 08/04/06 GHL 8.35    Added CheckBillingDetail param so that we can still perform 
  ||                      immediate transfers from one billing worksheet to another
  || 07/23/07 BSH 8.4.3.2 (10164)Allow transactions that are marked as billed but not posted to WIP to transfer.
  || 08/14/07 GHL 8.5     Added wip posting adjustment
  || 03/10/08 GHL 8.506   (22308) Setting now DetailTaskKey = null during transfers because parent task is different
  || 04/17/08 GHL 8.508   Made transfer message more explicit
  || 08/11/08 GHL 10.0.0.6  Calling now sptTimeInsertFixTaskKeys for task validations 
  || 10/09/08 GHL 10.0.1.0 (37137) Reviewed error returns because not explicit enough for users 
  || 11/05/09 GHL 10.513  Added TransferDate + changed logic about WriteOffs out of WIP
  || 06/04/10 GHL 10.530  (82202) Added return for prebilled PO associated to a voucher line 
  || 06/04/10 GHL 10.530  (82255) Added TransferComment to capture comment from the billing worksheet
  || 05/29/13 WDF 10.568  (178005) Revert logic about WriteOffs back to original 
  || 09/25/13 GHL 10.572  Added multi currency logic
  || 09/26/13 WDF 10.573  (188654) Added UserKey
  || 11/07/14 GHL 10.586  Added logic for tPreference.AllowTransferDate for Albelson Taylor enhancement
  || 11/19/14 GHL 10.586  Added logic for transfer adjustments for Albelson Taylor enhancement
  */

Declare @NewProjectNumber as varchar(100)
Declare @NewTaskID as varchar(100)
Declare @OrigProjectKey int
Declare @OrigProjectNumber as varchar(50)
Declare @OrigTaskID as varchar(50)
declare @WriteOff tinyint
declare @InvoiceLineKey int
declare @Status smallint
declare @TimeActive int
declare @ExpenseActive int
declare @WIPPostingInKey int
declare @WIPPostingOutKey int
declare @UIDTranKey uniqueidentifier
declare @iTranKey int
declare @Ret int
declare @DetailTaskKey int
declare @CompanyKey int
declare @UseGLCompany int
declare @IOClientLink int
declare @BCClientLink int
Declare @TransferToComment as varchar(500)
Declare @TransferFromComment as varchar(500)
declare @FromGLCompanyKey int
declare @ToGLCompanyKey int
declare @MultiCurrency int
declare @OrigCurrencyID varchar(10)
declare @ToCurrencyID varchar(10)
declare @Initiator varchar(201)
declare @AllowTransferDate int
declare @TransactionDate smalldatetime

DECLARE @kErrInvalidGLCompany INT				SELECT @kErrInvalidGLCompany =  -90 
DECLARE @kErrInvalidTimeInactive INT			SELECT @kErrInvalidTimeInactive = -100 
DECLARE @kErrInvalidExpInactive INT				SELECT @kErrInvalidExpInactive = -101 
DECLARE @kErrInvalidCurrency INT				SELECT @kErrInvalidCurrency = -200 
DECLARE @kErrInvalidWritenOff INT				SELECT @kErrInvalidWritenOff = -7
DECLARE @kErrInvalidBilled INT					SELECT @kErrInvalidBilled = -8
DECLARE @kErrInvalidLinkedPOBilled INT			SELECT @kErrInvalidLinkedPOBilled = -9
DECLARE @kErrInvalidMarkBilled INT				SELECT @kErrInvalidMarkBilled = -13
DECLARE @kErrInvalidOnBillingWS INT				SELECT @kErrInvalidOnBillingWS = -999
DECLARE @kErrWIPAdjustment INT					SELECT @kErrWIPAdjustment = -1300
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000
 
 
	IF @TransferDate IS NULL
		SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	ELSE
		SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), @TransferDate, 101)), 101)
 
	Select @NewProjectNumber = ProjectNumber, @CompanyKey = CompanyKey, @ToGLCompanyKey = isnull(GLCompanyKey, 0), @ToCurrencyID = isnull(CurrencyID, '') 
	from tProject (nolock) Where ProjectKey = @ToProjectKey
	
	Select @NewTaskID = TaskID 
	from tTask (nolock) Where TaskKey = @ToTaskKey
	
	Select @TimeActive = isnull(ps.TimeActive, 1), @ExpenseActive = isnull(ps.ExpenseActive, 1) 
	From   tProject p (nolock)
		left join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	Where  p.ProjectKey = @ToProjectKey

	select @MultiCurrency = isnull(MultiCurrency, 0)
	      ,@AllowTransferDate = isnull(AllowTransferDate, 1) 
	from tPreference (nolock) where CompanyKey = @CompanyKey

    select @Initiator = FirstName + ' ' + LastName from tUser (nolock) where UserKey = @UserKey

IF @TranType = 'LABOR'
BEGIN

	if @TimeActive = 0
		return @kErrInvalidTimeInactive 
		
	If @CheckBillingDetail = 1	
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityGuid = Cast(@TranKey as uniqueidentifier) and b.Status < 5)
		return @kErrInvalidOnBillingWS 
	
	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = ts.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey,
		@OrigCurrencyID = isnull(p.CurrencyID, ''),
		@TransactionDate = t.WorkDate
	From tTime t (nolock)
		inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.TimeKey = Cast(@TranKey as uniqueidentifier)
		

	if @Status = 4
		begin
			if @WriteOff = 1
				return @kErrInvalidWritenOff 
				
			if @InvoiceLineKey > 0
				return @kErrInvalidBilled 
			--if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
			--	return @kErrInvalidMarkBilled 
			
			-- do not transfer if WO and posted out of WIP
			-- if @WriteOff = 1 And @WIPPostingOutKey <> 0
			--	return @kErrInvalidWritenOff
			
		end
					
	if @MultiCurrency = 1 and @OrigCurrencyID <> @ToCurrencyID
		return @kErrInvalidCurrency

	Select @TransferFromComment = @Initiator + ': Transfer from Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @TransferToComment = @Initiator + ': Transfer to Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	
	if @TransferComment is not null
	begin
		select @TransferFromComment = @TransferFromComment + ' ' + @TransferComment
		select @TransferToComment = @TransferToComment + ' ' + @TransferComment 
	end 

	-- validations + update detail task key when possible  
    -- parameters are both input and output
	exec sptTimeInsertFixTaskKeys @ToProjectKey, @ToTaskKey output, @DetailTaskKey output
	 
	
	Select @UIDTranKey = Cast(@TranKey as UNIQUEIDENTIFIER)
	
	if @AllowTransferDate = 0
		select @TransferDate = @TransactionDate

	declare @TitleKey int
	declare @IsAdjustment int
	declare @TransferToKey uniqueidentifier

	select @IsAdjustment = 0 -- This is a transfer not an adjustment
	EXEC @Ret = spProcessTranTransferTI @UIDTranKey,@ToProjectKey,@ToTaskKey,@TransferDate,@TransferFromComment,@TransferToComment,@TitleKey,@IsAdjustment,@TransferToKey output 

	if @Ret <0 
		return @kErrUnexpected

END


IF @TranType = 'EXPRPT'
BEGIN

	if @ExpenseActive = 0
		return @kErrInvalidExpInactive 

	If @CheckBillingDetail = 1			
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityKey = Cast(@TranKey as int) and bd.Entity = 'tExpenseReceipt' and b.Status < 5)
		return @kErrInvalidOnBillingWS 
		
	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = ee.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey,
		@OrigCurrencyID = isnull(p.CurrencyID, ''),
		@TransactionDate = t.ExpenseDate
	From tExpenseReceipt t (nolock)
		inner join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = t.ExpenseEnvelopeKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.ExpenseReceiptKey = Cast(@TranKey as int)
	
	if @Status = 4
		begin
			if @WriteOff = 1
				return @kErrInvalidWritenOff 
				
			if @InvoiceLineKey > 0
				return @kErrInvalidBilled 
			--if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
			--	return @kErrInvalidMarkBilled 

			-- do not transfer if WO and posted out of WIP
			-- if @WriteOff = 1 And @WIPPostingOutKey <> 0
			--	return @kErrInvalidWritenOff

		end

	if @MultiCurrency = 1 and @OrigCurrencyID <> @ToCurrencyID
		return @kErrInvalidCurrency
			
	Select @TransferFromComment = @Initiator + ': Transfer from Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @TransferToComment = @Initiator + ': Transfer to Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')

	if @TransferComment is not null
	begin
		select @TransferFromComment = @TransferFromComment + ' ' + @TransferComment
		select @TransferToComment = @TransferToComment + ' ' + @TransferComment 
	end 
	
	Select @iTranKey = Cast(@TranKey as int)
		
	if @AllowTransferDate = 0
		select @TransferDate = @TransactionDate

	EXEC @Ret = spProcessTranTransferER @iTranKey,@ToProjectKey,@ToTaskKey,@TransferDate,@TransferFromComment, @TransferToComment 
	
	if @Ret <0 
		return @kErrUnexpected
END


IF @TranType = 'MISCCOST'
BEGIN

	if @ExpenseActive = 0
		return @kErrInvalidExpInactive 
		
	If @CheckBillingDetail = 1			
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityKey = Cast(@TranKey as int) and bd.Entity = 'tMiscCost' and b.Status < 5)
		return @kErrInvalidOnBillingWS 

	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey,
		@OrigCurrencyID = isnull(p.CurrencyID, ''),
		@TransactionDate = t.ExpenseDate
	From tMiscCost t (nolock)
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.MiscCostKey = Cast(@TranKey as int)
	
	if @WriteOff = 1
		return @kErrInvalidWritenOff 
		
	if @InvoiceLineKey > 0
		return @kErrInvalidBilled 
	--if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
	--	return @kErrInvalidMarkBilled 

	-- do not transfer if WO and posted out of WIP
	-- if @WriteOff = 1 And @WIPPostingOutKey <> 0
	-- 	return @kErrInvalidWritenOff

	if @MultiCurrency = 1 and @OrigCurrencyID <> @ToCurrencyID
		return @kErrInvalidCurrency
					
	Select @TransferFromComment = @Initiator + ': Transfer from Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @TransferToComment = @Initiator + ': Transfer to Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')

	if @TransferComment is not null
	begin
		select @TransferFromComment = @TransferFromComment + ' ' + @TransferComment
		select @TransferToComment = @TransferToComment + ' ' + @TransferComment 
	end 
	
	Select @iTranKey = Cast(@TranKey as int)
	
	if @AllowTransferDate = 0
		select @TransferDate = @TransactionDate
			
	EXEC @Ret = spProcessTranTransferMC @iTranKey,@ToProjectKey,@ToTaskKey,@TransferDate,@TransferFromComment, @TransferToComment 

	if @Ret <0 
		return @kErrUnexpected
END


IF @TranType = 'VOUCHER'
BEGIN

	if @ExpenseActive = 0
		return @kErrInvalidExpInactive 
		
	If @CheckBillingDetail = 1	
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityKey = Cast(@TranKey as int) and bd.Entity = 'tVoucherDetail' and b.Status < 5)
		return @kErrInvalidOnBillingWS 

	Declare @PurchaseOrderDetailKey int
	
	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = v.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey,
		@PurchaseOrderDetailKey = t.PurchaseOrderDetailKey,
		@FromGLCompanyKey = isnull(v.GLCompanyKey, 0),
		@OrigCurrencyID = isnull(p.CurrencyID, ''),
		@TransactionDate = v.InvoiceDate
	From tVoucherDetail t (nolock)
		inner join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.VoucherDetailKey = Cast(@TranKey as int)

	if @Status = 4
		begin
			-- WO and MB, Should be handled now by spProcessTranTransferVO
			
			if @WriteOff = 1
				return @kErrInvalidWritenOff 
				
			if @InvoiceLineKey > 0
				return @kErrInvalidBilled 
			--if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
			--	return @kErrInvalidMarkBilled

			-- do not transfer if WO and posted out of WIP
			-- if @WriteOff = 1 And @WIPPostingOutKey <> 0
			--	return @kErrInvalidWritenOff
			
			-- this would complicate the calculation of accrual amounts in spglPostVoucher/spglPostInvoice
			if exists (select 1
			   from  tPurchaseOrderDetail (nolock)
			   where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			   and   InvoiceLineKey > 0)
			   return @kErrInvalidLinkedPOBilled 
		end

	if @MultiCurrency = 1 and @OrigCurrencyID <> @ToCurrencyID
		return @kErrInvalidCurrency
			
	Select @TransferFromComment = @Initiator + ': Transfer from Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @TransferToComment = @Initiator + ': Transfer to Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')

	if @TransferComment is not null
	begin
		select @TransferFromComment = @TransferFromComment + ' ' + @TransferComment
		select @TransferToComment = @TransferToComment + ' ' + @TransferComment 
	end 
	
	Select @iTranKey = Cast(@TranKey as int)
	
	Select @IOClientLink = ISNULL(IOClientLink, 1)
			,@BCClientLink = ISNULL(BCClientLink, 1)
			,@UseGLCompany = ISNULL(UseGLCompany, 0)
	From   tPreference (NOLOCK)
	Where  CompanyKey =	@CompanyKey	
	
	IF @UseGLCompany = 1 AND @FromGLCompanyKey <> @ToGLCompanyKey
		return @kErrInvalidGLCompany

	if @AllowTransferDate = 0
		select @TransferDate = @TransactionDate
			
	EXEC @Ret = spProcessTranTransferVO @iTranKey,@ToProjectKey,@ToTaskKey,@TransferDate,@TransferFromComment, @TransferToComment, @IOClientLink,@BCClientLink 

	if @Ret <0 
		return @kErrUnexpected	
END


IF @TranType = 'ORDER'
BEGIN

	if @ExpenseActive = 0
		return @kErrInvalidExpInactive 
		
	If @CheckBillingDetail = 1			
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityKey = Cast(@TranKey as int) and bd.Entity = 'tPurchaseOrderDetail' and b.Status < 5)
		return @kErrInvalidOnBillingWS 

	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = po.Status,
		@OrigCurrencyID = isnull(p.CurrencyID, ''),
		@TransactionDate = isnull(t.DetailOrderDate, po.PODate)			
	From tPurchaseOrderDetail t (nolock)
		inner join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.PurchaseOrderDetailKey = Cast(@TranKey as int)

	if @Status = 4
		begin
			if @InvoiceLineKey > 0
				return @kErrInvalidBilled 
		end

	if @MultiCurrency = 1 and @OrigCurrencyID <> @ToCurrencyID
		return @kErrInvalidCurrency
			
	Select @TransferFromComment = @Initiator + ': Transfer from Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @TransferToComment = @Initiator + ': Transfer to Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')

	if @TransferComment is not null
	begin
		select @TransferFromComment = @TransferFromComment + ' ' + @TransferComment
		select @TransferToComment = @TransferToComment + ' ' + @TransferComment 
	end 

	Select @iTranKey = Cast(@TranKey as int)
	
	if @AllowTransferDate = 0
		select @TransferDate = @TransactionDate

	EXEC @Ret = spProcessTranTransferPO @iTranKey,@ToProjectKey,@ToTaskKey,@TransferDate,@TransferFromComment, @TransferToComment 

	if @Ret <0 
		return @kErrUnexpected
END


return 1
GO
