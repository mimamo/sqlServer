USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptTaskSummaryByEstimate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptTaskSummaryByEstimate]
(
	@ProjectKey int
	,@EstimateKey int	-- The UI only shows approved estimates
	,@IncludeNullTaskLines int = 0
)

AS --Encrypt		

/*
|| When     Who Rel   What
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

IF @IncludeNullTaskLines  = 0
select
	 ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = ta1.TaskKey), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0) 
	As EstHours
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0)
	As EstLabor
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0)
	As ApprovedCOLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and ete.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0)
	As EstExpenses
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and ete.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0)
	As ApprovedCOExpense
	, ta1.TaskKey
	, ta1.TaskName
	, ta1.TaskID
	, ta1.SummaryTaskKey
	, ta1.TaskType
	, ta1.Taxable
	, ta1.Taxable2
	, ta1.WorkTypeKey
	, ta1.ProjectOrder
	, ta1.DisplayOrder
	, ta1.TaskLevel
	,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
	else 2 end as BudgetTaskType		
	,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.TaskKey = ta1.TaskKey) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.TaskKey = ta1.TaskKey) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = ta1.TaskKey And tExpenseReceipt.VoucherDetailKey IS NULL) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = ta1.TaskKey) as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and pd.TaskKey = ta1.TaskKey) as OpenPOAmt
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = ta1.TaskKey) as VoucherAmt
	,ISNULL((Select TaskID from tTask ta2 (nolock) Where ta1.SummaryTaskKey = ta2.TaskKey), '') as SummaryTaskID
	,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where tInvoiceLine.TaskKey = ta1.TaskKey 
	     and tInvoice.AdvanceBill = 0
	     and tInvoiceLine.EstimateKey = @EstimateKey
	     ), 0) as AmountBilled
	 ,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where tInvoiceLine.TaskKey = ta1.TaskKey 
	     and tInvoice.AdvanceBill = 0
	     ), 0) as AllEstimatesAmountBilled    
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
	,0 as Selected
from tTask ta1 (nolock)
where ta1.ProjectKey = @ProjectKey
and ta1.MoneyTask = 1
order by ta1.ProjectOrder -- ta1.SummaryTaskKey, ta1.DisplayOrder

ELSE

select
	 ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = ta1.TaskKey), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0) 
	As EstHours
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0)
	As EstLabor
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0)
	As ApprovedCOLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and ete.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = ta1.TaskKey), 0)
	As EstExpenses
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and ete.TaskKey = ta1.TaskKey), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = ta1.TaskKey), 0)
	As ApprovedCOExpense
	, ta1.TaskKey
	, ta1.TaskName
	, ta1.TaskID
	, ta1.SummaryTaskKey
	, ta1.TaskType
	, ta1.Taxable
	, ta1.Taxable2
	, ta1.WorkTypeKey
	, ta1.ProjectOrder
	, ta1.DisplayOrder
	, ta1.TaskLevel
	,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
	else 2 end as BudgetTaskType		
	,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.TaskKey = ta1.TaskKey) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.TaskKey = ta1.TaskKey) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = ta1.TaskKey And tExpenseReceipt.VoucherDetailKey IS NULL ) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = ta1.TaskKey) as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and pd.TaskKey = ta1.TaskKey) as OpenPOAmt
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = ta1.TaskKey) as VoucherAmt
	,ISNULL((Select TaskID from tTask ta2 (nolock) Where ta1.SummaryTaskKey = ta2.TaskKey), '') as SummaryTaskID
	,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where tInvoiceLine.TaskKey = ta1.TaskKey 
	     and tInvoice.AdvanceBill = 0
	     and tInvoiceLine.EstimateKey = @EstimateKey
	     ), 0) as AmountBilled
	,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where tInvoiceLine.TaskKey = ta1.TaskKey 
	     and tInvoice.AdvanceBill = 0
	     ), 0) as AllEstimatesAmountBilled     
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
	,0 as Selected
from tTask ta1 (nolock)
where ta1.ProjectKey = @ProjectKey
and ta1.MoneyTask = 1
--order by ta1.SummaryTaskKey, ta1.DisplayOrder

UNION

select
	 ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TaskKey, 0) = 0), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0) 
	As EstHours
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.EstimateKey = @EstimateKey    
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0)
	As EstLabor
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOLabor
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 0 and isnull(et.TaskKey, 0) = 0), 0)
	As EstExpenses
	,ISNULL((Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey   
			and e.EstType = 1 and e.ChangeOrder = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOExpense
	, -1 As TaskKey
	, '' As TaskName
	, '[No Task]' As TaskID
	, -1 As SummaryTaskKey
	, 2 As TaskType
	, 0 As Taxable
	, 0 As Taxable2
	, 0 As WorkTypeKey
	, -1 As ProjectOrder
	, -1 As DisplayOrder
	, 0 As TaskLevel
	, 2 as BudgetTaskType		
    ,(select sum(ti.ActualHours) from tTime ti (nolock) Where isnull(ti.TaskKey, 0) = 0 And ti.ProjectKey = @ProjectKey) as ActHours
	,(Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where isnull(tTime.TaskKey, 0) = 0 And tTime.ProjectKey = @ProjectKey) as ActualLabor
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where isnull(tExpenseReceipt.TaskKey, 0) = 0 And tExpenseReceipt.ProjectKey = @ProjectKey  And tExpenseReceipt.VoucherDetailKey IS NULL) as ExpReceiptAmt
	,(Select SUM(BillableCost) from tMiscCost (nolock) where isnull(tMiscCost.TaskKey, 0) = 0 And tMiscCost.ProjectKey = @ProjectKey) as MiscCostAmt
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and isnull(pd.TaskKey, 0) = 0 And pd.ProjectKey = @ProjectKey) as OpenPOAmt
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where isnull(tVoucherDetail.TaskKey, 0) = 0 And tVoucherDetail.ProjectKey = @ProjectKey) as VoucherAmt
	,'' as SummaryTaskID
	,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where isnull(tInvoiceLine.TaskKey, 0) = 0 
	     And tInvoiceLine.ProjectKey = @ProjectKey
	     and tInvoice.AdvanceBill = 0
	     and tInvoiceLine.EstimateKey = @EstimateKey
	     ), 0) as AmountBilled
	,ISNULL(
		(Select Sum(TotalAmount) from tInvoiceLine (nolock) 
		 inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	     Where isnull(tInvoiceLine.TaskKey, 0) = 0 
	     And tInvoiceLine.ProjectKey = @ProjectKey
	     and tInvoice.AdvanceBill = 0
	     ), 0) as AllEstimatesAmountBilled     
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
	,0 as Selected

order by ProjectOrder -- SummaryTaskKey, DisplayOrder
GO
