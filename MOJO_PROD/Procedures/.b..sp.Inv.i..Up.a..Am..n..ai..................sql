USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdateAmountPaid]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdateAmountPaid]

	(
		@InvoiceKey int
		,@VouchersOnly int = 0
	)

AS

/*
|| When     Who Rel   What
|| 12/18/06 GWG 8.4   Update the date paid on vouchers for case when the PO is prebilled.
|| 12/16/08 GHL 10.015 (41844) Changed logic in sptVoucherGetMaxDate and decided to use that sp to set tVoucherDetail.DatePaidByClient
||                    At the difference with sptVoucherGetMaxDate that processes vouchers from the reg to the adv bill invoice 
||                    we process voucher lines from the adv bill invoice to the reg invoice
|| 10/07/10 GHL 10.537 Added parameter @VouchersOnly so that we can use it in sptInvoiceSave to update vouchers only
*/

Declare @PaidAmount money, @RetainerAmount money, @CreditAmount money, @InvoiceAmount money, @DatePaid smalldatetime, @CreditedAmount money, @AdvanceBill int

Select @PaidAmount = ISNULL(sum(Amount), 0) from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey
Select @CreditAmount = ISNULL(sum(Amount), 0) from tInvoiceCredit (nolock) Where InvoiceKey = @InvoiceKey
Select @CreditedAmount = ISNULL(sum(Amount), 0) * -1 from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey

Update tInvoice
	Set AmountReceived = @PaidAmount + @CreditAmount + @CreditedAmount
	Where InvoiceKey = @InvoiceKey
	
	
Select @InvoiceAmount = InvoiceTotalAmount, @RetainerAmount = ISNULL(RetainerAmount, 0), @AdvanceBill = AdvanceBill
From tInvoice (nolock)
Where InvoiceKey = @InvoiceKey

-- Use now common function to determine tVoucherDetail.DatePaidByClient

-- First process voucher details linked to the current invoice (regular or advance bill)
declare @VoucherDetailKey int
select @VoucherDetailKey = -1
while (1=1)
begin
	select @VoucherDetailKey = min(vd.VoucherDetailKey)
	from   tInvoiceLine il (nolock) 
		inner join tVoucherDetail vd (nolock) on il.InvoiceLineKey = vd.InvoiceLineKey
	where  il.InvoiceKey = @InvoiceKey
	and    vd.VoucherDetailKey > @VoucherDetailKey
	
	if @VoucherDetailKey is null
		break
	
	exec sptVoucherGetMaxDate @VoucherDetailKey
	
end

select @VoucherDetailKey = -1
while (1=1)
begin
	select @VoucherDetailKey = min(vd.VoucherDetailKey)
	from   tInvoiceLine il (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey 
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	where  il.InvoiceKey = @InvoiceKey
	and    vd.VoucherDetailKey > @VoucherDetailKey
	
	if @VoucherDetailKey is null
		break
	
	exec sptVoucherGetMaxDate @VoucherDetailKey
	
end

-- Second process voucher details linked to the regular invoices associated to the current invoice
-- if the current invoice is an Advance Bill !!!!! 

if (@AdvanceBill = 0)
	Return 1
	
select @VoucherDetailKey = -1
while (1=1)
begin
	select @VoucherDetailKey = min(vd.VoucherDetailKey)
	from   tInvoiceAdvanceBill iab (nolock)
		inner join tInvoiceLine il (nolock) on iab.InvoiceKey = il.InvoiceKey 
		inner join tVoucherDetail vd (nolock) on il.InvoiceLineKey = vd.InvoiceLineKey
	where  iab.AdvBillInvoiceKey = @InvoiceKey
	and    vd.VoucherDetailKey > @VoucherDetailKey
	
	if @VoucherDetailKey is null
		break
	
	exec sptVoucherGetMaxDate @VoucherDetailKey
	
end

select @VoucherDetailKey = -1
while (1=1)
begin
	select @VoucherDetailKey = min(vd.VoucherDetailKey)
	from   tInvoiceAdvanceBill iab (nolock)
		inner join tInvoiceLine il (nolock) on iab.InvoiceKey = il.InvoiceKey 
		inner join tPurchaseOrderDetail pod (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey 
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	where  iab.AdvBillInvoiceKey = @InvoiceKey
	and    vd.VoucherDetailKey > @VoucherDetailKey
	
	if @VoucherDetailKey is null
		break
	
	exec sptVoucherGetMaxDate @VoucherDetailKey
	
end

Return 1

/*
if @InvoiceAmount = @PaidAmount + @CreditAmount + @CreditedAmount + @RetainerAmount
BEGIN
	Select @DatePaid = CAST(CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
END
else
	Select @DatePaid = NULL
	
	
Update
	tVoucherDetail
Set
	DatePaidByClient = @DatePaid
From
	tVoucherDetail 
	inner join tPurchaseOrderDetail (nolock) on tVoucherDetail.PurchaseOrderDetailKey = tPurchaseOrderDetail.PurchaseOrderDetailKey
	inner join tInvoiceLine (nolock) on tInvoiceLine.InvoiceLineKey = tPurchaseOrderDetail.InvoiceLineKey
Where 
	tInvoiceLine.InvoiceKey = @InvoiceKey
	
Update
	tVoucherDetail
Set
	DatePaidByClient = @DatePaid
From
	tVoucherDetail 
	inner join tInvoiceLine (nolock) on tInvoiceLine.InvoiceLineKey = tVoucherDetail.InvoiceLineKey
Where 
	tInvoiceLine.InvoiceKey = @InvoiceKey
	

Update
	tVoucherDetail
Set
	DatePaidByClient = @DatePaid
From
	tVoucherDetail 
	inner join tPurchaseOrderDetail (nolock) on tPurchaseOrderDetail.PurchaseOrderDetailKey = tVoucherDetail.PurchaseOrderDetailKey
	inner join tInvoiceLine (nolock) on tInvoiceLine.InvoiceLineKey = tPurchaseOrderDetail.InvoiceLineKey
Where 
	tInvoiceLine.InvoiceKey = @InvoiceKey
*/
GO
