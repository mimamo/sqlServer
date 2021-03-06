USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMultiInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMultiInsert]
	@CompanyKey int,
	@CompanyName varchar(200),
	@ContactOwnerKey int,
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@Phone varchar(20),
	@Fax varchar(20),
	@FirstName varchar(100),
	@LastName varchar(100),
	@Email varchar(100),
	@Subject varchar(200),
	@LeadStatusKey int,
	@LeadStageKey int,
	@StartDate smalldatetime,
	@Probability int,
	@SaleAmount money,
	@ActivitySubject varchar(200),
	@ActivityDate smalldatetime,
	@Status smallint,
	@Notes varchar(4000),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/16/09 QMD 10.5    Removed User Defined Fields
*/

Declare @InsertCompanyKey int, @InsertAddressKey int
Declare @InsertUserKey int
Declare @InsertLeadKey int, @PaymentTermsKey int
Declare @GetRateFrom smallint, @TimeRateSheetKey int, @HourlyRate money, @GetMarkupFrom smallint, 
		@ItemRateSheetKey int, @ItemMarkup decimal(24,4), @IOCommission decimal(24,4), 
		@BCCommission decimal(24,4), @DefaultARLineFormat smallint

	Select
		@GetRateFrom = GetRateFrom,
		@TimeRateSheetKey = TimeRateSheetKey,
		@HourlyRate = HourlyRate,
		@GetMarkupFrom = GetMarkupFrom,
		@ItemRateSheetKey = ItemRateSheetKey,
		@ItemMarkup = ItemMarkup,
		@IOCommission = IOCommission,
		@BCCommission = BCCommission,
		@PaymentTermsKey = PaymentTermsKey,
		@DefaultARLineFormat = DefaultARLineFormat
	From 
		tPreference (nolock)
	Where CompanyKey = @CompanyKey

	INSERT tCompany
		(
		CompanyName,
		OwnerCompanyKey,
		ContactOwnerKey,
		Phone,
		Fax,
		Active,
		GetRateFrom,
		TimeRateSheetKey,
		HourlyRate,
		GetMarkupFrom,
		ItemRateSheetKey,
		ItemMarkup,
		IOCommission,
		BCCommission,
		PaymentTermsKey,
		DefaultARLineFormat
		
		)

	VALUES
		(
		@CompanyName,
		@CompanyKey,
		@ContactOwnerKey,
		@Phone,
		@Fax,
		1,
		@GetRateFrom,
		@TimeRateSheetKey,
		@HourlyRate,
		@GetMarkupFrom,
		@ItemRateSheetKey,
		@ItemMarkup,
		@IOCommission,
		@BCCommission,
		@PaymentTermsKey,
		@DefaultARLineFormat
		)
	
	SELECT @InsertCompanyKey = @@IDENTITY
	SELECT @oIdentity = @InsertCompanyKey


if not @FirstName is null and not @LastName is null
Begin
	Insert tUser
	(
	CompanyKey,
	OwnerCompanyKey,
	FirstName,
	LastName,
	Phone1,
	Email,
	Active,
	ClientVendorLogin
	)
	Values
	(
	@InsertCompanyKey,
	@CompanyKey,
	@FirstName,
	@LastName,
	@Phone,
	@Email,
	1,
	1
	)
	
	Select @InsertUserKey = @@IDENTITY
	
	Update tCompany
	Set PrimaryContact = @InsertUserKey
	Where CompanyKey = @InsertCompanyKey
end

if not @Subject is null
begin
	Insert tLead
	(
	CompanyKey,
	Subject,
	ContactCompanyKey,
	ContactKey,
	AccountManagerKey,
	LeadStatusKey,
	LeadStageKey,
	Probability,
	SaleAmount,
	StartDate
	)
	Values
	(
	@CompanyKey,
	@Subject,
	@InsertCompanyKey,
	@InsertUserKey,
	@ContactOwnerKey,
	@LeadStatusKey,
	@LeadStageKey,
	@Probability,
	@SaleAmount,
	@StartDate
	)
	
	Select @InsertLeadKey = @@IDENTITY
end

If not @ActivitySubject is null
begin
	Insert tContactActivity
	(
	CompanyKey,
	Type,
	Subject,
	ContactCompanyKey,
	ContactKey,
	AssignedUserKey,
	Status,
	ActivityDate,
	LeadKey,
	Notes
	)
	values
	(
	@CompanyKey,
	'Call',
	@ActivitySubject,
	@InsertCompanyKey,
	@InsertUserKey,
	@ContactOwnerKey,
	@Status,
	@ActivityDate,
	@InsertLeadKey,
	@Notes
	)
	
end

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
		@CompanyKey,
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
	
	SELECT @InsertAddressKey = @@IDENTITY
	Update tCompany
	Set DefaultAddressKey = @InsertAddressKey
	Where CompanyKey = @InsertCompanyKey
end

return 1
GO
