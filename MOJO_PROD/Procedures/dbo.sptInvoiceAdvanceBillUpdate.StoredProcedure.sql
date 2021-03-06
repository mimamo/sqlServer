USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillUpdate]

	(
		@InvoiceAdvanceBillKey int,
		@Amount money
	)

AS --Encrypt
	
/*
|| When     Who Rel   What
|| 04/30/07 GHL 8.5  Auto create tax records for enhancement 6523.
|| 03/13/09 GHL 10.021 The applied amount in tInvoiceAdvanceBill - applied amount in tInvoiceAdvanceBillTax
||                     should not be greater than the amount on the lines
|| 04/22/09 GHL 10.024 Rolled back the 3/13/09 change at MW's request
||                     Putting now new restriction: the non tax total applied against the AB
||                     should not be greater than the non tax total on the AB invoice lines 
|| 09/16/09 GHL 10.510 (63192) Do not recalc the sales taxes when changing the applied amount
||                     Because of Labov situation when same taxes on Adv Bill and Reg Bill but different total amounts
||                     Solution is to apply with 1 dollar less, then change the sales taxes manually
||                     then apply with 1 more dollar, leaving taxes the same, this is why we cannot recalc taxes
|| 02/26/10  GHL 10.519  (74355) Enabling now a $0 application for a reg invoice to and advance bill
||                      This is to solve the problem of an advance bill having sales overapplied
||                      The idea is to create a $0 inv with negative sales and positive taxes applied
*/
	
Declare @InvoiceKey int, @AdvBillInv int, @AdvApplied money, @Applied money, @Amt money, @AppliedAdvBill money, @AdvBillAmount money, @OldAmount money, @AdvBillSalesAmount money

Select @InvoiceKey = InvoiceKey, @AdvBillInv = AdvBillInvoiceKey, @OldAmount = Amount 
From tInvoiceAdvanceBill (nolock) Where InvoiceAdvanceBillKey = @InvoiceAdvanceBillKey

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey and Posted = 1)
	Return -3
	
-- Make sure the target invoice is not overapplied
Select @Applied = ISNULL(sum(Amount), 0) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey and InvoiceAdvanceBillKey <> @InvoiceAdvanceBillKey

Select @Amt = ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0)
	From tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
if @Amt - @Applied - @Amount < 0
	Return -1
	

-- Make sure the source invoice is not overapplied
Select @AppliedAdvBill = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @AdvBillInv and InvoiceKey <> @InvoiceKey
select @AdvBillAmount = InvoiceTotalAmount 
	   ,@AdvBillSalesAmount = TotalNonTaxAmount
from tInvoice (nolock) Where InvoiceKey = @AdvBillInv

if @AdvBillAmount - @AppliedAdvBill - @Amount < 0
	return -2

Update
	tInvoiceAdvanceBill
Set
	Amount = @Amount
Where
	InvoiceAdvanceBillKey = @InvoiceAdvanceBillKey

-- Removed because we should not recalc the taxes
--If @Amount <> @OldAmount
--	exec sptInvoiceAdvanceBillTaxAutoApply @InvoiceKey, @AdvBillInv, @Amount
	
Declare @AdvBillNonTaxAmount money
Declare @AdvBillTaxAmount money

Select @AdvBillNonTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBill (NOLOCK)
Where  AdvBillInvoiceKey = @AdvBillInv
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @AdvBillTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBillTax (NOLOCK)
Where  AdvBillInvoiceKey = @AdvBillInv
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @AdvBillNonTaxAmount = ISNULL(@AdvBillNonTaxAmount, 0) - ISNULL(@AdvBillTaxAmount, 0)

if @Amount <> 0
begin
	-- Abort, if we went over what the sales amount is
	If @AdvBillNonTaxAmount > @AdvBillSalesAmount
	Begin
		Update tInvoiceAdvanceBill Set Amount = @OldAmount Where AdvBillInvoiceKey = @AdvBillInv and InvoiceKey = @InvoiceKey
		
		-- do not recalc the taxes
		--exec sptInvoiceAdvanceBillTaxAutoApply @InvoiceKey, @AdvBillInv, @OldAmount
		return -4
End
end
	
Select @Amt = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey and InvoiceKey <> AdvBillInvoiceKey

Update tInvoice Set RetainerAmount = ISNULL(@Amt, 0) Where InvoiceKey = @InvoiceKey

exec sptInvoiceUpdateAmountPaid @InvoiceKey

return 1
GO
