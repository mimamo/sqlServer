USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vInvoiceLine]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE                  VIEW [dbo].[vInvoiceLine]
AS

/*
|| When     Who     Rel      What
|| 11/17/09 GHL     10.513	 (68534) Checking now SalesTaxAmount to determine Taxable status (vs Taxable flag) 
|| 7/15/11  GWG     10.545   Added a count of sub summary tasks to be able to tell where to print sub details
|| 03/31/14 GHL     10.578   (210964) Removed SalesTaxAmount to determine Taxable status and modified
||                           spvInvoiceLineGet instead
|| 04/17/14 GHL     10.578   (213260) For the Taxable fields, differentiate summary and detail lines because
||                           spvInvoiceLineGet affects summary line only
*/

SELECT vInvoice.*, 
	p.ProjectNumber AS ProjectNumber, 
	p.ProjectName AS ProjectName, 
	LEFT(p.ProjectName, 25) AS ProjectShortName, 
	p.ClientProjectNumber as ClientProjectNumber,
	p.CustomFieldKey as CustomFieldKey,
	p.EstHours + p.ApprovedCOHours AS BudgetHours, 
	p.EstLabor + p.EstExpenses + p.ApprovedCOLabor + p.ApprovedCOExpense AS BudgetAmount, 
	CAST(p.Description AS VARCHAR(8000)) as ProjectDescription,
	p.ProjectKey as LineProjectKey,
	il.InvoiceLineKey,
	il.ParentLineKey,
	il.InvoiceOrder,
	il.LineLevel,
	il.LineType,
	case when il.LineType = 2 then
		-- Detail line: this is not recalculated by spvInvoiceLineGet, so recalc here
		case when il.Taxable = 1 and isnull(il.SalesTax1Amount, 0) <> 0 then 1 else 0 end
		-- Summary line: this is calculated by spvInvoiceLineGet
		else il.Taxable 
	end as Taxable ,
	case when il.LineType = 2 then
		-- Detail line: this is not recalculated by spvInvoiceLineGet, so recalc here
		case when il.Taxable2 = 1 and isnull(il.SalesTax2Amount, 0) <> 0 then 1 else 0 end
		-- Summary line: this is calculated by spvInvoiceLineGet
		else il.Taxable2 
	end as Taxable2 ,
	(Select COUNT(*) From tInvoiceLineTax ilt (NOLOCK) Where ilt.InvoiceLineKey = il.InvoiceLineKey and ilt.SalesTaxAmount <> 0) As Taxable3,
	il.LineSubject AS LineSubject, 
	il.LineDescription AS LineDescription, 
	il.BillFrom AS BillFrom, 
	il.Quantity, 
	il.UnitAmount, 
	il.TotalAmount,
	u.FirstName + ' ' + u.LastName as AEName,
	(Select Count(*) from tInvoiceLine (nolock) Where tInvoiceLine.ParentLineKey = il.InvoiceLineKey and tInvoiceLine.LineType = 1) as SummarySubCount,
	(Select ISNULL(Sum(BilledHours), 0) from tTime (nolock) Where tTime.InvoiceLineKey = il.InvoiceLineKey) as Hours,
	(Select ISNULL(Sum(ROUND(BilledHours * BilledRate, 2)), 0) from tTime (nolock) Where tTime.InvoiceLineKey = il.InvoiceLineKey) as Labor,
	(Select ISNULL(Sum(AmountBilled), 0) from tMiscCost (nolock) Where tMiscCost.InvoiceLineKey = il.InvoiceLineKey) + 
	(Select ISNULL(Sum(AmountBilled), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.InvoiceLineKey = il.InvoiceLineKey) + 
	(Select ISNULL(Sum(AmountBilled), 0) from tVoucherDetail (nolock) Where tVoucherDetail.InvoiceLineKey = il.InvoiceLineKey) + 
	(Select ISNULL(Sum(AmountBilled), 0) from tPurchaseOrderDetail (nolock) Where tPurchaseOrderDetail.InvoiceLineKey = il.InvoiceLineKey) as Expense

FROM tInvoiceLine il (NOLOCK) 
	INNER JOIN vInvoice (NOLOCK) ON il.InvoiceKey = vInvoice.InvoiceKey 
	LEFT OUTER JOIN tProject p  (NOLOCK) ON il.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tUser u  (NOLOCK) ON p.AccountManager = u.UserKey
GO
