USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserInsert]
	@UserKey int,
	@TaskKey int,
	@Hours decimal(24, 4),
	@PercComp int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@ReviewedByTraffic smallint,
	@LoggedUserKey int 
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/19/07 GHL 8.4   Added Time Completed logic  
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
			
	SELECT @PercCompSeparate = ISNULL(PercCompSeparate, 0)
	FROM   tTask (NOLOCK)
	WHERE  TaskKey = @TaskKey

	SELECT	@OldReviewedByTraffic = ISNULL(ReviewedByTraffic, 0)
	       ,@OldPercComp = ISNULL(PercComp, 0)
	       ,@OldCompletedByDate = CompletedByDate
	       ,@OldCompletedByKey = CompletedByKey
	FROM	tTaskUser (NOLOCK)
	WHERE	UserKey = @UserKey
	AND		TaskKey = @TaskKey
					 
	IF @@ROWCOUNT > 0
		SELECT @RecordExists = 1
	ELSE
		SELECT @RecordExists = 0
			
	IF @PercCompSeparate = 0
	BEGIN
		-- Only update Hours
		-- Other data will be rolled down from tTask
		IF @RecordExists = 0
			INSERT tTaskUser (UserKey, TaskKey, Hours)
			VALUES (@UserKey, @TaskKey, @Hours) 
		ELSE
			UPDATE	tTaskUser SET Hours = @Hours 
			WHERE	UserKey = @UserKey
			AND		TaskKey = @TaskKey
	END
	
	IF @PercCompSeparate = 1
	BEGIN
		-- Update all data, info will be rolled up to tTask
		IF @RecordExists = 1
		BEGIN
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
				SET		tTaskUser.Hours = @Hours
						,tTaskUser.PercComp = @PercComp
						,tTaskUser.ActStart = @ActStart
						,tTaskUser.ActComplete = @ActComplete	
						,tTaskUser.ReviewedByTraffic = @ReviewedByTraffic
						,tTaskUser.ReviewedByDate = @ReviewedByDate
						,tTaskUser.ReviewedByKey = @ReviewedByKey
						,tTaskUser.CompletedByDate = @CompletedByDate
						,tTaskUser.CompletedByKey = @CompletedByKey
				WHERE	UserKey = @UserKey
				AND		TaskKey = @TaskKey			
			END
			ELSE
			BEGIN
				-- Review By traffic flag has NOT changed
				UPDATE	tTaskUser
				SET		tTaskUser.Hours = @Hours
						,tTaskUser.PercComp = @PercComp
						,tTaskUser.ActStart = @ActStart
						,tTaskUser.ActComplete = @ActComplete	
						,tTaskUser.CompletedByDate = @CompletedByDate
						,tTaskUser.CompletedByKey = @CompletedByKey						
				WHERE	UserKey = @UserKey
				AND		TaskKey = @TaskKey
				
			END
			
		END
		ELSE
		BEGIN
			-- Record does not exist
			IF @PercComp >= 100
				SELECT @CompletedByDate = GETUTCDATE()
				      ,@CompletedByKey = @LoggedUserKey
			ELSE
				SELECT @CompletedByDate = NULL
				      ,@CompletedByKey = NULL
			
			
			If @ReviewedByTraffic = 1
				Select @ReviewedByDate = GETUTCDATE()
			          ,@ReviewedByKey = @LoggedUserKey  
			ELSE
				Select @ReviewedByDate = NULL
			          ,@ReviewedByKey = NULL  
			
			INSERT tTaskUser
				(
				UserKey,
				TaskKey,
				Hours,
				PercComp,
				ActStart,
				ActComplete,
				ReviewedByTraffic,
				ReviewedByDate,
				ReviewedByKey,
				CompletedByDate,
				CompletedByKey
				)

			VALUES
				(
				@UserKey,
				@TaskKey,
				@Hours,
				@PercComp,
				@ActStart,
				@ActComplete,
				@ReviewedByTraffic,
				@ReviewedByDate,
				@ReviewedByKey,			
				@CompletedByDate,
				@CompletedByKey
				)
	
		END
	END
			
	if @UserKey is not null
	BEGIN
		Declare @ProjectKey int
		Select @ProjectKey = ProjectKey from tTask (nolock) Where TaskKey = @TaskKey
		exec sptAssignmentInsertFromTask @ProjectKey, @UserKey
	END

	RETURN 1
GO
