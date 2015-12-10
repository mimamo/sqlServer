USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectSnapshotUnappliedDD]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectSnapshotUnappliedDD]
	@CompanyKey int,
	@ProjectKey int,
	@IncludeSalesTax tinyint
AS

/*
|| When      Who Rel     What
|| 4/30/08   CRG 1.0.0.0 Created for Project Snapshot drilldown
|| 5/14/10   GHL 10.522  (80683) When IncludeSalesTax = 1, InvoiceTotalAmount = InvoiceTotalAmount, not TotalNonTaxAmount
*/

IF @IncludeSalesTax = 1
	SELECT	adv.InvoiceKey,
			adv.InvoiceNumber, 
			adv.InvoiceDate, 
			adv.InvoiceTotalAmount,
			adv.LineAmount AS ProjectAmount,
			adv.AmountApplied
	FROM (
			SELECT ISNULL(i.InvoiceTotalAmount, 0)		AS InvoiceTotalAmount
				,ISNULL(inv.LineAmount, 0)				AS LineAmount
				,ISNULL((SELECT SUM(iab.Amount)
					FROM tInvoiceAdvanceBill iab (NOLOCK)
					WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
				, 0) AS AmountApplied,
				i.InvoiceNumber, 
				i.InvoiceDate,
				i.InvoiceKey				 	
			FROM tInvoice i (NOLOCK)
			INNER JOIN	-- Starting Point: we need unique Adv Bill invoices with line for the project
				(SELECT isum.InvoiceKey
				, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
				--, ISNULL(SUM(isum.Amount), 0) AS LineAmount -- might as well calc LineAmount here
				FROM  tInvoiceSummary isum (NOLOCK)
					INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
				WHERE isum.ProjectKey = @ProjectKey
				AND   i2.CompanyKey = @CompanyKey
				AND   i2.AdvanceBill = 1
				GROUP BY isum.InvoiceKey 
				) AS inv ON i.InvoiceKey = inv.InvoiceKey
			WHERE i.CompanyKey = @CompanyKey
			AND   i.AdvanceBill = 1
			) AS adv
ELSE
	SELECT	adv.InvoiceKey,
			adv.InvoiceNumber, 
			adv.InvoiceDate, 
			adv.InvoiceTotalAmount,
			adv.LineAmount AS ProjectAmount,
			adv.AmountApplied
	FROM (
			SELECT ISNULL(i.TotalNonTaxAmount, 0)		AS InvoiceTotalAmount
				,ISNULL(inv.LineAmount, 0)				AS LineAmount
				,ISNULL((SELECT SUM(iab.Amount)
					FROM tInvoiceAdvanceBill iab (NOLOCK)
					WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
				, 0)									
				- ISNULL((SELECT SUM(iabt.Amount)
					FROM tInvoiceAdvanceBillTax iabt (NOLOCK)
					WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)
				, 0)
				AS AmountApplied,
				i.InvoiceNumber, 
				i.InvoiceDate,
				i.InvoiceKey
			FROM tInvoice i (NOLOCK)
			INNER JOIN	-- Starting Point: we need unique Adv Bill invoices with line for the project
				(SELECT isum.InvoiceKey
				--, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
				, ISNULL(SUM(isum.Amount), 0) AS LineAmount -- might as well calc LineAmount here
				FROM  tInvoiceSummary isum (NOLOCK)
					INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
				WHERE isum.ProjectKey = @ProjectKey
				AND   i2.CompanyKey = @CompanyKey
				AND   i2.AdvanceBill = 1
				GROUP BY isum.InvoiceKey 
				) AS inv ON i.InvoiceKey = inv.InvoiceKey
			WHERE i.CompanyKey = @CompanyKey
			AND   i.AdvanceBill = 1
			) AS adv
GO
