USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupUpdateTransferInfo]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupUpdateTransferInfo]
	(
	@ProjectKey int
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 03/08/11 GHL 10.542   (105027) creation for new transfer data in project rollup
  || 06/20/12 GHL 10.556   (146627) t.WIPPostingInKey = 0 -- not a reversal should be t.WIPPostingInKey <> -99
  ||                        because of interferences with real wip posting
  || 08/26/13 GHL 10.571   Using now PTotalCost and PAppliedCost instead of TotalCost and AppliedCost for ERs, POs, and VDs
  ||                       Did not change labor and misc costs because they are expressed in Project Currency                          
  */ 
	declare @TransferInLabor money
	declare @TransferOutLabor money
	declare @TransferInExpense money
	declare @TransferOutExpense money


	select @TransferInLabor = SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferFromKey = t2.TimeKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferInDate is not null -- was transfered in  	   	   
								AND  t.ProjectKey <> t2.ProjectKey
								 
	
	select @TransferOutLabor = SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferToKey = t2.TimeKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferOutDate is not null-- was transfered out 	   
								AND  t.WIPPostingInKey <> -99 -- not a reversal
								AND  t.ProjectKey <> t2.ProjectKey 

	select @TransferInExpense = ISNULL((SELECT SUM(t.BillableCost) -- t for transaction  
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferFromKey = t2.MiscCostKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferFromKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferFromKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferInDate is not null 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  t.VoucherDetailKey is null
								), 0)
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.PTotalCost,0) -- change for MC
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferFromKey = t2.PurchaseOrderDetailKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferInDate is not null -- was transfered in during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								), 0)
	
 	select @TransferOutExpense = ISNULL((SELECT SUM(t.BillableCost) 
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferToKey = t2.MiscCostKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferOutDate is not null
								AND  t.ProjectKey <> t2.ProjectKey   
								AND  t.WIPPostingInKey <> -99 
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferToKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferOutDate is not null
								AND  t.ProjectKey <> t2.ProjectKey 
								AND  t.WIPPostingInKey <> -99 
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferToKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferOutDate is not null
								AND  t.ProjectKey <> t2.ProjectKey 	   
								AND  t.WIPPostingInKey <> -99 
								AND  t.VoucherDetailKey is null
								), 0) 
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.PTotalCost,0) -- change for MC
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferToKey = t2.PurchaseOrderDetailKey
								LEFT OUTER JOIN tPurchaseOrderDetail t3 (NOLOCK) ON t.TransferFromKey = t3.PurchaseOrderDetailKey
								WHERE t.ProjectKey = @ProjectKey
								AND  t.TransferOutDate is not null -- was transfered out during date range 	   
								AND  t.ProjectKey <> t2.ProjectKey
								AND  (t3.ProjectKey is null or t.ProjectKey <> t3.ProjectKey)  -- not a reversal
								), 0)

			

	update tProjectRollup
	set    TransferInLabor = isnull(@TransferInLabor, 0)
	       ,TransferOutLabor = isnull(@TransferOutLabor, 0)
		   ,TransferInExpense = isnull(@TransferInExpense, 0)
	       ,TransferOutExpense = isnull(@TransferOutExpense, 0)
	where  tProjectRollup.ProjectKey = @ProjectKey


	RETURN 1
GO
