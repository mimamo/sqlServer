USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanySetup]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCompanySetup]
 --company info
 @CompanyName varchar(200),
 @Address1 varchar(100),
 @Address2 varchar(100),
 @Address3 varchar(100),
 @City varchar(100),
 @State varchar(50),
 @PostalCode varchar(20),
 @Country varchar(50),
 @WebSite varchar(100),
 @Phone varchar(20),
 @Fax varchar(20),
 @AffiliateID varchar(50),
 @FirstName varchar(100),
 @LastName varchar(100),
 @Email varchar(100),
 @UserID varchar(100),
 @Password varchar(100),
 @ProductVersion varchar(50),
 @TimeZoneIndex int = 35
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/17/09   GWG 105      Added the option to remove tasks from timesheets.
|| 5/15/10   GWG 10.523   Added defaulting of labs on.
|| 2/9/11    CRG 10.5.4.1 (102366) Added @TimeZoneIndex
*/

declare @CompanyKey int
declare @URL varchar(100)
declare @DefStylesheet int
declare @AffiliateKey int, @AddressKey int


if len(@AffiliateID) > 0
BEGIN
 select @AffiliateKey = AffiliateKey
   from tAffiliate (nolock)
  where upper(@AffiliateID) = upper(AffiliateID)
       and Active = 1

	if ISNULL(@AffiliateKey, 0) = 0
		return -1
END

If exists(Select 1 from tUser (nolock) Where UPPER(UserID) = UPPER(@UserID))
	return -2


 if ISNULL(@AffiliateKey, 0) > 0
   begin
  select @URL = WebsiteURL
        ,@DefStylesheet = Stylesheet
    from tAffiliate (nolock)
   where AffiliateKey = @AffiliateKey

   end
 else
   begin

  select @DefStylesheet = 5
   end   
   
 begin transaction
 --Company Info
 insert tCompany
  (
  CompanyName,
  WebSite,
  Phone,
  Fax,
  Active,
  Locked
  )
 values
  (
  @CompanyName,
  @URL,
  @Phone,
  @Fax,
  1,
  0
  )
  
 if @@ERROR <> 0 
   begin
  rollback transaction 
  return -1
   end
    
 select @CompanyKey = @@IDENTITY
 
 Insert tAddress
 (
	OwnerCompanyKey,
	CompanyKey,
	AddressName,
	Address1,
	Address2,
	Address3,
	City,
	State,
	PostalCode,
	Country,
	Active
 )
 Values
 (
	@CompanyKey,
	@CompanyKey,
	'(Default)',
	@Address1,
	@Address2,
	@Address3,
	@City,
	@State,
	@PostalCode,
	@Country,
	1
)

Select @AddressKey = @@Identity

Update tCompany Set DefaultAddressKey = @AddressKey Where CompanyKey = @CompanyKey
 
 --Company Preferences
 insert tPreference
  (
  CompanyKey,
  AffiliateKey,
  DateJoined,
  ProductVersion,
  UsingWebDav
  )
 values
  (
  @CompanyKey,
  @AffiliateKey,
  GETDATE(),
  @ProductVersion,
  1
)
 
 if @@ERROR <> 0
   begin
  rollback transaction 
  return -2
   end
   
 
 --Company Time Options
 insert tTimeOption
  (
  CompanyKey,
  ShowServicesOnGrid,
  ReqProjectOnTime,
  ReqServiceOnTime,
  TimeSheetPeriod,
  StartTimeOn
  )
 values
  (
  @CompanyKey,
  1,
  1,
  1,
  1,
  1
  )
 
 if @@ERROR <> 0 
   begin
  rollback transaction 
  return -3
   end
    
 --User
	insert tUser
	(
		CompanyKey,
		FirstName,
		LastName,
		Phone1,
		Fax,
		Email,
		Administrator,
		UserID,
		Password,
		LastLogin,
		Active,
		AutoAssign,
		TimeZoneIndex
	)
	values
	(
		@CompanyKey,
		@FirstName,
		@LastName,
		@Phone,
		@Fax,
		@Email,
		1,
		@UserID,
		@Password,
		GETDATE(),
		1,
		0,
		@TimeZoneIndex
	)

	Insert tActivationLog
	(UserKey, DateActivated)
	Values (@@IDENTITY, GETDATE())
 
 if @@ERROR <> 0 
   begin
  rollback transaction 
  return -4
   end  
 
 
 	INSERT	tLabCompany (LabKey, CompanyKey)
	SELECT	LabKey, @CompanyKey
	FROM	tLab (nolock)
	WHERE	Beta = 0
 
 
 
 commit transaction  
 
 return 1
GO
