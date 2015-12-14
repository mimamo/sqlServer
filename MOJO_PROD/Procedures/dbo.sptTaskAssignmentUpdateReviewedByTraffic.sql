USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUpdateReviewedByTraffic]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUpdateReviewedByTraffic]
	(
		@TaskUserKey int,
		@UpdateActuals int,
		@ActStart smalldatetime,
		@ActComplete smalldatetime,
		@ReviewedByDate smalldatetime,
		@ReviewedByKey int
		
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 02/08/07 GHL 8.4   Added roll down of PercComp, ActStart, ActComplete when PercCompSeparate = 0
  ||                    by calling sptTaskUserRolldown which is more complete
  || 04/28/11 RLB 10543 (109923) Change to Work with TaskUser in WMJ  
  || 01/30/12 RLB 10552 (132725) Fix for this issue              
  */

	SET NOCOUNT ON
	
	DECLARE	@PercCompSeparate tinyint, @UserKey int, @TaskKey int
	
	SELECT	@PercCompSeparate = ISNULL(PercCompSeparate,0), @UserKey = ISNULL(tu.UserKey, @ReviewedByKey), @TaskKey = tu.TaskKey
	FROM	tTask t (NOLOCK)
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	WHERE	TaskUserKey = @TaskUserKey
	
	IF @PercCompSeparate = 1
		BEGIN
			IF @UpdateActuals = 1
				BEGIN
					UPDATE	tTaskUser
					SET		ActStart = @ActStart
							,ActComplete = @ActComplete
							,PercComp = 100
							,ReviewedByTraffic = 1
							,ReviewedByDate = @ReviewedByDate	
							,ReviewedByKey = @ReviewedByKey
							,CompletedByDate = GETUTCDATE()
							,CompletedByKey = @UserKey
					WHERE	TaskUserKey = @TaskUserKey
					
				END
			ELSE
				BEGIN
					-- Just mark them as reviewed		  
					UPDATE	tTaskUser
					SET		ReviewedByTraffic = 1
							,ReviewedByDate = @ReviewedByDate	
							,ReviewedByKey = @ReviewedByKey
					WHERE	TaskUserKey = @TaskUserKey
					
				END
								
			EXEC sptTaskUserRollup @TaskKey
		END
		
	ELSE
		
		IF @UpdateActuals = 1
			BEGIN
				UPDATE	tTask
				SET		ActStart = @ActStart
						,ActComplete = @ActComplete
						,PercComp = 100
						,ReviewedByTraffic = 1
						,ReviewedByDate = @ReviewedByDate	
						,ReviewedByKey = @ReviewedByKey
						,CompletedByDate = GETUTCDATE()
						,CompletedByKey = @UserKey
				WHERE	TaskKey = @TaskKey
				
				EXEC sptTaskUserRolldown @TaskKey
					
			END
		ELSE
			BEGIN	-- Just mark them as reviewed		  
				UPDATE	tTask
				SET		ReviewedByTraffic = 1
						,ReviewedByDate = @ReviewedByDate	
						,ReviewedByKey = @ReviewedByKey
				WHERE	TaskKey = @TaskKey

				UPDATE	tTaskUser
				SET		ReviewedByTraffic = 1
						,ReviewedByDate = @ReviewedByDate	
						,ReviewedByKey = @ReviewedByKey
				WHERE	TaskUserKey = @TaskUserKey
			
			END
				  	
	RETURN 1
GO
