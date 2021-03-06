USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdate]
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
	@OwnerCompanyKey int,
	@ContactMethod tinyint,
	@DepartmentKey int,
	@OfficeKey int,
	@TimeZoneIndex int,
	@Supervisor tinyint,
	@DefaultCalendarColor varchar(50)

AS --Encrypt

-- GHL: Patch for negative TimeZoneIndex!
/*
|| When      Who Rel      What
|| 03/16/09  QMD 10.5.0.0 Removed User Defined fields
|| 08/25/09  MFT 10.5.0.8 Added insert logic
*/

IF @TimeZoneIndex < 0
	SELECT @TimeZoneIndex = 4

IF @UserKey > 0
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
		OwnerCompanyKey = @OwnerCompanyKey,
		ContactMethod = @ContactMethod,
		DepartmentKey = @DepartmentKey,
		OfficeKey = @OfficeKey,
		TimeZoneIndex = @TimeZoneIndex,
		Supervisor = @Supervisor,
		DefaultCalendarColor = @DefaultCalendarColor,
		DateUpdated = GETDATE()
	WHERE
		UserKey = @UserKey 
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
			AutoAssign,
			NoUnassign,
			HourlyRate,
			HourlyCost,
			TimeApprover,
			ExpenseApprover,
			CustomFieldKey,
			DepartmentKey,
			OfficeKey,
			RateLevel,
			TimeZoneIndex,
			Supervisor,
			DefaultCalendarColor,
			DateAdded,
			DateUpdated,
			Active
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
			@OwnerCompanyKey,
			@ContactMethod,
			0,
			0,
			0,
			0,
			NULL,
			NULL,
			NULL,
			@DepartmentKey,
			@OfficeKey,
			1,
			@TimeZoneIndex,
			@Supervisor,
			@DefaultCalendarColor,
			GETDATE(),
			GETDATE(),
			1	
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

If @Supervisor = 0
	DELETE tUserNotification
	WHERE UserKey = @UserKey
	AND NotificationID IN ('ODTIME', 'NOHOURS')
	AND Value = 3 -- The people I supervise

RETURN @UserKey
GO
