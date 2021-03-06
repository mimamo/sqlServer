USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10542]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10542]
AS
	SET NOCOUNT ON

	-- This seems to be the best option for current companies
	update tPreference
	set    CampaignNumStyle = 4 -- Prefix + Client ID + Next # from Client
	      ,CampaignNumPrefixUseYear = 0
		  ,CampaignNumPrefix = ''
		  ,NextCampaignNum = 1
		  ,CampaignNumSep = ''
		  ,CampaignNumPlaces = 4

	update tCompany
	set    NextCampaignNum = 1


create table #tRpt(ProjectKey int null, TransferInLabor money null, TransferOutLabor money null, TransferInExpense money null, TransferOutExpense money null)
insert #tRpt (ProjectKey) 
select distinct ProjectKey from tTime (nolock) where TransferInDate is not null or TransferOutDate is not null

insert #tRpt (ProjectKey) 
select distinct ProjectKey from tMiscCost (nolock) where TransferInDate is not null or TransferOutDate is not null
and ProjectKey not in (select ProjectKey from #tRpt)

insert #tRpt (ProjectKey) 
select distinct ProjectKey from tVoucherDetail (nolock) where TransferInDate is not null or TransferOutDate is not null
and ProjectKey not in (select ProjectKey from #tRpt)

insert #tRpt (ProjectKey) 
select distinct ProjectKey from tExpenseReceipt (nolock) where TransferInDate is not null or TransferOutDate is not null
and ProjectKey not in (select ProjectKey from #tRpt)

insert #tRpt (ProjectKey) 
select distinct ProjectKey from tPurchaseOrderDetail (nolock) where TransferInDate is not null or TransferOutDate is not null
and ProjectKey not in (select ProjectKey from #tRpt)

delete #tRpt where isnull(ProjectKey, 0) = 0

		UPDATE #tRpt
		SET    #tRpt.TransferInLabor = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferFromKey = t2.TimeKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0) 
	
	
	
		UPDATE #tRpt
		SET    #tRpt.TransferOutLabor = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferToKey = t2.TimeKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate is not null-- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.WIPPostingInKey = 0 -- not a reversal
								), 0) 
	
		UPDATE #tRpt
		SET    #tRpt.TransferInExpense = ISNULL((SELECT SUM(t.BillableCost) -- t for transaction  
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferFromKey = t2.MiscCostKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferFromKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferFromKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate is not null -- was transfered in during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.VoucherDetailKey is null
								), 0)
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.TotalCost,0)
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.TotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferFromKey = t2.PurchaseOrderDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate is not null -- was transfered in during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0)
	
 		UPDATE #tRpt
		SET    #tRpt.TransferOutExpense = ISNULL((SELECT SUM(t.BillableCost) 
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferToKey = t2.MiscCostKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate is not null -- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.WIPPostingInKey = 0 -- not a reversal
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferToKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate is not null -- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.WIPPostingInKey = 0 -- not a reversal
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferToKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate is not null -- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.WIPPostingInKey = 0 -- not a reversal
								AND  t.VoucherDetailKey is null
								), 0) 
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.TotalCost,0)
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.TotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferToKey = t2.PurchaseOrderDetailKey
								LEFT OUTER JOIN tPurchaseOrderDetail t3 (NOLOCK) ON t.TransferFromKey = t3.PurchaseOrderDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate is not null -- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  (t3.ProjectKey is null or t.ProjectKey <> t3.ProjectKey)  -- not a reversal
								), 0)

		update tProjectRollup
		set    tProjectRollup.TransferInLabor = #tRpt.TransferInLabor
		      ,tProjectRollup.TransferOutLabor = #tRpt.TransferOutLabor
			  ,tProjectRollup.TransferInExpense = #tRpt.TransferInExpense
		      ,tProjectRollup.TransferOutExpense = #tRpt.TransferOutExpense
		from   #tRpt
		where  tProjectRollup.ProjectKey = #tRpt.ProjectKey
			  
drop table #tRpt

	RETURN 1
GO
