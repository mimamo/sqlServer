USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeGetTaskList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeGetTaskList]
(
	@BillingKey int,
	@ProjectKey int
)

as --Encrypt

  /*
  || When     Who Rel    What
  || 09/27/06 GHL 8.4    Reviewed AmountBilled to make it same as spRptTaskSummary
  || 07/09/07 GHL 8.5    Added restriction on ERs
  || 01/31/08 GHL 8.5    (20123) Using now invoice summary rather project cost view
  || 11/12/09 GHL 10.513 (68297) Limiting now to approved estimates when there is no task 
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
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

select 
	 t.TaskKey
	,t.TaskID
	,t.TaskName
	,t.TaskLevel
	,t.TaskType
	,case when t.TaskType = 1 and isnull(t.TrackBudget,0) = 0 then 1
	else 2 end as BudgetTaskType			
	,t.SummaryTaskKey
	,t.MoneyTask
	,t.HideFromClient
	,t.EstLabor
	,t.EstExpenses
	,t.EstHours
	,t.BudgetLabor
	,t.BudgetExpenses
	,t.ApprovedCOHours
	,t.ApprovedCOLabor
	,t.ApprovedCOBudgetLabor
	,t.ApprovedCOExpense
	,t.ApprovedCOBudgetExp
	,t.ProjectOrder
	,t.DisplayOrder
	,t.ProjectKey
    ,ISNULL((select sum(ti.ActualHours) from tTime ti (nolock) Where ti.TaskKey = t.TaskKey), 0) as ActHours
	,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.TaskKey = t.TaskKey), 0) as ActualLabor
	,ISNULL((Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = t.TaskKey And tExpenseReceipt.VoucherDetailKey IS NULL), 0) as ExpReceiptAmt
	,ISNULL((Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = t.TaskKey), 0) as MiscCostAmt
	,ISNULL((Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and pd.TaskKey = t.TaskKey), 0) as OpenPOAmt
	,ISNULL((Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = t.TaskKey), 0) as VoucherAmt
	
	,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.TaskKey = t.TaskKey
				AND   inv.AdvanceBill = 0), 0)
				
	as AmountBilled
					
	/*	
	,ISNULL((Select Sum(TotalAmount) from tInvoiceLine (nolock) 
			inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
			Where tInvoiceLine.TaskKey = t.TaskKey 
			and tInvoice.AdvanceBill = 0
			and tInvoiceLine.BillFrom = 1), 0)		-- Fixed Fee amounts
	+
	ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.TaskKey = t.TaskKey
			 AND   InvoiceLineKey > 0), 0)	-- Detail Amounts		 
	  as AmountBilled
	 */   
	,0 As AllEstimatesAmountBilled -- Compatibility with sptBillingFixedFeeGetTaskEstimateList	
	,0 as InvoiceLineKey
	,ISNULL((Select sum(Percentage) from tBillingFixedFee (nolock) Where Entity = 'tTask' and EntityKey = t.TaskKey and BillingKey = @BillingKey), 0) as InvoiceLinePercent
	,ISNULL((Select sum(Amount) from tBillingFixedFee (nolock) Where Entity = 'tTask' and EntityKey = t.TaskKey and BillingKey = @BillingKey), 0) as InvoiceLineAmount
from tTask t (nolock)
where t.ProjectKey = @ProjectKey
and t.MoneyTask = 1

UNION

select 
	 -1 --t.TaskKey
	,'[No Task]' -- t.TaskID
	,'' -- t.TaskName
	,0 -- t.TaskLevel
	,2 --t.TaskType
	,2 --BudgetTaskKey
	,-1 -- t.SummaryTaskKey
	,1 --t.MoneyTask
	,0 --t.HideFromClient
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0)
	As EstLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0)
	As EstExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey  
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TaskKey, 0) = 0), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey    
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0) 
	As EstHours
	,0 -- t.BudgetLabor
	,0 -- t.BudgetExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey  
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey    
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOLabor
	,0 -- t.ApprovedCOBudgetLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOExpense
	,0 -- t.ApprovedCOBudgetExp
	,-1 AS ProjectOrder
	,-1 AS DisplayOrder
	,@ProjectKey
   ,ISNULL((select sum(ti.ActualHours) from tTime ti (nolock) 
		Where ti.ProjectKey = @ProjectKey And IsNull(ti.TaskKey, 0) = 0), 0) as ActHours
	,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) 
		where tTime.ProjectKey = @ProjectKey And IsNull(tTime.TaskKey, 0) = 0), 0) as ActualLabor
	,ISNULL((Select SUM(BillableCost) from tExpenseReceipt (nolock) 
		where tExpenseReceipt.ProjectKey = @ProjectKey And IsNull(tExpenseReceipt.TaskKey, 0) = 0  And tExpenseReceipt.VoucherDetailKey IS NULL), 0) as ExpReceiptAmt
	,ISNULL((Select SUM(BillableCost) from tMiscCost (nolock) 
		where tMiscCost.ProjectKey = @ProjectKey And IsNull(tMiscCost.TaskKey, 0) = 0), 0) as MiscCostAmt
	,ISNULL((Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and pd.ProjectKey = @ProjectKey And IsNull(pd.TaskKey, 0) = 0), 0) 
		as OpenPOAmt
	,ISNULL((Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.ProjectKey = @ProjectKey And IsNull(tVoucherDetail.TaskKey, 0) = 0), 0) 
		as VoucherAmt
	
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
	  and tInvoiceLine.BillFrom = 1 ), 0 -- Fixed Fee
	 ) 
	 + 
	ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(ProjectCosts.TaskKey, 0) = 0
			 AND   InvoiceLineKey > 0 -- Transactions
	), 0)  
	AS AmountBilled
	*/
	,0 As AllEstimatesAmountBilled -- Compatibility with sptBillingFixedFeeGetTaskEstimateList	
	,0 as InvoiceLineKey
	,ISNULL((Select sum(Percentage) from tBillingFixedFee (nolock) Where Entity = 'tTask' and EntityKey = 0 and BillingKey = @BillingKey), 0) as InvoiceLinePercent
	,ISNULL((Select sum(Amount) from tBillingFixedFee (nolock) Where Entity = 'tTask' and EntityKey = 0 and BillingKey = @BillingKey), 0) as InvoiceLineAmount

order by SummaryTaskKey, DisplayOrder
GO
