USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDoTaskList]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDoTaskList]
	@ProjectKey int,
	@UserKey int,
	@VisibleToClientOnly tinyint,
	@ExcludeCompletedActivities tinyint,
	@UseTaskToDo tinyint = 0
AS

/*
|| When      Who Rel      What
|| 12/30/10  CRG 10.5.3.9 Created for ToDoTaskList
|| 1/6/11    CRG 10.5.4.0 Added ProjectKey, ProjectNumber, ProjectName to the Task query
|| 3/7/11    CRG 10.5.4.2 Restricted it to only return parent To Do items.  Also modified it to not restrict by user if -1 is passed in for the @UserKey
|| 04/17/12  RLB 10.5.5.5  Changes made for Drag and Drop
|| 09/11/12  RLB 10.5.6.0 (154006) Not pulling in any private ToDo's
|| 09/25/13  GWG 10.5.7.2 Added display order to the main sort
|| 
*/

	CREATE TABLE #ActivityKeys
	(
		ActivityKey int NULL,
		TaskKey int NULL
	)



	--Get activities assigned to or created by the user
	IF @UseTaskToDo = 0
	BEGIN
			INSERT	#ActivityKeys
				(ActivityKey,
				TaskKey)
			SELECT	ActivityKey, TaskKey
			FROM	tActivity (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		(@UserKey = -1
					OR
					AssignedUserKey = @UserKey
					OR
					AddedByKey = @UserKey)
			AND		ActivityEntity = 'ToDo'
			AND		ISNULL(ParentActivityKey, 0) = 0
			AND     ISNULL(Private, 0) = 0
			AND		(@VisibleToClientOnly = 0 OR VisibleToClient = 1)
			AND		(@ExcludeCompletedActivities = 0 OR ISNULL(Completed, 0) = 0)
	END
	ELSE
	BEGIN
			INSERT	#ActivityKeys
				(ActivityKey,
				TaskKey)
			SELECT	ActivityKey, TaskKey
			FROM	tActivity (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		(@UserKey = -1
					OR
					AssignedUserKey = @UserKey
					OR
					AddedByKey = @UserKey)
			AND		ActivityEntity = 'ToDo'
			AND		ISNULL(ParentActivityKey, 0) = 0
			AND     ISNULL(Private, 0) = 0
			AND		(@VisibleToClientOnly = 0 OR VisibleToClient = 1)
			AND		(ISNULL(Completed, 0) = @ExcludeCompletedActivities OR @ExcludeCompletedActivities IS NULL)
	END
	

	--Get tasks assigned to the user

	CREATE TABLE #TaskKeys
	(
		TaskKey int NULL,
		SummaryTaskKey int NULL
	)

	IF @VisibleToClientOnly = 0 
	BEGIN

		INSERT	#TaskKeys
				(TaskKey,
				SummaryTaskKey)
		SELECT	t.TaskKey, t.SummaryTaskKey
		FROM	tTask t (nolock)
		INNER JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
		WHERE	t.ProjectKey = @ProjectKey
		AND		tu.UserKey = @UserKey

		--Get tasks where the user has an activity
		INSERT	#TaskKeys
				(TaskKey,
				SummaryTaskKey)
		SELECT	t.TaskKey,
				t.SummaryTaskKey
		FROM	tTask t (nolock)
		INNER JOIN #ActivityKeys ak (nolock) ON t.TaskKey = ak.TaskKey
		WHERE	t.ProjectKey = @ProjectKey
		AND		t.TaskKey NOT IN (SELECT TaskKey FROM #TaskKeys)
	END
	ELSE 
	BEGIN
		INSERT	#TaskKeys
				(TaskKey,
				SummaryTaskKey)
		SELECT	t.TaskKey, t.SummaryTaskKey
		FROM	tTask t (nolock)
		WHERE	t.ProjectKey = @ProjectKey
		AND		ISNULL(t.HideFromClient, 0) = 0
	END


	--Now get all of the summary tasks for the previous tasks
	DECLARE	@SummaryTaskKey int
	SELECT	@SummaryTaskKey = 0
	
	WHILE (1=1)
	BEGIN
		SELECT	@SummaryTaskKey = MIN(SummaryTaskKey)
		FROM	#TaskKeys
		WHERE	SummaryTaskKey NOT IN (SELECT TaskKey FROM #TaskKeys)
		AND		SummaryTaskKey > 0

		IF @SummaryTaskKey IS NULL
			BREAK

		INSERT	#TaskKeys
				(TaskKey,
				SummaryTaskKey)
		SELECT	TaskKey,
				SummaryTaskKey
		FROM	tTask (nolock)
		WHERE	TaskKey = @SummaryTaskKey
	END
	
	SELECT	t.TaskKey,
			t.TaskID,
			t.TaskName,
			t.PlanComplete,
			t.SummaryTaskKey,
			t.TaskLevel,
			t.ProjectKey,
			p.ProjectNumber,
			p.ProjectName
	FROM	tTask t (nolock)
	INNER JOIN tProject p ON t.ProjectKey = p.ProjectKey
	WHERE	t.TaskKey IN (SELECT TaskKey FROM #TaskKeys)
	ORDER BY t.ProjectOrder

	SELECT	a.*,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			a.ActivityTypeKey,
			p.ProjectNumber,
			p.ProjectName,
			t.TaskID,
			t.TaskName
	FROM	tActivity a (nolock)
	LEFT JOIN tUser u (nolock) ON a.AssignedUserKey = u.UserKey
	LEFT JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) ON a.TaskKey = t.TaskKey
	WHERE	a.ActivityKey IN (SELECT ActivityKey FROM #ActivityKeys (nolock))
	ORDER BY a.DisplayOrder, a.ActivityDate DESC, a.DateUpdated DESC
GO
