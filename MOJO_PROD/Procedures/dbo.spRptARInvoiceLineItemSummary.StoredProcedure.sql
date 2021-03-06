USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptARInvoiceLineItemSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptARInvoiceLineItemSummary]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@InvoiceKey int = null,
		@UserKey int = null,
		@CurrencyID varchar(10) = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/12/07 GHL 8.436  (12840) Added PO contributions
  || 11/16/10 RLB 10538  (92031) Added InvoiceKey 
  || 04/17/12 GHL 10.555 Added UserKey for UserGLCompanyAccess    
  || 12/14/12 WDF 10.563 (162240) Add criteria to AccountName     
  || 01/24/14 GHL 10.576  Using PTotalCost vs TotalCost except for misc cost 
  ||                      Added CurrencyID param                                      
  */
  
if @StartDate is null
	Select @StartDate = '1/1/1960'

if @EndDate is null
	Select @EndDate = '12/31/2049'
	
Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)	
	  ,@MultiCurrency = isnull(@MultiCurrency, 0)

-- If an invoice is passed, do not check for currency
if @InvoiceKey > 0
	select @MultiCurrency = 0

Select
	i.CompanyKey
	,i.InvoiceDate
	,i.InvoiceNumber
	,il.LineSubject
	,p.ProjectNumber + ' - ' + p.ProjectName as ProjectName
	,p.ProjectNumber
	,c.CustomerID + ' - ' + c.CompanyName as CompanyName
	,c.CustomerID
	,CASE il.PostSalesUsingDetail
	    WHEN 1 THEN NULL
		ELSE gl.AccountNumber + ' - ' + gl.AccountName
	  END as AccountName
	,CASE il.PostSalesUsingDetail
	    WHEN 1 THEN NULL
		ELSE gl.AccountNumber 
	  END as AccountNumber
	,u.FirstName + ' ' + u.LastName as AccountManagerName
	,ISNULL(il.TotalAmount, 0) as TotalAmount
	,ISNULL((Select Sum(BilledHours * BilledRate) from
		tTime t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) as BilledLabor
	,ISNULL((Select Sum(PTotalCost) from
		tPurchaseOrderDetail pod (nolock) Where pod.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(PTotalCost) from
		tVoucherDetail t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(TotalCost) from
		tMiscCost t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(PTotalCost) from
		tExpenseReceipt t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) as Net
	,ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tPurchaseOrderDetail pod (nolock) Where pod.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tVoucherDetail t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(AmountBilled - TotalCost) from
		tMiscCost t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) +
	 ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tExpenseReceipt t (nolock) Where t.InvoiceLineKey = il.InvoiceLineKey), 0) as MU
From 
	tInvoice i (nolock)
	inner join tCompany c on i.ClientKey = c.CompanyKey
	inner join tInvoiceLine il on i.InvoiceKey = il.InvoiceKey
	left outer join tGLAccount gl (nolock) on il.SalesAccountKey = gl.GLAccountKey
	left outer join tProject p (nolock) on il.ProjectKey = p.ProjectKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
Where
	i.CompanyKey = @CompanyKey and
	i.InvoiceDate >= @StartDate and
	i.InvoiceDate <= @EndDate and
	(@InvoiceKey IS NULL or i.InvoiceKey = @InvoiceKey) and
	i.AdvanceBill = 0
	AND (@RestrictToGLCompany = 0 
		OR i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
	
	AND   (@MultiCurrency = 0
			OR
			isnull(i.CurrencyID, '') = isnull(@CurrencyID, '')
			)
GO
