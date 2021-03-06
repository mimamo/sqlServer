USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Retainer_Prelim]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vListing_Retainer_Prelim] AS

  /*
  || When     Who Rel     What
  || 02/10/09 GWG 10.019  Added a restriction so that advance bills are not included in what has been billed
  || 10/08/09 GHL 10.512  (50725) Added RetainerAmount and ExtraAmount
  || 05/13/13 RLB 10.569  (177962) Removed AdvanceBill from the totals like Retainer SnapShot
  */

SELECT	r.RetainerKey,
	ISNULL((SELECT	SUM(il.TotalAmount)
		FROM	tInvoice i (NOLOCK)
		Inner join tInvoiceLine il (NOLOCK) on i.InvoiceKey = il.InvoiceKey
		WHERE	il.RetainerKey = r.RetainerKey
		AND i.AdvanceBill = 0
		AND	il.BillFrom = 1), 0) + 
		ISNULL((Select SUM(il.TotalAmount)
		FROM   tInvoiceLine il (NOLOCK)
		Inner join tProject p (nolock) on il.ProjectKey = p.ProjectKey
		inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		Where p.RetainerKey = r.RetainerKey
		and i.AdvanceBill = 0
		and il.BillFrom = 2), 0)
 AS TotalBilled,

	ISNULL((SELECT	SUM(il.TotalAmount)
		FROM	tInvoice i (NOLOCK)
		Inner join tInvoiceLine il (NOLOCK) on i.InvoiceKey = il.InvoiceKey
		WHERE	il.RetainerKey = r.RetainerKey
		AND i.AdvanceBill = 0
		AND	il.BillFrom = 1), 0) 
AS RetainerAmount,

	ISNULL((Select SUM(il.TotalAmount)
		FROM   tInvoiceLine il (NOLOCK)
		Inner join tProject p (nolock) on il.ProjectKey = p.ProjectKey
		inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		Where p.RetainerKey = r.RetainerKey
		and i.AdvanceBill = 0
		and il.BillFrom = 2), 0)
 AS ExtraAmount,

	v.TotalLabor,
	v.TotalExpense
FROM	tRetainer r (NOLOCK)
LEFT JOIN vRetainerCosts v (NOLOCK) ON r.RetainerKey = v.RetainerKey
GO
