USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateRollupDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateRollupDetail]

	(
		@ProjectKey int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/20/07 GHL 8.4   Added validation before inserts into tProjectEstByItem        
  || 10/16/07 GHL 8.5   Added clearing of sales taxes in tProject 
  || 01/06/10 GHL 10.516 Added call to sptProjectRollupUpdate  
  || 02/11/10 GHL 10.518 Added check of ProjectKey since estimates may not have a project key
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))       
  || 10/13/14 GHL 10.585 Added update of tProjectEstByTitle
  || 10/23/14 GHL 10.585 Add to tProjectEstByTitle estimates that do not use titles (mixed mode) 
  || 03/09/15 GHL 10.690 Added deletion of records where everything = 0
  */
  
  if isnull(@ProjectKey, 0) = 0
	return 1

	declare @UseBillingTitles int
	select @UseBillingTitles = pref.UseBillingTitles
	from   tPreference pref (nolock)
		inner join tProject p (nolock) on p.CompanyKey = pref.CompanyKey
	where  p.ProjectKey = @ProjectKey
	select @UseBillingTitles = isnull(@UseBillingTitles, 0)

	-- Must check all estimates for a project with ExternalStatus or ExternalStatus = 4 
	If Not Exists (Select 1
					From  tEstimate (nolock)
					Where ProjectKey = @ProjectKey
					And ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))
					)
		Begin
			Update tTask
			Set EstHours = 0
			   ,EstLabor = 0
			   ,BudgetExpenses = 0
			   ,EstExpenses = 0
			   ,ApprovedCOHours = 0
			   ,ApprovedCOLabor = 0
			   ,ApprovedCOBudgetExp = 0
			   ,ApprovedCOExpense = 0
			   ,Contingency = 0
			   ,BudgetLabor = 0
			   ,ApprovedCOBudgetLabor = 0			   
			Where ProjectKey = @ProjectKey

			Update tProject
			Set EstHours = 0
			   ,EstLabor = 0
			   ,BudgetExpenses = 0
			   ,EstExpenses = 0
			   ,ApprovedCOHours = 0
			   ,ApprovedCOLabor = 0
			   ,ApprovedCOBudgetExp = 0
			   ,ApprovedCOExpense = 0
			   ,Contingency = 0
			   ,BudgetLabor = 0
			   ,ApprovedCOBudgetLabor = 0
			   ,SalesTax = 0
			   ,ApprovedCOSalesTax = 0
			Where ProjectKey = @ProjectKey
			
			Delete tProjectEstByItem Where ProjectKey = @ProjectKey
			if @UseBillingTitles = 1
				Delete tProjectEstByTitle Where ProjectKey = @ProjectKey

			-- call project rollup to update tProjectRollup and tProjectItemRollup, 9 indicates Estimate data only
			exec sptProjectRollupUpdate @ProjectKey, 9, 0,0,0,0
			
			Return 1   
		End				
		
	Update tTask
	Set
		 EstHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = tTask.TaskKey), 0)
		,BudgetLabor = ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = tTask.TaskKey), 0)
		,EstLabor = ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 0 and etl.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = tTask.TaskKey), 0)
		,BudgetExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and ete.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.BudgetExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = tTask.TaskKey), 0)
		,EstExpenses =  ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and ete.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0 and et.TaskKey = tTask.TaskKey), 0)
		,ApprovedCOHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = tTask.TaskKey), 0)
		,ApprovedCOBudgetLabor = ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = tTask.TaskKey), 0)
		,ApprovedCOLabor = ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and etl.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = tTask.TaskKey), 0)
		,ApprovedCOBudgetExp = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and ete.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.BudgetExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = tTask.TaskKey), 0)
		,ApprovedCOExpense =  ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and ete.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1 and et.TaskKey = tTask.TaskKey), 0)
		,Contingency = ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * e.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and etl.TaskKey = tTask.TaskKey), 0)
			+
			ISNULL((Select Sum((ISNULL(et.EstLabor, 0)) * e.Contingency / 100 ) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and et.TaskKey = tTask.TaskKey), 0)
			
		Where
		ProjectKey = @ProjectKey


	-- Because of expenses without tasks, update from the source for expenses otherwise use the tasks

	Update tProject
	Set
		 EstHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0), 0)
			+
			ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,BudgetLabor = ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
			+
			ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 0), 0)
		,EstLabor = ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 0), 0)
			+
			ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,BudgetExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0), 0)
			+
			ISNULL((Select Sum(et.BudgetExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,EstExpenses = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0), 0)
			+
			ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,SalesTax = ISNULL((Select Sum(ISNULL(SalesTaxAmount,0) + ISNULL(SalesTax2Amount,0))
			from tEstimate e (nolock)
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and  e.ChangeOrder = 0), 0)
		,ApprovedCOHours = ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1), 0)
			+
			ISNULL((Select Sum(et.Hours) 
			from tEstimateTask et (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey 
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,ApprovedCOBudgetLabor = ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
			+
			ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))   
			and e.EstType > 1 and e.ChangeOrder = 1), 0)
		,ApprovedCOLabor = ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2)) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1), 0)
			+
			ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,ApprovedCOExpense = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.BillableCost
											 when e.ApprovedQty = 2 Then ete.BillableCost2
											 when e.ApprovedQty = 3 Then ete.BillableCost3
											 when e.ApprovedQty = 4 Then ete.BillableCost4
											 when e.ApprovedQty = 5 Then ete.BillableCost5
											 when e.ApprovedQty = 6 Then ete.BillableCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1), 0)
			+
			ISNULL((Select Sum(et.EstExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,ApprovedCOBudgetExp = ISNULL((Select Sum(case 
											 when e.ApprovedQty = 1 Then ete.TotalCost
											 when e.ApprovedQty = 2 Then ete.TotalCost2
											 when e.ApprovedQty = 3 Then ete.TotalCost3
											 when e.ApprovedQty = 4 Then ete.TotalCost4
											 when e.ApprovedQty = 5 Then ete.TotalCost5
											 when e.ApprovedQty = 6 Then ete.TotalCost6											 
											 end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1), 0)
			+
			ISNULL((Select Sum(et.BudgetExpenses) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,ApprovedCOSalesTax = ISNULL((Select Sum(ISNULL(SalesTaxAmount,0) + ISNULL(SalesTax2Amount,0))
			from tEstimate e (nolock)
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.ChangeOrder = 1), 0)
		,Contingency = ISNULL((Select Sum((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * e.Contingency / 100 ) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1), 0)
			+
			ISNULL((Select Sum((ISNULL(et.EstLabor, 0)) * e.Contingency / 100 ) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1), 0)
	Where
		ProjectKey = @ProjectKey

	/*
							How to populate tProjectEstByItem
	
	Entity = tItem			EstType = 1									EstType >1
	---------------------------------------------------------------------------------------------						
	Qty							0								tEstimateTaskExpense.Quantity
	
	Net				tEstimateTask.BudgetExpenses				tEstimateTaskExpense.TotalCost
	
	Gross			tEstimateTask.NetExpenses					tEstimateTaskExpense.BillableCost
																(based on tEstimate.ApprovedQty)
	
	Entity = tService		EstType = 1									EstType >1
	----------------------------------------------------------------------------------------------						
	Qty				tEstimateTask.Hours							tEstimateTaskLabor.Hours
	
	Net				tEstimateTask.Hours							tEstimateTaskLabor.Hours
					* tEstimateTask.Cost						* etl.Cost
																
	Gross			tEstimateTask.Hours							tEstimateTaskLabor.Hours
					* tEstimateTask.Rate						* etl.Rate
							OR
					tEstimateTask.EstLabor		
					
	*/

	-- If missing records for EntityKey = 0, add them 
	IF NOT EXISTS (SELECT 1 FROM tProjectEstByItem (NOLOCK)
		WHERE ProjectKey = @ProjectKey
		AND   Entity = 'tItem'
		AND   EntityKey = 0)
	-- Always take ItemKey = 0 for tEstimateTask records
	INSERT tProjectEstByItem (ProjectKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT @ProjectKey, 'tItem', 0, 0,0,0,0,0,0

	IF NOT EXISTS (SELECT 1 FROM tProjectEstByItem (NOLOCK) 
		WHERE ProjectKey = @ProjectKey
		AND   Entity = 'tService'
		AND   EntityKey = 0)
	-- Always take ServiceKey = 0 for tEstimateTask records
	INSERT tProjectEstByItem (ProjectKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT @ProjectKey, 'tService', 0, 0,0,0,0,0,0
	
	INSERT tProjectEstByItem (ProjectKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT 	DISTINCT @ProjectKey, 'tItem', ISNULL(ete.ItemKey, 0), 0,0,0,0,0,0
	FROM    tEstimateTaskExpense ete (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = ete.EstimateKey 	
	Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	And   isnull(ete.ItemKey, 0) <> 0
	And   isnull(ete.ItemKey, 0) NOT IN (SELECT EntityKey FROM tProjectEstByItem 
								WHERE ProjectKey = @ProjectKey AND Entity = 'tItem') 
		
	INSERT  tProjectEstByItem (ProjectKey, Entity, EntityKey, Qty, Net, Gross, COQty, CONet, COGross)
	SELECT 	DISTINCT @ProjectKey, 'tService', isnull(etl.ServiceKey, 0), 0,0,0,0,0,0
	FROM    tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = etl.EstimateKey 	
	Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	And     isnull(etl.ServiceKey, 0) <> 0
	And     isnull(etl.ServiceKey, 0) NOT IN (SELECT EntityKey FROM tProjectEstByItem 
								WHERE ProjectKey = @ProjectKey AND Entity = 'tService') 
	
	-- only delete when there is a valid item or service i.e. EntityKey > 0
	-- and item or service not on approved estimate
	DELETE tProjectEstByItem 
	WHERE ProjectKey = @ProjectKey 
	AND   EntityKey > 0
	AND   Entity = 'tItem'
	AND   EntityKey NOT IN (SELECT ISNULL(ete.ItemKey, 0)
		FROM    tEstimateTaskExpense ete (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = ete.EstimateKey 	
		Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
		)

	DELETE tProjectEstByItem 
	WHERE ProjectKey = @ProjectKey 
	AND   EntityKey > 0
	AND   Entity = 'tService'
	AND   EntityKey NOT IN (SELECT isnull(etl.ServiceKey, 0)
	FROM    tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = etl.EstimateKey 	
		Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
		)
	
	-- Updates By Item
	
	-- Sum records from tEstimateTaskExpense when EstType > 1
	-- The Qty field does not matter
	UPDATE tProjectEstByItem 
	SET    
		tProjectEstByItem.Qty = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and e.InternalStatus = 4)) 
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0) 
		,tProjectEstByItem.Net = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.TotalCost
							when e.ApprovedQty = 2 Then ete.TotalCost2
							when e.ApprovedQty = 3 Then ete.TotalCost3
							when e.ApprovedQty = 4 Then ete.TotalCost4
							when e.ApprovedQty = 5 Then ete.TotalCost5
							when e.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0) 
		,tProjectEstByItem.Gross = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0) 
		,tProjectEstByItem.COQty = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.Quantity
							when e.ApprovedQty = 2 Then ete.Quantity2
							when e.ApprovedQty = 3 Then ete.Quantity3
							when e.ApprovedQty = 4 Then ete.Quantity4
							when e.ApprovedQty = 5 Then ete.Quantity5
							when e.ApprovedQty = 6 Then ete.Quantity6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0)			 
		,tProjectEstByItem.CONet = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.TotalCost
							when e.ApprovedQty = 2 Then ete.TotalCost2
							when e.ApprovedQty = 3 Then ete.TotalCost3
							when e.ApprovedQty = 4 Then ete.TotalCost4
							when e.ApprovedQty = 5 Then ete.TotalCost5
							when e.ApprovedQty = 6 Then ete.TotalCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0) 
		 ,tProjectEstByItem.COGross = ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(ete.ItemKey, 0) = tProjectEstByItem.EntityKey), 0) 			
	Where tProjectEstByItem.ProjectKey = @ProjectKey 
	AND   tProjectEstByItem.Entity = 'tItem'


	-- Now add records from tEstimateTask when EstType = 1 to the ItemKey = 0 bucket 
	UPDATE tProjectEstByItem
	SET    
		tProjectEstByItem.Net = tProjectEstByItem.Net + ISNULL((Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0) 
		,tProjectEstByItem.Gross = tProjectEstByItem.Gross + ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0) 
		,tProjectEstByItem.CONet = tProjectEstByItem.CONet + ISNULL((Select Sum(et.BudgetExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0) 
		,tProjectEstByItem.COGross = tProjectEstByItem.COGross + ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0) 
	Where tProjectEstByItem.ProjectKey = @ProjectKey 
	AND   tProjectEstByItem.Entity = 'tItem'
	AND   tProjectEstByItem.EntityKey = 0

	-- Updates By Service
	
	-- Sum the records from tEstimateTaskLabor when EstType > 1	
	UPDATE tProjectEstByItem
	SET    
		tProjectEstByItem.Qty = isnull((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0)
		,tProjectEstByItem.Net = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0)
		,tProjectEstByItem.Gross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0) 
		,tProjectEstByItem.COQty = isnull((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0)
		,tProjectEstByItem.CONet = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0)
		,tProjectEstByItem.COGross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
			from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.ServiceKey, 0) = tProjectEstByItem.EntityKey), 0) 
	Where tProjectEstByItem.ProjectKey = @ProjectKey 
	AND   tProjectEstByItem.Entity = 'tService'


	-- Add the records from tEstimateTask to the ServiceKey = 0 records	
	UPDATE tProjectEstByItem
	SET    
		tProjectEstByItem.Qty = tProjectEstByItem.Qty + isnull((Select Sum(et.Hours) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,tProjectEstByItem.Net = tProjectEstByItem.Net + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, 0), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0)
		,tProjectEstByItem.Gross = tProjectEstByItem.Gross + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 0), 0) 
		,tProjectEstByItem.COQty = tProjectEstByItem.COQty + isnull((Select Sum(et.Hours) 
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,tProjectEstByItem.CONet = tProjectEstByItem.CONet + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, 0), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0)
		,tProjectEstByItem.COGross = tProjectEstByItem.COGross + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2))
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			and e.EstType = 1 and e.ChangeOrder = 1), 0) 
	Where tProjectEstByItem.ProjectKey = @ProjectKey 
	AND   tProjectEstByItem.Entity = 'tService'
	AND   tProjectEstByItem.EntityKey = 0
	

	-- we only support titles when by task and service, so read tEstimateTaskLaborTitle
	if @UseBillingTitles = 1
	begin
		delete tProjectEstByTitle where ProjectKey = @ProjectKey

		-- Always take TitleKey = 0 for estimates which do not use billing titles
		INSERT tProjectEstByTitle (ProjectKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
		SELECT @ProjectKey, 0, 0,0,0,0,0,0
		
		INSERT  tProjectEstByTitle (ProjectKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
		SELECT 	DISTINCT @ProjectKey, isnull(etlt.TitleKey, 0), 0,0,0,0,0,0
		FROM    tEstimateTaskLaborTitle etlt (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = etlt.EstimateKey 	
		Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
		

		UPDATE tProjectEstByTitle
		SET    
			tProjectEstByTitle.Qty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0)
			,tProjectEstByTitle.Net = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0)

/* Because we have tEstimateTaskLaborTitle.Gross, do not calculate like below
			,tProjectEstByTitle.Gross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0) 
*/

			,tProjectEstByTitle.Gross = isnull((Select Sum(round(etl.Gross, 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0) 

			,tProjectEstByTitle.COQty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0)
			,tProjectEstByTitle.CONet = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0)

/* Because we have tEstimateTaskLaborTitle.Gross, do not calculate like below
			,tProjectEstByTitle.COGross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0) 
*/
		
		,tProjectEstByTitle.COGross = isnull((Select Sum(round(etl.Gross, 2))
				from tEstimateTaskLaborTitle etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(etl.TitleKey, 0) = tProjectEstByTitle.TitleKey), 0) 

		Where tProjectEstByTitle.ProjectKey = @ProjectKey 


		-- now deal with estimates which do not use title, update where TitleKey = 0
		UPDATE tProjectEstByTitle
		SET    
			tProjectEstByTitle.Qty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(e.UseTitle, 0) = 0), 0)
			,tProjectEstByTitle.Net = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(e.UseTitle, 0) = 0 ), 0)
			,tProjectEstByTitle.Gross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 0 and isnull(e.UseTitle, 0) = 0 ), 0) 
			,tProjectEstByTitle.COQty = isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(e.UseTitle, 0) = 0 ), 0)
			,tProjectEstByTitle.CONet = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(e.UseTitle, 0) = 0), 0)
			,tProjectEstByTitle.COGross = isnull((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0), 2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType > 1 and e.ChangeOrder = 1 and isnull(e.UseTitle, 0) = 0), 0) 
		Where tProjectEstByTitle.ProjectKey = @ProjectKey 
		AND   tProjectEstByTitle.TitleKey = 0


		-- Add the records from tEstimateTask to the TitleKey = 0 records	
		UPDATE tProjectEstByTitle
		SET    
			tProjectEstByTitle.Qty = tProjectEstByTitle.Qty + isnull((Select Sum(et.Hours) 
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 0), 0)
			,tProjectEstByTitle.Net = tProjectEstByTitle.Net + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, 0), 2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 0), 0)
			,tProjectEstByTitle.Gross = tProjectEstByTitle.Gross + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 0), 0) 
			,tProjectEstByTitle.COQty = tProjectEstByTitle.COQty + isnull((Select Sum(et.Hours) 
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 1), 0)
			,tProjectEstByTitle.CONet = tProjectEstByTitle.CONet + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, 0), 2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 1), 0)
			,tProjectEstByTitle.COGross = tProjectEstByTitle.COGross + isnull((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0), 2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				and e.EstType = 1 and e.ChangeOrder = 1), 0) 
		Where tProjectEstByTitle.ProjectKey = @ProjectKey 
		AND   tProjectEstByTitle.TitleKey = 0
		
		/* Because of TitleKey = 0 record, no need to do this
		if not exists (select 1 from tProjectEstByTitle (nolock) where ProjectKey = @ProjectKey) 
		begin
			INSERT tProjectEstByTitle (ProjectKey, TitleKey, Qty, Net, Gross, COQty, CONet, COGross)
			SELECT @ProjectKey, 0 -- zero TitleKey = No Title
			,sum(Qty), sum(Net), sum(Gross), sum(COQty), sum(CONet), sum(COGross)
			from tProjectEstByItem (nolock)
			where ProjectKey = @ProjectKey
			and   Entity = 'tService' -- Labor only
		end
		*/
	
		delete tProjectEstByTitle
		where  ProjectKey = @ProjectKey
		and    isnull(Qty, 0) = 0
		and    isnull(Net, 0) = 0
		and    isnull(Gross, 0) = 0
		and    isnull(COQty, 0) = 0
		and    isnull(CONet, 0) = 0
		and    isnull(COGross, 0) = 0

	end
		
	delete tProjectEstByItem
	where  ProjectKey = @ProjectKey
	and    isnull(Qty, 0) = 0
	and    isnull(Net, 0) = 0
	and    isnull(Gross, 0) = 0
	and    isnull(COQty, 0) = 0
	and    isnull(CONet, 0) = 0
	and    isnull(COGross, 0) = 0

	-- call project rollup to update tProjectRollup and tProjectItemRollup, 9 indicates Estimate data only
	exec sptProjectRollupUpdate @ProjectKey, 9, 0,0,0,0
			
RETURN 1
GO
