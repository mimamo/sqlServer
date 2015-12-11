USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_GLTransaction]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_GLTransaction] 
AS

/*
|| When      Who Rel     What
|| 1/28/08   CRG 1.0.0.0 Created for new General Ledger Listing
|| 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
*/

Select 
	t.CompanyKey
	,t.GLCompanyKey
	,t.TransactionKey
	,t.Entity as [Source Transaction Type]
	,t.EntityKey
	,Cast(Cast(DatePart(mm,t.TransactionDate) as varchar) + '/' + Cast(DatePart(dd,t.TransactionDate) as varchar) + '/' + Cast(DatePart(yyyy,t.TransactionDate) as varchar) as datetime) as [Date Posted]
	,t.TransactionDate as [Transaction Date]	
	,t.Reference as [Transaction Reference]
	,gl.AccountNumber as [GL Account Number]
	,gl.AccountName as [GL Account Name]
	,gl.AccountNumber + ' - ' + gl.AccountName as [GL Account Name Full]
	,t.Debit as [Debit Amount]
	,t.Credit as [Credit Amount]
	,Case 
		When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
		ELSE Credit - Debit END as [Transaction Amount]
	,t.Memo as [Transaction Memo]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,cl.ClassID + ' - ' + cl.ClassName as [Class Name Full]
	,t.PostMonth as [Posting Month]
	,Cast(t.PostMonth as varchar) + ' - ' + DATENAME(mm, t.TransactionDate) as [Posting Month Name]
	,t.PostYear as [Posting Year]
	,Case When t.Cleared = 1 then 'YES' else 'NO' end as [Transaction Cleared]
	,c.CompanyName as [Source Company Name]
	,c.CustomerID as [Source Customer ID]
	,client.CompanyName as [Client Name]
	,client.CustomerID as [Client ID]
	,c.VendorID as [Source Vendor ID]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,Case p.NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
	,CASE gl.AccountType
		WHEN 10 THEN 'Bank'
		WHEN 11 THEN 'Accounts Receivable'
		WHEN 12 THEN 'Current Asset'
		WHEN 13 THEN 'Fixed Asset'
		WHEN 14 THEN 'Other Asset'
		WHEN 20 THEN 'Accounts Payable'
		WHEN 21 THEN 'Current Liability'
		WHEN 22 THEN 'Long Term Liability'
		WHEN 30 THEN 'Equity - Does Not Close'
		WHEN 31 THEN 'Equity - Closes'
		WHEN 32 THEN 'Retained Earnings'
		WHEN 40 THEN 'Income'
		WHEN 41 THEN 'Other Income'
		WHEN 50 THEN 'Cost of Goods Sold'
		WHEN 51 THEN 'Expense'
		WHEN 52 THEN 'Other Expense'
	END AS [Account Type]
from tTransaction t (nolock)
	left outer join tClass cl (nolock) on t.ClassKey = cl.ClassKey
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	left outer join tCompany c (nolock) on t.SourceCompanyKey = c.CompanyKey
	left outer join tCompany client (nolock) on t.ClientKey = client.CompanyKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on t.DepartmentKey = d.DepartmentKey
GO
