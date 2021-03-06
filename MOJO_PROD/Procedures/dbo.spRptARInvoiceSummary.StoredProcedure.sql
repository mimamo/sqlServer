USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptARInvoiceSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptARInvoiceSummary]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@GLCompanyKey int = -1,  -- -1 All, 0 Blank, >0 a valid GL company
		@UserKey int = null,
		@CurrencyID varchar(10) = null,
		@OpenStatus int = 0  -- 0 All, 1 Open, 2 Paid
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 09/12/07 GHL 8.436  (12840) Added PO contributions     
  || 03/07/12 GHL 10.554 (123991) Added GLCompanyKey filter and column
  || 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess    
  || 01/24/14 GHL 10.576  Using PTotalCost vs TotalCost except for misc cost 
  ||                      Added CurrencyID param     
  || 01/07/15 GHL 10.588  (239375) Added OpenStatus depending on Open Amount
  ||                           = ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) 
  ||                           - ISNULL(WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) 
  ||                       0 All invoices
  ||                       1 Open Amount <> 0 -- Open Invoices
  ||                       2 Open Amount = 0  -- Paid Invoices
  */
  
if @StartDate is null
	Select @StartDate = '1/1/1960'

if @EndDate is null
	Select @EndDate = '12/31/2049'
	
if @GLCompanyKey is null
	select @GLCompanyKey = -1	
	
Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
	   ,@MultiCurrency = isnull(@MultiCurrency, 0)

Select
	i.InvoiceKey
	,i.CompanyKey
	,i.InvoiceDate
	,i.InvoiceNumber
	,c.CustomerID + ' - ' + c.CompanyName as CompanyName
	,c.CustomerID
	,isnull(glc.GLCompanyID + ' - ' + glc.GLCompanyName, 'No Company') as GLCompanyName
	,isnull(glc.GLCompanyID, 'No Company') as GLCompanyID
	,i.InvoiceTotalAmount
	,i.SalesTaxAmount
	,ISNULL((Select Sum(TotalAmount) from tInvoiceLine il (nolock) Where InvoiceKey = i.InvoiceKey and LineType = 2 and BillFrom = 1), 0) as NoDetailAmount
	,ISNULL((Select Sum(BilledHours * BilledRate) from
		tTime t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) as BilledLabor
	,ISNULL((Select Sum(PTotalCost) from
		tPurchaseOrderDetail pod (nolock) inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) +
	 ISNULL((Select Sum(PTotalCost) from
		tVoucherDetail t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) + 
	 ISNULL((Select Sum(TotalCost) from
		tMiscCost t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) + 
	 ISNULL((Select Sum(PTotalCost) from
		tExpenseReceipt t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) as Net

	,ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tPurchaseOrderDetail pod (nolock) inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) +
	 ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tVoucherDetail t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) +
	 ISNULL((Select Sum(AmountBilled - TotalCost) from
		tMiscCost t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) +
	 ISNULL((Select Sum(AmountBilled - PTotalCost) from
		tExpenseReceipt t (nolock) inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Where il.InvoiceKey = i.InvoiceKey), 0) as MU
From tInvoice i (nolock)
	inner join tCompany c on i.ClientKey = c.CompanyKey
	left join tGLCompany glc on i.GLCompanyKey = glc.GLCompanyKey
Where
	i.CompanyKey = @CompanyKey and
	i.InvoiceDate >= @StartDate and
	i.InvoiceDate <= @EndDate and
	i.AdvanceBill = 0 
	--and (@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey !=-1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)
	
	AND   (@MultiCurrency = 0
			OR
			isnull(i.CurrencyID, '') = isnull(@CurrencyID, '')
			)
	AND (
		@OpenStatus = 0
		Or
			(@OpenStatus = 1
			AND ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) <> 0
			)
		Or
			(@OpenStatus = 2
			AND ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) = 0
			AND ISNULL(i.InvoiceTotalAmount, 0) <> 0 -- if total = 0, consider it paid
			)
		)
GO
