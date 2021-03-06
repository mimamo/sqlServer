USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetReassignList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetReassignList]
	(
	@UserKey INT
	,@ProjectKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 01/30/06 GHL 8.4   Fixed problem with completed tasks showing up in the list  
  ||                    
  */
  
	SET NOCOUNT ON
	
	SELECT	
			t.TaskKey
			,t.TaskID
			,t.TaskName
			,t.Description
			,t.ProjectOrder
			,t.PlanStart
			,t.PlanComplete
			,t.PercComp
			,t.PlanDuration
			,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN t.PercComp
				  ELSE tu.PercComp
			END AS PercComp
			,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN t.ActStart
				  ELSE tu.ActStart
			END AS ActStart
			,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN t.ActComplete
				  ELSE tu.ActComplete
			END AS ActComplete
			,tu.Hours		
	FROM	tTaskUser  tu (nolock)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
	WHERE	t.ProjectKey = @ProjectKey
	AND     tu.UserKey = @UserKey
	AND     (
			(ISNULL(t.PercCompSeparate, 0) = 0 AND t.ActComplete IS NULL AND t.PercComp <> 100)
			OR 
			(ISNULL(t.PercCompSeparate, 0) = 1 AND tu.ActComplete IS NULL AND tu.PercComp <> 100)
			)
		
	RETURN 1
GO
