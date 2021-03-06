USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateFromHistory]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateFromHistory]
	@ActivityKey int,
	@UpdateField varchar(50),
	@Completed tinyint,
	@UserKey int,
	@Subject varchar(2000) = null,
	@AssignedUserKey int = null,
	@ActivityTypeKey int = null,
	@ActivityDate smalldatetime = null,
	@Notes text = null,
	@TaskKey int = null,
	@DisplayOrder int = null
AS

/*
|| When      Who Rel      What
|| 5/4/10    CRG 10.5.2.1 Created to update only one field at a time from the Activity History screen. Other than ActivityKey and Completed,
||                        a maximum of only one parm will be NOT NULL at a time, and that field will be the one that is updated.
|| 7/16/10   CRG 10.5.3.2 Added UpdateField and TaskKey. UpdateField is used to determine which field was updated, rather than just checking for NOT NULL from the fields.
||                        Otherwise, a field could never be blanked out from the History component.
|| 3/21/12   RLB 10.5.5.4 Adding Display Order to be updated
|| 4/20/12   RLB 10.5.5.5 Made some Changes on how to handle if a null TaskKey is passed in 
|| 03/03/14 GWG 10.5.7.8 Added support for clearing the read flag
*/

	IF @UpdateField = 'Completed'
	BEGIN
		DECLARE @DateCompleted smalldatetime
		IF @Completed = 1
			SELECT @DateCompleted = dbo.fFormatDateNoTime(GETDATE())
	
		UPDATE	tActivity
		SET		Completed = @Completed,
				DateCompleted = @DateCompleted
		WHERE	ActivityKey = @ActivityKey
	END

	IF @UpdateField = 'Subject'
		UPDATE	tActivity
		SET		Subject = @Subject
		WHERE	ActivityKey = @ActivityKey

	IF @UpdateField = 'AssignedUserKey'
		UPDATE	tActivity
		SET		AssignedUserKey = @AssignedUserKey
		WHERE	ActivityKey = @ActivityKey
		
	IF @UpdateField = 'ActivityTypeKey'
		UPDATE	tActivity
		SET		ActivityTypeKey = @ActivityTypeKey
		WHERE	ActivityKey = @ActivityKey
		
	IF @UpdateField = 'ActivityDate'
		UPDATE	tActivity
		SET		ActivityDate = @ActivityDate
		WHERE	ActivityKey = @ActivityKey

	IF @UpdateField = 'Notes'
		UPDATE	tActivity
		SET		Notes = @Notes
		WHERE	ActivityKey = @ActivityKey

	IF @UpdateField = 'DisplayOrder'
		UPDATE	tActivity
		SET		DisplayOrder = @DisplayOrder
		WHERE	ActivityKey = @ActivityKey

	IF @UpdateField = 'TaskKey'
	BEGIN
		DECLARE	@OldTaskKey int
		SELECT	@OldTaskKey = TaskKey
		FROM	tActivity (nolock)
		WHERE	ActivityKey = @ActivityKey

		IF ISNULL(@TaskKey, 0) <> ISNULL(@OldTaskKey, 0)
		BEGIN
			UPDATE	tActivity
			SET		TaskKey = @TaskKey
			WHERE	ActivityKey = @ActivityKey

			IF @OldTaskKey IS NOT NULL
				EXEC sptActivityLinkUpdate @ActivityKey, 'tTask', @OldTaskKey, 'delete'

			IF @TaskKey IS NOT NULL
				EXEC sptActivityLinkUpdate @ActivityKey, 'tTask', @TaskKey, 'insert'
		END
	END		
		
	--Increment the Sequence number
	EXEC sptActivityIncrementSequence @ActivityKey	
	
	--Clear any read flags
	exec sptAppReadClearRead @UserKey, 'tActivity', @ActivityKey
GO
