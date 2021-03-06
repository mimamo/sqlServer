USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskGetTree]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskGetTree]
	@EstimateKey int
	,@ProjectKey int = null

AS --Encrypt

/*
|| When     Who Rel   What
|| 09/21/06 CRG 8.35  If the Project Billing "Get Rate From" is set to "Task" and the Estimate Type is set to "Task Only",
||                    and the Estimate Task Rate is still NULL, then default the Rate to tTask.HourlyRate
|| 12/05/06 GHL 8.4   Added missing columns TrackBudget and NonTrackSummary when EstType = 1  
|| 12/11/09 GHL 10.515 Added BudgetTaskType to make it similar to other budget/estimate screens
|| 02/03/10 GHL 10.518 Added ProjectKey param for the case when EstimateKey = 0 (Flash screen)
|| 11/11/10 GHL 10.538 (92349) Added tEstimateTask.Comments
*/

	declare @EstType smallint,
			@GetRateFrom smallint

	if isnull(@EstimateKey, 0) = 0
		select @EstType = 1
	else
		select	@ProjectKey = isnull(ProjectKey,0),
				@EstType = EstType
		  from tEstimate (nolock)
		 where EstimateKey = @EstimateKey

	SELECT	@GetRateFrom = GetRateFrom
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	IF @GetRateFrom = 6 AND @EstType = 1
		select ta1.TaskKey
			,ta1.TaskID
			,ta1.TaskName
			,ta1.TaskLevel
			,ta1.TaskType
			,ta1.Markup
			,ta1.SummaryTaskKey
			,ta1.TaskConstraint
			,ta1.MoneyTask
			,ta1.ScheduleTask
			,ta1.ShowDescOnEst
			,ta1.Description
			,ta1.ProjectOrder
			,ta1.TrackBudget
			,case
				when ta1.TaskType=1 and isnull(ta1.TrackBudget,0) = 0 then 1
				else 0
			end as NonTrackSummary
			,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
			else 2 end as BudgetTaskType
			,et.EstimateKey
			,et.EstimateTaskKey
			,et.Hours
			,isnull(et.Cost, et.Rate) As Cost
			,round(isnull(et.Cost, isnull(et.Rate, 0)) * isnull(et.Hours, 0), 2) as BudgetLabor 
			,ISNULL(et.Rate, ta1.HourlyRate) AS Rate
			,et.EstLabor
			,et.BudgetExpenses
			,et.Markup as EstMarkup
			,et.EstExpenses
			,(select sum(et2.Hours * et2.Cost)
			from  tTask ta2 (nolock)
					inner join tEstimateTask et2 (nolock) on et2.TaskKey = ta2.TaskKey
				where ta2.SummaryTaskKey = ta1.TaskKey
				and   et2.EstimateKey = @EstimateKey
				) AS DetailBudgetLabor						-- To display on estimate_tasks.aspx grid
			,et.Comments
		from tTask ta1 (nolock)
			left outer join tEstimateTask et (nolock) on ta1.TaskKey = et.TaskKey 
			and et.EstimateKey = @EstimateKey
		where ta1.ProjectKey = @ProjectKey
		and isnull(ta1.MoneyTask,0) = 1
		order by ta1.ProjectOrder
	ELSE	 
		select ta1.TaskKey
			,ta1.TaskID
			,ta1.TaskName
			,ta1.TaskLevel
			,ta1.TaskType
			,ta1.Markup
			,ta1.SummaryTaskKey
			,ta1.TaskConstraint
			,ta1.MoneyTask
			,ta1.ScheduleTask
			,ta1.ShowDescOnEst
			,ta1.Description
			,ta1.ProjectOrder
			,ta1.TrackBudget
			,case
				when ta1.TaskType=1 and isnull(ta1.TrackBudget,0) = 0 then 1
				else 0
			end as NonTrackSummary
			,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
			else 2 end as BudgetTaskType
			,et.EstimateKey
			,et.EstimateTaskKey
			,et.Hours
			,isnull(et.Cost, et.Rate) As Cost
			,round(isnull(et.Cost, isnull(et.Rate, 0)) * isnull(et.Hours, 0), 2) as BudgetLabor 
			,et.Rate
			,et.EstLabor
			,et.BudgetExpenses
			,et.Markup as EstMarkup
			,et.EstExpenses
			,(select sum(et2.Hours * et2.Cost)
			from  tTask ta2 (nolock)
					inner join tEstimateTask et2 (nolock) on et2.TaskKey = ta2.TaskKey
				where ta2.SummaryTaskKey = ta1.TaskKey
				and   et2.EstimateKey = @EstimateKey
				) AS DetailBudgetLabor						-- To display on estimate_tasks.aspx grid
			,et.Comments
		from tTask ta1 (nolock)
			left outer join tEstimateTask et (nolock) on ta1.TaskKey = et.TaskKey 
			and et.EstimateKey = @EstimateKey
		where ta1.ProjectKey = @ProjectKey
		and isnull(ta1.MoneyTask,0) = 1
		order by ta1.ProjectOrder
	 
	 
	RETURN 1
GO
