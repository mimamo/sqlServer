USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCreateInvoiceLineTree]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCreateInvoiceLineTree]
	 @SummaryTaskKey int
	,@NewInvoiceKey int
	,@ProjectKey int
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@ParentLineKey int
	,@PostSalesUsingDetail tinyint
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 07/02/07 GHL 8.5   Added OfficeKey and DepartmentKey when creating the line
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465    
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)   
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */

declare @NbrOfChildren int
declare @NewInvoiceLineKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContactKey int 
declare @RetVal int
declare @TodaysDate smalldatetime
declare @ProjectName varchar(100)
declare @TotHours decimal(9,3)
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
declare @SalesGLAccountKey int
Declare @TrackBudget int
Declare @LineType int


	select @NbrOfChildren = isnull(count(*),0)
	  from #tInvcTask
	 where SummaryTaskKey = @SummaryTaskKey
	if @NbrOfChildren = 0 
		return 1
		

	select @NextInvoiceDisplayOrder = 0
		
	--loop through tasks in order
	select @NextRootDisplayOrder = -1
	while (1=1)
	  begin
		select @NextRootDisplayOrder = min(DisplayOrder)
		  from #tInvcTask
		 where DisplayOrder > @NextRootDisplayOrder
		   and SummaryTaskKey = @SummaryTaskKey
		if @NextRootDisplayOrder is null
			break
				
	    select @NextRootTaskKey = TaskKey
		      ,@TaskName = left(TaskName,100)
		      ,@Description = left(Description,4000)
		      ,@TaskType = TaskType
		      ,@Taxable = Taxable
		      ,@Taxable2 = Taxable2
		      ,@WorkTypeKey = WorkTypeKey
		      ,@TrackBudget = TrackBudget
		  from #tInvcTask
		 where DisplayOrder = @NextRootDisplayOrder
		   and SummaryTaskKey = @SummaryTaskKey
		     		  
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
					   	
		exec @RetVal = sptInvoiceLineInsert
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,@NextRootTaskKey				-- Task Key
					  ,@TaskName					-- Line Subject
					  ,null -- @Description                 -- Line description
					  ,@BillFrom               		-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,0							-- Line Amount
					  ,@LineType					-- line type
					  ,@ParentLineKey				-- parent line key
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
			return -17					   	
		  end
		if @@ERROR <> 0 
		  begin
			return -17					   	
		  end			           		     		  
			  
				  			 
		if @LineType = 2
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
						When 1 then isnull(TotalCost,0)
						When 2 then isnull(BillableCost,0) - isnull(TotalCost,0) end ,0)
				  from #tProcWIPKeys, tPurchaseOrder po
				 where #tProcWIPKeys.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and tPurchaseOrderDetail.TaskKey = @NextRootTaskKey
				if @@ERROR <> 0 
				  begin
					return -21			   	
				  end
				  
			
				--update invoice line totals
				--get total hours/labor
				select @TotHours = isnull(sum(isnull(ActualHours,0)),0)
				      ,@TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0),2)),0)
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
				 			 
				--get orders
				select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
				When 0 then isnull(BillableCost,0)
				When 1 then isnull(TotalCost,0)
				When 2 then isnull(BillableCost,0) - isnull(TotalCost,0) end ),0)
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
					return -23			   	
				  end
				  
		  end  --end if detail task processing
		
		
		if @LineType = 1  --only detail lines
		  begin
			--recursively create subordinate lines
			exec spCreateInvoiceLineTree @NextRootTaskKey
			                            ,@NewInvoiceKey
			                            ,@ProjectKey
			                            ,@DefaultSalesAccountKey
										,@DefaultClassKey
										,@NewInvoiceLineKey
										,@PostSalesUsingDetail
			        
			if @RetVal <> 1 
			  begin
				return -23					   	
			  end
			if @@ERROR <> 0 
			  begin
				return -24					   	
			  end	
		end --end of recursive sub task call		                    
				
	end --end of root task loop
		  
	                       
	return 1
GO
