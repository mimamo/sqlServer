USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerService]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerService]
	(
	@NewInvoiceKey INT
	,@BillingKey INT
	,@BillingMethod INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@BillingClassKey int
	,@ParentInvoiceLineKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

  /*
  || When     Who Rel		What
  || 05/22/07 GHL 8.4.2.2   Getting now services from billing detail instead of time record
  ||                        This was causing the time entry to be billed for the original service
  ||                        instead of the new one.
  || 07/09/07 GHL 8.5		Added logic for office/department  
  || 04/08/08 GHL 8.508 (23712) New logic for classes, remove reading of FixedFeeBillingClassDetail  
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments    
  || 07/29/09 GHL 10.505 (57778) Do not prevent the users from creating an invoice with 0 amount
  ||                      For this reason, use transaction count rather than amount to determine if 
  ||                      the invoice lines are needed  
  || 12/17/10 GHL 10.539 (97621) Removed amount recalcs to improve performance 
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
  
	SET NOCOUNT ON
	
declare @NewInvoiceLineKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @TotHours decimal(9,3)
declare @TotLabor money
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
Declare @InsertLine int

		If exists(
			Select 1
			from #tBillingDetail
			where #tBillingDetail.Entity = 'tTime'
			and #tBillingDetail.BillingKey = @BillingKey
			and ISNULL(#tBillingDetail.ServiceKey, 0) = 0)
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -30					   	
		  end
		
		Select @NextServiceKey = -1	 
		While 1=1
		begin
			Select @NextServiceKey = Min(#tBillingDetail.ServiceKey)
			from #tBillingDetail
			where #tBillingDetail.Entity = 'tTime'
			and #tBillingDetail.BillingKey = @BillingKey
			and #tBillingDetail.ServiceKey > @NextServiceKey
		
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
			
			Select @NextServiceName = ISNULL(@NextServiceName , 'No Service Specified')

			if not @LineWorkTypeKey is null
				Select @WorkTypeDescription = Description from tWorkType (nolock) Where WorkTypeKey = @LineWorkTypeKey
			
			if @SalesGLAccountKey is null
				Select @SalesGLAccountKey = @DefaultSalesAccountKey
			
			IF ISNULL(@BillingClassKey, 0) > 0
				SELECT @ClassKey = @BillingClassKey
			ELSE
				IF ISNULL(@ServiceClassKey, 0) > 0
					SELECT @ClassKey = @ServiceClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey
		
			--get total hours/labor
			select @TotHours = isnull(sum(isnull(Quantity,0)),0)
			      ,@TotLabor = isnull(sum(round(isnull(Quantity,0)*isnull(Rate,0), 2)), 0)
			  from #tBillingDetail w
			 where w.Entity = 'tTime'
     			and w.BillingKey = @BillingKey
			   and w.ServiceKey = @NextServiceKey

			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
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
						  ,@ParentInvoiceLineKey		-- parent line key
						  -- Default Sales AccountKey		Changed by Gil was initially DefaultSalesAccountKey
						  ,@SalesGLAccountKey			-- @DefaultSalesAccountKey		
						  ,@ClassKey         		    -- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@LineWorkTypeKey				-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,'tService'					-- Entity
						  ,@NextServiceKey				-- EntityKey	
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

			--exec sptInvoiceRecalcAmounts @NewInvoiceKey 

			update tTime
			   set InvoiceLineKey = @NewInvoiceLineKey
				  ,BilledService = #tBillingDetail.ServiceKey
				  ,RateLevel = #tBillingDetail.RateLevel
				  ,BilledHours = #tBillingDetail.Quantity
				  ,BilledRate = #tBillingDetail.Rate
				  ,BilledComment = #tBillingDetail.Comments
			  from #tBillingDetail
			 where #tBillingDetail.Entity = 'tTime'
				and #tBillingDetail.BillingKey = @BillingKey
				and #tBillingDetail.ServiceKey = @NextServiceKey
				and #tBillingDetail.EntityGuid = tTime.TimeKey
			   
			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -18					   	
			  end
		end 
	 
		--get expenses
			select @TotExpense = isnull(sum(isnull(Total,0)),0)
			  from #tBillingDetail w
			 where w.Entity <> 'tTime' -- Expenses
			and w.BillingKey = @BillingKey
			   
			select @InsertLine = 0   
			if isnull(@TotExpense, 0) <> 0
				select @InsertLine = 1  
			if @InsertLine = 0
			begin
				if exists (select 1
				  from #tBillingDetail w
				 where w.Entity <> 'tTime' -- Expenses
				and w.BillingKey = @BillingKey
				)
				select @InsertLine = 1
			end
			   
			--calc total expenses
			select @TotExpense = round((@TotExpense),2)

			IF ISNULL(@BillingClassKey, 0) > 0
				SELECT @ClassKey = @BillingClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey
		
			if @InsertLine = 1 
			begin
			
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
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
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
						  ,@ClassKey             -- Class Key
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
			and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
			if @@ERROR <> 0 
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -10				   	
			end	   
				
		end	-- expenses	  
	
	RETURN 1
GO
