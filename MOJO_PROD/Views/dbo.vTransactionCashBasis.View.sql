USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTransactionCashBasis]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        View [dbo].[vTransactionCashBasis]

as 

/*
|| When      Who Rel     What
|| 10/5/07   CRG 8.5     Modified DepartmentKey and OfficeKey to come from tTransaction. Added GLCompanyKey.
|| 11/12/07  CRG 8.5     Fixed join for ClientID
|| 03/10/09  GHL 10.0.2.0 Cloned vTransaction for cash basis
|| 06/11/09  GHL 10.0.2.7 Added use of AccountTypeCash
|| 07/12/13  WDF 10.5.7.0 (176497) Added VoucherID
|| 10/31/13  GHL 10.5.7.5  Pulling now HCredit and HDebit vs Credit and Debit 
|| 02/05/14  GHL 10.5.7.6  Added CurrencyID and transaction currency Debit/Credit
*/

SELECT     
	 tr.UIDCashTransactionKey
	,tr.CompanyKey
	,tr.DateCreated
	,tr.TransactionDate
	,tr.Entity
	,tr.EntityKey
	,tr.Reference
	,tr.GLAccountKey
	,tr.HDebit as Debit
	,tr.HCredit as Credit
	,Case 
		When isnull(gl.AccountTypeCash, gl.AccountType) in (10, 11, 12, 13, 14, 50, 51, 52) Then HDebit - HCredit
		ELSE HCredit - HDebit END as Amount
	,tr.ClassKey
	,tr.Memo
	,tr.PostMonth
	,tr.PostYear
	,tr.ProjectKey
	,tr.SourceCompanyKey
	,tr.Cleared
	,tr.ClientKey
	,gl.AccountNumber
	,gl.AccountName
	,isnull(gl.AccountTypeCash, gl.AccountType) as AccountType
	,gl.ParentAccountKey
	,cl.ClassID
	,cl.ClassName
	,p.ProjectNumber
	,p.ProjectName
	,c.CompanyName
	,client.CustomerID as ClientID
	,c.VendorID
	,tr.DepartmentKey
	,d.DepartmentName
	,tr.OfficeKey
	,o.OfficeID
	,o.OfficeName
	,tr.GLCompanyKey
	,glc.GLCompanyID
	,glc.GLCompanyName
	,v.VoucherID
	,tr.CurrencyID 
	,tr.Debit as CDebit   -- Debit in other Currency
	,tr.Credit as CCredit  -- Credit in other Currency
	,Case 
		When isnull(gl.AccountTypeCash, gl.AccountType) in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
		ELSE Credit - Debit END as CAmount
FROM 
	tCashTransaction tr (nolock) 
	INNER JOIN tGLAccount as gl (nolock) ON tr.GLAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tClass cl (nolock) ON tr.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tProject p (nolock) ON tr.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany c (nolock) ON tr.SourceCompanyKey = c.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON tr.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tDepartment d (nolock) ON tr.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tOffice o (nolock) ON tr.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tCompany client (nolock) ON tr.ClientKey = client.CompanyKey
	LEFT OUTER JOIN tVoucher v (nolock) ON tr.EntityKey = v.VoucherKey AND
	                                       tr.Entity = 'VOUCHER'
GO
