USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vVoucherDetail]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE           View [dbo].[vVoucherDetail]

as

/*
|| When      Who Rel      What
|| 07/12/13  WDF 10.5.7.0 (176497) Added VoucherID
|| 01/23/14  GHL 10.5.7.6  Added Currency ID
*/

SELECT v.CompanyKey
	,v.VoucherKey
	,v.VendorKey
	,v.VoucherID
	,v.APAccountKey
	,c.VendorID
	,c.CompanyName as VendorName
	,c.VendorID + ' - ' + c.CompanyName as VendorFullName
	,v.InvoiceNumber
	,v.DueDate
	,v.InvoiceDate
	,DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) as DiscountDate
	,v.DateReceived
	,v.Description as VoucherDescription
	,v.Status
	,v.Posted
	,v.Downloaded
	,v.ApprovedByKey
	,v.ApprovalComments
	,ISNULL(v.VoucherTotal, 0) as VoucherTotal
	,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as OpenAmount
	,gl1.AccountNumber as APAccountNumber
	,gl1.AccountName as APAccountName
	,gl1.AccountNumber + ' - ' + gl1.AccountName as APAccountFullName
	,v.ClassKey as APClassKey
	,vd.LineNumber
	,po.PurchaseOrderNumber
	,pod.LineNumber as POLineNumber
	,ISNULL(pod.TotalCost, 0) as POTotalCost
	,ISNULL(pod.AppliedCost, 0) as POAppliedCost
	,p.ProjectNumber
	,p.ProjectName
	,t.TaskID
	,t.TaskName
	,cl.ClassID
	,glc.GLCompanyKey
	,o.OfficeKey
	,gl2.AccountNumber as ExpenseAccountNumber
	,gl2.AccountName as ExpenseAccountName
	,vd.ShortDescription
	,vd.Quantity
	,vd.UnitCost
	,vd.UnitDescription
	,vd.TotalCost
	,vd.Billable
	,vd.Markup
	,vd.BillableCost
	,vd.InvoiceLineKey
	,vd.WriteOff
	,vd.VoucherDetailKey
	,vd.DatePaidByClient
	,Case When ISNULL(vd.InvoiceLineKey, 0) = 0 then ''
		else
			(Select InvoiceNumber 
				from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				Where InvoiceLineKey = vd.InvoiceLineKey) 
		end as BillingInvoiceNumber
	,v.CurrencyID
	,vd.PCurrencyID
FROM 
	tVoucher v (nolock)
	INNER JOIN tCompany c (nolock) ON v.VendorKey = c.CompanyKey 
	left outer join tVoucherDetail vd (nolock) ON v.VoucherKey = vd.VoucherKey
	left outer join tGLAccount gl1 (nolock) on v.APAccountKey = gl1.GLAccountKey
	left outer join tGLAccount gl2 (nolock) on vd.ExpenseAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on vd.ClassKey = cl.ClassKey
	left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
	left outer join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on vd.OfficeKey = o.OfficeKey




--select * from vVoucherDetail
GO
