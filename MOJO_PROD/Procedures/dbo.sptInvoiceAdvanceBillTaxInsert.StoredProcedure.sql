USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxInsert]
	(
		@InvoiceKey int
		,@AdvBillInvoiceKey int
		,@SalesTaxKey int
		,@Amount money
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 04/26/07 GHL 8.5  Creation for enhancement 6523.
|| 09/30/09 GHL 10.5 Using now tInvoiceTax
*/

	-- Please note:
	-- Sales Tax 1 on Header: SalesTaxKey but SalesTax1Amount
	-- Sales Tax 2 on Header: SalesTax2Key and SalesTax2Amount

	SET NOCOUNT ON

	IF ISNULL(@Amount, 0) = 0
	BEGIN
		DELETE tInvoiceAdvanceBillTax
		WHERE  InvoiceKey = @InvoiceKey
		AND    AdvBillInvoiceKey = @AdvBillInvoiceKey
		AND    SalesTaxKey = @SalesTaxKey
	
		RETURN 1
	END
		
	IF @InvoiceKey = 0 OR @AdvBillInvoiceKey = 0 OR @SalesTaxKey = 0
		RETURN 1
	
	DECLARE @InvoiceTaxAmount MONEY
	DECLARE @AdvBillInvoiceTaxAmount MONEY
	DECLARE @AppliedAdvBillInvoiceTaxAmount MONEY
	DECLARE @UnappliedAdvBillInvoiceTaxAmount MONEY
		
	-- cannot be more than the amount on the invoice
	SELECT @InvoiceTaxAmount = 
	ISNULL(
		(SELECT SalesTax1Amount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    SalesTaxKey = @SalesTaxKey)
	,0)
	
	SELECT @InvoiceTaxAmount = @InvoiceTaxAmount + 
	ISNULL(
		(SELECT SalesTax2Amount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    SalesTax2Key = @SalesTaxKey)
	, 0)
	
	SELECT @InvoiceTaxAmount = @InvoiceTaxAmount +
	ISNULL(
		(SELECT SUM(it.SalesTaxAmount)
		FROM   tInvoiceTax it (NOLOCK)
		WHERE  it.InvoiceKey = @InvoiceKey
		AND    it.Type = 3
		AND    it.SalesTaxKey = @SalesTaxKey)
	, 0)
		
	IF @Amount > @InvoiceTaxAmount 
		SELECT @Amount = @InvoiceTaxAmount
	
	-- calc adv bill amount
	SELECT @AdvBillInvoiceTaxAmount = 
	ISNULL(
		(SELECT SalesTax1Amount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @AdvBillInvoiceKey
		AND    SalesTaxKey = @SalesTaxKey)
	, 0)

	SELECT @AdvBillInvoiceTaxAmount = @AdvBillInvoiceTaxAmount + 
	ISNULL(
		(SELECT SalesTax2Amount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @AdvBillInvoiceKey
		AND    SalesTax2Key = @SalesTaxKey)
	, 0)
	
	SELECT @AdvBillInvoiceTaxAmount = @AdvBillInvoiceTaxAmount +
	ISNULL(
		(SELECT SUM(it.SalesTaxAmount)
		FROM   tInvoiceTax it (NOLOCK)
		WHERE  it.InvoiceKey = @AdvBillInvoiceKey
		AND    it.Type = 3
		AND    it.SalesTaxKey = @SalesTaxKey)
	, 0)	
	
	-- calc applied amount for that sales tax and for other invoices
	SELECT @AppliedAdvBillInvoiceTaxAmount = 
	ISNULL(
		   (SELECT SUM(Amount)
			FROM tInvoiceAdvanceBillTax (NOLOCK)
			WHERE  InvoiceKey <> @InvoiceKey
			AND    AdvBillInvoiceKey = @AdvBillInvoiceKey
			AND    SalesTaxKey = @SalesTaxKey)
		,0)
	
	-- cannot be more than the unapplied
	SELECT @UnappliedAdvBillInvoiceTaxAmount = @AdvBillInvoiceTaxAmount - @AppliedAdvBillInvoiceTaxAmount
	
	IF @Amount > @UnappliedAdvBillInvoiceTaxAmount	
		SELECT @Amount = @UnappliedAdvBillInvoiceTaxAmount
		 	
	IF @Amount <= 0
		RETURN 1
				 	
	UPDATE tInvoiceAdvanceBillTax
	SET    Amount = @Amount
	WHERE  InvoiceKey = @InvoiceKey
	AND    AdvBillInvoiceKey = @AdvBillInvoiceKey
	AND    SalesTaxKey = @SalesTaxKey
	
	IF @@ROWCOUNT = 0
		INSERT tInvoiceAdvanceBillTax(InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
		VALUES (@InvoiceKey, @AdvBillInvoiceKey, @SalesTaxKey, @Amount)
	
	RETURN 1
GO
