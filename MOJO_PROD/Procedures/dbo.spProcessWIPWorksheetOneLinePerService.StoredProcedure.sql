USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerService]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerService]
	(
	@NewInvoiceKey INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parm OfficeKey, DepartmentKey
  || 04/07/08 GHL 8.508 (23712) Added new requirements for classes
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */

	SET NOCOUNT ON
	
declare @NewInvoiceLineKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @TotHours decimal(9,3)
declare @TotLabor money
declare @TotExpenseRcpt money
declare @TotMiscExpense money
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
declare @Taxable tinyint
declare @Taxable2 tinyint
Declare @SalesGLAccountKey int 
Declare @WorkTypeDescription varchar(500)
Declare @NextServiceKey int
Declare @NextServiceName varchar(200)
Declare @LineWorkTypeKey int
Declare @ServiceClassKey int
Declare @ClassKey int

		If exists(
			Select 1
			from #tProcWIPKeys, tTime (nolock)
			where #tProcWIPKeys.EntityType = 'Time'
			and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
			and #tProcWIPKeys.Action = 1
			and ISNULL(tTime.ServiceKey, 0) = 0)
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -30					   	
		  end
		
		Select @NextServiceKey = -1	 
		While 1=1
		begin
			Select @NextServiceKey = Min(tTime.ServiceKey)
			from #tProcWIPKeys, tTime (nolock)
			where #tProcWIPKeys.EntityType = 'Time'
			and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
			and #tProcWIPKeys.Action = 1
			and tTime.ServiceKey > @NextServiceKey
		
			if @NextServiceKey is null
				break
			
			-- Changed by Gil, get the SalesGLAccountKey from the tService not from tWorkType
			Select @SalesGLAccountKey = GLAccountKey
					, @NextServiceName = Description
					, @Taxable = ISNULL(Taxable, 0)
					, @Taxable2 = ISNULL(Taxable2, 0)
					, @LineWorkTypeKey = WorkTypeKey 
					, @ServiceClassKey = ClassKey
			From tService (nolock) Where ServiceKey = @NextServiceKey

			IF ISNULL(@InvoiceByClassKey, 0) > 0
				SELECT @ClassKey = @InvoiceByClassKey
			ELSE
				IF ISNULL(@ServiceClassKey, 0) > 0
					SELECT @ClassKey = @ServiceClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey
						
			Select @NextServiceName = ISNULL(@NextServiceName , 'No Service Specified')

			if not @LineWorkTypeKey is null
				Select @WorkTypeDescription = Description from tWorkType (nolock) Where WorkTypeKey = @LineWorkTypeKey
			
			if @SalesGLAccountKey is null
				Select @SalesGLAccountKey = @DefaultSalesAccountKey
				
			--get total hours/labor
			select @TotHours = isnull(sum(isnull(ActualHours,0)),0)
			      ,@TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
			  from tTime t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Time'
			   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			   and t.ServiceKey = @NextServiceKey

			--create single invoice line
			exec @RetVal = sptInvoiceLineInsert
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@NextServiceName				-- Line Subject
						  ,@WorkTypeDescription    		-- Line description
						  ,2               				-- Bill From 
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,@TotLabor					-- Line Amount
						  ,2							-- line type
						  ,0							-- parent line key
						  -- Default Sales AccountKey		Changed by Gil was initially DefaultSalesAccountKey
						  ,@SalesGLAccountKey			-- @DefaultSalesAccountKey		
						  ,@ClassKey 					-- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@LineWorkTypeKey				-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,'tService'							-- Entity
						  ,@NextServiceKey						-- EntityKey						  
						  ,NULL									-- OfficeKey
						  ,NULL									-- DepartmentKey
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
				  ,BilledService = ServiceKey
				  ,BilledHours = ActualHours
				  ,BilledRate = ActualRate
			  from #tProcWIPKeys
			 where #tProcWIPKeys.EntityType = 'Time'
			   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)					  
			   and tTime.ServiceKey = @NextServiceKey
			   
			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -18					   	
			  end
		end 
	 
		--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
			  from tExpenseReceipt t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Expense'
			   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)		 
			   
			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
			  from tMiscCost t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'MiscExpense'
			   and t.MiscCostKey = cast(w.EntityKey as integer)		   
			   
			--get vouchers
			select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
		
			--get po's
			select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			from tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
			inner join #tProcWIPKeys w on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			where w.EntityType = 'Order'

			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotPO),2)
		
			IF ISNULL(@InvoiceByClassKey, 0) > 0
				SELECT @ClassKey = @InvoiceByClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey
					
			if @TotExpenseRcpt + @TotMiscExpense + @TotVoucher + @TotPO <> 0

			--create single invoice line
			exec @RetVal = sptInvoiceLineInsert
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,'Expenses'					-- Line Subject
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

			--expenses	   
			update tExpenseReceipt
			   set InvoiceLineKey = @NewInvoiceLineKey
				  ,AmountBilled = BillableCost
			  from #tProcWIPKeys
			 where #tProcWIPKeys.EntityType = 'Expense'
			   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
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
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -10			   	
				end


	
	RETURN 1
GO
