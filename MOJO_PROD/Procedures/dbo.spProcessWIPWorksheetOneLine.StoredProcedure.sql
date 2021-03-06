USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLine]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLine]
	(
		@NewInvoiceKey INT
		,@ProjectKey INT
		,@LineSubject VARCHAR(100)
		,@DefaultSalesAccountKey INT
		,@DefaultClassKey INT
		,@WorkTypeKey INT
		,@PostSalesUsingDetail INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parm OfficeKey, DepartmentKey
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
  
	SET NOCOUNT ON
	
declare @TotLabor money
declare @TotExpenseRcpt money
declare @TotMiscExpense money
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
declare @NewInvoiceLineKey int
declare @RetVal int

		    --get total hours/labor
		select @TotLabor = isnull(sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)), 0)
		  from tTime t (nolock)
		      ,#tProcWIPKeys w
		 where w.EntityType = 'Time'
		   and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
		   
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
		select @TotExpense = round((@TotExpenseRcpt+@TotMiscExpense+@TotVoucher+@TotLabor+@TotPO),2)	

		
		--create single invoice line
		exec @RetVal = sptInvoiceLineInsert
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@LineSubject					-- Line Subject
					  ,null                 		-- Line description
					  ,2                    		-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@DefaultClassKey             -- Class Key
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
			return -6					   	
		  end
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -6					   	
		  end					  
 		
 		exec sptInvoiceRecalcAmounts @NewInvoiceKey 
	
  		--associate time to invoice line
		--time
		update tTime
		   set InvoiceLineKey = @NewInvoiceLineKey
			  ,BilledService = ServiceKey
			  ,BilledHours = ActualHours
			 ,BilledRate = ActualRate
		  from #tProcWIPKeys
		 where #tProcWIPKeys.EntityType = 'Time'
		   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -7					   	
		  end
		  	   
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
 				
 		--po
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
