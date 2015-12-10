USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTaxInsertMultiple]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTaxInsertMultiple]
	(
    @InvoiceKey int
	,@UpdateMode int = 1
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 05/22/13 GHL 10.568 (179160) Make sure now that amounts on header/invoice are always rolledup from taxes for split invoices
||                     To do so added UpdateMode so that we can call when sales tax keys have changed (complete reload) 
*/
	SET NOCOUNT ON
	
	/*
	Assume 
	create table #tax (
		InvoiceLineKey int null
		,SalesTaxKey int null
		,SalesTaxAmount money null
		,Type int null
		)
	*/
	
	if @UpdateMode = 1
	begin
		-- Update only	
		UPDATE tInvoiceTax
		SET    tInvoiceTax.SalesTaxAmount = #tax.SalesTaxAmount
		FROM   #tax
		WHERE  tInvoiceTax.InvoiceKey = @InvoiceKey
		AND    tInvoiceTax.InvoiceLineKey = #tax.InvoiceLineKey
		AND    tInvoiceTax.SalesTaxKey = #tax.SalesTaxKey
	end
	else
	begin
		-- complete reload
		delete tInvoiceTax where InvoiceKey = @InvoiceKey

		-- and reload them
		insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, SalesTaxAmount, Type)
		select @InvoiceKey, InvoiceLineKey, SalesTaxKey, SalesTaxAmount, Type
		from   #tax
	end


	DECLARE @SalesTax1Amount MONEY
	DECLARE @SalesTax2Amount MONEY
	DECLARE @SalesTaxAmount MONEY
	
	SELECT @SalesTax1Amount = SUM(SalesTaxAmount)
	FROM   tInvoiceTax (nolock)
	WHERE  InvoiceKey = @InvoiceKey
	AND    Type = 1 
	
	SELECT @SalesTax2Amount = SUM(SalesTaxAmount)
	FROM   tInvoiceTax (nolock)
	WHERE  InvoiceKey = @InvoiceKey
	AND    Type = 2
	
	SELECT @SalesTaxAmount = SUM(SalesTaxAmount)
	FROM   tInvoiceTax (nolock)
	WHERE  InvoiceKey = @InvoiceKey
	
	SELECT  @SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
			,@SalesTax1Amount = ISNULL(@SalesTax1Amount,0)
			,@SalesTax2Amount = ISNULL(@SalesTax2Amount,0) 
			
	UPDATE tInvoice
	SET    SalesTaxAmount     = @SalesTaxAmount
		  ,SalesTax1Amount	  = @SalesTax1Amount
		  ,SalesTax2Amount	  = @SalesTax2Amount  
		  ,InvoiceTotalAmount = isnull(TotalNonTaxAmount, 0) + @SalesTaxAmount
	WHERE InvoiceKey         = @InvoiceKey
	
	EXEC sptInvoiceSummary @InvoiceKey
	
	
	RETURN 1
GO
