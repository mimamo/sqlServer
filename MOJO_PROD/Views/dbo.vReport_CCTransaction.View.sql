USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_CCTransaction]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_CCTransaction]
AS

/*
	This view shows Entries in the Credit Card Connector. Not actual credit card charges
  || When      Who Rel       What
  || 07/24/13  WDF 10.5.7.0  Created
  || 12/02/13  WDF 10.5.7.4  Added Approved By and Approval Status
  || 01/27/15  WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
  || 03/10/15  WDF 10.5.9.0 (242377) Added [Transfer Out]
*/

SELECT 
    cc.CompanyKey
   ,cc.ProjectKey
   ,cc.GLAccountKey
   ,cc.GLCompanyKey
   ,cc.Amount as [Amount]
   ,cc.PayeeName as [Payee Name]
   ,cc.TransactionDate as [Transaction Date]
   ,cc.TransactionPostedDate as [Transaction Posted Date]
   ,cc.TransactionType as [Transaction Type]
   ,cc.FITID as [FITID]
   ,cc.Overhead as [Overhead]
   ,cc.Receipt as [Receipt]
   ,gl.AccountNumber as [GL Account Number]
   ,gl.AccountName as [GL Account Name]
   ,gl.AccountNumber + ' - ' + gl.AccountName as [GL Account Name Full]
   ,Case When cc.Billable = 1 then 'YES' else 'NO' end as [Billable]
   ,Case WHEN ISNULL(cc.CCVoucherKey, 0) = 0 then 'NO' else 'YES' end as [Transaction Cleared]
   ,cc.Memo as [Memo]
   ,cc.OriginalMemo as [Original Memo]
   ,ta.TaskID as [Task ID]
   ,ta.TaskName as [Task Name]
   ,ta.TaskID + ' ' + ta.TaskName as [Task Full Name]
   ,p.ProjectNumber as [Project Number]
   ,p.ProjectName as [Project Name]
   ,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
   ,case (Select COUNT(*)
			from tVoucherDetail (nolock)
		   where VoucherKey = v.VoucherKey
			 and ProjectKey = cc.ProjectKey
			 and ISNULL(TransferToKey, 0) > 0)
		when 0 then 'NO'
		else 'YES'
	end as [Transfer Out]
   ,i.ItemID as [Item ID]
   ,i.ItemName as [Item Name]
   ,i.ItemID + ' ' + i.ItemName as [Item Full Name]
   ,o.OfficeID as [Office ID]
   ,o.OfficeName as [Office Name]
   ,o.OfficeID + ' ' + o.OfficeName as [Office Full Name]
   ,cl.ClassID as [Class ID]
   ,cl.ClassName as [Class Name]
   ,cl.ClassID + ' ' + cl.ClassName as [Class Full Name]
   ,d.DepartmentName as [Department Name]
   ,glc.GLCompanyID as [Company]
   ,c.VendorID as [Vendor ID]
   ,c.CompanyName AS [Vendor Name]
   ,c.VendorID + ' ' + c.CompanyName as [Vendor Full Name]
   ,ea.AccountName as [Expense Account Name]
   ,LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName,''))) As [Charged By]
   ,v.InvoiceNumber as [Invoice Number]
   ,u2.FirstName + ' ' + u2.LastName as [Approved By Name]
   ,case isnull(v.Status, 0)
		when 1 then 'Unapproved'
		when 2 then 'Submitted for Approval'
		when 3 then 'Rejected'
		when 4 then 'Approved'
		else Null
	end as [Approval Status]
   ,st.SalesTaxID as [Sales Tax ID]
   ,st.SalesTaxName as [Sales Tax Name]
   ,st.SalesTaxID + ' ' + st.SalesTaxName as [Sales Tax Full Name]
   ,st2.SalesTaxID as [Sales Tax2 ID]
   ,st2.SalesTaxName as [Sales Tax2 Name]
   ,st2.SalesTaxID + ' ' + st2.SalesTaxName as [Sales Tax2 Full Name]
   ,case isnull(cc.CCVoucherKey, 0)
		when -1 then 'Marked as Processed'
		when 0 then 'Unprocessed'
		else 'Processed'
	end as [Processed Status]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM tCCEntry cc (nolock)	
	LEFT OUTER JOIN tTask ta (nolock) on cc.TaskKey = ta.TaskKey
	LEFT OUTER JOIN tProject p (nolock) on cc.ProjectKey = p.ProjectKey	
	LEFT OUTER JOIN tItem i (nolock) on cc.ItemKey = i.ItemKey
	LEFT OUTER JOIN tOffice o (NOLOCK) ON cc.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tGLAccount gl (nolock) on cc.GLAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON cc.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tVoucher v (nolock) on cc.CCEntryKey = v.CCEntryKey
	LEFT OUTER JOIN tUser u (nolock) on cc.ChargedByKey = u.UserKey
	LEFT OUTER JOIN tUser u2 (nolock) on v.ApprovedByKey = u2.UserKey
	LEFT OUTER JOIN tCompany c (NOLOCK) ON cc.VendorKey = c.CompanyKey
	LEFT OUTER JOIN tDepartment d (nolock) ON cc.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tGLAccount ea (nolock) ON cc.ExpenseAccountKey = ea.GLAccountKey
	LEFT OUTER JOIN tClass cl (nolock) on cc.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tSalesTax st (nolock) on cc.SalesTaxKey = st.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on cc.SalesTax2Key = st2.SalesTaxKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
