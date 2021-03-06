USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteInsert]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@ProjectKey int,
	@ParentActivityKey int,
	@AddedByKey int,
	@Subject varchar(2000),
	@Note text,
	@VisibleToClient tinyint,
	@AddedByEmail varchar(300),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/09/09  GHL 10.5.0.0 Inserting now in tActivity instead of tProjectNote
|| 07/10/09  QMD 10.5.0.4 Removed TimeZoneIndex
|| 12/21/10  GHL 10.5.3.9 Added ActivityEntity
*/

	SELECT @AddedByKey = ISNULL(@AddedByKey, 0)
	
	IF @AddedByKey = 0 AND @AddedByEmail IS NOT NULL
	BEGIN
		SELECT @AddedByKey = UserKey 
		FROM   tUser (NOLOCK)
		WHERE  Email = @AddedByEmail
		AND    (CompanyKey = @CompanyKey OR OwnerCompanyKey = @CompanyKey)
		
		SELECT @AddedByKey = ISNULL(@AddedByKey, 0)	
	END  
	
	DECLARE @ClientKey INT
	DECLARE @DateAdded DATETIME
	DECLARE @RootActivityKey INT
	DECLARE @ActivityEntity varchar(50)

	SELECT @ClientKey = ClientKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey 
	SELECT @DateAdded = CONVERT(VARCHAR(10), GETDATE(), 101)
	
	IF ISNULL(@ProjectKey, 0) > 0
		SELECT @ActivityEntity = 'Diary'
	ELSE
		SELECT @ActivityEntity = 'Activity'
	
	INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		Private,
		Type,
		--Priority,
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
		DateAdded,
		DateUpdated,
		ActivityEntity
		)
		
		Select 
		@CompanyKey, --CompanyKey,
		@ParentActivityKey, --ParentActivityKey,
		0, --RootActivityKey,
		0, --Private,
		NULL, --Type,
		--NULL, --Priority,
		@Subject, --Subject,
		@ClientKey, --ContactCompanyKey,
		NULL, --ContactKey,
		NULL, --UserLeadKey,
		NULL, --LeadKey,
		@ProjectKey, --ProjectKey,
		NULL, --StandardActivityKey,
		@AddedByKey, --AssignedUserKey,
		@AddedByKey, --OriginatorUserKey,
		NULL, --CustomFieldKey,
		@VisibleToClient, --VisibleToClient,
		NULL, --Outcome,
		@DateAdded, --ActivityDate,
		NULL, --StartTime,
		NULL, --EndTime,
		0, --ReminderMinutes,
		NULL, --ActivityTime,
		1, --Completed,
		@DateAdded, --DateCompleted,
		@Note, --Notes,
		@AddedByKey, --AddedByKey,
		@AddedByKey, --UpdatedByKey,
		GETUTCDATE(), --DateAdded,
		GETUTCDATE(), --DateUpdated
	    @ActivityEntity

	SELECT @oIdentity = @@IDENTITY
	
	IF ISNULL(@ParentActivityKey, 0) = 0
		-- if you do not have a parent, then you must be a root
		SELECT @RootActivityKey = @oIdentity
	ELSE
		-- if you have a parent, get the root from it, all share the same root
		SELECT @RootActivityKey = RootActivityKey FROM tActivity (NOLOCK) WHERE ActivityKey = @ParentActivityKey
	
	Update tActivity Set RootActivityKey = @RootActivityKey Where ActivityKey = @oIdentity

	-- now add a link for the client
	IF ISNULL(@ClientKey, 0) > 0
		INSERT tActivityLink (ActivityKey, Entity, EntityKey)
		VALUES (@oIdentity, 'tCompany', @ClientKey)
	
	-- and add a link for the project
	IF ISNULL(@ProjectKey, 0) > 0
		INSERT tActivityLink (ActivityKey, Entity, EntityKey)
		VALUES (@oIdentity, 'tProject', @ProjectKey)
	
	/*	
	INSERT tProjectNote
		(
		CompanyKey,
		Entity,
		EntityKey,
		ProjectKey,
		ParentNoteKey,
		AddedByKey,
		DateAdded,
		Note,
		VisibleToClient,
		AddedByEmail
		)

	VALUES
		(
		@CompanyKey,
		@Entity,
		@EntityKey,
		@ProjectKey,
		@ParentNoteKey,
		@AddedByKey,
		GETDATE(),
		@Note,
		@VisibleToClient,
		@AddedByEmail
		)
	*/
	
	RETURN 1
GO
