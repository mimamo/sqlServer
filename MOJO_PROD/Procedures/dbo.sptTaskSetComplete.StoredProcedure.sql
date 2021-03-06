USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskSetComplete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskSetComplete]
	@TaskKey int,
	@UserKey int,
	@CompleteDate smalldatetime,
	@ProjectKey int output,
	@PercComp int output
AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/24/07 GHL 8.4   Added parameter @PercComp to send notifications when the task is complete 
  || 01/30/07 GHL 8.4   Added validation of ActStart and ActComplete before saving                 
  || 02/08/07 GHL 8.4   Added roll down of PercComp, ActStart, ActComplete when PercCompSeparate = 0                
  */
  
	DECLARE	@PercCompSeparate tinyint,
			@PlanStart smalldatetime,
			@ActStart smalldatetime,
			@PlanDuration int
	
	SELECT	@PercCompSeparate = PercCompSeparate,
			@ProjectKey = ProjectKey,
			@PlanStart = PlanStart,
			@ActStart = ActStart,
			@PlanDuration = PlanDuration
	FROM	tTask (NOLOCK)
	WHERE	TaskKey = @TaskKey
	
	IF @PercCompSeparate = 1
		BEGIN
			-- Rollup from tTaskUser to tTask
			SELECT	@ActStart = ActStart
			FROM	tTaskUser (NOLOCK)
			WHERE	TaskKey = @TaskKey
			AND     UserKey = @UserKey
			
			IF @ActStart IS NULL
				SELECT @ActStart = @PlanStart
				
			IF @ActStart > @CompleteDate
				SELECT @ActStart = @CompleteDate 
					,@PlanDuration = 0
					
			UPDATE	tTaskUser
			SET		PercComp = 100,
					ActComplete = @CompleteDate,
					ActStart = @ActStart,
					CompletedByDate = GETUTCDATE(),
					CompletedByKey = @UserKey
			WHERE	TaskKey = @TaskKey
			AND		UserKey = @UserKey
			
			EXEC sptTaskUserRollup @TaskKey
		END
	ELSE
	BEGIN	
		-- Rolldown from tTask to tTaskUser
		IF @ActStart IS NULL
			SELECT @ActStart = @PlanStart
			
		IF @ActStart > @CompleteDate
			SELECT @ActStart = @CompleteDate 
			      ,@PlanDuration = 0
				
		UPDATE	tTask
		SET		PercComp = 100,
				ActComplete = @CompleteDate,
				ActStart = @ActStart,
				PlanDuration = @PlanDuration,
				CompletedByDate = GETUTCDATE(),
				CompletedByKey = @UserKey
		WHERE	TaskKey = @TaskKey
	
		EXEC sptTaskUserRolldown @TaskKey	
	
	END
	
	-- If the task is now 100% complete, we need to send notifications	
	SELECT @PercComp = ISNULL(PercComp, 0)
	FROM   tTask (NOLOCK)
	WHERE  TaskKey = @TaskKey
GO
