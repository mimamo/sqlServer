USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleSaveReassignToDo]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleSaveReassignToDo]
AS

/*
|| When      Who Rel      What
|| 3/8/11    CRG 10.5.4.2 Created to reassign ToDo items when a task is reassigned. We can assume here that #tTaskUser has already been populated
*/

	CREATE TABLE #ToDoReassign
			(TaskUserKey int null,
			TaskKey int null,
			UserKey int null,
			NewUserKey int null)

	--Get the list of TaskUser records that are being updated
	INSERT	#ToDoReassign
			(TaskUserKey,
			TaskKey,
			NewUserKey)
	SELECT	TaskUserKey, 
			TaskKey, 
			UserKey
	FROM	#tTaskUser
	WHERE	Action = 2

	--Set the existing UserKey
	UPDATE	#ToDoReassign
	SET		#ToDoReassign.UserKey = tu.UserKey
	FROM	#ToDoReassign
	INNER JOIN tTaskUser tu (nolock) ON #ToDoReassign.TaskUserKey = tu.TaskUserKey

	--Remove records that have not had the user changed
	DELETE	#ToDoReassign
	WHERE	NewUserKey = UserKey

	--Update the ToDo item
	UPDATE	tActivity
	SET		tActivity.AssignedUserKey = #ToDoReassign.NewUserKey
	FROM	tActivity 
	INNER JOIN #ToDoReassign ON tActivity.TaskKey = #ToDoReassign.TaskKey AND tActivity.AssignedUserKey = #ToDoReassign.UserKey
	WHERE	tActivity.ActivityEntity = 'ToDo'
GO
