USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserUnassign]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserUnassign]
	(
		@TaskKey INT,
		@OldUserKey INT,
		@RemoveFromProject INT
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/25/08 GHL wmj10 Creation for new flash task reassign screen 
  ||                    
  */
  
	SET NOCOUNT ON

	DECLARE @ProjectKey INT
	
	SELECT @ProjectKey = ProjectKey
	FROM   tTask (NOLOCK)
	WHERE  TaskKey = @TaskKey
	 				
	DELETE tTaskUser
	WHERE  TaskKey = @TaskKey
	AND    UserKey = @OldUserKey	
		
	EXEC sptTaskUserRollup @TaskKey
		
	-- 3) Cleanup old user from project?
	DECLARE @NoUnassign INT
	SELECT @NoUnassign = ISNULL(NoUnassign, 0) FROM tUser (NOLOCK) WHERE UserKey = @OldUserKey
				
	DECLARE @RemovedFromProject INT
	SELECT @RemovedFromProject = 0
				
	IF @RemoveFromProject = 1 AND @NoUnassign = 0
	BEGIN
		
		IF (SELECT COUNT(*) 
			FROM tTaskUser tu (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey 
			WHERE tu.UserKey = @OldUserKey
			AND   t.ProjectKey = @ProjectKey)
			 = 0
		BEGIN
			DELETE tAssignment WHERE ProjectKey = @ProjectKey AND UserKey = @OldUserKey
			DELETE tProjectUserServices WHERE ProjectKey = @ProjectKey AND UserKey = @OldUserKey		 
		
			SELECT @RemovedFromProject = 1
		END
	
	END
	
	RETURN @RemovedFromProject
GO
