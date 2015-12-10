USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptTaskSummary]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptTaskSummary]

(
	@ProjectKey int
	,@IncludeNullTaskLines int = 0
)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/05/06 CRG 8.35  Modified to look for open PO Lines rather than open POs.
|| 07/09/07 GHL 8.5   Added restriction on ERs (null VDKey)
|| 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view
|| 07/14/09 GHL 10.505 (56484) Added support of No Task billing (couple of fields were missing)
|| 04/08/11 GHL 10.543 (106776) Added Selected field to help with project fixed fee grid
||                     Now even if InvoiceLineAmount is 0, we must be able to create invoice line
|| 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate)) 
|| 03/21/13 GHL 10.566 Changed sort by ProjectOrder rather than SummaryTaskKey/DisplayOrder
*/

/*
On Budget screens, we cannot rely on TaskType = 1 to display bold on grids 
But rely on BudgetTaskType = 1

TaskType | TrackBudget | BudgetTaskType | Grid appearance
--------------------------------------------------------
1 Summary        0             1         Bold
1 Summary        1             2         Not Bold, like tracking       
2 Tracking       1             2         Not Bold, tracking
2 Tracking       0             2         NOT SHOWN MoneyTask = 0

All tasks below a TrackBudget task have MoneyTask = 0 so they will not be shown 
If a summary task tracks budget, it becomes in effect a tracking task
 
*/

	-- Patch to make sure that estimates are rolled up
	-- Check for approved estimates
	IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK)
					WHERE e.ProjectKey = @ProjectKey
				    AND ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				    Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
					)
		BEGIN
			-- Check for Rollups
			IF NOT EXISTS (SELECT 1 FROM tProjectEstByItem (NOLOCK)
							WHERE ProjectKey = @ProjectKey)
			BEGIN
				EXEC sptEstimateRollupDetail @ProjectKey
			END
		END
		
If @IncludeNullTaskLines = 1		
select 
	 ta1.TaskKey
	,ta1.TaskID
	,ta1.TaskName
	,ta1.TaskLevel
	,ta1.TaskType
	,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
	else 2 end as BudgetTaskType		
	,ta1.SummaryTaskKey
	,ta1.TrackBudget
	,ta1.MoneyTask
	,ta1.HideFromClient
	,ta1.EstLabor
	,ta1.EstExpenses
	,ta1.EstHours
	,ta1.BudgetLabor
	,ta1.BudgetExpenses
	,ta1.ApprovedCOHours
	,ta1.ApprovedCOLabor
	,ta1.ApprovedCOBudgetLabor
	,ta1.ApprovedCOExpense
	,ta1.ApprovedCOBudgetExp
	,ta1.ProjectOrder
	,ta1.DisplayOrder
	,ta1.ProjectKey
    ,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.TaskKey = ta1.TaskKey) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.TaskKey = ta1.TaskKey) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = ta1.TaskKey And tExpenseReceipt.VoucherDetailKey IS NULL) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = ta1.TaskKey) as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where pd.Closed = 0 and pd.TaskKey = ta1.TaskKey) as OpenPOAmt
	,(Select SUM(pd.AmountBilled) -- for Prebill POs 
		from tPurchaseOrderDetail pd (nolock) 
		where pd.AmountBilled is not null and pd.TaskKey = ta1.TaskKey) 
	As PreBilledPOAmt
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = ta1.TaskKey)
	 as VoucherAmt
	,ISNULL((Select TaskID from tTask ta2 (nolock) Where ta1.SummaryTaskKey = ta2.TaskKey), '') as SummaryTaskID

	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.TaskKey = ta1.TaskKey
				AND   inv.AdvanceBill = 0), 0)
				
				as AmountBilled
	/*			
	,ISNULL((Select Sum(TotalAmount) from tInvoiceLine (nolock) 
			inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
			Where tInvoiceLine.TaskKey = ta1.TaskKey 
			and tInvoice.AdvanceBill = 0
			and tInvoiceLine.BillFrom = 1), 0)		-- Fixed Fee amounts
	+
	ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.TaskKey = ta1.TaskKey
			 AND   InvoiceLineKey > 0), 0)	-- Detail Amounts		 
	  as AmountBilled	
	*/
	,0 As AllEstimatesAmountBilled -- Compatibility with  spRptTaskSummaryByEstimate
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
	,ta1.WorkTypeKey
	,ta1.Taxable
	,ta1.Taxable2
	,0 as Selected
from tTask ta1 (nolock)
where ta1.ProjectKey = @ProjectKey
and ta1.MoneyTask = 1

UNION

Select 
	 -1 AS TaskKey	-- Because of rollup routines, return -1 rather than 0
	,'[No Task]' AS TaskID
	,'' As TaskName
	,0 AS TaskLevel
	,2 AS TaskType
	,2 AS BudgetTaskType		
	,-1 AS SummaryTaskKey
	,1 AS TrackBudget
	,1 AS MoneyTask
	,0 AS HideFromClient
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0)
	As EstLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As EstExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey  
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey    
			and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0) 
	As EstHours
	,0 AS BudgetLabor
	,0 AS BudgetExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey  
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey    
			and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOLabor
	,0 AS ApprovedCOBudgetLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOExpense
	,0 AS ApprovedCOBudgetExp
	,-1 AS ProjectOrder
	,-1 AS DisplayOrder
	,@ProjectKey AS ProjectKey
    ,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = 0
	) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = 0
	) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.ProjectKey = @ProjectKey and isnull(tExpenseReceipt.TaskKey, 0) = 0  And tExpenseReceipt.VoucherDetailKey IS NULL
	) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.ProjectKey = @ProjectKey and isnull(tMiscCost.TaskKey, 0) = 0 
	)as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) 
		inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where pd.Closed = 0 and pd.ProjectKey = @ProjectKey and isnull(pd.TaskKey, 0) = 0
	) as OpenPOAmt
	,(Select SUM(pd.AmountBilled) -- for Prebill POs 
		from tPurchaseOrderDetail pd (nolock) 
		where pd.AmountBilled is not null and pd.ProjectKey = @ProjectKey and isnull(pd.TaskKey, 0) = 0) 
	As PreBilledPOAmt
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.ProjectKey = @ProjectKey and isnull(tVoucherDetail.TaskKey, 0) = 0
	) as VoucherAmt
	,'' as SummaryTaskID
	
	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   ISNULL(isum.TaskKey, 0) = 0
				AND   inv.AdvanceBill = 0), 0)
				
				as AmountBilled
	
	/*			
	,ISNULL((Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	  Where tInvoiceLine.ProjectKey = @ProjectKey 
	  and isnull(tInvoiceLine.TaskKey, 0) = 0 
	  and tInvoice.AdvanceBill = 0
	  and tInvoiceLine.BillFrom = 1 ), 0
	 ) 
	 + 
	ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(ProjectCosts.TaskKey, 0) = 0
			 AND   InvoiceLineKey > 0
	), 0)  
	AS AmountBilled
	*/
	,0 As AllEstimatesAmountBilled -- Compatibility with  spRptTaskSummaryByEstimate
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
    ,0 As WorkTypeKey
    ,0 AS Taxable
    ,0 AS Taxable2
	,0 as Selected
order by ProjectOrder -- SummaryTaskKey, DisplayOrder

else

select 
	 ta1.*
   ,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
	else 2 end as BudgetTaskType		
    ,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.TaskKey = ta1.TaskKey) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.TaskKey = ta1.TaskKey) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = ta1.TaskKey  And tExpenseReceipt.VoucherDetailKey IS NULL) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = ta1.TaskKey) as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where pd.Closed = 0 and pd.TaskKey = ta1.TaskKey) as OpenPOAmt
	,(Select SUM(pd.AmountBilled) -- for Prebill POs 
		from tPurchaseOrderDetail pd (nolock) 
		where pd.AmountBilled is not null and pd.TaskKey = ta1.TaskKey) 
	As PreBilledPOAmt		
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = ta1.TaskKey) as VoucherAmt
	,ISNULL((Select TaskID from tTask ta2 (nolock) Where ta1.SummaryTaskKey = ta2.TaskKey), '') as SummaryTaskID
	
	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.TaskKey = ta1.TaskKey
				AND   inv.AdvanceBill = 0), 0)
				
				as AmountBilled

	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.TaskKey = ta1.TaskKey
				AND   inv.AdvanceBill = 0), 0)
				
				as AllAmountBilled
	/*
	,ISNULL((Select Sum(TotalAmount) from tInvoiceLine (nolock) 
			inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
			Where tInvoiceLine.TaskKey = ta1.TaskKey 
			and tInvoice.AdvanceBill = 0
			and tInvoiceLine.BillFrom = 1), 0)		-- Fixed Fee amounts
	+
	ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.TaskKey = ta1.TaskKey
			 AND   InvoiceLineKey > 0), 0)	-- Detail Amounts		 
	  as AmountBilled		   
	,ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.TaskKey = ta1.TaskKey), 0) AS AllAmountBilled
	*/
			 
	,0 As AllEstimatesAmountBilled -- Compatibility with  spRptTaskSummaryByEstimate
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
	,ta1.WorkTypeKey
	,ta1.Taxable
	,ta1.Taxable2
	,0 as Selected
from tTask ta1 (nolock)
where ta1.ProjectKey = @ProjectKey
and ta1.MoneyTask = 1
order by ta1.ProjectOrder -- ta1.SummaryTaskKey, ta1.DisplayOrder
GO
