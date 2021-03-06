USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Receipts]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Receipts]

as

  /*
  || When     Who Rel   What
  || 02/19/07 GHL 8.4   Replaced left join with tTransaction by derived table
  ||                                  Was causing duplicate rows in listing 
  || 10/10/07 CRG 8.5   Added GLCompany 
  || 4/20/09  GWG 10.024Added the prepay account
  || 5/13/09  MFT 10.024(52812)
  || 06/19/09 RLB 10.500 (55245) Added unapplied amount field
  || 09/03/09 RLB 10.509 (61781) Wrapped ISNUll on applied and Unapplied columns so listing would display correctly 
  || 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
  || 03/14/14 GHL 10578 Added CurrencyID
  || 03/20/14 GHL 10578 Added Exchange Rate
  */

Select
	ch.CheckKey
	,ch.ClientKey
	,c.OwnerCompanyKey as CompanyKey
	,ch.GLCompanyKey
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,c.CustomerID + ' - ' + c.CompanyName as [Client Full Name]
	,ch.ReferenceNumber as [Reference Number]
	,cm.CheckMethod as [Payment Method]
	,ch.Description as [Payment Description]
	,ch.CheckAmount as [Check Amount]
    ,ch.CheckAmount - ISNULL((Select Sum(Amount) from tCheckAppl (nolock) Where tCheckAppl.CheckKey = ch.CheckKey and InvoiceKey is not null), 0) - ISNULL((Select Sum(Amount) from tCheckAppl (nolock) Where tCheckAppl.CheckKey = ch.CheckKey and InvoiceKey is null), 0) As [Unapplied Amount]
	,ch.CheckDate as [Date Received]
	,ch.PostingDate as [Posting Date]
	,ch.Description as [Description]
	,gl.AccountNumber as [Cash Account Number]
	,gl.AccountName as [Cash Account Name]
	,glp.AccountNumber as [Prepay Account Number]
	,glp.AccountName as [Prepay Account Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,case ch.Posted when 1 then 'YES' else 'NO' end as Posted
	,dep.DepositID as [Deposit ID]
	,dep.DepositDate as [Deposit Date]
	,chm.CheckMethod as [Receipt Type]
	,(Select ISNULL(Sum(Amount), 0) from tCheckAppl (nolock) Where tCheckAppl.CheckKey = ch.CheckKey and InvoiceKey is not null) as [Amount Applied]
	,(Select Count(*) from tTransaction (nolock) Where Entity = 'RECEIPT' and EntityKey = ch.CheckKey) as [Posting Count]
             ,Case ISNULL(tr.EntityKey, 0) When 0 then 'NO' else 'YES' end as Cleared
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,ch.CurrencyID as Currency
	,ch.ExchangeRate as [Exchange Rate]
From
	tCheck ch (nolock)
	inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	left outer join tGLAccount gl (nolock) on ch.CashAccountKey = gl.GLAccountKey
	left outer join tGLAccount glp (nolock) on ch.PrepayAccountKey = glp.GLAccountKey
	left outer join tCheckMethod cm (nolock) on ch.CheckMethodKey = cm.CheckMethodKey
	left outer join tClass cl (nolock) on ch.ClassKey = cl.ClassKey
	left outer join tDeposit dep (nolock) on ch.DepositKey = dep.DepositKey
	left outer join tCheckMethod chm (nolock) on ch.CheckMethodKey = chm.CheckMethodKey
              left outer join (
	    select distinct EntityKey from tTransaction (nolock) 
	    where Entity = 'RECEIPT' and Cleared = 1
	    ) AS tr ON ch.CheckKey = tr.EntityKey
	left outer join tGLCompany glc (nolock) on ch.GLCompanyKey = glc.GLCompanyKey
GO
