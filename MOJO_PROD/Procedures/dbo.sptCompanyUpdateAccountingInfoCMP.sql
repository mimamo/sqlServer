USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateAccountingInfoCMP]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateAccountingInfoCMP]
 @CompanyKey int,
 @CustomerID varchar(50),
 @BillableClient tinyint,
 @VendorID varchar(50),
 @Vendor tinyint,
 @Address1 varchar(100),
 @Address2 varchar(100),
 @Address3 varchar(100),
 @City varchar(100),
 @State varchar(50),
 @PostalCode varchar(20),
 @Country varchar(50),
 @DefaultSalesAccountKey int,
 @DefaultExpenseAccountKey int,
 @DefaultAPAccountKey int,
 @GetRateFrom int,
 @TimeRateSheetKey int,
 @HourlyRate money,
 @GetMarkupFrom int,
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
 @AccountManagerKey int,
 @DefaultTeamKey int,
 @Type1099 smallint,
 @Box1099 varchar(10),
 @EINNumber varchar(30),
 @NextProjectNum int,
 @SalesTaxKey int,
 @SalesTax2Key int,
 @TermsPercent decimal(9,3),
 @TermsDays int,
 @TermsNet int,
 @InvoiceTemplateKey int,
 @EstimateTemplateKey int,
 @ClientDownloaded int,
 @OwnerCompanyKey int,
 @IOBillAt smallint,
 @BCBillAt smallint,
 @PaymentTermsKey int,
 @DefaultARLineFormat smallint,
 @DefaultMemo varchar(500),
 @DefaultRetainerKey int,
 @DefaultBillingMethod smallint,
 @OneInvoicePer smallint,
 @DefaultExpensesNotIncluded tinyint,
 @PaymentAddressKey int,
 @BillingAddressKey int,
 @OnHold tinyint,
 @Overhead tinyint,
 @GLCompanyKey int,
 @DBA varchar(200)
 
  
AS --Encrypt

/*
|| When     Who Rel      What
|| 07/21/09 GHL 10.5     Added to support CMP side
||                       Clone of 10.0 version
|| 11/4/09  CRG 10.5.1.3 (67238) Added DBA
*/

Declare @oIdentity int

	IF @BillableClient = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND
				BillableClient = 1 AND
				CustomerID = @CustomerID)
		RETURN -1
	END

	IF @Vendor = 1
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND
				Vendor = 1 AND
				VendorID = @VendorID)
		RETURN -2
	END

Declare @CurVendor tinyint, @CurClient tinyint

Select @CurVendor = Vendor, @CurClient = BillableClient from tCompany (nolock) Where CompanyKey = @CompanyKey

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


 UPDATE tCompany
 set
  
 CustomerID = @CustomerID
 ,BillableClient = @BillableClient
 ,VendorID = @VendorID
 ,Vendor = @Vendor
 ,DefaultSalesAccountKey = @DefaultSalesAccountKey
 ,DefaultExpenseAccountKey = @DefaultExpenseAccountKey
 ,DefaultAPAccountKey = @DefaultAPAccountKey
 ,GetRateFrom = @GetRateFrom
 ,TimeRateSheetKey = @TimeRateSheetKey
 ,GetMarkupFrom = @GetMarkupFrom
 ,HourlyRate = @HourlyRate
 ,ItemRateSheetKey = @ItemRateSheetKey 
 ,ItemMarkup = @ItemMarkup
 ,IOCommission = @IOCommission
 ,BCCommission = @BCCommission
 ,AccountManagerKey = @AccountManagerKey
 ,DefaultTeamKey = @DefaultTeamKey
 ,Type1099 = @Type1099
 ,Box1099 = @Box1099
 ,EINNumber = @EINNumber
 ,NextProjectNum = @NextProjectNum
 ,SalesTaxKey = @SalesTaxKey
 ,SalesTax2Key = @SalesTax2Key
 ,TermsPercent = @TermsPercent
 ,TermsDays = @TermsDays
 ,TermsNet = @TermsNet
 ,InvoiceTemplateKey = @InvoiceTemplateKey
 ,EstimateTemplateKey = @EstimateTemplateKey
 ,ClientDownloaded = @ClientDownloaded
 ,IOBillAt = @IOBillAt
 ,BCBillAt = @BCBillAt
 ,PaymentTermsKey = @PaymentTermsKey
 ,DefaultARLineFormat = @DefaultARLineFormat
 ,DefaultMemo = @DefaultMemo
 ,DefaultRetainerKey = @DefaultRetainerKey
 ,DefaultBillingMethod = @DefaultBillingMethod
 ,OneInvoicePer = @OneInvoicePer
 ,DefaultExpensesNotIncluded = @DefaultExpensesNotIncluded
 ,PaymentAddressKey = @PaymentAddressKey
 ,BillingAddressKey = @BillingAddressKey
 ,OnHold = @OnHold
 ,Overhead = @Overhead
 ,GLCompanyKey = @GLCompanyKey
 ,DBA = @DBA
 WHERE
  CompanyKey = @CompanyKey 



 RETURN 1
GO
