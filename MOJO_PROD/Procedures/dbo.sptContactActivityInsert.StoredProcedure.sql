USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityInsert]
	@CompanyKey int,
	@Type varchar(50),
	@Priority varchar(20),
	@Subject varchar(200),
	@ContactCompanyKey int,
	@ContactKey int,
	@AssignedUserKey int,
	@Status smallint,
	@Outcome smallint,
	@ActivityDate smalldatetime,
	@ActivityTime varchar(50),
	@LeadKey int,
	@ProjectKey int,
	@Notes text,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel      What
  || 01/08/09 GHL 10.016   Updating now tActivity instead of tContactActivity
  || 7/10/09  CRG 10.5.0.3 Removed TimeZoneIndex
  || 12/21/10 GHL 10.5.3.9 Added ActivityEntity ('Activity' always)
  */

Declare @DateCompleted smalldatetime
Declare @Completed int
Declare @ActivityEntity varchar(50)

select @ActivityEntity = 'Activity'

if @Status = 2
	Select @DateCompleted = GETDATE(), @Completed = 1
else
	Select @DateCompleted = NULL, @Completed = 0

-- clone of spConverttActivity
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
		StandardActivityKey,
		AssignedUserKey,
		OriginatorUserKey,
		CustomFieldKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		ActivityTime,
		Completed,
		DateCompleted,
		Notes,
		AddedByKey,
		UpdatedByKey,
		ActivityEntity
		)
	Select
		@CompanyKey,
		0, -- parent key
		0, -- root key
		0, -- private
		@Type,
		@Priority,
		@Subject,
		@ContactCompanyKey,
		@ContactKey,
		NULL, -- UserLeadKey
		@LeadKey,
		@ProjectKey,
		NULL, -- StandardActivityKey
		@AssignedUserKey,
		@AssignedUserKey, --originator
		NULL, -- custom field key
		0,  -- visible to client
		@Outcome,
		@ActivityDate,
		NULL, --start time
		NULL, -- end time
		0, -- reminder min
		@ActivityTime,
		@Completed,
		@DateCompleted,
		@Notes,
		@AssignedUserKey,
		@AssignedUserKey,
		@ActivityEntity

	SELECT @oIdentity = @@IDENTITY

	Update tActivity Set RootActivityKey = ActivityKey Where ActivityKey = @oIdentity
	
	RETURN 1
GO
