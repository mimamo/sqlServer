USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10513]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10513]
	AS

/*
|| When      Who Rel      What
|| 11/22/09  GHL 10.5.1.3 Added 2 new rights. Also a fix for DateBilled (only installed sites)
*/

	exec spConvertDBSeed
	
delete tRightAssigned
from   tRight r (nolock)
where  tRightAssigned.RightKey = r.RightKey 
and    r.RightID in ( 'prjTimeCompletedTask',  'prjExpenseCompletedTask')

insert tRightAssigned (EntityType, EntityKey, RightKey)
select 'Security Group', sg.SecurityGroupKey, r.RightKey
from   tSecurityGroup sg (nolock)
      ,tRight r (nolock)
where r.RightID in ( 'prjTimeCompletedTask',  'prjExpenseCompletedTask')

	Update tTime
	Set    tTime.DateBilled = i.PostingDate
	From   tInvoiceLine il (nolock)
          ,tInvoice i (nolock) 
	Where  
		tTime.InvoiceLineKey > 0
    --and  tTime.DateBilled is null
	and	 tTime.InvoiceLineKey = il.InvoiceLineKey
	and	 il.InvoiceKey = i.InvoiceKey 
      
	Update tExpenseReceipt
	Set    tExpenseReceipt.DateBilled = i.PostingDate
	From   tInvoiceLine il (nolock)
          ,tInvoice i (nolock) 
	Where  
		tExpenseReceipt.InvoiceLineKey > 0
    --and  tExpenseReceipt.DateBilled is null
	and	 tExpenseReceipt.InvoiceLineKey = il.InvoiceLineKey
	and	 il.InvoiceKey = i.InvoiceKey 
      
	Update tMiscCost
	Set    tMiscCost.DateBilled = i.PostingDate
	From   tInvoiceLine il (nolock)
          ,tInvoice i (nolock) 
	Where  
		tMiscCost.InvoiceLineKey > 0
    --and  tMiscCost.DateBilled is null
	and	 tMiscCost.InvoiceLineKey = il.InvoiceLineKey
	and	 il.InvoiceKey = i.InvoiceKey 	

	Update tVoucherDetail
	Set    tVoucherDetail.DateBilled = i.PostingDate
	From   tInvoiceLine il (nolock)
          ,tInvoice i (nolock) 
	Where  
		tVoucherDetail.InvoiceLineKey > 0
    --and  tVoucherDetail.DateBilled is null
	and	 tVoucherDetail.InvoiceLineKey = il.InvoiceLineKey
	and	 il.InvoiceKey = i.InvoiceKey 	

	

	Update tPurchaseOrderDetail
	Set    tPurchaseOrderDetail.DateBilled = i.PostingDate
	From   tInvoiceLine il (nolock)
          ,tInvoice i (nolock) 
	Where  
		tPurchaseOrderDetail.InvoiceLineKey > 0
    --and  tPurchaseOrderDetail.DateBilled is null
	and	 tPurchaseOrderDetail.InvoiceLineKey = il.InvoiceLineKey
	and	 il.InvoiceKey = i.InvoiceKey
GO
