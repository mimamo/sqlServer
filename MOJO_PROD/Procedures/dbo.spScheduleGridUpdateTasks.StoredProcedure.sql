USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleGridUpdateTasks]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleGridUpdateTasks]
	(
		@ProjectKey INT
		,@UserKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 12/06/06 GHL 8.4   Added roll down for tTaskUser records
  || 12/14/06 GHL 8.4   Added cleanup of Actuals for Summary tasks 
  || 01/03/07 GHL 8.4   Added patch to cleanup SummaryTaskKey = TaskKey situation
  || 01/04/07 GHL 8.4   Added protection against null PercComp
  || 01/19/07 GHL 8.4   Added logic for Completed Time and User
  */
  
	SET NOCOUNT ON

	-- Set Task Completion status
	UPDATE #tTask
	SET    #tTask.Completed = 1 
	FROM   tTask b (NOLOCK)
	WHERE  #tTask.TaskKey = b.TaskKey
	AND    b.PercCompSeparate = 0	
	AND    ISNULL(#tTask.PercComp, 0) >= 100
	AND    ISNULL(b.PercComp, 0) <> 100
	
	-- Update Actual Info
	
	UPDATE	tTask
		SET tTask.ActStart = 
				CASE WHEN tTask.PercCompSeparate = 0 THEN #tTask.ActStart
				ELSE tTask.ActStart
				END
			,tTask.ActComplete = 
			CASE WHEN tTask.PercCompSeparate = 0 THEN #tTask.ActComplete
				ELSE tTask.ActComplete
				END
			--,tTask.TaskConstraint = #tTask.TaskConstraint -- Could be changed on the grid
			,tTask.ConstraintDate = #tTask.ConstraintDate
			,tTask.PlanDuration = #tTask.Duration
			,tTask.PercComp = 
				CASE WHEN tTask.PercCompSeparate = 0 THEN ISNULL(#tTask.PercComp, 0)
				ELSE ISNULL(tTask.PercComp, 0)
				END		
			,tTask.CompletedByDate =
				CASE WHEN #tTask.Completed = 1 THEN GETUTCDATE()
				ELSE tTask.CompletedByDate
				END
			,tTask.CompletedByKey =
				CASE WHEN #tTask.Completed = 1 THEN @UserKey
				ELSE tTask.CompletedByKey
				END		
	FROM	#tTask
	WHERE	tTask.ProjectKey = @ProjectKey
	AND		tTask.TaskKey = #tTask.TaskKey
	AND		#tTask.TaskType = 2

	UPDATE tTask SET SummaryTaskKey = 0 WHERE ProjectKey = @ProjectKey AND TaskKey = SummaryTaskKey 	

	UPDATE tTask Set ActStart = NULL, ActComplete = NULL WHERE ProjectKey = @ProjectKey AND TaskType = 1
	 
	-- Do the rolldown when PercCompSeparate = 0
	DECLARE @TaskKey INT
	SELECT @TaskKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TaskKey = MIN(TaskKey)
		FROM   tTask (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    TaskKey > @TaskKey
		AND    PercCompSeparate = 0
		
		IF @TaskKey IS NULL
			BREAK
		
		EXEC sptTaskUserRolldown @TaskKey
	
	END
	
	RETURN 1
GO
