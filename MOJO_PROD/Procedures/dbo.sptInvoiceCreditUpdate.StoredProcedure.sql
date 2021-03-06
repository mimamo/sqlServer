USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditUpdate]
	@InvoiceCreditKey int,
	@Description varchar(500),
	@Amount money

AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money, @PaidAmount as money, @InvoiceKey int, @CreditInvoiceKey int

Select @InvoiceKey = InvoiceKey, @CreditInvoiceKey = CreditInvoiceKey from tInvoiceCredit (nolock) Where InvoiceCreditKey = @InvoiceCreditKey

Select @CreditAmt = ABS(InvoiceTotalAmount) from tInvoice Where InvoiceKey = @CreditInvoiceKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @CreditInvoiceKey and InvoiceCreditKey <> @InvoiceCreditKey

if @ApplAmt + @Amount > @CreditAmt
	return -1
	
	Declare @InvoiceTotal money
	Declare @InvoiceAmt money
	Select @CreditAmt = Amount from tInvoiceCredit (nolock) Where InvoiceCreditKey = @InvoiceCreditKey
	
	Select @InvoiceTotal = ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
		from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
		
	if @InvoiceTotal - @Amount + @CreditAmt < 0
		return -2
		
		
	UPDATE
		tInvoiceCredit
	SET
		Description = @Description,
		Amount = @Amount
	WHERE
		InvoiceCreditKey = @InvoiceCreditKey 
		
	exec sptInvoiceUpdateAmountPaid @InvoiceKey
	exec sptInvoiceUpdateAmountPaid @CreditInvoiceKey

	RETURN 1
GO
