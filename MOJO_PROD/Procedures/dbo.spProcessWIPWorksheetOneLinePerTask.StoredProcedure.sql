USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerTask]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerTask]
	(
	@NewInvoiceKey INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 06/29/07 GHL 8.5   Added new parm OfficeKey, DepartmentKey
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465 
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)     
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency 
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
declare @Description varchar(4000) -- Limit to 4000, size of line description
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
		
	--create temp tables needed
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
		      ,#tProcWIPKeys w
		      ,tTask ta (nolock)
		 where w.EntityType = 'Time'
		   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
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
		      ,#tProcWIPKeys w
		      ,tTask ta (nolock)
		 where w.EntityType = 'Expense'
		   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
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
		      ,#tProcWIPKeys w
		      ,tTask ta (nolock)
		 where w.EntityType = 'MiscExpense'
		   and t.MiscCostKey = cast(w.EntityKey as integer)		   
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
		      ,#tProcWIPKeys w
		      ,tTask ta (nolock)		      
		 where w.EntityType = 'Voucher'
		   and t.VoucherDetailKey = cast(w.EntityKey as integer)	
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
		      ,#tProcWIPKeys w
		      ,tTask ta (nolock)		      
		 where w.EntityType = 'Order'
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
			      ,@Description = left(Description,4000)
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
				
			--if @TaskType = 1
			if @TrackBudget = 0
				-- Summary
				select @BillFrom = 0
					  ,@LineType = 1
			else
				-- Detail
				select @BillFrom = 2
					   ,@LineType = 2

			--create single invoice line
			exec @RetVal = sptInvoiceLineInsert
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,@NextRootTaskKey				-- TaskKey
						  ,@TaskName					-- Line Subject
						  ,null -- @Description                 -- Line description
						  ,@BillFrom      				-- Bill From 
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,0							-- Line Amount
						  ,@LineType					-- line type
						  ,0							-- parent line key
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


			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end
			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end			   		     		 

			exec sptInvoiceRecalcAmounts @NewInvoiceKey 

			 
			if @LineType = 2  --only detail lines
			  begin
  				--associate to invoice line
				--time
				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = ServiceKey
					  ,BilledHours = ActualHours
					  ,BilledRate = ActualRate
				  from #tProcWIPKeys
			 where #tProcWIPKeys.EntityType = 'Time'
				   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)					 
				   and tTime.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -18					   	
				  end
				  	   
				--expenses	   
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Expense'
				   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and tExpenseReceipt.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -19					   	
				  end
				  
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
   				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'MiscExpense'
				   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
				   AND tMiscCost.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -20					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
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
					  ,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
				  from #tProcWIPKeys, tPurchaseOrder po
				 where #tProcWIPKeys.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and tPurchaseOrderDetail.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			   	
				  end
				   
				   
				--update invoice line totals
				--get total hours/labor
				select @TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
				  from tTime t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				   
				--get expense receipts
				select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
				  from tExpenseReceipt t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 			   
				--get misc expenses
				select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
				  from tMiscCost t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 			   
				--get vouchers
				select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
				  from tVoucherDetail t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 
				--get po's
				select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
				When 0 then isnull(BillableCost,0)
				When 1 then isnull(PTotalCost,isnull(TotalCost,0))
				When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
				from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				Where po.PurchaseOrderKey = pod.PurchaseOrderKey
				and pod.InvoiceLineKey = @NewInvoiceLineKey
				
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
				exec @RetVal = spCreateInvoiceLineTree 
										 @NextRootTaskKey
										,@NewInvoiceKey
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
				,#tProcWIPKeys
			where #tProcWIPKeys.EntityType = 'Expense'
			and er.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
			and isnull(er.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1
			
	
	If Exists (Select 1
			from tMiscCost mc (nolock)
   				,#tProcWIPKeys
			where #tProcWIPKeys.EntityType = 'MiscExpense'
			and mc.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
			AND isnull(mc.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1
	
	If Exists (Select 1
			from tVoucherDetail vd (nolock)
			    ,#tProcWIPKeys
			where #tProcWIPKeys.EntityType = 'Voucher'
			and vd.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
			and isnull(vd.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1

	If Exists (Select 1
			from #tProcWIPKeys, tPurchaseOrder po, tPurchaseOrderDetail pod (nolock)
			where #tProcWIPKeys.EntityType = 'Order'
			and pod.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
			and po.PurchaseOrderKey = pod.PurchaseOrderKey
			and isnull(pod.TaskKey, 0) = 0
			)
		SELECT  @NoTask = 1


	if @NoTask = 1
	begin
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsert
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
						  ,0							-- parent line key
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


			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end
			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end			           		     		 

			exec sptInvoiceRecalcAmounts @NewInvoiceKey 

				--expenses	   
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Expense'
				   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
				  and isnull(tExpenseReceipt.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -19					   	
				  end
				  
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				 from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'MiscExpense'
				   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
				   AND isnull(tMiscCost.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -20					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
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
					  ,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
				  from #tProcWIPKeys, tPurchaseOrder po (nolock)
				 where #tProcWIPKeys.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and isnull(tPurchaseOrderDetail.TaskKey, 0) = 0
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -21			   	
				  end
				   
				   
				--update invoice line totals
								   
				--get expense receipts
				select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
				  from tExpenseReceipt t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 			   
				--get misc expenses
				select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
				  from tMiscCost t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 			   
				--get vouchers
				select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
				  from tVoucherDetail t (nolock)
				 where t.InvoiceLineKey = @NewInvoiceLineKey
				 
				--get po's
				select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
				When 0 then isnull(BillableCost,0)
				When 1 then isnull(PTotalCost,isnull(TotalCost,0))
				When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
				from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				Where po.PurchaseOrderKey = pod.PurchaseOrderKey
				and pod.InvoiceLineKey = @NewInvoiceLineKey
				
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
