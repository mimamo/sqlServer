USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReceiptsGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptExpenseReceiptsGet]
 @ExpenseEnvelopeKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 7/19/07   CRG 8.5      (9833) Modifications for Enhancement.
|| 8/27/09   GHL 10.5     Added filter on TransferToKey
|| 10/10/09	 GWG 10.5.12  Added Item Name
|| 11/6/09   CRG 10.5.1.3 Added PercComp
|| 05/17/10  RLB 10.5.2.2 Ordering by Expense Date and Item Name to match printing of the page 
|| 02/22/11  RLB 10.5.4.2 (100772) added ActualCostWithTaxes for Sales Tax
*/

	SELECT	er.*,
			p.ProjectNumber,
			p.ProjectName,
			t.TaskID,
			t.TaskName,
			i.InvoiceKey,
			i.InvoiceNumber,
			v.InvoiceNumber AS VoucherNumber,
			v.VoucherKey,
			it.ItemID,
			it.ItemName,
			t.PercComp,
			ISNULL(er.ActualCost, 0) + ISNULL(er.SalesTaxAmount, 0) as ActualCostWithTaxes
	FROM	tExpenseReceipt er (nolock)
	LEFT JOIN tProject p (nolock) ON er.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock) ON er.TaskKey = t.TaskKey
	LEFT JOIN tInvoiceLine il (nolock) ON er.InvoiceLineKey = il.InvoiceLineKey
	LEFT JOIN tInvoice i (nolock) ON il.InvoiceKey = i.InvoiceKey
	LEFT JOIN tVoucherDetail vd (nolock) ON er.VoucherDetailKey = vd.VoucherDetailKey
	LEFT JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
	LEFT JOIN tItem it (nolock) ON er.ItemKey = it.ItemKey
	INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	WHERE	er.ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	AND     er.TransferToKey IS NULL
	ORDER BY er.ExpenseDate, it.ItemName
  
 return 1
GO
