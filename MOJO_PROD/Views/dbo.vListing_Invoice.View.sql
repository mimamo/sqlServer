USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Invoice]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Invoice]
AS

/*
|| When     Who Rel      What
|| 03/02/07 BSH 8.4.0.4  Added Primary Conact.
|| 03/19/07 GHL 8.4.0.8  Added Emailed
|| 03/26/07 RTC 8.4.1    (7972, 8118) Added the client division and product fields from the invoice header project.
|| 10/10/07 CRG 8.5      Added Company and Office
|| 11/06/07 CRG 8.5      (9309) Added Project Name
|| 01/07/08 GWG 8502      Added the user defined fields
|| 02/11/08 BSH 1.000     Added ASC_Selected
|| 02/14/08 GHL 1.000     Added GLCompanyKey so that we can charge credit cards from the listing 
|| 06/11/08 GHL 8513     (27755) Setting now Advance Bill Unapplied to 0 if the invoice is not an advance bill
|| 12/16/08 GHL 10.015   (42441) Added Advance Bill Sales Tax Unapplied
|| 03/17/09 RTC 10.5	  Removed user defined fields.
|| 07/09/09 MAS 10.5	 (56913)Added AccountManager
|| 09/29/09 GWG 10.511	 (63864) Modified the column Amount Billed to not include credits. Looks at Retainer Amount
|| 01/04/10 RLB 10.516   (71241) Added Project Account Manager
|| 05/19/10 RLB 10.523   (79987) Added Client Project Number, Client Primary Contact and Custom Fields for Company, Project and contacts
|| 07/28/10 RLB 10.533   (78955) Added Project Full Name & description
|| 08/13/10 RLB 10.533   (87534) Added Company Type and Parent Company
|| 09/28/10 RLB 10535    (91043) Added Opening Transaction
|| 11/15/10 RLB 10.538   (91722) Added Invoice Template and Invoice Layout
|| 12/15/11 GWG 10.551	  Added Project Campaign Name 
|| 07 18/12 RLB 10.558   (137183) Added Invoice Campaign Name
|| 08/27/12 RLB 10.559   (152497) added Billing Code
|| 09/06/12 KMC 10.5.6.0 (151883) Update query to return the Billing Group Code per recommendations from Gil
|| 09/11/12 MFT 10.559   Added Alternate Payer
|| 09/15/12 GWG 10.560   Fixed link to billing group code to get it from the project based on the invoice header
|| 09/27/12 GHL 10.560   Since we added tInvoice.BillingGroupKey, get Billing Group Code from tBillingGroup, joining with that new field 
|| 06/27/13 GWG 10.569   Added project key to limit visibility to assigned projects.
|| 07/01/13 GHL 10.569   (181721) Added Campaign ID
|| 01/03/14 WDF 10.576   (188500) Added [Date Created] and [Created By]
|| 01/27/14 GHL 10.576   Added Currency 
|| 03/20/14 GHL 10.578   Added Exchange Rate 
|| 04/9/14  GWG 10.578   Added project team and project status
|| 07/2/14  GWG 10.581   Added Sales Tax names
|| 11/24/14 GAR 10.586   (237300) Added bill to state and company state.
|| 1/26/15  GHL 10.588   Added Biling Group Description for Abelson Taylor
|| 01/27/15 WDF 10.588   (Abelson Taylor) Added Division and Product ID
*/

SELECT 
	i.InvoiceKey,
	i.CompanyKey, 
	i.ClientKey,
	i.GLCompanyKey,
	i.ProjectKey,
    i.InvoiceNumber AS [Invoice Number], 
    i.InvoiceDate AS [Invoice Date], 
	i.PostingDate as [Posting Date],
    i.DueDate AS [Due Date], 
	case i.AdvanceBill when 1 then 'YES' else 'NO' end as [Advance Billing Invoice],
	i.UserDefined1 as [Invoice User Defined 1],
	i.UserDefined2 as [Invoice User Defined 2],
	i.UserDefined3 as [Invoice User Defined 3],
	i.UserDefined4 as [Invoice User Defined 4],
	i.UserDefined5 as [Invoice User Defined 5],
	i.UserDefined6 as [Invoice User Defined 6],
	i.UserDefined7 as [Invoice User Defined 7],
	i.UserDefined8 as [Invoice User Defined 8],
	i.UserDefined9 as [Invoice User Defined 9],
	i.UserDefined10 as [Invoice User Defined 10],
	i.DateCreated AS [Date Created],
	c.CustomFieldKey,
	cpc.CustomFieldKey as CustomFieldKey3,
	pr.CustomFieldKey as CustomFieldKey2,
    c.CompanyName AS [Client Name], 
    c.CustomerID AS [Client ID],
    ct.CompanyTypeName AS [Company Type],
    pc.CompanyName AS [Parent Company], 
    c.CustomerID + ' - ' + c.CompanyName AS [Client Full Name], 
	ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName,'') AS [Account Manager], 
	ISNULL(pam.FirstName,'') + ' ' + ISNULL(pam.LastName,'') AS [Project Account Manager],
	ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName,'') AS [Sales Person],
	ISNULL(cpc.FirstName,'') + ' ' + ISNULL(cpc.LastName,'') AS [Client Primary Contact],
	ISNULL(cbk.FirstName,'') + ' ' + ISNULL(cbk.LastName,'') AS [Created By],
    pt.TermsDescription AS Terms, 
    glAR.AccountNumber AS [AR Account Number], 
    glAR.AccountName AS [AR Account Name], 
	glSales.AccountNumber AS [Default Sales Account Number], 
    glSales.AccountName AS [Default Sales Account Name],
	cl.ClassID as [Class ID],
	cl.ClassName as [Class Name],
    pr.ProjectNumber as [Project Number],
	pr.ProjectName as [Project Name],
	pr.ProjectNumber + ' - ' + pr.ProjectName AS [Project Full Name],
	pr.ClientProjectNumber as [Client Project Number],
	pr.Description as [Project Description],
	camp.CampaignName as [Project Campaign Name],
	camp2.CampaignName as [Invoice Campaign Name],
	camp.CampaignID as [Project Campaign ID],
	camp2.CampaignID as [Invoice Campaign ID],
	cd.DivisionName as [Division Name],
	cd.DivisionID as [Division ID],
	cp.ProductName as [Product Name],
	cp.ProductID as [Product ID],
	ISNULL(i.InvoiceTotalAmount, 0) as [Amount Total],
	ISNULL(i.TotalNonTaxAmount, 0) as [Amount Non Tax Total],
	ISNULL(i.SalesTaxAmount, 0) as [Amount Sales Tax],
	ISNULL(i.AmountReceived, 0) as [Amount Received],
    ISNULL(i.WriteoffAmount, 0) AS [Amount Writeoff], 
    ISNULL(i.RetainerAmount, 0) AS [Amount Applied From Adv Bill], 
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) as [Amount Open],
    i.HeaderComment as [Invoice Comment], 
	i.ApprovalComments as [Approval Comments],
	it.TemplateName AS [Invoice Template],
	lo.LayoutName AS [Invoice Layout],
	Case i.InvoiceStatus
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case i.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Approval Status],
    case i.Downloaded when 1 then 'YES' else 'NO' end as Downloaded, 
	case i.Posted when 1 then 'YES' else 'NO' end as Posted,
	case i.Printed when 1 then 'YES' else 'NO' end as Printed,
	case i.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction],
	case i.Emailed when 1 then 'YES' else 'NO' end as Emailed,
	u.FirstName + ' ' + u.LastName as [Invoice Approver],
        u1.FirstName + ' ' + u1.LastName as [Primary Contact],
	(Select Count(*) from tTransaction (nolock) Where Entity = 'INVOICE' and EntityKey = i.InvoiceKey) as [Posting Count],
	
	ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
	Where AdvBillInvoiceKey = i.InvoiceKey),0) as [Advance Bill Applied],
	
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.RetainerAmount, 0) as [Amount Billed],

	CASE WHEN i.AdvanceBill = 1 THEN
		ISNULL(i.InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
		Where AdvBillInvoiceKey = i.InvoiceKey),0)
	ELSE 0 END as [Advance Bill Unapplied],

	CASE WHEN i.AdvanceBill = 1 THEN
		ISNULL(i.SalesTaxAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
		Where AdvBillInvoiceKey = i.InvoiceKey),0)
	ELSE 0 END as [Advance Bill Sales Tax Unapplied],
	
	ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = i.InvoiceKey),0) as [Applied Advance Billings],
	ISNULL((Select Sum(Amount) from tInvoiceCredit (nolock) Where CreditInvoiceKey = i.InvoiceKey), 0) as [Credit Amount Applied],
	ISNULL((Select Sum(Amount) from tInvoiceCredit (nolock) Where InvoiceKey = i.InvoiceKey),0) as [Applied Credits]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,ap.CompanyName AS [Alternate Payer]
	,ap.CustomerID AS [Alternate Payer ID]
	,bg.BillingGroupCode as [Billing Group Code]
	,bg.Description as [Billing Group Description]
	,i.CurrencyID as [Currency]
	,i.ExchangeRate as [Exchange Rate]
	,tt.TeamName as [Project Team Name]
	,ps.ProjectStatus as [Project Status]
	,st1.SalesTaxID as [Sales Tax 1 Code]
	,st2.SalesTaxID as [Sales Tax 2 Code]
	,st1.SalesTaxName as [Sales Tax 1 Name]
	,st2.SalesTaxName as [Sales Tax 2 Name]
	,CASE WHEN i.AddressKey IS NOT NULL THEN ib.State ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			end AS [Bill To State]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			AS [Company State]
  ,0 AS ASC_Selected
FROM 
	tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey 
    LEFT OUTER JOIN tGLAccount glAR (nolock) ON i.ARAccountKey = glAR.GLAccountKey 
	LEFT OUTER JOIN tGLAccount glSales (nolock) ON c.DefaultSalesAccountKey = glSales.GLAccountKey 
	LEFT OUTER JOIN tClass cl (nolock) on i.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tUser u (nolock) on i.ApprovedByKey = u.UserKey
    LEFT OUTER JOIN tProject pr (nolock) on i.ProjectKey = pr.ProjectKey
    LEFT OUTER JOIN tCampaign camp (nolock) on pr.CampaignKey = camp.CampaignKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
    LEFT OUTER JOIN tUser u1 (nolock) on i.PrimaryContactKey = u1.UserKey
	LEFT OUTER JOIN tUser am (nolock) on c.AccountManagerKey = am.UserKey
	LEFT OUTER JOIN tUser sales (nolock) on c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tUser pam (nolock) on pr.AccountManager = pam.UserKey
	LEFT OUTER JOIN tUser cpc (nolock) on c.PrimaryContact = cpc.UserKey
	LEFT OUTER JOIN tUser cbk (nolock) on i.CreatedByKey = cbk.UserKey
	left outer join tGLCompany glc (nolock) on i.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on i.OfficeKey = o.OfficeKey
	Left Outer Join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	Left Outer Join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	Left Outer Join tInvoiceTemplate it (nolock) on i.InvoiceTemplateKey = it.InvoiceTemplateKey
	Left Outer Join tLayout lo (nolock) on i.LayoutKey = lo.LayoutKey
	Left Outer Join tCampaign camp2 (nolock) on i.CampaignKey = camp2.CampaignKey
	LEFT OUTER JOIN tCompany ap (nolock) ON i.AlternatePayerKey = ap.CompanyKey
	LEFT OUTER JOIN tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey 
	LEFT OUTER JOIN tTeam tt (nolock) on pr.TeamKey = tt.TeamKey
	LEFT OUTER JOIN tProjectStatus ps (nolock) on pr.ProjectStatusKey = ps.ProjectStatusKey
	LEFT OUTER JOIN tSalesTax st1 (nolock) on i.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on i.SalesTax2Key = st2.SalesTaxKey
	Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	Left outer join tAddress ab (nolock) on c.BillingAddressKey = ab.AddressKey
	Left outer join tAddress ib (nolock) on i.AddressKey = ib.AddressKey
GO
