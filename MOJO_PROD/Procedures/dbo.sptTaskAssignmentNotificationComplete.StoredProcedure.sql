USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentNotificationComplete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentNotificationComplete]
	(
		@TaskAssignmentKey INT
	)
AS
	SET NOCOUNT ON
	
	DECLARE @TaskKey INT
			,@WorkOrder INT
			,@NextWorkOrder INT
			
	SELECT 	@TaskKey = TaskKey
			,@WorkOrder = WorkOrder
	FROM    tTaskAssignment (NOLOCK)
	WHERE   TaskAssignmentKey = @TaskAssignmentKey
	AND     PercComp = 100
	
	-- This one not complete
	IF @@ROWCOUNT = 0
		RETURN

	-- Not all complete for this work order	
	IF EXISTS (SELECT 1
				FROM  tTaskAssignment (NOLOCK)
				WHERE TaskKey = @TaskKey
				AND   WorkOrder = @WorkOrder
				AND   PercComp <> 100)
		RETURN		

	-- Are there next TAs for the task?
	SELECT @NextWorkOrder = MIN(WorkOrder)
				FROM  tTaskAssignment (NOLOCK)
				WHERE TaskKey = @TaskKey
				AND   WorkOrder > @WorkOrder
		
	IF @NextWorkOrder IS NOT NULL
	BEGIN
	
		-- Only notify if ActStart is not null
		SELECT  1 AS TaskMode
				,p.ProjectNumber
				,p.ProjectName
				,t.TaskKey
				,t.TaskID
				,t.TaskName
				,ta.TaskAssignmentKey
				,ta.Title
				,ta.WorkDescription
				,ta.DueBy
				,ta.PlanComplete
				,ta.WorkOrder
				,ta.PercComp
				,ta.ActStart
				,u.UserKey
				,u.Email
				,u.LastName
				,u.FirstName
		FROM    tTaskAssignmentUser tau (NOLOCK)
			INNER JOIN tUser u (NOLOCK) ON tau.UserKey = u.UserKey
			INNER JOIN tTaskAssignment ta (NOLOCK) on tau.TaskAssignmentKey = ta.TaskAssignmentKey
			INNER JOIN tTask t (NOLOCK) ON t.TaskKey = ta.TaskKey
			INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey		
		WHERE ta.TaskKey = @TaskKey
		AND   ta.WorkOrder = @NextWorkOrder
		AND   ta.ActStart IS NULL
							
	END
	ELSE
	BEGIN
		-- No next work order for this task
		-- Try next task, take them all and analyze in VB to get min WorkOrder
		SELECT  2 AS TaskMode
				,p.ProjectNumber
				,p.ProjectName
				,t.TaskKey
				,t.TaskID
				,t.TaskName
				,ta.TaskAssignmentKey
				,ta.Title
				,ta.WorkDescription
				,ta.DueBy
				,ta.PlanComplete
				,ta.WorkOrder
				,ta.PercComp
				,ta.ActStart
				,u.UserKey
				,u.Email
				,u.LastName
				,u.FirstName
		FROM    tTaskAssignmentUser tau (NOLOCK)
			INNER JOIN tUser u (NOLOCK) ON tau.UserKey = u.UserKey
			INNER JOIN tTaskAssignment ta (NOLOCK) ON tau.TaskAssignmentKey = ta.TaskAssignmentKey
			INNER JOIN tTaskPredecessor tp (NOLOCK) ON tp.TaskKey = ta.TaskKey
			INNER JOIN tTask t (NOLOCK) ON t.TaskKey = ta.TaskKey
			INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey		
		WHERE tp.PredecessorKey = @TaskKey
					
	END													 		
		
	RETURN
GO
