USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingProcessWorksheet]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingProcessWorksheet]

	 @BillingKey int
	,@UserKey int
	,@WriteOffReasonKey int
	,@BillPercentage decimal(15,8)
	,@PostingDate smalldatetime = Null 
	,@ToProjectKey int
	,@ToTaskKey int
	,@EditComments varchar(2000)
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/19/07 GHL 8.5   Added collate default when comparing 2 entities 
  || 06/06/08 GHL 8.512 (27863) During transfers, check if project is non billable and determine if we can Xfer
  || 10/27/08 GHL 10.011 (38810) Multiply Total by Percentage for Action = Bill 
  ||                     Instead of calculating the Total to Bill as Quantity * Rate * Percentage.
  ||                     This is a problem when Quantity = 0
  ||                     Users complain that the gross is disappearing
  || 07/02/09 GHL 10.052 (56304) Do not 'Mark As Billed' POs 
  || 11/05/09 GHL 10.513 Added setting of AsOfDate for transfers + changed logic of WOs for transfers
  || 12/01/09 GHL 10.514 Commented out optional new transfers. They are now the general rule.   
  */
  
-- Assume done in calling sp or web page
-- create table #tProcBillingKeys (EntityType varchar(20), EntityKey varchar(50), Action int, BillingDetailKey int null)

	DECLARE	@TimeActive int
			,@ExpenseActive int
			,@NonBillable int
			,@ValidateTransfers int
			,@NewTransfers int
			,@CompanyKey int 
			,@MultiCurrency int
			,@CurrencyID varchar(10)
			,@ToCurrencyID varchar(10)
			,@ProjectKey int
					
	SELECT 	@TimeActive = TimeActive
			,@ExpenseActive = ExpenseActive
			,@NonBillable = NonBillable
			,@ToCurrencyID = isnull(p.CurrencyID, '')
	FROM    tProject p (NOLOCK)
			INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE   p.ProjectKey = @ToProjectKey
	
	SELECT  @TimeActive = ISNULL(@TimeActive, 1)
			,@ExpenseActive = ISNULL(@ExpenseActive, 1)
	
	SELECT @CompanyKey = CompanyKey
	      ,@ProjectKey = ProjectKey 
	from tBilling (nolock) where BillingKey = @BillingKey
	
	SELECT @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock)  where CompanyKey = @CompanyKey

	Select @CurrencyID = isnull(CurrencyID, '') from tProject (nolock) where ProjectKey = @ProjectKey

	IF EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE Action = 5)
		SELECT @ValidateTransfers = 1
	ELSE
		SELECT @ValidateTransfers = 0
	

	IF @ValidateTransfers = 1
	BEGIN
		IF @TimeActive = 0 AND EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE Entity = 'tTime' AND Action = 5)
			RETURN -1
			
		IF @ExpenseActive = 0 AND EXISTS (SELECT 1 FROM #tProcBillingKeys WHERE Entity <> 'tTime' AND Action = 5)
			RETURN -2

		IF @MultiCurrency = 1 And @CurrencyID <> @ToCurrencyID
			RETURN -6

		select @NewTransfers = 1
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
			
		
		IF @NewTransfers = 0
		BEGIN
			-- we cannot do the WIP adjustment if the new project is not billable 
			-- same validation as spProcessTranTransfer and spGLPostWIPAdjustment

			IF @NonBillable = 1
			BEGIN
				IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
								INNER JOIN tTime t (nolock) ON a.EntityKey = t.TimeKey 
							WHERE a.Entity = 'tTime' 
							AND a.Action = 5
							AND t.WIPPostingInKey <> 0
							AND t.WIPPostingOutKey = 0
							)
							RETURN -3
							
				IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
								INNER JOIN tMiscCost t (nolock) ON a.EntityKey = t.MiscCostKey 
							WHERE a.Entity = 'tMiscCost' 
							AND a.Action = 5
							AND t.WIPPostingInKey <> 0
							AND t.WIPPostingOutKey = 0
							)
							RETURN -3
							
				IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
								INNER JOIN tExpenseReceipt t (nolock) ON a.EntityKey = t.ExpenseReceiptKey 
							WHERE a.Entity = 'tExpenseReceipt' 
							AND a.Action = 5
							AND t.WIPPostingInKey <> 0
							AND t.WIPPostingOutKey = 0
							)
							RETURN -3						
				
				IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
								INNER JOIN tVoucherDetail t (nolock) ON a.EntityKey = t.VoucherDetailKey 
							WHERE a.Entity = 'tVoucherDetail' 
							AND a.Action = 5
							AND t.WIPPostingInKey <> 0
							AND t.WIPPostingOutKey = 0
							)
							RETURN -3		
			END
			
			-- no MB and WOK <> 0
			
			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tTime t (nolock) ON a.EntityKey = t.TimeKey 
					WHERE a.Entity = 'tTime' 
					AND a.Action = 5
					AND t.WIPPostingOutKey <> 0
					AND t.InvoiceLineKey = 0
					)
					RETURN -4

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tMiscCost t (nolock) ON a.EntityKey = t.MiscCostKey 
					WHERE a.Entity = 'tMiscCost' 
					AND a.Action = 5
					AND t.WIPPostingOutKey <> 0
					AND t.InvoiceLineKey = 0
					)
					RETURN -4

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tExpenseReceipt t (nolock) ON a.EntityKey = t.ExpenseReceiptKey 
					WHERE a.Entity = 'tExpenseReceipt' 
					AND a.Action = 5
					AND t.WIPPostingOutKey <> 0
					AND t.InvoiceLineKey = 0
					)
					RETURN -4			
		
			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
					INNER JOIN tVoucherDetail t (nolock) ON a.EntityKey = t.VoucherDetailKey 
					WHERE a.Entity = 'tVoucherDetail' 
					AND a.Action = 5
					AND t.WIPPostingOutKey <> 0
					AND t.InvoiceLineKey = 0
					)
					RETURN -4			

			-- no WO
			
			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tTime t (nolock) ON a.EntityKey = t.TimeKey 
					WHERE a.Entity = 'tTime' 
					AND a.Action = 5
					AND t.WriteOff = 1
					)
					RETURN -5

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tMiscCost t (nolock) ON a.EntityKey = t.MiscCostKey 
					WHERE a.Entity = 'tMiscCost' 
					AND a.Action = 5
					AND t.WriteOff = 1
					)
					RETURN -5

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tExpenseReceipt t (nolock) ON a.EntityKey = t.ExpenseReceiptKey 
					WHERE a.Entity = 'tExpenseReceipt' 
					AND a.Action = 5
					AND t.WriteOff = 1
					)
					RETURN -5			
		
			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
					INNER JOIN tVoucherDetail t (nolock) ON a.EntityKey = t.VoucherDetailKey 
					WHERE a.Entity = 'tVoucherDetail' 
					AND a.Action = 5
					AND t.WriteOff = 1
					)
					RETURN -5			

		END -- Old Transfers
		
		IF @NewTransfers = 1
		BEGIN
			-- same validation as spProcessTranTransfers

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
								INNER JOIN tTime t (nolock) ON a.EntityKey = t.TimeKey 
							WHERE a.Entity = 'tTime' 
							AND a.Action = 5
							AND t.WriteOff = 1
							AND t.WIPPostingOutKey <> 0
							)
							RETURN -5

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tMiscCost t (nolock) ON a.EntityKey = t.MiscCostKey 
					WHERE a.Entity = 'tMiscCost' 
					AND a.Action = 5
					AND t.WriteOff = 1
					AND t.WIPPostingOutKey <> 0
					)
					RETURN -5

			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
						INNER JOIN tExpenseReceipt t (nolock) ON a.EntityKey = t.ExpenseReceiptKey 
					WHERE a.Entity = 'tExpenseReceipt' 
					AND a.Action = 5
					AND t.WriteOff = 1
					AND t.WIPPostingOutKey <> 0
					)
					RETURN -5			
		
			IF EXISTS (SELECT 1 FROM #tProcBillingKeys a
					INNER JOIN tVoucherDetail t (nolock) ON a.EntityKey = t.VoucherDetailKey 
					WHERE a.Entity = 'tVoucherDetail' 
					AND a.Action = 5
					AND t.WriteOff = 1
					AND t.WIPPostingOutKey <> 0
					)
					RETURN -5			

		END
		
				

	END -- validate Xfers
	
	-- process Write Off = 0
	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
	  from #tProcBillingKeys t
	 where t.Action = 0
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	  and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey	      
	  from #tProcBillingKeys t
	 where t.Action = 0
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	   
	   
	   	-- process Bill = 1
	update tBillingDetail
	   set TMPercentage = @BillPercentage
	      ,Action = t.Action
	      ,Rate = round(Rate * @BillPercentage,3)
	      ,Total = round(Total * @BillPercentage,2)
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 1
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set TMPercentage = @BillPercentage
	      ,Action = t.Action
	      ,Rate = round(Rate * @BillPercentage,3)
	      ,Total = round(Quantity * round(Rate * @BillPercentage,3),2)
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 1
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'

 
	-- process Mark As Billed = 2
	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 2
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'
	   and t.Entity <> 'tPurchaseOrderDetail'


	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 2
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	    

	-- process Mark as On Hold = 3
	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 3
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 3
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	   
	   
	-- process Mark On Hold as Billable = 4
	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 4
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 4
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	   
	   
	-- process Transfer Costs = 5
	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,TransferProjectKey = @ToProjectKey
	      ,TransferTaskKey = @ToTaskKey
	      ,Action = t.Action
		  ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
  from #tProcBillingKeys t
	 where t.Action = 5
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set AsOfDate = @PostingDate
	      ,TransferProjectKey = @ToProjectKey
	      ,TransferTaskKey = @ToTaskKey
	      ,Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 5
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	    	    
	    
	-- process Remove = 6
	delete tBillingDetail
	  from #tProcBillingKeys t
	 where t.Action = 6
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	delete tBillingDetail
	  from #tProcBillingKeys t
	 where t.Action = 6
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'

	-- process Do not Bill = 7
	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 7
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityKey = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity <> 'tTime'

	update tBillingDetail
	   set Action = t.Action
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey	      
		  ,WriteOffReasonKey = null	      
	  from #tProcBillingKeys t
	 where t.Action = 7
	   and tBillingDetail.BillingKey = @BillingKey	
	   and tBillingDetail.EntityGuid = t.EntityKey
	   and tBillingDetail.Entity = t.Entity COLLATE DATABASE_DEFAULT 
	   and t.Entity = 'tTime'
	
	exec sptBillingRecalcTotals @BillingKey	
	
	return 1
GO
