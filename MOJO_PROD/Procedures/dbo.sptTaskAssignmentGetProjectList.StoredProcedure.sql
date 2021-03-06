USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGetProjectList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGetProjectList]

	(
		@ProjectKey int,
		@UserKey int
	)
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 07/20/09 GHL 10.504 Lifted ambiguity on Decription
  */

	SET NOCOUNT ON 
	
	SELECT  *
			,TaskName As DefaultTitle
			,HideFromClient As TaskHideFromClient
			,PlanDuration as Duration
			,t.Description as WorkDescription
			,CASE PercCompSeparate
				WHEN 1 THEN tu.ActStart
				ELSE t.ActStart
			END AS DispActStart
			,CASE PercCompSeparate
				WHEN 1 THEN tu.ActComplete
				ELSE t.ActComplete
			END AS DispActComplete
			,CASE PercCompSeparate
				WHEN 1 THEN tu.PercComp
				ELSE t.PercComp
			END AS DispPercComp
	FROM    tTask t (NOLOCK)
	INNER JOIN tTaskUser tu (NOLOCK) ON t.TaskKey = tu.TaskKey
	WHERE	t.ProjectKey = @ProjectKey
	AND		tu.UserKey = @UserKey
	order by SummaryTaskKey, DisplayOrder

	
	RETURN 1
GO
