USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_CCConnector]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_CCConnector]
AS

/*
  || When      Who Rel       What
  || 12/01/14  WDF 10.5.8.7  (236999) Created
  || 01/27/15  WDF 10.5.8.8  (Abelson Taylor) Added Division and Product
  || 02/23/15  WDF 10.5.8.9  (246193) Modified to show Vendor Invoices Paid
*/

SELECT  v.CompanyKey
	   ,p.ProjectKey
	   ,glc.GLCompanyKey
	   ,gl1.GLAccountKey
	   ,glc.GLCompanyID AS [GL_Company]
       ,bbu.FirstName + ' ' + bbu.LastName AS [Purchased By Name]
       ,v.BoughtFrom AS [Purchased From]
	   ,v.PostingDate AS [Posting Date]
	   ,v.VoucherID AS [Charge Reference Number]
	   ,cl.ClassID AS [Class ID]
	   ,cl.ClassName AS [Class Name]
	   ,c.CompanyName AS [Vendor Name]
	   ,c.VendorID AS [Vendor ID] 
	   ,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
	   ,v.InvoiceNumber AS [Invoice Number] 
	   ,v.DueDate AS [Due Date] 
	   ,v.InvoiceDate AS [Charge Date]
	   ,DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) AS [Discount Date]
	   ,v.DateReceived AS [Date Received]
	   ,v.DateCCUsed as [Date Credit Card Used]
	   ,v.Description AS [Voucher Description]
	   ,Case v.Status
		  When 1 Then 'Not Sent For Approval'
		  When 2 Then 'Sent For Approval'
		  When 3 Then 'Rejected'
		  When 4 Then 
			 Case v.Posted When 1 Then 'Posted' Else 'Approved Not Posted' End
	    End AS [Charge Status]
	   ,Case v.Posted When 1 Then 'YES' Else 'NO' End AS [Posted]
	   ,v.Downloaded
	   ,u.FirstName + ' ' + u.LastName AS [Approver Name]
	   ,v.ApprovalComments AS [Approval Comments]
	   ,ISNULL(v.VoucherTotal, 0) AS [Charge Amount]
	   ,v.AmountPaid AS [Charge Amount Paid]
	   ,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) AS [Open Amount]
	   ,v2.InvoiceNumber as [Vendor Invoice Number]
	   ,v2.InvoiceDate as [Vendor Invoice Date]
	   ,v2.DueDate as [Vendor Due Date]
	   ,v2.VoucherTotal as [Vendor Invoice Total]
	   ,vcc.Amount as [Applied Amount]
	   ,ISNULL(v2.VoucherTotal, 0) - ISNULL(v2.AmountPaid, 0) as [Unapplied Amount]
	   ,v2.Posted as [Vendor Invoice Posted] 
	   ,gl1.AccountNumber AS [AP Account Number]
	   ,gl1.AccountName AS [AP Account Name]
	   ,gl1.AccountNumber + ' - ' + gl1.AccountName AS [AP Account Full Name]
	   ,po.PurchaseOrderNumber AS [PurchaseOrder Number]
	   ,pod.LineNumber AS [PO Line Number]
	   ,ISNULL(pod.TotalCost, 0) AS [PO Total Cost]
	   ,ISNULL(pod.AppliedCost, 0) AS [PO Applied Cost]
	   ,p.ProjectNumber AS [Project Number]
	   ,p.ProjectNumber + ' ' + p.ProjectName AS [Full Project Name]
	   ,p.ProjectName AS [Project Name]
	   ,t.TaskID AS [Task ID]
	   ,t.TaskName AS [Task Name]
	   ,gl2.AccountNumber AS [Expense Account]
	   ,gl2.AccountName AS [Expense Account Name]
	   ,vd.LineNumber AS [Detail Line Number]
	   ,vd.ShortDescription AS [Short Description]
	   ,vd.Quantity
	   ,vd.UnitCost AS [Unit Cost]
	   ,vd.UnitDescription AS [Unit Description]
	   ,vd.TotalCost AS [Total Cost]
	   ,vd.Billable
	   ,vd.Markup
	   ,vd.BillableCost AS [Billable Cost]
	   ,vd.WriteOff AS [Write Off]
	   ,vd.DatePaidByClient AS [Date Paid By Client]
	   ,Case When ISNULL(vd.InvoiceLineKey, 0) = 0 then ''
		     else
			   (Select InvoiceNumber 
				  from tInvoice inner join tInvoiceLine on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey 
				  Where InvoiceLineKey = vd.InvoiceLineKey) 
		     end AS [Billing Invoice Number]
	   ,v.CurrencyID
	   ,vd.PCurrencyID
	   ,cd.DivisionID as [Client Division ID]
	   ,cd.DivisionName as [Client Division]
	   ,cp.ProductID as [Client Product ID]
	   ,cp.ProductName as [Client Product]
  FROM tVoucher v (nolock) INNER JOIN tCompany c (nolock) ON v.VendorKey = c.CompanyKey 
	                  LEFT OUTER JOIN tVoucherDetail vd (nolock) ON v.VoucherKey = vd.VoucherKey
	                  LEFT OUTER JOIN tVoucherCC vcc (nolock) ON v.VoucherKey = vcc.VoucherCCKey
					  LEFT OUTER JOIN tVoucher v2 (nolock) on vcc.VoucherKey = v2.VoucherKey
	                  LEFT OUTER JOIN tUser u (nolock) on v.ApprovedByKey = u.UserKey
	                  LEFT OUTER JOIN tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey
	                  LEFT OUTER JOIN tGLAccount gl1 (nolock) on v.APAccountKey = gl1.GLAccountKey
	                  LEFT OUTER JOIN tGLAccount gl2 (nolock) on vd.ExpenseAccountKey = gl2.GLAccountKey
	                  LEFT OUTER JOIN tClass cl (nolock) on vd.ClassKey = cl.ClassKey
	                  LEFT OUTER JOIN tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	                  LEFT OUTER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	                  LEFT OUTER JOIN tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	                  LEFT OUTER JOIN tTask t (nolock) on vd.TaskKey = t.TaskKey
	                  LEFT OUTER JOIN tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	                  LEFT OUTER JOIN tOffice o (nolock) on vd.OfficeKey = o.OfficeKey
	                  LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	                  LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
where v.CreditCard = 1
GO
