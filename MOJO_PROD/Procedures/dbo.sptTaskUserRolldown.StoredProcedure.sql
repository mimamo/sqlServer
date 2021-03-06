USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserRolldown]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserRolldown]
	(
		@TaskKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 01/04/07 GHL 8.4   Added protection against NULL PercComp
  || 01/19/07 GHL 8.4   Added Time Completed logic
  */
  
	-- Rolldown from tTask to tTaskUser
	-- Case when tTask.PercCompSeparate = 0	

	UPDATE	tTaskUser
	SET		tTaskUser.PercComp = ISNULL(tTask.PercComp, 0)
			,tTaskUser.ActStart = tTask.ActStart
			,tTaskUser.ActComplete = tTask.ActComplete
			,tTaskUser.ReviewedByTraffic = ISNULL(tTask.ReviewedByTraffic, 0)
			,tTaskUser.ReviewedByDate = tTask.ReviewedByDate
			,tTaskUser.ReviewedByKey = tTask.ReviewedByKey
			,tTaskUser.CompletedByDate = tTask.CompletedByDate
			,tTaskUser.CompletedByKey = tTask.CompletedByKey
	FROM	tTask (NOLOCK)
	WHERE	tTaskUser.TaskKey = tTask.TaskKey		
	AND		tTask.TaskKey = @TaskKey
	AND		ISNULL(tTask.PercCompSeparate, 0) = 0
	
	RETURN 1
GO
