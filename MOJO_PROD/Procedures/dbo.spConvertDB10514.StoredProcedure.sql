USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10514]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10514]
	AS

	exec spConvertDBSeed
	
	
	

update tVoucherDetail
set    tVoucherDetail.WIPAmount = isnull(wpd.Amount, 0)
from   tWIPPostingDetail wpd (nolock)
where  wpd.Entity = 'tVoucherDetail' 
and    wpd.EntityKey = tVoucherDetail.VoucherDetailKey

update tVoucherDetail
set    WIPAmount = isnull(TotalCost, 0)
where  WIPPostingInKey <> 0 
and    WIPAmount is null

update tVoucherDetail
set    WIPAmount = 0
where  WIPAmount is null



update tMiscCost
set    tMiscCost.WIPAmount = isnull(wpd.Amount, 0)
from   tWIPPostingDetail wpd (nolock)
where  wpd.Entity = 'tMiscCost' 
and    wpd.EntityKey = tMiscCost.MiscCostKey

update tMiscCost
set    WIPAmount = isnull(TotalCost, 0)
where  WIPPostingInKey <> 0 
and    WIPAmount is null

update tMiscCost
set    WIPAmount = 0
where  WIPAmount is null




update tExpenseReceipt
set    tExpenseReceipt.WIPAmount = isnull(wpd.Amount, 0)
from   tWIPPostingDetail wpd (nolock)
where  wpd.Entity = 'tExpenseReceipt' 
and    wpd.EntityKey = tExpenseReceipt.ExpenseReceiptKey

update tExpenseReceipt
set    WIPAmount = isnull(ActualCost, 0)
where  WIPPostingInKey <> 0 
and    WIPAmount is null

update tExpenseReceipt
set    WIPAmount = 0
where  WIPAmount is null



update tTime
set    tTime.WIPAmount = isnull(wpd.Amount, 0)
from   tWIPPostingDetail wpd (nolock)
where  wpd.Entity = 'tTime' 
and    wpd.UIDEntityKey = tTime.TimeKey

update tTime
set    WIPAmount = ROUND(ActualHours * ActualRate, 2)
where  WIPPostingInKey <> 0 
and    WIPAmount is null

update tTime
set    WIPAmount = 0
where  WIPAmount is null


update tActivity
set ActivityTypeKey = at.ActivityTypeKey
from tActivityType at (nolock)
where tActivity.CompanyKey = at.CompanyKey 
and tActivity.Type = at.TypeName
and tActivity.ActivityTypeKey is null
GO
