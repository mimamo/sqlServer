USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUserGetReassignList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUserGetReassignList]
	(
		@UserKey INT
		,@ProjectKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
		/*
		Calculate AssignedHours and TaskAssignmentDurations like in spvTaskAssignmentGetList
		*/
		
		SELECT	
			ta.TaskAssignmentKey
			,t.TaskKey
			,t.TaskID
			,t.TaskName
			,ta.Title
			,ta.WorkOrder
			,ta.WorkDescription
			,ta.Duration
			,ta.PlanStart
			,ta.PlanComplete
			,ta.PercComp
			,ta.ActStart
			,ta.ActComplete
			,ISNULL((Select Hours from tTaskUser (nolock) Where TaskKey = t.TaskKey and UserKey = @UserKey), 0) as AssignedHours
			,ISNULL((SELECT SUM(CASE WHEN ta2.Duration IS NULL THEN 0
										WHEN ta2.Duration = 0 THEN 1
										ELSE ta2.Duration
										END) 
			 FROM tTaskAssignment ta2 (nolock)
				INNER JOIN tTaskAssignmentUser tau2 (nolock) on tau2.TaskAssignmentKey = ta2.TaskAssignmentKey 
			 WHERE ta2.TaskKey = ta.TaskKey 
			 AND tau2.UserKey = @UserKey), 0) AS TaskAssignmentDurations

	FROM	tTaskAssignmentUser  tau (nolock)
			INNER JOIN tTaskAssignment ta (NOLOCK) ON tau.TaskAssignmentKey = ta.TaskAssignmentKey
			INNER JOIN tTask t (NOLOCK) ON tau.TaskKey = t.TaskKey
	WHERE	t.ProjectKey = @ProjectKey
	AND     tau.UserKey = @UserKey
	
	RETURN 1
GO
