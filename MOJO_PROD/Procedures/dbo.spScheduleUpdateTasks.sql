USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleUpdateTasks]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleUpdateTasks]
	(
		@ProjectKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel   What
  || 10/10/06 GHL 8.4   Added cleanup of tTaskUser records for summary tasks (after moves of tasks) 
  || 01/04/07 GHL 8.4   Added protection against null PercComp                   
  || 04/13/07 GHL 8.42  Added update of tProject.TaskStatus       
  || 09/06/07 GHL 8.435 Added patch for incorrect MoneyTask flag     
  || 11/28/07 GHL 8441  Added update of Event Start/End                    
  || 3/11/10  CRG 10.5.1.9 Added code to make sure that any tasks where ShowOnCalendar = 1 have the date part of EventStart/End matching the PlanStart/Complete dates
  || 3/23/11  RLB 10.5.4.2 (106451) only pull tasks with PercComp < 100 when setting project task status
  || 05/29/14 RLB 10.5.8.1 (217472) This check should not be needed and was causing an issue with an enhancement
  */
  
	-- Update Plan and Recalc'ed Info

	UPDATE	tTask
		
		-- For Scheduling
		SET tTask.PlanStart = #tTask.PlanStart
			,tTask.PlanComplete = #tTask.PlanComplete
			,tTask.TaskConstraint = #tTask.TaskConstraint
			,tTask.ConstraintDate = #tTask.ConstraintDate
			,tTask.PlanDuration = #tTask.Duration
			,tTask.PercComp = ISNULL(#tTask.PercComp, 0)
			,tTask.PredecessorsComplete = #tTask.PredecessorsComplete
			,tTask.TaskStatus = #tTask.TaskStatus
			,tTask.ScheduleNote = #tTask.ScheduleNote
			,tTask.EventStart = #tTask.EventStart
			,tTask.EventEnd = #tTask.EventEnd
			,tTask.ShowOnCalendar = CASE WHEN #tTask.EventStart IS NULL THEN 0 ELSE tTask.ShowOnCalendar END 
			
		-- For UI support
			,tTask.TaskType = #tTask.TaskType
			,tTask.SummaryTaskKey = #tTask.SummaryTaskKey
			,tTask.ScheduleTask = #tTask.ScheduleTask
			,tTask.MoneyTask = #tTask.MoneyTask
            ,tTask.TrackBudget = #tTask.TrackBudget
            ,tTask.DisplayOrder = #tTask.DisplayOrder
            ,tTask.ProjectOrder = #tTask.ProjectOrder 
            ,tTask.TaskLevel = #tTask.TaskLevel
			,tTask.BudgetTaskKey = #tTask.BudgetTaskKey
	FROM	#tTask
	WHERE	tTask.ProjectKey = @ProjectKey
	AND		tTask.TaskKey = #tTask.TaskKey

	UPDATE tTask
	SET    tTask.MoneyTask = 1
	FROM   tTask (NOLOCK)
		   ,tTask track (NOLOCK) 
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.ProjectKey = track.ProjectKey 
	AND    tTask.TaskKey = track.SummaryTaskKey 
	AND    track.TrackBudget = 1
	AND    tTask.MoneyTask = 0

	-- Summary tasks are created dynamically now
	-- Must cleanup the user records after moves
	/*
	DELETE tTaskUser
		FROM tTask (NOLOCK) 
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.TaskKey = tTaskUser.TaskKey
	AND    tTask.TaskType = 1 */

	UPDATE tProject 
	SET TaskStatus = ISNULL((SELECT MAX(tTask.TaskStatus) 
		FROM tTask (NOLOCK) 
		WHERE tTask.ProjectKey = tProject.ProjectKey
		AND tTask.PercComp < 100
		AND tTask.ScheduleTask = 1
		AND tTask.TaskType = 2), 1)
	WHERE tProject.ProjectKey = @ProjectKey

	--Make sure that the date parts of EventStart/End match the dates in PlanStart and PlanComplete
	UPDATE	tTask
	SET		EventStart = dbo.fSyncDate(EventStart, PlanStart),
			EventEnd = dbo.fSyncDate(EventEnd, PlanComplete)
	WHERE	ProjectKey = @ProjectKey
	AND		ShowOnCalendar = 1	
			
	RETURN 1
GO
