USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetProject]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetProject]
	@ProjectKey int
AS

/*
|| When      Who Rel      What
|| 12/16/14  MFT 10.5.8.6 Created for Platinum Billing Worksheets
|| 01/19/15  MFT 10.5.8.8 Changed tInvoiceLine to tInvoiceSummary
*/

SELECT
	i.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	SUM(ISNULL(ins.Amount, 0)) AS TotalAmount
FROM
	tInvoice i (nolock)
	LEFT JOIN tInvoiceSummary ins (nolock) ON i.InvoiceKey = ins.InvoiceKey
WHERE
	ins.ProjectKey = @ProjectKey
GROUP BY
	i.InvoiceDate,
	i.InvoiceKey,
	i.InvoiceNumber
ORDER BY
	i.InvoiceDate,
	i.InvoiceNumber
GO
