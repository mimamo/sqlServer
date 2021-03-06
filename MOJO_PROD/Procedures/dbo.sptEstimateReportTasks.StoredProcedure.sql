USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateReportTasks]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateReportTasks]
	@EstimateKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 4/23/10   CRG 10.5.2.1 Modified to pull from tEstimateTaskTemp if the estimate was generated from an opportunity
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

declare @ProjectKey int
Declare @EstimateType smallint
Declare @ApprovedQty smallint
Declare @LeadKey int


	select @ProjectKey = isnull(ProjectKey,0)
	      ,@EstimateType = EstType
	      ,@ApprovedQty = ApprovedQty
	      ,@LeadKey = LeadKey
	  from tEstimate (nolock)
	 where EstimateKey = @EstimateKey
	 
If @EstimateType = 1
	IF EXISTS(
			SELECT	NULL
			FROM	tEstimateTaskTemp (nolock)
			WHERE	Entity = 'tLead'
			AND		EntityKey = @LeadKey)	
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(EstLabor) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(EstExpenses) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstExpenses
		  from tEstimateTaskTemp ta (nolock)
		 where ta.Entity = 'tLead'
		   and ta.EntityKey = @LeadKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END
	ELSE
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(EstLabor) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(EstExpenses) from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstExpenses
		  from tTask ta (nolock)
		 where ta.ProjectKey = @ProjectKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END  
If @EstimateType = 2
	IF EXISTS(
			SELECT	NULL
			FROM	tEstimateTaskTemp (nolock)
			WHERE	Entity = 'tLead'
			AND		EntityKey = @LeadKey)	
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(case 
					when @ApprovedQty = 1 Then BillableCost
					when @ApprovedQty = 2 Then BillableCost2
					when @ApprovedQty = 3 Then BillableCost3
					when @ApprovedQty = 4 Then BillableCost4
					when @ApprovedQty = 5 Then BillableCost5
					when @ApprovedQty = 6 Then BillableCost6											 
					end)
			from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey),0) as EstExpenses
		  from tEstimateTaskTemp ta (nolock)
		 where ta.Entity = 'tLead'
		   and ta.EntityKey = @LeadKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END
	ELSE
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(case 
					when @ApprovedQty = 1 Then BillableCost
					when @ApprovedQty = 2 Then BillableCost2
					when @ApprovedQty = 3 Then BillableCost3
					when @ApprovedQty = 4 Then BillableCost4
					when @ApprovedQty = 5 Then BillableCost5
					when @ApprovedQty = 6 Then BillableCost6											 
					end)
			from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey),0) as EstExpenses
		  from tTask ta (nolock)
		 where ta.ProjectKey = @ProjectKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END
If @EstimateType = 3
	IF EXISTS(
			SELECT	NULL
			FROM	tEstimateTaskTemp (nolock)
			WHERE	Entity = 'tLead'
			AND		EntityKey = @LeadKey)	
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(case 
					when @ApprovedQty = 1 Then BillableCost
					when @ApprovedQty = 2 Then BillableCost2
					when @ApprovedQty = 3 Then BillableCost3
					when @ApprovedQty = 4 Then BillableCost4
					when @ApprovedQty = 5 Then BillableCost5
					when @ApprovedQty = 6 Then BillableCost6											 
					end)
			from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey),0) as EstExpenses	  
			from tEstimateTaskTemp ta (nolock)
		 where ta.Entity = 'tLead'
		   and ta.EntityKey = @LeadKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END
	ELSE
	BEGIN
		select ta.TaskKey
			  ,ta.TaskName
			  ,ta.TaskLevel
			  ,ta.TaskType
			  ,case when ta.TaskType = 1 and isnull(ta.TrackBudget,0) = 0 then 1
				else 2 end as BudgetTaskType
			  ,ta.SummaryTaskKey
			  ,ta.ShowDescOnEst
			  ,ta.Description
			  ,ta.ProjectOrder
			  ,ISNULL((Select Sum(Hours) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstHours
			  ,ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey), 0) as EstLabor
			  ,ISNULL((Select Sum(case 
					when @ApprovedQty = 1 Then BillableCost
					when @ApprovedQty = 2 Then BillableCost2
					when @ApprovedQty = 3 Then BillableCost3
					when @ApprovedQty = 4 Then BillableCost4
					when @ApprovedQty = 5 Then BillableCost5
					when @ApprovedQty = 6 Then BillableCost6											 
					end)
			from tEstimateTaskExpense (nolock) Where EstimateKey = @EstimateKey and TaskKey = ta.TaskKey),0) as EstExpenses	  
			from tTask ta (nolock)
		 where ta.ProjectKey = @ProjectKey
		   and ta.MoneyTask = 1
	  order by ta.ProjectOrder
	END  
  
	RETURN 1
GO
