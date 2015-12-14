USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPUndoMarkBilled]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPUndoMarkBilled]
	 @EntityKey VARCHAR(50)
	,@WOType VARCHAR(50)
	,@Rollup int = 0
AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/27/12 GWG 10.560 Added protection for unmarking as billed transactions that have been posted out of wip
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
			,BilledRate = 0
			,BilledHours = 0
			,InvoiceLineKey = NULL
			,DateBilled = NULL
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
		   ,InvoiceLineKey = NULL
		   ,DateBilled = NULL
		   ,AmountBilled = 0
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
		   ,InvoiceLineKey = NULL
		   ,DateBilled = NULL
		   ,AmountBilled = 0
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
		   ,InvoiceLineKey = NULL
		   ,DateBilled = NULL
		   ,AmountBilled = 0
		 where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer) and ISNULL(WIPPostingOutKey, 0) = 0
		if @@ERROR <> 0 
		  begin
			return -4					   	
		  end
	  	
	end
	
	DECLARE @RollupType INT
	IF @Rollup = 1
	BEGIN
		if @WOType = 'LABOR'
			SELECT 	@RollupType = 1
		if @WOType = 'EXPRPT'
			SELECT 	@RollupType = 3
		if @WOType = 'MISCCOST'			
			SELECT 	@RollupType = 2
		if @WOType = 'VOUCHER'
			SELECT 	@RollupType = 4
		EXEC sptProjectRollupUpdate @ProjectKey, @RollupType, 1, 1, 1, 1	
	END
	
	
	return 1
GO
