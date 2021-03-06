USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillDelete]

	(
		@InvoiceKey int,
		@InvoiceAdvanceBillKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 04/30/07 GHL 8.5  Added tInvoiceAdvanceBillTax for enhancement 6523.
|| 05/07/07 GHL 8.421 Added call to sptInvoiceUpdateAmountPaid. Bug 9159. 
||                    When we delete record, RetainerAmount is affected and voucher DatePaidByClient also
*/

Declare @AppliedAmount money

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey and Posted = 1)
	Return -1

Declare @AdvBillInvoiceKey INT
Select @AdvBillInvoiceKey = AdvBillInvoiceKey
From   tInvoiceAdvanceBill (NOLOCK)
Where  InvoiceAdvanceBillKey = @InvoiceAdvanceBillKey 

Delete tInvoiceAdvanceBillTax
Where
	InvoiceKey = @InvoiceKey
And
	AdvBillInvoiceKey = @AdvBillInvoiceKey
	
Delete tInvoiceAdvanceBill
Where
	InvoiceAdvanceBillKey = @InvoiceAdvanceBillKey
	
Select @AppliedAmount = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey and InvoiceKey <> AdvBillInvoiceKey

Update tInvoice Set RetainerAmount = ISNULL(@AppliedAmount, 0) Where InvoiceKey = @InvoiceKey

exec sptInvoiceUpdateAmountPaid @InvoiceKey
GO
