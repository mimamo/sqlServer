USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Invoice_Transactions]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Invoice_Transactions]
AS

/*
|| When     Who Rel    What
|| 10/12/06 WES 8.3567 Added Amount Advance Billed, Estimate Total
|| 03/19/07 GHL 8.408  Added Emailed
|| 03/26/07 RTC 8.4.1  (7972) Added the client division and product from the invoice detail project.
|| 05/18/07 GHL 8.5    Merged vReport_Invoice and vReport_Transactions
|| 10/11/07 CRG 8.5    Fixed Header Class join
||                     Added Office, Department and GLCompany
|| 11/07/07 CRG 8.5    (10950) Added Billing Item ID
|| 11/7/07  GWG 8.5	   Added transaction project type
|| 01/11/08 GHL 8.501  (19211) Added Task info 
|| 09/24/08 GHL 10.009 (35422) Getting now SalesAccountKey from service or item instead of invoice line
|| 02/24/09 GWG 10.020 Added the billed difference column
|| 03/17/09  RTC 10.5	  Removed user defined fields.
|| 8/13/09  GWG 10.5.06  Added Sales person to the list
|| 10/13/09 GHL 10.512 (64451) Added Vendor ID and Name
|| 10/30/09 GWG 10.5.1.3 Added Task Description
|| 11/02/09 GHL 10.5.1.3 Added Order Number
|| 12/10/09 GHL 10.514 (68925) Added Estimate ID + Name
|| 01/06/10 RLB 10.516   Added Task Type
|| 03/14/11 GHL 10.542 (105923) Added invoice info such as InvoiceKey, InvoiceNumber to vProjectTransPOInvoice to force IX_tTime_3
||                      Found out that if InvoiceNumber is pulled from vReport_Invoice_Transactions, there is table scan on tTime
||                      If InvoiceNumber is pulled in vProjectTransPOInvoice, there is no table scan on tTime
|| 07/28/11 GHL 10.546  (111859) Added custom fields # 2 and Parent Company Name
|| 04/24/12 GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 03/22/13 WDF 10.5.6.6 (172390) Added BilledComment
|| 11/06/14 GHL 10.5.8.6 (230365) Added currency and exchange rate
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
|| 01/28/15 GHL 10.5.5.8 Added Title data for Abelson
*/

SELECT 
	pti.CompanyKey, 
	pti.GLCompanyKey, 
	p.CustomFieldKey,
	c.CustomFieldKey as CustomFieldKey2,
	cd.DivisionName as [Division Name],
	cd.DivisionID as [Division ID],
	pd.ProductName as [Product Name],
	pd.ProductID as [Product ID],
	pti.InvoiceNumber AS [Invoice Number], 
	pti.InvoiceDate AS [Invoice Date], 
	pti.PostingDate as [Posting Date],
	pti.DueDate AS [Due Date], 
	case pti.AdvanceBill when 1 then 'YES' else 'NO' end as [Advance Billing Invoice],
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
	pti.ClientName AS [Client Name], 
	pti.CustomerID AS [Client ID], 
	pti.CustomerID + ' - ' + pti.ClientName AS [Client Full Name], 
	pti.ContactName as [Bill To Contact],
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
	pc.CompanyName as [Parent Company Name],
	pt.TermsDescription AS Terms, 
	glAR.AccountNumber + ' - ' + glAR.AccountName AS [AR Account], 
	pr.ProjectNumber as [Project Number],
	pr.ProjectName as [Project Name],
	pr.ProjectNumber + ' - ' + pr.ProjectName as [Project Full Name],
	pr.ClientProjectNumber as [Client Project Number],
	i.WriteoffAmount AS [Invoice Writeoff Amount], 
	i.RetainerAmount AS [Invoice Adv Bill Amount], 
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(RetainerAmount, 0) as [Amount Open],
	i.HeaderComment AS [Invoice Comment], 
	i.ApprovalComments as [Approval Comments],
	cl2.ClassID as [Header Class ID],
	cl2.ClassName as [Header Class Name],
	ISNULL(i.InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = i.InvoiceKey),0) as [Advance Bill Unapplied],
	ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = i.InvoiceKey),0) as [Applied Advance Billings],
	Case pti.InvoiceStatus
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case pti.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Invoice Status],
	case i.Downloaded when 1 then 'YES' else 'NO' end as Downloaded, 
	case pti.Posted when 1 then 'YES' else 'NO' end as Posted,
	case i.Printed when 1 then 'YES' else 'NO' end as Printed, 
	case i.Emailed when 1 then 'YES' else 'NO' end as Emailed, 
	il.LineSubject AS [Line Description], 
	il.LineDescription AS [Line Comments], 
	il.Quantity AS [Line Quantity], 
	il.UnitAmount AS [Line Unit Amount], 
	il.TotalAmount AS [Line Total Amount],
	cl.ClassID as [Line Class ID],
	cl.ClassName as [Line Class Name],
	bi.WorkTypeName as [Billing Item],
	am.FirstName + ' ' + am.LastName as [Account Manager],
	glSales.AccountNumber + ' - ' + glSales.AccountName AS [Sales GL Account],
    glSales.AccountNumber AS [Sales GL Account Number],
	u.FirstName + ' ' + u.LastName as [Invoice Approver],
	p.ProjectNumber as [Line Project Number],
	p.ProjectName as [Line Project Name],
	p.ProjectNumber + ' - ' + p.ProjectName as [Line Project Full Name],
	p.ClientProjectNumber as [Line Client Project Number],
	prt.ProjectTypeName as [Line Project Type],
	cp.CampaignName as [Campaign Name],
	cp.CampaignID as [Campaign ID],
	ct.CompanyTypeName as [Company Type],
	pti.ContactName as [Printed Name],
	pti.PrimaryContactName as [Client Primary Contact],
	sales.FirstName + ' ' + sales.LastName as [Sales Person],
	p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Estimate Total],
	(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey Where tInvoice.AdvanceBill = 1 and tInvoiceLine.ProjectKey = p.ProjectKey) as [Amount Advance Billed]

	,pti.TransactionDate as [Transaction Date]
	,pti.Type as [Transaction Type]
	,pti.ItemID as [Transaction Item ID]
	,pti.ItemName as [Transaction Item Name]
	,pti.Quantity as [Transaction Quantity]
	,pti.UnitCost as [Transaction Unit Amount]
	,pti.TotalCost as [Transaction Total Amount]
	,pti.BillableCost as [Transaction Billable Amount]
	,ISNULL(pti.AmountBilled, 0) as [Transaction Amount Billed]
	,pti.Description as [Transaction Description]
	,pti.Comments as [Transaction Comments]
	,pti.BilledDifference as [Transaction Billed Difference]
	,p2.ProjectNumber as [Transaction Project Number]
	,p2.ProjectName as [Transaction Project Name]
	,p2.ProjectNumber + ' - ' + p2.ProjectName as [Transaction Project Full Name]
	,p2pt.ProjectTypeName as [Transaction Project Type]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
	,CASE il.Entity
		WHEN 'tService' THEN s.ServiceCode
		WHEN 'tItem' THEN item.ItemID
		ELSE NULL
	END AS [Billing Item ID]
	,t.TaskID AS [Task ID]
	,t.TaskName as [Task Name]
	,tat.TaskAssignmentType as [Task Type]
	,t.Description as [Task Description]
    ,pti.VendorID as [Vendor ID]
    ,pti.VendorName as [Vendor Name]
    ,pti.PurchaseOrderNumber as [Order Number] 
    ,pti.MediaEstimateID as [Media Estimate ID]
    ,pti.MediaEstimateName as [Media Estimate Name]
    ,pti.BilledComment as [Billed Comment]
    ,p.ProjectKey
    ,i.CurrencyID as [Currency]
    ,i.ExchangeRate as [Exchange Rate]
	,trs.RateSheetName as [Service Rate Sheet]
	,irs.RateSheetName as [Item Rate Sheet]
	,pti.TitleName as [Billing Title Name]
	,pti.TitleID as [Billing Title ID]
FROM 
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock)ON i.InvoiceKey = il.InvoiceKey 
	INNER JOIN vProjectTransPOInvoice pti (nolock) on pti.InvoiceLineKey = il.InvoiceLineKey
	INNER JOIN tCompany c (nolock) ON pti.ClientKey = c.CompanyKey 
	LEFT OUTER JOIN tCompany pc (nolock) ON c.ParentCompanyKey = pc.CompanyKey 
    LEFT OUTER JOIN tGLAccount glSales (nolock) ON pti.SalesAccountKey = glSales.GLAccountKey
    LEFT OUTER JOIN tGLAccount glAR (nolock) ON i.ARAccountKey = glAR.GLAccountKey 
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tProject pr (nolock) ON i.ProjectKey = pr.ProjectKey
    LEFT OUTER JOIN tProject p (nolock) ON il.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct pd (nolock) on p.ClientProductKey = pd.ClientProductKey
	LEFT OUTER JOIN tProjectType prt (nolock) on p.ProjectTypeKey = prt.ProjectTypeKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
	LEFT OUTER JOIN tUser u (nolock) on i.PrimaryContactKey = u.UserKey
	--LEFT OUTER JOIN tUser pc (nolock) on c.PrimaryContact = pc.UserKey
	LEFT OUTER JOIN tUser sales (nolock) on c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	LEFT OUTER JOIN tWorkType bi (nolock) on il.WorkTypeKey = bi.WorkTypeKey
	left outer join tClass cl (nolock) on il.ClassKey = cl.ClassKey
	left outer join tClass cl2 (nolock) on i.ClassKey = cl2.ClassKey
	Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	Left outer join tAddress ab (nolock) on c.BillingAddressKey = ab.AddressKey
	Left outer join tAddress ib (nolock) on i.AddressKey = ib.AddressKey
	LEFT OUTER JOIN tProject p2 (nolock) ON pti.ProjectKey = p2.ProjectKey
	LEFT OUTER Join tTask t (nolock) on pti.TaskKey = t.TaskKey
	LEFT OUTER JOIN tTaskAssignmentType tat (nolock) on t.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
	LEFT OUTER JOIN tProjectType p2pt (nolock) on p2.ProjectTypeKey = p2pt.ProjectTypeKey
	left outer join tGLCompany glc (nolock) on pti.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on il.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on il.DepartmentKey = d.DepartmentKey
	left outer join tService s (nolock) on il.EntityKey = s.ServiceKey AND il.Entity = 'tService'
	left outer join tItem item (nolock) on il.EntityKey = item.ItemKey AND il.Entity = 'tItem'
	left outer join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
	left outer join tItemRateSheet irs (nolock) on p.ItemRateSheetKey = irs.ItemRateSheetKey
WHERE (il.LineType = 2)
GO
