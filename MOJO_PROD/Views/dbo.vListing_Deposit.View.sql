USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Deposit]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View [dbo].[vListing_Deposit]
As

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added GLCompany
|| 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
*/

Select
	d.DepositKey
	,d.CompanyKey
	,d.GLCompanyKey
	,d.DepositID as [Deposit ID]
	,gl.AccountNumber as [Cash Account Number]
	,gl.AccountName as [Cash Account Name]
	,d.DepositDate as [Deposit Date]
	,case d.Cleared when 1 then 'YES' else 'NO' end as Cleared
	,(Select sum(CheckAmount) from tCheck Where DepositKey = d.DepositKey) as [Deposit Amount]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
From 
	tDeposit d (nolock)
	left outer join tGLAccount gl (nolock) on d.GLAccountKey = gl.GLAccountKey
	left outer join tGLCompany glc (nolock) on d.GLCompanyKey = glc.GLCompanyKey
GO
