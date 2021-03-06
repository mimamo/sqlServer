USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetTaskSummary]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptBillingGetTaskSummary]
	
	  @ProjectKey int
	 ,@BillingKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.4   Added Mark as Billed column 
  || 07/09/07 GHL 8.5   Added restriction on ERs
  || 12/15/08 GHL 10.015 (41479) The billed columns should not include the invoice created with the WS  
  || 10/07/09 RLB 10.512 (64911) no task Amount marked as billed was not filtering for ProjectKey it is now     
  || 01/19/11 GHL 10.540 (99860) Rewrote queries to increase performance (was causing timeouts at Lavidge)
  ||                     Went from 3m 10s to 1 sec at Lavidge
  || 02/15/13 GHL 10.565 (168977) Increased size of TaskName to 500 like in tTask
  || 04/25/14 WDF 10.579 (212466) Have OpenPOAmt reflect Gross and not Net
  || 03/26/15 GHL 10.591 (228570) Take in account AppliedCost when calculating OpenPOAmt (same as sptProjectRollupUpdate)
  ||                      1) Recalc NewGross as a function of po.BillAt
  ||                      2) NewGross = NewGross * (Amt Unapplied / TotalCost) = NewGross * ((TotalCost - AppliedCost) / TotalCost)
  ||                         = NewGross * (1 - (AppliedCost / TotalCost))
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

	declare @InvoiceKey int
	select @InvoiceKey = InvoiceKey from tBilling (nolock) where BillingKey = @BillingKey
	select @InvoiceKey = isnull(@InvoiceKey, 0)
	
	create table #task(
		TaskKey int null
		,TaskID varchar(50) null
		,TaskName varchar(500) null
		,TaskLevel int null
		,TaskType int null
		,BudgetTaskType int null
		,SummaryTaskKey int null
		,MoneyTask int null
		,HideFromClient int null
		,EstLabor money null
		,EstExpenses money null
		,EstHours decimal(24, 4) null
		,BudgetLabor money null
		,BudgetExpenses money null
		,ApprovedCOHours decimal(24, 4) null
		,ApprovedCOLabor money null
		,ApprovedCOBudgetLabor money null
		,ApprovedCOExpense money null
		,ApprovedCOBudgetExp money null
		,ProjectOrder int null
		,DisplayOrder int null
		,ProjectKey int null
		,summaryTaskID varchar(50) null

		,ActHours decimal(24, 4) null
		,ActualLabor money null
		,ActualLaborBilled money null
		,LaborToBeBilled money null
		,LaborOnBW money null

		,ExpReceiptAmt money null
		,ExpReceiptAmtBilled money null
		,ExpReceiptToBeBilled money null
		,ExpReceiptOnBW money null

		,MiscCostAmt money null
		,MiscCostAmtBilled money null
		,MiscCostToBeBilled money null
		,MiscCostOnBW money null

		,OpenPOAmt money null
		,OpenPOAmtBilled money null
		,OpenPOToBeBilled money null
		,OpenPOOnBW money null

		,VoucherAmt money null
		,VoucherAmtBilled money null
		,VoucherToBeBilled money null
		,VoucherOnBW money null

		,AmountBilledNoDetail money null
		,AmountNotSelected money null
		,InvoiceLineKey int null
		,InvoiceLineAmount money null
		,PercComp int null
		,AmountMarkAsBilled money null

		)

	create table #time (
		TimeKey uniqueidentifier null
		,TaskKey int null
		,ActualHours decimal(24, 4) null
		,ActualRate money null
		,BilledHours decimal(24, 4) null
		,BilledRate money null
		,InvoiceLineKey int null
		)
		
	insert #time (TimeKey, TaskKey, ActualHours, ActualRate, BilledHours, BilledRate, InvoiceLineKey)
	select TimeKey, TaskKey, ActualHours, ActualRate, BilledHours, BilledRate, InvoiceLineKey
	from   tTime (nolock)
	where  ProjectKey = @ProjectKey

	insert #task(
		TaskKey
		,TaskID
		,TaskName 
		,TaskLevel
		,TaskType 
		,BudgetTaskType 
		,SummaryTaskKey 
		,MoneyTask
		,HideFromClient 
		,EstLabor
		,EstExpenses 
		,EstHours
		,BudgetLabor 
		,BudgetExpenses 
		,ApprovedCOHours 
		,ApprovedCOLabor 
		,ApprovedCOBudgetLabor 
		,ApprovedCOExpense 
		,ApprovedCOBudgetExp 
		,ProjectOrder 
		,DisplayOrder 
		,ProjectKey 
		,summaryTaskID -- 23 fields

		,ActHours 
		,ActualLabor 
		,ActualLaborBilled 
		,LaborToBeBilled 
		,LaborOnBW 

		,ExpReceiptAmt 
		,ExpReceiptAmtBilled 
		,ExpReceiptToBeBilled 
		,ExpReceiptOnBW

		,MiscCostAmt 
		,MiscCostAmtBilled
		,MiscCostToBeBilled
		,MiscCostOnBW 

		,OpenPOAmt 
		,OpenPOAmtBilled
		,OpenPOToBeBilled 
		,OpenPOOnBW 

		,VoucherAmt 
		,VoucherAmtBilled 
		,VoucherToBeBilled 
		,VoucherOnBW    -- 21 fields

		,AmountBilledNoDetail
		,AmountNotSelected 
		,InvoiceLineKey 
		,InvoiceLineAmount 
		,PercComp 
		,AmountMarkAsBilled
		)

	select 
		 ta1.TaskKey
		,ta1.TaskID
		,ta1.TaskName
		,ta1.TaskLevel
		,ta1.TaskType -- 1 Summary, 2 Tracking
		,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
		 else 2 end as BudgetTaskType	
		,ta1.SummaryTaskKey
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
		,isnull((select TaskID 
				   from tTask ta2 (nolock) 
				  where ta1.SummaryTaskKey = ta2.TaskKey), '') as summaryTaskID -- 23
		
		-- times
		,0,0,0,0,0 
		
		-- ERs
		,0,0,0,0

		-- MCs
		,0,0,0,0

		-- POs
		,0,0,0,0

		-- VD
		,0,0,0,0

		-- Billed Amounts and Misc
		,0,0,0,0,round(ta1.PercComp,2),0

	from tTask ta1 (nolock)
   where ta1.ProjectKey = @ProjectKey
     and ta1.MoneyTask = 1

	UNION ALL

	select 
		 0 AS TaskKey	-- Because of rollup routines, return -1 rather than 0, but set to 0 for now
		,'[No Task]' AS TaskID
		,'' As TaskName
		,0 AS TaskLevel
		,2 AS TaskType
		,2 AS BudgetTaskType
		,0 AS SummaryTaskKey
		,1 AS MoneyTask
		,0 AS HideFromClient
		,0 AS EstLabor
		,0 AS EstExpenses
		,0 AS EstHours
		,0 AS BudgetLabor
		,0 AS BudgetExpenses
		,0 AS ApprovedCOHours
		,0 AS ApprovedCOLabor
		,0 AS ApprovedCOBudgetLabor
		,0 AS ApprovedCOExpense
		,0 AS ApprovedCOBudgetExp
		,-1 AS ProjectOrder
		,-1 AS DisplayOrder
		,@ProjectKey AS ProjectKey
		,'' AS summaryTaskID

		-- times
		,0,0,0,0,0 
		
		-- ERs
		,0,0,0,0

		-- MCs
		,0,0,0,0

		-- POs
		,0,0,0,0

		-- VD
		,0,0,0,0

		-- Billed Amounts
		,0,0,0,0,0,0

		-- times...no need to join with ProjectKey (already taken in account when populating temp)
		update #task
		set    #task.ActHours = ISNULL((
				select sum(ti.ActualHours)
			    from   #time ti
				where  isnull(ti.TaskKey, 0) = #task.TaskKey
				), 0)
				
				,#task.ActualLabor = ISNULL((
				select sum(round(ti.ActualHours * ti.ActualRate, 2)) 
			    from   #time ti
				where  isnull(ti.TaskKey, 0) = #task.TaskKey
				), 0)
				
				,#task.ActualLaborBilled = ISNULL((
				select sum(round(ti.BilledHours * ti.BilledRate, 2)) 
			    from   #time ti
					inner join tInvoiceLine il (nolock) on ti.InvoiceLineKey = il.InvoiceLineKey 
				where  isnull(ti.TaskKey, 0) = #task.TaskKey
				and    il.InvoiceKey  <> @InvoiceKey
				), 0)
				,#task.LaborToBeBilled = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join #time t (nolock) on bd.EntityGuid = t.TimeKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tTime' 
				 and Action = 1
				 and isnull(t.TaskKey, 0) = #task.TaskKey
				 ),0)
				 ,#task.LaborOnBW = ISNULL((
				 select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
				where bd.BillingKey = @BillingKey 
				and bd.Entity = 'tTime' 
				and isnull(t.TaskKey, 0) = #task.TaskKey
				),0)

		-- ERs...join with ProjectKey because of TaskKey = 0
		update #task
		set    #task.ExpReceiptAmt = ISNULL((
				select sum(BillableCost) 
				from tExpenseReceipt (nolock)
				where tExpenseReceipt.ProjectKey = @ProjectKey
				and   isnull(tExpenseReceipt.TaskKey, 0) = #task.TaskKey
				and   tExpenseReceipt.VoucherDetailKey IS NULL
				), 0)
				
				,#task.ExpReceiptAmtBilled = ISNULL((
				select sum(AmountBilled) 
				from tExpenseReceipt (nolock) 
				inner join tInvoiceLine il (nolock) on tExpenseReceipt.InvoiceLineKey = il.InvoiceLineKey 
				where tExpenseReceipt.ProjectKey = @ProjectKey
				and   isnull(tExpenseReceipt.TaskKey, 0) = #task.TaskKey
				and   il.InvoiceKey  <> @InvoiceKey
				), 0)
				,#task.ExpReceiptToBeBilled  = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tExpenseReceipt' 
				 and Action = 1
				 and isnull(er.TaskKey, 0) = #task.TaskKey
				 ),0)
				 ,#task.ExpReceiptOnBW  = ISNULL((
				 select sum(bd.Total) 
				 from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
			     where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tExpenseReceipt' 
				 and isnull(er.TaskKey, 0) = #task.TaskKey
				 ),0)

		-- MCs...join with ProjectKey because of TaskKey = 0
		update #task
		set    #task.MiscCostAmt = ISNULL((
				select sum(BillableCost) 
			    from tMiscCost (nolock) 
		        where tMiscCost.ProjectKey = @ProjectKey
				and   isnull(tMiscCost.TaskKey, 0) = #task.TaskKey
				), 0)
				
				,#task.MiscCostAmtBilled = ISNULL((
				select sum(AmountBilled) 
				from tMiscCost mc (nolock) 
				inner join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey 
				where mc.ProjectKey = @ProjectKey
				and   isnull(mc.TaskKey, 0) = #task.TaskKey
				and   il.InvoiceKey  <> @InvoiceKey
				), 0)
				,#task.MiscCostToBeBilled   = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tMiscCost' 
				 and Action = 1
				 and isnull(mc.TaskKey, 0) = #task.TaskKey
				 ),0)
				 ,#task.MiscCostOnBW   = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tMiscCost' 
				and isnull(mc.TaskKey, 0) = #task.TaskKey
				 ),0)

		-- POs...join with ProjectKey because of TaskKey = 0
		update #task
			set #task.OpenPOAmt = ISNULL((
				SELECT SUM(
							CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8) ) )	
								ELSE NewBillableCost 
							END
						)
				FROM				
				(
				SELECT CASE po.BillAt 
						WHEN 0 THEN ISNULL(pod.BillableCost, 0)
						WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
    					WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
						END AS NewBillableCost
						,pod.PTotalCost as TotalCost
						,pod.PAppliedCost as AppliedCost
						,pod.BillableCost
				FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE	pod.Closed = 0					-- still open
				AND		pod.ProjectKey = @ProjectKey
				and     isnull(pod.TaskKey, 0) = #task.TaskKey
				AND     pod.DateBilled IS NULL  -- Non Prebilled only
				) AS OpenOrders	
				), 0)

				,#task.OpenPOAmtBilled = ISNULL((
				select sum(AmountBilled) 
				from tPurchaseOrderDetail pd (nolock) 
				inner join tInvoiceLine il (nolock) on pd.InvoiceLineKey = il.InvoiceLineKey 
				where pd.TaskKey = #task.TaskKey 
				and   pd.ProjectKey = @ProjectKey
				and il.InvoiceKey  <> @InvoiceKey
				), 0)
				,#task.OpenPOToBeBilled   = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tPurchaseOrderDetail' 
				 and Action = 1
				 and isnull(pd.TaskKey, 0) = #task.TaskKey
				 ),0)
				 ,#task.OpenPOOnBW    = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tPurchaseOrderDetail' 
				 and isnull(pd.TaskKey, 0) = #task.TaskKey
				 ),0)

		-- VDs...join with ProjectKey because of TaskKey = 0
		update #task
		set    #task.VoucherAmt = ISNULL((
				select sum(BillableCost) 
				from tVoucherDetail (nolock)
				where tVoucherDetail.ProjectKey = @ProjectKey
				and   isnull(tVoucherDetail.TaskKey, 0) = #task.TaskKey
				), 0)
				
				,#task.VoucherAmtBilled = ISNULL((
				select sum(AmountBilled) 
				from tVoucherDetail (nolock)
				inner join tInvoiceLine il (nolock) on tVoucherDetail.InvoiceLineKey = il.InvoiceLineKey 
				where tVoucherDetail.ProjectKey = @ProjectKey
				and   isnull(tVoucherDetail.TaskKey, 0) = #task.TaskKey 
				 --and InvoiceLineKey >0
				and il.InvoiceKey  <> @InvoiceKey
				), 0)
				,#task.VoucherToBeBilled    = ISNULL((
				select sum(bd.Total) 
				from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
			    where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tVoucherDetail' 
				 and Action = 1
				 and isnull(vd.TaskKey, 0) = #task.TaskKey
				 ),0)
				 ,#task.VoucherOnBW     = ISNULL((
                  select sum(bd.Total) 
				 from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
			     where bd.BillingKey = @BillingKey 
				 and bd.Entity = 'tVoucherDetail' 
				 and isnull(vd.TaskKey, 0) = #task.TaskKey
				 ),0)

    update #task
	set    #task.AmountBilledNoDetail = ISNULL((
					select sum(TotalAmount) 
				   from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
				  where tInvoiceLine.ProjectKey = @ProjectKey
				    and isnull(tInvoiceLine.TaskKey, 0) = #task.TaskKey 
					and tInvoiceLine.BillFrom = 1   -- Fixed Fee lines
					and tInvoice.InvoiceKey <> @InvoiceKey
					and tInvoice.AdvanceBill = 0
					),0)  
			,#task.AmountNotSelected = ISNULL((
					select sum(BillableCost) 
				    from vBillingItemSelect
				    where vBillingItemSelect.ProjectKey = @ProjectKey 
				    and isnull(vBillingItemSelect.TaskKey, 0) = #task.TaskKey 
					),0)  
			,#task.AmountMarkAsBilled = ISNULL((
					isnull((select sum(round(BilledHours * BilledRate, 2)) 
							from #time ti (nolock) Where isnull(ti.TaskKey,0) = #task.TaskKey
							and InvoiceLineKey = 0),0)

			+ ISNULL((select sum(AmountBilled) 
				from tExpenseReceipt (nolock) 
			   where tExpenseReceipt.ProjectKey = @ProjectKey
			     and isnull(tExpenseReceipt.TaskKey, 0) = #task.TaskKey 
				 and InvoiceLineKey =0),0) 
			+ ISNULL((select sum(AmountBilled) 
				from tMiscCost (nolock) 
			   where ISNULL(tMiscCost.TaskKey, 0) = #task.TaskKey 
				 and isnull(tMiscCost.ProjectKey, 0) = @ProjectKey
				 and InvoiceLineKey =0),0) 
			+ ISNULL((select sum(AmountBilled) 
				from tVoucherDetail (nolock)
			   where isnull(tVoucherDetail.TaskKey, 0) = #task.TaskKey
			    and tVoucherDetail.ProjectKey = @ProjectKey 
				 and InvoiceLineKey =0),0) 	 			 
			+ISNULL((select sum(AmountBilled) 
				from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
			   where ISNULL(pd.TaskKey, 0) = #task.TaskKey 
				 and pd.ProjectKey = @ProjectKey
				 and InvoiceLineKey =0), 0)


					),0)  
			


	update #task set TaskKey = -1 where TaskKey = 0

	select * from #task
	order by SummaryTaskKey, DisplayOrder

	/*

	select 
		 ta1.TaskKey
		,ta1.TaskID
		,ta1.TaskName
		,ta1.TaskLevel
		,ta1.TaskType -- 1 Summary, 2 Tracking
		,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
		 else 2 end as BudgetTaskType	
		,ta1.SummaryTaskKey
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

		-- times
		,ISNULL((select sum(ti.ActualHours)
			from tTime ti (nolock)
		   where ti.TaskKey = ta1.TaskKey),0) as ActHours
		,ISNULL((select sum(round(ActualHours * ActualRate, 2)) 
			from tTime (nolock) 
		   where tTime.TaskKey = ta1.TaskKey),0) as ActualLabor
		,ISNULL((select sum(round(BilledHours * BilledRate, 2)) 
			from tTime (nolock) 
				inner join tInvoiceLine il (nolock) on tTime.InvoiceLineKey = il.InvoiceLineKey 
		   where tTime.TaskKey = ta1.TaskKey 
			 --and il.InvoiceLineKey >0
			 and il.InvoiceKey  <> @InvoiceKey
			 ),0) as ActualLaborBilled
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tTime' 
			 and Action = 1
			 and t.TaskKey = ta1.TaskKey),0) as LaborToBeBilled 
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tTime' 
			 and t.TaskKey = ta1.TaskKey),0) as LaborOnBW 
		
		-- ERs
		,ISNULL((select sum(BillableCost) 
			from tExpenseReceipt (nolock)
		   where tExpenseReceipt.TaskKey = ta1.TaskKey
		   and   tExpenseReceipt.VoucherDetailKey IS NULL),0) as ExpReceiptAmt
		,ISNULL((select sum(AmountBilled) 
			from tExpenseReceipt (nolock) 
				inner join tInvoiceLine il (nolock) on tExpenseReceipt.InvoiceLineKey = il.InvoiceLineKey 
		   where tExpenseReceipt.TaskKey = ta1.TaskKey 
			 --and InvoiceLineKey >0
			 and il.InvoiceKey  <> @InvoiceKey
			 ),0) as ExpReceiptAmtBilled
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tExpenseReceipt' 
			 and Action = 1
			 and er.TaskKey = ta1.TaskKey),0) as ExpReceiptToBeBilled 
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tExpenseReceipt' 
			 and er.TaskKey = ta1.TaskKey),0) as ExpReceiptOnBW 
		
		-- MC
		,ISNULL((select sum(BillableCost) 
			from tMiscCost (nolock) 
		   where tMiscCost.TaskKey = ta1.TaskKey),0) as MiscCostAmt
		,ISNULL((select sum(AmountBilled) 
			from tMiscCost (nolock) 
		   		inner join tInvoiceLine il (nolock) on tMiscCost.InvoiceLineKey = il.InvoiceLineKey 
		   where tMiscCost.TaskKey = ta1.TaskKey 
			 --and InvoiceLineKey >0
			 and il.InvoiceKey  <> @InvoiceKey
			 ),0) as MiscCostAmtBilled
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tMiscCost' 
			 and Action = 1
			 and mc.TaskKey = ta1.TaskKey),0) as MiscCostToBeBilled 
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tMiscCost' 
			 and mc.TaskKey = ta1.TaskKey),0) as MiscCostOnBW 
		
		-- PO
		,ISNULL((select sum(TotalCost - isnull(AppliedCost, 0)) 
			from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		   where p.Closed = 0 
			 and pd.TaskKey = ta1.TaskKey),0) as OpenPOAmt
		,ISNULL((select sum(AmountBilled) 
			from tPurchaseOrderDetail pd (nolock) 
				inner join tInvoiceLine il (nolock) on pd.InvoiceLineKey = il.InvoiceLineKey 
		   where pd.TaskKey = ta1.TaskKey 
			 --and InvoiceLineKey >0
			 and il.InvoiceKey  <> @InvoiceKey
			 ),0) as OpenPOAmtBilled
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tPurchaseOrderDetail'
			 and Action = 1
			 and pd.TaskKey = ta1.TaskKey),0) as OpenPOToBeBilled 
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tPurchaseOrderDetail'
			 and pd.TaskKey = ta1.TaskKey),0) as OpenPOOnBW 
		
		-- VD
		,ISNULL((select sum(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.TaskKey = ta1.TaskKey),0) as VoucherAmt
		,ISNULL((select sum(AmountBilled) 
			from tVoucherDetail (nolock)
				inner join tInvoiceLine il (nolock) on tVoucherDetail.InvoiceLineKey = il.InvoiceLineKey 
		   where tVoucherDetail.TaskKey = ta1.TaskKey 
			 --and InvoiceLineKey >0
			 and il.InvoiceKey  <> @InvoiceKey
			 ),0) as VoucherAmtBilled
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tVoucherDetail'
			 and Action = 1
			 and vd.TaskKey = ta1.TaskKey),0) as VoucherToBeBilled 			 
		,ISNULL((select sum(Total) 
			from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tVoucherDetail'
			 and vd.TaskKey = ta1.TaskKey),0) as VoucherOnBW 			 
		
		,isnull((select TaskID 
				   from tTask ta2 (nolock) 
				  where ta1.SummaryTaskKey = ta2.TaskKey), '') as summaryTaskID
		
		-- Billed Amounts
		,isnull((select sum(TotalAmount) 
				   from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
				  where tInvoiceLine.TaskKey = ta1.TaskKey 
					and tInvoiceLine.BillFrom = 1 
					and tInvoice.InvoiceKey <> @InvoiceKey
					and tInvoice.AdvanceBill = 0), 0) as AmountBilledNoDetail

		,isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.TaskKey = ta1.TaskKey 
				), 0) as AmountNotSelected
		
		,0 as InvoiceLineKey
		,cast(0 as Money) as InvoiceLineAmount
		,round(ta1.PercComp,2) as PercComp

		-- Marked As Billed
		,isnull((select sum(round(BilledHours * BilledRate, 2)) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = ta1.TaskKey 
		and InvoiceLineKey = 0
		), 0) 
		+ ISNULL((select sum(AmountBilled) 
			from tExpenseReceipt (nolock) 
		   where tExpenseReceipt.TaskKey = ta1.TaskKey 
			 and InvoiceLineKey =0),0) 
		+ ISNULL((select sum(AmountBilled) 
			from tMiscCost (nolock) 
		   where ISNULL(tMiscCost.TaskKey, 0) = ta1.TaskKey 
		     and tMiscCost.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0),0) 
		+ ISNULL((select sum(AmountBilled) 
			from tVoucherDetail (nolock)
		   where tVoucherDetail.TaskKey = ta1.TaskKey 
			 and InvoiceLineKey =0),0) 	 			 
		+ISNULL((select sum(AmountBilled) 
			from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		   where ISNULL(pd.TaskKey, 0) = ta1.TaskKey 
			 and pd.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0), 0)
	
		as AmountMarkAsBilled
	from tTask ta1 (nolock)
   where ta1.ProjectKey = @ProjectKey
     and ta1.MoneyTask = 1

UNION ALL


select 
	 -1 AS TaskKey	-- Because of rollup routines, return -1 rather than 0
	,'[No Task]' AS TaskID
	,'' As TaskName
	,0 AS TaskLevel
	,2 AS TaskType
	,2 AS BudgetTaskType
	,0 AS SummaryTaskKey
	,1 AS MoneyTask
	,0 AS HideFromClient
	,0 AS EstLabor
	,0 AS EstExpenses
	,0 AS EstHours
	,0 AS BudgetLabor
	,0 AS BudgetExpenses
	,0 AS ApprovedCOHours
	,0 AS ApprovedCOLabor
	,0 AS ApprovedCOBudgetLabor
	,0 AS ApprovedCOExpense
	,0 AS ApprovedCOBudgetExp
	,-1 AS ProjectOrder
	,-1 AS DisplayOrder
	,@ProjectKey AS ProjectKey
    ,(select sum(ti.ActualHours) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = 0
	) as ActHours
	,(select sum(round(ActualHours * ActualRate, 2)) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = 0
	) as ActualLabor
	,(select sum(round(BilledHours * BilledRate, 2)) 
		from tTime ti (nolock) 
		inner join tInvoiceLine il (nolock) on ti.InvoiceLineKey = il.InvoiceLineKey
		Where ti.ProjectKey = @ProjectKey 
		and isnull(ti.TaskKey,0) = 0 
	    --and InvoiceLineKey >0
        and il.InvoiceKey <> @InvoiceKey
	) as ActualLaborBilled
	,0 as LaborToBeBilled 
	,0 as LaborOnBW

		,(select sum(BillableCost) 
			from tExpenseReceipt (nolock)
		   where ISNULL(tExpenseReceipt.TaskKey, 0) = 0
		   and tExpenseReceipt.ProjectKey = @ProjectKey
		   and tExpenseReceipt.VoucherDetailKey IS NULL
		   ) as ExpReceiptAmt
		,(select sum(AmountBilled) 
			from tExpenseReceipt (nolock) 
				inner join tInvoiceLine il (nolock) on tExpenseReceipt.InvoiceLineKey = il.InvoiceLineKey 
		   where ISNULL(tExpenseReceipt.TaskKey, 0) = 0
		     and tExpenseReceipt.ProjectKey = @ProjectKey
			 --and InvoiceLineKey >0
			 and il.InvoiceKey <> @InvoiceKey
			 ) as ExpReceiptAmtBilled
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tExpenseReceipt' 
			 and Action = 1
			 and ISNULL(er.TaskKey, 0) = 0
			 and er.ProjectKey = @ProjectKey) as ExpReceiptToBeBilled
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tExpenseReceipt' 
			 and ISNULL(er.TaskKey, 0) = 0
			 and er.ProjectKey = @ProjectKey) as ExpReceiptOnBW 			 
		,(select sum(BillableCost) 
			from tMiscCost (nolock) 
		   where ISNULL(tMiscCost.TaskKey, 0) = 0
		     and tMiscCost.ProjectKey = @ProjectKey) as MiscCostAmt
		,(select sum(AmountBilled) 
			from tMiscCost (nolock) 
				inner join tInvoiceLine il (nolock) on tMiscCost.InvoiceLineKey = il.InvoiceLineKey 
		   where ISNULL(tMiscCost.TaskKey, 0) = 0 
		     and tMiscCost.ProjectKey = @ProjectKey
			 --and InvoiceLineKey >0
			 and il.InvoiceKey <> @InvoiceKey
			 ) as MiscCostAmtBilled
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tMiscCost' 
			 and Action = 1
			 and ISNULL(mc.TaskKey, 0) = 0
			 and mc.ProjectKey = @ProjectKey) as MiscCostToBeBilled 
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tMiscCost' 
			 and ISNULL(mc.TaskKey, 0) = 0
			 and mc.ProjectKey = @ProjectKey) as MiscCostOnBW 
		,(select sum(TotalCost - isnull(AppliedCost, 0)) 
			from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		   where p.Closed = 0 
			 and ISNULL(pd.TaskKey, 0) = 0
			 and pd.ProjectKey = @ProjectKey) as OpenPOAmt
		,(select sum(AmountBilled) 
			from tPurchaseOrderDetail pd (nolock) 
				inner join tInvoiceLine il (nolock) on pd.InvoiceLineKey = il.InvoiceLineKey 
		     where ISNULL(pd.TaskKey, 0) = 0 
			 and pd.ProjectKey = @ProjectKey
			 --and InvoiceLineKey >0
			 and il.InvoiceKey <> @InvoiceKey
			 ) as OpenPOAmtBilled
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tPurchaseOrderDetail'
			 and Action = 1
			 and ISNULL(pd.TaskKey, 0) = 0
			 and pd.ProjectKey = @ProjectKey) as OpenPOToBeBilled 
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tPurchaseOrderDetail pd (nolock) on bd.EntityKey = pd.PurchaseOrderDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tPurchaseOrderDetail'
			 and ISNULL(pd.TaskKey, 0) = 0
			 and pd.ProjectKey = @ProjectKey) as OpenPOOnBW 
		,(select sum(BillableCost) 
			from tVoucherDetail (nolock)
			where ISNULL(tVoucherDetail.TaskKey, 0) = 0
			and tVoucherDetail.ProjectKey = @ProjectKey) as VoucherAmt
		,(select sum(AmountBilled) 
			from tVoucherDetail (nolock)
		   		inner join tInvoiceLine il (nolock) on tVoucherDetail.InvoiceLineKey = il.InvoiceLineKey 
		   where ISNULL(tVoucherDetail.TaskKey, 0) = 0
		     and tVoucherDetail.ProjectKey = @ProjectKey 
			 --and InvoiceLineKey >0
			 and il.InvoiceKey <> @InvoiceKey
			 ) as VoucherAmtBilled
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tVoucherDetail'
			 and Action = 1
			 and ISNULL(vd.TaskKey, 0) = 0
			 and vd.ProjectKey = @ProjectKey) as VoucherToBeBilled		 
		,(select sum(Total) 
			from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
		   where bd.BillingKey = @BillingKey 
			 and bd.Entity = 'tVoucherDetail'
			 and ISNULL(vd.TaskKey, 0) = 0
			 and vd.ProjectKey = @ProjectKey) as VoucherOnBW 			 
		,'' as summaryTaskID
		,isnull((select sum(TotalAmount) 
				   from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
				  where ISNULL(tInvoiceLine.TaskKey, 0) = 0
					and tInvoiceLine.ProjectKey = @ProjectKey 
					and tInvoiceLine.BillFrom = 1
					and tInvoice.InvoiceKey <> @InvoiceKey 
					and tInvoice.AdvanceBill = 0), 0) as AmountBilledNoDetail
				
		,isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where ISNULL(vBillingItemSelect.TaskKey, 0) = 0
					and vBillingItemSelect.ProjectKey = @ProjectKey  
				), 0) as AmountNotSelected
	,0 as InvoiceLineKey
	,cast(0 as Money) as InvoiceLineAmount
	,0 as PercComp
	,isnull((select sum(round(BilledHours * BilledRate, 2)) from tTime ti (nolock) Where ti.ProjectKey = @ProjectKey and isnull(ti.TaskKey,0) = 0 
	and InvoiceLineKey = 0
	), 0) 
	+ ISNULL((select sum(AmountBilled) 
			from tExpenseReceipt (nolock) 
		   where isnull(tExpenseReceipt.TaskKey, 0) = 0 
		     and  tExpenseReceipt.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0),0) 
	+ ISNULL((select sum(AmountBilled) 
			from tMiscCost (nolock) 
		   where ISNULL(tMiscCost.TaskKey, 0) = 0 
		     and tMiscCost.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0),0) 	
	+ ISNULL((select sum(AmountBilled) 
			from tVoucherDetail (nolock)
		   where tVoucherDetail.TaskKey = 0 
		     and tVoucherDetail.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0),0) 	 			 
	+ISNULL((select sum(AmountBilled) 
			from tPurchaseOrderDetail pd (nolock) inner join tPurchaseOrder p (nolock) on pd.PurchaseOrderKey = p.PurchaseOrderKey
		   where ISNULL(pd.TaskKey, 0) = 0 
			 and pd.ProjectKey = @ProjectKey
			 and InvoiceLineKey =0),0)
			 			 	 
	as AmountMarkAsBilled
		
order by SummaryTaskKey, DisplayOrder

*/
GO
