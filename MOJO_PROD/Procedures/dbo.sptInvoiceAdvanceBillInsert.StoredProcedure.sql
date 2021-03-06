USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillInsert]

	(
		@InvoiceKey int,
		@AdvBillInvoiceKey int,
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
|| 02/26/10 GHL 10.519  (74355) Enabling now a $0 application for a reg invoice to and advance bill
||                      This is to solve the problem of an advance bill having sales overapplied
||                      The idea is to create a $0 inv with negative sales and positive taxes applied
|| 01/12/13 GHL 10.563  (164761) Instead of returning an error if we over apply sales, just reduce applied amount 
|| 02/15/13 GHL 10.564  (166221) Calculate an amount to reduce on the real invoice side also
|| 02/19/13 GHL 10.565  (169152) Only reduce on the real side if no taxes have been applied
||                       Because the Sales Tax Analysis reports considers this as a payment of the real inv
*/

Declare @OpenAmount money, @AppliedAdvBill money, @AdvBillAmount money, @Amt money, @AdvBillSalesAmount money

if exists(select 1 from tInvoice (nolock) Where InvoiceKey = @InvoiceKey and Posted = 1)
	Return -3

-- cannot overapply the real invoice
Select @OpenAmount = ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(RetainerAmount, 0) - isnull(DiscountAmount, 0) - isnull(AmountReceived, 0)
 	From tInvoice (nolock) Where InvoiceKey = @InvoiceKey

If @OpenAmount - @Amount < 0
	return -1
	
-- cannot overapply the adv bill
Select @AppliedAdvBill = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @AdvBillInvoiceKey
select @AdvBillAmount = InvoiceTotalAmount 
	   ,@AdvBillSalesAmount = TotalNonTaxAmount
from tInvoice (nolock) Where InvoiceKey = @AdvBillInvoiceKey

if @AdvBillAmount - @AppliedAdvBill - @Amount < 0
	return -2
	

Insert tInvoiceAdvanceBill (InvoiceKey, AdvBillInvoiceKey, Amount)
Values (@InvoiceKey, @AdvBillInvoiceKey, @Amount)

exec sptInvoiceAdvanceBillTaxAutoApply @InvoiceKey, @AdvBillInvoiceKey, @Amount

Declare @AdvBillNonTaxAmount money
Declare @AdvBillTaxAmount money

Select @AdvBillNonTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBill (NOLOCK)
Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @AdvBillTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBillTax (NOLOCK)
Where  AdvBillInvoiceKey = @AdvBillInvoiceKey
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @AdvBillNonTaxAmount = ISNULL(@AdvBillNonTaxAmount, 0) - ISNULL(@AdvBillTaxAmount, 0)

-- do the same on real invoice side
Declare @RealInvoiceNonTaxAmount money
Declare @RealInvoiceTaxAmount money
Declare @RealInvoiceSalesAmount money

Select @RealInvoiceNonTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBill (NOLOCK)
Where  InvoiceKey = @InvoiceKey
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @RealInvoiceTaxAmount = SUM(Amount)
From   tInvoiceAdvanceBillTax (NOLOCK)
Where  InvoiceKey = @InvoiceKey
and    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications

Select @RealInvoiceNonTaxAmount = ISNULL(@RealInvoiceNonTaxAmount, 0) - ISNULL(@RealInvoiceTaxAmount, 0)

select @RealInvoiceSalesAmount = TotalNonTaxAmount
from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

-- Amount to reduce on AB side
declare @Amt1 money
If @AdvBillNonTaxAmount > @AdvBillSalesAmount
	select @Amt1 = @AdvBillNonTaxAmount - @AdvBillSalesAmount

-- Amount to reduce on Real side (only if there are IAB taxes for this application see 169152)
declare @IABTAmount money
select @IABTAmount = Sum(Amount)
from   tInvoiceAdvanceBillTax (nolock)
where  InvoiceKey = @InvoiceKey
and    AdvBillInvoiceKey = @AdvBillInvoiceKey

declare @Amt2 money
If @RealInvoiceNonTaxAmount > @RealInvoiceSalesAmount and isnull(@IABTAmount, 0) <> 0
	select @Amt2 = @RealInvoiceNonTaxAmount - @RealInvoiceSalesAmount

select @Amt1 = isnull(@Amt1, 0)
select @Amt2 = isnull(@Amt2, 0)

-- take the largest
if @Amt2 > @Amt1
	select @Amt = @Amt2
else 
	select @Amt = @Amt1

--select @Amt, @Amt1, @Amt2

if @Amount <> 0
begin
	-- Abort, if we went over what the sales amount is
	-- or reduce the amount applied
	--If @AdvBillNonTaxAmount > @AdvBillSalesAmount
	If @Amt <> 0
	Begin
		--select @Amt = @AdvBillNonTaxAmount - @AdvBillSalesAmount

		-- if we are in the limits of the application
		if @Amt < @Amount
			-- reduce the amount
			update tInvoiceAdvanceBill set Amount = Amount - @Amt 
			where  InvoiceKey = @InvoiceKey
			and    AdvBillInvoiceKey = @AdvBillInvoiceKey
		else
		begin
			-- else abort
			Delete tInvoiceAdvanceBill Where AdvBillInvoiceKey = @AdvBillInvoiceKey and InvoiceKey = @InvoiceKey
			Delete tInvoiceAdvanceBillTax Where AdvBillInvoiceKey = @AdvBillInvoiceKey and InvoiceKey = @InvoiceKey
			return -4
		end
	End
end
	
Select @Amt = Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey and InvoiceKey <> AdvBillInvoiceKey

Update tInvoice Set RetainerAmount = ISNULL(@Amt, 0) Where InvoiceKey = @InvoiceKey

exec sptInvoiceUpdateAmountPaid @InvoiceKey

return 1
GO
