USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vInvoiceStmtAmounts]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vInvoiceStmtAmounts]
AS
SELECT 	i.*,
		ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) AS AmountBilled,
		(SELECT ISNULL(SUM(iab.Amount), 0)
		FROM	tInvoiceAdvanceBill iab (nolock) 
		WHERE	iab.InvoiceKey = i.InvoiceKey) AS AdvBillApplied
FROM	tInvoice i (nolock)
GO
