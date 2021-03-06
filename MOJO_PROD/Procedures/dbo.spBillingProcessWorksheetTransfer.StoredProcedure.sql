USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingProcessWorksheetTransfer]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingProcessWorksheetTransfer]

	 @BillingKey int
	,@UserKey int
	,@ToProjectKey int
	,@ToTaskKey int
	,@TransferDate smalldatetime
	,@EditComments varchar(2000)
	
AS --Encrypt

-- This is an immediate transfer by opposition to a regular 2-step (edit/billing) transfer done in following sps
-- spBillingProcessWorksheet
-- spBillingProcessNoInvoice

  /*
  || When     Who Rel   What
  || 08/04/06 GHL 8.35  Added use of @CheckBillingDetail var so that we can still perform 
  ||                    immediate transfers from one billing worksheet to another
  || 02/20/07 GHL 8.403 Added project rollup section
  || 08/14/07 GHL 8.5   Using now new transfer sp for vouchers
  || 10/19/07 GHL 8.5   Added COLLATE DATABASE_DEFAULT when comparing 2 entities	
  || 07/17/08 GHL 8.516 (30265) When transferring to a new project, reset the client on the voucher line 
  || 09/10/09 GHL 10.5  Added support of new transfers 
  || 11/05/09 GHL 10.513 After a new transfer, update the new EntityKey and EntityGuid in tBillingDetail
  || 12/01/09 GHL 10.514 Commented out optional new transfers. They are now the general rule.     
  || 06/04/10 GHL 10.530  (82255) Added TransferComment to capture comment from the billing worksheet
  || 03/08/11 GHL 10.542  (105027) Added update of transfer info in tProjectRollup
  || 09/26/13 WDF 10.573  (188654) Passed UserKey to spProcessTranTransfer and spProcessTranTransfers
  */

-- Assume done in calling sp or web page
-- create table #tProcBillingKeys (Entity varchar(20), EntityKey varchar(50), Action int, BillingDetailKey int null) OR

	declare @NewTransfers int   select @NewTransfers = 1
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
		  	
	DECLARE @ToBillingKey int
			,@CompanyKey int
			,@TimeActive int
			,@ExpenseActive int
			,@TransferComment varchar(400) -- 400 because limited to 500 in transactions and we need to add some extra comments

	select @EditComments = isnull(@EditComments, '')

	SELECT 	@TimeActive = TimeActive
			,@ExpenseActive = ExpenseActive
	FROM    tProject p (NOLOCK)
			INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE   p.ProjectKey = @ToProjectKey
	
	SELECT  @TimeActive = ISNULL(@TimeActive, 1)
			,@ExpenseActive = ISNULL(@ExpenseActive, 1)
	
	IF @TimeActive = 0 AND EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE Entity = 'tTime' AND Action = 5)
		RETURN -1
		
	IF @ExpenseActive = 0 AND EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE Entity <> 'tTime' AND Action = 5)
		RETURN -2
			
	SELECT @CompanyKey = CompanyKey
	FROM   tUser (nolock)
	WHERE  UserKey = @UserKey

	-- update the BillingDetailKey
	UPDATE #tProcBillingKeys
	SET    #tProcBillingKeys.BillingDetailKey = bd.BillingDetailKey
	FROM   #tProcBillingKeys t
		INNER JOIN tBillingDetail bd (NOLOCK) 
			ON  CAST(bd.EntityKey AS VARCHAR(50)) = t.EntityKey
	WHERE  t.Action = 5
	AND    bd.BillingKey = @BillingKey
	AND    bd.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	AND    t.Entity <> 'tTime'

	UPDATE #tProcBillingKeys
	SET    #tProcBillingKeys.BillingDetailKey = bd.BillingDetailKey
	FROM   #tProcBillingKeys t
		INNER JOIN tBillingDetail bd (NOLOCK) 
			ON  CAST(bd.EntityGuid AS VARCHAR(50)) = t.EntityKey
	WHERE  t.Action = 5
	AND    bd.BillingKey = @BillingKey
	AND    bd.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	AND    t.Entity = 'tTime'
	
	-- Perform immediate transfer
	Declare @CurKey int
			,@TranType varchar(8)
			,@TranKey varchar(100)
			,@CheckBillingDetail int
			,@ErrorNumber int
	        ,@EntityGuid varchar(50)
	        ,@EntityKey int
	        ,@TransferToEntityGuid varchar(50)
	        ,@TransferToEntityKey int
	        
	Select @CurKey = -1
	While 1 = 1
	BEGIN
		If @NewTransfers = 0
		    -- Old transfers, separate process for voucher and other trans
			Select @CurKey = MIN(BillingDetailKey) 
			from   #tProcBillingKeys (nolock) 
			Where  BillingDetailKey > @CurKey 
			and    Entity <> 'tVoucherDetail'
			and    Action = 5	
		Else
			-- New transfers, same process for all
			Select @CurKey = MIN(BillingDetailKey) 
			from   #tProcBillingKeys (nolock) 
			Where  BillingDetailKey > @CurKey 
			and    Action = 5
			
		if @CurKey is null
			Break
			
		Select @TranType = Case Entity When 'tTime' then 'LABOR'
									When 'tMiscCost' then 'MISCCOST'
									When 'tExpenseReceipt' then 'EXPRPT'
									When 'tVoucherDetail' Then 'VOUCHER'
									When 'tPurchaseOrderDetail' then 'ORDER' end
			,@TranKey = Cast(EntityKey as varchar(100)) -- Even for tTime
			,@EntityGuid = Case Entity When 'tTime' then Cast(EntityKey as uniqueidentifier) else null end
			,@EntityKey = Case Entity When 'tTime' then null else Cast(EntityKey as int) end
		From #tProcBillingKeys Where BillingDetailKey = @CurKey
						
		-- Specify to not check billing detail since we are moving 
		-- from one billing worksheet to another  
		SELECT @CheckBillingDetail = 0
		
		If @NewTransfers = 0				
			-- Use the transfer sp to make sure the transfer comment gets on the transaction
			exec @ErrorNumber = spProcessTranTransfer @UserKey, @ToProjectKey, @ToTaskKey, @TranType, @TranKey, @CheckBillingDetail
		Else
		Begin

			if len(@EditComments) > 0
				select @TransferComment = left(@EditComments, 400)
			else
				select @TransferComment = null

			exec @ErrorNumber = spProcessTranTransfers @UserKey, @ToProjectKey, @ToTaskKey , @TranType, @TranKey, @TransferDate, @CheckBillingDetail, @TransferComment
		
			-- During this new transfer, a new transaction has been created
			-- Capture now the TransferToKey so that it can be updated in tBillingDetail
			
			-- If success 
			If @ErrorNumber = 1
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
		
		-- ErrorNumber = 1 if success, <0 if error	
		UPDATE	#tProcBillingKeys 
		SET		ErrorNumber = @ErrorNumber
		WHERE	BillingDetailKey = @CurKey
		
	END

	If @NewTransfers = 0
	Begin
	
		-- To be used by spProcessTranTransferVoucher	
		CREATE TABLE #tTransfer
			(
			VoucherDetailKey INT null
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

		INSERT #tTransfer (VoucherDetailKey)
		SELECT EntityKey FROM #tProcBillingKeys (nolock) Where Entity = 'tVoucherDetail' and Action = 5
		
		-- Will set error number in temp table
		EXEC spProcessTranTransferVoucher @UserKey, @CompanyKey, @ToProjectKey ,@ToTaskKey,@CheckBillingDetail
		
		UPDATE	#tProcBillingKeys 
		SET		#tProcBillingKeys.ErrorNumber = #tTransfer.ErrorNum
		FROM    #tTransfer 
		WHERE	#tTransfer.VoucherDetailKey = #tProcBillingKeys.EntityKey
		AND    	#tProcBillingKeys.Entity = 'tVoucherDetail'
		
		--select * from #tProcBillingKeys
	End
				
	-- Delete it from this worksheet			
	-- Or try to tie them to another billing worksheet
	SELECT @ToBillingKey = BillingKey
	FROM   tBilling (nolock)
	WHERE  CompanyKey = @CompanyKey
	AND    ISNULL(ProjectKey, 0) = @ToProjectKey
	AND    Status < 4 -- Less than approved	
	AND    AdvanceBill = 0
	
	IF @ToBillingKey IS NULL
	BEGIN
		DELETE tBillingDetail
		FROM   #tProcBillingKeys t
		WHERE  tBillingDetail.BillingDetailKey = t.BillingDetailKey
		AND    t.Action = 5
		AND	   t.ErrorNumber = 1 -- Xfer was successful
	END
	ELSE
	BEGIN
		-- Move them to a new Billing Worksheet with Action = Bill
		UPDATE tBillingDetail
		SET    tBillingDetail.BillingKey = @ToBillingKey
			  ,tBillingDetail.EditorKey = @UserKey
			  ,tBillingDetail.EditComments = @EditComments
			  ,tBillingDetail.Action = 1	
		FROM   #tProcBillingKeys t
		WHERE  t.Action = 5
		AND	   t.ErrorNumber = 1 -- Xfer was successful
		AND    tBillingDetail.BillingKey = @BillingKey
		AND	   tBillingDetail.BillingDetailKey = t.BillingDetailKey

		exec sptBillingRecalcTotals @ToBillingKey	
	
	END
	
	exec sptBillingRecalcTotals @BillingKey	

	-- Perform project rollup on 2 projects
	
	DECLARE @FromProjectKey INT
	SELECT @FromProjectKey = ProjectKey FROM tBilling (NOLOCK) WHERE BillingKey = @BillingKey
	
	EXEC sptProjectRollupUpdate @FromProjectKey, -1, 1, 1, 1, 1
	EXEC sptProjectRollupUpdate @ToProjectKey, -1, 1, 1, 1, 1

	EXEC sptProjectRollupUpdateTransferInfo @FromProjectKey
	EXEC sptProjectRollupUpdateTransferInfo @ToProjectKey
	
	IF EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE ErrorNumber <> 1)
		return -3
	else
		return 1
GO
