USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vHCashTransaction]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vHCashTransaction]

as 

/*
|| When      Who Rel     What
|| 12/30/13  GHL 10.5.7.5 Mapping now HDebit/HCredit to Debit/Credit and Debit/Credit to CDebit/CCredit (C=currency) 
||                        This is to facilitate the reports
*/

SELECT     
	tr.UIDCashTransactionKey,
	tr.CompanyKey ,
	tr.DateCreated ,
	tr.TransactionDate ,
	tr.Entity ,
	tr.EntityKey,
	tr.Reference,
	tr.GLAccountKey ,
	tr.HDebit  as Debit,
	tr.HCredit as Credit ,
	Case 
		When isnull(gl.AccountTypeCash, gl.AccountType) in (10, 11, 12, 13, 14, 50, 51, 52) Then tr.HDebit - tr.HCredit
		ELSE tr.HCredit - tr.HDebit END as Amount,
	tr.ClassKey ,
	tr.Memo ,
	tr.PostMonth ,
	tr.PostYear,
	tr.Reversed ,
	tr.PostSide ,
	tr.ClientKey ,
	tr.ProjectKey ,
	tr.SourceCompanyKey,
	tr.Cleared ,
	tr.DepositKey ,
	tr.GLCompanyKey ,
	tr.OfficeKey ,
	tr.DepartmentKey ,
	tr.DetailLineKey ,
	tr.Section ,
	tr.Overhead ,
	tr.ICTGLCompanyKey ,
	tr.AEntity ,
	tr.AEntityKey ,
	tr.AEntity2 ,
	tr.AEntity2Key ,
	tr.AAmount ,
	LineAmount ,
	tr.CashTransactionLineKey ,
	tr.AReference ,
	tr.AReference2 ,
	tr.CurrencyID ,
	tr.ExchangeRate ,
	tr.Debit as CDebit,
	tr.Credit as CCredit
	
FROM 
	tCashTransaction tr (nolock) 
	LEFT JOIN tGLAccount as gl (nolock) ON tr.GLAccountKey = gl.GLAccountKey
GO
