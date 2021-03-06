USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserReassign]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserReassign]
	(
		@TaskKey INT,
		@OldUserKey INT,
		@NewUserKey INT,
		@RemoveFromProject INT
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 03/25/08 GHL wmj10    Added RemovedFromProject return to update flash 
  || 7/02/08  GHL 8.515    (29599) when inserting tTaskUser records, copy PercComp, ActStart, ActComplete
  || 11/18/10 CRG 10.5.3.8 Modified to call sptTaskRollupAssignedNames
  || 11/30/10 CRG 10.5.3.9 Modified to handle ServiceKeys passed in as negative @NewUserKeys
  || 12/13/10 RLB 10539    (94833) setting defaultservice on servicekey on TaskUser if the new user has one  
  */
  
	SET NOCOUNT ON

	/*
	Move hours from old user to new user if:
	1) tTask.PercCompSeparate = 0
	2) tTask.PercCompSeparate = 1
	
		if tTaskUser.ActStart is null
			move ALL hours from old user to new user
		
		if tTaskUser.ActStart is not null and tTaskUser.ActComplete is null
			move % of hours from old user to new user 
			set PercComp = 100 on old user and ActComplete = ActStart
			recalc PercComp on new user
										 
		if tTaskUser.ActComplete is NOT null 
			DO NOT MOVE
			
	*/
	
	DECLARE @OldPercComp INT
			,@OldHours DECIMAL(24, 4)
			,@OldActStart DATETIME
			,@OldActComplete DATETIME
			,@NewPercComp INT
			,@NewHours DECIMAL(24, 4)
			,@NewActStart DATETIME
			,@NewActComplete DATETIME
			,@PercCompSeparate INT
			,@HoursUsed DECIMAL(24, 4)
			,@ProjectKey INT
			,@DefaultServiceKey INT
			
	SELECT @ProjectKey = ProjectKey
		  ,@PercCompSeparate = ISNULL(PercCompSeparate, 0)
	FROM   tTask (NOLOCK)
	WHERE  TaskKey = @TaskKey

	Select @DefaultServiceKey = DefaultServiceKey From tUser (nolock) where UserKey = @NewUserKey
	
	IF @PercCompSeparate = 0
	BEGIN
		SELECT @OldHours = Hours
		FROM   tTaskUser (NOLOCK)
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @OldUserKey
		
		SELECT @OldHours = ISNULL(@OldHours, 0)
		
		SELECT @OldPercComp = PercComp
		      ,@OldActStart = ActStart
		      ,@OldActComplete = ActComplete
		FROM   tTask (NOLOCK)
		WHERE  TaskKey = @TaskKey 
		
		IF @NewUserKey >= 0
		BEGIN

			UPDATE tTaskUser
			SET    Hours = Hours + @OldHours, ServiceKey = @DefaultServiceKey
			WHERE  TaskKey = @TaskKey
			AND    UserKey = @NewUserKey
		
			IF @@ROWCOUNT = 0 
				INSERT tTaskUser (TaskKey, UserKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
				SELECT @TaskKey, @NewUserKey, @OldHours, @OldPercComp, @OldActStart, @OldActComplete, @DefaultServiceKey
		END
		ELSE
		BEGIN
			UPDATE tTaskUser
			SET    Hours = Hours + @OldHours
			WHERE  TaskKey = @TaskKey
			AND    ServiceKey = @NewUserKey * -1
		
			IF @@ROWCOUNT = 0 
				INSERT tTaskUser (TaskKey, ServiceKey, Hours, PercComp, ActStart, ActComplete)
				SELECT @TaskKey, @NewUserKey * -1, @OldHours, @OldPercComp, @OldActStart, @OldActComplete
		END
			
		DELETE tTaskUser
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @OldUserKey
			
	END
	ELSE
	BEGIN
		
		-- @PercCompSeparate = 1
		
		SELECT @OldPercComp = PercComp
		      ,@OldHours = Hours
			  ,@OldActStart = ActStart
			  ,@OldActComplete = ActComplete
		FROM   tTaskUser (NOLOCK)
		WHERE  TaskKey = @TaskKey
		AND    UserKey = @OldUserKey 
		
		SELECT @OldHours = ISNULL(@OldHours, 0)
		
		IF @OldActStart IS NULL
		BEGIN
			-- Simple case, old user did not start yet, move everything to new user
			-- Do like above
			
			SELECT @OldHours = Hours
			FROM   tTaskUser (NOLOCK)
			WHERE  TaskKey = @TaskKey
			AND    UserKey = @OldUserKey
			
			SELECT @OldHours = ISNULL(@OldHours, 0)

			IF @NewUserKey >= 0
			BEGIN
				UPDATE tTaskUser
				SET    Hours = Hours + @OldHours, ServiceKey = @DefaultServiceKey
				WHERE  TaskKey = @TaskKey
				AND    UserKey = @NewUserKey
			
				IF @@ROWCOUNT = 0 
					INSERT tTaskUser (TaskKey, UserKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
					SELECT @TaskKey, @NewUserKey, @OldHours, @OldPercComp, @OldActStart, @OldActComplete, @DefaultServiceKey
			END
			ELSE
			BEGIN
				UPDATE tTaskUser
				SET    Hours = Hours + @OldHours
				WHERE  TaskKey = @TaskKey
				AND    ServiceKey = @NewUserKey * -1
		
				IF @@ROWCOUNT = 0 
					INSERT tTaskUser (TaskKey, ServiceKey, Hours, PercComp, ActStart, ActComplete)
					SELECT @TaskKey, @NewUserKey * -1, @OldHours, @OldPercComp, @OldActStart, @OldActComplete
			END
						
			DELETE tTaskUser
			WHERE  TaskKey = @TaskKey
			AND    UserKey = @OldUserKey
					
		END
		
		IF @OldActStart IS NOT NULL AND @OldActComplete IS NULL
		BEGIN		
			-- Old user started but did not complete yet
			IF @OldHours = 0
			BEGIN
				IF @NewUserKey >= 0
				BEGIN
					UPDATE tTaskUser
					SET    Hours = Hours + @OldHours, ServiceKey = @DefaultServiceKey
					WHERE  TaskKey = @TaskKey
					AND    UserKey = @NewUserKey
			
					IF @@ROWCOUNT = 0 
						INSERT tTaskUser (TaskKey, UserKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
						SELECT @TaskKey, @NewUserKey, @OldHours, @OldPercComp, @OldActStart, @OldActComplete, @DefaultServiceKey
				END
				ELSE
				BEGIN
					UPDATE tTaskUser
					SET    Hours = Hours + @OldHours
					WHERE  TaskKey = @TaskKey
					AND    ServiceKey = @NewUserKey * -1
		
					IF @@ROWCOUNT = 0 
						INSERT tTaskUser (TaskKey, ServiceKey, Hours, PercComp, ActStart, ActComplete)
						SELECT @TaskKey, @NewUserKey * -1, @OldHours, @OldPercComp, @OldActStart, @OldActComplete
				END
				
				UPDATE tTaskUser
				SET    ActComplete = ActStart
					   ,PercComp = 100
				WHERE  TaskKey = @TaskKey
				AND    UserKey = @OldUserKey
			END	
			ELSE
			BEGIN
				-- Old user already started
				-- We have Hours to transfer, calculate the number of hours 'Used'
				SELECT @HoursUsed = ISNULL(( (@OldHours * @OldPercComp) / 100), 0)
				SELECT @HoursUsed = ROUND(@HoursUsed, 2)
				
				IF @NewUserKey >= 0
				BEGIN
					-- Update new user
					SELECT @NewPercComp = PercComp
						  ,@NewHours = Hours
						  ,@NewActStart = ActStart
						  ,@NewActComplete = ActComplete
					FROM   tTaskUser (NOLOCK)
					WHERE  TaskKey = @TaskKey
					AND    UserKey = @NewUserKey 
				
					-- We could be more accurate about the PercComp of the new user
					IF @@ROWCOUNT > 0 
					BEGIN
						SELECT @NewHours = ISNULL(@NewHours, 0) + @OldHours - @HoursUsed
				
						UPDATE tTaskUser
						SET    Hours = @NewHours,  ServiceKey = @DefaultServiceKey
						WHERE  TaskKey = @TaskKey
						AND    UserKey = @NewUserKey
					END
					ELSE
					BEGIN
						SELECT @NewHours = ISNULL(@NewHours, 0) + @OldHours - @HoursUsed
				
						INSERT tTaskUser (TaskKey, UserKey, Hours, PercComp, ActStart, ActComplete, ServiceKey)
						SELECT @TaskKey, @NewUserKey, @NewHours, @OldPercComp, @OldActStart, @OldActComplete, @DefaultServiceKey
					END
				END
				ELSE
				BEGIN
					-- Update new user
					SELECT @NewPercComp = PercComp
						  ,@NewHours = Hours
						  ,@NewActStart = ActStart
						  ,@NewActComplete = ActComplete
					FROM   tTaskUser (NOLOCK)
					WHERE  TaskKey = @TaskKey
					AND    ServiceKey = @NewUserKey * -1
				
					-- We could be more accurate about the PercComp of the new user
					IF @@ROWCOUNT > 0 
					BEGIN
						SELECT @NewHours = ISNULL(@NewHours, 0) + @OldHours - @HoursUsed
				
						UPDATE tTaskUser
						SET    Hours = @NewHours
						WHERE  TaskKey = @TaskKey
						AND    ServiceKey = @NewUserKey * -1
					END
					ELSE
					BEGIN
						SELECT @NewHours = ISNULL(@NewHours, 0) + @OldHours - @HoursUsed
				
						INSERT tTaskUser (TaskKey, ServiceKey, Hours, PercComp, ActStart, ActComplete)
						SELECT @TaskKey, @NewUserKey * -1, @NewHours, @OldPercComp, @OldActStart, @OldActComplete
					END
				END
				
				-- Update old user
				UPDATE tTaskUser
				SET    Hours = @HoursUsed
					   ,ActComplete = ActStart
					   ,PercComp = 100
				WHERE  TaskKey = @TaskKey
				AND    UserKey = @OldUserKey
				
			END
			
		END
			
		-- In the following case, we do not do anything 	
		-- IF @OldActComplete IS NOT NULL			

		EXEC sptTaskUserRollup @TaskKey
	END 				
	
	IF @NewUserKey >= 0
	BEGIN
		-- Assign new user to project, this sp will do it with proper hourly rate
		EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey
	END
	
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

	EXEC sptTaskRollupAssignedNames @TaskKey
	
	RETURN @RemovedFromProject
GO
