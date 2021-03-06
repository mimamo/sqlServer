USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceTaskLineTree]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingInvoiceTaskLineTree]
	 @SummaryTaskKey int
	,@NewInvoiceKey int
	,@BillingKey int
	,@ProjectKey int
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@ParentLineKey int
	,@PostSalesUsingDetail tinyint
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added use of TrackBudget
  || 07/09/07 GHL 8.5	Added logic for office/department  
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465    
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1) 
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments    
  || 10/28/10 GHL 10.537 Put back description at KN's request
  || 12/17/10 GHL 10.539 (97621) Using now sptInvoiceLineInsertMassBilling vs sptInvoiceLineInsert to improve performance 
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
declare @Description varchar(4000)
declare @TaskType smallint
declare @Taxable tinyint, @Taxable2 tinyint 
declare @WorkTypeKey int
declare @BillFrom smallint
declare @NextInvoiceDisplayOrder int
declare @SalesGLAccountKey int
declare @LineType int
declare @TrackBudget int

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
	
		exec @RetVal = sptInvoiceLineInsertMassBilling
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,@NextRootTaskKey				-- Task Key
					  ,@TaskName					-- Line Subject
					  ,@Description                 -- Line description
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

		  if @@ERROR <> 0 
		  begin
			return -17					   	
		  end		
		  if @RetVal <> 1 
		  begin
			return -17					   	
		  end
	           		     		  
			  
				  			 
		if @LineType = 2 -- detail line
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
					return -23			   	
				  end
				  
		  end  --end if detail task processing
		
		
		if @LineType = 1  --Summary line
		  begin
			--recursively create subordinate lines
			exec spBillingInvoiceTaskLineTree @NextRootTaskKey
			                            ,@NewInvoiceKey
			                            ,@BillingKey
			                            ,@ProjectKey
			                            ,@DefaultSalesAccountKey
										,@DefaultClassKey
										,@NewInvoiceLineKey
										,@PostSalesUsingDetail
			        
			  if @@ERROR <> 0 
			  begin
				return -24					   	
			  end	
			  if @RetVal <> 1 
			  begin
				return -23					   	
			  end

		end --end of recursive sub task call		                    
				
	end --end of root task loop
		  
	                       
	return 1
GO
