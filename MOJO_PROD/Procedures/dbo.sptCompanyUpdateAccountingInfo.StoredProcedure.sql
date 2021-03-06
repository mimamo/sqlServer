USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateAccountingInfo]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateAccountingInfo]
 @CompanyKey int,
 @OwnerCompanyKey int,
 @ParentCompanyKey int,
 @ParentCompanyDivisionKey int,
 @ParentCompany tinyint,
 @CustomerID varchar(50),  
 @BillableClient tinyint,
 @VendorID varchar(50),
 @Vendor tinyint,
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
 @DefaultTeamKey int,
 @Type1099 smallint,
 @Box1099 varchar(10),
 @EINNumber varchar(100),
 @NextProjectNum int,
 @NextCampaignNum int,
 @SalesTaxKey int,
 @SalesTax2Key int,
 @VendorSalesTaxKey int,
 @VendorSalesTax2Key int,
 @TermsPercent decimal(9,3),
 @TermsDays int,
 @TermsNet int,
 @InvoiceTemplateKey int,
 @EstimateTemplateKey int,
 @ClientDownloaded int,
 @VendorDownloaded int,
 @IOBillAt smallint,
 @BCBillAt smallint,
 @PaymentTermsKey int,
 @DefaultARLineFormat smallint,
 @DefaultMemo varchar(500),
 @DefaultRetainerKey int,
 @DefaultBillingMethod smallint,
 @OneInvoicePer smallint,
 @DefaultExpensesNotIncluded tinyint,
 @OnHold tinyint,
 @Overhead tinyint,
 @OverheadVendor tinyint,
 @GLCompanyKey int,
 @OfficeKey int,
 @DBA varchar(200),
 @LayoutKey int,
 @CCPayeeName varchar(100) = null,
 @DefaultAPApproverKey int = null,
 @BillingName varchar(200) = null,
 @CCAccepted tinyint,
 @AlternatePayerKey int,
 @UseDBAForPayment tinyint,
 @OnePaymentPerVoucher tinyint,
 @BillingManagerKey int,
 @BillingBase smallint,
 @BillingAdjPercent decimal(24,4),
 @BillingAdjBase smallint,
 @CurrencyID varchar(10) = null,
 @BillingEmailContact int,
 @TitleRateSheetKey int,
 @EmailCCToAddress varchar(200),
 @CCAccountKey int,
 @LockLaborRate tinyint,
 @LockMarkupFrom tinyint,
 @BankAccountNumber varchar(500),
 @BankAccountName varchar(500),
 @BankRoutingNumber varchar(100),
 @AllTrackBudgetTasksOnInvoice tinyint 
 
AS --Encrypt

  /*
  || When     Who  Rel      What
  || 02/22/09 GWG  10.5     Null other companies parent company if this gets set to 0 for parent company
  || 11/4/09  CRG  10.5.1.3 (67238) Added @DBA
  || 11/16/09 GWG  10.5.1.3 Modified the vendor and customer id checks to check for dupes regardless of the is a vendor/client boxes and search everyone. 
  || 1/5/10   GWG  10.5.1.6 Added LayoutKey for layout changes. 
  || 05/13/10 RLB  10.5.2.2 (75879) Removed check for vendors and Clients with PO's, Vouchers etc...
  || 01/21/11 RLB  10.5.4.2 (100772) Addeding Vendor Sales Taxs
  || 03/02/11 GHL  10.5.4.2 (103729) Added NextCampaignNumber for enhancement
  || 09/01/11 RLB  10.5.4.7 (120193) Added OfficeKey for Project Client Defaulting
  || 03/30/12 MAS  10.5.5.4 Added CCPayeeName
  || 05/11/12 GHL  10.5.5.6 (142898) Added DefaultAPApproverKey so that we can override tPreference.DefaultAPApproverKey
  || 07/10/12 GHL  10.5.5.8 (148528) Added OverheadVendor. If 1 set tVoucher.Overhead = 1 on new vouchers and CC charges 
  || 07/10/12 GHL  10.5.5.8 (148091) Added @BillingName for estimates and invoices 
  || 08/03/12 KMC  10.5.5.8 (146259) Added @CCAccepted to capture if the vendor accepts credit card payments
  || 09/10/12 MFT  10.5.5.0 Added @ParentCompanyDivisionKey, @AlternatePayerKey
  || 09/21/12 KMC  10.5.6.0 (133301) Added @UseDBAForPayment update
  || 10/03/12 GHL  10.5.6.0 Added @OnePaymentPerVoucher for a HMI request
  || 05/03/13 MFT  10.5.6.7 Added @BillingManagerKey
  || 08/08/13 CRG  10.5.7.0 Added @BillingBase, @BillingAdjPercent, @BillingAdjBase
  || 08/16/13 MFT  10.5.7.1 Increased @EINNumber from 30 to 100 chars
  || 09/11/13 GHL  10.5.7.2 Added currency ID
  || 03/25/14 WDF  10.5.7.8 (210499) Added BillingMethod check for RetainerKey
  || 07/23/14 GHL  10.5.8.2 (222235) Added @BillingEmailContact param for enhancement for Benefitz
  ||                        Client invoices and statements are emailed/sent to that new contact 
  || 09/25/14 MAS  10.5.8.4 Abelson & Taylor added @TitleRateSheetKey
  || 10/06/14 CRG  10.5.8.5 Added EmailCCToAddress and CCAccountKey
  || 10/06/14 RLB  10.5.8.6 Added LockLaborRate and LockMarkupFrom for Abelson Taylor
  || 03/12/15 GHL  10.5.9.1 (241695) Added @BankAccountNumber, @BankAccountName, @BankAccountNumber for Spark44 enh
  ||                        These 2 fields are used in BACS transfers
  || 03/13/15 GHL  10.5.9.1 (241695) Increased bank account info to 500 chars because they are encrypted
  || 03/20/15 GHL  10.5.9.1 (238426) added @AllTrackBudgetTasksOnInvoice for enhancement for YRG
  */
  
Declare @oIdentity int

	IF @CustomerID is not null
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND
				CustomerID = @CustomerID)
		RETURN -1
	END

	IF @VendorID is not null
	BEGIN
		IF EXISTS(SELECT 1 FROM tCompany (nolock) WHERE 
				CompanyKey <> @CompanyKey AND 
				OwnerCompanyKey = @OwnerCompanyKey AND
				VendorID = @VendorID)
		RETURN -2
	END

Declare @CurVendor tinyint, @CurClient tinyint, @CurParentComp tinyint, @CurCurrencyID varchar(10)

Select @CurVendor = Vendor
	, @CurClient = BillableClient
	, @CurParentComp = ParentCompany 
	, @CurCurrencyID = CurrencyID
from tCompany (nolock) 
Where CompanyKey = @CompanyKey

/*
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

-- Do we need some checks here?
if isnull(@CurCurrencyID, '') <> isnull(@CurrencyID, '')
begin
	if exists(Select 1 from tProject (nolock) Where ClientKey = @CompanyKey)
		return -100
	
end 

*/
 
Declare @CurOverhead tinyint
Select @CurOverhead = ISNULL(Overhead, 0) from tCompany Where CompanyKey = @CompanyKey

if @CurOverhead <> @Overhead
BEGIN
	Update tTransaction Set Overhead = @Overhead Where ClientKey = @CompanyKey
END

if @CurParentComp = 1 and @ParentCompany = 0
	Update tCompany Set ParentCompanyKey = NULL Where ParentCompanyKey = @CompanyKey


 UPDATE tCompany
 set
  
  CustomerID = @CustomerID
 ,BillableClient = @BillableClient
 ,VendorID = @VendorID
 ,Vendor = @Vendor
 ,ParentCompanyKey = @ParentCompanyKey
 ,ParentCompanyDivisionKey = @ParentCompanyDivisionKey
 ,ParentCompany = @ParentCompany
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
 ,DefaultTeamKey = @DefaultTeamKey
 ,Type1099 = @Type1099
 ,Box1099 = @Box1099
 ,EINNumber = @EINNumber
 ,NextProjectNum = @NextProjectNum
 ,NextCampaignNum = @NextCampaignNum
 ,SalesTaxKey = @SalesTaxKey
 ,SalesTax2Key = @SalesTax2Key
 ,VendorSalesTaxKey = @VendorSalesTaxKey
 ,VendorSalesTax2Key = @VendorSalesTax2Key
 ,TermsPercent = @TermsPercent
 ,TermsDays = @TermsDays
 ,TermsNet = @TermsNet
 ,InvoiceTemplateKey = @InvoiceTemplateKey
 ,EstimateTemplateKey = @EstimateTemplateKey
 ,ClientDownloaded = @ClientDownloaded
 ,VendorDownloaded = @VendorDownloaded
 ,IOBillAt = @IOBillAt
 ,BCBillAt = @BCBillAt
 ,PaymentTermsKey = @PaymentTermsKey
 ,DefaultARLineFormat = @DefaultARLineFormat
 ,DefaultMemo = @DefaultMemo
 ,DefaultRetainerKey = CASE WHEN @DefaultBillingMethod = 3 THEN @DefaultRetainerKey ELSE NULL END
 ,DefaultBillingMethod = @DefaultBillingMethod
 ,OneInvoicePer = @OneInvoicePer
 ,DefaultExpensesNotIncluded = @DefaultExpensesNotIncluded
 ,OnHold = @OnHold
 ,Overhead = @Overhead
 ,OverheadVendor = @OverheadVendor
 ,GLCompanyKey = @GLCompanyKey
 ,OfficeKey = @OfficeKey
 ,DBA = @DBA
 ,LayoutKey = @LayoutKey
 ,CCPayeeName = @CCPayeeName
 ,DefaultAPApproverKey = @DefaultAPApproverKey
 ,BillingName = @BillingName
 ,CCAccepted = @CCAccepted
 ,AlternatePayerKey = @AlternatePayerKey
 ,UseDBAForPayment = @UseDBAForPayment
 ,OnePaymentPerVoucher = @OnePaymentPerVoucher
 ,BillingManagerKey = @BillingManagerKey
 ,BillingBase = @BillingBase
 ,BillingAdjPercent = @BillingAdjPercent
 ,BillingAdjBase = @BillingAdjBase
 ,CurrencyID = @CurrencyID
 ,BillingEmailContact = @BillingEmailContact 
 ,TitleRateSheetKey = @TitleRateSheetKey
 ,EmailCCToAddress = @EmailCCToAddress
 ,CCAccountKey = @CCAccountKey
 ,LockLaborRate = @LockLaborRate
 ,LockMarkupFrom = @LockMarkupFrom
 ,BankAccountNumber = @BankAccountNumber 
 ,BankAccountName = @BankAccountName 
 ,BankRoutingNumber = @BankRoutingNumber 
 ,AllTrackBudgetTasksOnInvoice = @AllTrackBudgetTasksOnInvoice
 WHERE
  CompanyKey = @CompanyKey 

 RETURN 1
GO
