USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGetNotificationList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGetNotificationList]
	(
		@ProjectKey INT			
	)

AS
	SET NOCOUNT ON

	SELECT u.UserKey
		,u.Email
		,u.FirstName
		,u.LastName
		,ta.TaskAssignmentKey
		,p.ProjectNumber
		,p.ProjectName
		,t.TaskKey
		,t.TaskID
		,t.TaskName
		,ta.PlanStart
		,ta.PlanComplete
		,ta.PercComp
		,ta.DueBy
		,ta.WorkDescription
		,ta.Title
	FROM tTaskAssignmentUser tau (NOLOCK)
		INNER JOIN tTaskAssignment ta (NOLOCK) ON ta.TaskAssignmentKey = tau.TaskAssignmentKey 
		INNER JOIN tTask t (NOLOCK) ON t.TaskKey = ta.TaskKey
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tUser u (NOLOCK) ON tau.UserKey = u.UserKey	
	WHERE p.ProjectKey = @ProjectKey
	AND   ta.PercComp < 100
	
	
	RETURN 1
GO
