USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDoList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDoList]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@UserKey int,
	@LoggedUserKey int, --Sometimes @UserKey above will be NULL when we want to see all ToDos for the Entity/EntityKey. LoggedUserKey will allow us to see if the user is subscribed
	@OnlyNullTaskKeys tinyint,
	@Completed int = NULL
AS

/*
|| When      Who Rel      What
|| 12/6/10   CRG 10.5.3.9 Created
|| 1/5/11    CRG 10.5.4.0 Added IsTaskAssigned
|| 1/12/11   CRG 10.5.4.0 Removed join to tActivityLink and going off ProjectKey and TaskKey in tActivity instead
|| 1/20/11   CRG 10.5.4.0 Modified to pull all To Do items for a project, not just the ones with a null TaskKey
|| 1/21/11   CRG 10.5.4.0 Added SortTaskName for the grouping on the To Do grid
|| 2/8/11    CRG 10.5.4.0 Added @OnlyNullTaskKeys. If 1, and @Entity = 'tProject', then only To Do items with TaskKey IS NULL will be returned.
|| 5/3/11    CRG 10.5.4.3 Fixed problem where To Do items where being duplicated when a user was assigned more than once to a task.
|| 11/21/11  RLB 10.5.5.0 Added ActivityTypeKey for enhancement (126142)
|| 03/14/12  RLB 10.5.5.5  Changes made for Drag and Drop
|| 04/01/12  RLB 10.5.5.5 (141856) If there is a UserKey then pull that and any unassigned To Do's
|| 09/11/12  RLB 10.5.6.0 (154006) Not pulling in any private ToDo's
*/

	SELECT 	a.ActivityKey,
			a.DateUpdated,
			a.Private,
			a.AssignedUserKey,
			a.ActivityTypeKey,
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
			a.DisplayOrder,
			a.VisibleToClient,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			p.ProjectNumber,
			p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
			CASE
				WHEN ta.TaskID IS NULL THEN ta.TaskName 
				ELSE ta.TaskID + ' - ' + ta.TaskName 
			END AS TaskFullName,
			ta.TaskID,
			ta.TaskName,
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
			END AS SortTaskName
	FROM	tActivity a (nolock)
	LEFT JOIN tActivityEmail ae (nolock) ON a.ActivityKey = ae.ActivityKey AND ae.UserKey = @LoggedUserKey
	LEFT JOIN tUser u (nolock) ON a.AssignedUserKey = u.UserKey
	LEFT JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tTask ta (nolock) ON a.TaskKey = ta.TaskKey
	LEFT JOIN (SELECT DISTINCT TaskKey, UserKey FROM tTaskUser (nolock) WHERE UserKey = @LoggedUserKey) tu ON a.TaskKey = tu.TaskKey AND tu.UserKey = @LoggedUserKey
	WHERE	a.ActivityEntity = 'ToDo'
	AND     ISNULL(a.Private, 0) = 0
	AND		ISNULL(a.ParentActivityKey, 0) = 0
	AND		a.CompanyKey = @CompanyKey
	AND		((@Entity = 'tProject' AND a.ProjectKey = @EntityKey AND (ISNULL(@OnlyNullTaskKeys, 0) = 0 OR ISNULL(a.TaskKey, 0) = 0))
			OR
			(@Entity = 'tTask' AND a.TaskKey = @EntityKey))
	AND		((a.AssignedUserKey = @UserKey OR a.AssignedUserKey is NULL) OR @UserKey IS NULL)
	AND     (ISNULL(a.Completed, 0) = @Completed or @Completed IS NULL)
	ORDER BY a.AssignedUserKey, a.DisplayOrder
GO
