USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptTaskCampaignSummary]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptTaskCampaignSummary]

(
	@CampaignKey int
)

AS --Encrypt

/*
|| When     Who Rel   What
|| 02/01/07 GHL 8.4   Added budget Task Type (similar to spRptTaskSummary).
|| 07/18/08 GHL 8.516 (30481) Removed subquery into tTime. Preparing now labor into a temp table
|| 09/04/08 GHL 8.519 (34119) Added restriction VoucherDetailKey IS NULL to expense receipts
|| 02/10/09 RTC 10.018  Removed query hint for better performance
|| 08/13/09 GHL 10.507 (59431) Added a NO TASK row to report on expenses without tasks
|| 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
*/

create table #Labor(ProjectKey int null, TaskKey int null, ProjectNumber varchar(50) null, ProjectName varchar(100) null, ActualHours decimal(24,4) null, ActualLabor money null)

insert #Labor (ProjectKey, TaskKey, ProjectNumber, ProjectName, ActualHours, ActualLabor)
select proj.ProjectKey, TaskKey, proj.ProjectNumber, proj.ProjectName, 0, 0 from tTask ta1 (nolock)
	Inner join tProject proj (nolock) on ta1.ProjectKey = proj.ProjectKey
where proj.CampaignKey = @CampaignKey
and ta1.MoneyTask = 1

-- Also one line for expenses without tasks, cannot use TaskKey = 0 because of rollup on the UI, use -1
insert #Labor (ProjectKey, TaskKey, ProjectNumber, ProjectName, ActualHours, ActualLabor)
select proj.ProjectKey, -1, proj.ProjectNumber, proj.ProjectName, 0, 0 
	from tProject proj (nolock) 
where proj.CampaignKey = @CampaignKey


update #Labor
set    #Labor.ActualHours =  (
		select sum(ti.ActualHours) 
		from  tTime ti (nolock)
		Where ti.TaskKey = #Labor.TaskKey
		)
where  TaskKey <> -1

update #Labor
set    #Labor.ActualLabor =  (
		select SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
		from  tTime ti (nolock)
		Where ti.TaskKey = #Labor.TaskKey
		)
Where  TaskKey <> -1

update #Labor
set    #Labor.ActualHours =  (
		select sum(ti.ActualHours) 
		from  tTime ti (nolock)
		Where ti.ProjectKey = #Labor.ProjectKey
		And   isnull(ti.TaskKey, 0) = 0
		)
where  TaskKey = -1

update #Labor
set    #Labor.ActualLabor =  (
		select SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
		from tTime ti (nolock)
		Where ti.ProjectKey = #Labor.ProjectKey
		And   isnull(ti.TaskKey, 0) = 0
		)
Where  TaskKey = -1

		
select 
	 --ta1.*
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
	
	,b.ProjectNumber
	,b.ProjectNumber + ' - ' + b.ProjectName as ProjectFullName
    ,b.ActualHours as ActHours	
	,b.ActualLabor as ActualLabor
	
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.TaskKey = ta1.TaskKey
	  and tExpenseReceipt.VoucherDetailKey IS NULL
	) 
		as ExpReceiptAmt
	
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.TaskKey = ta1.TaskKey) 
		as MiscCostAmt
	
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where p.Closed = 0 and pd.TaskKey = ta1.TaskKey) 
		as OpenPOAmt
	
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.TaskKey = ta1.TaskKey) 
		as VoucherAmt
		
	,ISNULL((Select TaskID from tTask ta2 (nolock) Where ta1.SummaryTaskKey = ta2.TaskKey), '') as SummaryTaskID
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
from tTask ta1 (nolock)
	Inner join #Labor b (nolock) on ta1.TaskKey = b.TaskKey
where b.TaskKey <> -1

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
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = b.ProjectKey 
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
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As EstExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = b.ProjectKey  
			and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0)
	 + ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = b.ProjectKey    
			and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 and (e.InternalStatus =4 and (isnull(e.ExternalApprover,0) = 0 or (isnull(e.ExternalApprover,0) > 0 and e.ExternalStatus = 4)))), 0) 
	As EstHours
	,0 AS BudgetLabor
	,0 AS BudgetExpenses
	,ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = b.ProjectKey  
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = b.ProjectKey    
			and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0) 
	As ApprovedCOHours
	,ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = b.ProjectKey 
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
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0), 0)
	+ ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = b.ProjectKey   
			and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0), 0)
	As ApprovedCOExpense
	,0 AS ApprovedCOBudgetExp
	,-1 AS ProjectOrder
	,-1 AS DisplayOrder
	
	,b.ProjectKey AS ProjectKey
	,b.ProjectNumber
	,b.ProjectNumber + ' - ' + b.ProjectName as ProjectFullName
    ,b.ActualHours AS ActualHours
	,b.ActualLabor as ActualLabor
	
	,(Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.ProjectKey = b.ProjectKey and isnull(tExpenseReceipt.TaskKey, 0) = 0  And tExpenseReceipt.VoucherDetailKey IS NULL
	) as ExpReceiptAmt
	
	,(Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.ProjectKey = b.ProjectKey and isnull(tMiscCost.TaskKey, 0) = 0 
	)as MiscCostAmt
	
	,(Select SUM(TotalCost - ISNULL(AppliedCost, 0)) 
		from tPurchaseOrderDetail pd (nolock) 
		inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		where pd.Closed = 0 and pd.ProjectKey = b.ProjectKey and isnull(pd.TaskKey, 0) = 0
	) as OpenPOAmt
	
	,(Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.ProjectKey = b.ProjectKey and isnull(tVoucherDetail.TaskKey, 0) = 0
	) as VoucherAmt
	
	,'' as SummaryTaskID
	,0 as InvoiceLineKey
	,Cast(0 as Money) as InvoiceLineAmount
From #Labor b (nolock) 
where b.TaskKey = -1

order by b.ProjectNumber, ta1.ProjectOrder
GO
