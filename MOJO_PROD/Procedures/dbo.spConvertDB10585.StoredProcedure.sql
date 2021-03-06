USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10585]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spConvertDB10585]
AS

	--Default the CCDeliveryOption to 0 just to be safe (in case an ISNULL/OverrideBlank is missed somewhere)
	UPDATE tGLAccount SET CCDeliveryOption = 0

	-- set tInvoice.BillingKey to prevent the generation of duplicate invoices
	update tInvoice
	set    tInvoice.BillingKey = b.BillingKey
	from   tBilling b (nolock)
	where  tInvoice.InvoiceKey = b.InvoiceKey 

	-- because parent and children WS are associated with the same invoice
	-- make sure that the parent WS is set on the invoice 
	update tInvoice
	set    tInvoice.BillingKey = b.BillingKey
	from   tBilling b (nolock)
	where  tInvoice.InvoiceKey = b.InvoiceKey 
	and    b.ParentWorksheet = 1

-- correction of spConvertDB10584
-- take in consideration po.BillAt + vendor invoice applications
update tPurchaseOrderDetail
set    tPurchaseOrderDetail.AmountBilled = CASE isnull(po.BillAt, 0) 
	WHEN 0 THEN ISNULL(tPurchaseOrderDetail.BillableCost, 0)
	WHEN 1 THEN ISNULL(tPurchaseOrderDetail.TotalCost,0)
	WHEN 2 THEN ISNULL(tPurchaseOrderDetail.BillableCost,0) - ISNULL(tPurchaseOrderDetail.TotalCost,0) 
END
from   tPurchaseOrder po (nolock)
where  tPurchaseOrderDetail.Closed = 1
and    tPurchaseOrderDetail.InvoiceLineKey = 0
and   tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
and    po.BillAt > 0

update tPurchaseOrderDetail
set    tPurchaseOrderDetail.AmountBilled = 0
from   tVoucherDetail vd (nolock)
where  tPurchaseOrderDetail.Closed = 1
and    tPurchaseOrderDetail.InvoiceLineKey = 0
and    tPurchaseOrderDetail.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey


	-- Now set the Transfer Source Key on all transfers
	------------------------------------------------------
	declare @CircuitBreaker int	

	-- set the root on the root (TransferFromKey is null) 
	update tVoucherDetail
	set    RootTransferFromKey = VoucherDetailKey
	where  RootTransferFromKey is null
	and    TransferFromKey is null --never xferred before
	and    TransferToKey is not null

	-- set the root on the transferred to data
	-- need to take care of data Xferred from 1 project to another and another...not more than 10 loops 
	select @CircuitBreaker = 1
	while (1=1)
	begin 
		update tVoucherDetail
		set    tVoucherDetail.RootTransferFromKey = b.RootTransferFromKey
		from   tVoucherDetail (nolock)
		inner join tVoucherDetail b (nolock) on tVoucherDetail.TransferFromKey = b.VoucherDetailKey
		where  tVoucherDetail.RootTransferFromKey is null
		and    b.RootTransferFromKey is not null 

		if @@ROWCOUNT = 0
			break
		
		select @CircuitBreaker = @CircuitBreaker + 1
		if @CircuitBreaker > 10
			break 
	end


	-- set the root on the root (TransferFromKey is null) 
	update tPurchaseOrderDetail
	set    RootTransferFromKey = PurchaseOrderDetailKey
	where  RootTransferFromKey is null
	and    TransferFromKey is null --never xferred before
	and    TransferToKey is not null

	-- set the root on the transferred to data
	-- need to take care of data Xferred from 1 project to another and another...not more than 10 loops 
	select @CircuitBreaker = 1
	while (1=1)
	begin 
		update tPurchaseOrderDetail
		set    tPurchaseOrderDetail.RootTransferFromKey = b.RootTransferFromKey
		from   tPurchaseOrderDetail (nolock)
		inner join tPurchaseOrderDetail b (nolock) on tPurchaseOrderDetail.TransferFromKey = b.PurchaseOrderDetailKey
		where  tPurchaseOrderDetail.RootTransferFromKey is null
		and    b.RootTransferFromKey is not null 

		if @@ROWCOUNT = 0
			break
		
		select @CircuitBreaker = @CircuitBreaker + 1
		if @CircuitBreaker > 10
			break 
	end



	-- set the root on the root (TransferFromKey is null) 
	update tExpenseReceipt
	set    RootTransferFromKey = ExpenseReceiptKey
	where  RootTransferFromKey is null
	and    TransferFromKey is null --never xferred before
	and    TransferToKey is not null

	-- set the root on the transferred to data
	-- need to take care of data Xferred from 1 project to another and another...not more than 10 loops 
	select @CircuitBreaker = 1
	while (1=1)
	begin 
		update tExpenseReceipt
		set    tExpenseReceipt.RootTransferFromKey = b.RootTransferFromKey
		from   tExpenseReceipt (nolock)
		inner join tExpenseReceipt b (nolock) on tExpenseReceipt.TransferFromKey = b.ExpenseReceiptKey
		where  tExpenseReceipt.RootTransferFromKey is null
		and    b.RootTransferFromKey is not null 

		if @@ROWCOUNT = 0
			break
		
		select @CircuitBreaker = @CircuitBreaker + 1
		if @CircuitBreaker > 10
			break 
	end

	-- set the root on the root (TransferFromKey is null) 
	update tMiscCost
	set    RootTransferFromKey = MiscCostKey
	where  RootTransferFromKey is null
	and    TransferFromKey is null --never xferred before
	and    TransferToKey is not null

	-- set the root on the transferred to data
	-- need to take care of data Xferred from 1 project to another and another...not more than 10 loops 
	select @CircuitBreaker = 1
	while (1=1)
	begin 
		update tMiscCost
		set    tMiscCost.RootTransferFromKey = b.RootTransferFromKey
		from   tMiscCost (nolock)
		inner join tMiscCost b (nolock) on tMiscCost.TransferFromKey = b.MiscCostKey
		where  tMiscCost.RootTransferFromKey is null
		and    b.RootTransferFromKey is not null 

		if @@ROWCOUNT = 0
			break
		
		select @CircuitBreaker = @CircuitBreaker + 1
		if @CircuitBreaker > 10
			break 
	end

	create table #time (TimeKey uniqueidentifier null
		, TransferFromKey uniqueidentifier null, TransferToKey uniqueidentifier null
		,TransferSourceKey uniqueidentifier null
		)
	  
	insert #time (TimeKey, TransferFromKey, TransferToKey)
	select TimeKey, TransferFromKey, TransferToKey from tTime (nolock)
	where TransferToKey is not null
	or TransferFromKey is not null	 

	create index time_convert_1 on #time(TransferFromKey, TransferToKey)
	create index time_convert_2 on #time(TimeKey)

	-- set the root on the root (TransferFromKey is null) 
	update #time
	set    TransferSourceKey = TimeKey
	--where  TransferSourceKey is null
	where    TransferFromKey is null --never xferred before
	and    TransferToKey is not null

	-- set the root on the transferred to data
	-- need to take care of data Xferred from 1 project to another and another...not more than 10 loops 
	select @CircuitBreaker = 1
	while (1=1)
	begin 
		update #time
		set    #time.TransferSourceKey = b.TransferSourceKey
		from   #time (nolock)
		inner join #time b (nolock) on #time.TransferFromKey = b.TimeKey
		where  #time.TransferSourceKey is null
		and    b.TransferSourceKey is not null 
		
		if @@ROWCOUNT = 0
			break
		
		select @CircuitBreaker = @CircuitBreaker + 1
		if @CircuitBreaker > 10
			break 
	end

	update tTime
	set    tTime.TransferSourceKey = b.TransferSourceKey
	from   #time b
	where  tTime.TimeKey = b.TimeKey

   -- End Transfers
   --------------------------------------------------------------------------------
GO
