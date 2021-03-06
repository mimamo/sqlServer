USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDClientInvoice]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptDDClientInvoice]
	@ProjectKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/18/08 CRG 1.0.0.0 Created for new Project Budget View        
*/

	SELECT 	i.InvoiceKey,
			ISNULL(c.CustomerID, '') + '-' + ISNULL(c.CompanyName, '') AS Client,
			i.InvoiceNumber,
			i.InvoiceDate,
			i.PostingDate,
			i.AdvanceBill,
			i.InvoiceTotalAmount,
			ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.TotalNonTaxAmount, 0) AS TaxableAmount,
			ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) AS OpenAmount,
			ISNULL((SELECT SUM(Amount) FROM tInvoiceAdvanceBill (nolock) WHERE AdvBillInvoiceKey = i.InvoiceKey), 0) AS AdvanceBillApplied,
			ISNULL((SELECT SUM(Amount) FROM tInvoiceSummary isum (nolock) WHERE i.InvoiceKey = isum.InvoiceKey AND isum.ProjectKey = @ProjectKey), 0) AS ProjectTotalAmount
	FROM	tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey
	INNER JOIN	(SELECT DISTINCT InvoiceKey 
				FROM	tInvoiceSummary (nolock) 
				WHERE	ProjectKey = @ProjectKey) isum2 ON i.InvoiceKey = isum2.InvoiceKey
	ORDER BY i.InvoiceNumber
GO
