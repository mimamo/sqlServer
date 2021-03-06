USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetNoInvoice]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetNoInvoice]
	(
	@ProcessDate smalldatetime
	,@WriteOffReasonKey int
	)

AS -- Encrypt

	SET NOCOUNT ON

	Select @ProcessDate = ISNULL(@ProcessDate, GETDATE())
	
	-- Process Action 0, 2, 3 which do not require invoices
	
	--do write-offs ***************************************************************************************************************
	--time
		
		update tTime
	   set WriteOff = 1
	      ,BilledHours = 0
	      ,BilledRate = 0
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Time'
	   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
	   and #tProcWIPKeys.Action = 0
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Expense'
	   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 0
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'MiscExpense'
	   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 0
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set WriteOff = 1
	      ,AmountBilled = 0
	      ,WriteOffReasonKey = @WriteOffReasonKey
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Voucher'
	 and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 0
	if @@ERROR <> 0 
	 begin
		return -4					   	
	  end
	  	
	--delete write-offs
	delete #tProcWIPKeys
	 where Action = 0

	-- Determine if there are any billable charges (greg)
	if not exists(select 1 from #tProcWIPKeys)
	  begin
		return 1
	  end
	 
	--do Mark Billed ***************************************************************************************************************
	--time
	update tTime
	   set WriteOff = 0
	  ,BilledHours = tTime.ActualHours
	 ,BilledRate = tTime.ActualRate
	      ,InvoiceLineKey = 0
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Time'
	   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
	   and #tProcWIPKeys.Action = 2
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Expense'
	   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 2
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'MiscExpense'
	   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 2
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set WriteOff = 0
	      ,AmountBilled = BillableCost
	      ,InvoiceLineKey = 0
	      ,DateBilled = @ProcessDate
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Voucher'
	   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 2
	if @@ERROR <> 0 
	  begin
		return -4					 	
	  end
	  	
	--delete mark as billed
	delete #tProcWIPKeys
	 where Action = 2
	 
	-- Determine if there are any billable charges (greg)
	if not exists(select 1 from #tProcWIPKeys)
	  begin
		return 1
	  end
	
	-- End of Mark AS Billed Section *********************************************************************
	
	--do Mark On Hold ***************************************************************************************************************
	--time
	update tTime
	   set OnHold = 1
	from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Time'
	   and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
	   and #tProcWIPKeys.Action = 3
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	  	   
	--expenses	   
	update tExpenseReceipt
	   set OnHold = 1
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Expense'
	   and tExpenseReceipt.ExpenseReceiptKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 3
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	update tMiscCost
	   set OnHold = 1
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'MiscExpense'
	   and tMiscCost.MiscCostKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 3
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	update tVoucherDetail
	   set OnHold = 1
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Voucher'
	   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 3
	if @@ERROR <> 0 
	  begin
		return -4					   	
	  end

	--voucher	   
	update tPurchaseOrderDetail
	   set OnHold = 1
	  from #tProcWIPKeys
	 where #tProcWIPKeys.EntityType = 'Order'
	   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
	   and #tProcWIPKeys.Action = 3
	if @@ERROR <> 0 
	  begin
		return -5					   	
	  end
	  	
	--delete mark as on hold
	delete #tProcWIPKeys
	 where Action = 3


	RETURN 1
GO
