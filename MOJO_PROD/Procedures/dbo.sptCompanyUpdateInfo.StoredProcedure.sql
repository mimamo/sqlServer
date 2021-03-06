USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateInfo]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateInfo]
	@CompanyKey int,
	@CompanyName varchar(200),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(100),
	@PrimaryContact int,
	@WebSite varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@Active tinyint,
	@CompanyTypeKey int,
	@Comments varchar(2000),
	@ParentCompany tinyint,
	@ParentCompanyKey int,
	@ContactOwnerKey int,
	@DefaultAddressKey int,
	@AddressName varchar(200)
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/16/09 QMD 10.5    Removed User Defined Fields
*/

Declare @CurParent tinyint, @CurParentKey int,@OwnerCompanyKey int, @oIdentity int

if @ParentCompany = 1
	Select @ParentCompanyKey = NULL
	
if @ParentCompanyKey is not null
	if not exists(Select 1 from tCompany (nolock) Where ParentCompany = 1 and CompanyKey = @ParentCompanyKey)
		Return -1
		
if @ParentCompany = 0
	if exists(Select 1 from tCompany (nolock) Where ParentCompanyKey = @CompanyKey)
		Return -2	


 UPDATE
  tCompany
 SET
	CompanyName = @CompanyName
	,PrimaryContact = @PrimaryContact
	,WebSite = @WebSite
	,Phone = @Phone
	,Fax = @Fax
	,Active = @Active
	,CompanyTypeKey = @CompanyTypeKey
	,Comments = @Comments
	,ParentCompany = @ParentCompany
	,ParentCompanyKey = @ParentCompanyKey
	,DateUpdated = GETDATE()
	,ContactOwnerKey = @ContactOwnerKey
	,DefaultAddressKey = @DefaultAddressKey
	
 WHERE
  CompanyKey = @CompanyKey 


SELECT @OwnerCompanyKey = OwnerCompanyKey from tCompany (nolock)
where CompanyKey = @CompanyKey

if @AddressName is not null
BEGIN
	if @DefaultAddressKey = -1 
	begin
	INSERT 
		tAddress
		(
		OwnerCompanyKey
		,CompanyKey
		,AddressName
		,Address1
		,Address2
		,Address3
		,City
		,State
		,PostalCode
		,Country
		)
	VALUES
		(
		@OwnerCompanyKey,
		@CompanyKey,
		@AddressName,
		@Address1,
		@Address2,
		@Address3,
		@City,
		@State,
		@PostalCode,
		@Country
		)

	SELECT @oIdentity = @@IDENTITY
		Update tCompany
		Set DefaultAddressKey = @oIdentity
		Where CompanyKey = @CompanyKey
	end
	else
	begin
	UPDATE
		tAddress
	SET
		AddressName = @AddressName
		,Address1 = @Address1
		,Address2 = @Address2
		,Address3 = @Address3
		,City = @City
		,State = @State
		,PostalCode = @PostalCode
		,Country = @Country
	WHERE
	CompanyKey = @CompanyKey 
	AND
	AddressKey = @DefaultAddressKey
	end
END

 RETURN 1
GO
