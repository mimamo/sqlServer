USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadConvert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadConvert]
	(
	@OwnerKey INT,
	@UserKey INT,
	@UserLeadKey INT,
	@UserCompanyKey INT,
	@CompanyKey INT,
	@CreateContact INT,
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50),
	@ContactFolderKey INT,
	@CreateCompany INT,
	@CompanyName VARCHAR(150),
	@CompanyFolderKey INT,
	@CreateOpportunity INT,
	@OppSubject VARCHAR(75),
	@OppStageKey INT,
	@OppFolderKey INT,
	@OppStatusKey INT,
	@CreateActivity INT,
	@ActivitySubject VARCHAR(75),
	@ActivityNote TEXT,
	@ActivityDate smalldatetime,
	@ActivityStartTime smalldatetime,
	@ActivityEndTime smalldatetime,
	@ActivityCompleted TINYINT,
	@ActivityFolderKey INT,
	@ActivityTypeKey int,
	@AddToEmail int,
	@ActivityAssignedUserKey int,
	@ActivityReminderMinutes int,
	@ActivityPriority varchar(20),
	@oContactIdentity INT OUTPUT,
	@oCompanyIdentity INT OUTPUT,
	@oOpportunityIdentity INT OUTPUT,
	@oActivityIdentity INT OUTPUT,
	@oExistingActivityIdentity INT OUTPUT
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 08/13/08  QMD 10.5.0.0 Created to convert a lead into a contact, lead, or opportunity
|| 01/30/09  RTC 10.5.0.0 Added existing activity logic and corrected the new activity logic
|| 03/06/09  QMD 10.5.0.0 Added in Opportunity Custom Fields
|| 4/29/09   CRG 10.5.0.0 Added ActivityAssignedUserKey, ActivityReminderMinutes, ActivityPriority
|| 5/19/09   CRG 10.5.0.0 Added ActivityStartTime and ActivityEndTime
|| 5/19/09   MAS 10.5.0.0 Added tUser DateLeadCreated = DateAdded
|| 5/29/09   MFT 10.5.0.0 tUserLead Comments to tUser only if no company created
|| 6/01/09   MFT 10.5.0.0 Made tUser.UserCompanyName = tCompany.CompanyName if linked
|| 6/24/09   MAS 10.5.0.0 (55679) Added a input param, @UserCompanyKey.  It's used if the user wants
						  to convert a lead and use an existing Company.  Moved the History copy so that
						  it's used for both new and exsisting companies
|| 08/03/09  GWG 10.5.0.6 Fixed level history if stage is null
|| 10/29/09  GHL 10.5.1.3 (66978) The Activity should not be threaded, i.e. leave
||                        ParentActivityKey = 0
|| 2/20/10   GWG 10.5.1.9 Changed the save of comments so they are saved to the company and the contact.
|| 02/26/10  QMD 10.5.1.9 Add Insert into tUserLeadUpdateLog
|| 3/01/10   RLB 10.5.1.9 Added ActivityTypeKey on converted Leads to contacts
|| 05/18/10  RLB 10.5.2.3 (80993)Default Client Vendor Login to 1 when converting to contact
|| 06/22/10  MFT 10.5.3.1 (83691) Set labor and expense defaults on tCompany (from tPreference)
|| 10/11/10  RLB 10.5.3.6 Added Email to for an enhancement
|| 01/12/11  QMD 10.5.4.0 Added Exec sptMarketingListListDeleteLogInsert 
|| 02/16/11  GHL 10.5.4.1 Added created user, company, opportunity, activity to the log in order to help us with the report 
|| 07/25/12  GHL 10.5.5.8 Added propagation of the GL company if we restrict to GL company
*/

	Declare @ConvertDate smalldatetime
	Select @ConvertDate = Cast(Cast(Month(GETDATE()) as varchar) + '/' + Cast(Day(GETDATE()) as varchar) + '/' + Cast(Year(GETDATE()) as varchar) as smalldatetime)
	
	select @oExistingActivityIdentity = min(ActivityKey)
	from tActivity (nolock)
	where UserLeadKey = @UserLeadKey
	
	IF EXISTS(SELECT 1 FROM tUserLead WHERE UserLeadKey = @UserLeadKey)
	  BEGIN
	  	DECLARE
				@GetRateFrom smallint,
				@HourlyRate money,
				@TimeRateSheetKey int,
				@GetMarkupFrom smallint,
				@ItemMarkup decimal,
				@IOCommission decimal,
				@BCCommission decimal,
				@ItemRateSheetKey int,
				@GLCompanyKey int,
				@RestrictToGLCompany int
			
			SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0) from tPreference (NOLOCK) WHERE CompanyKey = @CompanyKey
			-- leave GLCompanyKey null
			SELECT @GLCompanyKey = GLCompanyKey FROM tUserLead (NOLOCK) WHERE UserLeadKey = @UserLeadKey

			IF @CreateCompany = 1
			  BEGIN
			  SELECT
			  		@GetRateFrom = GetRateFrom,
						@HourlyRate = HourlyRate,
						@TimeRateSheetKey = TimeRateSheetKey,
						@GetMarkupFrom = GetMarkupFrom,
						@ItemMarkup = ItemMarkup,
						@IOCommission = IOCommission,
						@BCCommission = BCCommission,
						@ItemRateSheetKey = ItemRateSheetKey
			  FROM
			  	tPreference (NOLOCK)
			  WHERE
			  	CompanyKey = @CompanyKey
			  
				INSERT INTO tCompany
						(
						CompanyName,
						Phone,
						Fax,
						WebSite, 
						Active,
						AccountManagerKey,
						OwnerCompanyKey,					
						ContactOwnerKey,
						CompanyTypeKey,
						DateAdded,
						DateUpdated,
						CreatedBy,
						ModifiedBy,
						CMFolderKey,
						CustomFieldKey, 
						Comments,
						SalesPersonKey,
						SourceKey,
						DateConverted,
						GetRateFrom,
						HourlyRate,
						TimeRateSheetKey,
						GetMarkupFrom,
						ItemMarkup,
						IOCommission,
						BCCommission,
						ItemRateSheetKey
						)
				
				SELECT	CASE ISNULL(@CompanyName,'') WHEN '' THEN CompanyName ELSE @CompanyName END,
						CompanyPhone,
						CompanyFax,
						CompanyWebsite,		
						1,			
						CASE WHEN @OwnerKey > 0 THEN @OwnerKey ELSE OwnerKey END,
						CompanyKey,
						CASE WHEN @OwnerKey > 0 THEN @OwnerKey ELSE OwnerKey END,
						CompanyTypeKey,			
						GETUTCDATE(),
						GETUTCDATE(),
						@UserKey,
						@UserKey,
						CASE ISNULL(@CompanyFolderKey, 0) WHEN 0 THEN NULL ELSE @CompanyFolderKey END,
						CompanyCustomFieldKey,
						Comments, 
						CASE WHEN @OwnerKey > 0 THEN @OwnerKey ELSE OwnerKey END,
						CompanySourceKey,
						@ConvertDate,
						@GetRateFrom,
						@HourlyRate,
						@TimeRateSheetKey,
						@GetMarkupFrom,
						@ItemMarkup,
						@IOCommission,
						@BCCommission,
						@ItemRateSheetKey
				FROM	tUserLead (nolock)
				WHERE	UserLeadKey = @UserLeadKey
				
				SELECT @oCompanyIdentity = @@Identity		
				
				if @RestrictToGLCompany = 1 and isnull(@GLCompanyKey, 0) > 0
					-- use sptGLCompanyAccessInsert because it checks if record exists before inserting
					exec sptGLCompanyAccessInsert 'tCompany', @oCompanyIdentity, @GLCompanyKey
		
			  END
			ELSE
			  BEGIN			
				-- Set @oCompanyIdentity if we're not creating a new company 
				If ISNULL(@oCompanyIdentity,0) = 0
					Set @oCompanyIdentity = @UserCompanyKey

				-- If we are using an existing company, give right access to it
				if @RestrictToGLCompany = 1 And isnull(@UserCompanyKey, 0) > 0 and isnull(@GLCompanyKey, 0) > 0
					-- use sptGLCompanyAccessInsert because it checks if record exists before inserting
					exec sptGLCompanyAccessInsert 'tCompany', @UserCompanyKey, @GLCompanyKey

			  END

			-- Copy the Activity records regardless of whether it's a new company or not
			UPDATE	tActivity
			SET		ContactCompanyKey = @oCompanyIdentity
			WHERE	UserLeadKey = @UserLeadKey

			INSERT	tActivityLink (ActivityKey, Entity, EntityKey)
			SELECT	ActivityKey, 'tCompany', @oCompanyIdentity
			FROM	tActivity (NOLOCK)
			WHERE	UserLeadKey = @UserLeadKey


			IF @CreateContact = 1
			  BEGIN
				
			  	SELECT
			  		@CompanyName = CompanyName
			  	FROM
			  		tCompany (nolock)
			  	WHERE
			  		CompanyKey = @oCompanyIdentity
			  	
				INSERT INTO tUser 
						(
						CompanyKey,
						FirstName, 
						MiddleName, 
						LastName, 
						Salutation, 
						Phone1, 
						Phone2, 							
						Cell, 
						Fax, 
						Pager, 
						Title, 
						Email, 
						ContactMethod, 
						DoNotCall, 
						DoNotEmail, 							
						DoNotMail, 
						DoNotFax, 
						AddedByKey, 
						TimeZoneIndex, 
						OwnerKey, 							
						Department, 
						UserRole, 
						Assistant, 
						AssistantPhone, 							
						AssistantEmail, 
						Birthday, 
						SpouseName, 
						Children, 
						Anniversary, 
						Hobbies, 
						Comments, 								
						UserCompanyName,
						CMFolderKey,
						DateAdded,
						Active,
						OwnerCompanyKey,
						CustomFieldKey,
						DateConverted,
						DateLeadCreated,
						ClientVendorLogin
						)
				SELECT	@oCompanyIdentity,  
						@FirstName, 
						MiddleName, 
						@LastName, 					
						Salutation, 
						Phone1, 
						Phone2, 
						Cell, 
						Fax, 
						Pager, 
						Title, 
						Email, 					
						ContactMethod, 
						DoNotCall, 
						DoNotEmail, 
						DoNotMail, 
						DoNotFax, 
						AddedByKey, 
						TimeZoneIndex, 
						CASE WHEN @OwnerKey > 0 THEN @OwnerKey ELSE OwnerKey END, 					
						Department, 
						UserRole, 
						Assistant, 
						AssistantPhone, 
						AssistantEmail,					
						Birthday, 
						SpouseName, 
						Children, 
						Anniversary, 
						Hobbies, 
						Comments, 
						CASE ISNULL(@CompanyName,'') WHEN '' THEN CompanyName ELSE @CompanyName END,
						CASE ISNULL(@ContactFolderKey, 0) WHEN 0 THEN NULL ELSE @ContactFolderKey END,
						GETDATE(),
						1,
						@CompanyKey,
						UserCustomFieldKey,
						@ConvertDate,
						DateAdded,
						1	
				FROM	tUserLead (NOLOCK)
				WHERE	UserLeadKey = @UserLeadKey	

				SET @oContactIdentity = @@IDENTITY			   

				if @RestrictToGLCompany = 1 and isnull(@GLCompanyKey, 0) > 0
					-- use sptGLCompanyAccessInsert because it checks if record exists before inserting
					exec sptGLCompanyAccessInsert 'tUser', @oContactIdentity, @GLCompanyKey

				UPDATE	tActivity
				SET		ContactKey = @oContactIdentity
				WHERE	UserLeadKey = @UserLeadKey
			
				INSERT  tActivityLink (ActivityKey, Entity, EntityKey)
				SELECT	ActivityKey, 'tUser', @oContactIdentity
				FROM	tActivity (NOLOCK)
				WHERE	UserLeadKey = @UserLeadKey

				-- Log Change MarketingListKey
				IF EXISTS(SELECT * FROM tMarketingListList (NOLOCK) WHERE Entity = 'tUserLead' AND EntityKey = @UserLeadKey)
				  BEGIN
					DECLARE @pList VARCHAR(50)
					SELECT @pList = '@UserLeadKey = ' + CONVERT(VARCHAR(10),@UserLeadKey)
					EXEC sptMarketingListListDeleteLogInsert @UserKey, @UserLeadKey, 'tUserLead', 'sptUserLeadConvert', @pList, 'UI'
				  END
				  
				UPDATE	tMarketingListList
				SET		Entity = 'tUser', EntityKey = @oContactIdentity
				WHERE	EntityKey = @UserLeadKey 
						AND Entity = 'tUserLead'				

				IF @CreateCompany = 1
				  BEGIN
					UPDATE	tCompany
					SET		PrimaryContact = @oContactIdentity
					WHERE	CompanyKey = @oCompanyIdentity

				  END
			  END
			  
			-- Update addresses based on what was created
			Declare @BKey int, @HKey int, @OKey int
			 
			Select @BKey = AddressKey, @HKey = HomeAddressKey, @OKey = OtherAddressKey from tUserLead (nolock) Where UserLeadKey = @UserLeadKey
			 
			if @CreateContact = 0 and @CreateCompany = 1
			BEGIN
					-- move all the addresses over
				UPDATE	tAddress
				SET		CompanyKey = @oCompanyIdentity, Entity = NULL, EntityKey = NULL
				WHERE	Entity = 'tUserLead'
						AND EntityKey = @UserLeadKey
				
				Update tCompany Set DefaultAddressKey = @BKey Where CompanyKey = @oCompanyIdentity
			END

			if @CreateContact = 1 and @CreateCompany = 1
			BEGIN
					-- Just update the company address
				UPDATE	tAddress
				SET		CompanyKey = @oCompanyIdentity, Entity = NULL, EntityKey = NULL
				WHERE	AddressKey = @BKey
				
				Update tCompany Set DefaultAddressKey = @BKey Where CompanyKey = @oCompanyIdentity
					-- move the rest to the user
				UPDATE	tAddress
				SET		CompanyKey = 0, Entity = 'tUser', EntityKey = @oContactIdentity
				WHERE	Entity = 'tUserLead'
						AND EntityKey = @UserLeadKey
				
				Update tUser Set HomeAddressKey = @HKey, OtherAddressKey = @OKey Where UserKey = @oContactIdentity
				
			END
			if @CreateContact = 1 and @CreateCompany = 0
			BEGIN
					-- move the rest to the user
				UPDATE	tAddress
				SET		CompanyKey = 0, Entity = 'tUser', EntityKey = @oContactIdentity
				WHERE	Entity = 'tUserLead'
						AND EntityKey = @UserLeadKey
				
				Update tUser Set AddressKey = @BKey, HomeAddressKey = @HKey, OtherAddressKey = @OKey Where UserKey = @oContactIdentity
				
			END

			IF @CreateOpportunity = 1
			  BEGIN

				DECLARE @Probability INT
				
				SELECT @Probability = DefaultProbability FROM tLeadStage (NOLOCK) WHERE LeadStageKey = @OppStageKey
		
				INSERT INTO tLead
						(
						CompanyKey,
						[Subject],
						ContactCompanyKey,
						ContactKey,
						AccountManagerKey,
						ProjectTypeKey,
						LeadStageKey,
						WWPCurrentLevel,
						SaleAmount,
						AddedByKey,
						UpdatedByKey,
						DateAdded,
						DateUpdated,
						LeadStatusKey,
						CMFolderKey,
						Probability,
						CustomFieldKey,
						DateConverted,
						GLCompanyKey
						)
				SELECT	@CompanyKey,
						@OppSubject,
						@oCompanyIdentity,
						@oContactIdentity,
						OwnerKey,
						OppProjectTypeKey,
						@OppStageKey,
						1,
						OppAmount,
						@UserKey,
						@UserKey,
						GETUTCDATE(),
						GETUTCDATE(),
						@OppStatusKey,
						CASE ISNULL(@OppFolderKey, 0) WHEN 0 THEN NULL ELSE @OppFolderKey END,
						@Probability,
						OppCustomFieldKey,
						@ConvertDate,
						@GLCompanyKey
				FROM	tUserLead (NOLOCK)
				WHERE	UserLeadKey = @UserLeadKey
					
				SET @oOpportunityIdentity = @@IDENTITY			   
				
				IF ISNULL(@oContactIdentity,0) > 0
				  BEGIN
					INSERT INTO tLeadUser (LeadKey, UserKey, [Role])
					SELECT @oOpportunityIdentity, @oContactIdentity, UserRole FROM tUserLead (NOLOCK) WHERE UserLeadKey = @UserLeadKey

				  END 

				if @OppStageKey is not null
					INSERT INTO tLeadStageHistory (LeadKey, LeadStageKey, HistoryDate, Comment)
					VALUES (@oOpportunityIdentity, @OppStageKey, GETDATE(), 'Opportunity Created')

				INSERT INTO tLevelHistory (Entity, EntityKey, [Level], LevelDate)
				VALUES ('tLead', @oOpportunityIdentity, 1, GETUTCDATE())
				

				UPDATE	tActivity
				SET		LeadKey = @oOpportunityIdentity
				WHERE	UserLeadKey = @UserLeadKey
		

				INSERT INTO tActivityLink (ActivityKey, Entity, EntityKey)
				SELECT	ActivityKey, 'tLead', @oOpportunityIdentity
				FROM	tActivity (NOLOCK)
				WHERE	UserLeadKey = @UserLeadKey


			  END

			IF @CreateActivity = 1
			  BEGIN
		
				INSERT INTO tActivity
						(
						[Subject],
						ActivityDate,
						Completed,
						Priority,
						CompanyKey,
						ContactCompanyKey,
						ContactKey,
						OriginatorUserKey,
						LeadKey,
						AddedByKey,
						UpdatedByKey,
						DateAdded,
						DateUpdated,
						ActivityTypeKey,
						AssignedUserKey,
						Notes,
						CMFolderKey,
						ReminderMinutes,
						StartTime,
						EndTime,
						GLCompanyKey,
						ActivityEntity
						)
				SELECT 
						@ActivitySubject,
						@ActivityDate,
						@ActivityCompleted,
						@ActivityPriority,
						@CompanyKey,
						@oCompanyIdentity,
						@oContactIdentity,
						@UserKey,
						@oOpportunityIdentity,
						@UserKey,
						@UserKey,
						GETUTCDATE(),
						GETUTCDATE(),
						@ActivityTypeKey,
						@ActivityAssignedUserKey,
						@ActivityNote,
						CASE ISNULL(@ActivityFolderKey, 0) WHEN 0 THEN NULL ELSE @ActivityFolderKey END,
						@ActivityReminderMinutes,
						@ActivityStartTime,
						@ActivityEndTime,
						@GLCompanyKey,
						'Activity'
				FROM	tUserLead (NOLOCK)
				WHERE	UserLeadKey = @UserLeadKey
				
				SET @oActivityIdentity = @@IDENTITY			   

				--need to update newly inserted activity with the new key
				update tActivity set RootActivityKey = @oActivityIdentity
				where ActivityKey = @oActivityIdentity
				
				
				IF ISNULL(@oCompanyIdentity,0) > 0
				  BEGIN
					INSERT INTO tActivityLink (ActivityKey, Entity, EntityKey)
					VALUES (@oActivityIdentity, 'tCompany', @oCompanyIdentity)

				  END

				IF ISNULL(@oContactIdentity,0) > 0
				  BEGIN
					INSERT INTO tActivityLink (ActivityKey, Entity, EntityKey)
					VALUES (@oActivityIdentity, 'tUser', @oContactIdentity)

				  END

				IF ISNULL(@oOpportunityIdentity,0) > 0
				  BEGIN
					INSERT INTO tActivityLink (ActivityKey, Entity, EntityKey)
					VALUES (@oActivityIdentity, 'tLead', @oOpportunityIdentity)

				  END
				IF ISNULL(@AddToEmail, 0) > 0
					BEGIN
						EXEC sptActivityEmailUpdate @oActivityIdentity, @oContactIdentity, @UserKey, 'insert'
					
					END
			
			  END



		   -- clean up activity table by getting rid of the UserLeadKey
		   UPDATE tActivity
		   SET    UserLeadKey = NULL
		   WHERE  UserLeadKey = @UserLeadKey


		   -- clean up ActivityLink table
		   DELETE tActivityLink
		   WHERE  Entity = 'tUserLead' 
				  AND EntityKey = @UserLeadKey		
									
		  -- Log Deletes
		   select @CreateCompany = isnull(@CreateCompany, 0)
		   select @CreateContact = isnull(@CreateContact, 0)
           select @CreateOpportunity = isnull(@CreateOpportunity, 0) 
           select @CreateActivity = isnull(@CreateActivity, 0)

		   select @oCompanyIdentity = isnull(@oCompanyIdentity, 0)
		   select @oContactIdentity = isnull(@oContactIdentity, 0)
           select @oOpportunityIdentity = isnull(@oOpportunityIdentity, 0) 
           select @oActivityIdentity = isnull(@oActivityIdentity, 0)

		   DECLARE @parmList VARCHAR(1500)
           SELECT @parmList = '@UserLeadKey=' + CONVERT(VARCHAR(15),@UserLeadKey)
		   SELECT @parmList = @parmList + ',@CreateCompany=' + CONVERT(VARCHAR(10),@CreateCompany)
		   SELECT @parmList = @parmList + ',@CreateContact=' + CONVERT(VARCHAR(10),@CreateContact)
		   SELECT @parmList = @parmList + ',@CreateOpportunity=' + CONVERT(VARCHAR(10),@CreateOpportunity)
		   SELECT @parmList = @parmList + ',@CreateActivity=' + CONVERT(VARCHAR(10),@CreateActivity)

		   SELECT @parmList = @parmList + ',@oCompanyIdentity=' + CONVERT(VARCHAR(15),@oCompanyIdentity)
		   SELECT @parmList = @parmList + ',@oContactIdentity=' + CONVERT(VARCHAR(15),@oContactIdentity)
		   SELECT @parmList = @parmList + ',@oOpportunityIdentity=' + CONVERT(VARCHAR(15),@oOpportunityIdentity)
		   SELECT @parmList = @parmList + ',@oActivityIdentity=' + CONVERT(VARCHAR(15),@oActivityIdentity)

		   EXEC sptUserLeadUpdateLogInsert @UserLeadKey, @UserKey, 'D', 'sptUserLeadConvert', @parmList, 'UI'					
		
		  -- delete lead
		   Delete tUserLead
		   WHERE  UserLeadKey = @UserLeadKey
	  END
	ELSE 
	  RETURN -2
GO
