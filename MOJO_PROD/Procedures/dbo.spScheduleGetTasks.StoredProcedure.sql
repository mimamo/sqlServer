USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleGetTasks]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleGetTasks]
	(
		@ProjectKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 11/22/06 GHL 8.4   Removed restriction on ScheduleTask 
  || 11/09/12 RLB 10561 Added 2 fields for Kohls changes
  */

	SET NOCOUNT ON

	SELECT	TaskType	-- 1 Summary, 2 Tracking
			,TaskKey
			,SummaryTaskKey
			,CAST(TaskName AS VARCHAR(500)) AS TaskName
			,TaskID
			,TaskConstraint
			,ConstraintDate
			,PlanDuration AS Duration
			,ActStart
			,ActComplete
			,PlanStart
			,PlanComplete
			,PercComp
			,PercCompSeparate
			,PredecessorsComplete
			,WorkAnyDay
			,EventStart
			,EventEnd
			,(SELECT COUNT(*) FROM tTask t2 (NOLOCK) 
				WHERE t2.ProjectKey = @ProjectKey
				AND   t2.SummaryTaskKey = tTask.TaskKey) AS SubtaskCount
			,ScheduleTask
			,MoneyTask
			,TrackBudget
			,ProjectOrder
			,DisplayOrder
			,TaskLevel
			,BudgetTaskKey
			,ConstraintDayOfTheWeek
			,ExcludeFromStatus
	FROM	tTask (NOLOCK)
	WHERE	ProjectKey = @ProjectKey
	
	RETURN 1
GO
