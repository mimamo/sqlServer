USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10546]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10546]

AS


Delete tTaskUser Where TaskKey is null and ServiceKey is null



Update tTransaction Set TransactionDate = dbo.fFormatDateNoTime(TransactionDate) Where DATEPART(HH, TransactionDate) <> 0
Update tCashTransaction Set TransactionDate = dbo.fFormatDateNoTime(TransactionDate) Where DATEPART(HH, TransactionDate) <> 0

Update tInvoice Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(HH, PostingDate) <> 0
Update tVoucher Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(HH, PostingDate) <> 0
Update tPayment Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(HH, PostingDate) <> 0
Update tCheck Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(HH, PostingDate) <> 0
Update tJournalEntry Set PostingDate = dbo.fFormatDateNoTime(PostingDate) Where DATEPART(HH, PostingDate) <> 0

Update tInvoice Set InvoiceDate = dbo.fFormatDateNoTime(InvoiceDate) Where DATEPART(HH, InvoiceDate) <> 0
Update tVoucher Set InvoiceDate = dbo.fFormatDateNoTime(InvoiceDate) Where DATEPART(HH, InvoiceDate) <> 0

--seeding of taxes on PO lines + setting SalesTaxAmount
declare @PurchaseOrderKey int
select @PurchaseOrderKey = -1
while (1=1)
begin
	select @PurchaseOrderKey = min(PurchaseOrderKey)
    from tPurchaseOrder (nolock)
    where PurchaseOrderKey > @PurchaseOrderKey

	if @PurchaseOrderKey is null
		break

    -- this will not do a rollup of the details to the header
	-- but we will simply populate the detail SalesTax1Amount and SalesTax2Amount
	exec sptPurchaseOrderRecalcAmountsConversion @PurchaseOrderKey
 
end

update tPurchaseOrderDetail set SalesTaxAmount = isnull(SalesTax1Amount, 0) + isnull(SalesTax2Amount, 0) 
update tPurchaseOrder set SalesTaxAmount = isnull(SalesTax1Amount, 0) + isnull(SalesTax2Amount, 0) 

delete tGLBudgetDetail
From tGLBudget b (nolock) 
inner join tGLBudgetDetail bd (nolock) on b.GLBudgetKey = bd.GLBudgetKey 
inner join tGLAccount gl (nolock) on bd.GLAccountKey = gl.GLAccountKey 
where b.CompanyKey <> gl.CompanyKey
GO
