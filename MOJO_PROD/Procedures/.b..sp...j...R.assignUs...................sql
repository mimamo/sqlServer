USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectReassignUser]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectReassignUser]
	(
		@ProjectKey int,
		@OldUserKey int,
		@NewUserKey int
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 7/11/07   GHL 8.5   (9690) Checking now if the user is assigned to a task before reassigning
||                      in the case PercCompSeparate = 1.
|| 7/02/08   GHL 8.515  (29599) only reassign tasks if they are not complete
||                      Also when inserting tTaskUser records, copy PercComp, ActStart, ActComplete
|| 12/12/08  GWG 10.015 (41885) Only Add someone to the project if person you are reasigning actually has an assigned task. ie. do nothing if the person to reasign has no tasks.
*/
	SET NOCOUNT ON
	
	IF NOT EXISTS (SELECT 1 
				   FROM   tAssignment (NOLOCK)
				   WHERE  ProjectKey = @ProjectKey
				   AND    UserKey    = @OldUserKey
				   )
		return 1
	
	BEGIN TRANSACTION
	

	IF NOT EXISTS (SELECT 1 
				   FROM   tAssignment (NOLOCK)
				   WHERE  ProjectKey = @ProjectKey
				   AND    UserKey    = @NewUserKey
				   )	
		INSERT tAssignment (ProjectKey, UserKey, HourlyRate)
		SELECT @ProjectKey, @NewUserKey, HourlyRate
		FROM   tUser (NOLOCK)
		WHERE  UserKey = @NewUserKey
				
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

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
					
	/*
	1) tTask.PercCompSeparate = 0
	*/		
	
	-- Add Hours from old user to new user where both users found for same task
	UPDATE tTaskUser
	SET    tTaskUser.Hours = tTaskUser.Hours + ISNULL((SELECT tu2.Hours 
												FROM   tTaskUser tu2 (NOLOCK)
												WHERE  tu2.UserKey    = @OldUserKey -- Old user
												AND    tu2.TaskKey = tTaskUser.TaskKey), 0)					 
	FROM   tTask t (NOLOCK)	
	WHERE  t.ProjectKey      = @ProjectKey
	AND    t.TaskKey         = tTaskUser.TaskKey
	AND    tTaskUser.UserKey = @NewUserKey
	AND    ISNULL(t.PercCompSeparate, 0) = 0
	AND    t.PercComp < 100
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	
	-- Then insert new hours
	INSERT tTaskUser (UserKey, TaskKey, Hours, PercComp, ActStart, ActComplete)
	SELECT @NewUserKey, tu.TaskKey, tu.Hours, t.PercComp, t.ActStart, t.ActComplete
	FROM   tTaskUser tu (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey	
	WHERE  t.ProjectKey      = @ProjectKey
	AND    ISNULL(t.PercCompSeparate, 0) = 0
	AND    t.PercComp < 100
	AND    tu.UserKey = @OldUserKey --Old user
	AND    tu.TaskKey NOT IN (
		SELECT tu2.TaskKey
		FROM   tTaskUser tu2 (NOLOCK)
			INNER JOIN tTask t2 (NOLOCK) ON tu2.TaskKey = t2.TaskKey	
		WHERE  t2.ProjectKey      = @ProjectKey
		AND    tu2.UserKey        = @NewUserKey
		)
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	
	DELETE tTaskUser
	FROM   tTask t (NOLOCK)	
	WHERE  t.ProjectKey      = @ProjectKey
	AND    t.TaskKey         = tTaskUser.TaskKey
	AND    tTaskUser.UserKey = @OldUserKey
	AND    ISNULL(t.PercCompSeparate, 0) = 0
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	/*
	2) tTask.PercCompSeparate = 1
		if tTaskUser.ActStart is null
			move ALL hours from old user to new user
		
		if tTaskUser.ActStart is not null and tTaskUser.ActComplete is null
			move % of hours from old user to new user 
			set PercComp = 100 on old user and ActComplete = ActStart
			recalc PercComp on new user
										 
		if tTaskUser.ActComplete is NOT null 
			DO NOT MOVE
			
		Also check hours, if hours = 0, no need to transfer hours
		 	
	*/
	
	DECLARE @TaskKey INT
			
	SELECT @TaskKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TaskKey = MIN(TaskKey)
		FROM   tTask (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    ISNULL(PercCompSeparate, 0) = 1
		AND    PercComp < 100
		AND    TaskKey > @TaskKey
		
		IF @TaskKey IS NULL
			BREAK
		
		IF EXISTS (SELECT 1 FROM tTaskUser (NOLOCK) WHERE TaskKey = @TaskKey 
					AND UserKey = @OldUserKey)
		BEGIN			
			EXEC sptTaskUserReassign @TaskKey, @OldUserKey, @NewUserKey, 0
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -1
			END
		END
				
	END
	
	UPDATE  tProjectUserServices
	SET     tProjectUserServices.UserKey = @NewUserKey
	WHERE   tProjectUserServices.ProjectKey = @ProjectKey
	AND     tProjectUserServices.UserKey = @OldUserKey
	AND     tProjectUserServices.ServiceKey NOT IN (
		SELECT pus.ServiceKey
		FROM   tProjectUserServices pus (NOLOCK)
		WHERE  pus.ProjectKey = @ProjectKey
		AND    pus.UserKey = @NewUserKey)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
		
	DELETE	tProjectUserServices
	WHERE	ProjectKey = @ProjectKey
	AND		UserKey = @OldUserKey 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	DECLARE @NoUnassign INT
	Select @NoUnassign = ISNULL(NoUnassign, 0) 
	from tUser (nolock) Where UserKey = @OldUserKey
	
	IF @NoUnassign = 0 AND 
	(SELECT COUNT(*) 
			FROM tTaskUser tu (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey 
			WHERE tu.UserKey = @OldUserKey
			AND   t.ProjectKey = @ProjectKey)
			 = 0
		BEGIN
			DELETE tAssignment WHERE ProjectKey = @ProjectKey AND UserKey = @OldUserKey
			DELETE tProjectUserServices WHERE ProjectKey = @ProjectKey AND UserKey = @OldUserKey		 
		END
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	COMMIT TRANSACTION
			
	RETURN 1
GO
