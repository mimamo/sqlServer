USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetGetTrans]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetGetTrans]
	(
	@ProjectKey int
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 10/04/12 GHL 10.561 Creation to support new billing option in mass billing:
||                     One Invoice Per Client
||                     One Line Item Per Project then Billing Item and Item 
||                     Similar to spBillingLinesGetTrans
|| 12/03/14 GHL 10.587 (237117) Need to support now 'One Line per Service and Item'
||                     with or without a project
*/

/*
This converts data from #tProcWIPKeys to #tran
#tran is used by the routines used by the billing worksheets
*/
	SET NOCOUNT ON
	 
	if @ProjectKey = 0
		select @ProjectKey = null

  INSERT #tran(Entity, EntityGuid, Quantity, BilledAmount, Rate, RateLevel, WorkTypeKey, LayoutEntityKey, ItemName)
  SELECT 'tTime', t.TimeKey, ActualHours, round(isnull(ActualHours,0)*isnull(ActualRate,0), 2), t.ActualRate, t.RateLevel
  , isnull(s.WorkTypeKey, 0), isnull(t.ServiceKey, 0), s.Description  
  FROM   #tProcWIPKeys a
	INNER JOIN tTime t (NOLOCK) ON t.TimeKey = cast(a.EntityKey as uniqueidentifier)
	LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
  WHERE  a.EntityType = 'Time'
  AND    (@ProjectKey is null or a.ProjectKey = @ProjectKey)

  
  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName)
  SELECT 'tMiscCost', t.MiscCostKey, Quantity, isnull(BillableCost, 0)
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName   
  FROM   #tProcWIPKeys a
	INNER JOIN tMiscCost t (NOLOCK) ON t.MiscCostKey = cast(a.EntityKey as integer)
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  a.EntityType = 'MiscExpense'
  AND    (@ProjectKey is null or a.ProjectKey = @ProjectKey)

  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName)
  SELECT 'tExpenseReceipt', t.ExpenseReceiptKey, ActualQty, isnull(BillableCost, 0)
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0),  i.ItemName    
  FROM   #tProcWIPKeys a
	INNER JOIN tExpenseReceipt t (NOLOCK) ON t.ExpenseReceiptKey = cast(a.EntityKey as integer)
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  a.EntityType = 'Expense'
  AND    (@ProjectKey is null or a.ProjectKey = @ProjectKey)

  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName)
  SELECT 'tVoucherDetail', t.VoucherDetailKey, Quantity, isnull(BillableCost, 0)
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), i.ItemName    
  FROM   #tProcWIPKeys a
	INNER JOIN tVoucherDetail t (NOLOCK) ON t.VoucherDetailKey = cast(a.EntityKey as integer)
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  a.EntityType = 'Voucher'
  AND    (@ProjectKey is null or a.ProjectKey = @ProjectKey)

  INSERT #tran(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, LayoutEntityKey, ItemName)
  SELECT 'tPurchaseOrderDetail',pod.PurchaseOrderDetailKey, pod.Quantity
  , Case ISNULL(po.BillAt, 0) 
		When 0 then isnull(pod.BillableCost,0)
		When 1 then isnull(pod.TotalCost,0)
		When 2 then isnull(pod.BillableCost,0) - isnull(pod.TotalCost,0) 
	end
  , isnull(i.WorkTypeKey, 0), isnull(pod.ItemKey, 0), i.ItemName    
  FROM   #tProcWIPKeys a
	INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON pod.PurchaseOrderDetailKey = cast(a.EntityKey as integer)
	INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	LEFT OUTER JOIN tItem i (NOLOCK) ON pod.ItemKey = i.ItemKey
  WHERE  a.EntityType = 'Order'
  AND    (@ProjectKey is null or a.ProjectKey = @ProjectKey)

 
	RETURN 1
GO
