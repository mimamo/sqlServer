USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillTaxCheckSales]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillTaxCheckSales]
	(
	@InvoiceKey INT
	,@AdvBillInvoiceKey INT
	,@TaxesAmount MONEY		-- all tax amounts from invoice advance bill TAX POPUP UI
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 03/13/09 GHL 10.021 The applied amount in tInvoiceAdvanceBill 
||                     - applied amount in tInvoiceAdvanceBillTax
||                     should not be greater than the amount on the lines of the real invoice
|| 04/28/09 GHL 10.024 Rewrote so that the check is now performed on the Adv Bill invoice 
||                     rather than the real invoice 
*/

	SET NOCOUNT ON
	
	Declare @AdvBillSalesAmount money
	Declare @AdvBillNonTaxAmount money
	Declare @AdvBillTaxAmount money

	select @AdvBillSalesAmount = TotalNonTaxAmount
	from tInvoice (nolock) Where InvoiceKey = @AdvBillInvoiceKey

	Select @AdvBillNonTaxAmount = SUM(Amount)
	From   tInvoiceAdvanceBill (NOLOCK)
	Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

	Select @AdvBillTaxAmount = SUM(Amount)
	From   tInvoiceAdvanceBillTax (NOLOCK)
	Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
	and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications
	and    InvoiceKey <> @InvoiceKey       -- exclude this invoice, since the pending updates are @TaxesAmount 			

	select @AdvBillSalesAmount = isnull(@AdvBillSalesAmount, 0)
			,@AdvBillNonTaxAmount = isnull(@AdvBillNonTaxAmount, 0)
			,@AdvBillTaxAmount = isnull(@AdvBillTaxAmount, 0)
			
	select	@AdvBillTaxAmount = @AdvBillTaxAmount + isnull(@TaxesAmount, 0)
	
	Select @AdvBillNonTaxAmount = ISNULL(@AdvBillNonTaxAmount, 0) - ISNULL(@AdvBillTaxAmount, 0)

	If @AdvBillNonTaxAmount > @AdvBillSalesAmount
		RETURN -1
	Else
		RETURN 1
GO
