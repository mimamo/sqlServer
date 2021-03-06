USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesGetTrans]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesGetTrans]
	(
	@BillingKey int
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 03/26/10 GHL 10.521 Creation for new layouts  
*/
	SET NOCOUNT ON 
	
	-- service for labor can be changed, get a good service if not updated
update #tBillingDetail
set    #tBillingDetail.ServiceKey = t.ServiceKey
from   tTime t (nolock)
where  #tBillingDetail.Entity = 'tTime'
and    #tBillingDetail.BillingKey = @BillingKey
and    #tBillingDetail.EntityGuid = t.TimeKey
and    isnull(#tBillingDetail.ServiceKey, 0) = 0   

  INSERT #tran(Entity, EntityGuid, Quantity, BilledAmount, Rate, RateLevel, WorkTypeKey, LayoutEntityKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityGuid, w.Quantity, w.Total, w.Rate, w.RateLevel
  , isnull(s.WorkTypeKey, 0), isnull(w.ServiceKey, 0), s.Description, w.Comments   
  FROM   #tBillingDetail w
	LEFT OUTER JOIN tService s (NOLOCK) ON w.ServiceKey = s.ServiceKey
  WHERE  w.Entity = 'tTime'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tMiscCost t (NOLOCK) ON t.MiscCostKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tMiscCost'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tExpenseReceipt t (NOLOCK) ON t.ExpenseReceiptKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tExpenseReceipt'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName, w.Comments  
  FROM  #tBillingDetail w
	INNER JOIN tVoucherDetail t (NOLOCK) ON t.VoucherDetailKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tVoucherDetail'
  AND    w.BillingKey = @BillingKey
 
  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tPurchaseOrderDetail t (NOLOCK) ON t.PurchaseOrderDetailKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tPurchaseOrderDetail'
  AND    w.BillingKey = @BillingKey


	RETURN 1
GO
