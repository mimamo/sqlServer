USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectRetainerCosts]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProjectRetainerCosts] AS

  /*
  || When     Who Rel     What
  || 07/09/07 GHL 8.5      Added restriction of ER where VoucherDetailKey is null
  || 09/03/08 GHL 10.0.0.7 Using now tProjectRollup instead of subqueries
  || 12/15/08 GHL 10.0.1.5 (41911) Taking in account project non billable status to be 
  ||                       consistent with project status page  
  */

SELECT 	p.ProjectKey, p.RetainerKey, 
	ISNULL(roll.LaborGross, 0) as TotalLabor,
	ISNULL(
		ISNULL(roll.MiscCostGross, 0) + 
		ISNULL(roll.ExpReceiptGross, 0) + 
	 	ISNULL(roll.VoucherGross, 0) +
		(
		Select ISNULL(Sum(BillableCost), 0) 
		from tPurchaseOrderDetail (nolock) 
		Where tPurchaseOrderDetail.ProjectKey = p.ProjectKey 
		AND (tPurchaseOrderDetail.InvoiceLineKey > 0 
			or 
			(ISNULL(tPurchaseOrderDetail.AppliedCost, 0) = 0 and tPurchaseOrderDetail.Closed = 0)
			)
		)
	, 0) as TotalExpense,
	ISNULL((SELECT	SUM(il.TotalAmount)
		FROM	tInvoiceLine il (NOLOCK)
		INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
		WHERE	i.CompanyKey = p.CompanyKey
		AND	il.ProjectKey = p.ProjectKey), 0) AS Billed
FROM	tProject p (NOLOCK)
LEFT OUTER JOIN tProjectRollup roll (NOLOCK) ON p.ProjectKey = roll.ProjectKey
WHERE 	ISNULL(p.RetainerKey, 0) <> 0
AND     ISNULL(p.NonBillable, 0) = 0
GO
