USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGetInvoiceList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGetInvoiceList]
	(
	@RetainerKey int
	)
AS	-- Encrypt

	/*
	Who		Rel		When		What
	GHL		82		12/26/2005	Removed reading of AmountReceived and OpenAmt since we moved
								tInvoice.RetainerKey to tInvoiceLine.RetainerKey
	GHL		83		03/27/2006	Added check of il.RetainerKey when calculating RetainerAmount
								to separate from invoices entered by user with BillFrom = 1
								and not generated from the mass billing screen
	GHL		84	    03/07/2007  Modified where clause in second insert so that duplicates are not
	                            inserted. Duplicates were skewing totals at bottom of the invoice list
	GWG		8.4.1.1	04/05/2007	The first statement to get the company key used RetainerKey = RetainerKey, not @RetainerKey
	GHL     8519    09/04/08    (34245) Removed Advance Bills
	RLB    10.5.4.9	Changed for Flex Retainer	
	GHL    10.5.6.4 01/29/2013  (166680) Added a filter for invoice lines. Do not pick FF (not TM) lines if this is for this retainer
	                            but the project has been removed from the retainer				
	*/

	SET NOCOUNT ON
	
	DECLARE @CompanyKey int
	
	SELECT @CompanyKey = CompanyKey
	FROM   tRetainer (NOLOCK)
	WHERE  RetainerKey = @RetainerKey

	-- There is already a retainer amount on tInvoice	
	CREATE TABLE #tInvoice (InvoiceKey int null, RetainerAmount2 money null, ExtraAmount money null)
	
	-- Capture invoices for extras
	INSERT #tInvoice (i.InvoiceKey)
	SELECT DISTINCT i.InvoiceKey
	FROM   tInvoice i (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
	WHERE  i.CompanyKey = @CompanyKey
	AND    i.AdvanceBill = 0
	AND    il.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey)
	AND	   il.BillFrom = 2 -- From transactions
	
	-- Capture invoices for lines entered for that retainer
	INSERT #tInvoice (i.InvoiceKey)
	SELECT DISTINCT i.InvoiceKey
	FROM   tInvoice i (NOLOCK)
		INNER JOIN tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
	WHERE  i.CompanyKey = @CompanyKey
	AND    i.AdvanceBill = 0
	AND    il.RetainerKey = @RetainerKey
	AND	   il.BillFrom = 1 -- Entered on Screen or FF
	AND    (isnull(il.ProjectKey, 0) = 0 -- this is a real retainer line entered without a project
			Or
			-- or the project still belongs to the retainer 
			il.ProjectKey IN (SELECT ProjectKey FROM tProject (NOLOCK) WHERE CompanyKey = @CompanyKey AND RetainerKey = @RetainerKey)
			) 
	AND    i.InvoiceKey NOT IN (SELECT InvoiceKey FROM #tInvoice)
	
	UPDATE #tInvoice
	SET	   #tInvoice.RetainerAmount2 = (SELECT SUM(il.TotalAmount) 
			   FROM tInvoiceLine il (NOLOCK)
			   INNER JOIN tInvoice i (NOLOCK) ON i.InvoiceKey = il.InvoiceKey				 
			   WHERE #tInvoice.InvoiceKey = i.InvoiceKey
			   AND   il.BillFrom = 1					-- No Transaction, Retainer Amount	
			   AND   il.RetainerKey = @RetainerKey	
			   )

	UPDATE #tInvoice
	SET	   #tInvoice.ExtraAmount = (SELECT SUM(il.TotalAmount) 
			   FROM tInvoiceLine il (NOLOCK)
			   INNER JOIN tInvoice i (NOLOCK) ON i.InvoiceKey = il.InvoiceKey				 
			   WHERE #tInvoice.InvoiceKey = i.InvoiceKey
			   AND   il.BillFrom = 2					-- Transaction, Extra Amount	
			   )

	SELECT  i.*
			,ISNULL(tmp.RetainerAmount2, 0) AS RetainerAmount2
			,ISNULL(tmp.ExtraAmount, 0) AS ExtraAmount		 
	FROM    #tInvoice tmp
		INNER JOIN tInvoice i (NOLOCK) ON i.InvoiceKey = tmp.InvoiceKey
							
	
	RETURN 1
GO
