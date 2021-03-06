USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateClient]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateClient]
	@CompanyKey int,
	@OwnerCompanyKey int,
	@CompanyName varchar(200),
	@CustomerID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@PrimaryContact int,
	@BillableClient tinyint,
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
	@Phone varchar(50),
	@Fax varchar(50),
	@Active tinyint,
	@AccountManagerKey int,
	@DefaultTeamKey int,
	@CompanyTypeKey int,
	@Comments varchar(2000),
	@NextProjectNum int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@InvoiceTemplateKey int,
	@EstimateTemplateKey int,
	@IOBillAt smallint,
	@BCBillAt smallint,
	@PaymentTermsKey int,
	@DefaultARLineFormat int,
	@DefaultRetainerKey int,
	@DefaultBillingMethod smallint,
	@OneInvoicePer smallint,
	@DefaultExpensesNotIncluded tinyint,
	@AddressName varchar(200),
	@DefaultAddressKey int,
	@BillingAddressKey int,
	@Overhead tinyint,
	@GLCompanyKey int
	
AS --Encrypt

	IF @BillableClient = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND
				BillableClient = 1 AND
				CustomerID = @CustomerID)
		RETURN -1
	END
	
Declare @CurVendor tinyint, @CurClient tinyint, @InsertAddressKey int

Select @CurVendor = Vendor, @CurClient = BillableClient from tCompany (nolock) Where CompanyKey = @CompanyKey

if @CurClient = 1 and @BillableClient = 0
begin
	if exists(Select 1 from tProject (nolock) Where ClientKey = @CompanyKey)
		return -100
	if exists(Select 1 from tInvoice (nolock) Where ClientKey = @CompanyKey)
		return -101
	if exists(Select 1 from tCheck (nolock) Where ClientKey = @CompanyKey)
		return -102
		
end

Declare @CurOverhead tinyint
Select @CurOverhead = ISNULL(Overhead, 0) from tCompany Where CompanyKey = @CompanyKey

if @CurOverhead <> @Overhead
BEGIN
	Update tTransaction Set Overhead = @Overhead Where ClientKey = @CompanyKey
END

 UPDATE
  tCompany
 SET
	CompanyName = @CompanyName,
	CustomerID = @CustomerID,
	PrimaryContact = @PrimaryContact,
	BillableClient = @BillableClient,
	DefaultSalesAccountKey = @DefaultSalesAccountKey,
	SalesTaxKey = @SalesTaxKey,
	SalesTax2Key = @SalesTax2Key,
	InvoiceTemplateKey = @InvoiceTemplateKey,
	EstimateTemplateKey = @EstimateTemplateKey,
	GetRateFrom = @GetRateFrom,
	TimeRateSheetKey = @TimeRateSheetKey,
	HourlyRate = @HourlyRate,
	GetMarkupFrom = @GetMarkupFrom,
	ItemRateSheetKey = @ItemRateSheetKey,
	ItemMarkup = @ItemMarkup,
	IOCommission = @IOCommission,
	BCCommission = @BCCommission,
    WebSite = @WebSite,
	Phone = @Phone,
	Fax = @Fax,
	Active = @Active,
	AccountManagerKey = @AccountManagerKey,
	CompanyTypeKey = @CompanyTypeKey,
	Comments = @Comments,
	NextProjectNum = @NextProjectNum,
	DateUpdated = GETDATE(),
	IOBillAt = @IOBillAt,
	BCBillAt = @BCBillAt,
	PaymentTermsKey = @PaymentTermsKey,
	DefaultARLineFormat = @DefaultARLineFormat,
	DefaultTeamKey = @DefaultTeamKey,
	DefaultRetainerKey = @DefaultRetainerKey,
	DefaultBillingMethod = @DefaultBillingMethod,
	OneInvoicePer = @OneInvoicePer,
	DefaultExpensesNotIncluded = @DefaultExpensesNotIncluded,
	DefaultAddressKey = @DefaultAddressKey,
	BillingAddressKey = @BillingAddressKey,
	Overhead = @Overhead,
	GLCompanyKey = @GLCompanyKey
 WHERE
  CompanyKey = @CompanyKey 

if @AddressName is not null
begin
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

		SELECT @InsertAddressKey = @@IDENTITY
			Update tCompany
			Set DefaultAddressKey = @InsertAddressKey
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
end

 RETURN 1
GO
