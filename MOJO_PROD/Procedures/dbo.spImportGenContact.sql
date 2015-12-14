USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportGenContact]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spImportGenContact]
 (
	@OwnerCompanyKey int,
	@CompanyName varchar(200),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@PrimaryContact tinyint,
	@Vendor tinyint,
	@VendorID varchar(50),
	@BillableClient tinyint,
	@CustomerID varchar(50),
	@DefaultExpenseAccount varchar(100),
	@DefaultSalesAccount varchar(100),
	@HourlyRate money,
	@BAddress1 varchar(100),
	@BAddress2 varchar(100),
	@BAddress3 varchar(100),
	@BCity varchar(100),
	@BState varchar(50),
	@BPostalCode varchar(20),
	@BCountry varchar(50),
	@WebSite varchar(100),
	@Phone varchar(20),
	@Fax varchar(20),
	@Active tinyint,
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250),
	@User_FirstName varchar(100),
	@User_LastName varchar(100),
	@User_Salutation varchar(10),
	@User_Department varchar(200),
	@User_Phone1 varchar(20),
	@User_Phone2 varchar(20),
	@User_Cell varchar(20),
	@User_Fax varchar(20),
	@User_Pager varchar(20),
	@User_Title varchar(50),
	@User_Email varchar(100),
	@User_SecurityGroup varchar(100),
	@User_Administrator tinyint,
	@User_UserID varchar(100),
	@User_Password varchar(100),
	@User_SystemID varchar(500),
	@User_Active tinyint,
	@User_ShowHints tinyint,
	@User_AutoAssign tinyint,
	@User_HourlyRate money,
	@User_HourlyCost money,
	@User_UserDefined1 varchar(250),
	@User_UserDefined2 varchar(250),
	@User_UserDefined3 varchar(250),
	@User_UserDefined4 varchar(250),
	@User_UserDefined5 varchar(250),
	@User_UserDefined6 varchar(250),
	@User_UserDefined7 varchar(250),
	@User_UserDefined8 varchar(250),
	@User_UserDefined9 varchar(250),
	@User_UserDefined10 varchar(250)
 )
AS --Encrypt

/*
|| When     Who Rel   What
|| 07/24/09 GHL 10.5  Removed update of tCompany address fields (they were removed)
*/

DECLARE @CompanyKey INT
        ,@UserKey    INT
	,@DefaultExpenseAccountKey int
	,@DefaultSalesAccountKey int
	,@SecurityGroupKey int 
	,@DepartmentKey int 
	,@PrimaryContactKey int
       
 -- Update/Insert Company
 IF @User_LastName IS NULL AND @CompanyName IS NULL
	return -1
 
IF @CompanyName IS NULL OR LTRIM(RTRIM(@CompanyName)) = ''
	select @CompanyName = @User_FirstName + ' ' + @User_LastName

   SELECT @CompanyKey = MIN(CompanyKey)
   FROM   tCompany (NOLOCK)
   WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
   --AND    UPPER(LTRIM(RTRIM(Address1))) = UPPER(LTRIM(RTRIM(@Address1)))
   AND    OwnerCompanyKey = @OwnerCompanyKey 
 
	IF @CompanyKey IS NULL
		SELECT @CompanyKey = MIN(CompanyKey)
		FROM   tCompany (NOLOCK)
		WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
		AND    OwnerCompanyKey = @OwnerCompanyKey


if not @DefaultExpenseAccount is null
	Select @DefaultExpenseAccountKey = GLAccountKey from tGLAccount (nolock)
	where CompanyKey = @OwnerCompanyKey and AccountNumber = @DefaultExpenseAccount

if not @DefaultSalesAccount is null
	Select @DefaultSalesAccountKey = GLAccountKey from tGLAccount (nolock)
	where CompanyKey = @OwnerCompanyKey and AccountNumber = @DefaultSalesAccount 
	
if @Active IS NULL
	Select @Active = 1
if @User_Active IS NULL
	Select @User_Active = 1

  IF @CompanyKey IS NULL
  BEGIN
	INSERT tCompany
		(
		CompanyName,
		VendorID,
		CustomerID,
		--Address1,
		--Address2,
		--Address3,
		--City,
		--State,
		--PostalCode,
		--Country,
		Vendor,
		BillableClient,
		DefaultExpenseAccountKey,
		DefaultSalesAccountKey,
		HourlyRate,
		--BAddress1,
		--BAddress2,
		--BAddress3,
		--BCity,
		--BState,
		--BPostalCode,
		--BCountry,
		WebSite,
		OwnerCompanyKey,
		Phone,
		Fax,
		Active,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10
		)

	VALUES
		(
		@CompanyName,
		@VendorID,
		@CustomerID,
		--@Address1,
		--@Address2,
		--@Address3,
		--@City,
		--@State,
		--@PostalCode,
		--@Country,
		@Vendor,
		@BillableClient,
		@DefaultExpenseAccountKey,
		@DefaultSalesAccountKey,
		@HourlyRate,
		--case when @BAddress1 is null then @Address1 else @BAddress1 end,
		--case when @BAddress2 is null then @BAddress2 else @BAddress2 end,
		--case when @BAddress3 is null then @BAddress3 else @BAddress3 end,
		--case when @BCity is null then @BCity else @BCity end,
		--case when @BState is null then @BState else @BState end,
		--case when @BPostalCode is null then @BPostalCode else @BPostalCode end,
		--case when @BCountry is null then @BCountry else @BCountry end,
		@WebSite,
		@OwnerCompanyKey,
		@Phone,
		@Fax,
		1,
		@UserDefined1,
		@UserDefined2,
		@UserDefined3,
		@UserDefined4,
		@UserDefined5,
		@UserDefined6,
		@UserDefined7,
		@UserDefined8,
		@UserDefined9,
		@UserDefined10
		)

   SELECT @CompanyKey = @@IDENTITY
  END
  ELSE
	UPDATE
		tCompany
	SET
		CompanyName = @CompanyName,
		VendorID = @VendorID,
		CustomerID = @CustomerID,
		--Address1 = @Address1,
		--Address2 = @Address2,
		--Address3 = @Address3,
		--City = @City,
		--State = @State,
		--PostalCode = @PostalCode,
		--Country = @Country,
		Vendor = @Vendor,
		BillableClient = @BillableClient,
		DefaultExpenseAccountKey = @DefaultExpenseAccountKey,
		DefaultSalesAccountKey = @DefaultSalesAccountKey,
		HourlyRate = @HourlyRate,
		--BAddress1 = @BAddress1,
		--BAddress2 = @BAddress2,
		--BAddress3 = @BAddress3,
		--BCity = @BCity,
		--BState = @BState,
		--BPostalCode = @BPostalCode,
		--BCountry = @BCountry,
		WebSite = @WebSite,
		Phone = @Phone,
		Fax = @Fax,
		Active = 1,
		UserDefined1 = @UserDefined1,
		UserDefined2 = @UserDefined2,
		UserDefined3 = @UserDefined3,
		UserDefined4 = @UserDefined4,
		UserDefined5 = @UserDefined5,
		UserDefined6 = @UserDefined6,
		UserDefined7 = @UserDefined7,
		UserDefined8 = @UserDefined8,
		UserDefined9 = @UserDefined9,
		UserDefined10 = @UserDefined10
	WHERE
		CompanyKey = @CompanyKey 
 
 -- Update/Insert User
 -- Could have same name in company, use phone #

IF NOT @User_LastName IS NULL
BEGIN

 IF @User_FirstName IS NULL
  SELECT @User_FirstName = ''
  
  SELECT @UserKey = UserKey
  FROM   tUser (NOLOCK)
  WHERE  CompanyKey      = @CompanyKey
  AND    OwnerCompanyKey = @OwnerCompanyKey 
  AND    FirstName       = @User_FirstName
  AND    LastName        = @User_LastName
  AND    Phone1     = @User_Phone1
  
 IF @UserKey IS NULL
  SELECT @UserKey = UserKey
  FROM   tUser (NOLOCK)
  WHERE  CompanyKey      = @CompanyKey
  AND    OwnerCompanyKey = @OwnerCompanyKey 
  AND    FirstName       = @User_FirstName
  AND    LastName        = @User_LastName

	if not @User_SecurityGroup is null
		select @SecurityGroupKey = SecurityGroupKey from tSecurityGroup (nolock)
		where CompanyKey = @OwnerCompanyKey and GroupName = @User_SecurityGroup

	if not @User_Department is null
		select @DepartmentKey = DepartmentKey from tDepartment (nolock)
		where CompanyKey = @OwnerCompanyKey and DepartmentName = @User_Department

	IF @UserKey IS NULL
	BEGIN
	
	
		INSERT tUser
			(
			OwnerCompanyKey,
			CompanyKey,
			FirstName,
			LastName,
			Salutation,
			DepartmentKey,
			Phone1,
			Phone2,
			Cell,
			Fax,
			Pager,
			Title,
			Email,
			SecurityGroupKey,
			Administrator,
			UserID,
			Password,
			SystemID,
			Active,
			--ShowHints,
			AutoAssign,
			HourlyRate,
			HourlyCost,
			UserDefined1,
			UserDefined2,
			UserDefined3,
			UserDefined4,
			UserDefined5,
			UserDefined6,
			UserDefined7,
			UserDefined8,
			UserDefined9,
			UserDefined10
			)
	
		VALUES
			(
			@OwnerCompanyKey,
			@CompanyKey,
			@User_FirstName,
			@User_LastName,
			@User_Salutation,
			@DepartmentKey,
			@User_Phone1,
			@User_Phone2,
			@User_Cell,
			@User_Fax,
			@User_Pager,
			@User_Title,
			@User_Email,
			@SecurityGroupKey,
			@User_Administrator,
			@User_UserID,
			@User_Password,
			@User_SystemID,
			1,
			--@User_ShowHints,
			@User_AutoAssign,
			@User_HourlyRate,
			@User_HourlyCost,
			@User_UserDefined1,
			@User_UserDefined2,
			@User_UserDefined3,
			@User_UserDefined4,
			@User_UserDefined5,
			@User_UserDefined6,
			@User_UserDefined7,
			@User_UserDefined8,
			@User_UserDefined9,
			@User_UserDefined10
			)
	
	 
	  	SELECT @UserKey = @@IDENTITY  -- Indicates new user
		SELECT @PrimaryContactKey = @@IDENTITY

  		if @User_Active = 1 and len(@User_UserID) > 0
			Insert tActivationLog
			(UserKey, DateActivated)
			Values (@UserKey, GETDATE())
	
	END
	ELSE
	BEGIN
		UPDATE
			tUser
		SET
			CompanyKey = @CompanyKey,
			FirstName = @User_FirstName,
			LastName = @User_LastName,
			Salutation = @User_Salutation,
			DepartmentKey = @DepartmentKey,
			Phone1 = @User_Phone1,
			Phone2 = @User_Phone2,
			Cell = @User_Cell,
			Fax = @User_Fax,
			Pager = @User_Pager,
			Title = @User_Title,
			Email = @User_Email,
			SecurityGroupKey = @SecurityGroupKey,
			Administrator = @User_Administrator,
			UserID = @User_UserID,
			Password = @User_Password,
			SystemID = @User_SystemID,
			Active = 1,
			--ShowHints = @User_ShowHints,
			AutoAssign = @User_AutoAssign,
			HourlyRate = @User_HourlyRate,
			HourlyCost = @User_HourlyCost,
			UserDefined1 = @User_UserDefined1,
			UserDefined2 = @User_UserDefined2,
			UserDefined3 = @User_UserDefined3,
			UserDefined4 = @User_UserDefined4,
			UserDefined5 = @User_UserDefined5,
			UserDefined6 = @User_UserDefined6,
			UserDefined7 = @User_UserDefined7,
			UserDefined8 = @User_UserDefined8,
			UserDefined9 = @User_UserDefined9,
			UserDefined10 = @User_UserDefined10
		WHERE
			UserKey = @UserKey 
	 
		SELECT @PrimaryContactKey = @UserKey
	
	
	if @PrimaryContact = 1
		Update tCompany
		Set PrimaryContact = @PrimaryContactKey
		Where CompanyKey = @CompanyKey
	
	return @UserKey
	END
end
ELSE
	return 13
GO
