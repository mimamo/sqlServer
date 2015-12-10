USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGet]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGet]
	@TaskUserKey int 

AS --Encrypt

  /*
  || When     Who Rel    What
  || 11/01/07 GHL 8.439  Added Title for backwards compatibilty with assignments
  || 04/28/11 RLB 10.543 (109923) Changed to just use TaskUserKey
  */
		SELECT	tu.*, t.TaskID, t.Comments, t.TaskName, t.EstHours, t.ApprovedCOHours, t.PlanStart, t.PlanComplete, p.ProjectKey, p.ProjectNumber, p.ProjectName
			,t.TaskName as Title
		FROM	tTaskUser tu (nolock)
		inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
		inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
		WHERE tu.TaskUserKey = @TaskUserKey
	
		

	RETURN 1
GO
