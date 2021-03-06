USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleFixActivityTaskKeys]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleFixActivityTaskKeys]
	@ProjectKey int,
	@UpdateNewKeys tinyint = 0,
	@UserKey int = NULL
AS

/*
|| When      Who Rel      What
|| 5/21/10   CRG 10.5.3.0 Created to fix negative TaskKeys that are set on activities when they're created from new Tasks in a schedule that haven't yet been saved
|| 11/16/11  CRG 10.5.5.0 (126335) Now deleting ToDo's when a Task has been deleted
|| 12/13/11  CRG 10.5.5.0 Fixed bug where the wrong activities were getting deleted
|| 10/28/13  WDF 10.5.7.3 Added UserKey and Logging of ToDo deletes
*/

	IF @UpdateNewKeys = 1
	BEGIN
		/* Assume created in VB
		CREATE TABLE #NewKeys 
			(Entity VARCHAR(50) NULL,
			OldKey int NULL
			NewKey int NULL)
		*/

		UPDATE	tActivity
		SET		TaskKey = nk.NewKey
		FROM	tActivity (nolock),
				#NewKeys nk
		WHERE	tActivity.ProjectKey = @ProjectKey
		AND		nk.Entity = 'tTask'
		AND		tActivity.TaskKey = nk.OldKey

		--Now add activity links for all of the task/activity combinations
		DECLARE	@NewKey int
		SELECT	@NewKey = 0

		DECLARE	@ActivityKey int

		WHILE(1=1)
		BEGIN
			SELECT	@NewKey = MIN(NewKey)
			FROM	#NewKeys
			WHERE	Entity = 'tTask'
			AND		NewKey > @NewKey

			IF @NewKey IS NULL
				BREAK

			SELECT	@ActivityKey = 0
			WHILE(1=1)
			BEGIN
				SELECT	@ActivityKey = MIN(ActivityKey)
				FROM	tActivity (nolock)
				WHERE	TaskKey = @NewKey
				AND		ActivityKey > @ActivityKey

				IF @ActivityKey IS NULL
					BREAK

				EXEC sptActivityLinkUpdate @ActivityKey, 'tTask', @NewKey, 'insert'
			END
		END
	END

	--Delete any remaining activities where the TaskKeys are negative
	DELETE	tActivity
	WHERE	ProjectKey = @ProjectKey
	AND		TaskKey < 0
	
	--Clean up any task keys that have been deleted from the schedule
	SELECT	TaskKey INTO #TaskKeys
	FROM	tActivity (nolock)
	WHERE	ProjectKey = @ProjectKey
	AND		TaskKey NOT IN (SELECT TaskKey FROM tTask (nolock) WHERE ProjectKey = @ProjectKey)
	AND		TaskKey > 0
	AND		ActivityEntity = 'ToDo'

	-- Log ToDos being deleted from the Schedule
	DECLARE @CompanyKey INT, @ProjectNumber VARCHAR(50), @Now as datetime, @Comments varchar(4000)

	Select @ProjectNumber = ProjectNumber, @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey
	SELECT @Now = GETUTCDATE()
	SELECT @ActivityKey = 0
	WHILE (1=1)
		BEGIN
			SELECT @ActivityKey = MIN(ActivityKey)
			  FROM tActivity (nolock)
			 WHERE TaskKey IN (SELECT TaskKey FROM #TaskKeys)
			   AND ActivityEntity = 'ToDo'
			   AND ActivityKey > @ActivityKey
		
			IF @ActivityKey IS NULL
				BREAK
				
			SELECT @Comments = 'ToDo delete triggered by Task delete.  Subject: ' + Subject
			  FROM tActivity (nolock)
			 WHERE ActivityKey = @ActivityKey

			-- Log ToDo Deletion
			EXEC sptActionLogInsert 'Activity',@ActivityKey, @CompanyKey, @ProjectKey, 'Deleted ToDo',
								@Now, NULL, @Comments, @ProjectNumber, NULL, @UserKey  
		END

    -- Delete the Schedule ToDos 
	DELETE	tActivity
	WHERE	ProjectKey = @ProjectKey
	AND		TaskKey IN (SELECT TaskKey FROM #TaskKeys)
	AND		TaskKey > 0
	AND		ActivityEntity = 'ToDo'
	
	DELETE	tActivityLink
	WHERE	Entity = 'tTask'
	AND		EntityKey IN (SELECT TaskKey FROM #TaskKeys)
GO
