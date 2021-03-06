USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentReassignUnassigned]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentReassignUnassigned]
	(
		@ProjectKey INT
		,@NewUserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	-- Assign new user to project, this sp will do it with proper hourly rate
	EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey
	
	INSERT	tTaskAssignmentUser (TaskAssignmentKey, UserKey, TaskKey, Hours)
	SELECT	ta.TaskAssignmentKey, @NewUserKey, ta.TaskKey, 0
	FROM	tTaskAssignment ta (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON ta.TaskKey = t.TaskKey
	WHERE	t.ProjectKey = @ProjectKey
	AND		ta.TaskAssignmentKey NOT IN (SELECT tau.TaskAssignmentKey
										 FROM	tTaskAssignmentUser tau (nolock)
											INNER JOIN tTask t2 (NOLOCK) ON tau.TaskKey = t2.TaskKey
											WHERE	t2.ProjectKey = @ProjectKey	  
											)	
	
	RETURN 1
GO
