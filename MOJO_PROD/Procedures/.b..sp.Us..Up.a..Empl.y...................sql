USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateEmployee]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateEmployee]
	@UserKey int = 0,
	@CompanyKey int,
	@FirstName varchar(100),
	@MiddleName varchar(100),
	@LastName varchar(100),
	@Salutation varchar(10),
	@Phone1 varchar(50),
	@Phone2 varchar(50),
	@Cell varchar(50),
	@Fax varchar(50),
	@Pager varchar(50),
	@Title varchar(200),
	@Email varchar(100),
	@SystemID varchar(500),
	@ContactMethod tinyint,
	@DepartmentKey int,
	@OfficeKey int,
	@TimeZoneIndex int,
	@Supervisor tinyint,
	@DefaultServiceKey int,
	@SecurityGroupKey int,
	@Locked tinyint,
	@UserRole varchar(300),
	@Assistant varchar(300),
	@AssistantPhone varchar(50),
	@AssistantEmail varchar(100),
	@Birthday datetime,
	@SpouseName varchar(300),
	@Children varchar(500),
	@Anniversary datetime,
	@Hobbies varchar(500),
	@Comments varchar(1000),
	@HourlyCost money,
	@MonthlyCost money,
	@HourlyRate money,
	@RateLevel int,
	@TimeApprover int,
	@ExpenseApprover int,
	@GLCompanyKey int,
	@VendorKey int,
	@ClassKey int,
	@AutoAssign tinyint,
	@NoUnassign tinyint,
	@POLimit money,
	@BCLimit money,
	@IOLimit money,
	@SubscribeDiary tinyint,
	@SubscribeToDo tinyint,
	@DeliverableReviewer tinyint,
	@DeliverableNotify tinyint,
	@Contractor tinyint,
	@RequireUserTimeDetails tinyint,
	@BackupApprover int,
	@CreditCardApprover int,
	@DateHired smalldatetime,
	@TitleKey int
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 08/28/09  MFT 10.5.0.8 Created
|| 9/10/09   CRG 10.5.1.0 Removed DefaultCalendarColor
|| 10/5/09   GWG 10.5.1.1 Removed Owner Company Key
|| 10/14/09  MFT 10.5.1.2 Removed CustomeFieldKey
|| 12/21/10  GHL 10.5.3.9 Added Subscribe Diary and ToDo params
|| 12/10/11  GWG 10.5.5.0 Added the default deliverable flags
|| 05/30/12  GHL 10.5.5.6 (145013) Added Contractor field
|| 06/18/12  RLB 10.5.5.7 Added for HMI Changes
|| 09/19/12	 KMC 10.5.6.0 Added BackupApprover
|| 09/19/12	 GHL 10.5.6.0 Added CreditCardApprover
|| 10/29/12  MFT 10.5.6.1 Added DateHired
|| 05/08/13  WDF 10.5.6.8 (177487) Added SystemMessage defaulted to 1 for New employee
|| 05/16/14  WDF 10.5.8.0 (216580) Removed 'IF @TimeZoneIndex < 0 SELECT @TimeZoneIndex = 4'
|| 09/23/14  MAS 10.5.8.3 Ableson & Taylor - Added @TitleKey
|| 10/20/14  WDF 10.5.8.4 Ableson & Taylor - Don't allow TitleKey update for existing employees when imported
*/

DECLARE @ActionOnName varchar(201), @CurrentTitleKey int, @CurrentTitleID varchar(50), @NewTitleID varchar(50)
DECLARE @CharIdx int, @Msg varchar(4000), @CurrentDate as datetime

IF @UserKey > 0
	BEGIN
	
	select @CharIdx = charindex('billingtitles',Customizations)
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey
	
	if @CharIdx > 0
	begin
		select @ActionOnName = FirstName + ' ' + LastName
		      ,@CurrentTitleKey = ISNULL(t.TitleKey, ISNULL(@TitleKey, 0)), @CurrentTitleID = ISNULL(t.TitleID, '')
		  from tUser u (nolock) LEFT JOIN tTitle t (nolock) on u.TitleKey = t.TitleKey
		 where u.CompanyKey = @CompanyKey
		   and u.UserKey = @UserKey

		if ISNULL(@TitleKey, 0) <> @CurrentTitleKey
		BEGIN
			select @NewTitleID = TitleID from tTitle (nolock) where CompanyKey = @CompanyKey and TitleKey = @TitleKey
		    select @CurrentDate = GETUTCDATE()
			select @Msg = 'Billing Title for ' + @ActionOnName + ' was blocked from being updated from ''' + @CurrentTitleID + ''' to ''' + @NewTitleID  + ''' through the Employee Import'
        
			EXEC sptActionLogInsert 'User', @UserKey, @CompanyKey, 0, 'Billing Title Blocked', @CurrentDate, 'Employee Import'
							       ,@Msg, @CurrentTitleKey, NULL, NULL   

			SELECT @TitleKey = @CurrentTitleKey
		END
	end
	
	UPDATE
		tUser
	SET
		CompanyKey = @CompanyKey,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Salutation = @Salutation,
		Phone1 = @Phone1,
		Phone2 = @Phone2,
		Cell = @Cell,
		Fax = @Fax,
		Pager = @Pager,
		Title = @Title,
		Email = @Email,
		SystemID = @SystemID,
		OwnerCompanyKey = NULL,
		ContactMethod = @ContactMethod,
		DepartmentKey = @DepartmentKey,
		OfficeKey = @OfficeKey,
		TimeZoneIndex = @TimeZoneIndex,
		Supervisor = @Supervisor,
		DefaultServiceKey = @DefaultServiceKey,
		DateUpdated = GETDATE(),
		SecurityGroupKey = @SecurityGroupKey,
		Locked = @Locked,
		UserRole = @UserRole,
		Assistant = @Assistant,
		AssistantPhone = @AssistantPhone,
		AssistantEmail = @AssistantEmail,
		Birthday = @Birthday,
		SpouseName = @SpouseName,
		Children = @Children,
		Anniversary = @Anniversary,
		Hobbies = @Hobbies,
		Comments = @Comments,
		HourlyCost = @HourlyCost,
		MonthlyCost = @MonthlyCost,
		HourlyRate = @HourlyRate,
		RateLevel = @RateLevel,
		TimeApprover = @TimeApprover,
		ExpenseApprover = @ExpenseApprover,
		GLCompanyKey = @GLCompanyKey,
		VendorKey = @VendorKey,
		ClassKey = @ClassKey,
		AutoAssign = @AutoAssign,
		NoUnassign = @NoUnassign,
		POLimit = @POLimit,
		BCLimit = @BCLimit,
		IOLimit = @IOLimit,
		SubscribeDiary = @SubscribeDiary,
		SubscribeToDo = @SubscribeToDo,
		DeliverableReviewer = @DeliverableReviewer,
		DeliverableNotify = @DeliverableNotify,
		Contractor = @Contractor,
		RequireUserTimeDetails = @RequireUserTimeDetails,
		BackupApprover = @BackupApprover,
		CreditCardApprover = @CreditCardApprover,
		DateHired = @DateHired,
		TitleKey = @TitleKey
	WHERE
		UserKey = @UserKey 
	END
ELSE
	BEGIN
		DECLARE @CurPrimaryCont int
		
		INSERT tUser
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
			SystemID,
			OwnerCompanyKey,
			ContactMethod,
			DepartmentKey,
			OfficeKey,
			TimeZoneIndex,
			Supervisor,
			DefaultServiceKey,
			DateAdded,
			DateUpdated,
			Active,
			SecurityGroupKey,
			Locked,
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
			HourlyCost,
			MonthlyCost,
			HourlyRate,
			RateLevel,
			TimeApprover,
			ExpenseApprover,
			GLCompanyKey,
			VendorKey,
			ClassKey,
			AutoAssign,
			NoUnassign,
			POLimit,
			BCLimit,
			IOLimit,
			SystemMessage,
			SubscribeDiary,
		  SubscribeToDo,
			DeliverableReviewer,
		  DeliverableNotify,
			Contractor,
			RequireUserTimeDetails,
			BackupApprover,
			CreditCardApprover,
			DateHired,
			TitleKey
		)
		VALUES
		(
			@CompanyKey,
			@FirstName,
			@MiddleName,
			@LastName,
			@Salutation,
			@Phone1,
			@Phone2,
			@Cell,
			@Fax,
			@Pager,
			@Title,
			@Email,
			@SystemID,
			NULL,
			@ContactMethod,
			@DepartmentKey,
			@OfficeKey,
			@TimeZoneIndex,
			@Supervisor,
			@DefaultServiceKey,
			GETDATE(),
			GETDATE(),
			1,
			@SecurityGroupKey,
			@Locked,
			@UserRole,
			@Assistant,
			@AssistantPhone,
			@AssistantEmail,
			@Birthday,
			@SpouseName,
			@Children,
			@Anniversary,
			@Hobbies,
			@Comments,
			@HourlyCost,
			@MonthlyCost,
			@HourlyRate,
			@RateLevel,
			@TimeApprover,
			@ExpenseApprover,
			@GLCompanyKey,
			@VendorKey,
			@ClassKey,
			@AutoAssign,
			@NoUnassign,
			@POLimit,
			@BCLimit,
			@IOLimit,
			1,
			@SubscribeDiary,
		  @SubscribeToDo,
			@DeliverableReviewer,
		  @DeliverableNotify,
			@Contractor,
			@RequireUserTimeDetails,
			@BackupApprover,
			@CreditCardApprover,
			@DateHired,
			@TitleKey
		)
		
		SELECT @UserKey = SCOPE_IDENTITY()
		
		SELECT @CurPrimaryCont = PrimaryContact
		FROM tCompany (nolock)
		WHERE CompanyKey = @CompanyKey
		
		IF @CurPrimaryCont = 0
			UPDATE tCompany
			SET PrimaryContact = @UserKey
			WHERE CompanyKey = @CompanyKey
	END

IF @Supervisor = 0
	DELETE tUserNotification
	WHERE UserKey = @UserKey
	AND NotificationID IN ('ODTIME', 'NOHOURS')
	AND Value = 3 -- The people I supervise

RETURN @UserKey
GO
