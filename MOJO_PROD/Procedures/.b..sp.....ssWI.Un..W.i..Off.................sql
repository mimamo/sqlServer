USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPUndoWriteOff]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPUndoWriteOff]
	 @EntityKey VARCHAR(50)
	,@WOType VARCHAR(50)
AS --Encrypt

/*
|| When      Who Rel      What
|| 1/21/10   RLB 10517    (72812) will null out Write off Reason key when write offs are undone
|| 04/25/14  GHL 10579    (214165) Added protection for un-writing off transactions that have been posted out of wip
*/

--create table #tProcWIPKeys (EntityType varchar(20), EntityKey varchar(50), Action int)	
Declare @Closed tinyint
Declare @ProjectKey int

	--do write-offs
	--time
	if @WOType = 'LABOR'
	Begin
		Select @ProjectKey = ProjectKey from tTime (nolock) where tTime.TimeKey = cast(@EntityKey as uniqueidentifier)
		if @ProjectKey is not null
		begin
			Select @Closed = Closed from tProject (nolock) Where ProjectKey = @ProjectKey 
			if @Closed = 1
				return -2
		end
		
		update tTime
		   set WriteOff = 0
		   ,DateBilled = NULL
		   ,WriteOffReasonKey = null
		 where tTime.TimeKey = cast(@EntityKey as uniqueidentifier) and ISNULL(WIPPostingOutKey, 0) = 0 
		if @@ERROR <> 0 
		  begin
			return -1					   	
		  end
	end
	
	--expenses	   
	else if @WOType = 'EXPRPT'
	Begin
		Select @ProjectKey = ProjectKey from tExpenseReceipt (nolock) where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer)
		if @ProjectKey is not null
		begin
			Select @Closed = Closed from tProject (nolock) Where ProjectKey = @ProjectKey 
			if @Closed = 1
				return -2
		end
		
		update tExpenseReceipt
		   set WriteOff = 0
		   ,DateBilled = NULL
		   ,WriteOffReasonKey = null
		 where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
 		if @@ERROR <> 0 
		  begin
			return -2					   	
		  end
	end
	
	--misc expenses
	else if @WOType = 'MISCCOST'
	Begin
		Select @ProjectKey = ProjectKey from tMiscCost (nolock) where tMiscCost.MiscCostKey = cast(@EntityKey as integer)
		if @ProjectKey is not null
		begin
			Select @Closed = Closed from tProject (nolock) Where ProjectKey = @ProjectKey 
			if @Closed = 1
				return -2
		end
		
	update tMiscCost
	   set WriteOff = 0
	   ,DateBilled = NULL
	   ,WriteOffReasonKey = null
	where tMiscCost.MiscCostKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	end
	
	--voucher	   
	else if @WOType = 'VOUCHER'
	Begin
		Select @ProjectKey = ProjectKey from tVoucherDetail (nolock) where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer)
		if @ProjectKey is not null
		begin
			Select @Closed = Closed from tProject (nolock) Where ProjectKey = @ProjectKey 
			if @Closed = 1
				return -2
		end
		
		update tVoucherDetail
		   set WriteOff = 0
		   ,DateBilled = NULL
		   ,WriteOffReasonKey = null
		 where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0 
		if @@ERROR <> 0 
		  begin
			return -4					   	
		  end
	end
	
	return 1
GO
