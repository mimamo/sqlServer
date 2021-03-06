USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestInsert]
	@CompanyKey int,
	@ClientKey int,
	@RequestDefKey int,
	@CustomFieldKey int,
	@Prefix varchar(50),
	@NextNumber int,
	@EnteredByKey int,
	@RequestedBy varchar(150),
	@NotifyEmail varchar(100),
	@DateAdded smalldatetime,
	@Subject varchar(100),
	@ClientProjectNumber varchar(200),
	@ProjectDescription text,
	@DueDate smalldatetime,
	@CampaignID varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

 /*
  || When     Who Rel       What
  || 11/10/10 RLB 10.5.3.8  (91299) Fields added for enhancement
  || 05/29/12 QMD 10.5.5.6  (143615) Added CampaignID
  || 03/25/15 WDF 10.5.9.0  (250961) Added UpdatedByKey; DateUpdated to tRequest
  || 04/21/15 WDF 10.5.9.1  (250962) Added UpdatedByKey; DateUpdated to tSpecSheet
 */

IF EXISTS (SELECT 1
			FROM  tRequestDefSpec  (NOLOCK)
			WHERE RequestDefKey = @RequestDefKey
			AND FieldSetKey NOT IN (SELECT FieldSetKey FROM tFieldSet (NOLOCK) WHERE OwnerEntityKey = @CompanyKey)
		   )
	RETURN -1
		 
declare @RequestID varchar(50)

While 1=1
BEGIN
	Select @RequestID = @Prefix + '-' + Cast(@NextNumber as Varchar)
	if exists(Select 1 from tRequest (NOLOCK) Where RequestID = @RequestID and CompanyKey = @CompanyKey)
		Select @NextNumber = @NextNumber + 1
	else
		Break
END


	INSERT tRequest
		(
		CompanyKey,
		ClientKey,
		RequestDefKey,
		CustomFieldKey,
		RequestID,
		EnteredByKey,
		RequestedBy,
		NotifyEmail,
		Status,
		DateAdded,
		Subject,
		ClientProjectNumber,
		ProjectDescription,
		DueDate,
		CampaignID,
		UpdatedByKey,
		DateUpdated
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@RequestDefKey,
		@CustomFieldKey,
		@RequestID,
		@EnteredByKey,
		@RequestedBy,
		@NotifyEmail,
		1,
		@DateAdded,
		@Subject,
		@ClientProjectNumber,
		@ProjectDescription,
		@DueDate,
		@CampaignID,
		@EnteredByKey,
		@DateAdded
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	Declare @CurKey int
	Declare @CurFSKey int
	Declare @CurCFKey int
	Select @CurKey = -1
	While 1=1
	begin
		Select @CurKey = Min(RequestDefSpecKey) 
		from tRequestDefSpec (nolock)
		Where RequestDefKey = @RequestDefKey and RequestDefSpecKey > @CurKey
		
		if @CurKey is null
			Break
		
		Select @CurFSKey = FieldSetKey from tRequestDefSpec (NOLOCK) Where RequestDefSpecKey = @CurKey
		
		INSERT tObjectFieldSet (FieldSetKey) VALUES (@CurFSKey)
		SELECT @CurCFKey = @@IDENTITY
				
		Insert into tSpecSheet (Entity, EntityKey, FieldSetKey, CustomFieldKey, Subject, Description, DisplayOrder, CreatedByKey, CreatedByDate)
		Select 
			'ProjectRequest', @oIdentity, FieldSetKey, @CurCFKey, Subject, Description, DisplayOrder, @EnteredByKey, GETUTCDATE()
		From 
			tRequestDefSpec (NOLOCK) 
		Where
			RequestDefSpecKey = @CurKey
			
	end
	
	Update tRequestDef Set NextRequestNum = @NextNumber Where RequestDefKey = @RequestDefKey

	RETURN 1
GO
