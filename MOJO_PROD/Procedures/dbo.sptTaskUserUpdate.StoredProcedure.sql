USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserUpdate]
	@TaskUserKey int,
	@UserKey int,
	@TaskKey int,
	@ServiceKey int,
	@Hours decimal(24, 4),
	@PercComp int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@ReviewedByTraffic smallint,
	@LoggedUserKey int
	
AS --Encrypt

  /*
  || When     Who Rel      What
  || 7/15/10  GWG 10.532   Created for new Traffic Calendar
  || 11/23/10 CRG 10.5.3.8 Now adding user to tAssignment if they're not already on there when a user is added to a task.
  || 12/7/10  CRG 10.5.3.9 Fixed it so that Users and Services could be modified on an existing tTaskUser record.
  || 4/20/11  CRG 10.5.4.3 (107350) Now defaulting the user's service when adding a task user record, if one was not passed in
  || 06/08/11 GHL 10.5.4.4 Made sure that user key and service key are null if 0 
  || 11/17/11 GWG 10.5.5.0 Task was not getting updated when the trackseparate = 0
  || 12/15/11 GWG 10.5.5.1 Added handling of defaults for subscribing and deliverable review and notify
  */
	DECLARE @PercCompSeparate int
			,@OldReviewedByTraffic int  
			,@ReviewedByDate smalldatetime
			,@ReviewedByKey int
			,@RecordExists int
			,@OldPercComp int 
			,@OldCompletedByDate datetime
			,@OldCompletedByKey int
			,@CompletedByDate datetime
			,@CompletedByKey int
			,@OldUserKey int
			,@NewAssignment tinyint
			,@DeliverableKey int
			

	Select @NewAssignment = 0
	-- The logic below is based on @UserKey @ServiceKey values being NULL, so replace 0 by NULL
	if @UserKey <= 0
		select @UserKey = Null
	if @ServiceKey <= 0
		select @ServiceKey = Null	 

	IF @TaskUserKey < 1
	BEGIN
		if @UserKey is not null OR @ServiceKey is not null
		BEGIN
			IF @ServiceKey IS NULL
				SELECT	@ServiceKey = DefaultServiceKey
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey

			INSERT tTaskUser (UserKey, TaskKey, ServiceKey, Hours)
			VALUES (@UserKey, @TaskKey, @ServiceKey, @Hours) 
		
			Select @TaskUserKey = @@Identity, @NewAssignment = 1
		END
		ELSE
			return -1
	END

	if @UserKey is null AND @ServiceKey is null
	BEGIN
		Delete tTaskUser Where TaskUserKey = @TaskUserKey
		return -1
	END

	SELECT @PercCompSeparate = ISNULL(PercCompSeparate, 0)
	FROM   tTask (NOLOCK)
	WHERE  TaskKey = @TaskKey

	SELECT	@OldReviewedByTraffic = ISNULL(ReviewedByTraffic, 0)
	       ,@OldPercComp = ISNULL(PercComp, 0)
	       ,@OldCompletedByDate = CompletedByDate
	       ,@OldCompletedByKey = CompletedByKey
		   ,@OldUserKey = UserKey
		   ,@DeliverableKey = DeliverableKey
	FROM	tTaskUser (NOLOCK)
	WHERE	TaskUserKey = @TaskUserKey


					 
	IF @@ROWCOUNT > 0
		SELECT @RecordExists = 1
	ELSE
		SELECT @RecordExists = 0
			
	IF @PercCompSeparate = 0
	BEGIN

		if @NewAssignment = 1
		BEGIN
			Update tTaskUser
			Set PercComp = @PercComp,
				ActStart = @ActStart,
				ActComplete = @ActComplete
			Where TaskKey = @TaskKey
		END
		ELSE
		BEGIN
			-- need to update the task and push it down to all the assignments
			Update tTask 
			Set PercComp = @PercComp,
				ActStart = @ActStart,
				ActComplete = @ActComplete
			Where TaskKey = @TaskKey

			Update tTaskUser
			Set PercComp = @PercComp,
				ActStart = @ActStart,
				ActComplete = @ActComplete
			Where TaskKey = @TaskKey

			UPDATE	tTaskUser SET Hours = @Hours 
			WHERE	TaskUserKey = @TaskUserKey
		END

		
	END
	ELSE
	BEGIN
		-- Update all data, info will be rolled up to tTask

		-- Check old and new PercComp
		If @OldPercComp <> @PercComp 
		BEGIN
			IF @PercComp >= 100
				SELECT @CompletedByDate = GETUTCDATE()
		    			,@CompletedByKey = @LoggedUserKey
			ELSE
				-- The task is not complete
				SELECT @CompletedByDate = NULL
					    ,@CompletedByKey = NULL
		END 
		ELSE
			-- Perc Comp has not changed, keep old settings
			SELECT @CompletedByDate = @OldCompletedByDate
					,@CompletedByKey = @OldCompletedByKey
					  
		-- Check Traffic
		IF @ReviewedByTraffic <> @OldReviewedByTraffic
		BEGIN
			-- Review By traffic flag has changed
				
			if @ReviewedByTraffic = 1
				-- User set task as reviewed, so set review date
				Select @ReviewedByDate = GETUTCDATE()
					    ,@ReviewedByKey = @LoggedUserKey 
			else
				-- User reset task as reviewed
				Select @ReviewedByDate = NULL
					    ,@ReviewedByKey = NULL 
					
			UPDATE	tTaskUser
			SET		tTaskUser.UserKey = @UserKey
					,tTaskUser.ServiceKey = @ServiceKey
					,tTaskUser.Hours = @Hours
					,tTaskUser.PercComp = @PercComp
					,tTaskUser.ActStart = @ActStart
					,tTaskUser.ActComplete = @ActComplete	
					,tTaskUser.ReviewedByTraffic = @ReviewedByTraffic
					,tTaskUser.ReviewedByDate = @ReviewedByDate
					,tTaskUser.ReviewedByKey = @ReviewedByKey
					,tTaskUser.CompletedByDate = @CompletedByDate
					,tTaskUser.CompletedByKey = @CompletedByKey
			WHERE	TaskUserKey = @TaskUserKey			
		END
		ELSE
		BEGIN
			-- Review By traffic flag has NOT changed
			UPDATE	tTaskUser
			SET		tTaskUser.UserKey = @UserKey
					,tTaskUser.ServiceKey = @ServiceKey
					,tTaskUser.Hours = @Hours
					,tTaskUser.PercComp = @PercComp
					,tTaskUser.ActStart = @ActStart
					,tTaskUser.ActComplete = @ActComplete	
					,tTaskUser.CompletedByDate = @CompletedByDate
					,tTaskUser.CompletedByKey = @CompletedByKey						
			WHERE	TaskUserKey = @TaskUserKey
				
		END
		
		IF @UserKey IS NOT NULL
		BEGIN
			DECLARE	@ProjectKey int
			SELECT  @ProjectKey = ProjectKey
			FROM	tTask (nolock)
			WHERE	TaskKey = @TaskKey

			IF NOT EXISTS (SELECT NULL FROM tAssignment a (nolock) WHERE ProjectKey = @ProjectKey AND UserKey = @UserKey)
				INSERT	tAssignment
						(ProjectKey,
						UserKey,
						HourlyRate,
						SubscribeDiary,
						SubscribeToDo,
						DeliverableReviewer,
						DeliverableNotify)
				SELECT	@ProjectKey,
						@UserKey,
						HourlyRate,
						SubscribeDiary,
						SubscribeToDo,
						DeliverableReviewer,
						DeliverableNotify
				FROM	tUser (nolock)
				WHERE	UserKey = @UserKey
		END
		
		-- sets to null if not completed so default can come from the task.
		-- this section is trying to set the pred complete flag on a future task assignment with the same deliverable.
		if @DeliverableKey is not null
		BEGIN
		Declare @Switch tinyint
		IF @PercComp = 100
			select @Switch = 1
		
		Update tTaskUser
		Set APredecessorsComplete = @Switch 
		Where TaskUserKey in 
			(Select tu.TaskUserKey from
				tTaskUser tu (nolock)
				inner join tTaskPredecessor	tp (nolock) on tu.TaskKey = tp.TaskKey
				inner join tTaskUser tpu (nolock) on tp.PredecessorKey = tpu.TaskKey
				Where tpu.DeliverableKey = @DeliverableKey and tpu.TaskUserKey = @TaskUserKey)
		
		END
		

		
	END

	RETURN 1
GO
