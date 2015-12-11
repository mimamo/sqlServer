USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Contact]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vExport_Contact]
AS
SELECT 
	tCompany.CompanyKey,
	tCompany.CompanyName,
	tCompany.VendorID,
	tCompany.CustomerID,
	tCompany.LinkID,
	tCompany.PrimaryContact,
	tCompany.Vendor,
	tCompany.BillableClient,
	tCompany.Type1099,
	tCompany.Box1099,
	tCompany.EINNumber,
	tCompany.DefaultExpenseAccountKey,
	tCompany.DefaultSalesAccountKey,
	tCompany.TermsPercent,
	tCompany.TermsDays,
	tCompany.TermsNet,
	tCompany.SalesTaxKey,
	tCompany.SalesTax2Key,
	tCompany.InvoiceTemplateKey,
	tCompany.EstimateTemplateKey,
	tCompany.GetRateFrom,
	tCompany.TimeRateSheetKey,
	tCompany.HourlyRate,
	tCompany.GetMarkupFrom,
	tCompany.ItemRateSheetKey,
	tCompany.ItemMarkup,
	tCompany.IOCommission,
	tCompany.BCCommission,
	tCompany.IOBillAt,
	tCompany.BCBillAt,
	tCompany.WebSite,
	tCompany.OwnerCompanyKey,
	tCompany.ParentCompany,
	tCompany.ParentCompanyKey,
	tCompany.Phone,
	tCompany.Fax,
	tCompany.Active,
	tCompany.Locked,
	tCompany.RootFolderKey,
	tCompany.CustomFieldKey,
	tCompany.AccountManagerKey,
	tCompany.UserDefined1,
	tCompany.UserDefined2,
	tCompany.UserDefined3,
	tCompany.UserDefined4,
	tCompany.UserDefined5,
	tCompany.UserDefined6,
	tCompany.UserDefined7,
	tCompany.UserDefined8,
	tCompany.UserDefined9,
	tCompany.UserDefined10,
	tCompany.CompanyTypeKey,
	tCompany.ContactOwnerKey,
	tCompany.Comments,
	tCompany.VendorDownloaded,
	tCompany.ClientDownloaded,
	tCompany.NextProjectNum,
	tCompany.DateAdded,
	tCompany.DateUpdated,
	tCompany.PaymentTermsKey,
	tCompany.CustomLogo,
	tCompany.DefaultARLineFormat,
	tCompany.DefaultTeamKey,
	tCompany.DefaultAPAccountKey,
	tCompany.CardHolderName,
	tCompany.CCNumber,
	tCompany.ExpMonth,
	tCompany.ExpYear,
	tCompany.CVV,
	tCompany.DefaultMemo,
	tCompany.DefaultRetainerKey,
	tCompany.OneInvoicePer,
	tCompany.DefaultBillingMethod,
	tCompany.DefaultExpensesNotIncluded,
	tCompany.DefaultAddressKey,
	tCompany.BillingAddressKey,
	tCompany.PaymentAddressKey,
	case when tCompany.BillingAddressKey IS NOT NULL then bad.Address1
	else ad.Address1 end as BAddress1,	
	case when tCompany.BillingAddressKey IS NOT NULL then bad.Address2
	else ad.Address2 end as BAddress2,	
	case when tCompany.BillingAddressKey IS NOT NULL then bad.Address3
	else ad.Address3 end as BAddress3,
	case when tCompany.BillingAddressKey IS NOT NULL then bad.City
	else ad.City end as BCity,
	case when tCompany.BillingAddressKey IS NOT NULL then bad.State
	else ad.State end as BState,	
	case when tCompany.BillingAddressKey IS NOT NULL then bad.PostalCode
	else ad.PostalCode end as BPostalCode,
	case when tCompany.BillingAddressKey IS NOT NULL then bad.Country
	else ad.Country end as BCountry,	
	ad.Address1, ad.Address2 , ad.Address3,
	ad.City, ad.State, ad.PostalCode,
	ad.Country,
	isnull(ClientDownloaded, 0) as ClientDownloadFlag,
	isnull(VendorDownloaded, 0) as VendorDownloadFlag,
	tGLAccount.AccountNumber AS DefaultExpenseAccount, 
	tGLAccount1.AccountNumber AS DefaultSalesAccount, 
	tUser.FirstName AS PrimaryContactFirstName, 
	tUser.LastName AS PrimaryContactLastName
FROM 
	tCompany 
	LEFT OUTER JOIN tGLAccount ON 
    		tCompany.DefaultExpenseAccountKey = tGLAccount.GLAccountKey
     	LEFT OUTER JOIN tGLAccount tGLAccount1 ON 
    		tCompany.DefaultSalesAccountKey = tGLAccount1.GLAccountKey
     	LEFT OUTER JOIN tUser ON 
    		tCompany.PrimaryContact = tUser.UserKey
		LEFT OUTER JOIN tAddress ad ON
			tCompany.DefaultAddressKey = ad.AddressKey
		LEFT OUTER JOIN tAddress bad ON
			tCompany.BillingAddressKey = bad.AddressKey
GO
