USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerProject]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerProject]
	(
	@NewInvoiceKey INT
	,@DefaultSalesAccountKey INT
	,@DefaultClassKey INT
	,@WorkTypeKey INT
	,@PostSalesUsingDetail INT
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parm OfficeKey, DepartmentKey
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
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
Declare @ProjectName varchar(100)
Declare @CurrProjectKey int
Declare @ProjectClassKey int
Declare @ClassKey int
		
		Select @CurrProjectKey = -1
		While 1=1
		begin

			Select @CurrProjectKey = MIN(t.ProjectKey)
			from  (Select Distinct ProjectKey
					From #tProcWIPKeys
				   ) As t
			Where t.ProjectKey > @CurrProjectKey
			
			if @CurrProjectKey is null
				break
		
			Select @ProjectName = ProjectName
					,@ProjectClassKey = ClassKey
			From   tProject (NOLOCK)
			Where  ProjectKey =	@CurrProjectKey
		
			IF ISNULL(@ProjectClassKey, 0) > 0
				SELECT @ClassKey = @ProjectClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey
			
			-- Time
			select @TotHours = isnull(sum(isnull(ActualHours,0)),0)
			      ,@TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
			  from tTime t (nolock) ,#tProcWIPKeys w
			 where w.EntityType = 'Time'
			   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			   and t.ProjectKey = w.ProjectKey
			   and w.ProjectKey = @CurrProjectKey
				
			--get expense receipts
			select @TotExpenseRcpt = isnull(sum(isnull(BillableCost,0)),0)
			  from tExpenseReceipt t (nolock), #tProcWIPKeys w
			 where w.EntityType = 'Expense'
			   and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
			   and t.ProjectKey = w.ProjectKey
			   and w.ProjectKey = @CurrProjectKey
			   
			--get misc expenses
			select @TotMiscExpense = isnull(sum(isnull(BillableCost,0)),0)
			  from tMiscCost t (nolock) ,#tProcWIPKeys w
			 where w.EntityType = 'MiscExpense'
			   and t.MiscCostKey = cast(w.EntityKey as integer)
			   and t.ProjectKey = w.ProjectKey
			   and w.ProjectKey = @CurrProjectKey
			  
			--get vouchers
			select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock),#tProcWIPKeys w
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
			   and t.ProjectKey = w.ProjectKey
			   and w.ProjectKey = @CurrProjectKey

			--get po's
			select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			  from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				   ,#tProcWIPKeys w
			 where w.EntityType = 'Order'
			   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			   and po.PurchaseOrderKey = pod.PurchaseOrderKey
			   and pod.ProjectKey = w.ProjectKey
			   and w.ProjectKey = @CurrProjectKey
			   
			--calc total expenses
			select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)
		
			if @TotExpenseRcpt + @TotMiscExpense + @TotVoucher + @TotLabor + @TotPO <> 0
			BEGIN

				exec @RetVal = sptInvoiceLineInsert
					  @NewInvoiceKey				-- Invoice Key
					  ,@CurrProjectKey				-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@ProjectName					-- Line Subject
					  ,null    						-- Line description
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@ClassKey		            -- Class Key
					  ,0							-- Taxable
					  ,0							-- Taxable2
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

				update tTime
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,BilledService = tTime.ServiceKey
					  ,BilledHours = tTime.ActualHours
					  ,BilledRate = tTime.ActualRate
				  from #tProcWIPKeys w 
				   where w.EntityType = 'Time'
				   and tTime.TimeKey = cast(w.EntityKey as uniqueidentifier)					  
				   and tTime.ProjectKey = w.ProjectKey
				   and w.ProjectKey = @CurrProjectKey
				if @@ERROR <> 0 
				 begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				  end
	
				update tExpenseReceipt
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys w
				 where w.EntityType = 'Expense'
				   and tExpenseReceipt.ExpenseReceiptKey = cast(w.EntityKey as integer)
				   and tExpenseReceipt.ProjectKey = w.ProjectKey
				   and w.ProjectKey = @CurrProjectKey
				if @@ERROR <> 0 
				 begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -8					   	
				  end
			 
				--misc expenses
				update tMiscCost
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys w
				 where w.EntityType = 'MiscExpense'
				   and tMiscCost.MiscCostKey = cast(w.EntityKey as integer)
				   and tMiscCost.ProjectKey = w.ProjectKey
				   and w.ProjectKey = @CurrProjectKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -9					   	
				  end
				  	
				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys w
				 where w.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(w.EntityKey as integer)
				   and tVoucherDetail.ProjectKey = w.ProjectKey
				   and w.ProjectKey = @CurrProjectKey
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
				  from #tProcWIPKeys w, tPurchaseOrder po (nolock)
				 where w.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and tPurchaseOrderDetail.ProjectKey = w.ProjectKey
				   and w.ProjectKey = @CurrProjectKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				 end
				 
			end  -- end of insert line
		end  -- Loop for projects
				   
				 
	
	RETURN 1
GO
