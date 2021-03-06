USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_WIPDetail]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_WIPDetail]
AS

/*
|| When     Who Rel   	  What
|| 05/14/07 GHL 8.4.2.1   Creation for Media Logic
|| 10/11/07 CRG 8.5       Added GLCompany and Office 
|| 04/14/10 RLB 10.521    (40466)  Added CompanyType       
|| 04/23/12 GHL 10.555    Added GLCompanyKey for map/restrict 
|| 10/29/12 CRG 10.5.6.1  (156391) Added ProjectKey
|| 01/27/15 WDF 10.5.8.8  (Abelson Taylor) Added Division and Product
*/

SELECT  w.CompanyKey
    ,t.GLCompanyKey
	,w.PostingDate		AS [Posting Date]
	,w.Comment		AS [WIP Comments]
	,t.AccountNumber	AS [GL Account Number]
	,t.AccountName		AS [GL Account Name]
	,t.ClassID 		AS [Class ID]
	,t.ClassName		AS [Class Name]
	,t.Debit			AS [GL Debit Amount]
	,t.Credit			AS [GL Credit Amount]
	,t.Reference		AS [GL Reference]
	,src.ProjectNumber	AS [Project Number]
	,src.ProjectName	AS [Project Name]
	,src.WorkDate		AS [Detail Transaction Date]
	,src.ActualTotal		AS [Detail Net Amount]
	,src.ActualTotal		AS [Detail Gross Amount]
	,cl.CompanyName	AS [Client Name]
	,cl.CustomerID		AS [Client ID]
	,ct.CompanyTypeName as [Company Type]
	,CAST('LABOR' AS VARCHAR(50)) AS [Detail Transaction Type]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,t.OfficeID as [Office ID]
	,t.OfficeName as [Office Name]
	,t.ProjectKey
	,src.DivisionID as [Client Division ID]
    ,src.DivisionName as [Client Division]
    ,src.ProductID as [Client Product ID]
    ,src.ProductName as [Client Product]
FROM   	tWIPPosting w (NOLOCK)
	INNER JOIN vTransaction t (NOLOCK) ON w.WIPPostingKey = t.EntityKey AND t.Entity = 'WIP'
	INNER JOIN tWIPPostingDetail wd (NOLOCK) ON w.WIPPostingKey = wd.WIPPostingKey AND t.TransactionKey = wd.TransactionKey
	INNER JOIN vTimeDetail src (NOLOCK) ON wd.UIDEntityKey = src.TimeKey
	LEFT OUTER JOIN tCompany cl (NOLOCK) ON t.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey

UNION ALL


SELECT  w.CompanyKey
	,t.GLCompanyKey
	,w.PostingDate		AS [Posting Date]
	,w.Comment		AS [WIP Comments]
	,t.AccountNumber	AS [GL Account Number]
	,t.AccountName		AS [GL Account Name]
	,t.ClassID 		AS [Class ID]
	,t.ClassName		AS [Class Name]
	,t.Debit			AS [GL Debit Amount]
	,t.Credit			AS [GL Credit Amount]
	,t.Reference		AS [GL Reference]
	,p.ProjectNumber	AS [Project Number]
	,p.ProjectName		AS [Project Name]
	,src.ExpenseDate	AS [Detail Transaction Date]
	,src.TotalCost		AS [Detail Net Amount]
	,src.BillableCost		AS [Detail Gross Amount]
	,cl.CompanyName	AS [Client Name]
	,cl.CustomerID		AS [Client ID]
	,ct.CompanyTypeName as [Company Type]
	,CAST('MISC COST' AS VARCHAR(50)) AS [Detail Transaction Type]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,t.OfficeID as [Office ID]
	,t.OfficeName as [Office Name]
	,t.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM   	tWIPPosting w (NOLOCK)
	INNER JOIN vTransaction t (NOLOCK) ON w.WIPPostingKey = t.EntityKey AND t.Entity = 'WIP'
	INNER JOIN tWIPPostingDetail wd (NOLOCK) ON w.WIPPostingKey = wd.WIPPostingKey AND t.TransactionKey = wd.TransactionKey
	INNER JOIN tMiscCost src (NOLOCK) ON wd.EntityKey = src.MiscCostKey AND wd.Entity = 'tMiscCost'  
	INNER JOIN tProject p (NOLOCK) ON src.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany cl (NOLOCK) ON t.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey

UNION ALL


SELECT  w.CompanyKey
	,t.GLCompanyKey
	,w.PostingDate		AS [Posting Date]
	,w.Comment		AS [WIP Comments]
	,t.AccountNumber	AS [GL Account Number]
	,t.AccountName		AS [GL Account Name]
	,t.ClassID 		AS [Class ID]
	,t.ClassName		AS [Class Name]
	,t.Debit			AS [GL Debit Amount]
	,t.Credit			AS [GL Credit Amount]
	,t.Reference		AS [GL Reference]
	,p.ProjectNumber	AS [Project Number]
	,p.ProjectName		AS [Project Name]
	,src.ExpenseDate	AS [Detail Transaction Date]
	,src.ActualCost		AS [Detail Net Amount]
	,src.BillableCost		AS [Detail Gross Amount]
	,cl.CompanyName	AS [Client Name]
	,cl.CustomerID		AS [Client ID]
	,ct.CompanyTypeName as [Company Type]
	,CAST('EXPENSE REPORT' AS VARCHAR(50)) AS [Detail Transaction Type]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,t.OfficeID as [Office ID]
	,t.OfficeName as [Office Name]	
	,t.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM   	tWIPPosting w (NOLOCK)
	INNER JOIN vTransaction t (NOLOCK) ON w.WIPPostingKey = t.EntityKey AND t.Entity = 'WIP'
	INNER JOIN tWIPPostingDetail wd (NOLOCK) ON w.WIPPostingKey = wd.WIPPostingKey AND t.TransactionKey = wd.TransactionKey
	INNER JOIN tExpenseReceipt src (NOLOCK) ON wd.EntityKey = src.ExpenseReceiptKey AND wd.Entity = 'tExpenseReceipt'  
	LEFT OUTER JOIN tProject p (NOLOCK) ON src.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany cl (NOLOCK) ON t.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey

UNION ALL


SELECT  w.CompanyKey
	,t.GLCompanyKey
	,w.PostingDate		AS [Posting Date]
	,w.Comment		AS [WIP Comments]
	,t.AccountNumber	AS [GL Account Number]
	,t.AccountName		AS [GL Account Name]
	,t.ClassID 		AS [Class ID]
	,t.ClassName		AS [Class Name]
	,t.Debit			AS [GL Debit Amount]
	,t.Credit			AS [GL Credit Amount]
	,t.Reference		AS [GL Reference]
	,p.ProjectNumber	AS [Project Number]
	,p.ProjectName		AS [Project Name]
	,v.InvoiceDate		AS [Detail Transaction Date]
	,src.TotalCost		AS [Detail Net Amount]
	,src.BillableCost		AS [Detail Gross Amount]
	,cl.CompanyName	AS [Client Name]
	,cl.CustomerID		AS [Client ID]
	,ct.CompanyTypeName as [Company Type]
	,CAST('VENDOR INVOICE' AS VARCHAR(50)) AS [Detail Transaction Type]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,t.OfficeID as [Office ID]
	,t.OfficeName as [Office Name]
	,t.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM   	tWIPPosting w (NOLOCK)
	INNER JOIN vTransaction t (NOLOCK) ON w.WIPPostingKey = t.EntityKey AND t.Entity = 'WIP'
	INNER JOIN tWIPPostingDetail wd (NOLOCK) ON w.WIPPostingKey = wd.WIPPostingKey AND t.TransactionKey = wd.TransactionKey
	INNER JOIN tVoucherDetail src (NOLOCK) ON wd.EntityKey = src.VoucherDetailKey AND wd.Entity = 'tVoucherDetail'  
	INNER JOIN tVoucher v (NOLOCK) ON src.VoucherKey = v.VoucherKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON src.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany cl (NOLOCK) ON t.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    LEFT OUTER JOIN tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
