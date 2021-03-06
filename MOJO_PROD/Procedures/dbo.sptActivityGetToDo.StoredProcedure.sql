USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDo]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDo]
	@ActivityKey int,
	@LoggedUserKey int
AS

/*
|| When      Who Rel      What
|| 01/24/11  CRG 10.5.4.0 Created to retreive one To Do item for the new ToDoEdit module 
||                        (note: the original sptActivityGetToDo has been renamed sptActivityGetToDoList)
|| 01/26/15  QMD 10.5.8.8 Added CompletedByUserName
*/

	SELECT	a.ActivityKey,
			a.DateUpdated,
			a.Private,
			a.AssignedUserKey,
			a.OriginatorUserKey,
			a.RootActivityKey,
			a.ParentActivityKey,
			a.ActivityDate,
			a.Completed,
			a.DateCompleted,
			a.Subject,
			a.ProjectKey,
			a.TaskKey,
			a.Notes,
			a.VisibleToClient,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			p.ProjectNumber,
			p.ProjectName,
			p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
			CASE
				WHEN ta.TaskID IS NULL THEN ta.TaskName 
				ELSE ta.TaskID + ' - ' + ta.TaskName 
			END AS TaskFullName,
			ta.TaskID,
			ta.TaskName,
			ta.PercComp as TaskPercComp,
			CASE
				WHEN ae.UserKey IS NOT NULL THEN 1
				ELSE 0
			END AS IsSubscribed,
			CASE
				WHEN tu.UserKey IS NOT NULL THEN 1
				ELSE 0
			END AS IsTaskAssigned,
			CASE
				WHEN a.TaskKey IS NOT NULL THEN ta.TaskName
				WHEN a.TaskKey IS NULL AND a.ProjectKey IS NOT NULL THEN ' Project To Do Items' --Space in front to sort it to the top (it's stripped out in the group renderer)
				ELSE ''
			END AS SortTaskName,
			a.ActivityTypeKey,
			avt.TypeName,
			u2.FirstName + ' ' + u2.LastName as CompletedByUserName
	FROM	tActivity a (nolock)
	LEFT JOIN tActivityEmail ae (nolock) ON a.ActivityKey = ae.ActivityKey AND ae.UserKey = @LoggedUserKey
	LEFT JOIN tUser u (nolock) ON a.AssignedUserKey = u.UserKey
	LEFT JOIN tUser u2 (nolock) ON a.CompletedByKey = u2.UserKey
	LEFT JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tTask ta (nolock) ON a.TaskKey = ta.TaskKey
	LEFT JOIN tTaskUser tu (nolock) ON a.TaskKey = tu.TaskKey AND tu.UserKey = @LoggedUserKey
	LEFT JOIN tActivityType avt (nolock) ON a.ActivityTypeKey = avt.ActivityTypeKey
	WHERE	a.ActivityKey = @ActivityKey
GO
