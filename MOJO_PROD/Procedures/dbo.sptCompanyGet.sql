USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGet]
	 @CompanyKey int
AS --Encrypt


	-- Note from Gil: I replaced c.* by explicit field names for backward compatibilty
	-- When we remove the address fields from c, we can go back to c.* 
	
/*
|| When     Who Rel     What
|| 12/6/06  CRG 8.4     Added StateEINNumber
|| 8/22/07  GWG 8.5     Added the GL Company and Overhead flags
|| 12/21/07 GHL 8.5     Added comments after CustomLogo since task manager looks for go+CR during Installs
|| 03/04/08 CRG 1.0.0.0 Added Company fields explicitly to remove conflict with the address fields caused by c.*
||                      Also added ParentCompanyName and ContactOwnerName
|| 03/16/09 QMD 10.5    Removed User Defined Fields
|| 04/16/09 GWG 10.5    Added fields for compatibility with default names for activity history
|| 06/23/09 MAS 10.5    (55337) Added field UserRole field
|| 11/4/09  CRG 10.5.1.3 (67238) Added DBA
|| 08/25/10 GHL 10.5.3.4 Added LayoutKey
|| 03/03/11 RLB 10.5.4.0 Added for new company vendor sales taxs enhancement
|| 08/12/11 MFT 10.5.4.7 Added DefaultVoucherType
|| 10/28/11 GHL 10.5.4.9 Added CreditCard flag to be used on payment screen
|| 05/11/12 GHL 10.5.5.6 (142898) Added default AP approver for vendor invoice screen
|| 07/10/12 GHL 10.5.5.8 (148528) Added OverheadVendor
|| 07/10/12 GHL 10.5.5.8 (148091) Added BillingName
|| 08/03/12 KMC 10.5.5.8 (146259) Added @CCAccepted to capture if the vendor accepts credit card payments
|| 09/14/12 GHL 10.5.6.0 Added Alternate Payer info
|| 09/21/12 KMC 10.5.6.0 (133301) Added UseDBAForPayment flag to tCompany
*/ 

  declare @HasCreditCard int
  if exists (select 1 from tGLAccount gla (nolock)
			inner join tCompany c (nolock) on c.OwnerCompanyKey = gla.CompanyKey -- uses IX_tGLAccount
			where c.CompanyKey = @CompanyKey
			and   gla.VendorKey = @CompanyKey
			) 
			select @HasCreditCard = 1
		else
			select @HasCreditCard = 0
		 
  	
  SELECT
		c.*,
		ad.Address1 as Address1,		-- For backward compatibility
		ad.Address2 as Address2,		-- For backward compatibility
		ad.Address3 as Address3,		-- For backward compatibility
		ad.City as City, 				-- For backward compatibility
		ad.State as State, 				-- For backward compatibility
		ad.PostalCode as PostalCode, 	-- For backward compatibility
		ad.Country as Country,			-- For backward compatibility
		
		ad.Address1 as DAddress1,
		ad.Address2 as DAddress2,
		ad.Address3 as DAddress3,
		ad.City as DCity, 
		ad.State as DState, 
		ad.PostalCode as DPostalCode, 
		ad.Country as DCountry, 
		ad.AddressName as DAddressName,
		adb.Address1 as DBAddress1,
		adb.Address2 as DBAddress2,
		adb.Address3 as DBAddress3,
		adb.City as DBCity, 
		adb.State as DBState, 
		adb.PostalCode as DBPostalCode, 
		adb.Country as DBCountry, 
		adb.AddressName as DBAddressName,
		gl.AccountNumber as DefaultExpenseAccountNumber,
		gl.AccountName as DefaultExpenseAccountName,
		gl2.AccountNumber as DefaultSalesAccountNumber,
		gl2.AccountName as DefaultSalesAccountName,
		gl3.AccountNumber as DefaultAPAccountNumber,
		gl3.AccountName as DefaultAPAccountName,
		it.TemplateName,
		pc.CompanyName as ParentCompanyName,
		co.UserName as ContactOwnerName,
		pcu.FirstName + ' ' + pcu.LastName as PrimaryContactName,
		pcu.UserRole,
		c.CompanyKey as ContactCompanyKey,  -- name compatibility with the activities history
		pcu.FirstName + ' ' + pcu.LastName as ContactName,
		@HasCreditCard as HasCreditCard,
		apc.CustomerID as AlternatePayerClientID,
		apc.CompanyName as AlternatePayerCompanyName
  FROM tCompany c (nolock)
	left outer join tGLAccount gl (nolock) on c.DefaultExpenseAccountKey = gl.GLAccountKey
	left outer join tGLAccount gl2 (nolock) on c.DefaultSalesAccountKey = gl2.GLAccountKey
	left outer join tGLAccount gl3 (nolock) on c.DefaultAPAccountKey = gl3.GLAccountKey
	left outer join tInvoiceTemplate it (nolock) on c.InvoiceTemplateKey = it.InvoiceTemplateKey
	left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	left outer join tAddress adb (nolock) on c.BillingAddressKey = adb.AddressKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join vUserName co (nolock) on c.ContactOwnerKey = co.UserKey
	left outer join tUser pcu (nolock) on c.PrimaryContact = pcu.UserKey 
	left outer join tCompany apc (nolock) on c.AlternatePayerKey = apc.CompanyKey
  WHERE
   c.CompanyKey = @CompanyKey
  
 RETURN 1
GO
