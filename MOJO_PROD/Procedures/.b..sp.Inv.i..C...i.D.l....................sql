USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceCreditDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceCreditDelete]

	(
		@InvoiceKey int,
		@InvoiceCreditKey int
	)

AS --Encrypt

Declare @AppliedAmount money, @CreditInvoiceKey int

Select @CreditInvoiceKey = CreditInvoiceKey from tInvoiceCredit (nolock) Where InvoiceCreditKey = @InvoiceCreditKey

Delete tInvoiceCredit
Where
	InvoiceCreditKey = @InvoiceCreditKey
	
exec sptInvoiceUpdateAmountPaid @InvoiceKey
exec sptInvoiceUpdateAmountPaid @CreditInvoiceKey
GO
