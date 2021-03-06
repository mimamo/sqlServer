USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Expenses]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Expenses]
AS

/*
|| When     Who Rel     What
|| 10/12/06 WES 8.3567  Added Approved By
|| 10/17/06 WES 8.3567  Added Markup, Unit Rate, expense type/ID and billable
|| 07/10/07 GHL 8.5     Added Voucher Created
|| 07/10/07 QMD 8.5     Expense Type reference changed to tItem
|| 10/11/07 CRG 8.5     Added GLCompany, Class, Department, Office
|| 06/18/09 RLB 10.5.0.0 (55283)change the inner join to an outer on items because they are not required
|| 09/10/09 GHL 10.5    Added Transferred Out
|| 01/11/10 RLB 10.516  Added Item Expense Account (71739)
|| 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
|| 04/20/10 RLB 10.521  (78891) Added Gross Amount
|| 04/24/12 GHL 10.555  Added GLCompanyKey (from user) to map/restrict
||                      p.GLCompanySource = 0 then p.GLCompanyKey
||                      p.GLCompanySource = 1 then u.GLCompanyKey
||                      p.GLCompanySource is null i.e. no project then u.GLCompanyKey
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 04/09/14 WDF 10.5.7.9 (211210) Added Envelope Comments
|| 04/10/14 WDF 10.5.7.9 (212646) Added Posting Date
|| 06/17/14 WDF 10.5.8.1 (218517) Added Vendor ID/Name
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
*/

SELECT ee.CompanyKey, 
    case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey,
    u.FirstName AS [User First Name], 
    u.LastName AS [User Last Name], 
    u.FirstName + ' ' + u.LastName AS [User Full Name],
    u.SystemID AS [User System ID], 
    u2.FirstName + ' ' + u2.LastName AS [Expense Approver], 
    ee.EnvelopeNumber AS [Envelope Number],
    ee.StartDate AS [Start Date], 
    ee.EndDate AS [End Date], 
    ee.DateCreated AS [Date Created], 
    ee.DateSubmitted AS [Date Submitted], 
    ee.DateApproved AS [Date Approved], 
    ee.ApprovalComments AS [Approval Comments],
    ee.Comments AS [Expense Envelope Comments],
    er.ExpenseDate AS [Expense Date], 
    item.ItemName AS [Expense Description], 
    p.ProjectNumber as [Project Number],
    p.ProjectName AS [Project Name],
	cp.CampaignName as [Campaign Name], 
    cl.CompanyName AS [Client Name], 
	cl.CustomerID as [Client ID],
	vend.VendorID as [Vendor ID],
	vend.CompanyName as [Vendor Name],
	vend.VendorID + ' - ' + vend.CompanyName as [Vendor Full Name],
    t.TaskID AS [Task ID], 
    t.TaskID + ' - ' +  t.TaskName AS [Task Description], 
    er.ActualQty AS [Actual Quantity], 
    er.ActualUnitCost AS [Actual Unit Cost], 
    er.ActualCost AS [Actual Total Cost], 
    er.Description AS [Expense Receipt Description],
    er.Comments AS [Expense Receipt Comments],
    ISNULL(er.AmountBilled, 0) AS [Amount Billed],
	er.BillableCost AS [Gross Amount],
	case when isnull(i.InvoiceStatus, 0) = 4 then isnull(er.AmountBilled, 0) else 0 end AS [Amount Billed Approved], 
	i.InvoiceNumber AS [Invoice Number],
	Case When er.WIPPostingInKey = 0 then 'NO' else 'YES' end as [Posted Into WIP],
	Case When er.WIPPostingOutKey = 0 then 'NO' else 'YES' end as [Posted Out Of WIP],
	ab.FirstName + ' ' + ab.LastName AS [Approved By],
	Case When er.Billable = 0 then 'NO' else 'YES' end as [Billable],
	er.Markup,
	er.UnitRate as [Unit Rate],
	item.ItemID as [Expense Type],
	gla.AccountNumber + ' - ' + gla.AccountName as [Item Expense Account],
	Case When er.VoucherDetailKey IS NULL  then 'NO' else 'YES' end as [Voucher Created]
	,case when p.GLCompanySource = 0 then glcP.GLCompanyID else glc.GLCompanyID end as [Company ID]
	,case when p.GLCompanySource = 0 then glcP.GLCompanyName else glc.GLCompanyName end as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
	,Case When er.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out]
	,p.ProjectKey
	,vk.PostingDate as [Posting Date]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,pc.ProductID as [Client Product ID]
    ,pc.ProductName as [Client Product]
From 
	tExpenseReceipt er (nolock)
	Inner Join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
	Inner join tUser u (nolock) on ee.UserKey = u.UserKey
	Inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	Left outer join tUser u2 (nolock) on u.ExpenseApprover = u2.UserKey
	Left Outer Join tProject p (nolock) on er.ProjectKey = p.ProjectKey
	Left Outer Join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompany vend (nolock) on ee.VendorKey = vend.CompanyKey
	Left Outer Join tTask t (nolock) on er.TaskKey = t.TaskKey
	Left Outer Join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
	Left Outer Join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Left Outer Join tItem item (nolock) on er.ItemKey = item.ItemKey
	Left OUTER JOIN tGLAccount gla (nolock) on item.ExpenseAccountKey = gla.GLAccountKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tVoucher vk (nolock) on ee.VoucherKey = vk.VoucherKey
	left outer join tUser ab (nolock) on vk.ApprovedByKey = ab.UserKey
	left outer join tClass cla (nolock) on i.ClassKey = cla.ClassKey
	LEFT OUTER JOIN tGLCompany glcP (nolock) ON p.GLCompanyKey = glcP.GLCompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON u.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on item.DepartmentKey = d.DepartmentKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  pc (nolock) on p.ClientProductKey  = pc.ClientProductKey
GO
