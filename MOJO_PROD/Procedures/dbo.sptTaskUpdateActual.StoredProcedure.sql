USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdateActual]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdateActual]
	@TaskKey int,
	@UserKey int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@Comments varchar(1000),
	@TaskUserKey int = null,
	@LeaveComments tinyint = 0
AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/22/07 GHL 8.4    Added Time Completed logic  
  || 05/07/07 GHL 8.4.2  Removed update of PlanStart/PlanComplete because tPreference.ActualDateUpdatesPlan
  ||                     can be false. Bug 9162.
  || 07/19/10 GHL 10.532 Added TaskUserKey param to handle cases of user assigned several times to the task
  || 05/21/15 GWG 10.592 Needed an option to not update the task status comment for plat.
  */

	DECLARE	@PercCompSeparate tinyint
	DECLARE @OldPercComp int 
			,@OldCompletedByDate datetime
			,@OldCompletedByKey int
			,@CompletedByDate datetime
			,@CompletedByKey int
			,@OldTaskPercComp int 
			,@OldTaskCompletedByDate datetime
			,@OldTaskCompletedByKey int
			
	
	SELECT	@PercCompSeparate = ISNULL(PercCompSeparate,0)
		   ,@OldTaskPercComp = ISNULL(PercComp, 0)
	       ,@OldTaskCompletedByDate = CompletedByDate
	       ,@OldTaskCompletedByKey = CompletedByKey
	FROM	tTask (NOLOCK)
	WHERE	TaskKey = @TaskKey
	
	
	IF ISNULL(@TaskUserKey, 0) = 0
		SELECT	@OldPercComp = ISNULL(PercComp, 0)
			   ,@OldCompletedByDate = CompletedByDate
			   ,@OldCompletedByKey = CompletedByKey
		FROM	tTaskUser (NOLOCK)
		WHERE	UserKey = @UserKey
		AND		TaskKey = @TaskKey
	ELSE
		SELECT	@OldPercComp = ISNULL(PercComp, 0)
			   ,@OldCompletedByDate = CompletedByDate
			   ,@OldCompletedByKey = CompletedByKey
		FROM	tTaskUser (NOLOCK)
		WHERE	TaskUserKey = @TaskUserKey
		

	IF @PercCompSeparate = 1
		BEGIN
			-- Info on tTaskUser is entered separately by each user
			-- We will need to rollup from tTaskUser to tTask
		
			-- Check old and new PercComp
			If @OldPercComp <> @PercComp 
			BEGIN
				IF @PercComp >= 100
					SELECT @CompletedByDate = GETUTCDATE()
		    			   ,@CompletedByKey = @UserKey
				ELSE
					-- The task is not complete
					SELECT @CompletedByDate = NULL
					      ,@CompletedByKey = NULL
			END 
			ELSE
				-- Perc Comp has not changed, keep old settings
				SELECT @CompletedByDate = @OldCompletedByDate
					   ,@CompletedByKey = @OldCompletedByKey
		
			IF ISNULL(@TaskUserKey, 0) = 0			   
				UPDATE	tTaskUser
				SET		ActStart = @ActStart,
						ActComplete = @ActComplete,
						PercComp = @PercComp,
						CompletedByDate = @CompletedByDate,
						CompletedByKey = @CompletedByKey
				WHERE	TaskKey = @TaskKey 
				AND		UserKey = @UserKey
			ELSE
				UPDATE	tTaskUser
				SET		ActStart = @ActStart,
						ActComplete = @ActComplete,
						PercComp = @PercComp,
						CompletedByDate = @CompletedByDate,
						CompletedByKey = @CompletedByKey
				WHERE	TaskUserKey = @TaskUserKey 
			
			if @LeaveComments = 0
			BEGIN
				UPDATE	tTask
				SET		Comments = @Comments
				WHERE	TaskKey = @TaskKey
			END
						
			EXEC sptTaskUserRollup @TaskKey
		END
	ELSE
		BEGIN
			-- Info on tTaskUser is NOT entered separately by each user
			-- We will need to rolldown from tTask to tTaskUser

			-- Check old and new PercComp
			If @OldTaskPercComp <> @PercComp 
			BEGIN
				IF @PercComp >= 100
					SELECT @CompletedByDate = GETUTCDATE()
		    			   ,@CompletedByKey = @UserKey
				ELSE
					-- The task is not complete
					SELECT @CompletedByDate = NULL
					      ,@CompletedByKey = NULL
			END 
			ELSE
				-- Perc Comp has not changed, keep old settings
				SELECT @CompletedByDate = @OldTaskCompletedByDate
					   ,@CompletedByKey = @OldTaskCompletedByKey
					   
			UPDATE	tTask
			SET		ActStart = @ActStart,
					ActComplete = @ActComplete,
					PercComp = @PercComp,
					CompletedByDate = @CompletedByDate,
					CompletedByKey = @CompletedByKey
			WHERE	TaskKey = @TaskKey 
			
			if @LeaveComments = 0
			BEGIN
				UPDATE	tTask
				SET		Comments = @Comments
				WHERE	TaskKey = @TaskKey
			END
			
			UPDATE	tTaskUser
			SET		ActStart = @ActStart,
					ActComplete = @ActComplete,
					PercComp = @PercComp,
					CompletedByDate = @CompletedByDate,
					CompletedByKey = @CompletedByKey
			WHERE	TaskKey = @TaskKey 
		
		END		

	RETURN 1
GO
