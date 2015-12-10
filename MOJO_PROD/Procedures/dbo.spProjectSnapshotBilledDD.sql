USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectSnapshotBilledDD]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectSnapshotBilledDD]
	@ProjectKey int,
	@IncludeSalesTax tinyint
AS

/*
|| When      Who Rel     What
|| 4/30/08   CRG 1.0.0.0 Created for Project Snapshot drilldown
*/

	SELECT	i.InvoiceKey,
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.InvoiceTotalAmount, 
			CASE @IncludeSalesTax
				WHEN 1 THEN SUM(ISNULL(isum.Amount, 0) + ISNULL(isum.SalesTaxAmount, 0))
				ELSE SUM(isum.Amount)
			END AS ProjectAmount
	FROM	tInvoiceSummary isum (NOLOCK)			
	INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
	WHERE	i.AdvanceBill = 0
	AND		isum.ProjectKey = @ProjectKey
	GROUP BY i.InvoiceKey, i.InvoiceNumber, i.InvoiceDate, i.InvoiceTotalAmount
	ORDER BY i.InvoiceDate
GO
