USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixOrderAccrualOpeningTransaction]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixOrderAccrualOpeningTransaction]
	(
	@CompanyKey int
	)
AS
	SET NOCOUNT ON

	create table #temp(PurchaseOrderDetailKey int null, VoucherDetailKey int null, Amount money null, Entity varchar(20) null, EntityKey int null, PostingDate datetime null, UpdateFlag int null)

	insert #temp(PurchaseOrderDetailKey, Amount, Entity, EntityKey, PostingDate, UpdateFlag)
	select  pod.PurchaseOrderDetailKey, isnull(pod.AccruedCost, 0) , 'INVOICE', i.InvoiceKey, i.PostingDate, 0
	from    tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey =po.PurchaseOrderKey	
		inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	where i.CompanyKey = @CompanyKey
	and   isnull(i.OpeningTransaction, 0) = 1 
	and   i.Posted = 1
	And po.BillAt in (0,1)

	insert #temp(PurchaseOrderDetailKey, VoucherDetailKey, Amount, Entity, EntityKey, PostingDate, UpdateFlag)
	select  pod.PurchaseOrderDetailKey, vd.VoucherDetailKey, isnull(vd.PrebillAmount, 0) , 'VOUCHER', v.VoucherKey,v.PostingDate, 0
	from    tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey =po.PurchaseOrderKey	
		inner join tVoucherDetail vd (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	where v.CompanyKey = @CompanyKey
	and   isnull(v.OpeningTransaction, 0) = 1 
	and   v.Posted = 1
	And po.BillAt in (0,1)

	update #temp
	set    #temp.UpdateFlag = 1
	from   tTransactionOrderAccrual b (nolock)
	where  #temp.PurchaseOrderDetailKey = b.PurchaseOrderDetailKey 
    and    #temp.EntityKey = b.EntityKey 
	and    #temp.Entity = 'INVOICE'
	and    b.Entity = 'INVOICE'

	update #temp
	set    #temp.UpdateFlag = 1
	from   tTransactionOrderAccrual b (nolock)
	where  #temp.PurchaseOrderDetailKey = b.PurchaseOrderDetailKey 
    and    #temp.EntityKey = b.EntityKey 
	and    #temp.Entity = 'VOUCHER'
	and    b.Entity = 'VOUCHER'

	--select * from #temp order by PurchaseOrderDetailKey
	--return 1

	delete #temp where UpdateFlag = 1


	insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, AccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
	select PurchaseOrderDetailKey, @CompanyKey, Amount, -1, 'INVOICE', EntityKey, PostingDate
	from   #temp
	where  Entity = 'INVOICE'

	insert tTransactionOrderAccrual (PurchaseOrderDetailKey, VoucherDetailKey, CompanyKey, UnaccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
	select PurchaseOrderDetailKey, VoucherDetailKey, @CompanyKey, Amount, -1, 'VOUCHER', EntityKey, PostingDate
	from   #temp
	where  Entity = 'VOUCHER'

	RETURN 1
GO
