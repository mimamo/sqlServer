USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vVoucher]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vVoucher]

AS

/*
|| 10/28/08 GHL 10.011  (38216) Added OfficeKey when creating the payment detail
|| 09/13/11 GHL 10.457   Added CreditCard,BoughtFrom and BoughtByName
|| 10/19/11 GHL 10.459   Added BoughtByKey, GLCompany info
|| 03/05/12 MFT 10.553  (135446) Added cm table/info
|| 04/03/12 GHL 10.554   Added Class Name
|| 05/17/12 GHL 10.554   Added Account Full Name
|| 07/24/12 MFT 10.558   Added CompanyTypeKey
|| 08/20/12 GHL 10.559   Added Posting Date for the 'Select Credit Cards to Pay' screen 
|| 12/20/12 RLB 10.563  (162896) Added discount calculation to open amount and discount amount fields
|| 03/19/13 GHL 10.566  (172083) Rolled back open amount calculation because this is a function of the payment date on the UI
|| 04/29/13 GHL 10.567  (176301) Added rounding of the discount
|| 07/10/13 WDF 10.570  (176497) Added VoucherID
|| 08/05/13 GHL 10.571   Added multi currency info
|| 01/08/15 PLC 10.582   Added CompanyMediaKey for Publications
*/

SELECT 
	v.CompanyKey
	,v.GLCompanyKey
	,v.VoucherKey
	,v.APAccountKey
	,v.VendorKey
	,v.VoucherID
	,c.VendorID
	,c.OnHold
	,c.CompanyName as VendorName
	,c.CompanyTypeKey
	,v.InvoiceNumber
	,v.DueDate
	,v.InvoiceDate
	,v.PostingDate
	,v.DateReceived
	,v.TermsPercent
	,v.TermsDays
	,v.TermsNet
	,v.RecurringParentKey
	,v.ClassKey
 	,cl.ClassID
 	,cl.ClassName
 	,v.ProjectKey
	,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
	,DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) as DiscountDate
	,v.Description as VoucherDescription
	,v.Status
	,v.Posted
	,v.Downloaded
	,v.ApprovedByKey
	,v.ApprovalComments
	,gl1.AccountNumber as APAccountNumber
	,gl1.AccountName as APAccountName
	,gl1.AccountNumber + ' - ' + gl1.AccountName as APAccountFullName
	,ISNULL(v.VoucherTotal, 0) VoucherTotal
	,ISNULL(v.AmountPaid, 0) AmountPaid
	,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as OpenAmount
	,CASE WHEN DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) > GETDATE() THEN 
	    ROUND(ISNULL(v.VoucherTotal, 0) * (ISNULL(v.TermsPercent, 0) / 100.0), 2)
		ELSE 0 END as DiscountAmount
	,v.OfficeKey
	,isnull(v.CreditCard, 0) as CreditCard
    ,v.BoughtFrom
	,isnull(bbu.FirstName + ' ', '') + isnull(bbu.LastName , '') as BoughtByName
	,v.BoughtByKey    
	,glc.GLCompanyID
	,glc.GLCompanyName
	,cm.CompanyName AS ClientName
	,cm.CustomerID AS ClientID
	,v.CurrencyID
    ,v.ExchangeRate
    ,v.CompanyMediaKey
    ,cmp.Name AS Publication
FROM 
	tVoucher v (nolock)
	INNER JOIN tCompany c (nolock) ON v.VendorKey = c.CompanyKey 
	left outer join tGLAccount gl1 (nolock) on v.APAccountKey = gl1.GLAccountKey
	left outer join tClass cl (nolock) on v.ClassKey = cl.ClassKey
	left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	left outer join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey
	left outer join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left outer join tCompany cm (nolock) on p.ClientKey = cm.CompanyKey
	left outer join tCompanyMedia cmp (nolock) on v.CompanyMediaKey = cmp.CompanyMediaKey
GO
