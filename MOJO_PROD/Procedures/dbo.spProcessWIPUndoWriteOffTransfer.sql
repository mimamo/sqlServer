USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPUndoWriteOffTransfer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPUndoWriteOffTransfer]
	 @EntityKey VARCHAR(50)
	,@WOType VARCHAR(50)
	,@CompanyKey int
	,@TransferDate smalldatetime = null
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/06/15  GHL 10588   Creation for an enhancement for Abelson Taylor
||                       Added ability to undo Writeoff for transactions posted to WIP
||                       if we have the option for that, create a new transaction similar to transfers
||                       Use TransferDate for the dates of the transfers if not null, else use expense/work dates
||                       Currently we pass transfer date = null but we can change that later
|| 02/27/15  GHL 10589   When calling spProcessTranTransferTI etc..., pass TransferDate vs Expensedate
*/

Declare @Closed tinyint
Declare @ProjectKey int
Declare @TaskKey int
Declare @WIPPostingOutKey int
Declare @ExpenseDate smalldatetime -- or WorkDate for time entries
Declare @UndoWOAfterWIP int
Declare @IOClientLink int
Declare @BCClientLink int
Declare @TransferComment varchar(500)
Declare @AdjustmentType int 
Declare @TimeKey uniqueidentifier
Declare @TranKey int
Declare @RetVal int

select @UndoWOAfterWIP = isnull(UndoWOAfterWIP, 0)
      ,@IOClientLink = isnull(IOClientLink, 0)
	  ,@BCClientLink = isnull(BCClientLink, 0)
from   tPreference (nolock)
where  CompanyKey = @CompanyKey

Declare @kErrProjectClosed int			select @kErrProjectClosed = -2
Declare @kErrTime int					select @kErrTime = -1
Declare @kErrMC int						select @kErrMC = -3
Declare @kErrVI int						select @kErrVI = -4
Declare @kErrER int						select @kErrER = -5
Declare @kErrCannotUndo int				select @kErrCannotUndo = -6
Declare @kErrXferBase int				select @kErrXferBase = -10

	if @WOType = 'LABOR'
	Begin
		Select @ProjectKey = ProjectKey 
		      ,@TaskKey = TaskKey
		      ,@WIPPostingOutKey = WIPPostingOutKey 
			  ,@ExpenseDate = WorkDate
		from tTime (nolock) 
		where tTime.TimeKey = cast(@EntityKey as uniqueidentifier)		
	end
	else if @WOType = 'EXPRPT'
	Begin
		Select @ProjectKey = ProjectKey 
		      ,@TaskKey = TaskKey
			  ,@WIPPostingOutKey = WIPPostingOutKey 
			  ,@ExpenseDate = ExpenseDate
		from tExpenseReceipt (nolock) 
		where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer)
	end
	else if @WOType = 'MISCCOST'
	Begin
		Select @ProjectKey = ProjectKey 
		      ,@TaskKey = TaskKey
			  ,@WIPPostingOutKey = WIPPostingOutKey
			  ,@ExpenseDate = ExpenseDate 
		from tMiscCost (nolock) 
		where tMiscCost.MiscCostKey = cast(@EntityKey as integer)
	end
	else if @WOType = 'VOUCHER'
	Begin
		Select @ProjectKey = vd.ProjectKey 
		      ,@TaskKey = vd.TaskKey
			  ,@WIPPostingOutKey = vd.WIPPostingOutKey
			  ,@ExpenseDate = v.InvoiceDate 
		from tVoucherDetail vd (nolock)
			inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey 
		where vd.VoucherDetailKey = cast(@EntityKey as integer)
	end

	Select @ProjectKey = isnull(@ProjectKey, 0) 
	      ,@WIPPostingOutKey = isnull(@WIPPostingOutKey, 0) 
	
	-- if we cannot undo WO after WIP, abort now
	if @WIPPostingOutKey <> 0 And @UndoWOAfterWIP = 0
		return @kErrCannotUndo

	-- check if project is closed
	if @ProjectKey > 0
	begin
		Select @Closed = Closed from tProject (nolock) Where ProjectKey = @ProjectKey 
		if @Closed = 1
			return @kErrProjectClosed
	end

	-- process the transaction now if not posted to WIP
	if @WIPPostingOutKey = 0
	begin
		if @WOType = 'LABOR'
		Begin
			update tTime
			   set WriteOff = 0
			   ,DateBilled = NULL
			   ,WriteOffReasonKey = null
			 where tTime.TimeKey = cast(@EntityKey as uniqueidentifier) and ISNULL(WIPPostingOutKey, 0) = 0 
			if @@ERROR <> 0 
			  begin
				return @kErrTime					   	
			  end
		end
		else if @WOType = 'EXPRPT'
		Begin
			update tExpenseReceipt
			   set WriteOff = 0
			   ,DateBilled = NULL
			   ,WriteOffReasonKey = null
			 where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
 			if @@ERROR <> 0 
			  begin
				return @kErrER					   	
			  end
		end	
		--misc expenses
		else if @WOType = 'MISCCOST'
		Begin
			update tMiscCost
			   set WriteOff = 0
			   ,DateBilled = NULL
			   ,WriteOffReasonKey = null
			where tMiscCost.MiscCostKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
			if @@ERROR <> 0 
			  begin
				return @kErrMC					   	
			  end
		end
		--voucher	   
		else if @WOType = 'VOUCHER'
		Begin
			update tVoucherDetail
			   set WriteOff = 0
			   ,DateBilled = NULL
			   ,WriteOffReasonKey = null
			 where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
			if @@ERROR <> 0 
			  begin
				return @kErrVI					   	
			  end
		end

		-- and terminate now with success
		return 1
	end

	-- If we came that far, we know that it was posted to WIP @WIPPostingOutKey <> 0, we must do a transfer
	-- set Transfer data

	if @TransferDate is null
		select @TransferDate = @ExpenseDate

	select @TransferComment = 'Adjustment from undoing Writeoff after posting to WIP'

	select @AdjustmentType = 3 -- see other types in spProcessTranTransferTI

	if @WOType = 'LABOR'
	Begin
		Declare @TransferToKey uniqueidentifier

		select @TimeKey = cast(@EntityKey as uniqueidentifier)
				
		exec @RetVal = spProcessTranTransferTI @TimeKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment, @TransferComment, Null, @AdjustmentType, @TransferToKey output  
	
		if @RetVal < 0
			return @kErrXferBase + @RetVal
		else
			return @RetVal
	end
	
	--expenses	   
	else if @WOType = 'EXPRPT'
	Begin
		select @TranKey = cast(@EntityKey as integer)
		
		exec @RetVal = spProcessTranTransferER @TranKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment, @TransferComment, @AdjustmentType  
	
		if @RetVal < 0
			return @kErrXferBase + @RetVal
		else
			return @RetVal
	end
	
	--misc expenses
	else if @WOType = 'MISCCOST'
	Begin
		select @TranKey = cast(@EntityKey as integer)
		
		exec @RetVal = spProcessTranTransferMC @TranKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment, @TransferComment, @AdjustmentType  
	
		if @RetVal < 0
			return @kErrXferBase + @RetVal
		else
			return @RetVal
	end
	
	--voucher	   
	else if @WOType = 'VOUCHER'
	Begin
		select @TranKey = cast(@EntityKey as integer)
		
		exec @RetVal = spProcessTranTransferMC @TranKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment, @TransferComment, @IOClientLink, @BCClientLink, @AdjustmentType  
	
		if @RetVal < 0
			return @kErrXferBase + @RetVal
		else
			return @RetVal
	end
	
	return 1
GO
