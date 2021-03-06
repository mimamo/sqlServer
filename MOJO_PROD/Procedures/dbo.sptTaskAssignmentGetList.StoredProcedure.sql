USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGetList]

	@TaskKey int


AS --Encrypt

		SELECT 
			ta.*,
			ISNULL(ta.Title, t.TaskName) As DefaultTitle,
			t.ProjectKey,
			t.TaskID,
			t.TaskName
		FROM 
			tTaskAssignment ta (nolock) 
			inner join tTask t (nolock) on ta.TaskKey = t.TaskKey
		WHERE
			t.TaskKey = @TaskKey
		Order By 
			ta.WorkOrder, ta.Title

	RETURN 1
GO
