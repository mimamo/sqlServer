USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectReconciliationSummary]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectReconciliationSummary]
	@ProjectKey int
AS

/*
|| When     Who Rel     What
|| 10/24/12 MFT 10.561  Created
|| 01/14/13 GWG 10.563  Flipped the variance calc
|| 05/30/13 MFT 10.568  Broke out labor & expense on lines
|| 06/04/13 MFT 10.568  Changed MiscCostNet and VoucherNet to Gross
|| 10/09/13 MFT 10.573  Changed BilledLabor & BilledExpense values to key on WorkTypeID = FEE rather than Entity
|| 11/08/13 MFT 10.574  Added ExpReceiptGross to Expense calc
|| 11/18/13 MFT 10.574  Added ApprovedCOLabor & ApprovedCOExpense to Est calcs AND changed final query to left join
*/

SELECT
	p.ProjectKey,
	p.ProjectName,
	u.FirstName + ' ' + u.LastName AS PrimaryContactName,
	p.ClientProjectNumber,
	p.ClientNotes,
	ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) AS EstLabor,
	ISNULL(pr.LaborGross, 0) AS ActLaborGross,
	ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) - ISNULL(pr.LaborGross, 0) AS LaborVariance,
	ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) AS EstExpenses,
	ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.ExpReceiptGross, 0) AS ActExpenses,
	ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) - ISNULL(pr.MiscCostGross, 0) - ISNULL(pr.VoucherGross, 0) - ISNULL(pr.ExpReceiptGross, 0) AS ExpensesVariance
INTO
	#header
FROM
	tProject p (nolock)
	LEFT JOIN tProjectRollup pr (nolock) ON p.ProjectKey = pr.ProjectKey
	LEFT JOIN tCompany cl (nolock) ON p.ClientKey = cl.CompanyKey
	LEFT JOIN tUser u (nolock) ON cl.PrimaryContact = u.UserKey
WHERE
	p.ProjectKey = @ProjectKey

SELECT
	ins.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	SUM(CASE ISNULL(wt.WorkTypeID, '') WHEN 'FEE' THEN ISNULL(ins.Amount, 0) ELSE 0 END) AS BilledLabor,
	SUM(CASE ISNULL(wt.WorkTypeID, '') WHEN 'FEE' THEN 0 ELSE ISNULL(ins.Amount, 0) END) AS BilledExpense,
	ISNULL(SUM(ins.Amount), 0) AS BilledAmount,
	ins.ProjectKey AS ProjectKey
INTO
	#lines
FROM
	tInvoiceSummary ins (nolock)
	INNER JOIN tInvoice i (nolock) ON ins.InvoiceKey = i.InvoiceKey
	INNER JOIN tInvoiceLine il (nolock) ON ins.InvoiceLineKey = il.InvoiceLineKey
	LEFT JOIN tWorkType wt (nolock) on il.WorkTypeKey = wt.WorkTypeKey
WHERE
	ins.ProjectKey = @ProjectKey
GROUP BY
	ins.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	ins.ProjectKey

SELECT
	h.*,
	l.InvoiceKey,
	ISNULL(l.InvoiceNumber, '') AS InvoiceNumber,
	l.InvoiceDate,
	ISNULL(l.BilledLabor, 0) AS BilledLabor,
	ISNULL(l.BilledExpense, 0) AS BilledExpense,
	ISNULL(l.BilledAmount, 0) AS BilledAmount
FROM
	#header h
	LEFT JOIN #lines l ON h.ProjectKey = l.ProjectKey
ORDER BY
	InvoiceDate
GO
