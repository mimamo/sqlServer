USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingProcessNoInvoice]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingProcessNoInvoice]
	(
	@BillingKey int
   ,@UserKey int
	)

AS -- Encrypt

	SET NOCOUNT ON

	-- Process Action which do not require invoices
	--    Write Off 0
	--    Mark as Billed 2
	--    Mark On Hold 3
	--    Undo Mark On Hold  4
	--    Transfers 5
	--    Remove 6
	
	-- And cleanup records for Action 1 = To Bill since WO, On Hold, Mark as Billed
	-- can be pulled in again with Action =1 after Unapprove

  /*
  || When     Who Rel   What
  || 08/04/06 GHL 8.35  Added use of @CheckBillingDetail var so that we can still perform 
  ||                    transfers when tran is on a billing worksheet 
  || 01/25/07 GHL 8.402 Changed DateBilled for 'Mark As Billed' to tBillingDetail.AsOfDate. Bug 8027
  || 02/20/07 GHL 8.403 Added project rollup section
  || 08/14/07 GHL 8.5   Using now new transfer sp for vouchers  
  || 07/17/08 GHL 8.516 (30265) When transferring to a new project, reset the client on the voucher line 
  || 09/10/09 GHL 10.5  Added support of new transfers 
  || 11/05/09 GHL 10.513 After a new transfer, update the new EntityKey and EntityGuid in tBillingDetail
  || 11/05/09 GHL 10.513 Added TransferDate when calling transfer stored proc
  || 12/01/09 GHL 10.514 Commented out optional new transfers. They are now the general rule. 
  || 03/08/11 GHL 10.542  (105027) Added update of transfer info in tProjectRollup
  || 09/26/13 WDF 10.573 (188654) Added UserKey
 */

	declare @NewTransfers int	select @NewTransfers = 1
	/*
	if exists (select 1 
			from tBilling b (nolock)
			inner join tPreference pref (nolock) on b.CompanyKey = pref.CompanyKey
		where b.BillingKey = @BillingKey
		and lower(pref.Customizations) like '%newtransfers%'
		) 
		select @NewTransfers = 1
	else
		select @NewTransfers = 0
	*/
	
	declare @ProcessDate smalldatetime
	select @ProcessDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)

	declare @DefaultAsOfDate smalldatetime
	select @DefaultAsOfDate = DefaultAsOfDate from tBilling (nolock) where BillingKey = @BillingKey
	if @DefaultAsOfDate is not null
	begin
		select @DefaultAsOfDate = cast(cast(DATEPART(m,@DefaultAsOfDate) as varchar(5))+'/'+cast(DATEPART(d,@DefaultAsOfDate) as varchar(5))+'/'+cast(DATEPART(yy,@DefaultAsOfDate)as varchar(5)) as smalldatetime)
		select @ProcessDate = @DefaultAsOfDate
	end

	-- do To Bill
	-- Reverse possible following conditions:  On Hold, Writen Off, Mark As Billed	

	--time
		update tTime
	   set BilledHours = 0					-- Not Mark As Billed 
	      ,BilledRate = 0
	      ,DateBilled = NULL
		  ,InvoiceLineKey = NULL	
	      ,WriteOff = 0						-- Not Written Off	
	      ,tTime.WriteOffReasonKey = NULL
		  ,OnHold = 0						-- Not on Hold				
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tTime'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tTime.TimeKey = tBillingDetail.EntityGuid
	   and tBillingDetail.Action = 1
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	
	--expenses	   
	update tExpenseReceipt
	   set AmountBilled = 0				-- Not Mark as Billed
	      ,DateBilled = NULL
	      ,InvoiceLineKey = NULL
	      ,WriteOff = 0					-- Not Written Off
	      ,tExpenseReceipt.WriteOffReasonKey = NULL
	      ,OnHold = 0					-- Not on Hold
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tExpenseReceipt'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tExpenseReceipt.ExpenseReceiptKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 1
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	
	--misc expenses
	update tMiscCost
	   set AmountBilled = 0				-- Not Mark as Billed
	      ,DateBilled = NULL
	      ,InvoiceLineKey = NULL
	      ,WriteOff = 0					-- Not Written Off
	      ,tMiscCost.WriteOffReasonKey = NULL
	      ,OnHold = 0					-- Not on Hold
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tMiscCost'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tMiscCost.MiscCostKey = tBillingDetail.EntityKey 
	   and tBillingDetail.Action = 1
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	
	--voucher	   
	update tVoucherDetail
	   set AmountBilled = 0				-- Not Mark as Billed
	      ,DateBilled = NULL
	      ,InvoiceLineKey = NULL
	      ,WriteOff = 0					-- Not Written Off
	      ,tVoucherDetail.WriteOffReasonKey = NULL
	      ,OnHold = 0					-- Not on Hold
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tVoucherDetail'
	   and tBillingDetail.BillingKey = @BillingKey
       and tVoucherDetail.VoucherDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 1
	if @@ERROR <> 0 
	 begin
		return -4					   	
	  end
	
	--po	   
	update tPurchaseOrderDetail
	   set AmountBilled = 0				-- Not Mark as Billed
	      ,DateBilled = NULL
	      ,InvoiceLineKey = NULL
	      ,OnHold = 0					-- Not on Hold
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tPurchaseOrderDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tPurchaseOrderDetail.PurchaseOrderDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 1
	if @@ERROR <> 0 
	  begin
		return -5					   	
	  end
	  
	-- do write-offs ***************************************************************************************************************
	--time

		update tTime
	   set WriteOff = 1
	      ,BilledHours = 0
	      ,BilledRate = 0
	      ,tTime.WriteOffReasonKey = tBillingDetail.WriteOffReasonKey
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tTime'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tTime.TimeKey = tBillingDetail.EntityGuid
	   and tBillingDetail.Action = 0
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,tExpenseReceipt.WriteOffReasonKey = tBillingDetail.WriteOffReasonKey
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tExpenseReceipt'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tExpenseReceipt.ExpenseReceiptKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 0
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,tMiscCost.WriteOffReasonKey = tBillingDetail.WriteOffReasonKey
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tMiscCost'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tMiscCost.MiscCostKey = tBillingDetail.EntityKey 
	   and tBillingDetail.Action = 0
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,tVoucherDetail.WriteOffReasonKey = tBillingDetail.WriteOffReasonKey
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tVoucherDetail'
	   and tBillingDetail.BillingKey = @BillingKey
       and tVoucherDetail.VoucherDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 0
	if @@ERROR <> 0 
	 begin
		return -4					   	
	  end
	 
	--do Mark Billed ***************************************************************************************************************
	--time
	update tTime
	   set WriteOff = 0
		   ,BilledHours = tTime.ActualHours
		   ,BilledRate = tTime.ActualRate
	      ,InvoiceLineKey = 0
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tTime'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tTime.TimeKey = tBillingDetail.EntityGuid
	   and tBillingDetail.Action = 2
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tExpenseReceipt'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tExpenseReceipt.ExpenseReceiptKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 2
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tMiscCost'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tMiscCost.MiscCostKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 2
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = ISNULL(tBillingDetail.AsOfDate, @ProcessDate)
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tVoucherDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tVoucherDetail.VoucherDetailKey = tBillingDetail.EntityKey 
	 and tBillingDetail.Action = 2
	if @@ERROR <> 0 
	  begin
		return -4					 	
	  end
	  	
	-- End of Mark AS Billed Section *********************************************************************
	
	--do Mark On Hold ***************************************************************************************************************
	--time
	update tTime
	   set OnHold = 1
	from tBillingDetail
	 where tBillingDetail.Entity = 'tTime'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tTime.TimeKey = tBillingDetail.EntityGuid 
	   and tBillingDetail.Action = 3
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set OnHold = 1
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tExpenseReceipt'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tExpenseReceipt.ExpenseReceiptKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 3
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set OnHold = 1
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tMiscCost'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tMiscCost.MiscCostKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 3
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set OnHold = 1
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tVoucherDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tVoucherDetail.VoucherDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 3
	if @@ERROR <> 0 
	  begin
		return -4					   	
	  end

	--po	   
	update tPurchaseOrderDetail
	   set OnHold = 1
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tPurchaseOrderDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tPurchaseOrderDetail.PurchaseOrderDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 3
	if @@ERROR <> 0 
	  begin
		return -5					   	
	  end

	--Undo Mark On Hold ***************************************************************************************************************
	--time
	update tTime
	   set OnHold = 0
	from tBillingDetail
	 where tBillingDetail.Entity = 'tTime'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tTime.TimeKey = tBillingDetail.EntityGuid
	   and tBillingDetail.Action = 4
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set OnHold = 0
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tExpenseReceipt'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tExpenseReceipt.ExpenseReceiptKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 4
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set OnHold = 0
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tMiscCost'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tMiscCost.MiscCostKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 4
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set OnHold = 0
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tVoucherDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tVoucherDetail.VoucherDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 4
	if @@ERROR <> 0 
	  begin
		return -4					   	
	  end

	--po	   
	update tPurchaseOrderDetail
	   set OnHold = 0
	  from tBillingDetail
	 where tBillingDetail.Entity = 'tPurchaseOrderDetail'
	   and tBillingDetail.BillingKey = @BillingKey
	   and tPurchaseOrderDetail.PurchaseOrderDetailKey = tBillingDetail.EntityKey
	   and tBillingDetail.Action = 4
	if @@ERROR <> 0 
	  begin
		return -5					   	
	  end
	 
	--Transfer ***************************************************************************************************************
	Declare @CurKey int
		, @ToBillingKey int
		, @ToProjectKey int
		, @ToTaskKey int
		, @TranType varchar(8)
		, @TranKey varchar(100)
		, @CheckBillingDetail int
		, @RetVal int
		, @FromProjectKey int
		, @CompanyKey int
		, @EntityGuid varchar(50)
	    , @EntityKey int
	    , @TransferToEntityGuid varchar(50)
	    , @TransferToEntityKey int
	    , @TransferDate smalldatetime
	    , @TransferComment varchar(400)
		, @EditComments varchar(2000)
		    	
	CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
	 
	INSERT #ProjectRollup (ProjectKey)
	SELECT DISTINCT TransferProjectKey
	FROM   tBillingDetail (NOLOCK)
	WHERE  BillingKey = @BillingKey
	AND    TransferProjectKey IS NOT NULL
	AND    Action = 5
	  		
 	SELECT @FromProjectKey = ISNULL(ProjectKey, 0), @CompanyKey = CompanyKey 
	FROM   tBilling (NOLOCK)
	WHERE  BillingKey = @BillingKey
				
	SELECT @ToBillingKey = BillingKey
	FROM   tBilling (nolock)
	WHERE  CompanyKey = @CompanyKey
	AND    ISNULL(ProjectKey, 0) = @ToProjectKey
	AND    Status < 4 -- Less than approved	
	AND    AdvanceBill = 0

	Select @CurKey = -1
	While 1 = 1
	BEGIN
		If @NewTransfers = 0
			Select @CurKey = MIN(BillingDetailKey) from tBillingDetail (nolock) 
			Where BillingKey = @BillingKey and BillingDetailKey > @CurKey and Action = 5
			And   Entity <> 'tVoucherDetail'
		Else
			-- New Transfers = 1, process voucher details as well
			Select @CurKey = MIN(BillingDetailKey) from tBillingDetail (nolock) 
			Where BillingKey = @BillingKey and BillingDetailKey > @CurKey and Action = 5
		
		if @CurKey is null
			Break
			
		Select @ToProjectKey = TransferProjectKey, @ToTaskKey = TransferTaskKey
		,@TranType = Case Entity When 'tTime' then 'LABOR'
								When 'tMiscCost' then 'MISCCOST'
								When 'tExpenseReceipt' then 'EXPRPT'
								When 'tVoucherDetail' Then 'VOUCHER'
								When 'tPurchaseOrderDetail' then 'ORDER' end
		,@TranKey = Case Entity When 'tTime' then Cast(EntityGuid as varchar(100))
								When 'tMiscCost' then Cast(EntityKey as varchar(100))
								When 'tExpenseReceipt' then Cast(EntityKey as varchar(100))
								When 'tVoucherDetail' Then Cast(EntityKey as varchar(100))
								When 'tPurchaseOrderDetail' then Cast(EntityKey as varchar(100)) end
		,@EntityGuid = Case Entity When 'tTime' then EntityGuid else null end
		,@EntityKey = Case Entity When 'tTime' then null else EntityKey end
		,@TransferDate = AsOfDate
		,@EditComments = isnull(EditComments, '')
		From tBillingDetail (nolock) Where BillingDetailKey = @CurKey

		-- Enable transfer by telling spProcessTranTransfer not to check in tBillingDetail 
		Select @CheckBillingDetail = 0
					
		-- Use the transfer sp to make sure the transfer comment gets on the transaction
		If @NewTransfers = 0
			exec @RetVal = spProcessTranTransfer @UserKey, @ToProjectKey, @ToTaskKey, @TranType, @TranKey, @CheckBillingDetail
		Else
		Begin

			if len(@EditComments) > 0
				select @TransferComment = left(@EditComments, 400)
			else
				select @TransferComment = null

			exec @RetVal = spProcessTranTransfers @UserKey, @ToProjectKey, @ToTaskKey, @TranType, @TranKey, @TransferDate, @CheckBillingDetail, @TransferComment
		
			-- During this new transfer, a new transaction has been created
			-- Capture now the TransferToKey so that it can be updated in tBillingDetail

			-- If success 
			If @RetVal = 1
			Begin
				
				Select @TransferToEntityKey = null
				Select @TransferToEntityGuid = null
				
				If @TranType = 'LABOR'
					Select @TransferToEntityGuid = TransferToKey
					From   tTime (NOLOCK)
					Where  TimeKey = @EntityGuid
				Else If @TranType = 'MISCCOST'
					Select @TransferToEntityKey = TransferToKey
					From   tMiscCost (NOLOCK)
					Where  MiscCostKey = @EntityKey
				Else If @TranType = 'EXPRPT'
					Select @TransferToEntityKey = TransferToKey
					From   tExpenseReceipt (NOLOCK)
					Where  ExpenseReceiptKey = @EntityKey
				Else If @TranType = 'VOUCHER'
					Select @TransferToEntityKey = TransferToKey
					From   tVoucherDetail (NOLOCK)
					Where  VoucherDetailKey = @EntityKey
				Else If @TranType = 'ORDER'
					Select @TransferToEntityKey = TransferToKey
					From   tPurchaseOrderDetail (NOLOCK)
					Where  PurchaseOrderDetailKey = @EntityKey
				
				If isnull(@TransferToEntityKey, 0) > 0
					update tBillingDetail
					set    tBillingDetail.EntityKey = @TransferToEntityKey
					where  tBillingDetail.BillingKey = @BillingKey
					and    tBillingDetail.BillingDetailKey = @CurKey
					
				If @TransferToEntityGuid is not null
					update tBillingDetail
					set    tBillingDetail.EntityGuid = @TransferToEntityGuid
					where  tBillingDetail.BillingKey = @BillingKey
					and    tBillingDetail.BillingDetailKey = @CurKey	
					
					
			End
		End
		
		-- If Success, remove it, in case users approve and unapprove 
		-- In that case we would have a billing detail record with the wrong project
		-- causing problems during invoicing if they decide to bill
		If @RetVal = 1 AND @ToProjectKey <> @FromProjectKey
		BEGIN
			-- Delete it from this worksheet			
			
			IF @ToBillingKey IS NULL
			BEGIN
				DELETE tBillingDetail
				WHERE  BillingDetailKey = @CurKey
			END
			ELSE
			BEGIN
				-- Move it to a new Billing Worksheet with Action = Bill
				UPDATE tBillingDetail
				SET    tBillingDetail.BillingKey = @ToBillingKey
						,tBillingDetail.Action = 1	
				WHERE  tBillingDetail.BillingDetailKey = @CurKey
		
			END
		END
	END

	If @NewTransfers = 0
	Begin

		-- To be used by spProcessTranTransferVoucher	
		CREATE TABLE #tTransfer
			(
			BillingDetailKey INT NULL
			,VoucherDetailKey INT null
			,VoucherKey INT NULL
			,Status INT NULL
			,InvoiceLineKey INT NULL
			,WriteOff INT NULL
			,WIPPostingInKey INT NULL
			,WIPPostingOutKey INT NULL
			,OrigTransferComment VARCHAR(500) NULL
			,OrigProjectKey INT NULL
			,OrigProjectNumber varchar(50) NULL
			,OrigTaskID varchar(50) NULL
			,NewTransferComment VARCHAR(500) NULL
			,ClientKey INT NULL
			,ErrorNum INT NULL)

		
			INSERT #tTransfer (BillingDetailKey, VoucherDetailKey)
			SELECT BillingDetailKey, EntityKey FROM tBillingDetail (nolock) 
			Where BillingKey = @BillingKey
			And   Entity = 'tVoucherDetail' and Action = 5
			
			-- Will set error number in temp table, success = 1
			EXEC spProcessTranTransferVoucher @UserKey, @CompanyKey, @ToProjectKey ,@ToTaskKey,@CheckBillingDetail
		
		SELECT @CurKey = -1
		While 1 = 1
		BEGIN
			Select @CurKey = MIN(BillingDetailKey) from #tTransfer 
			Where ErrorNum = 1
			And   BillingDetailKey > @CurKey  
			
			if @CurKey is null
				Break
				
			IF @ToBillingKey IS NULL
			BEGIN
				DELETE tBillingDetail
				WHERE  BillingDetailKey = @CurKey
			END
			ELSE
			BEGIN
				-- Move it to a new Billing Worksheet with Action = Bill
				UPDATE tBillingDetail
				SET    tBillingDetail.BillingKey = @ToBillingKey
						,tBillingDetail.Action = 1	
				WHERE  tBillingDetail.BillingDetailKey = @CurKey		
			END	
				
		END	

	End -- If NewTransfers = 0

	IF @ToBillingKey IS NOT NULL
		exec sptBillingRecalcTotals @ToBillingKey	
			
	exec sptBillingRecalcTotals @BillingKey	

	-- Recalc everything on current project, TranType = All or -1	
	EXEC sptProjectRollupUpdate @FromProjectKey, -1, 1, 1, 1, 1
	EXEC sptProjectRollupUpdateTransferInfo @FromProjectKey
	
	-- Recalc everything on projects transferred to
	SELECT @ToProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ToProjectKey = MIN(ProjectKey)
		FROM   #ProjectRollup
		WHERE  ProjectKey > @ToProjectKey
		
		IF @ToProjectKey IS NULL
			BREAK
			
		-- Rollup project, TranType = All or -1	
		EXEC sptProjectRollupUpdate @ToProjectKey, -1, 1, 1, 1, 1
		EXEC sptProjectRollupUpdateTransferInfo @ToProjectKey
	
	END
		
	RETURN 1
GO
