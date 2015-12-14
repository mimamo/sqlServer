USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCompanyInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCompanyInsert]
	@CompanyName varchar(200),
	@OwnerCompanyKey int,
	@VendorID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(100),
	@PrimaryContact int,
	@Vendor tinyint,
	@DefaultExpenseAccountKey int,
	@DefaultAPAccountKey int,
	@WebSite varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@Active tinyint,
	@Type1099 smallint,
	@Box1099 varchar(10),
	@EINNumber varchar(30),
	@CompanyTypeKey int,
	@ContactOwnerKey int,
	@Comments varchar(2000),
	@TermsPercent decimal(24,4),
	@TermsDays int,
	@TermsNet int,
	@DefaultMemo varchar(500),
	@OnHold tinyint,
	@DBA varchar(200),
	@oIdentity INT OUTPUT
AS --Encrypt

IF EXISTS(SELECT 1 FROM tCompany (NOLOCK) WHERE 
		OwnerCompanyKey = @OwnerCompanyKey AND
		Vendor = 1 AND
		VendorID = @VendorID)
RETURN -1

/*
|| When      Who Rel      What
|| 11/4/09   CRG 10.5.1.3 (67238) Added DBA
*/

Declare @InsertCompanyKey int, @NewAddressKey int

 INSERT tCompany
  (
	CompanyName,
	OwnerCompanyKey,
	VendorID,
	PrimaryContact,
	Vendor,
	DefaultExpenseAccountKey,
	DefaultAPAccountKey,
	WebSite,
	Phone,
	Fax,
	Active,
	Type1099,
	Box1099,
	EINNumber,
	CompanyTypeKey,
	ContactOwnerKey,
	Comments,
	TermsPercent,
	TermsDays,
	TermsNet,
	DefaultMemo,
	OnHold,
	DBA
	)
	VALUES
	(
	@CompanyName,
	@OwnerCompanyKey,
	@VendorID,
	@PrimaryContact,
	@Vendor,
	@DefaultExpenseAccountKey,
	@DefaultAPAccountKey,
	@WebSite,
	@Phone,
	@Fax,
	@Active,
	@Type1099,
	@Box1099,
	@EINNumber,
	@CompanyTypeKey,
	@ContactOwnerKey,
	@Comments,
	@TermsPercent,
	@TermsDays,
	@TermsNet,
	@DefaultMemo,
	@OnHold,
	@DBA
  )
 
 SELECT @oIdentity = @@IDENTITY
 SELECT @InsertCompanyKey = @oIdentity

	if not @Address1 is null 
	or not @Address2 is null 
	or not @Address3 is null 
	or not @City is null 
	or not @State is null 
	or not @PostalCode is null 
	or not @Country is null
begin
INSERT tAddress
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

	VALUES
		(
		@OwnerCompanyKey,		
		@InsertCompanyKey,
		'Default',
		@Address1,
		@Address2,
		@Address3,
		@City,
		@State,
		@PostalCode,
		@Country,
		1
		)
	
	SELECT @NewAddressKey = @@IDENTITY
	Update tCompany
	Set DefaultAddressKey = @NewAddressKey
	Where CompanyKey = @oIdentity
end

 RETURN 1
GO
