USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyInsert]
	@CompanyName varchar(200),
	@VendorID varchar(50),
	@CustomerID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@PrimaryContact int,
	@Vendor tinyint,
	@BillableClient tinyint,
	@DefaultExpenseAccountKey int,
	@DefaultSalesAccountKey int,
	@GetRateFrom smallint,
	@TimeRateSheetKey int,
	@HourlyRate money,
	@GetMarkupFrom smallint,
	@ItemRateSheetKey int,
	@ItemMarkup decimal(24,4),
	@IOCommission decimal(24,4),
	@BCCommission decimal(24,4),
	@BAddress1 varchar(100),
	@BAddress2 varchar(100),
	@BAddress3 varchar(100),
	@BCity varchar(100),
	@BState varchar(50),
	@BPostalCode varchar(20),
	@BCountry varchar(50),
	@WebSite varchar(100),
	@OwnerCompanyKey int,
	@Phone varchar(50),
	@Fax varchar(50),
	@Active tinyint,
	@Locked tinyint,
	@CustomFieldKey int,
	@AccountManagerKey int,
	@DefaultTeamKey int,	
	@Type1099 smallint,
	@Box1099 varchar(10),
	@EINNumber varchar(30),
	@CompanyTypeKey int,
	@ContactOwnerKey int,
	@Comments varchar(2000),
	@NextProjectNum int,
	@TermsPercent decimal(24,4),
	@TermsDays int,
	@TermsNet int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@InvoiceTemplateKey int,
	@EstimateTemplateKey int,
	@IOBillAt smallint,
	@BCBillAt smallint,
	@PaymentTermsKey int,
	@DefaultARLineFormat int,
	@DefaultBillingMethod smallint,
	@OneInvoicePer smallint,
	@DefaultExpensesNotIncluded tinyint,
	@DefaultAddressKey int,
	@BillingAddressKey int,
	@Overhead tinyint,
	@GLCompanyKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/16/09 QMD 10.5    Removed User Defined Fields
*/

DECLARE @InsertCompanyKey int, @InsertAddressKey int

	IF @BillableClient = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				OwnerCompanyKey = @OwnerCompanyKey AND
				BillableClient = 1 AND
				CustomerID = @CustomerID)
		RETURN -1
	END

	IF @Vendor = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				OwnerCompanyKey = @OwnerCompanyKey AND
				Vendor = 1 AND
				VendorID = @VendorID)
		RETURN -2
	END
	
 INSERT tCompany
  (
	CompanyName,
	VendorID,
	CustomerID,
	PrimaryContact,
	Vendor,
	BillableClient,
	DefaultExpenseAccountKey,
	DefaultSalesAccountKey,
	GetRateFrom,
	TimeRateSheetKey,
	HourlyRate,
	GetMarkupFrom,
	ItemRateSheetKey,
	ItemMarkup,
	IOCommission,
	BCCommission,
	WebSite,
	OwnerCompanyKey,
	Phone,
	Fax,
	Active,
	Locked,
	CustomFieldKey,
	AccountManagerKey,
	Type1099,
	Box1099,
	EINNumber,
	CompanyTypeKey,
	ContactOwnerKey,
	Comments,
	NextProjectNum,
	TermsPercent,
	TermsDays,
	TermsNet,
	SalesTaxKey,
	SalesTax2Key,
	InvoiceTemplateKey,
	EstimateTemplateKey,
	IOBillAt,
	BCBillAt,
	PaymentTermsKey,
	DefaultARLineFormat,
	DefaultTeamKey,
	DefaultBillingMethod,
	OneInvoicePer,
	DefaultExpensesNotIncluded,
	Overhead,
	GLCompanyKey
	)
	VALUES
	(
	@CompanyName,
	@VendorID,
	@CustomerID,
	@PrimaryContact,
	@Vendor,
	@BillableClient,
	@DefaultExpenseAccountKey,
	@DefaultSalesAccountKey,
	@GetRateFrom,
	@TimeRateSheetKey,
	@HourlyRate,
	@GetMarkupFrom,
	@ItemRateSheetKey,
	@ItemMarkup,
	@IOCommission,
	@BCCommission,
	@WebSite,
	@OwnerCompanyKey,
	@Phone,
	@Fax,
	@Active,
	@Locked,
	@CustomFieldKey,
	@AccountManagerKey,
	@Type1099,
	@Box1099,
	@EINNumber,
	@CompanyTypeKey,
	@ContactOwnerKey,
	@Comments,
	@NextProjectNum,
	@TermsPercent,
	@TermsDays,
	@TermsNet,
	@SalesTaxKey,
	@SalesTax2Key,
	@InvoiceTemplateKey,
	@EstimateTemplateKey,
	@IOBillAt,
	@BCBillAt,
	@PaymentTermsKey,
	@DefaultARLineFormat,
	@DefaultTeamKey,
	@DefaultBillingMethod,
	@OneInvoicePer,
	@DefaultExpensesNotIncluded,
	@Overhead,
	@GLCompanyKey
  )
 
 SELECT @oIdentity = @@IDENTITY
 SELECT @InsertCompanyKey = @@IDENTITY

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
	
	SELECT @InsertAddressKey = @@IDENTITY
	Update tCompany
	Set DefaultAddressKey = @InsertAddressKey
	Where CompanyKey = @InsertCompanyKey
end


 RETURN 1
GO
