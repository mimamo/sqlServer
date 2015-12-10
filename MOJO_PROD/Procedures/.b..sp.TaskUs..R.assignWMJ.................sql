USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserReassignWMJ]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserReassignWMJ]
	(
		@OldTaskUserKey INT,
		@NewUserKey INT,
		@RemoveFromProject INT,
		@AddToTask tinyint = 0,
		@NewTaskHours decimal(24,4)

	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 03/28/11 GHL 10.543   (107252) Creation to handle reassign of services 
  ||                       Just change UserKey on task user key 
  || 6/2/11   CRG 10.5.4.5 Added @AddToTask to allow user to be added without removing the existing user.
  ||                       Also added @NewTaskHours to pass in the hours from the reassign screen and set it for the new tTaskUser record.
  || 10/25/13 RLB 10.5.7.3 (192183) If 0 NewUserKey is passed in and there is a service on the olduserkey then just remove the user but keep the service
  */

	SET NOCOUNT ON

	if isnull(@OldTaskUserKey, 0) = 0
		return 1

	DECLARE @ProjectKey INT
			,@TaskKey INT
			,@OldUserKey int
			,@OldUserServiceKey int
			,@NewServiceKey int
			,@PercCompSeparate tinyint
			,@DefaultServiceKey int
			,@RetVal int

	select @OldUserKey = UserKey
	      ,@TaskKey = TaskKey
		  ,@OldUserServiceKey = ServiceKey
	from tTaskUser (nolock) 
	where TaskUserKey = @OldTaskUserKey

	select @OldUserKey = isnull(@OldUserKey, 0)
	select @OldUserServiceKey = isnull(@OldUserServiceKey, 0)

	-- if the users are the same, abort
	if @OldUserKey = @NewUserKey
		return 1 
	-- if unassigned and the old user does not have a service set abort
	IF @NewUserKey = 0 AND @OldUserServiceKey = 0
		return 1

	SELECT	@ProjectKey = ProjectKey,
			@PercCompSeparate = ISNULL(PercCompSeparate, 0)
	FROM	tTask (NOLOCK)
	WHERE	TaskKey = @TaskKey

	IF @NewUserKey < 0
		SELECT @NewServiceKey = @NewUserKey * -1

	IF @AddToTask = 1
	BEGIN
	    IF @NewUserKey > 0
		begin
			SELECT	@DefaultServiceKey = DefaultServiceKey 
			FROM	tUser (nolock) 
			WHERE	UserKey = @NewUserKey

			INSERT	tTaskUser	
					(TaskKey, 
					UserKey, 
					Hours, 
					ServiceKey)
			SELECT	@TaskKey, 
					@NewUserKey, 
					@NewTaskHours,
					@DefaultServiceKey

			SELECT @RetVal = @@IDENTITY

			IF @PercCompSeparate = 1
			EXEC sptTaskUserRollup @TaskKey
		end
		ELSE
		begin
			INSERT	tTaskUser	
						(TaskKey, 
						UserKey, 
						Hours, 
						ServiceKey)
				SELECT	@TaskKey, 
						null, 
						@NewTaskHours,
						@NewServiceKey

				SELECT @RetVal = @@IDENTITY
			IF @PercCompSeparate = 1
				EXEC sptTaskUserRollup @TaskKey
		end

	END
	ELSE
	BEGIN
	    IF @NewUserKey = 0 AND @OldUserServiceKey > 0 -- made some changes to handle 0 userkey which is unassign but keep if there is a service set on TaskUser
			update tTaskUser                          -- also made some changes to handle if a service was assigned instead of a user
			set UserKey = null
			where  TaskUserKey = @OldTaskUserKey
		ELSE
			IF @NewUserKey < 0
				update tTaskUser
				set    UserKey = null,
					   ServiceKey = @NewServiceKey
				where  TaskUserKey = @OldTaskUserKey
			ELSE
				update tTaskUser
				set UserKey = @NewUserKey
				where  TaskUserKey = @OldTaskUserKey
	END	

	IF @NewUserKey > 0
		-- Assign new user to project, this sp will do it with proper hourly rate
		EXEC sptAssignmentInsertFromTask @ProjectKey, @NewUserKey

	-- Cleanup old user from project?
	DECLARE @NoUnassign INT
	SELECT @NoUnassign = 1

	IF isnull(@OldUserKey, 0) > 0
 	SELECT @NoUnassign = ISNULL(NoUnassign, 0) FROM tUser (NOLOCK) WHERE UserKey = @OldUserKey

	IF @RemoveFromProject = 1 AND @NoUnassign = 0 AND @OldUserKey > 0
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
		END
	END

	EXEC sptTaskRollupAssignedNames @TaskKey

	IF @AddToTask = 1
		RETURN @RetVal
	ELSE

		RETURN 1
GO
