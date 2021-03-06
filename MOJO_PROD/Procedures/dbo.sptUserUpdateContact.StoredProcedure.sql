USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateContact]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateContact]
	(
		@UserKey int,
		@CompanyKey int,
		@FirstName varchar(100),
		@MiddleName varchar(100),
		@LastName varchar(100),
		@Salutation varchar(10),
		@UserCompanyName varchar(200),
		@DepartmentKey int,
		@Phone1 varchar(50),
		@Phone2 varchar(50),
		@Cell varchar(50),
		@Fax varchar(50),
		@Pager varchar(50),
		@Title varchar(200),
		@Email varchar(100),
		@SecurityGroupKey int,
		@OwnerKey int,
		@CMFolderKey int,
		@SystemID varchar(500),
		@OwnerCompanyKey int,
		@ContactMethod tinyint,
		@DoNotCall tinyint,
		@DoNotEmail tinyint,
		@DoNotMail tinyint,
		@DoNotFax tinyint,
		@HourlyRate money,
		@HourlyCost money,
		@TimeApprover int,
		@BackupApprover int,
		@ExpenseApprover int,
		@CreditCardApprover int,
		--@POLimit money,
		--@BCLimit money,
		--@IOLimit money,
		@VendorKey int,
		@ClassKey int,
		@OfficeKey int,
		@RateLevel int,
		--@TrafficNotification tinyint,
		@UpdatedByKey int,
		@TimeZoneIndex int,
		--@Supervisor tinyint,
		@DefaultReminderTime int,
		@DefaultServiceKey int,
		--@SystemMessage tinyint,
		@GLCompanyKey int,
		@MonthlyCost money,
		@ClientDivisionKey int,
		@ClientProductKey int,
		@Department varchar(300),
		@UserRole varchar(300),
		@ReportsToKey int,
		@Assistant varchar(300),
		@AssistantPhone varchar(50),
		@AssistantEmail varchar(100),
		@Birthday datetime,
		@SpouseName varchar(300),
		@Children varchar(500),
		@Anniversary datetime,
		@Hobbies varchar(500),
		@Comments text,
		@DateConverted smalldatetime,
		@LinkedCompanyAddressKey int,
		@WWPCurrentLevel int = null,
		@DeliverableReviewer tinyint,
		@DeliverableNotify tinyint,
		@Contractor tinyint = 0,
		@RequireUserTimeDetails tinyint,
		@DateHired smalldatetime,
		@TitleKey int = 0,
		@InvoiceEmails varchar(1000) = null,
		@TwitterID varchar(50) = NULL,
		@LinkedInURL varchar(100) = NULL
	)
	
AS

/*
  || When     Who Rel      What
  || 09/08/09 MFT 10.509   Added @CustomFieldKey
  || 09/10/09 GWG 10.509   Removed CustomFieldKey
  || 9/17/09  CRG 10.5.1.0 Added LinkedCompanyAddressKey
  || 10/02/09 GHL 10.5.1.1 (63702) Added WWPCurrentLevel
  || 10/5/09  CRG 10.5.1.1 Removed DefaultCalendarColor
  || 11/25/09 MFT 10.5.1.5 Set @UserCompanyName if not given
  || 05/18/10 RLB 10.5.2.3 (80993)Default Client Vendor Login to 1 on new contacts
  || 04/08/11 QMD 10.5.4.3 Added check if email is different section
  || 12/10/11 GWG 10.5.5.0 Added the default deliverable flags
  || 05/30/12 GHL 10.5.5.6 (145013) Added Contractor field
  || 06/18/12 RLB 10.5.5.7 Added for HMI Changes
  || 07/09/12 GHL 10.5.5.8 If we restrict by gl company, get default from owner and add to tGLCompanyAccess
  || 09/19/12 GHL 10.5.6.0 Added Backup and Credit Card approvers
  || 10/29/12 MFT 10.5.6.1 Added DateHired
  || 05/24/13 QMD 10.5.6.8 Add logic to update tSyncItem for contacts that are moved
  || 10/20/14 WDF 10.5.8.5 Ableson Taylor - Added TitleKey; Don't allow TitleKey update for existing contacts when imported
  || 11/05/14 WDF 10.5.8.6 (232644) Added InvoiceEmails
  || 11/05/14 MFT 10.5.8.6 Added TwitterID and LinkedInURL
*/
DECLARE @ActionOnName varchar(201), @CurrentTitleKey int, @CurrentTitleID varchar(50), @NewTitleID varchar(50)
DECLARE @CharIdx int, @Msg varchar(4000), @CurrentDate as datetime

IF ISNULL(@UserCompanyName, '') = '' AND ISNULL(@CompanyKey, 0) > 0
	SELECT
		@UserCompanyName = CompanyName
	FROM
		tCompany (nolock)
	WHERE
		CompanyKey = @CompanyKey

if ISNULL(@UserKey, 0) > 0
BEGIN

	--Check if email is different
	IF NOT EXISTS(SELECT * FROM tUser (NOLOCK) WHERE UserKey = @UserKey AND Email = @Email)
		BEGIN
			IF EXISTS(SELECT * FROM tMarketingListList (NOLOCK) WHERE Entity='tUser' AND EntityKey = @UserKey)
				BEGIN
					DECLARE @parmList VARCHAR(50)
					SELECT @parmList = '@UserKey=' + CONVERT(VARCHAR(10),@UserKey)
					-- E = Email Update
					EXEC sptUserUpdateLogInsert @UpdatedByKey, @UserKey, 'E', 'sptUserUpdateContact', @parmList, 'UI'
				END
		END 

	--Handle folder changes
	DECLARE @OLD_CMFolderKey INTEGER
	SELECT @OLD_CMFolderKey = CMFolderKey FROM tUser (NOLOCK) WHERE UserKey = @UserKey
	IF EXISTS(SELECT * FROM tSyncItem (NOLOCK) WHERE CompanyKey = @OwnerCompanyKey AND ApplicationItemKey = @UserKey AND ApplicationFolderKey = @OLD_CMFolderKey)
		BEGIN
			IF (@OLD_CMFolderKey <> @CMFolderKey)
				BEGIN
					IF EXISTS(SELECT * FROM tSyncItem (NOLOCK) WHERE CompanyKey = @OwnerCompanyKey AND ApplicationItemKey = @UserKey * -1 AND ApplicationFolderKey = @OLD_CMFolderKey)
						DELETE tSyncItem WHERE CompanyKey = @OwnerCompanyKey AND ApplicationItemKey = @UserKey * -1 AND ApplicationFolderKey = @OLD_CMFolderKey
		
					UPDATE	tSyncItem 
					SET		ApplicationItemKey = ApplicationItemKey * -1
					WHERE	CompanyKey = @OwnerCompanyKey
							AND ApplicationItemKey = @UserKey
							AND ApplicationFolderKey = @OLD_CMFolderKey	
				END
		END

	-- Don't allow TitleKey update for existing contacts when imported
	SELECT @CharIdx = charindex('billingtitles',Customizations)
	  FROM tPreference (nolock)
	 WHERE CompanyKey = @OwnerCompanyKey
	
	IF @CharIdx > 0
	BEGIN
		SELECT @ActionOnName = ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
		      ,@CurrentTitleKey = ISNULL(t.TitleKey, ISNULL(@TitleKey, 0)), @CurrentTitleID = ISNULL(t.TitleID, '')
		  FROM tUser u (nolock) LEFT JOIN tTitle t (nolock) ON u.TitleKey = t.TitleKey
		 WHERE u.CompanyKey = @CompanyKey
		   AND u.UserKey = @UserKey
		   
		if LEN(@ActionOnName) = 0
			SELECT @ActionOnName = '(' + CAST(@UserKey as varchar(7)) + ')'

		IF ISNULL(@TitleKey, 0) <> @CurrentTitleKey
		BEGIN
			SELECT @NewTitleID = TitleID FROM tTitle (nolock) WHERE TitleKey = @TitleKey
		    SELECT @CurrentDate = GETUTCDATE()
			SELECT @Msg = 'Billing Title for ' + @ActionOnName + ' was blocked from being updated from ''' + @CurrentTitleID + ''' to ''' + @NewTitleID  + ''' through the Contact Import'
        
			EXEC sptActionLogInsert 'User', @UserKey, @OwnerCompanyKey, 0, 'Billing Title Blocked', @CurrentDate, 'Contact Import'
							       ,@Msg, @CompanyKey, Null, NULL   

			SELECT @TitleKey = @CurrentTitleKey
		END
	END
	-- update the existing record
	UPDATE
		tUser
	SET
		CompanyKey = @CompanyKey,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Salutation = @Salutation,
		UserCompanyName = @UserCompanyName,
		DepartmentKey = @DepartmentKey,
		Phone1 = @Phone1,
		Phone2 = @Phone2,
		Cell = @Cell,
		Fax = @Fax,
		Pager = @Pager,
		Title = @Title,
		Email = @Email,
		SecurityGroupKey = @SecurityGroupKey,
		OwnerKey = @OwnerKey,
		CMFolderKey = @CMFolderKey,
		Administrator = 0,
		SystemID = @SystemID,
		ContactMethod = @ContactMethod,
		DoNotCall = @DoNotCall,
		DoNotEmail = @DoNotEmail,
		DoNotMail = @DoNotMail,
		DoNotFax = @DoNotFax,
		AutoAssign = 0,
		NoUnassign = 0,
		HourlyRate = @HourlyRate,
		HourlyCost = @HourlyCost,
		TimeApprover = @TimeApprover,
		BackupApprover = @BackupApprover,
		ExpenseApprover = @ExpenseApprover,
		CreditCardApprover = @CreditCardApprover,
		POLimit = 0,
		BCLimit = 0,
		IOLimit = 0,
		VendorKey = @VendorKey,
		ClassKey = @ClassKey,
		OfficeKey = @OfficeKey,
		RateLevel = @RateLevel,
		TrafficNotification = 0,
		UpdatedByKey = @UpdatedByKey,
		DateUpdated = GETUTCDATE(),
		TimeZoneIndex = @TimeZoneIndex,
		Supervisor = 0,
		DefaultReminderTime = @DefaultReminderTime,
		DefaultServiceKey = @DefaultServiceKey,
		--SystemMessage = @SystemMessage,
		GLCompanyKey = @GLCompanyKey,
		MonthlyCost = @MonthlyCost,
		LastModified = GETUTCDATE(),
		ClientDivisionKey = @ClientDivisionKey,
		ClientProductKey = @ClientProductKey,
		Department = @Department,
		UserRole = @UserRole,
		ReportsToKey = @ReportsToKey,
		Assistant = @Assistant,
		AssistantPhone = @AssistantPhone,
		AssistantEmail = @AssistantEmail,
		Birthday = @Birthday,
		SpouseName = @SpouseName,
		Children = @Children,
		Anniversary = @Anniversary,
		Hobbies = @Hobbies,
		Comments = @Comments,
		DateConverted = @DateConverted,
		LinkedCompanyAddressKey = @LinkedCompanyAddressKey,
		DeliverableReviewer = @DeliverableReviewer,
		DeliverableNotify = @DeliverableNotify,
		Contractor = @Contractor,
		RequireUserTimeDetails = @RequireUserTimeDetails,
		DateHired = @DateHired,
		TitleKey = @TitleKey,
		InvoiceEmails = @InvoiceEmails,
		TwitterID = @TwitterID,
		LinkedInURL = @LinkedInURL
	WHERE
		UserKey = @UserKey 

END
ELSE
BEGIN

	INSERT tUser
		(
		CompanyKey,
		FirstName,
		MiddleName,
		LastName,
		Salutation,
		UserCompanyName,
		DepartmentKey,
		Phone1,
		Phone2,
		Cell,
		Fax,
		Pager,
		Title,
		Email,
		SecurityGroupKey,
		OwnerKey,
		CMFolderKey,
		Administrator,
		SystemID,
		OwnerCompanyKey,
		ContactMethod,
		DoNotCall,
		DoNotEmail,
		DoNotMail,
		DoNotFax,
		HourlyRate,
		HourlyCost,
		TimeApprover,
		BackupApprover,
		ExpenseApprover,
		CreditCardApprover,
		POLimit,
		BCLimit,
		IOLimit,
		VendorKey,
		ClassKey,
		OfficeKey,
		RateLevel,
		TrafficNotification,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated,
		TimeZoneIndex,
		NumberOfAttempts,
		Supervisor,
		DefaultReminderTime,
		DefaultServiceKey,
		SystemMessage,
		GLCompanyKey,
		MonthlyCost,
		LastModified,
		ClientDivisionKey,
		ClientProductKey,
		Department,
		UserRole,
		ReportsToKey,
		Assistant,
		AssistantPhone,
		AssistantEmail,
		Birthday,
		SpouseName,
		Children,
		Anniversary,
		Hobbies,
		Comments,
		Active,
		DateConverted,
		LinkedCompanyAddressKey,
		ClientVendorLogin,
		DeliverableReviewer,
		DeliverableNotify,
		Contractor,
		RequireUserTimeDetails,
		DateHired,
		TitleKey,
		InvoiceEmails,
		TwitterID,
		LinkedInURL
		)

	VALUES
		(
		@CompanyKey,
		@FirstName,
		@MiddleName,
		@LastName,
		@Salutation,
		@UserCompanyName,
		@DepartmentKey,
		@Phone1,
		@Phone2,
		@Cell,
		@Fax,
		@Pager,
		@Title,
		@Email,
		@SecurityGroupKey,
		@OwnerKey,
		@CMFolderKey,
		0,
		@SystemID,
		@OwnerCompanyKey,
		@ContactMethod,
		@DoNotCall,
		@DoNotEmail,
		@DoNotMail,
		@DoNotFax,
		@HourlyRate,
		@HourlyCost,
		@TimeApprover,
		@BackupApprover,
		@ExpenseApprover,
		@CreditCardApprover,
		0, --@POLimit,
		0, --@BCLimit,
		0, --@IOLimit,
		@VendorKey,
		@ClassKey,
		@OfficeKey,
		@RateLevel,
		0, --@TrafficNotification,
		@UpdatedByKey, -- AddedByKey
		@UpdatedByKey,
		GETUTCDATE(), --@DateAdded,
		GETUTCDATE(), --@DateUpdated,
		@TimeZoneIndex,
		0, --NumberOfAttempts
		0, --@Supervisor,
		@DefaultReminderTime,
		@DefaultServiceKey,
		0, --@SystemMessage,
		@GLCompanyKey,
		@MonthlyCost,
		GETUTCDATE(), --@LastModified,
		@ClientDivisionKey,
		@ClientProductKey,
		@Department,
		@UserRole,
		@ReportsToKey,
		@Assistant,
		@AssistantPhone,
		@AssistantEmail,
		@Birthday,
		@SpouseName,
		@Children,
		@Anniversary,
		@Hobbies,
		@Comments,
		1,  --Active
		@DateConverted,
		@LinkedCompanyAddressKey,
		1, --Default Client Vendor Login to true on new contacts,
		@DeliverableReviewer,
		@DeliverableNotify,
		@Contractor,
		@RequireUserTimeDetails,
		@DateHired,
		@TitleKey,
		@InvoiceEmails,
		@TwitterID,
		@LinkedInURL
		)
	
	SELECT @UserKey = @@IDENTITY

	declare @RestrictToGLCompany int,@DefaultGLCompanyKey int

	select @RestrictToGLCompany = isnull(pref.RestrictToGLCompany, 0)
	      ,@DefaultGLCompanyKey = isnull(u.GLCompanyKey, 0)
	from  tUser u (nolock)
		inner join tPreference pref (nolock) on isnull(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey
	where u.UserKey = @OwnerKey
 
	if @RestrictToGLCompany = 1 and @DefaultGLCompanyKey > 0
		insert tGLCompanyAccess (Entity, EntityKey, GLCompanyKey, CompanyKey)
		values ('tUser', @UserKey, @DefaultGLCompanyKey, @OwnerCompanyKey)
END

IF @WWPCurrentLevel is not null
Begin
	UPDATE tUser SET WWPCurrentLevel = @WWPCurrentLevel WHERE UserKey = @UserKey

	Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
	Values ('tUser', @UserKey, @WWPCurrentLevel, NULL, GETUTCDATE())
	
End

Return @UserKey
GO
