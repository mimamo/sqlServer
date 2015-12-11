USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Payment]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Payment]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added GLCompany
|| 02/14/07  GWG 8.6     Added the unapplied payment account
|| 04/23/09  GWG 10.023  Added Custom FieldKey
|| 05/21/09  MFT 10.026	 Unapplied Amount
|| 07/29/09  RLB 10.505  Added Opening Transactions
|| 03/09/10  RLB 10.520  Added account type on cash account 
|| 04/25/12  GHL 10.555  Added GLCompanyKey for map/restrict
|| 07/10/12  MFT 10.558  Added [Voided Payment]
|| 11/12/13  GHL 10.574  Added CurrencyID
|| 03/20/14  GHL 10.578  Added Exchange Rate
*/

SELECT
	 p.PaymentKey
	,p.CompanyKey
	,p.GLCompanyKey
	,p.VendorKey
	,c.CustomFieldKey
	,gl.AccountNumber as [Cash Account Number]
	,gl.AccountName as [Cash Account Name]
	,gl.AccountNumber + ' - ' + gl.AccountName as [Cash Account Full Name]
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
	,p.PaymentAmount - 
	(Select ISNULL(Sum(Amount), 0) from tPaymentDetail (NOLOCK) Where PaymentKey = p.PaymentKey) AS [Unapplied Amount]
	,gl2.AccountNumber as [Unapplied Payment Account Number]
	,gl2.AccountName as [Unapplied Payment Account Name]
	,gl2.AccountNumber + ' - ' + gl2.AccountName as [Unapplied Payment Account Full Name]
	,p.PaymentDate as [Check Date]
	,p.CheckNumber as [Check Number]
	,c.VendorID as [Vendor ID]
	,c.CompanyName as [Vendor Name]
	,case c.Type1099 When 1 then 'MISC' when 2 then 'INT' else 'NONE' end as [Vendor 1099 Type]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,ct.CompanyTypeName as [Company Type]
	,p.PayToName as [Pay To Name]
	,p.PayToAddress1 as [Pay To Address1]
	,p.PayToAddress2 as [Pay To Address2]
	,p.PayToAddress3 as [Pay To Address3]
	,p.PayToAddress4 as [Pay To Address4]
	,p.PayToAddress5 as [Pay To Address5]
	,p.PostingDate as [Posting Date]
	,p.Memo as [Check Memo]
	,p.PaymentAmount as [Check Amount]
	,case p.Posted when 1 then 'YES' else 'NO' end as Posted
	,case when p.CheckNumber is null then 'NO' else 'YES' end as Printed
	,(Select Count(*) from tTransaction (nolock) Where Entity = 'PAYMENT' and EntityKey = p.PaymentKey) as [Posting Count]
	,Case (Select Distinct 1 from tTransaction tr(nolock) Where  p.PaymentKey = tr.EntityKey and tr.Entity = 'PAYMENT' and tr.Cleared = 1) When 1 then 'YES' else 'NO' end as Cleared
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
  ,case ISNULL(p.OpeningTransaction, 0) when 0 then 'NO' when 1 then 'YES' end as [Opening Transaction]
  ,CASE ISNULL(VoidPaymentKey, 0) WHEN PaymentKey THEN 'YES' ELSE 'NO' END AS [Voided Payment]
  ,p.CurrencyID as [Currency]
  ,p.ExchangeRate as [Exchange Rate]
FROM         
	tPayment p (nolock)
	INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey 
	left outer join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer JOIN tGLAccount gl(nolock) ON p.CashAccountKey = gl.GLAccountKey
	left outer JOIN tGLAccount gl2 (nolock) ON p.UnappliedPaymentAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on p.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	--left outer join tTransaction tr (nolock) on p.PaymentKey = tr.EntityKey and tr.Entity = 'PAYMENT' and tr.Cleared = 1
GO
