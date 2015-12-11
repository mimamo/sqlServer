USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Invoice]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vReport_Invoice]
AS

/*
|| When     Who Rel     What
|| 10/12/06 WES 8.3567  Added Amount Advance Billed, Estimate Total
|| 03/19/07 GHL 8.408   Added Emailed
|| 03/26/07 RTC 8.4.1   (7972) Added the client division and product from the invoice detail project.
|| 10/11/07 CRG 8.5     Added GLCompany, Department, Office
|| 11/7/07  CRG 8.5     (7962) Added Client Primary Contact Phone1, Phone2, and Email
|| 01/10/08 GWG 8.502   Fixed where invoice approver was comming from
|| 02/07/08 GHL 8.503  (20833) Added Date Paid field
|| 07/31/08 GHL 8.517  (31159) Added line project description
|| 03/17/09  RTC 10.5	  Removed user defined fields. 
|| 8/7/09   CRG 10.5.0.7 (58248) Added Company CustomFieldKey
|| 10/30/09 GWG 10.5.1.3 Added Task ID, Name and Description
|| 04/30/10 RLB 10.5.2.2 (63218)Added Parent Company Name
|| 06/15/10 GWG 10.5.3.2 Added the default client sales account for CBRE
|| 08/15/10 GWG 10.5.3.2 Added a union in to pull in child invoices (cbre)
|| 09/28/10 RLB 10.5.3.5 (91043) Added Opening Transaction to report
|| 11/2/10  RLB 10.5.3.7 (89210) Added line Sales Tax 1, 2 and Total
|| 11/5/10  GHL 10.5.3.7 (93868) Added Parent Invoice flag
|| 12/2/10  RLB 10.5.3.9 (95841) Added Project Billing Status
|| 12/3/10  RLB 10.5.3.9 (93868) fixed UNION
|| 02/17/11 RLB 10.5.4.1 (104102) added Line type, Item ID and Line Item Name
|| 02/22/11 RLB 10.5.4.1 (89417) added Tax 1 and 2 applied
|| 09/01.11 RLB 10.5.4.7 (119705) Added Gl Sales Account Number
|| 04/24/12 GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 09/06/12 KMC 10.5.6.0 (151883) Added Billing Group Code
|| 10/17/12 GHL 10.5.6.0 (157258) Using now tBillingGroup to get Billing Group Code
||                        because of multiple billing worksheets associated to 1 invoice
||                        (happens when master billing ws used)
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 02/20/13 GHL 10.5.6.5 (169313) Advance Bill Unapplied = 0 for regular invoices
|| 01/03/14 WDF 10.5.7.6 (188500) Added CreatedByKey and DateCreated
|| 03/07/14 GHL 10.5.7.8  Added Currency + Exchange Rate
|| 07/16/14 GWG 10.5.8.2  Fixed join for header class
|| 11/24/14 GAR 10.5.8.6  (237300) Added company state.
|| 01/26/15 GHL 10.588 Added Billing Group Description for Abelson Taylor
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
|| 01/29/15 GHL 10.588 Added Billing Title for Abelson + Title Rate Sheet
*/

SELECT
	i.CompanyKey, 
	isnull(il.TargetGLCompanyKey, i.GLCompanyKey) as GLCompanyKey, 
	p.CustomFieldKey,
	c.CustomFieldKey AS CustomFieldKey2,
    bcu.CustomFieldKey AS CustomFieldKey3,
	cd.DivisionName as [Division Name],
	cd.DivisionID as [Division ID],
	pd.ProductName as [Product Name],
	pd.ProductID as [Product ID],
	i.InvoiceNumber AS [Invoice Number], 
	i.InvoiceDate AS [Invoice Date], 
	i.PostingDate as [Posting Date],
	i.DueDate AS [Due Date], 
	i.DateCreated AS [Date Created], 
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
	c.CompanyName AS [Client Name], 
	c.CustomerID AS [Client ID], 
	c.CustomerID + ' - ' + c.CompanyName AS [Client Full Name], 
	i.ContactName as [Bill To Contact],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address1 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address1 ELSE ad.Address1 END
			end AS [Bill To Address1],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address2 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address2 ELSE ad.Address2 END
			end AS [Bill To Address2],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address3 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address3 ELSE ad.Address3 END
			end AS [Bill To Address3],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.City ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.City ELSE ad.City END
			end AS [Bill To City],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.State ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			end AS [Bill To State],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.PostalCode ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.PostalCode ELSE ad.PostalCode END
			end AS [Bill To Postal Code],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Country ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Country ELSE ad.Country END
			end AS [Bill To Country],
	pt.TermsDescription AS Terms, 
	glAR.AccountNumber + ' - ' + glAR.AccountName AS [AR Account], 
	glCL.AccountNumber + ' - ' + glCL.AccountName AS [Default Client Sales Account], 
	pr.ProjectNumber as [Project Number],
	pr.ProjectName as [Project Name], 
	pr.ProjectNumber + ' - ' + pr.ProjectName as [Project Full Name],
	pr.ClientProjectNumber as [Client Project Number],
	i.WriteoffAmount AS [Invoice Writeoff Amount], 
	i.RetainerAmount AS [Invoice Adv Bill Amount], 
	i.InvoiceTotalAmount as [Invoice Total With Tax],
	i.TotalNonTaxAmount as [Invoice Total No Tax],
	i.InvoiceTotalAmount - i.TotalNonTaxAmount as [Invoice Total Tax],
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) as [Amount Open],
	i.HeaderComment AS [Invoice Comment], 
	i.ApprovalComments as [Approval Comments],
	cl2.ClassID as [Header Class ID],
	cl2.ClassName as [Header Class Name],
	case when i.AdvanceBill = 1 then
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = i.InvoiceKey),0) 
	else 0 end as [Advance Bill Unapplied],
	ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = i.InvoiceKey),0) as [Applied Advance Billings],
	Case i.InvoiceStatus
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case i.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Invoice Status],
	case il.BillFrom When 1 Then 'No Transactions' else 'Transactions' end as [Bill From],
	case i.Downloaded when 1 then 'YES' else 'NO' end as Downloaded, 
	case i.Posted when 1 then 'YES' else 'NO' end as Posted,
	case i.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction],
	case i.Printed when 1 then 'YES' else 'NO' end as Printed, 
	case i.Emailed when 1 then 'YES' else 'NO' end as Emailed, 
	case i.ParentInvoice when 1 then 'YES' else 'NO' end as [Parent Invoice], 
	il.LineSubject AS [Line Description], 
	il.LineDescription AS [Line Comments], 
	il.Quantity AS [Line Quantity], 
	il.UnitAmount AS [Line Unit Amount], 
	il.TotalAmount AS [Line Total Amount],
	case il.Taxable when 1 then 'YES' else 'NO' end as [Line Sales Tax 1 Applied],
	case il.Taxable2 when 1 then 'YES' else 'NO' end as [Line Sales Tax 2 Applied],
	il.SalesTax1Amount AS [Line Sales 1 Tax Amount],
	il.SalesTax2Amount AS [Line Sales 2 Tax Amount],
	il.SalesTaxAmount AS [Line Sales Tax Total Amount],
	case il.Entity
		when 'tItem' then 'Item'
		when 'tService' then 'Service'
		when 'tTitle' then 'Title'
		end as [Line Type],
	case il.Entity
		When 'tItem' then item.ItemID
		when 'tService' then s.ServiceCode
		when 'tTitle' then tt.TitleID
		End as [Line Item ID],
	case il.Entity
		When 'tItem' then item.ItemName
		when 'tService' then s.Description
		when 'tTitle' then tt.TitleName
		End as [Line Item Name],
	cl.ClassID as [Line Class ID],
	cl.ClassName as [Line Class Name],
	bi.WorkTypeName as [Billing Item],
	am.FirstName + ' ' + am.LastName as [Account Manager],
	glSales.AccountNumber + ' - ' + glSales.AccountName AS [Sales GL Account],
	glSales.AccountNumber  AS [Sales GL Account Number],
	app.FirstName + ' ' + app.LastName as [Invoice Approver],
	sales.FirstName + ' ' + sales.LastName as [Sales Person],
	p.ProjectNumber as [Line Project Number],
	p.ProjectName as [Line Project Name],
	p.ProjectNumber + ' - ' + p.ProjectName as [Line Project Full Name],
	p.ClientProjectNumber as [Line Client Project Number],
    CAST(p.Description as VARCHAR(4000)) as [Line Project Description],
	prt.ProjectTypeName as [Line Project Type],
	pbs.ProjectBillingStatus as [Project Billing Status],
	cp.CampaignID as [Campaign ID],
	cp.CampaignName as [Campaign Name],
	ct.CompanyTypeName as [Company Type],
	i.ContactName as [Printed Name],
	cbk.FirstName + ' ' + cbk.LastName as [Created By Name],
	u.FirstName + ' ' + u.LastName as [Client Primary Contact],
	u.Phone1 as [Client Primary Contact Phone1],
	u.Phone2 as [Client Primary Contact Phone2],
	u.Email as [Client Primary Contact Email],
	p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Estimate Total],
	(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed],
	isnull(glcT.GLCompanyID, glc.GLCompanyID) as [Company ID], 
	isnull(glcT.GLCompanyName, glc.GLCompanyName) as [Company Name], 
	pc.CompanyName as [Parent Company],
	o.OfficeID as [Office ID],
	o.OfficeName as [Office Name],
	d.DepartmentName as Department,
	t.TaskID AS [Task ID],
	t.TaskName as [Task Name],
	t.Description as [Task Description],
	(Select Max(c.CheckDate)
	From   tCheck c (nolock)
	Inner Join tCheckAppl ca (nolock) on ca.CheckKey = c.CheckKey
	Where ca.InvoiceKey = i.InvoiceKey
	And   ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.AmountReceived, 0) = 0
	) AS [Date Paid],
	bg.BillingGroupCode as [Billing Group Code],
	bg.Description as [Billing Group Description],
	p.ProjectKey,
	i.CurrencyID as [Currency],
	i.ExchangeRate as [Exchange Rate], 
	st1.SalesTaxID as [Sales Tax 1 Code],
	st2.SalesTaxID as [Sales Tax 2 Code],
	st1.SalesTaxName as [Sales Tax 1 Name],
	st2.SalesTaxName as [Sales Tax 2 Name],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			AS [Company State],
	trs.RateSheetName as [Service Rate Sheet],
	irs.RateSheetName as [Item Rate Sheet],
	ttrs.RateSheetName as [Title Rate Sheet]
FROM 
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock)ON i.InvoiceKey = il.InvoiceKey 
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey 
	LEFT OUTER JOIN tGLAccount glSales (nolock) ON il.SalesAccountKey = glSales.GLAccountKey
    LEFT OUTER JOIN tGLAccount glAR (nolock) ON i.ARAccountKey = glAR.GLAccountKey 
    LEFT OUTER JOIN tGLAccount glCL (nolock) ON c.DefaultSalesAccountKey = glCL.GLAccountKey 
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tProject pr (nolock) ON i.ProjectKey = pr.ProjectKey
    LEFT OUTER JOIN tUser bcu (nolock) on pr.BillingContact = bcu.UserKey 
    LEFT OUTER JOIN tProject p (nolock) ON il.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct pd (nolock) on p.ClientProductKey = pd.ClientProductKey
	LEFT OUTER JOIN tProjectType prt (nolock) on p.ProjectTypeKey = prt.ProjectTypeKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
	LEFT OUTER JOIN tUser u (nolock) on i.PrimaryContactKey = u.UserKey
	LEFT OUTER JOIN tUser app (nolock) on i.ApprovedByKey = app.UserKey
	LEFT OUTER JOIN tUser cbk (nolock) on i.CreatedByKey = cbk.UserKey
	LEFT OUTER JOIN tUser sales (nolock) on c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	LEFT OUTER JOIN tWorkType bi (nolock) on il.WorkTypeKey = bi.WorkTypeKey
	left outer join tClass cl (nolock) on il.ClassKey = cl.ClassKey
	left outer join tClass cl2 (nolock) on i.ClassKey = cl2.ClassKey
	Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	Left outer join tAddress ab (nolock) on c.BillingAddressKey = ab.AddressKey
	Left outer join tAddress ib (nolock) on i.AddressKey = ib.AddressKey
	LEFT OUTER Join tTask t (nolock) on il.TaskKey = t.TaskKey
	left outer join tGLCompany glc (nolock) on i.GLCompanyKey = glc.GLCompanyKey
	left outer join tGLCompany glcT (nolock) on il.TargetGLCompanyKey = glcT.GLCompanyKey
	left outer join tOffice o (nolock) on il.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on il.DepartmentKey = d.DepartmentKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tProjectBillingStatus pbs (nolock) on ISNULL(p.ProjectBillingStatusKey, pr.ProjectBillingStatusKey) = pbs.ProjectBillingStatusKey
	left outer join tService s (nolock) on il.EntityKey = s.ServiceKey AND il.Entity = 'tService'
	left outer join tItem item (nolock) on il.EntityKey = item.ItemKey AND il.Entity = 'tItem'
	left outer join tTitle tt (nolock) on il.EntityKey = tt.TitleKey AND il.Entity = 'tTitle'
	left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
	LEFT OUTER JOIN tSalesTax st1 (nolock) on i.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on i.SalesTax2Key = st2.SalesTaxKey
	left outer join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
	left outer join tItemRateSheet irs (nolock) on p.ItemRateSheetKey = irs.ItemRateSheetKey
	left outer join tTitleRateSheet ttrs (nolock) on p.TitleRateSheetKey = ttrs.TitleRateSheetKey
WHERE (il.LineType = 2)

UNION ALL

SELECT
	i.CompanyKey, 
	i.GLCompanyKey, 
	p.CustomFieldKey,
	c.CustomFieldKey AS CustomFieldKey2,
    bcu.CustomFieldKey AS CustomFieldKey3,
	cd.DivisionName as [Division Name],
	cd.DivisionID as [Division ID],
	pd.ProductName as [Product Name],
	pd.ProductID as [Product ID],
	i.InvoiceNumber AS [Invoice Number], 
	i.InvoiceDate AS [Invoice Date], 
	i.PostingDate as [Posting Date],
	i.DueDate AS [Due Date], 
	i.DateCreated AS [Date Created], 
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
	c.CompanyName AS [Client Name], 
	c.CustomerID AS [Client ID], 
	c.CustomerID + ' - ' + c.CompanyName AS [Client Full Name], 
	i.ContactName as [Bill To Contact],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address1 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address1 ELSE ad.Address1 END
			end AS [Bill To Address1],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address2 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address2 ELSE ad.Address2 END
			end AS [Bill To Address2],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Address3 ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Address3 ELSE ad.Address3 END
			end AS [Bill To Address3],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.City ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.City ELSE ad.City END
			end AS [Bill To City],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.State ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			end AS [Bill To State],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.PostalCode ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.PostalCode ELSE ad.PostalCode END
			end AS [Bill To Postal Code],
	CASE WHEN i.AddressKey IS NOT NULL THEN ib.Country ELSE  
		CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.Country ELSE ad.Country END
			end AS [Bill To Country],
	pt.TermsDescription AS Terms, 
	glAR.AccountNumber + ' - ' + glAR.AccountName AS [AR Account], 
	glCL.AccountNumber + ' - ' + glCL.AccountName AS [Default Client Sales Account], 
	pr.ProjectNumber as [Project Number],
	pr.ProjectName as [Project Name], 
	pr.ProjectNumber + ' - ' + pr.ProjectName as [Project Full Name],
	pr.ClientProjectNumber as [Client Project Number],
	i.WriteoffAmount AS [Invoice Writeoff Amount], 
	i.RetainerAmount AS [Invoice Adv Bill Amount], 
	i.InvoiceTotalAmount as [Invoice Total With Tax],
	i.TotalNonTaxAmount as [Invoice Total No Tax],
	i.InvoiceTotalAmount - i.TotalNonTaxAmount as [Invoice Total Tax],
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) as [Amount Open],
	i.HeaderComment AS [Invoice Comment], 
	i.ApprovalComments as [Approval Comments],
	cl2.ClassID as [Header Class ID],
	cl2.ClassName as [Header Class Name],
	case when i.AdvanceBill = 1 then
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = i.InvoiceKey),0) 
	else 0 end as [Advance Bill Unapplied],
	ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = i.InvoiceKey),0) as [Applied Advance Billings],
	Case i.InvoiceStatus
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case i.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Invoice Status],
	
	case il.BillFrom When 1 Then 'No Transactions' else 'Transactions' end as [Bill From],
	case i.Downloaded when 1 then 'YES' else 'NO' end as Downloaded, 
	case i.Posted when 1 then 'YES' else 'NO' end as Posted,
	case i.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction],
	case i.Printed when 1 then 'YES' else 'NO' end as Printed, 
	case i.Emailed when 1 then 'YES' else 'NO' end as Emailed, 
	case i.ParentInvoice when 1 then 'YES' else 'NO' end as [Parent Invoice], 
	il.LineSubject AS [Line Description], 
	il.LineDescription AS [Line Comments], 
	ROUND(il.Quantity * (i.PercentageSplit/100), 4) AS [Line Quantity], 
	il.UnitAmount AS [Line Unit Amount],
	ROUND(il.TotalAmount * (i.PercentageSplit/100), 2) AS [Line Total Amount],
	case il.Taxable when 1 then 'YES' else 'NO' end as [Line Sales Tax 1 Applied],
	case il.Taxable2 when 1 then 'YES' else 'NO' end as [Line Sales Tax 2 Applied],
	il.SalesTax1Amount AS [Line Sales 1 Tax Amount],
	il.SalesTax2Amount AS [Line Sales 2 Tax Amount], 
	il.SalesTaxAmount AS [Line Sales Tax Total Amount],
	case il.Entity
		when 'tItem' then 'Item'
		when 'tService' then 'Service'
		when 'tTitle' then 'Title'
		end as [Line Type],
	case il.Entity
		When 'tItem' then item.ItemID
		when 'tService' then s.ServiceCode
		when 'tTitle' then tt.TitleID
		End as [Line Item ID],
	case il.Entity
		When 'tItem' then item.ItemName
		when 'tService' then s.Description
		when 'tTitle' then tt.TitleName
		End as [Line Item Name],
	cl.ClassID as [Line Class ID],
	cl.ClassName as [Line Class Name],
	bi.WorkTypeName as [Billing Item],
	am.FirstName + ' ' + am.LastName as [Account Manager],
	glSales.AccountNumber + ' - ' + glSales.AccountName AS [Sales GL Account],
	glSales.AccountNumber  AS [Sales GL Account Number],
	app.FirstName + ' ' + app.LastName as [Invoice Approver],
	sales.FirstName + ' ' + sales.LastName as [Sales Person],
	p.ProjectNumber as [Line Project Number],
	p.ProjectName as [Line Project Name],
	p.ProjectNumber + ' - ' + p.ProjectName as [Line Project Full Name],
	p.ClientProjectNumber as [Line Client Project Number],
    CAST(p.Description as VARCHAR(4000)) as [Line Project Description],
	prt.ProjectTypeName as [Line Project Type],
	pbs.ProjectBillingStatus as [Project Billing Status],
	cp.CampaignID as [Campaign ID],
	cp.CampaignName as [Campaign Name],
	ct.CompanyTypeName as [Company Type],
	i.ContactName as [Printed Name],
	cbk.FirstName + ' ' + cbk.LastName as [Created By Name],
	u.FirstName + ' ' + u.LastName as [Client Primary Contact],
	u.Phone1 as [Client Primary Contact Phone1],
	u.Phone2 as [Client Primary Contact Phone2],
	u.Email as [Client Primary Contact Email],
	p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Estimate Total],
	(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed],
	glc.GLCompanyID as [Company ID],
	glc.GLCompanyName as [Company Name],
	pc.CompanyName as [Parent Company],
	o.OfficeID as [Office ID],
	o.OfficeName as [Office Name],
	d.DepartmentName as Department,
	t.TaskID AS [Task ID],
	t.TaskName as [Task Name],
	t.Description as [Task Description],
	(Select Max(c.CheckDate)
	From   tCheck c (nolock)
	Inner Join tCheckAppl ca (nolock) on ca.CheckKey = c.CheckKey
	Where ca.InvoiceKey = i.InvoiceKey
	And   ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.AmountReceived, 0) = 0
	) AS [Date Paid],
	bg.BillingGroupCode as [Billing Group Code],
	bg.Description as [Billing Group Description],
	p.ProjectKey,
	i.CurrencyID as [Currency],
	i.ExchangeRate as [Exchange Rate], 
	st1.SalesTaxID as [Sales Tax 1 Code],
	st2.SalesTaxID as [Sales Tax 2 Code],
	st1.SalesTaxName as [Sales Tax 1 Name],
	st2.SalesTaxName as [Sales Tax 2 Name],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN ab.State ELSE ad.State END
			AS [Company State],
	trs.RateSheetName as [Service Rate Sheet],
	irs.RateSheetName as [Item Rate Sheet],
	ttrs.RateSheetName as [Title Rate Sheet]
FROM 
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock)ON i.ParentInvoiceKey = il.InvoiceKey 
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey 
	LEFT OUTER JOIN tGLAccount glSales (nolock) ON il.SalesAccountKey = glSales.GLAccountKey
    LEFT OUTER JOIN tGLAccount glAR (nolock) ON i.ARAccountKey = glAR.GLAccountKey 
    LEFT OUTER JOIN tGLAccount glCL (nolock) ON c.DefaultSalesAccountKey = glCL.GLAccountKey 
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tProject pr (nolock) ON i.ProjectKey = pr.ProjectKey
    LEFT OUTER JOIN tUser bcu (nolock) on pr.BillingContact = bcu.UserKey 
    LEFT OUTER JOIN tProject p (nolock) ON il.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct pd (nolock) on p.ClientProductKey = pd.ClientProductKey
	LEFT OUTER JOIN tProjectType prt (nolock) on p.ProjectTypeKey = prt.ProjectTypeKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
	LEFT OUTER JOIN tUser u (nolock) on i.PrimaryContactKey = u.UserKey
	LEFT OUTER JOIN tUser app (nolock) on i.ApprovedByKey = app.UserKey
	LEFT OUTER JOIN tUser cbk (nolock) on i.CreatedByKey = cbk.UserKey
	LEFT OUTER JOIN tUser sales (nolock) on c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	LEFT OUTER JOIN tWorkType bi (nolock) on il.WorkTypeKey = bi.WorkTypeKey
	left outer join tClass cl (nolock) on il.ClassKey = cl.ClassKey
	left outer join tClass cl2 (nolock) on i.ClassKey = cl2.ClassKey
	Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	Left outer join tAddress ab (nolock) on c.BillingAddressKey = ab.AddressKey
	Left outer join tAddress ib (nolock) on i.AddressKey = ib.AddressKey
	LEFT OUTER Join tTask t (nolock) on il.TaskKey = t.TaskKey
	left outer join tGLCompany glc (nolock) on i.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on il.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on il.DepartmentKey = d.DepartmentKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tProjectBillingStatus pbs (nolock) on ISNULL(p.ProjectBillingStatusKey, pr.ProjectBillingStatusKey) = pbs.ProjectBillingStatusKey
	left outer join tService s (nolock) on il.EntityKey = s.ServiceKey AND il.Entity = 'tService'
	left outer join tItem item (nolock) on il.EntityKey = item.ItemKey AND il.Entity = 'tItem'
	left outer join tTitle tt (nolock) on il.EntityKey = tt.TitleKey AND il.Entity = 'tTitle'
	left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
	LEFT OUTER JOIN tSalesTax st1 (nolock) on i.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on i.SalesTax2Key = st2.SalesTaxKey
	left outer join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
	left outer join tItemRateSheet irs (nolock) on p.ItemRateSheetKey = irs.ItemRateSheetKey
	left outer join tTitleRateSheet ttrs (nolock) on p.TitleRateSheetKey = ttrs.TitleRateSheetKey

WHERE (il.LineType = 2)
GO
