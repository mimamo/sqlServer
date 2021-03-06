USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetDetail]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetDetail]
	@CheckKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 02/23/10  MFT 10.519  Created
|| 04/05/10  MFT 10.521  Added DefaultSalesAccount info for client
|| 07/22/10  MFT 10.532  Added tSalesTax to Applied to sales query
|| 11/24/10  MFT 10.548  Added Class to applied invoice get
|| 12/10/10  RLB 10.539  (96920) pulling down ParentRecurringTranKey
|| 03/27/12  MAS 10.554  Added TargetGLCompanyKey
|| 09/19/13  GHL 10.572  Added support for multi currency
|| 01/15/14  MFT 10.576  (202686) Fixed @Cleared flag to check for PostSide
*/

DECLARE @Cleared int
DECLARE @CompanyKey int
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @CheckDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

SELECT
	@Cleared = CASE WHEN SUM(Cleared) = COUNT(*) THEN 1 ELSE 0 END
FROM
	tTransaction (nolock) 
WHERE
	PostSide = 'D' AND
	Entity = 'RECEIPT' AND
	EntityKey = @CheckKey

select @CompanyKey = c.CompanyKey
	  ,@GLCompanyKey = isnull(c.GLCompanyKey, 0) 
      ,@CurrencyID = c.CurrencyID
	  ,@CheckDate = c.CheckDate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from   tCheck c (nolock)
inner join tPreference pref (nolock) on c.CompanyKey = pref.CompanyKey
where  c.CheckKey = @CheckKey    

-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @CheckDate, @ExchangeRate output, @RateHistory output

--Check header
SELECT 
	tCheck.*,
	c.CustomerID AS ClientID,
	c.CustomerID, -- expected by the client lookup
	c.CompanyName,
	c.DefaultSalesAccountKey,
	gl3.AccountNumber AS DefaultSalesNumber,
	gl3.AccountName AS DefaultSalesName,
	gl.AccountNumber AS CashAccountNumber,
	gl.AccountName AS CashAccountName,
	gl2.AccountNumber AS PrepayAccountNumber,
	gl2.AccountName AS PrepayAccountName,
	cl.ClassID,
	cl.ClassName,
	d.DepositID,
	pr.CCProcessor,
	u.Phone1,
	u.Email,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN bad.Country ELSE ad.Country END AS BCountry,
	ISNULL(@Cleared, 0) AS Cleared,
	glc.GLCompanyID,
	glc.GLCompanyName,
	rt.RecurTranKey as ParentRecurringTranKey,
	@RateHistory as RateHistory
FROM tCheck (nolock)
	INNER JOIN tCompany c (nolock) ON tCheck.ClientKey = c.CompanyKey
	INNER JOIN tPreference pr (nolock) ON c.OwnerCompanyKey = pr.CompanyKey
	LEFT JOIN tGLAccount gl (nolock) ON tCheck.CashAccountKey = gl.GLAccountKey
	LEFT JOIN tGLAccount gl2 (nolock) ON tCheck.PrepayAccountKey = gl2.GLAccountKey
	LEFT JOIN tGLAccount gl3 (nolock) ON c.DefaultSalesAccountKey = gl3.GLAccountKey
	LEFT JOIN tClass cl (nolock) ON tCheck.ClassKey = cl.ClassKey
	LEFT JOIN tDeposit d (nolock) ON tCheck.DepositKey = d.DepositKey
	LEFT JOIN tUser u (nolock) ON tCheck.CustomerContactKey = u.UserKey
	LEFT JOIN tAddress ad (nolock) ON c.DefaultAddressKey = ad.AddressKey
	LEFT JOIN tAddress bad (nolock) ON c.BillingAddressKey = bad.AddressKey
	LEFT JOIN tGLCompany glc (nolock) ON tCheck.GLCompanyKey = glc.GLCompanyKey
	LEFT JOIN tRecurTran rt (nolock) on tCheck.RecurringParentKey = rt.EntityKey and rt.Entity = 'RECEIPT'
WHERE
	tCheck.CheckKey = @CheckKey

--Applied to sales
SELECT
	ca.CheckApplKey,
	ca.Amount,
	ca.OfficeKey,
	ca.DepartmentKey,
	ca.Description,
	ca.Prepay,
	ca.TargetGLCompanyKey,
	glc.GLCompanyID,
	glc.GLCompanyName,
	o.OfficeKey,
	o.OfficeID,
	o.OfficeName,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName,
	d.DepartmentKey,
	d.DepartmentName,
	cl.ClassKey,
	cl.ClassID,
	cl.ClassName,
	st.SalesTaxName,
	st.SalesTaxKey
FROM
	tCheckAppl ca (nolock)
	LEFT JOIN tOffice o (nolock) ON ca.OfficeKey = o.OfficeKey
	LEFT JOIN tGLAccount gl (nolock) ON ca.SalesAccountKey = gl.GLAccountKey
	LEFT JOIN tDepartment d (nolock) ON ca.DepartmentKey = d.DepartmentKey
	LEFT JOIN tClass cl (nolock) ON ca.ClassKey = cl.ClassKey
	LEFT JOIN tSalesTax st (nolock) ON ca.SalesTaxKey = st.SalesTaxKey
	LEFT JOIN tGLCompany glc (nolock) ON ca.TargetGLCompanyKey = glc.GLCompanyKey
WHERE
	ca.CheckKey = @CheckKey AND
	ca.InvoiceKey IS NULL AND
	Prepay = 0

--Applied to invoices
SELECT
	ca.CheckApplKey,
	ca.Amount,
	ca.Prepay,
	ca.TargetGLCompanyKey,
	glc.GLCompanyID,
	glc.GLCompanyName,
	i.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	(ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0)) AS TotalAmount,
	(ISNULL(InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0)) AS TotalOpen,
	c.CustomerID,
	c.CompanyName,
	cl.ClassKey,
	cl.ClassID,
	cl.ClassName,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName
FROM
	tCheckAppl ca (nolock)
	INNER JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey
	LEFT JOIN tClass cl (nolock) ON ca.ClassKey = cl.ClassKey
	LEFT JOIN tGLAccount gl (nolock) ON ca.SalesAccountKey = gl.GLAccountKey
	LEFT JOIN tGLCompany glc (nolock) ON ca.TargetGLCompanyKey = glc.GLCompanyKey
WHERE 
	ca.CheckKey = @CheckKey AND
	ca.InvoiceKey IS NOT NULL AND
	Prepay = 0

--Prepay
SELECT
	ca.CheckApplKey,
	ca.Amount,
	ca.Description,
	ca.TargetGLCompanyKey,
	glc.GLCompanyID,
	glc.GLCompanyName,
	i.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	i.ARAccountKey,
	(ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0)) AS TotalAmount,
	i.Posted,
	i.InvoiceStatus,
	cl.ClassKey,
	cl.ClassID,
	cl.ClassName,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName
FROM
	tCheckAppl ca (nolock)
	LEFT JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
	LEFT JOIN tClass cl (nolock) ON ca.ClassKey = cl.ClassKey
	LEFT JOIN tGLAccount gl (nolock) ON ca.SalesAccountKey = gl.GLAccountKey
	LEFT JOIN tGLCompany glc (nolock) ON ca.TargetGLCompanyKey = glc.GLCompanyKey
WHERE 
	ca.CheckKey = @CheckKey AND
	Prepay = 1
GO
