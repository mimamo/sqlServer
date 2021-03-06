USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransfer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransfer]

	(
		@UserKey int,
		@ToProjectKey int,
		@ToTaskKey int,
		@TranType varchar(8),
		@TranKey varchar(100),
		@CheckBillingDetail int = 1 -- Set to 0 to allow for transfers between billing worksheets
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
  || 11/16/09 GHL 10.513 (68471) When creating the new transaction, use OfficeKey/ClassKey from project   
  || 09/26/13 WDF 10.573  (188654) Added UserKey
 */

Declare @OrigTranComment as varchar(500)
Declare @NewProjectNumber as varchar(100)
Declare @NewTaskID as varchar(100)
Declare @OrigProjectKey int
Declare @OrigProjectNumber as varchar(50)
Declare @OrigTaskID as varchar(50)
Declare @NewMessage as varchar(500)
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
Declare @CompanyKey int
Declare @ToOfficeKey int
Declare @ToClassKey int
Declare @DefaultClassKey int
Declare @Initiator varchar(201)

DECLARE @kErrInvalidTimeInactive INT			SELECT @kErrInvalidTimeInactive = -100 
DECLARE @kErrInvalidExpInactive INT				SELECT @kErrInvalidExpInactive = -101 
DECLARE @kErrInvalidWritenOff INT				SELECT @kErrInvalidWritenOff = -7
DECLARE @kErrInvalidBilled INT					SELECT @kErrInvalidBilled = -8
DECLARE @kErrInvalidMarkBilled INT				SELECT @kErrInvalidMarkBilled = -13
DECLARE @kErrInvalidOnBillingWS INT				SELECT @kErrInvalidOnBillingWS = -999
DECLARE @kErrWIPAdjustment INT					SELECT @kErrWIPAdjustment = -1300
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000
 
 
	Select @NewProjectNumber = ProjectNumber, @ToOfficeKey = OfficeKey, @ToClassKey = ClassKey, @CompanyKey = CompanyKey 
	from tProject (nolock) Where ProjectKey = @ToProjectKey
	
	if @ToOfficeKey = 0 select @ToOfficeKey = null
	if @ToClassKey = 0 select @ToClassKey = null

	Select @DefaultClassKey = DefaultClassKey
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
		 
	If isnull(@ToClassKey, 0) = 0
		select @ToClassKey, @DefaultClassKey
		 
	if @ToClassKey = 0 select @ToClassKey = null
	
	Select @NewTaskID = TaskID from tTask (nolock) Where TaskKey = @ToTaskKey
	
	Select @TimeActive = isnull(ps.TimeActive, 1), @ExpenseActive = isnull(ps.ExpenseActive, 1) 
	From   tProject p (nolock)
		left join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	Where  p.ProjectKey = @ToProjectKey

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
		@OrigTranComment = ISNULL(t.TransferComment, ''),
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = ts.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey
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
			if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
				return @kErrInvalidMarkBilled 
		end
				
	Select @NewMessage = @Initiator + ': From Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @NewMessage = @NewMessage + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	Select @NewMessage = @NewMessage + '<br>' + left(@OrigTranComment, 500 - Len(@NewMessage))
	
	-- validations + update detail task key when possible  
    -- parameters are both input and output
	exec sptTimeInsertFixTaskKeys @ToProjectKey, @ToTaskKey output, @DetailTaskKey output
	 
	Begin Tran

	if @InvoiceLineKey = 0 and @WIPPostingOutKey = 0
	Begin					
			Update tTime
			set 
				TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey, DetailTaskKey = @DetailTaskKey 
				,DateBilled = Null, InvoiceLineKey = Null, WriteOff = 0
			Where
				TimeKey = Cast(@TranKey as uniqueidentifier)
	
			If @@ERROR <> 0
			Begin
				Rollback Tran
				Return @kErrUnexpected 
			End	
			
	End
	else
	Begin	
		Update tTime
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey, DetailTaskKey = NULL
		Where
			TimeKey = Cast(@TranKey as uniqueidentifier)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End

	If @WIPPostingInKey > 0 AND @WIPPostingOutKey = 0
	Begin
		Select @UIDTranKey = Cast(@TranKey as uniqueidentifier)
		
		Exec @Ret = spGLPostWIPAdjustment 'tTime', Null, @UIDTranKey, @OrigProjectKey, @ToProjectKey

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

		If @Ret <> 1
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

	End	
			
	Commit Tran
	
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
		@OrigTranComment = ISNULL(t.TransferComment, ''),
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = ee.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey
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
			if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
				return @kErrInvalidMarkBilled 
		end
			
	Select @NewMessage = @Initiator + ': From Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @NewMessage = @NewMessage + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	Select @NewMessage = @NewMessage + '<br>' + left(@OrigTranComment, 500 - Len(@NewMessage))
	
	Begin Tran

	if @InvoiceLineKey = 0 and @WIPPostingOutKey = 0
	Begin	
		Update tExpenseReceipt
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey, 
			DateBilled = Null, InvoiceLineKey = Null, WriteOff = 0
		Where
			ExpenseReceiptKey = Cast(@TranKey as int)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End
	else
	Begin
		Update tExpenseReceipt
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey
		Where
			ExpenseReceiptKey = Cast(@TranKey as int)	

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End

	If @WIPPostingInKey > 0 AND @WIPPostingOutKey = 0
	Begin
		Select @iTranKey = Cast(@TranKey as int)
		
		Exec @Ret = spGLPostWIPAdjustment 'tExpenseReceipt', @iTranKey, Null, @OrigProjectKey, @ToProjectKey

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

		If @Ret <> 1
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

	End	
			
	Commit Tran
	
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
		@OrigTranComment = ISNULL(t.TransferComment, ''),
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey
	From tMiscCost t (nolock)
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.MiscCostKey = Cast(@TranKey as int)
	
	if @WriteOff = 1
		return @kErrInvalidWritenOff 
	if @InvoiceLineKey > 0
		return @kErrInvalidBilled 
	if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
		return @kErrInvalidMarkBilled 
					
	Select @NewMessage = @Initiator + ': From Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @NewMessage = @NewMessage + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	Select @NewMessage = @NewMessage + '<br>' + left(@OrigTranComment, 500 - Len(@NewMessage))
	
	Begin Tran
	
	if @InvoiceLineKey = 0 and @WIPPostingOutKey = 0
	Begin
		Update tMiscCost
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey, ClassKey = @ToClassKey,
			DateBilled = Null, InvoiceLineKey = Null, WriteOff = 0
		Where
			MiscCostKey = Cast(@TranKey as int)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End
	else
	Begin
		Update tMiscCost
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey, ClassKey = @ToClassKey
		Where
			MiscCostKey = Cast(@TranKey as int)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End

	If @WIPPostingInKey > 0 AND @WIPPostingOutKey = 0
	Begin
		Select @iTranKey = Cast(@TranKey as int)
		
		Exec @Ret = spGLPostWIPAdjustment 'tMiscCost', @iTranKey, Null, @OrigProjectKey, @ToProjectKey

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

		If @Ret <> 1
		Begin
			Rollback Tran
			Return @kErrWIPAdjustment 
		End	

	End	
	
	Commit Tran
	
END


IF @TranType = 'VOUCHER'
BEGIN

	if @ExpenseActive = 0
		return @kErrInvalidExpInactive 
		
	If @CheckBillingDetail = 1	
	If exists(Select 1 from tBillingDetail bd (nolock) inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
		Where bd.EntityKey = Cast(@TranKey as int) and bd.Entity = 'tVoucherDetail' and b.Status < 5)
		return @kErrInvalidOnBillingWS 

	Select
		@OrigProjectKey = t.ProjectKey,
		@OrigProjectNumber = p.ProjectNumber,
		@OrigTaskID = ta.TaskID,
		@OrigTranComment = ISNULL(t.TransferComment, ''),
		@WriteOff = t.WriteOff,
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = v.Status,
		@WIPPostingInKey = t.WIPPostingInKey,
		@WIPPostingOutKey = t.WIPPostingOutKey
	From tVoucherDetail t (nolock)
		inner join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Where
		t.VoucherDetailKey = Cast(@TranKey as int)

	if @Status = 4
		begin
			if @WriteOff = 1
				return @kErrInvalidWritenOff 
			if @InvoiceLineKey > 0
				return @kErrInvalidBilled 
			if @InvoiceLineKey = 0 and @WIPPostingOutKey > 0
				return @kErrInvalidMarkBilled 
		end
			
	Select @NewMessage = @Initiator + ': From Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @NewMessage = @NewMessage + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	Select @NewMessage = @NewMessage + '<br>' + left(@OrigTranComment, 500 - Len(@NewMessage))
	
	Begin Tran
	
	if @InvoiceLineKey = 0 and @WIPPostingOutKey = 0
	Begin
		Update tVoucherDetail
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey,
			ClassKey = @ToClassKey, OfficeKey = @ToOfficeKey,
			DateBilled = Null, InvoiceLineKey = Null, WriteOff = 0
		Where
			VoucherDetailKey = Cast(@TranKey as int)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End
	else
	Begin
		Update tVoucherDetail
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey,
			ClassKey = @ToClassKey, OfficeKey = @ToOfficeKey
		Where
			VoucherDetailKey = Cast(@TranKey as int)

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End
	
	If @WIPPostingInKey > 0 AND @WIPPostingOutKey = 0
	Begin
		Select @iTranKey = Cast(@TranKey as int)
		
		Exec @Ret = spGLPostWIPAdjustment 'tVoucherDetail', @iTranKey, Null, @OrigProjectKey, @ToProjectKey

		If @@ERROR <> 0
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

		If @Ret <> 1
		Begin
			Rollback Tran
			Return @kErrUnexpected 
		End	

	End	
	
	Commit Tran

		
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
		@OrigTranComment = ISNULL(t.TransferComment, ''),
		@InvoiceLineKey = t.InvoiceLineKey,
		@Status = po.Status				
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
			
	Select @NewMessage = @Initiator + ': From Project ' + ISNULL(@OrigProjectNumber, 'NONE') + ' and Task ' + ISNULL(@OrigTaskID, 'NONE')
	Select @NewMessage = @NewMessage + ' To Project ' + ISNULL(@NewProjectNumber, 'NONE') + ' and Task ' + ISNULL(@NewTaskID, 'NONE')
	Select @NewMessage = @NewMessage + '<br>' + left(@OrigTranComment, 500 - Len(@NewMessage))
	
	if @InvoiceLineKey = 0
		Update tPurchaseOrderDetail
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey,
			ClassKey = @ToClassKey, OfficeKey = @ToOfficeKey,
			DateBilled = Null, InvoiceLineKey = Null
		Where
			PurchaseOrderDetailKey = Cast(@TranKey as int)
	else
		Update tPurchaseOrderDetail
		Set
			TransferComment = @NewMessage, ProjectKey = @ToProjectKey, TaskKey = @ToTaskKey,
			ClassKey = @ToClassKey, OfficeKey = @ToOfficeKey
		Where
			PurchaseOrderDetailKey = Cast(@TranKey as int)

END


return 1
GO
