USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetNotificationList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetNotificationList]
	(
		@ProjectKey INT			
	)

AS
	SET NOCOUNT ON

	SELECT u.UserKey
		,u.Email
		,u.FirstName
		,u.LastName
		,p.ProjectKey
		,p.ProjectNumber
		,p.ProjectName
		,t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.PlanStart
		,t.PlanComplete
		,t.PercComp
		,t.DueBy
		,t.Description
	FROM tTaskUser tu (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON t.TaskKey = tu.TaskKey
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey	
	WHERE p.ProjectKey = @ProjectKey
	AND   t.PercComp < 100
	
	
	RETURN 1
GO
