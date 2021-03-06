USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserReassignUnassigned]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserReassignUnassigned]
	(
		@ProjectKey INT			-- Not NULL, insert for the whole project
		,@NewUserKey INT
		,@TaskKey INT = NULL	-- Not NULL, insert for that task
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 06/04/08 GHL wmj10 Added TaskKey parm to be able to add specific tasks
  || 12/13/10 RLB 10539 (94833) setting defaultservice on servicekey on TaskUser if the new user has one                   
  */
  
	SET NOCOUNT ON

	DECLARE @DefaultServiceKey int

	Select @DefaultServiceKey = DefaultServiceKey From tUser (nolock) where UserKey = @NewUserKey
	
	IF @ProjectKey IS NOT NULL
	BEGIN
		-- Insert all tasks for the project
	
		-- Assign new user to project, this sp will do it with proper hourly rate
		EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey
			
		-- Insert tTaskUser records for that new user where none has been assigned yet to a task
		INSERT	tTaskUser (UserKey, TaskKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
		SELECT	@NewUserKey, t.TaskKey, 0, 0, NULL, NULL, @DefaultServiceKey
		FROM	tTask t (NOLOCK) 
		WHERE	t.ProjectKey = @ProjectKey
		AND		t.TaskKey NOT IN (SELECT tu.TaskKey
								FROM	tTaskUser tu (nolock)
								INNER JOIN tTask t2 (NOLOCK) ON tu.TaskKey = t2.TaskKey
								WHERE	t2.ProjectKey = @ProjectKey	  
								)	
	END
	ELSE
	BEGIN
		IF @TaskKey IS NULL
			RETURN -1
			
		-- Insert one task
		SELECT @ProjectKey = ProjectKey FROM tTask (NOLOCK) WHERE TaskKey = @TaskKey
	
		-- Assign new user to project, this sp will do it with proper hourly rate
		EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey
		
		IF NOT EXISTS (SELECT 1 FROM tTaskUser (NOLOCK) WHERE TaskKey = @TaskKey and UserKey = @NewUserKey)
			INSERT	tTaskUser (UserKey, TaskKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
			SELECT	@NewUserKey, @TaskKey, 0, 0, NULL, NULL, @DefaultServiceKey
		
	END
	
	RETURN 1
GO
