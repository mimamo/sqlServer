USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityCopyFromTask]    Script Date: 04/29/2016 16:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [dbo].[sptActivityCopyFromTask]
	@CopyProjectKey int,
	@CopyFromTaskKey int,
	@NewProjectKey int,
	@NewTaskKey int,
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 07/12/10  CRG 10.5.3.2 Created to copy activities from one task to another
|| 08/15/10  GWG 10.5.3.3 Put in a check so that the from task has to be from a template project.
|| 03/21/12  GWG 10.554   Modified the call to copy activities so it will also copy project level todo's
|| 11/04/14  GAR 10.585   (234258) Allow To Dos to be copied over whether they are copying from a project or a template.
||						  Before only To Dos that were being copied from a template were being copied.
|| 05/28/15  RLB 10.5.9.2 (258052) update the new activity with the old ones display order
*/

	

	DECLARE	@ActivityKey int,
			@NewActivityKey int,
			@CompanyKey int,
			@Private tinyint,
			@Type varchar(50),
			@Priority varchar(20),
			@Subject varchar(2000),
			@ContactCompanyKey int,
			@ContactKey int,
			@UserLeadKey int,
			@LeadKey int,
			@TaskKey int,
			@CMFolderKey int,
			@StandardActivityKey int,
			@ActivityTypeKey int,
			@AssignedUserKey int,
			@OriginatorUserKey int,
			@VisibleToClient tinyint,
			@Outcome smallint,
			@ActivityDate smalldatetime,
			@StartTime smalldatetime,
			@EndTime smalldatetime,
			@ReminderMinutes int

	if @CopyProjectKey = 0
		SELECT  @CopyProjectKey = ProjectKey from tTask (nolock) Where TaskKey = @CopyFromTaskKey
	
	-- (234258) Allow To Dos to be copied over even when they are not being copied over from a template.
	IF NOT EXISTS(Select 1 from tProject (nolock) Where ProjectKey = @CopyProjectKey) --and Template = 1)
		RETURN 1

	IF @NewTaskKey = 0
		SELECT @NewTaskKey = NULL

	SELECT	@ActivityKey = 0

	WHILE(1=1)
	BEGIN
		SELECT	@ActivityKey = MIN(ActivityKey)
		FROM	tActivity (nolock)
		WHERE	ProjectKey = @CopyProjectKey
		AND		ISNULL(TaskKey, 0) = @CopyFromTaskKey
		AND		ActivityEntity = 'ToDo'
		AND		ActivityKey > @ActivityKey

		IF @ActivityKey IS NULL
			BREAK

		SELECT	@CompanyKey = CompanyKey,
				@UserKey = ISNULL(@UserKey, UpdatedByKey),
				@Private = Private,
				@Type = Type,
				@Priority = Priority,
				@Subject = Subject,
				@ContactCompanyKey = ContactCompanyKey,
				@ContactKey = ContactKey,
				@UserLeadKey = UserLeadKey,
				@LeadKey = LeadKey,
				@CMFolderKey = CMFolderKey,
				@StandardActivityKey = StandardActivityKey,
				@ActivityTypeKey = ActivityTypeKey,
				@AssignedUserKey = AssignedUserKey,
				@OriginatorUserKey = OriginatorUserKey,
				@VisibleToClient = VisibleToClient,
				@Outcome = Outcome,
				@ActivityDate = ActivityDate,
				@StartTime = StartTime,
				@EndTime = EndTime,
				@ReminderMinutes = ReminderMinutes
		FROM	tActivity (nolock)
		WHERE	ActivityKey = @ActivityKey

		EXEC @NewActivityKey = sptActivityUpdate
				0,
				@CompanyKey,
				@UserKey,
				0, --ParentActivityKey
				0, --RootActivityKey
				@Private,
				@Type,
				@Priority,
				@Subject,
				@ContactCompanyKey,
				@ContactKey,
				@UserLeadKey,
				@LeadKey,
				@NewProjectKey,
				@NewTaskKey,
				@CMFolderKey,
				@StandardActivityKey,
				@ActivityTypeKey,
				@AssignedUserKey,
				@OriginatorUserKey,
				@VisibleToClient,
				@Outcome,
				@ActivityDate,
				@StartTime,
				@EndTime,
				@ReminderMinutes,
				0, --Completed
				NULL, --DateCompleted
				NULL, --Notes will be updated in the next statement because they're text and can't be stored in a local variable
				'ToDo'  --Force these over to a todo

		UPDATE	tActivity
		SET		tActivity.Notes = old.Notes,
				tActivity.DisplayOrder = old.DisplayOrder
		FROM	tActivity (nolock), 
				tActivity old (nolock)
		WHERE	old.ActivityKey = @ActivityKey
		AND		tActivity.ActivityKey = @NewActivityKey

		IF NOT EXISTS(
				SELECT	NULL
				FROM	tActivityLink al (nolock)
				WHERE	ActivityKey = @NewActivityKey
				AND		Entity = 'tProject'
				AND		EntityKey = @NewProjectKey)
			INSERT	tActivityLink
					(ActivityKey,
					Entity,
					EntityKey)
			VALUES	(@NewActivityKey,
					'tProject',
					@NewProjectKey)

		IF @NewTaskKey IS NOT NULL
		BEGIN
			IF NOT EXISTS(
					SELECT	NULL
					FROM	tActivityLink al (nolock)
					WHERE	ActivityKey = @NewActivityKey
					AND		Entity = 'tTask'
					AND		EntityKey = @NewTaskKey)
				INSERT	tActivityLink
						(ActivityKey,
						Entity,
						EntityKey)
				VALUES	(@NewActivityKey,
						'tTask',
						@NewTaskKey)
		END

		INSERT	tActivityEmail
				(ActivityKey,
				UserKey,
				UserLeadKey)
		SELECT	@NewActivityKey,
				UserKey,
				UserLeadKey
		FROM	tActivityEmail (nolock)
		WHERE	ActivityKey = @ActivityKey

	END
