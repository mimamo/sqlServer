USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateToDo]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateToDo]
	@CompanyKey int,
	@ActivityKey int,
	@UserKey int,
	@ProjectKey int,
	@TaskKey int,
	@AssignedUserKey int,
	@Subject varchar(2000),
	@Notes text,
	@ActivityDate smalldatetime,
	@Completed tinyint,
	@TaskCompleted tinyint,
	@RootActivityKey int,
	@ActivityTypeKey int,
	@VisibleToClient tinyint
AS

/*
|| When      Who Rel      What
|| 12/9/10   CRG 10.5.3.9 Created to update To Dos
|| 3/22/10   GWG 10.5.4.2 Include < 0 keys in the insert
|| 11/18/11  RLB 10.5.5.0 (126142) Added Activity Type
|| 4/16/12   RLB 10.5.5.5 (132842) setting a DisplayOrder If the Task changes for assigned user or is the Assigned User changed
|| 5/09/12   RLB 10.5.5.5 noticed the visible to client was not getting set on the update from to do
|| 06/22/12  GHL 10.5.5.7 Added GL company update
|| 07/23/12  GHL 10.5.5.8 Only pull GL company if we restrict to gl company
|| 11/12/12  RLB 10.5.6.2 Setting updated By Key and date on update
|| 09/25/13  GWG 10.5.7.2 Changed how display order is getting set so its set for new todo's
|| 02/10/14  RLB 10.5.7.6 Setting task activity link on new todo for new app if their is a task on they todo
|| 03/03/14  GWG 10.5.7.8 Added support for clearing the read flag
|| 06/04/14  GWG 10.5.8.0 Removed the clearing of the read flag
|| 09/16/14  RLB 10.5.8.4 (229541) ProjectKey was not getting set correctly on new ToDo's it was getting set to @OldProjectKey instead of one passed in
|| 01/26/15  QMD 10.5.8.8 Added CompletedByKey
*/

	DECLARE	@OldTaskKey int,
			@OldProjectKey int,
			@OldAssignedUserKey int,
			@DisplayOrder int,
			@GLCompanyKey int,
			@RestrictToGLCompany int

	SELECT	@OldTaskKey = 0,
			@OldProjectKey = 0,
			@OldAssignedUserKey = -1,
			@DisplayOrder = 0

	select @RestrictToGLCompany = RestrictToGLCompany from tPreference (nolock) where CompanyKey = @CompanyKey

	IF ISNULL(@ActivityKey, 0) <= 0
	BEGIN
		-- New TODO
		Select @OldProjectKey = @ProjectKey

		if isnull(@TaskKey, 0) = 0
			select @OldTaskKey = @TaskKey
		
		-- only if we restrict
		if isnull(@RestrictToGLCompany, 0) = 1
		begin
			if isnull(@GLCompanyKey, 0) = 0
				select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @AssignedUserKey

			if isnull(@GLCompanyKey, 0) = 0
				select @GLCompanyKey = GLCompanyKey from tProject (nolock) where ProjectKey = @ProjectKey

			if isnull(@GLCompanyKey, 0) = 0
				select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @UserKey

			if @GLCompanyKey = 0
				select @GLCompanyKey = null
		end

		INSERT	tActivity
				(CompanyKey,
				ActivityEntity,
				ProjectKey,
				TaskKey,
				AssignedUserKey,
				Subject,
				Notes,
				ActivityDate,
				Completed,
				RootActivityKey,
				ActivityTypeKey,
				VisibleToClient,
				OriginatorUserKey,
				AddedByKey)
		VALUES	(@CompanyKey,
				'ToDo',
				@ProjectKey,
				@TaskKey,
				@AssignedUserKey,
				@Subject,
				@Notes,
				@ActivityDate,
				@Completed,
				@RootActivityKey,
				@ActivityTypeKey,
				@VisibleToClient,
				@UserKey,
				@UserKey)
				
		SELECT	@ActivityKey = @@IDENTITY

		IF @RootActivityKey = 0
			UPDATE	tActivity 
			SET		RootActivityKey = @ActivityKey 
			WHERE	ActivityKey = @ActivityKey

		if @ProjectKey > 0
		BEGIN
			SELECT @DisplayOrder = MAX(DisplayOrder) FROM tActivity (nolock) 
			WHERE ActivityEntity = 'ToDo' 
			and ProjectKey = @ProjectKey 
			AND ISNULL(TaskKey, 0) = ISNULL(@TaskKey, 0) 
			AND ISNULL(AssignedUserKey, 0) =  ISNULL(@AssignedUserKey, 0)
			
			Select @DisplayOrder = ISNULL(@DisplayOrder, 0) + 1
		END
		UPDATE tActivity set DisplayOrder = @DisplayOrder where ActivityKey = @ActivityKey
		
		IF @ProjectKey > 0
		BEGIN
			--Check to see if the assigned user is a client contact. If so, default VisibleToClient = 1
			DECLARE	@AssignedUserCompanyKey int,
					@ClientKey int

			SELECT	@AssignedUserCompanyKey = CompanyKey
			FROM	tUser (nolock)
			WHERE	UserKey = @AssignedUserKey

			--If the assigned user is an employee, no need to check the client
			IF @AssignedUserCompanyKey <> @CompanyKey
			BEGIN
				SELECT	@ClientKey = ClientKey
				FROM	tProject (nolock)
				WHERE	ProjectKey = @ProjectKey

				IF @AssignedUserCompanyKey = @ClientKey
					UPDATE	tActivity
					SET		VisibleToClient = 1
					WHERE	ActivityKey = @ActivityKey
			END

			--Default the Email list from tAssignment.SubscribeToDo
			INSERT	tActivityEmail
					(ActivityKey,
					UserKey)
			SELECT	@ActivityKey,
					UserKey
			FROM	tAssignment (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		SubscribeToDo = 1

			--If the user is a Client/Vendor login, then default the Acct Mgr and any assigned task users into the Email list
			DECLARE	@ClientVendorLogin tinyint
			
			SELECT	@ClientVendorLogin = ClientVendorLogin
			FROM	tUser (nolock)
			WHERE	UserKey = @UserKey

			IF @ClientVendorLogin = 1
			BEGIN
				DECLARE @AccountManager int

				SELECT	@AccountManager = AccountManager
				FROM	tProject (nolock)
				WHERE	ProjectKey = @ProjectKey

				EXEC sptActivityEmailUpdate @ActivityKey, @AccountManager, null, 'insert'

				IF @TaskKey > 0
				BEGIN
					DECLARE	@UserKeyFromTask int --not to be confused with TaskUserKey
					SELECT	@UserKeyFromTask = 0

					WHILE (1=1)
					BEGIN
						SELECT	@UserKeyFromTask = MIN(UserKey)
						FROM	tTaskUser (nolock)
						WHERE	TaskKey = @TaskKey
						AND		UserKey > @UserKeyFromTask

						IF @UserKeyFromTask IS NULL
							BREAK

						EXEC sptActivityEmailUpdate @ActivityKey, @UserKeyFromTask, null, 'insert'
					END
				END
			END
		END
	END
	ELSE
	BEGIN
		SELECT	@OldTaskKey = TaskKey,
				@OldProjectKey = ProjectKey,
				@OldAssignedUserKey = ISNULL(AssignedUserKey, 0)
		FROM	tActivity (nolock)
		WHERE	ActivityKey = @ActivityKey
	
		IF @Completed = 1 AND EXISTS(SELECT * FROM tActivity WHERE ActivityKey = @ActivityKey AND Completed = 0)
			BEGIN
				UPDATE	tActivity
				SET		ActivityEntity = 'ToDo', --just to make sure
						ProjectKey = @ProjectKey,
						TaskKey = @TaskKey,
						AssignedUserKey = @AssignedUserKey,
						Subject = @Subject,
						Notes = @Notes,
						ActivityDate = @ActivityDate,
						Completed = @Completed,
						ActivityTypeKey = @ActivityTypeKey,
						VisibleToClient = @VisibleToClient,
						UpdatedByKey = @UserKey,
						DateUpdated = GetUTCDate(),
						DateCompleted = GETUTCDATE(),
						CompletedByKey = @UserKey
				WHERE	ActivityKey = @ActivityKey
			END 			
		ELSE 
			BEGIN
				IF @Completed = 0 AND EXISTS(SELECT * FROM tActivity WHERE ActivityKey = @ActivityKey AND Completed = 1)					
					UPDATE	tActivity
					SET	ActivityEntity = 'ToDo', --just to make sure
						ProjectKey = @ProjectKey,
						TaskKey = @TaskKey,
						AssignedUserKey = @AssignedUserKey,
						Subject = @Subject,
						Notes = @Notes,
						ActivityDate = @ActivityDate,
						Completed = @Completed,
						ActivityTypeKey = @ActivityTypeKey,
						VisibleToClient = @VisibleToClient,
						UpdatedByKey = @UserKey,
						DateUpdated = GetUTCDate(),
						DateCompleted = NULL,
						CompletedByKey = NULL
					WHERE	ActivityKey = @ActivityKey					
				ELSE
					UPDATE	tActivity
					SET		ActivityEntity = 'ToDo', --just to make sure
							ProjectKey = @ProjectKey,
							TaskKey = @TaskKey,
							AssignedUserKey = @AssignedUserKey,
							Subject = @Subject,
							Notes = @Notes,
							ActivityDate = @ActivityDate,
							Completed = @Completed,
							ActivityTypeKey = @ActivityTypeKey,
							VisibleToClient = @VisibleToClient,
							UpdatedByKey = @UserKey,
							DateUpdated = GetUTCDate()
					WHERE	ActivityKey = @ActivityKey
			END
	END

	
	IF @TaskKey <> @OldTaskKey
	BEGIN
		SELECT @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1  FROM tActivity (nolock) WHERE ActivityEntity = 'ToDo' AND TaskKey = @TaskKey AND ISNULL(AssignedUserKey, 0) =  ISNULL(@AssignedUserKey, 0)

		UPDATE tActivity set DisplayOrder = @DisplayOrder where ActivityKey = @ActivityKey

		EXEC sptActivityLinkUpdate @ActivityKey, 'tTask', @OldTaskKey, 'delete'
		EXEC sptActivityLinkUpdate @ActivityKey, 'tTask', @TaskKey, 'insert'
	END
	ELSE
	BEGIN
		IF @AssignedUserKey <> @OldAssignedUserKey
		BEGIN
		SELECT @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1  FROM tActivity (nolock) WHERE ActivityEntity = 'ToDo' AND TaskKey = @TaskKey AND ISNULL(AssignedUserKey, 0) =  ISNULL(@AssignedUserKey, 0)

		UPDATE tActivity set DisplayOrder = @DisplayOrder where ActivityKey = @ActivityKey
		END
	END
	



	IF @ProjectKey <> @OldProjectKey
	BEGIN
		EXEC sptActivityLinkUpdate @ActivityKey, 'tProject', @OldProjectKey, 'delete'
		EXEC sptActivityLinkUpdate @ActivityKey, 'tProject', @ProjectKey, 'insert'
	END

	--Increment the Sequence number
	EXEC sptActivityIncrementSequence @ActivityKey		

	IF @TaskCompleted = 1 AND @TaskKey > 0
	BEGIN
		DECLARE	@PercCompSeparate tinyint,
				@ActStart smalldatetime,
				@ActComplete smalldatetime
							
		SELECT	@PercCompSeparate = ISNULL(PercCompSeparate, 0)
		FROM	tTask (NOLOCK)
		WHERE	TaskKey = @TaskKey

		IF @PercCompSeparate = 0
			SELECT	@ActStart = ActStart
			FROM	tTask (nolock)
			WHERE	TaskKey = @TaskKey
		ELSE
			SELECT	@ActStart = ActStart
			FROM	tTaskUser (nolock)
			WHERE	TaskKey = @TaskKey
			AND		UserKey = @UserKey

		IF @ActStart IS NULL
			SELECT @ActStart = dbo.fFormatDateNoTime(GETDATE())

		SELECT @ActComplete = dbo.fFormatDateNoTime(GETDATE())

		EXEC sptTaskUpdateActual
				@TaskKey,
				@UserKey,
				@ActStart,
				@ActComplete,
				100,
				null

	END

	RETURN @ActivityKey
GO
