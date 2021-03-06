USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUpdateCompanyVendor]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptUpdateCompanyVendor]

@CompanyKey int,
@CompanyName varchar(200),
@Address1 varchar(100),
@Address2 varchar(100),
@Address3 varchar(100),
@City varchar(100),
@State varchar(50),
@PostalCode varchar(20),
@Country varchar(50),
@Type1099 smallint,
@Box1099 varchar(10),
@Phone varchar(50),
@Fax varchar(50),
@Active tinyint,
@CompanyTypeKey int,
@Vendor tinyint,
@VendorID varchar(50),
@DefaultExpenseAccountKey int,
@DefaultAPAccountKey int,
@PrimaryContact int,
@TermsPercent decimal(24,4),
@TermsNet int,
@TermsDays int,
@Comments varchar(2000),
@WebSite varchar(100),
@EINNumber varchar(30),
@OwnerCompanyKey int,
@DefaultMemo varchar(500),
@DefaultAddressKey int,
@PaymentAddressKey int,
@AddressName varchar(200),
@OnHold tinyint,
@DBA varchar(200)

AS  --Encrypt

/*
|| When      Who Rel      What
|| 11/4/09   CRG 10.5.1.3 (67238) Added DBA
*/

	IF @Vendor = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (NOLOCK) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND 
				Vendor = 1 AND
				VendorID = @VendorID)
		RETURN -2
	END

Declare @CurVendor tinyint, @oIdentity int

Select @CurVendor = Vendor  from tCompany (NOLOCK) Where CompanyKey = @CompanyKey
	
	
if @CurVendor = 1 and @Vendor = 0
begin
	if exists(Select 1 from tPurchaseOrder (nolock) Where VendorKey = @CompanyKey)
		return -10
	if exists(Select 1 from tVoucher (nolock) Where VendorKey = @CompanyKey)
		return -11
	if exists(Select 1 from tPayment (nolock) Where VendorKey = @CompanyKey)
		return -12
	if exists(Select 1 from tQuoteReply (nolock) Where VendorKey = @CompanyKey)
		return -13
	if exists(Select 1 from tUser (nolock) Where VendorKey = @CompanyKey)
		return -14

end

UPDATE tCompany 
SET 
	CompanyName = @CompanyName,
	Type1099 = @Type1099,
	Box1099 = @Box1099,
	Phone = @Phone,
	Fax = @Fax,
	Active = @Active,
	CompanyTypeKey = @CompanyTypeKey,
	Comments = @Comments,
	Vendor = @Vendor,
	VendorID = @VendorID,	
	DefaultExpenseAccountKey = @DefaultExpenseAccountKey,
	DefaultAPAccountKey = @DefaultAPAccountKey,
	PrimaryContact = @PrimaryContact,
	TermsPercent = @TermsPercent,
	TermsDays = @TermsDays,
	TermsNet = @TermsNet,
	WebSite = @WebSite,
	DateUpdated = GETDATE(),
	EINNumber = @EINNumber,
	DefaultMemo = @DefaultMemo
	,DefaultAddressKey = @DefaultAddressKey
	,PaymentAddressKey = @PaymentAddressKey
	,OnHold = @OnHold
	,DBA = @DBA
WHERE  CompanyKey = @CompanyKey


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
