USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerTask]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerTask]
	(
	@NewInvoiceKey INT
	,@BillingKey INT
	,@BillingMethod INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@ParentInvoiceLineKey int
	,@PostSalesUsingDetail tinyint
	,@CampaignSegmentKey int = null
	)

AS

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 07/09/07 GHL 8.5	Added logic for office/department  
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description 
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465 
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments    
  || 05/12/10 GHL 10.523 Added segment param
  || 10/28/10 GHL 10.537 Put back description at KN's request
  || 12/17/10 GHL 10.539 (97621) Removed amount recalcs to improve performance 
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  || 03/20/15 GHL 10.591 (238426) Added logic for AllTrackBudgetTasks field from the client 
  ||                      if AllTrackBudgetTasks = 0, we only select tasks with time or expenses
  ||                      if AllTrackBudgetTasks = 1, we select all track budget task
  */

	SET NOCOUNT ON
	
declare @NewInvoiceLineKey int
declare @RetVal int
declare @TotLabor money
declare @TotExpenseRcpt money
declare @TotMiscExpense money
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
declare @NextRootTaskKey int
declare @NextRootDisplayOrder int
declare @TaskName varchar(100)
declare @Description varchar(4000) -- limit to 4000 size of line description
declare @TaskType smallint
declare @Taxable tinyint, @Taxable2 tinyint
declare @WorkTypeKey int
declare @BillFrom smallint
declare @NextInvoiceDisplayOrder int
Declare @SalesGLAccountKey int 
Declare @SalesTaxKey int, @SalesTax2Key int	
Declare @NoTask int
Declare @TrackBudget int
Declare @LineType int
		
	--temp tables needed (created now in calling sps)
	/*
	create table #tInvcTask
                (
                 TaskKey int null
                ,SummaryTaskKey int null
                ,TaskType smallint null
                ,DisplayOrder int null
                ,Taxable tinyint null 
                ,Taxable2 tinyint null 
                ,WorkTypeKey int null 
                ,TrackBudget int null
                ,TaskName varchar(500) null
                ,Description varchar(6000) null
                
      )	
	create table #tInvcRootTask
     (
				TaskKey int null
				,SummaryTaskKey int null
                ,TaskType smallint null
                ,DisplayOrder int null
                ,Taxable tinyint null 
                ,Taxable2 tinyint null 
                ,WorkTypeKey int null               
                ,TrackBudget int null
                ,TaskName varchar(500) null
                ,Description varchar(6000) null
                )           
	*/
		
	TRUNCATE TABLE #tInvcTask
	TRUNCATE TABLE #tInvcRootTask

declare @AllTrackBudgetTasks int
select @AllTrackBudgetTasks = AllTrackBudgetTasksOnInvoice
from tInvoice i (nolock)
inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
where i.InvoiceKey = @NewInvoiceKey

if isnull(@AllTrackBudgetTasks, 0) = 0
begin	
	--get labor
	  insert #tInvcTask
		select distinct ta.TaskKey
		     ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0) 
		      ,isnull(ta.Taxable2, 0) 
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		  from tTime t (nolock)
		      ,#tBillingDetail w
		      ,tTask ta (nolock)
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tTime'
		   and t.TimeKey = w.EntityGuid
		   and t.TaskKey = ta.TaskKey
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)
      	      
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -11				   	
		  end
		        
		--get expense receipts
	    insert #tInvcTask
		select distinct ta.TaskKey
		      ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0) 
		      ,isnull(ta.Taxable2, 0) 
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		      from tExpenseReceipt t (nolock)
		      ,#tBillingDetail w
		      ,tTask ta (nolock)
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tExpenseReceipt'
		   and t.ExpenseReceiptKey = w.EntityKey
		   and t.TaskKey = ta.TaskKey		   
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)

		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -12				   	
		  end
		   
		--get misc expenses
	    insert #tInvcTask
		select distinct ta.TaskKey
		      ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0) 
		      ,isnull(ta.Taxable2, 0) 
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget		   
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		      from tMiscCost t (nolock)
		      ,#tBillingDetail w
		      ,tTask ta (nolock)
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tMiscCost'
		   and t.MiscCostKey = w.EntityKey		   
		   and t.TaskKey = ta.TaskKey
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)
		      
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -13				   	
		  end
		   
		--get vouchers
	    insert #tInvcTask
		select distinct ta.TaskKey
		      ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0) 
		      ,isnull(ta.Taxable2, 0) 
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget		      
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		      from tVoucherDetail t (nolock)
		      ,#tBillingDetail w
		      ,tTask ta (nolock)		      
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tVoucherDetail'
		   and t.VoucherDetailKey = w.EntityKey	
		   and t.TaskKey = ta.TaskKey		     
		 and ta.TaskKey not in (select TaskKey from #tInvcTask)

		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -14				   	
		  end

		--get orders
	    insert #tInvcTask
		select distinct ta.TaskKey
		      ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0) 
		      ,isnull(ta.Taxable2, 0) 
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget		      
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		      from tPurchaseOrderDetail pod (nolock)
		      ,#tBillingDetail w
		      ,tTask ta (nolock)		      
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tPurchaseOrderDetail'
		   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)	
		   and pod.TaskKey = ta.TaskKey		     
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)

		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -14				   	
		  end
end
else
begin
		insert #tInvcTask
		select distinct ta.TaskKey
    		  ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0)
		      ,isnull(ta.Taxable2, 0)
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		  from tTask ta (nolock)		      
		 where ta.ProjectKey = @ProjectKey 
		 and   ta.TrackBudget = 1

		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -14				   	
		  end
end
		  
		--recursively fill in the missing summary nodes
		exec spCreateInvoiceTree
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -15				   	
		  end

		--order the root level nodes
		insert #tInvcRootTask
		select *
		  from #tInvcTask		
		 where #tInvcTask.SummaryTaskKey = 0
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -16				   	
		  end

		select @NextInvoiceDisplayOrder = 0
		
		--loop through root tasks in order
		select @NextRootDisplayOrder = -1
		while (1=1)
		  begin
			select @NextRootDisplayOrder = min(DisplayOrder)
			  from #tInvcRootTask
		     where DisplayOrder > @NextRootDisplayOrder
			if @NextRootDisplayOrder is null
				break
				
	    	select @NextRootTaskKey = TaskKey
			      ,@TaskName = isnull(left(TaskName,100),'No Task Name')
			      ,@Description = left(Description, 4000)
			      ,@TaskType = TaskType
			      ,@Taxable = Taxable
			      ,@Taxable2 = Taxable2
				  ,@WorkTypeKey = WorkTypeKey
				  ,@TrackBudget = TrackBudget
			  from #tInvcRootTask
		     where DisplayOrder = @NextRootDisplayOrder
		     		  
			select @SalesGLAccountKey =  null
			
			if isnull(@WorkTypeKey, 0) > 0 
				Select @SalesGLAccountKey = GLAccountKey 
				from tWorkType (nolock) 
				Where WorkTypeKey = @WorkTypeKey
						
			if isnull(@SalesGLAccountKey, 0) = 0
				Select @SalesGLAccountKey = @DefaultSalesAccountKey
				
			/*	
			if @TaskType = 1
				select @BillFrom = 0
			else
				select @BillFrom = 2
			*/
			
			if @TrackBudget = 1  -- This would be a tracking task now even if TaskType = 1
				select @BillFrom = 2
				      ,@LineType = 2 -- Tracking/Detail
			else
				select @BillFrom = 0
				       ,@LineType = 1 -- Summary

			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,@NextRootTaskKey				-- TaskKey
						  ,@TaskName					-- Line Subject
						  ,@Description                 -- Line description
						  ,@BillFrom      				-- Bill From 
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,0							-- Line Amount
						  ,@LineType					-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@SalesGLAccountKey			-- Default Sales AccountKey
						  ,@DefaultClassKey             -- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@WorkTypeKey					-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey
						  ,NULL							-- OfficeKey
						  ,NULL							-- DepartmentKey
						  ,@NewInvoiceLineKey output

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end			   		     		 
			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					 	
			  end

			--exec sptInvoiceRecalcAmounts @NewInvoiceKey 

			if isnull(@CampaignSegmentKey, 0) > 0
				update tInvoiceLine
				set CampaignSegmentKey = @CampaignSegmentKey
				where InvoiceLineKey = @NewInvoiceLineKey
				
			--if @TaskType = 2  --only detail lines
			if @LineType = 2 --only detail lines
			  begin
  				--associate to invoice line
				--time
					update tTime
					set InvoiceLineKey = @NewInvoiceLineKey
						,BilledService = ISNULL(#tBillingDetail.ServiceKey, tTime.ServiceKey)
						,RateLevel = ISNULL(#tBillingDetail.RateLevel, tTime.RateLevel)
						,BilledHours = Quantity
						,BilledRate = Rate
						,BilledComment = #tBillingDetail.Comments
					from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tTime'
					and tTime.TimeKey = #tBillingDetail.EntityGuid	
					and tTime.TaskKey = @NextRootTaskKey
					if @@ERROR <> 0 
					begin
						exec sptInvoiceDelete @NewInvoiceKey
						return -18				   	
					end
				  	   
				--expenses	   
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tExpenseReceipt'
					and tExpenseReceipt.ExpenseReceiptKey = #tBillingDetail.EntityKey
					and tExpenseReceipt.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -19					   	
				  end
				  
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tMiscCost'
				   and tMiscCost.MiscCostKey = #tBillingDetail.EntityKey 
				   AND tMiscCost.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -20					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tVoucherDetail'
				   and tVoucherDetail.VoucherDetailKey = #tBillingDetail.EntityKey
				   and tVoucherDetail.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			   	
				  end
				  
				--orders	   
				update tPurchaseOrderDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
				   	,tPurchaseOrderDetail.AccruedCost = 
				   		CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					,tPurchaseOrder po (nolock)
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tPurchaseOrderDetail'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tBillingDetail.EntityKey 
				   and tPurchaseOrderDetail.TaskKey = @NextRootTaskKey
				   and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
				   
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			 	
				  end
				   
				   
				--update invoice line totals
				--get total hours/labor
				select @TotLabor = isnull(sum(round(isnull(bd.Quantity, 0)*isnull(bd.Rate,0), 2)), 0)
				  from tTime t (nolock)
					   inner join #tBillingDetail bd on t.TimeKey = bd.EntityGuid 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tTime'
				   
				--get expense receipts
				select @TotExpenseRcpt = isnull(sum(isnull(Total,0)),0)
				  from tExpenseReceipt t (nolock)
					   inner join #tBillingDetail bd on t.ExpenseReceiptKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tExpenseReceipt'
				 			   
				--get misc expenses
				select @TotMiscExpense = isnull(sum(isnull(Total,0)),0)
				  from tMiscCost t (nolock)
					   inner join #tBillingDetail bd on t.MiscCostKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tMiscCost'
				 			   
				--get vouchers
				select @TotVoucher = isnull(sum(isnull(Total,0)),0)
				  from tVoucherDetail t (nolock)
					   inner join #tBillingDetail bd on t.VoucherDetailKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tVoucherDetail'
				 
				--get po's
				select @TotPO = isnull(sum(isnull(Total,0)),0)
				  from tPurchaseOrderDetail t (nolock)
					   inner join #tBillingDetail bd on t.PurchaseOrderDetailKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tPurchaseOrderDetail'

				
				--calc total expenses
				select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)		  

				--update invoice line
				update tInvoiceLine
				   set TotalAmount = @TotExpense
				 where InvoiceLineKey = @NewInvoiceLineKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -22			   	

				  end
				  				
			  end

			if @LineType = 1  --only summary lines
			  begin
				--recursively create subordinate lines
				exec @RetVal = spBillingInvoiceTaskLineTree 
										 @NextRootTaskKey
										,@NewInvoiceKey
										,@BillingKey
			                            ,@ProjectKey
										,@DefaultSalesAccountKey
			                            ,@DefaultClassKey
			                            ,@NewInvoiceLineKey
										,@PostSalesUsingDetail
			                          
				if @RetVal <> 1 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -23					   	
				  end
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -24					   	
				  end	
			end --end of recursive call		                            
				
		end --end of root task loop
		  
		  
	  -- Now case when there is no task for expenses. (Times always have a TaskKey)
	SELECT  @NoTask = 0
	
	If Exists (Select 1
			   from tExpenseReceipt er (nolock)
				inner join #tBillingDetail bd on er.ExpenseReceiptKey = bd.EntityKey
			where bd.Entity = 'tExpenseReceipt'
			and bd.BillingKey = @BillingKey
			and isnull(er.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1
			
	
	If Exists (Select 1
			from tMiscCost mc (nolock)
   				inner join #tBillingDetail bd on mc.MiscCostKey = bd.EntityKey
			where bd.Entity = 'tMiscCost' 
			and bd.BillingKey = @BillingKey
			and isnull(mc.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1
	
	If Exists (Select 1
			from tVoucherDetail vd (nolock)
   				inner join #tBillingDetail bd on vd.VoucherDetailKey = bd.EntityKey
			where bd.Entity = 'tVoucherDetail' 
			and bd.BillingKey = @BillingKey
			and isnull(vd.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1

	If Exists (Select 1
			from tPurchaseOrderDetail pod (nolock)
   				inner join #tBillingDetail bd on pod.PurchaseOrderDetailKey = bd.EntityKey
			where bd.Entity = 'tPurchaseOrderDetail' 
			and bd.BillingKey = @BillingKey
			and isnull(pod.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1


	if @NoTask = 1
	begin
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,'Expenses'					-- Line Subject
						  ,NULL                 		-- Line description
						  ,2              				-- Bill From    
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,0							-- Line Amount
						  ,2							-- line type   
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
						  ,@DefaultClassKey             -- Class Key
						  ,0							-- Taxable
						  ,0							-- Taxable2
						  ,NULL							-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey						  
						  ,NULL							-- OfficeKey
						  ,NULL							-- DepartmentKey
						  ,@NewInvoiceLineKey output

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end			           		     		 
			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end

			--exec sptInvoiceRecalcAmounts @NewInvoiceKey 

				--expenses	   
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tExpenseReceipt'
					and tExpenseReceipt.ExpenseReceiptKey = #tBillingDetail.EntityKey
				  and isnull(tExpenseReceipt.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -19					   	
				  end

				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tMiscCost'
				   and tMiscCost.MiscCostKey = #tBillingDetail.EntityKey 
				   AND isnull(tMiscCost.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -20					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tVoucherDetail'
				   and tVoucherDetail.VoucherDetailKey = #tBillingDetail.EntityKey
				   and isnull(tVoucherDetail.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			   	
				  end
				  
				--orders	   
				update tPurchaseOrderDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
				   	,tPurchaseOrderDetail.AccruedCost = 
				   		CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				 from #tBillingDetail
				    ,tPurchaseOrder po (nolock)
					where #tBillingDetail.BillingKey = @BillingKey
					and #tBillingDetail.Entity = 'tPurchaseOrderDetail'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tBillingDetail.EntityKey 
				   and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
				   and isnull(tPurchaseOrderDetail.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			   	
				  end
				   
				   
				--update invoice line totals
								   				   
				--get expense receipts
				select @TotExpenseRcpt = isnull(sum(isnull(Total,0)),0)
				  from tExpenseReceipt t (nolock)
					   inner join #tBillingDetail bd on t.ExpenseReceiptKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tExpenseReceipt'
				 			   
				--get misc expenses
				select @TotMiscExpense = isnull(sum(isnull(Total,0)),0)
				  from tMiscCost t (nolock)
					   inner join #tBillingDetail bd on t.MiscCostKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tMiscCost'
				 			   
				--get vouchers
				select @TotVoucher = isnull(sum(isnull(Total,0)),0)
				  from tVoucherDetail t (nolock)
					   inner join #tBillingDetail bd on t.VoucherDetailKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tVoucherDetail'
				 
				--get po's
				select @TotPO = isnull(sum(isnull(Total,0)),0)
				  from tPurchaseOrderDetail t (nolock)
					   inner join #tBillingDetail bd on t.PurchaseOrderDetailKey = bd.EntityKey 
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   and bd.BillingKey = @BillingKey
				   and bd.Entity = 'tPurchaseOrderDetail'
				
				--calc total expenses
				select @TotExpense = round((isnull(@TotExpenseRcpt, 0) + isnull(@TotMiscExpense, 0) +isnull(@TotVoucher, 0) + isnull(@TotPO, 0)),2)		  

				--update invoice line
				update tInvoiceLine
				   set TotalAmount = @TotExpense
				 where InvoiceLineKey = @NewInvoiceLineKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -22			   	

				  end
				  				
			  
		end -- end of no task on expense 
	
		
	RETURN 1
GO
