USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerBillingItem]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerBillingItem]
	(
	@CompanyKey int	
	,@NewInvoiceKey INT
	,@BillingKey int
	,@BillingMethod int
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@BillingClassKey int
	,@ParentInvoiceLineKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/11/07 GHL 8.411 Added check of InvoiceLineKey null before updating last batch of transactions
  ||                    Otherwise the transactions are billed against the wrong invoice line
  || 04/25/07 GHL 8.5   Added Taxable fields (Enh 7150)
  || 07/09/07 GHL 8.5   Added logic for office/dept
  || 07/10/07 QMD 8.5   (+ GHL) Expense Type reference changed to tItem
  || 01/09/08 GHL 8.501 (18967) Creating now invoice lines in alphabetical order
  || 04/08/08 GHL 8.508 (23712) New logic for classes, remove reading of FixedFeeBillingClassDetail  
  || 07/14/08 GHL 8.515 (30094) Removed call to sptInvoiceRecalcAmounts
  || 03/18/09 GHL 10.021 Getting now the service from the billing worksheet, not the time entry
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments  
  || 06/12/09 GHL 10.026 (54547) Joining now billing item thru tBillingDetail.ServiceKey 
  ||                     instead of tTime.ServiceKey (second join) 
  || 07/29/09 GHL 10.505 (57778) Do not prevent the users from creating an invoice with 0 amount
  ||                      For this reason, use transaction count rather than amount to determine if 
  ||                      the invoice lines are needed  
  || 04/12/10 GHL 10.521 (75825) Line description is now a text field, cannot be held in a variable
  || 12/10/10 GHL 10.539 (96484) Looping now using WorkTypeID instead of WorkTypeName
  ||                     because WorkTypeID is unique but WorkTypeName is not 
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
  
	SET NOCOUNT ON

declare @NewInvoiceLineKey int
declare @RetVal int
declare @TotHours decimal(9,3)
declare @TotLabor money
declare @TotExpenseRcpt money
declare @TotMiscExpense money
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
Declare @SalesGLAccountKey int 
Declare @NextWorkTypeKey int
Declare @WorkTypeID varchar(100)
Declare @WorkTypeName varchar(200)
Declare @Taxable tinyint
Declare @Taxable2 tinyint
Declare @WorkTypeClassKey int
Declare @ClassKey int
Declare @InsertLine int
		
-- we need a good service
update #tBillingDetail
set    #tBillingDetail.ServiceKey = t.ServiceKey
from   tTime t (nolock)
where  #tBillingDetail.Entity = 'tTime'
and    #tBillingDetail.BillingKey = @BillingKey
and    #tBillingDetail.EntityGuid = t.TimeKey
and    isnull(#tBillingDetail.ServiceKey, 0) = 0   
		
		Select @WorkTypeID = ''
		
		While 1=1
		begin

			Select @WorkTypeID = MIN(WorkTypeID)
			from   tWorkType (nolock)
			Where  CompanyKey = @CompanyKey 
			and    Active = 1
			and    WorkTypeID is not null
			and    WorkTypeID > @WorkTypeID
			
			if @WorkTypeID is null
				break
			
			Select
				@NextWorkTypeKey = WorkTypeKey,
				@SalesGLAccountKey = GLAccountKey,
				@Taxable = ISNULL(Taxable, 0),
				@Taxable2 = ISNULL(Taxable2, 0),
				@WorkTypeClassKey = ClassKey,
				@WorkTypeName = WorkTypeName
			from  tWorkType (nolock) 
			Where CompanyKey = @CompanyKey 
			and   Active = 1
			and   WorkTypeID = @WorkTypeID
			
			if @SalesGLAccountKey is null
				Select @SalesGLAccountKey = @DefaultSalesAccountKey

			IF ISNULL(@BillingClassKey, 0) > 0
				SELECT @ClassKey = @BillingClassKey
			ELSE
				IF ISNULL(@WorkTypeClassKey, 0) > 0
					SELECT @ClassKey = @WorkTypeClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey

			select @InsertLine = 0
			
			-- Time
			select @TotHours = isnull(sum(isnull(Quantity,0)),0)
			      ,@TotLabor = isnull(sum(round(isnull(Quantity,0)*isnull(Rate,0), 2)), 0)
			  from tTime t (nolock) 
				,#tBillingDetail w
				,tService s (nolock)
			 where w.Entity = 'tTime'
			   and w.BillingKey = @BillingKey
			   and t.TimeKey = w.EntityGuid
			   and w.ServiceKey = s.ServiceKey -- get the service from the billing worksheet
			   and s.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotLabor, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
					from tTime t (nolock) 
					,#tBillingDetail w
					,tService s (nolock)
				 where w.Entity = 'tTime'
				   and w.BillingKey = @BillingKey
				   and t.TimeKey = w.EntityGuid
				   and w.ServiceKey = s.ServiceKey -- get the service from the billing worksheet
				   and s.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end
			
			--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(Total,0)),0)
			  from tExpenseReceipt t (nolock)
			  ,#tBillingDetail w, tItem i 
			 where w.Entity = 'tExpenseReceipt'
			   and w.BillingKey = @BillingKey
			   and t.ExpenseReceiptKey = w.EntityKey
			   and t.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey
			
			if isnull(@TotExpenseRcpt, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tExpenseReceipt t (nolock)
				  ,#tBillingDetail w, tItem i 
				 where w.Entity = 'tExpenseReceipt'
				   and w.BillingKey = @BillingKey
				   and t.ExpenseReceiptKey = w.EntityKey
				   and t.ItemKey = i.ItemKey
				   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end
			   
			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(Total,0)),0)
			  from tMiscCost t (nolock)
			      ,#tBillingDetail w, tItem i
			 where w.Entity = 'tMiscCost'
			   and w.BillingKey = @BillingKey
			   and t.MiscCostKey = w.EntityKey
			   and t.ItemKey = i.ItemKey
			  and i.WorkTypeKey = @NextWorkTypeKey
			
			if isnull(@TotMiscExpense, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tMiscCost t (nolock)
						  ,#tBillingDetail w, tItem i
					 where w.Entity = 'tMiscCost'
					   and w.BillingKey = @BillingKey
					   and t.MiscCostKey = w.EntityKey
					   and t.ItemKey = i.ItemKey
					  and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end
			  
			--get vouchers
			select @TotVoucher = isnull(sum(isnull(Total,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tBillingDetail w, tItem i (nolock)
			 where w.Entity = 'tVoucherDetail'
			   and w.BillingKey = @BillingKey
			   and t.VoucherDetailKey = w.EntityKey		   
			   and t.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotVoucher, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tVoucherDetail t (nolock)
					  ,#tBillingDetail w, tItem i (nolock)
				 where w.Entity = 'tVoucherDetail'
				   and w.BillingKey = @BillingKey
				   and t.VoucherDetailKey = w.EntityKey		   
				   and t.ItemKey = i.ItemKey
				   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end
			
			--get po's
			select @TotPO = isnull(sum(isnull(Total,0)),0)
			  from tPurchaseOrderDetail pod (nolock)
				   ,#tBillingDetail w, tItem i (nolock)
			 where w.Entity = 'tPurchaseOrderDetail'
			   and w.BillingKey = @BillingKey
			   and pod.PurchaseOrderDetailKey = w.EntityKey
			   and pod.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotPO, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
				from tPurchaseOrderDetail pod (nolock)
					   ,#tBillingDetail w, tItem i (nolock)
				 where w.Entity = 'tPurchaseOrderDetail'
				   and w.BillingKey = @BillingKey
				   and pod.PurchaseOrderDetailKey = w.EntityKey
				   and pod.ItemKey = i.ItemKey
				   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end
			
			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)
					
			if @InsertLine = 1
			BEGIN
				exec @RetVal = sptInvoiceLineInsertMassBilling
					  @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@WorkTypeName				-- Line Subject
					  ,NULL    						-- Line description...text field cannot be in a variable
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,@ParentInvoiceLineKey		-- parent line key
					  ,@SalesGLAccountKey			-- Default Sales AccountKey
					  ,@ClassKey             -- Class Key
					  ,@Taxable						-- Taxable
					  ,@Taxable2					-- Taxable2
					  ,@NextWorkTypeKey				-- Work TypeKey
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

				-- only now can we update the line with a text field
				update tInvoiceLine
				set    tInvoiceLine.LineDescription = wt.Description
				from   tWorkType wt (nolock)
				where  wt.WorkTypeKey = @NextWorkTypeKey
				and    tInvoiceLine.InvoiceLineKey = @NewInvoiceLineKey
				
				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = ISNULL(#tBillingDetail.ServiceKey, tTime.ServiceKey)
					  ,RateLevel = ISNULL(#tBillingDetail.RateLevel, tTime.RateLevel)					  
					  ,BilledHours = #tBillingDetail.Quantity
					  ,BilledRate = #tBillingDetail.Rate
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail, tService (nolock)
				   where #tBillingDetail.Entity = 'tTime'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tTime.TimeKey = #tBillingDetail.EntityGuid					  
				   and #tBillingDetail.ServiceKey = tService.ServiceKey
				   and tService.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				 begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				  end
	
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail, tItem (nolock)
				 where #tBillingDetail.Entity = 'tExpenseReceipt'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tExpenseReceipt.ExpenseReceiptKey = #tBillingDetail.EntityKey
				   and tExpenseReceipt.ItemKey = tItem.ItemKey
				   and tItem.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				 begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				 end
			 
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail, tItem (nolock)
				 where #tBillingDetail.Entity = 'tMiscCost'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tMiscCost.MiscCostKey = #tBillingDetail.EntityKey
				   and tMiscCost.ItemKey = tItem.ItemKey
				   and tItem.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -9					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail, tItem (nolock)
				 where #tBillingDetail.Entity = 'tVoucherDetail'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tVoucherDetail.VoucherDetailKey = #tBillingDetail.EntityKey
				   and tVoucherDetail.ItemKey = tItem.ItemKey
				   and tItem.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				  end
				  
				--Order	   
				update tPurchaseOrderDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,tPurchaseOrderDetail.AccruedCost = 
					  CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END
					  ,AmountBilled = Total
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail, tItem (nolock)
				  	,tPurchaseOrder po (nolock)
				 where #tBillingDetail.Entity = 'tPurchaseOrderDetail'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tBillingDetail.EntityKey
				   and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
				   and tPurchaseOrderDetail.ItemKey = tItem.ItemKey
				   and tItem.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				 end
			end  -- end of insert line
		end  -- Loop for work types
				   
				 
		-- Begin update for remaining lines  *************************************

			select @InsertLine = 0
			
			-- Time
			select @TotLabor = isnull(sum(round(isnull(Quantity,0)*isnull(Rate,0), 2)), 0)
			  from tTime t (nolock) ,#tBillingDetail w
			 where w.Entity = 'tTime'
			  and w.BillingKey = @BillingKey
			  and t.TimeKey = w.EntityGuid
			   and t.InvoiceLineKey is NULL

			if isnull(@TotLabor, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
				from tTime t (nolock) ,#tBillingDetail w
				 where w.Entity = 'tTime'
				  and w.BillingKey = @BillingKey
				  and t.TimeKey = w.EntityGuid
				   and t.InvoiceLineKey is NULL
					)			
				select @InsertLine = 1
			end

			
			--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(Total,0)),0)
			  from tExpenseReceipt t (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'tExpenseReceipt'
			  and w.BillingKey = @BillingKey
			   and t.ExpenseReceiptKey = w.EntityKey
			   and t.InvoiceLineKey is NULL
			
			if isnull(@TotExpenseRcpt, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
				from tExpenseReceipt t (nolock)
					  ,#tBillingDetail w
				 where w.Entity = 'tExpenseReceipt'
				  and w.BillingKey = @BillingKey
				   and t.ExpenseReceiptKey = w.EntityKey
				   and t.InvoiceLineKey is NULL	
					)			
				select @InsertLine = 1
			end
			   
			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(Total,0)),0)
			  from tMiscCost t (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'tMiscCost'
			  and w.BillingKey = @BillingKey
			   and t.MiscCostKey = w.EntityKey
			   and t.InvoiceLineKey is NULL
			
			if isnull(@TotMiscExpense, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
			  from tMiscCost t (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'tMiscCost'
			  and w.BillingKey = @BillingKey
			   and t.MiscCostKey = w.EntityKey
			   and t.InvoiceLineKey is NULL
					)			
				select @InsertLine = 1
			end
			   
			--get vouchers
			select @TotVoucher = isnull(sum(isnull(Total,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'tVoucherDetail'
			  and w.BillingKey = @BillingKey
			   and t.VoucherDetailKey = w.EntityKey		   
			   and t.InvoiceLineKey is NULL
			
			if isnull(@TotVoucher, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
			  from tVoucherDetail t (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'tVoucherDetail'
			  and w.BillingKey = @BillingKey
			   and t.VoucherDetailKey = w.EntityKey		   
			   and t.InvoiceLineKey is NULL
					)			
				select @InsertLine = 1
			end
			   
			--get Orders
			select @TotPO = isnull(sum(isnull(Total,0)),0)
			  from tPurchaseOrderDetail pod (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'Order'
			  and w.BillingKey = @BillingKey
			   and pod.PurchaseOrderDetailKey = w.EntityKey		   
			   and pod.InvoiceLineKey is NULL

			if isnull(@TotPO, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
			  from tPurchaseOrderDetail pod (nolock)
			      ,#tBillingDetail w
			 where w.Entity = 'Order'
			  and w.BillingKey = @BillingKey
			   and pod.PurchaseOrderDetailKey = w.EntityKey		   
			   and pod.InvoiceLineKey is NULL
					)			
				select @InsertLine = 1
			end
			   
			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)
		
			IF ISNULL(@BillingClassKey, 0) > 0
				SELECT @ClassKey = @BillingClassKey 
			ELSE
				SELECT @ClassKey = @DefaultClassKey 
			
			if @InsertLine = 1
			BEGIN

			--create single invoice line
				exec @RetVal = sptInvoiceLineInsertMassBilling
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,'No Billing Item'			-- Line Subject
					  ,NULL				    		-- Line description
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,@ParentInvoiceLineKey		-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@ClassKey              -- Class Key
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

				-- time
				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = ISNULL(#tBillingDetail.ServiceKey, tTime.ServiceKey)
					  ,RateLevel = ISNULL(#tBillingDetail.RateLevel, tTime.RateLevel)					  
					  ,BilledHours = #tBillingDetail.Quantity
					  ,BilledRate = #tBillingDetail.Rate
					  ,BilledComment = #tBillingDetail.Comments
				  from #tBillingDetail
				   where #tBillingDetail.Entity = 'tTime'
			       and #tBillingDetail.BillingKey = @BillingKey
				   and tTime.TimeKey = #tBillingDetail.EntityGuid					  
				   and tTime.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
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
				and tExpenseReceipt.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
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
				and tMiscCost.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -9					   	
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
				and tVoucherDetail.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				end

 				--po
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
				and tPurchaseOrderDetail.InvoiceLineKey is NULL
				and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey	

				if @@ERROR <> 0 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				end	   	
					  
				end  -- end of insert line

		-- End update for remaining lines  *************************************

	RETURN 1
GO
