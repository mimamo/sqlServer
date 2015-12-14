USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerBillingItem]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerBillingItem]
	(
	@CompanyKey int	
	,@NewInvoiceKey INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt
  /*
  || When   Who         Rel    What
  || BSH    01/16/07    8.4001 Changed condition for total <> 0 instead of > 0 for issue #7890.
  || GHL    04/25/07    8.5    Added Taxable fields (Enh 7150)
  || GHL    06/29/07    8.5    Added new parm OfficeKey, DepartmentKey
  || QMD    07/10/07    8.5    Expense Type reference changed to tItem
  || GHL    01/09/08    8.501 (18967) Creating now invoice lines in alphabetical order
  || GHL    04/07/08    8.508 (23712) Added new requirements for classes
  || GHL    04/22/09   10.024 Setting now AccruedCost only if po.BillAt in (0,1)  
  || GHL    04/12/10   10.521 (75825) Line description is now a text field, cannot be held in a variable
  || GHL    12/27/11   10.551 (129332) Insert invoice line based on presence of records, not on billed amount <> 0
  ||                          (96484) Looping now using WorkTypeID instead of WorkTypeName
  ||                          because WorkTypeID is unique but WorkTypeName is not   
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency 
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

			IF ISNULL(@InvoiceByClassKey, 0) > 0
				SELECT @ClassKey = @InvoiceByClassKey
			ELSE
				IF ISNULL(@WorkTypeClassKey, 0) > 0
					SELECT @ClassKey = @WorkTypeClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey

			select @InsertLine = 0

			-- Time
			select @TotHours = isnull(sum(isnull(ActualHours,0)),0)
			      ,@TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
			  from tTime t (nolock) ,#tProcWIPKeys w, tService s (nolock)
			 where w.EntityType = 'Time'
			   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			   and t.ServiceKey = s.ServiceKey
			   and s.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotLabor, 0) <> 0
				select @InsertLine = 1
			
			if @InsertLine = 0
			begin
				if exists (select 1
					from tTime t (nolock) ,#tProcWIPKeys w, tService s (nolock)
				where w.EntityType = 'Time'
			   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			   and t.ServiceKey = s.ServiceKey
			   and s.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end


			--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
			  from tExpenseReceipt t (nolock)
			  ,#tProcWIPKeys w, tItem i
			 where w.EntityType = 'Expense'
			   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
			   and t.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey
			   
			if isnull(@TotExpenseRcpt, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tExpenseReceipt t (nolock)
				  ,#tProcWIPKeys w, tItem i
				 where w.EntityType = 'Expense'
				   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
				   and t.ItemKey = i.ItemKey
				   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end

			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
			  from tMiscCost t (nolock)
			      ,#tProcWIPKeys w, tItem i
			 where w.EntityType = 'MiscExpense'
			   and t.MiscCostKey = cast(w.EntityKey as integer)
			   and t.ItemKey = i.ItemKey
			  and i.WorkTypeKey = @NextWorkTypeKey
			  
			  if isnull(@TotMiscExpense, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tMiscCost t (nolock)
			      ,#tProcWIPKeys w, tItem i
					where w.EntityType = 'MiscExpense'
					and t.MiscCostKey = cast(w.EntityKey as integer)
					and t.ItemKey = i.ItemKey
					and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end

			--get vouchers
			select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tProcWIPKeys w, tItem i (nolock)
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
			   and t.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotVoucher, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
					from tVoucherDetail t (nolock)
			      ,#tProcWIPKeys w, tItem i (nolock)
				 where w.EntityType = 'Voucher'
				   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
				   and t.ItemKey = i.ItemKey
				   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end

			--get po's
			select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			  from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				   ,#tProcWIPKeys w, tItem i (nolock)
			 where w.EntityType = 'Order'
			   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			   and po.PurchaseOrderKey = pod.PurchaseOrderKey
			   and pod.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey

			if isnull(@TotPO, 0) <> 0
				select @InsertLine = 1
				
			if @InsertLine = 0
			begin
				if exists (select 1
				from tPurchaseOrderDetail pod (nolock)
				   ,#tProcWIPKeys w, tItem i (nolock)
			 where w.EntityType = 'Order'
			   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			   and pod.ItemKey = i.ItemKey
			   and i.WorkTypeKey = @NextWorkTypeKey
					)			
				select @InsertLine = 1
			end

			
			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)
		
			--if @TotExpenseRcpt + @TotMiscExpense + @TotVoucher + @TotLabor + @TotPO <> 0
			if @InsertLine = 1
			BEGIN

				exec @RetVal = sptInvoiceLineInsert
					  @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@WorkTypeName				-- Line Subject
					  ,NULL                         -- Line description...text field cannot be held in a var
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@SalesGLAccountKey			-- Default Sales AccountKey
					  ,@ClassKey			        -- Class Key
					  ,@Taxable						-- Taxable
					  ,@Taxable2					-- Taxable2
					  ,@NextWorkTypeKey				-- Work TypeKey
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

				-- only now can we update the line with a text field
				update tInvoiceLine
				set    tInvoiceLine.LineDescription = wt.Description
				from   tWorkType wt (nolock)
				where  wt.WorkTypeKey = @NextWorkTypeKey
				and    tInvoiceLine.InvoiceLineKey = @NewInvoiceLineKey

				exec sptInvoiceRecalcAmounts @NewInvoiceKey 

				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = tTime.ServiceKey
					  ,BilledHours = tTime.ActualHours
					  ,BilledRate = tTime.ActualRate
				  from #tProcWIPKeys, tService (nolock)
				   where #tProcWIPKeys.EntityType = 'Time'
				   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)					  
				   and tTime.ServiceKey = tService.ServiceKey
				   and tService.WorkTypeKey = @NextWorkTypeKey
				if @@ERROR <> 0 
				 begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				  end
	
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys, tItem (nolock)
				 where #tProcWIPKeys.EntityType = 'Expense'
				   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
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
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys, tItem (nolock)
				 where #tProcWIPKeys.EntityType = 'MiscExpense'
				   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
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
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys, tItem (nolock)
				 where #tProcWIPKeys.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
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
					  ,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
				  from #tProcWIPKeys, tItem (nolock), tPurchaseOrder po (nolock)
				 where #tProcWIPKeys.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
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



			-- Time
			select @TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
			  from tTime t (nolock) ,#tProcWIPKeys w
			 where w.EntityType = 'Time'
			 and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			   and t.InvoiceLineKey is NULL

			--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
			  from tExpenseReceipt t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Expense'
			   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
			   and t.InvoiceLineKey is NULL
			   
			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
			  from tMiscCost t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'MiscExpense'
			   and t.MiscCostKey = cast(w.EntityKey as integer)
			   and t.InvoiceLineKey is NULL
			   
			--get vouchers
			select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
			   and t.InvoiceLineKey is NULL
			   
			--get Orders
			select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			  from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Order'
			   and po.PurchaseOrderKey = pod.PurchaseOrderKey
			   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)		   
			   and pod.InvoiceLineKey is NULL

			   
			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)
		
			if @TotExpenseRcpt + @TotMiscExpense + @TotVoucher + @TotLabor + @TotPO <> 0
			BEGIN

				IF ISNULL(@InvoiceByClassKey, 0) > 0
					SELECT @ClassKey = @InvoiceByClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey
					
			--create single invoice line
				exec @RetVal = sptInvoiceLineInsert
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
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@ClassKey					-- Class Key
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

				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = tTime.ServiceKey
					  ,BilledHours = tTime.ActualHours
					  ,BilledRate = tTime.ActualRate
				  from #tProcWIPKeys
				   where #tProcWIPKeys.EntityType = 'Time'
				   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)					  
				   and tTime.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				  end
			 
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Expense'
				   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and tExpenseReceipt.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					  	
				  end
			 
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'MiscExpense'
				   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
				 and tMiscCost.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -9					 	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys
				 where #tProcWIPKeys.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and tVoucherDetail.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
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
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				   and tPurchaseOrderDetail.InvoiceLineKey is NULL
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				  end
				  
			end  -- end of insert line

		-- End update for remaining lines  *************************************

	RETURN 1
GO
