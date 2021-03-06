USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Voucher]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Voucher]
AS

/*
|| When     Who Rel    What
|| 01/10/07 BSH 8.4001 Added ApprovedDate
|| 10/11/07 CRG 8.5    Added GLCompany, Class, Office, Department
|| 04/16/07 GWG 10.23  Added Item Department. 
|| 05/11/07 GWG 10.025 Added several order line fields
|| 09/11/09 GHL 10.5   Added Transferred Out
|| 12/10/09 GHL 10.514 (68925) Added Estimate ID + Name
|| 01/19/10 GHL 10.517 (72527) Added Billing Item info
|| 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
|| 04/26/10 RLB 10.521  (78143) added custom fields for lines Project Client companies.
|| 04/30/10 RLB 10.522 (63218)Added Parent Company Name
|| 04/26/10 RLB 10.522  (78143) Client wanted Client contact customfields not company. (fixed to join on project billing contact to user)
|| 07/23/10 RLB 10.532 (81660) Added Project Primary Contact and Clients Project Number
|| 09/28/10 RLB 10.535 (91043) Added Opening Transaction to report
|| 10/25/10 RLB 10.537 (91944) Added Vendor and Client Custom fields to this report.
|| 02/22/11 RLB 10.541 (89417) Add Sales Tax line data
|| 08/22/11 GWG 10.547  Tweaked the definition of Sales tax applied to make sure a tax has been selecte and the box on the line is checked
|| 04/24/12 GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 11/08/12 RLB 10.5.6.2 (159062) Added Purchased By
|| 01/23/13 WDF 10.5.6.4 (165985) Added Expense Account Name
|| 06/24/13 RLB 10.5.6.9 (180813) Added voucher description field
|| 07/01/13 GHL 10.5.6.9 (182649) Added [Vendor Accepts CreditCard Cards]
|| 07/18/13 WDF 10.5.7.0 (176497) Added VoucherID
|| 09/03/13 GWG 10.5.7.1 Added fields to assist in Order Analysis
|| 09/09/13 GWG 10.5.7.1 Made the join to vendor left outer for reporting on credit cards
|| 11/15/13 GWG 10.5.7.4 Added client id through the estimate
|| 01/03/14 WDF 10.5.7.6 (188500) Added CreatedByKey and DateCreated
|| 02/05/14 WDF 10.5.7.7 (205342) Added Division Name and Product Name
|| 03/07/14 GHL 10.5.7.6   Added Currency
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
|| 03/10/15 WDF 10.5.9.0 (249110) Added TermsPercent, TermsDays and TermsNet
|| 03/11/15 RLB 10.5.9.0 (249671) Added WIP Posting In and Out Date
|| 03/13/15 RLB 10,5.9.0 (249671) Added WIP Issue In and Out
*/

SELECT 
	v.CompanyKey,
	isnull(vd.TargetGLCompanyKey, v.GLCompanyKey) as GLCompanyKey, 
	cc.CustomFieldKey,
	c.CustomFieldKey as CustomFieldKey2,
	cClient.CustomFieldKey as CustomFieldKey3,
	p.ProjectNumber AS [Project Number], 
	p.ProjectName AS [Project Name], 
	p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name],
	Case p.NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project],
	cc.FirstName + ' ' + cc.LastName AS [Project Primary Contact],
	p.ClientProjectNumber AS [Client Project Number],
	div.DivisionName AS [Division Name],
	div.DivisionID as [Division ID],
	pro.ProductName AS [Product Name],
	pro.ProductID as [Product ID],
	cp.CampaignName as [Campaign Name],
	cClient.CustomerID as [Client ID],
	cClient.CompanyName as [Client Name],
	cClient.CustomerID + ' - ' + cClient.CompanyName as [Client Full Name],
	meClient.CustomerID as [Estimate Client ID],
	meClient.CompanyName as [Estimate Client Name],
	meClient.CustomerID + ' - ' + meClient.CompanyName as [Estimate Client Full Name],
	t.TaskID AS [Task ID], 
	t.TaskID + ' - ' + t.TaskName AS [Task Full Name],
	c.CompanyName AS [Vendor Name], 
	c.VendorID AS [Vendor ID], 
	c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name],
	cbk.FirstName + ' ' + cbk.LastName as [Created By Name],
	case when c.CCAccepted = 1 then 'YES' else 'NO' end as [Vendor Accepts Credit Cards],   
	v.InvoiceDate AS [Invoice Date], 
	v.PostingDate AS [Posting Date],
	MONTH(v.PostingDate) as [Posting Month],
	YEAR(v.PostingDate) as [Posting Year],
	v.DateReceived as [Date Received],
	v.DueDate as [Invoice Due Date],
	v.InvoiceNumber AS [Invoice Number],
	v.VoucherID as [Unique Auto Number],
	v.ApprovedDate AS [Date Approved],
	v.DateCreated AS [Date Created], 
	v.Description AS [Header Description],
	u.FirstName + ' ' + u.LastName as [Approver Name],
	po.PurchaseOrderNumber AS [Purchase Order Number],
	pod.LineNumber as [Order Line Number],
	pod.AdjustmentNumber as [Order Line Adjustment Number],
	pod.TotalCost as [Order Line Net],
	pod.BillableCost as [Order Line Gross],
	pod.AmountBilled as [Order Line Amt Billed],
	pod.DetailOrderDate as [Order Line Start Date],
	pod.DetailOrderEndDate as [Order Line End Date],
	ISNULL(pod.AccruedCost, 0) as [Order Line Accrued Cost],
	Case po.BillAt When 0 then 'Gross'
		When 1 then 'Net'
		When 2 then 'Commission' end as [Order Bill At],
	case when vd.Taxable = 1 and v.SalesTaxKey > 0 then 'YES' else 'NO' end as [Line Sales Tax 1 Applied],
	case when vd.Taxable2 = 1 and v.SalesTax2Key > 0 then 'YES' else 'NO' end as [Line Sales Tax 2 Applied],
	vd.SalesTax1Amount as [Line Sales 1 Tax Amount],
	vd.SalesTax2Amount as [Line Sales 2 Tax Amount],
	vd.SalesTaxAmount as [Line Sales Tax Total Amount],
	vd.ShortDescription AS [Line Description], 
	vd.Quantity AS [Line Quantity], 
	vd.UnitCost AS [Line Unit Cost], 
	vd.UnitDescription AS [Line Unit Description], 
	vd.TotalCost AS [Line Net Cost], 
	vd.LastVoucher as [Last Invoice for Order],
	ISNULL(vd.PrebillAmount, 0) as [Amount Unaccrued],
	(Select SUM(ISNULL(PrebillAmount, 0)) from tVoucherDetail Where PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey) as [Order Line Unaccrued All Invoices],
	(Select MAX(PostingDate) from tVoucherDetail 
		inner join tVoucher on tVoucherDetail.VoucherKey = tVoucher.VoucherKey
		Where PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey and ISNULL(PrebillAmount, 0) <> 0) as [Order Line Last Unaccrue Date],
	case vd.Billable when 1 then 'YES' else 'NO' end as Billable,
	vd.Markup, 
	vd.BillableCost AS [Line Gross Amount], 
	vd.AmountBilled AS [Line Amount Billed], 
	case when isnull(i.InvoiceStatus, 0) = 4 then isnull(vd.AmountBilled, 0) else 0 end AS [Line Amount Billed Approved], 
	vd.DatePaidByClient as [Date Paid by Client],
	it.ItemID as [Line Item ID],
	it.ItemName as [Line Item Name],
	i.InvoiceNumber as [Line Invoice Number],
	i.PostingDate as [Client Invoice Posting Date],
	MONTH(i.PostingDate) as [Client Invoice Posting Month],
	YEAR(i.PostingDate) as [Client Invoice Posting Year],
	gl.AccountNumber as [AP Account Number],
	gl2.AccountNumber as [Expense Account Number],
	gl2.AccountName as [Expense Account Name],
	Case When vd.InvoiceLineKey IS NULL then
		Case vd.WriteOff When 1 then 'Write Off' else 'Unbilled' end
		When vd.InvoiceLineKey = 0 then 'Marked as Billed'
		else 'Billed' end as [Billing Status],
	case vd.WriteOff when 1 then 'YES' else 'NO' end as WriteOff, 
	case v.Posted when 1 then 'YES' else 'NO' end as Posted,
	case v.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction],
	Case v.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case v.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Invoice Status],
	Case When vd.WIPPostingInKey = 0 then 'NO' else 'YES' end as [Posted Into WIP],
	Case When vd.WIPPostingOutKey = 0 then 'NO' else 'YES' end as [Posted Out Of WIP],
	wpi.PostingDate as [WIP Posting In Date],
	CASE 
		WHEN wpi.PostingDate IS NOT NULL THEN
			case 
				when MONTH(v.PostingDate) = Month(wpi.PostingDate) AND YEAR(v.PostingDate) = YEAR(wpi.PostingDate) then 'No'
				else 'Yes' End
		ELSE 'No'
	END as [WIP In Issue],
	wpo.PostingDate as [WIP Posting Out Date],
	CASE 
		WHEN wpo.PostingDate IS NOT NULL THEN
			case 
				when MONTH(vd.DateBilled) = Month(wpo.PostingDate)  AND YEAR(vd.DateBilled) = YEAR(wpo.PostingDate) then 'No'
				else 'Yes' End
		ELSE 'No'
	END as [WIP Out Issue],
	vd.DateBilled as [Date Billed],
	Month(vd.DateBilled) as [Month Billed],
	Year(vd.DateBilled) as [Year Billed],
	isnull(glcT.GLCompanyID, glc.GLCompanyID) as [Company ID], 
	isnull(glcT.GLCompanyName, glc.GLCompanyName) as [Company Name], 
	pc.CompanyName as [Parent Company],
	cl.ClassID as [Class ID],
	cl.ClassName as [Class Name],
	o.OfficeID as [Office ID],
	o.OfficeName as [Office Name],
	d.DepartmentName as [Line Department],
	id.DepartmentName as [Item Department],
    case when vd.TransferToKey is null then 'NO' else 'YES' end as [Transferred Out],
    me.EstimateID as [Media Estimate ID],
    me.EstimateName as [Media Estimate Name]
    ,case when p.LayoutKey is not null then wt.WorkTypeID 
	      else wti.WorkTypeID 
     end as [Billing Item ID] 
    ,case when p.LayoutKey is not null then isnull(wtcust.Subject, wt.WorkTypeName) 
	      else isnull(wtcusti.Subject, wti.WorkTypeName)  
     end as [Billing Item Name] 
	,case when v.CreditCard = 1 then 'Credit Card Charge' else 'Vendor Invoice' end as [Type of Voucher]
	,v.BoughtFrom as [Purchased From]
	,pb.FirstName + ' ' + pb.LastName as [Purchased By]
	,p.ProjectKey
	,v.CurrencyID as [Currency]
	,v.TermsDays as [Terms Days]
	,v.TermsNet as [Terms Net]
	,v.TermsPercent as [Terms Percent]
From
	tVoucher v (nolock)
	Inner Join tVoucherDetail vd (nolock) on v.VoucherKey = vd.VoucherKey
	left outer Join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left outer join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	LEFT OUTER JOIN tUser cbk (nolock) on v.CreatedByKey = cbk.UserKey
	Left Outer Join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	Left Outer Join tClientDivision div (nolock) on div.ClientDivisionKey = p.ClientDivisionKey
	Left Outer Join tClientProduct pro (nolock) on pro.ClientProductKey = p.ClientProductKey
	Left Outer Join tTask t (nolock) on vd.TaskKey = t.TaskKey
	Left Outer Join tItem it (nolock) on vd.ItemKey = it.ItemKey
	Left Outer Join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	Left Outer Join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
    Left Outer Join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey 
	Left Outer Join tCompany cClient (nolock) on p.ClientKey = cClient.CompanyKey
	Left Outer Join tCompany meClient (nolock) on me.ClientKey = meClient.CompanyKey
	Left Outer Join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
	Left Outer Join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	Left outer join tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
	left outer join tGLAccount gl2 (nolock) on vd.ExpenseAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on vd.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left outer join tGLCompany glcT (nolock) on vd.TargetGLCompanyKey = glcT.GLCompanyKey
	left outer join tOffice o (nolock) on vd.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on vd.DepartmentKey = d.DepartmentKey
	left outer join tDepartment id (nolock) on it.DepartmentKey = id.DepartmentKey 
	left outer join tWIPPosting wpi (nolock) on vd.WIPPostingInKey = wpi.WIPPostingKey
	left outer join tWIPPosting wpo (nolock) on vd.WIPPostingOutKey = wpo.WIPPostingKey
	
    left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity = 'tItem' and lb.EntityKey = vd.ItemKey
    left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

	left outer join tWorkType wti (nolock) on it.WorkTypeKey = wti.WorkTypeKey 
	left outer join tWorkTypeCustom wtcusti (nolock) on it.WorkTypeKey = wtcusti.WorkTypeKey and wtcusti.Entity = 'tProject' and wtcusti.EntityKey = p.ProjectKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tUser cc (nolock) on p.BillingContact = cc.UserKey
	left outer join tUser pb (nolock) on v.BoughtByKey = pb.UserKey
GO
