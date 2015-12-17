USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_CCCharge]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vListing_CCCharge]
AS

/*
|| When     Who Rel  What
|| 11/29/06 CRG 8.35 Wrapped VoucherTotal with ISNULL
|| 10/10/07 CRG 8.5  Added GLCompany and Office
|| 08/25/10 RLB 10534 (88062) added Vendor Company Type and Client Company Type is from the project.
|| 09/28/10 RLB 10535 (91043) added Opening Transaction
|| 08/08/11 GHL 10547 Cloned vListing_Voucher and modified for credit cards
|| 09/20/11 GHL 10548 Changed wording of some field names
||                    AP Account Number to Card Number
||                    AP Account Name to Card Name
||                    Invoice Number to Reference Number
||                    Invoice Date to Charge Date
||                    Invoice Description to Charge Description
||                    Invoice Amount to Charge Amount
||                    Invoice Amount Paid to Charge Amount Paid
||                    Invoice Amount Open to Charge Amount Open
||                    Invoice Status to Charge Status
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
|| 11/29/11 GHL 10.550 Added Purchased From and Purchased By Name to show on listing
|| 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
|| 10/09/12 GHL 10560 Added BoughtByKey to handle security restrictions in listing
|| 11/11/13 GHL 10574 Added BoughtFromKey for the Credit Card Charges tab on the Vendors listing (195862)
|| 03/20/14 GHL 10578 Added Currency and Exchange Rate
|| 10/07/14 CRG 10585 Added Date Sent to Vendor, Date Viewed by Vendor, Viewed By, Date Credit Card Used, Amex Reference Number
|| 10/08/14 CRG 10585 Added CCDeliveryOption
|| 10/30/14 MAS 10585 Viewed By now comes from v.ViewedByName
|| 10/31/14 CRG 10585 Added CardPoolID
|| 10/31/14 GAR 10585 (225553) Changed the way we get and display client information
|| 01/20/15 RLB 10588 (243056) Added Receipt field
|| 01/27/15 WDF 10588 (Abelson Taylor) Added Division and Product
|| 04/01/15 CRG 10590 Added Unique Auto Number
*/

SELECT
	v.VoucherKey
	,v.CompanyKey
	,v.GLCompanyKey
	,v.VendorKey
	,v.BoughtByKey
	,c.CompanyName AS [Vendor Name]
	,c.VendorID AS [Vendor ID]
	,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
	,v.BoughtFrom as [Purchased From]
	,v.BoughtFromKey
	,v.InvoiceDate AS [Charge Date]
	,v.PostingDate AS [Posting Date]
	,p.ProjectNumber as [Header Project Number]
	,p.ProjectName as [Header Project Name]
	,p.ProjectNumber + ' ' + p.ProjectName as [Header Full Project Name]
	,cp.CampaignName as [Campaign Name]
	,gl.AccountNumber as [Card Number]
	,gl.AccountName as [Card Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,v.TermsPercent as [Terms Percentage Discount]
	,v.TermsDays as [Terms Discount Days]
	,v.TermsNet as [Terms Net Days]
	,case v.Receipt when 1 then 'YES' else 'NO' end as [Receipt]
	,v.Description as [Charge Description]
	,vct.CompanyTypeName as [Vendor Company Type]
	,cct.CompanyTypeName as [Client Company Type]
	,ISNULL(v.VoucherTotal, 0) as [Charge Amount]
	,v.AmountPaid as [Charge Amount Paid]
	,v.VoucherTotal - v.AmountPaid as [Charge Amount Open]
	,v.InvoiceNumber AS [Reference Number]
	,u.FirstName + ' ' + u.LastName as [Approver Name]
	,bbu.FirstName + ' ' + bbu.LastName as [Purchased By Name]
	,case v.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction]
	,case v.Downloaded when 1 then 'YES' else 'NO' end as Downloaded
	,case v.Posted when 1 then 'YES' else 'NO' end as Posted
	,Case v.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case v.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Charge Status]
	,v.ApprovalComments as [Approval Comments]
	,ISNULL((Select Count(*) from tTransaction (nolock) Where Entity = 'CREDITCARD' and EntityKey = v.VoucherKey), 0) as [Posting Count]
	,(CASE WHEN ISNULL(cli.CompanyName,'') = '' THEN (SELECT TOP 1 CompanyName FROM tCompany (nolock) INNER JOIN tVoucherDetail (nolock) ON tCompany.CompanyKey = tVoucherDetail.ClientKey WHERE tVoucherDetail.VoucherKey = v.VoucherKey AND tVoucherDetail.ClientKey IS NOT NULL) ELSE cli.CompanyName END)  as [Client Name]
	,(CASE WHEN ISNULL(cli.CustomerID,'') = '' THEN (SELECT TOP 1 CustomerID FROM tCompany (nolock) INNER JOIN tVoucherDetail (nolock) ON tCompany.CompanyKey = tVoucherDetail.ClientKey WHERE tVoucherDetail.VoucherKey = v.VoucherKey AND tVoucherDetail.ClientKey IS NOT NULL) ELSE cli.CustomerID END)  as [Client ID]
	,(CASE WHEN ISNULL(cli.CompanyName,'') = '' THEN (SELECT TOP 1 CompanyName FROM tCompany (nolock) INNER JOIN tVoucherDetail (nolock) ON tCompany.CompanyKey = tVoucherDetail.ClientKey WHERE tVoucherDetail.VoucherKey = v.VoucherKey AND tVoucherDetail.ClientKey IS NOT NULL) ELSE cli.CompanyName END)  as [Client Full Name]
	--,cli.CompanyName as [Client Name]
	--,cli.CustomerID as [Client ID]
	--,cli.CompanyName as [Client Full Name]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,v.CurrencyID as Currency
	,v.ExchangeRate as [Exchange Rate]
	,v.DateSentToVendor as [Date Sent to Vendor]
	,v.DateViewedByVendor as [Date Viewed by Vendor]
	,v.ViewedByName as [Viewed By]
	,v.DateCCUsed as [Date Credit Card Used]
	,v.AmexRefNumber as [Amex Reference Number]
	,gl.CCDeliveryOption
	,CASE gl.CCDeliveryOption
		WHEN 1 THEN 'Manual credit card'
		WHEN 2 THEN 'vPayment'
		ELSE 'Retreive from Bank'
	END AS [Delivery Option]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cpr.ProductID as [Client Product ID]
    ,cpr.ProductName as [Client Product]
    ,CAST(v.VoucherID as varchar) as [Unique Reference Number]
From
	tVoucher v (nolock)
	Inner Join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	left outer join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey
	left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	inner join tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
	inner join tCompany glv (nolock) on gl.VendorKey = glv.CompanyKey -- This defines a CC
	left outer join tClass cl (nolock) on v.ClassKey = cl.ClassKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tCompany cli (nolock) on p.ClientKey = cli.CompanyKey
	left outer join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on v.OfficeKey = o.OfficeKey
	left outer join tCompanyType vct (nolock) on c.CompanyTypeKey = vct.CompanyTypeKey
	left outer join tCompanyType cct (nolock) on cli.CompanyTypeKey = cct.CompanyTypeKey
	left outer join tCompany bf (nolock) on v.BoughtFromKey = bf.CompanyKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
Where CreditCard = 1
GO
