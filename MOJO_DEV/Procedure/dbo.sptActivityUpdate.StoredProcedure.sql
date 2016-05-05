USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptActivityUpdate]    Script Date: 04/29/2016 16:31:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[sptActivityUpdate]
	@ActivityKey int,
	@CompanyKey int,
	@UserKey int,
	@ParentActivityKey int,
	@RootActivityKey int,
	@Private tinyint,
	@Type varchar(50),
	@Priority varchar(20),
	@Subject varchar(2000),
	@ContactCompanyKey int,
	@ContactKey int,
	@UserLeadKey int,
	@LeadKey int,
	@ProjectKey int,
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
	@ReminderMinutes int,
	@Completed tinyint,
	@DateCompleted smalldatetime,
	@Notes text,
	@ActivityEntity varchar(50) = NULL,
	@GLCompanyKey int = NULL
AS --Encrypt

/*
|| When     Who Rel      What
|| 5/13/09  MAS 10.500   Added CustomFieldKey
|| 6/9/09   CRG 10.5.0.0 Added clearing of tCalendarReminder flags on update
|| 6/18/09  CRG 10.5.0.0 Added call to increment the Sequence number in tActivity after an update
|| 7/2/09   CRG 10.5.0.0 Removed TimeZoneIndex
|| 07/23/09 RLB 10.5.0.4 Set CustomfieldKey = 0 was causing Read Dariy email service to stop working
|| 09/09/09 GWG 10.5.0.9 Removed Custom FieldKey
|| 12/6/10  CRG 10.5.3.9 Added optional ActivityEntity parameter
|| 12/21/10 GHL 10.5.3.9 Setting now ActivityEntity based on ProjectKey/TaskKey
|| 12/29/10 CRG 10.5.3.9 Modified default value for @ActivityEntity to NULL, and now only setting the @ActivityEntity if it's NULL. If it's not NULL, it'll take the value being passed in.
|| 3/18/11  GWG 10.5.4.2 Slightly modified how the entity is set so that existing activities will get converted to todo's or diary if they have a project or task key
|| 3/5/12   GWG 10.5.5.3 Modified the update of entity to only change it if the current entity is Activity
|| 5/22/12  RLB 10.5.5.6 Change made to handle if a null ActivityEntity is passed for an update which had an ActivityEntity already set  
|| 6/2/12   GWG 10.5.5.6 Another change for setting entity. Always get entity off the row.
|| 06/22/12 GHL 10.5.5.7 Added GLCompanyKey parameter 
|| 12/16/13 RLB 10.5.7.5 (199773) only set ActivityEntity to Activity if nothing is passed in. This was causing an issue when copying over project ToDo's
|| 12/31/13 RLB 10.5.7.5 (200973) change made to check if a diary activity no longer has a project key then it should be just an activity
|| 03/04/13 RLB 10.5.7.8 Not setting AcitivtyEntity. It will have to be passed in since diaries will be able to have tasks on them in the new app
|| 03/03/14 GWG 10.5.7.8 Added support for clearing the read flag
|| 10/16/14 RLB 10.5.8.6 Added read flag on insert for the person creating the Activity
|| 03/23/15 RLB 10.5.9.0 (250592) Made sure that Activity Date is saved with no time on it
*/

-- try to get the GL Company from the project or the user
if isnull(@GLCompanyKey, 0) = 0
begin
	if isnull(@ProjectKey, 0) > 0 
		select @GLCompanyKey = GLCompanyKey from tProject (nolock) where ProjectKey = @ProjectKey 

	if isnull(@GLCompanyKey, 0) = 0
		select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @AssignedUserKey

	if isnull(@GLCompanyKey, 0) = 0
		select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @UserKey

end
if @GLCompanyKey = 0
	select @GLCompanyKey = null

if isnull(@ActivityKey, 0) = 0
BEGIN
	INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		Private,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		UserLeadKey,
		LeadKey,
		ProjectKey,
		TaskKey,
		CMFolderKey,
		StandardActivityKey,
		ActivityTypeKey,
		AssignedUserKey,
		OriginatorUserKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		Completed,
		DateCompleted,
		Notes,
		DateAdded,
		DateUpdated,
		AddedByKey,
		UpdatedByKey,
		ActivityEntity,
		GLCompanyKey
		)

	VALUES
		(
		@CompanyKey,
		@ParentActivityKey,
		@RootActivityKey,
		@Private,
		@Type,
		@Priority,
		@Subject,
		@ContactCompanyKey,
		@ContactKey,
		@UserLeadKey,
		@LeadKey,
		@ProjectKey,
		@TaskKey,
		@CMFolderKey,
		@StandardActivityKey,
		@ActivityTypeKey,
		@AssignedUserKey,
		@OriginatorUserKey,
		@VisibleToClient,
		@Outcome,
		dbo.fFormatDateNoTime(@ActivityDate),
		@StartTime,
		@EndTime,
		@ReminderMinutes,
		@Completed,
		@DateCompleted,
		@Notes,
		GETUTCDATE(),
		GETUTCDATE(),
		@UserKey,
		@UserKey,
		@ActivityEntity,
		@GLCompanyKey
		)

	SELECT @ActivityKey = @@IDENTITY

	if @RootActivityKey = 0
		Update tActivity Set RootActivityKey = @ActivityKey Where ActivityKey = @ActivityKey

	--mark the new activity as read for the person who created it
	exec sptAppReadMarkRead @UserKey, 'tActivity', @ActivityKey

END
ELSE
BEGIN

	DECLARE @OldStartTime smalldatetime,
			@OldEndTime smalldatetime,
			@OldReminderMinutes int
			
	SELECT	@OldStartTime = StartTime,
			@OldEndTime = EndTime,
			@OldReminderMinutes = ReminderMinutes
	FROM	tActivity (nolock)
	WHERE	ActivityKey = @ActivityKey

	UPDATE
		tActivity
	SET
		Private = @Private,
		Type = @Type,
		Priority = @Priority,
		Subject = @Subject,
		ContactCompanyKey = @ContactCompanyKey,
		ContactKey = @ContactKey,
		UserLeadKey = @UserLeadKey,
		LeadKey = @LeadKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		CMFolderKey = @CMFolderKey,
		StandardActivityKey = @StandardActivityKey,
		ActivityTypeKey = @ActivityTypeKey,
		AssignedUserKey = @AssignedUserKey,
		OriginatorUserKey = @OriginatorUserKey,
		VisibleToClient = @VisibleToClient,
		Outcome = @Outcome,
		ActivityDate = dbo.fFormatDateNoTime(@ActivityDate),
		StartTime = @StartTime,
		EndTime = @EndTime,
		ReminderMinutes = @ReminderMinutes,
		Completed = @Completed,
		DateCompleted = @DateCompleted,
		Notes = @Notes,
		DateUpdated = GETUTCDATE(),
		UpdatedByKey = @UserKey,
		ActivityEntity = @ActivityEntity,
		GLCompanyKey = @GLCompanyKey
	WHERE
		ActivityKey = @ActivityKey
		
	--Increment the Sequence number
	EXEC sptActivityIncrementSequence @ActivityKey		
	
	--Clear any read flags
	exec sptAppReadClearRead @UserKey, 'tActivity', @ActivityKey
	
	--Clear the reminder flags if the start/end or reminder times have been updated
	IF @StartTime <> @OldStartTime
		OR @EndTime <> @OldEndTime
		OR @ReminderMinutes <> @OldReminderMinutes
		UPDATE	tCalendarReminder
		SET		Displayed = 0,
				Dismissed = 0,
				SnoozeTime = NULL
		WHERE	Entity = 'tActivity'
		AND		EntityKey = @ActivityKey		

END


RETURN @ActivityKey


GO

