USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetExpenseList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetExpenseList]

	 @BillingKey int
	 ,@ItemKey int = 0

as --Encrypt

  /*
  || When   Who         Rel    What
  || QMD    07/10/07    8.5    Expense Type reference changed to tItem
  || GHL    01/08/08    8.5    Changed Union All to Union to remove duplicates since expenses 
  ||                           types like Hotel can be in exp receipts and voucher details now
  || GHL    05/31/11   10.545 (112280) Added @ItemKey because users can create a billing worksheet with zero billable amounts
  ||                     so that they can decide on billing them or marking them up as billed to clean them up like on the transactions screen 
  ||                     Problem is that worksheet_tm.aspx shows 0 amounts and the users can click on an item but will show as All Items on
  ||                     worksheet_tm_popup.aspx   
  */

    create table #expense (EntityKey int null, EntityID varchar(300) null)

	insert #expense (EntityKey, EntityID)

	select -1 as EntityKey	   
		  ,'[No Expense Item]' as EntityID
	
	union

	select Distinct i.ItemKey as EntityKey
		  ,i.ItemName as EntityID
	  from tBillingDetail bd (nolock)
	       inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
	       inner join tItem i (nolock) on er.ItemKey = i.ItemKey
	 where bd.Entity = 'tExpenseReceipt'
	   and bd.BillingKey = @BillingKey
	   and isnull(i.ItemKey, 0) > 0
	   
	union
	
	
	select Distinct i.ItemKey as EntityKey
		  ,i.ItemName as EntityID
	  from tBillingDetail bd (nolock)
	       inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
	       inner join tItem i (nolock) on mc.ItemKey = i.ItemKey
	 where bd.Entity = 'tMiscCost'
	   and bd.BillingKey = @BillingKey
       and isnull(mc.ItemKey, 0) > 0
       		
	union 
	
	
	select Distinct i.ItemKey as EntityKey
		  ,i.ItemName as EntityID
	  from tBillingDetail bd (nolock)
	       inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
	       inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
	 where bd.Entity = 'tVoucherDetail'
	   and bd.BillingKey = @BillingKey
       and isnull(vd.ItemKey, 0) > 0

	union 
	
	
	select Distinct i.ItemKey as EntityKey
	      ,i.ItemName as EntityID
	  from tBillingDetail bd (nolock)
	       inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey
	       inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
	 where bd.Entity = 'tPurchaseOrderDetail'
	   and bd.BillingKey = @BillingKey
       and isnull(pod.ItemKey, 0) > 0

	if @ItemKey > 0
		begin
			if not exists (select 1 from #expense where EntityKey = @ItemKey)
			insert #expense
			  (EntityKey
			  ,EntityID
			  )
			select ItemKey
				  ,ItemName
			  from tItem (nolock) 
			 where ItemKey = @ItemKey 
		
		end 
	

	select Distinct EntityKey
	      ,EntityID
	  from #expense    
  group by EntityKey, EntityID
  order by EntityID
  


	return 1
GO
