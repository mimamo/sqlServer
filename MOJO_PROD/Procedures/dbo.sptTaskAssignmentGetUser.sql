USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGetUser]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGetUser]
	@TaskAssignmentKey int,
	@UserKey int

AS --Encrypt

SELECT 
	ta.*
	, t.TaskID, t.TaskName, t.MoneyTask
	, p.ProjectKey, p.ProjectNumber, p.ProjectName
	,ps.TimeActive
	, ISNULL(t.EstHours, 0) + ISNULL(t.ApprovedCOHours, 0) as TaskHours
	,ISNULL((Select Hours from tTaskUser (nolock) 
	Where TaskKey = t.TaskKey and UserKey = @UserKey), 0) as AssignedHours
FROM 
	tTaskAssignment ta (nolock)
	inner join tTask t (nolock) on ta.TaskKey = t.TaskKey
	inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
	left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
WHERE
	ta.TaskAssignmentKey = @TaskAssignmentKey
GO
