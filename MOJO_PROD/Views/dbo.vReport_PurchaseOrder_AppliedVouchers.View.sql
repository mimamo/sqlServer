USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_PurchaseOrder_AppliedVouchers]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_PurchaseOrder_AppliedVouchers]
AS

/*
|| 09/29/10 RLB 10.5.3.6 (90687)created for this issue
|| 01/12/11 RLB 10.5.4.0 (90687) added per client request
|| 04/07/11 RLB 10.543 (108045) Removed Project Short Name
|| 04/24/12 GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 10/13/13 GWG 10.5.7.2 added the posting date and invoice number 
|| 01/27/15  WDF 10.588 (Abelson Taylor) Added Division and Product
|| 12/29/14 GHL 10.587 (240381) When calculating AmountBilled, check that InvoiceLineKey > 0
*/

SELECT 
	 po.CompanyKey
	,po.GLCompanyKey
	,pod.CustomFieldKey
	,p.ProjectKey
    ,po.PurchaseOrderNumber AS [PO Number]
    ,c.VendorID AS [Vendor ID]
    ,c.CompanyName AS [Vendor Name]
    ,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
    ,po.Contact AS [Vendor Contact]
    ,po.Address1 AS [Address 1]
    ,po.Address2 AS [Address 2]
    ,po.Address3 AS [Address 3]
    ,po.City AS [Address City]
    ,po.State AS [Address State]
    ,po.PostalCode AS [Address Postal Code]
    ,po.Country AS [Address Country]
    ,po.DateCreated AS [Date Created]
    ,po.PODate AS [PO Date]
    ,po.DueDate AS [Due Date]
    ,po.OrderedBy AS [Ordered By]
    ,po.SpecialInstructions AS [Special Instructions]
    ,po.DeliveryInstructions AS [Delivery Instructions]
    ,po.DeliverTo1 AS [Deliver To 1]
    ,po.DeliverTo2 AS [Deliver To 2]
    ,po.DeliverTo3 AS [Deliver To 3]
    ,po.DeliverTo4 AS [Deliver To 4]
    ,po.Revision AS [PO Revision Number]
    ,po.ApprovedDate AS [Approved Date]
    ,u.FirstName + ' ' + u.LastName AS [Approved By]
    ,Case When po.Closed = 1 then 'Closed' else 
		case po.Status 
			when 1 then 'Not Sent For Approval'
			when 2 then 'Sent for Approval'
			when 3 then 'Rejected'
			when 4 then 'Open Approved' end 
		end as [Status]
    ,case po.Closed when 1 then 'YES' else 'NO' end as [Closed]
    ,case pod.Closed when 1 then 'YES' else 'NO' end as [Line Closed]
    ,case po.Downloaded when 1 then 'YES' else 'NO' end as [Downloaded]
    ,pod.LineNumber AS [Line Number]
    ,pod.AdjustmentNumber AS [Line Adjustment Number]
    ,p.ProjectName AS [Line Project Name]
    ,p.ProjectNumber AS [Line Project Number]
    ,p.ProjectNumber + ' - ' + p.ProjectName AS [Line Project Full Name]
	,cp.CampaignName as [Campaign Name]
    ,t.TaskID AS [Line Task ID]
    ,t.TaskName AS [Line Task Name]
    ,t.TaskID + ' - ' + t.TaskName AS [Line Task Full Name]
    ,pod.ShortDescription AS [Line Short Description]
    ,pod.LongDescription AS [Line Long Description]
	,i.ItemID as [Line Item ID]
	,i.ItemName as [Line Item Name]
	,gla.AccountNumber + ' - ' + gla.AccountName as [Item Expense Account]
    ,pod.Quantity AS [Line Quantity]
    ,pod.UnitCost AS [Line Unit Cost]
    ,pod.UnitDescription AS [Line Unit Description]
    ,pod.TotalCost AS [Line Total Cost]
	,pod.AccruedCost as [Line Accrued Cost]
	,pod.TotalCost - ISNULL(pod.AccruedCost, 0) as [Line Accrued Cost Difference]
    ,ISNULL(pod.AppliedCost, 0) AS [Applied Invoices]
	,pod.TotalCost - ISNULL(pod.AppliedCost, 0) AS [Remaining PO Amount]
    ,case pod.Billable when 1 then 'YES' else 'NO' end as [Billable]
    ,case pod.Markup when 1 then 'YES' else 'NO' end as [Markup]
    ,pod.BillableCost AS [Line Total Amount Billable]
    ,case when pod.InvoiceLineKey > 0 then ISNULL(pod.AmountBilled, 0) else 0 end as [Line Total Amount Billed]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
    ,client.CustomerID AS [Client ID]
    ,client.CompanyName AS [Client Name]
	,pc.CompanyName as [Parent Company]
	,Case When pod.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out]

    ,case when p.LayoutKey is not null then wt.WorkTypeID 
	      else wti.WorkTypeID 
     end as [Billing Item ID] 
    ,case when p.LayoutKey is not null then isnull(wtcust.Subject, wt.WorkTypeName) 
	      else isnull(wtcusti.Subject, wti.WorkTypeName)  
     end as [Billing Item Name]
     ,vdgla.AccountNumber + ' ' + vdgla.AccountName as [Vendor Invoice Line GL Account]
     ,vgla.AccountNumber + ' ' + vgla.AccountName as [Vendor Invoice AP Account]
     ,vd.Quantity as [Vendor Invoice Line Quantiy]
     ,v.InvoiceNumber as [Vendor Invoice Number]
     ,v.VoucherTotal as [Vendor Invoice Total]
     
     ,vd.TotalCost as [Vendor Invoice Line Total Cost]
     ,ISNULL(vd.AmountBilled, 0) as [Vendor Line Total Amount Billed]
     ,v.InvoiceDate as [Vendor Invoice Date]
     ,vd.ShortDescription as [Vendor Line Short Description]
     ,vd.DatePaidByClient as [Vendor line Paid By Client]
     ,vd.DateBilled as [Vendor Line Date Billed]
    ,pod.AccruedCost as [Amount Accrued]
     ,inv.PostingDate as [Date Accrued]
     ,Month(inv.PostingDate) as [Month Accrued]
     ,Year(inv.PostingDate) as [Year Accrued]
     ,inv.InvoiceNumber as [Invoice Billed On]
     ,inv.PostingDate as [Order Invoice Date Posted]
     ,inv2.InvoiceNumber as [Voucher Invoice Billed On]
     
     ,Case When inv.Posted = 0 Then 'NO' else 'YES' end as [Accruing Client Invoice Posted]
     ,vd.PrebillAmount as [Amount Unaccrued]
     ,v.PostingDate as [Date Unaccrued]
     ,Month(v.PostingDate) as [Month Unaccrued]
     ,Year(v.PostingDate) as [Year Unaccrued]
     ,Case When v.Posted = 0 Then 'NO' else 'YES' end as [Unaccruing Vendor Invoice Posted]
     ,cm.Name as [Pub or Station Name]
     ,me.EstimateID as [Media Estimate ID]
     ,me.EstimateName as [Media Estimate Name]
     ,mec.CustomerID as [Media Estimate Client ID]
     ,mec.CompanyName as [Media Estimate Client Name]
	 ,cd.DivisionID as [Client Division ID]
     ,cd.DivisionName as [Client Division]
     ,cpr.ProductID as [Client Product ID]
     ,cpr.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
	INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on po.ApprovedByKey = u.UserKey 
	LEFT OUTER JOIN tTask t (nolock) ON pod.TaskKey = t.TaskKey 
	LEFT OUTER JOIN tProject p (nolock) ON pod.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tItem i (nolock) on pod.ItemKey = i.ItemKey
	Left OUTER JOIN tGLAccount gla (nolock) on i.ExpenseAccountKey = gla.GLAccountKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tCompany client (nolock) ON p.ClientKey = client.CompanyKey

    left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity = 'tItem' and lb.EntityKey = pod.ItemKey
    left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

	left outer join tWorkType wti (nolock) on i.WorkTypeKey = wti.WorkTypeKey 
	left outer join tWorkTypeCustom wtcusti (nolock) on i.WorkTypeKey = wtcusti.WorkTypeKey and wtcusti.Entity = 'tProject' and wtcusti.EntityKey = p.ProjectKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	left outer join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tGLAccount vdgla (nolock) on vd.ExpenseAccountKey = vdgla.GLAccountKey
	left outer join tGLAccount vgla (nolock) on v.APAccountKey = vgla.GLAccountKey
	left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
	left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
	left outer join tInvoiceLine il2 (nolock) on vd.InvoiceLineKey = il2.InvoiceLineKey
	left outer join tInvoice inv2 (nolock) on il2.InvoiceKey = inv2.InvoiceKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	left outer join tCompany mec (nolock) on me.ClientKey = mec.CompanyKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
GO
