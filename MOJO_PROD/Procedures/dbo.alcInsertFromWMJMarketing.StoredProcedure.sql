USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[alcInsertFromWMJMarketing]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[alcInsertFromWMJMarketing]
	@ContactKey varchar(50),
	@FirstName varchar(300),
	@LastName varchar(300),
	@CompanyName varchar(500),
	@Department varchar(100),
	@CompanySize varchar(100),
	@CompanyTypeKey int,
	@Email varchar(300),
	@Phone varchar(50),
	@StateCountry varchar(200),
	@MarketingCode varchar(200),
	@RequestType varchar(200),
	@LastEndView datetime,
	@PageHistory text,
	@Source varchar(100),
	@Keyword varchar(100)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 12/21/10 GHL 10.359 Added ActivityEntity
  */
	DECLARE	@ContactOwnerKey int
	SELECT @ContactOwnerKey = 46286 -- Kristie Golding
	
	DECLARE	@CompanyKey int,
			@UserKey int,
			@LeadKey int,
			@AddressKey int,
			@CompanyActive tinyint

	SELECT	@LastEndView = ISNULL(@LastEndView, GETDATE())
	IF YEAR(@LastEndView) = 1900
		SELECT @LastEndView = GETDATE()

	SELECT	@UserKey = u.UserKey,
			@CompanyKey = u.CompanyKey
	FROM	tUser u (nolock)
	WHERE	u.UserDefined10 = @ContactKey

	IF @CompanyKey IS NULL
	BEGIN
		DECLARE @AtPos int
		SELECT @AtPos = CHARINDEX('@', @Email)
		
		IF @AtPos > 0
		BEGIN
			DECLARE @Domain varchar(300)
			SELECT @Domain = SUBSTRING(@Email, @AtPos, LEN(@Email) - @AtPos + 1)
			
			SELECT	@CompanyKey = MIN(CompanyKey)
			FROM	tUser (NOLOCK)
			WHERE	UPPER(Email) LIKE '%' + UPPER(@Domain)
		END
	END		
	
/* Per Kristie Golding on 4/3/09- she does not want it to compare company names anymore. 
	IF @CompanyKey IS NULL
		SELECT	@CompanyKey = MIN(c.CompanyKey)
		FROM	tCompany c (NOLOCK)
		LEFT JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey
		WHERE	UPPER(LTRIM(RTRIM(c.CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
		AND		UPPER(LTRIM(RTRIM(a.State))) = UPPER(LTRIM(RTRIM(@StateCountry)))
		AND		c.OwnerCompanyKey = 1

	IF @CompanyKey IS NULL
		SELECT @CompanyKey = MIN(CompanyKey)
		FROM   tCompany (NOLOCK)
		WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
		AND    OwnerCompanyKey = 1
*/

	DECLARE @CompanySizeText varchar(100)
	IF @CompanySize = 1
		SELECT @CompanySizeText = '1-10 Full-Time Employees'
	IF @CompanySize = 2
		SELECT @CompanySizeText = '11-25 Full-Time Employees'
	IF @CompanySize = 3
		SELECT @CompanySizeText = '26-50 Full-Time Employees'
	IF @CompanySize = 4
		SELECT @CompanySizeText = '51-100 Full-Time Employees'
	IF @CompanySize = 5
		SELECT @CompanySizeText = '101-200 Full-Time Employees'
	IF @CompanySize = 6
		SELECT @CompanySizeText = '200+ Full-Time Employees'
	IF @CompanySize > 6
		SELECT @CompanySizeText = @CompanySize
	
	IF @CompanyKey IS NULL
	BEGIN
		INSERT	tCompany
				(CompanyName,
				OwnerCompanyKey,
				Phone,
				UserDefined1,
				UserDefined2,
				UserDefined6,
				Active,
				ContactOwnerKey,
				CompanyTypeKey)
		VALUES	(@CompanyName,
				1,
				@Phone,
				@MarketingCode,
				@RequestType,
				@CompanySizeText,
				1,
				@ContactOwnerKey,
				@CompanyTypeKey)
		
		SELECT	@CompanyKey = @@IDENTITY
		
		INSERT	tAddress
				(OwnerCompanyKey,
				CompanyKey,
				AddressName,
				State)
		VALUES	(1,
				@CompanyKey,
				'Default',
				@StateCountry)
		
		SELECT	@AddressKey = @@IDENTITY
				
		UPDATE	tCompany
		SET		DefaultAddressKey = @AddressKey
		WHERE	CompanyKey = @CompanyKey
	END
	ELSE
	BEGIN
		UPDATE	tCompany
		SET		Phone = ISNULL(Phone, @Phone),
				UserDefined1 = ISNULL(UserDefined1, @MarketingCode),
				UserDefined2 = ISNULL(UserDefined2, @RequestType),
				UserDefined6 = ISNULL(UserDefined6, @CompanySizeText),
				CompanyTypeKey = ISNULL(CompanyTypeKey, @CompanyTypeKey)
		WHERE	CompanyKey = @CompanyKey

		SELECT	@CompanyActive = Active
		FROM	tCompany (nolock)
		WHERE	CompanyKey = @CompanyKey

		IF ISNULL(@CompanyActive, 0) = 0
			UPDATE	tCompany
			SET		Active = 1
			WHERE	CompanyKey = @CompanyKey
		
		SELECT	@AddressKey = DefaultAddressKey
		FROM	tCompany (NOLOCK)
		WHERE	CompanyKey = @CompanyKey
		
		IF @AddressKey IS NULL
		BEGIN
			INSERT	tAddress
					(OwnerCompanyKey,
					CompanyKey,
					AddressName,
					State)
			VALUES	(1,
					@CompanyKey,
					'Default',
					@StateCountry)
			
			SELECT	@AddressKey = @@IDENTITY
					
			UPDATE	tCompany
			SET		DefaultAddressKey = @AddressKey
			WHERE	CompanyKey = @CompanyKey		
		END
	END
	
	IF @CompanyKey IS NULL
		RETURN 0
	
	-----------------------------------------------------------
	-- Added this 12/10/09 to add Company Size to custom fields
	DECLARE @companyCustomFieldKey INT 
	SELECT @companyCustomFieldKey = CustomFieldKey FROM tCompany (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	IF (ISNULL(@companyCustomFieldKey,'') = '')
	   BEGIN
	   
		EXEC spCF_tObjectFieldSetInsert 1, @companyCustomFieldKey OUTPUT
		UPDATE tCompany SET CustomFieldKey = @companyCustomFieldKey WHERE CompanyKey = @CompanyKey
			
	   END 
   
	--HARD CODED CUSTOM FIELD UPDATES		
	EXEC spCF_tFieldValueUpdate 428, @companyCustomFieldKey, @MarketingCode --Company_UD_Web_Source-in
	EXEC spCF_tFieldValueUpdate 429, @companyCustomFieldKey, @RequestType --Company_UD_Request_Type-in
	EXEC spCF_tFieldValueUpdate 430, @companyCustomFieldKey, @CompanySizeText --Company_UD_Nbr_of_Users_from_Sign-in			
	EXEC spCF_tFieldValueUpdate 438, @companyCustomFieldKey, @Source --Source		
	EXEC spCF_tFieldValueUpdate 439, @companyCustomFieldKey, @Keyword --Keyword		
	-----------------------------------------------------------	
	
	IF @UserKey IS NULL
	BEGIN
		INSERT	tUser
				(CompanyKey,
				OwnerCompanyKey,
				FirstName,
				LastName,
				Email,
				Phone1,
				Title,
				Active,
				OwnerKey,
				UserDefined10)
		VALUES	(@CompanyKey,
				1,
				@FirstName,
				@LastName,
				@Email,
				@Phone,
				@Department,
				1,
				@ContactOwnerKey,
				@ContactKey)
		
		SELECT	@UserKey = @@IDENTITY
		
		IF NOT EXISTS
				(SELECT NULL
				FROM	tCompany (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		ISNULL(PrimaryContact, 0) > 0)
			UPDATE	tCompany
			SET		PrimaryContact = @UserKey
			WHERE	CompanyKey = @CompanyKey
	END
	
	SELECT	@LeadKey = MIN(LeadKey)
	FROM	tLead (NOLOCK)
	WHERE	ContactCompanyKey = @CompanyKey
	
	IF @LeadKey IS NULL
	BEGIN
		INSERT	tLead
				(CompanyKey,
				ContactCompanyKey,
				ContactKey,
				AccountManagerKey,
				Subject,
				LeadStatusKey,
				LeadStageKey,
				StartDate)
		VALUES	(1,
				@CompanyKey,
				@UserKey,
				@ContactOwnerKey,
				'XXX',
				1,
				1,
				CAST(CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime))
		
		SELECT	@LeadKey = @@IDENTITY
	END
	Declare @ActivityKey int
	--Add an activity if there is history
	IF @PageHistory IS NOT NULL
	BEGIN
		INSERT	tActivity
				(CompanyKey,
				ContactCompanyKey,
				ContactKey,
				Subject,
				AssignedUserKey,
				Completed,
				Priority,
				ActivityDate,
				LeadKey,
				DateAdded,
				Notes,
				ActivityEntity
				)
		VALUES	(1,
				@CompanyKey,
				@UserKey,
				@RequestType,
				@ContactOwnerKey,
				0,
				'1-High',
				@LastEndView,	
				@LeadKey,
				GETDATE(),
				@PageHistory,
				'Activity'
				)
		Select @ActivityKey = @@IDENTITY

		INSERT tActivityLink(ActivityKey, Entity, EntityKey)
		Values (@ActivityKey, 'tUser', @UserKey)

		if @CompanyKey > 0
			INSERT tActivityLink(ActivityKey, Entity, EntityKey)
			Values (@ActivityKey, 'tCompany', @CompanyKey)

		if @LeadKey > 0
			INSERT tActivityLink(ActivityKey, Entity, EntityKey)
			Values (@ActivityKey, 'tLead', @LeadKey)
	END
	RETURN 1
GO
