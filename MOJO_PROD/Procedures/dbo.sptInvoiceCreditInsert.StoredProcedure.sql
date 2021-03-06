USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditInsert]
	@InvoiceKey int,
	@CreditInvoiceKey int,
	@Description varchar(500),
	@Amount money
AS --Encrypt

Declare @CreditAmt as money, @ApplAmt as money

Select @CreditAmt = ABS(InvoiceTotalAmount) from tInvoice (nolock) Where InvoiceKey = @CreditInvoiceKey
Select @ApplAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @CreditInvoiceKey

if @ApplAmt + @Amount > @CreditAmt
	return -1
	
	Declare @InvoiceTotal money
	Declare @InvoiceAmt money

	Select @InvoiceTotal = ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
		from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
		
	if @InvoiceTotal < @Amount
		return -2

	
	INSERT tInvoiceCredit
		(
		InvoiceKey,
		CreditInvoiceKey,
		Description,
		Amount
		)

	VALUES
		(
		@InvoiceKey,
		@CreditInvoiceKey,
		@Description,
		@Amount
		)
		
	exec sptInvoiceUpdateAmountPaid @InvoiceKey
	exec sptInvoiceUpdateAmountPaid @CreditInvoiceKey

	RETURN 1
GO
