USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetBillingSummary]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetBillingSummary]
	(
		@InvoiceKey INT
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel    What
  || 12/06/06 GHL 8.4    Creation for paid request 7050 Felder Communications Group 
  || 7/2/07   GWG 8.431  Modified the prior invoices to only include real invoices
  || 03/12/09 GWG 10.02  (47500) Modified billed to date to exclude advance bills
  || 01/11/13 MFT 10.565 (164197) Corrected prior invoice clause to use <= @InvoiceDate, rather than just <> @InvoiceKey
  */

	/*
	Based on the project specified on the header of the invoice, we would show:
 
	Total Estimate (only if > 0)
	Prior Invoices (not including this invoice) 
	Total Billed to Date
	Remaining to Bill (only if estimate is > 0)
	
	Look at the invoices lines not invoices when calculating the billed amounts
	*/


	DECLARE @ProjectKey INT
	DECLARE @TotalEstimate MONEY
	DECLARE @PriorInvoices MONEY
	DECLARE @PriorTaxes MONEY
	DECLARE @InvoiceAmount MONEY
	DECLARE @SalesTaxAmount MONEY
	DECLARE @BilledToDate MONEY
	DECLARE @ToBill MONEY
	DECLARE @InvoiceDate DATETIME
	
	SELECT @TotalEstimate = 0
	       ,@PriorInvoices = 0
	       ,@BilledToDate = 0
	       ,@ToBill = 0

	SELECT
		@ProjectKey = ProjectKey,
		@InvoiceDate = InvoiceDate
	FROM tInvoice (NOLOCK)
	WHERE InvoiceKey = @InvoiceKey
	
	IF @ProjectKey IS NULL
	BEGIN
		SELECT
			@ProjectKey AS ProjectKey
			,@TotalEstimate AS TotalEstimate
			,@PriorInvoices AS PriorInvoices
			,@BilledToDate AS BilledToDate
			,@ToBill AS ToBill
		RETURN -1
	END	
	
	-- Total Estimate
	SELECT @TotalEstimate = SUM(EstimateTotal)
	FROM   tEstimate (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	AND    ( (ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4) OR
			 (ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4)
		   )				  
	SELECT @TotalEstimate = ISNULL(@TotalEstimate, 0)
	
	-- Prior invoices
	SELECT @PriorInvoices = SUM(il.TotalAmount) FROM tInvoiceLine il (NOLOCK) 
		INNER JOIN tInvoice i (NOLOCK) on i.InvoiceKey = il.InvoiceKey
	WHERE  il.ProjectKey = @ProjectKey 
	AND    il.InvoiceKey <> @InvoiceKey
	AND    i.InvoiceDate < @InvoiceDate
	AND	   i.AdvanceBill = 0
	
	SELECT @PriorTaxes = SUM(tInvoiceLineTax.SalesTaxAmount) FROM tInvoiceLineTax (NOLOCK)
		INNER JOIN tInvoiceLine (NOLOCK) ON tInvoiceLine.InvoiceLineKey = tInvoiceLineTax.InvoiceLineKey
		INNER JOIN tInvoice (NOLOCK) on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey
	WHERE  tInvoiceLine.ProjectKey = @ProjectKey 
	AND    tInvoiceLine.InvoiceKey <> @InvoiceKey
	AND    tInvoice.InvoiceDate <= @InvoiceDate
	AND	   AdvanceBill = 0
	
	SELECT @PriorInvoices = ISNULL(@PriorInvoices, 0) + ISNULL(@PriorTaxes, 0)
	
	-- This invoice
	-- exlcude adv bills from the prior billing amount. 
	
	SELECT @InvoiceAmount = SUM(il.TotalAmount) 
	FROM tInvoiceLine il (NOLOCK) 
	INNER JOIN tInvoice i (NOLOCK) on i.InvoiceKey = il.InvoiceKey
	WHERE  i.InvoiceKey = @InvoiceKey and i.AdvanceBill = 0
	
	SELECT @SalesTaxAmount = SUM(tInvoiceLineTax.SalesTaxAmount) FROM tInvoiceLineTax (NOLOCK)
		INNER JOIN tInvoiceLine (NOLOCK) ON tInvoiceLine.InvoiceLineKey = tInvoiceLineTax.InvoiceLineKey
	WHERE  tInvoiceLine.InvoiceKey = @InvoiceKey
	
	SELECT @InvoiceAmount = ISNULL(@InvoiceAmount, 0) + ISNULL(@SalesTaxAmount, 0)

	-- Final Calcs
	SELECT @BilledToDate = ISNULL(@PriorInvoices, 0) + ISNULL(@InvoiceAmount, 0)
	SELECT @ToBill = @TotalEstimate - @BilledToDate
	IF @ToBill < 0
		SELECT @ToBill = 0
	 
	SELECT @ProjectKey AS ProjectKey
		,@TotalEstimate AS TotalEstimate
		,@PriorInvoices AS PriorInvoices
	    ,@BilledToDate AS BilledToDate
	    ,@ToBill AS ToBill
	
	RETURN 1
GO
