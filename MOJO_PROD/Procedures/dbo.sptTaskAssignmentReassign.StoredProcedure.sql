USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentReassign]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentReassign]
	(
		@TaskAssignmentKey INT,
		@UserKey INT,
		@NewUserKey INT,
		@Hours DECIMAL(24, 4),		-- Hours for that Task Assignment, may be over several days
		@RemoveFromProject INT
	)
AS -- Encrypt

  /*
  || When     Who Rel      What
  || 12/13/10 RLB 10539    (94833) setting defaultservice on servicekey on TaskUser if the new user has one  
  */

	SET NOCOUNT ON
	
	DECLARE @ProjectKey INT
			,@TaskKey INT
			,@TaskUserHours DECIMAL(24, 4)
			,@NoUnassign INT
			,@DeleteFlag INT
			,@DefaultServiceKey iNT
	
	-- Queries						
	SELECT @ProjectKey			= t.ProjectKey
		  ,@TaskKey				= ta.TaskKey
	FROM   tTaskAssignment ta (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON ta.TaskKey = t.TaskKey
	WHERE  ta.TaskAssignmentKey	= @TaskAssignmentKey

	-- There may not be hours in tTaskUser
	SELECT @TaskUserHours = ISNULL(tu.Hours, 0)
	FROM   tTaskUser tu (NOLOCK)  
	WHERE  tu.TaskKey = @TaskKey
	AND    tu.UserKey = @UserKey

	-- Subtract the assignment hours from the current pool of hours in tTaskUser
	SELECT @TaskUserHours = ISNULL(@TaskUserHours, 0) - @Hours
	
	SELECT @NoUnassign = ISNULL(NoUnassign, 0)
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey
 			
	-- 1) tTaskUser records 
	  			
	-- Delete tTaskUser for old user
	-- Do not rely only on the new hours to be zero due to possible rounding errors
	-- check also existence of tTaskAssignmentUser records
	
	SELECT @DeleteFlag = 0
	
	IF @TaskUserHours <= 0
		SELECT @DeleteFlag = 1
		
	IF (SELECT COUNT(*) 
		FROM   tTaskAssignmentUser (NOLOCK)
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @UserKey 
		) = 1			-- Current one is not deleted yet, so check for one
		SELECT @DeleteFlag = 1

	-- Old User							
	IF @DeleteFlag = 1
		DELETE tTaskUser
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @UserKey
	ELSE
		UPDATE tTaskUser
		SET    Hours = Hours - @Hours
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @UserKey

	-- Create tTaskUser record for new User
	Select @DefaultServiceKey = DefaultServiceKey From tUser (nolock) Where UserKey = @NewUserKey

	UPDATE tTaskUser
	SET    Hours = Hours + @Hours, ServiceKey = @DefaultServiceKey
	WHERE  TaskKey = @TaskKey
	AND    UserKey = @NewUserKey		
			
	IF @@ROWCOUNT = 0
		INSERT tTaskUser (TaskKey, UserKey, Hours, ServiceKey)
		VALUES (@TaskKey, @NewUserKey, @Hours, @DefaultServiceKey) 		

	-- 2) tTaskAssignmentUser records 

	-- Old User
	DELETE tTaskAssignmentUser
	WHERE  TaskAssignmentKey	= @TaskAssignmentKey
	AND    UserKey				= @UserKey

	-- Add new user
	IF (SELECT COUNT(*)
			FROM tTaskAssignmentUser tau (NOLOCK)
			WHERE tau.UserKey = @NewUserKey
			AND   tau.TaskAssignmentKey = @TaskAssignmentKey)
			= 0
		INSERT tTaskAssignmentUser (TaskAssignmentKey, UserKey, TaskKey)
		VALUES (@TaskAssignmentKey, @NewUserKey, @TaskKey)

	-- Assign new user to project, this sp will do it with proper hourly rate
	EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey
	
	-- 3) Cleanup old user from project?
		
	IF @RemoveFromProject = 1 AND @NoUnassign = 0
	BEGIN
		SELECT @DeleteFlag = 1
		
		IF (SELECT COUNT(*) 
			FROM tTaskUser tu (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey 
			WHERE tu.UserKey = @UserKey
			AND   t.ProjectKey = @ProjectKey)
			 > 0
			SELECT @DeleteFlag = 0
						
		IF (SELECT COUNT(*) 
			FROM tTaskAssignmentUser tau (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tau.TaskKey = t.TaskKey 
			WHERE tau.UserKey = @UserKey
			AND   t.ProjectKey = @ProjectKey)
			 > 0
			SELECT @DeleteFlag = 0
			 
		IF @DeleteFlag = 1
		BEGIN
			DELETE tAssignment WHERE ProjectKey = @ProjectKey AND UserKey = @UserKey
			DELETE tProjectUserServices WHERE ProjectKey = @ProjectKey AND UserKey = @UserKey		 
		END
	
	END
			
	
	RETURN 1
GO
