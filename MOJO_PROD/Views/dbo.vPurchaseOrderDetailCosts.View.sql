USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vPurchaseOrderDetailCosts]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPurchaseOrderDetailCosts]
AS
/*
|| When     Who Rel  What
|| 07/27/07 GHL 8.43 Creation for Bug 10515 (spRptProjectBudgetSummary + other queries)
||                                  Needed OpenUnbilledCost
|| 10/19/07 GHL 8.438 Changed to OpenUnbilledCost = Gross * (1 - AppliedCost/ TotalCost)
||                                   Initially was OpenUnbilledCost = Gross * (AppliedCost/ TotalCost)
*/
SELECT pod.PurchaseOrderDetailKey
       ,pod.PurchaseOrderKey
       ,pod.ProjectKey
       ,pod.TaskKey
       ,pod.ItemKey
       ,pod.Quantity
       ,pod.UnitCost
       ,pod.BillableCost
       ,pod.TotalCost
       ,ISNULL(pod.AppliedCost, 0) AS AppliedCost
       ,pod.TotalCost - ISNULL(pod.AppliedCost, 0) AS OpenCost
       ,case 
            when ISNULL(pod.AmountBilled, 0) > 0 then 0
            when ISNULL(pod.AppliedCost, 0) >= pod.TotalCost then 0
            when ISNULL(pod.AppliedCost, 0) > 0 and ISNULL(pod.AppliedCost, 0) < pod.TotalCost
	       then pod.BillableCost * (1 - ISNULL(pod.AppliedCost, 0) / pod.TotalCost)
            else pod.BillableCost
        end as OpenUnbilledCost
FROM    tPurchaseOrderDetail pod (NOLOCK)
GO
