USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdateTotals]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdateTotals]

	(
		@InvoiceLineKey int
		,@RecalcSalesTaxes int = 1      -- by default we will recalc at invoice level
		,@RecalcLineSalesTaxes int = 0
	)

AS --Encrypt

 /*
  || When     Who Rel    What
  || 10/20/09 GHL 10.513 Added 2 parameters to be able to recalc sales taxes at line or invoice level
  ||                     Also have the ability to do it outside of this stored proc   
  */
  
 declare @BilledLabor money
		,@BilledMiscCost money
		,@BilledCost money
		,@BilledVoucherCost money
		,@BilledPOCost money
		,@InvoiceKey int
		,@TotalAmount money
		,@BillFrom int
		
 Select @InvoiceKey = InvoiceKey
		,@BillFrom = BillFrom 
 from tInvoiceLine (nolock) 
 Where InvoiceLineKey = @InvoiceLineKey

	-- GHL: Added this check for retainers because all transactions are marked with InvoiceLineKey
	-- But the amount should remain set to the retainer amount and should not be recalculated   
	IF @BillFrom = 1
		RETURN 1
		
	SELECT @BilledLabor = SUM(ROUND(ISNULL(BilledHours,0) * ISNULL(BilledRate,0), 2))
	FROM tTime (NOLOCK)
	WHERE InvoiceLineKey = @InvoiceLineKey
	
	SELECT @BilledMiscCost = isnull(SUM(ISNULL(AmountBilled,0)),0)
	FROM tMiscCost (NOLOCK)
	WHERE InvoiceLineKey = @InvoiceLineKey

	SELECT @BilledCost = isnull(SUM(ISNULL(AmountBilled,0)),0)
	FROM tExpenseReceipt (NOLOCK)
	WHERE InvoiceLineKey = @InvoiceLineKey

	SELECT @BilledVoucherCost = isnull(SUM(ISNULL(AmountBilled,0)),0)
	FROM tVoucherDetail (NOLOCK)
	WHERE InvoiceLineKey = @InvoiceLineKey
	
	SELECT @BilledPOCost = isnull(SUM(ISNULL(AmountBilled,0)),0)
	FROM tPurchaseOrderDetail (NOLOCK)
	WHERE InvoiceLineKey = @InvoiceLineKey
	
	select @TotalAmount = ROUND(ISNULL(@BilledLabor,0), 2) + ROUND(ISNULL(@BilledCost,0), 2) + ROUND(ISNULL(@BilledMiscCost,0), 2) + ROUND(ISNULL(@BilledVoucherCost,0), 2) + ROUND(ISNULL(@BilledPOCost,0), 2)

	Declare @CreditAmt money, @AdvBillAmt money, @InvoiceTotal money, @AppliedTotal money, @AdvBill tinyint, @LineAmt money
	Declare @CurTotal money, @Diff money

	Select @AdvBill = AdvanceBill, 
		@InvoiceTotal = ISNULL(InvoiceTotalAmount, 0),
		@AppliedTotal = isnull(AmountReceived, 0) + isnull(RetainerAmount, 0) + isnull(DiscountAmount, 0)
		from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
		
	Select @CurTotal = TotalAmount from tInvoiceLine (nolock) Where InvoiceLineKey = @InvoiceLineKey
	Select @Diff = @TotalAmount - @CurTotal
	
	if @Diff <> 0
	BEGIN
		if @InvoiceTotal < 0
		BEGIN
			-- verify the new line amount does not cause an overapplied situation
			Select @CreditAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey
			-- make sure the new amount does not send the line positive if credits are applied
			if @CreditAmt > 0
				if @InvoiceTotal + @Diff > 0
					return -101
					
			if ABS(@InvoiceTotal + @Diff) < @CreditAmt
				Return -100
			
		END
		if @AdvBill = 1
		BEGIN
			-- Make sure the line amount (neg) does not cause an overapplied situation
			Select @AdvBillAmt = ISNULL(Sum(Amount), 0) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey
			if ABS(@InvoiceTotal + @Diff) < ABS(@AdvBillAmt)
				return -201
		END

		-- verify the new line amount does not cause an overapplied situation
		if ABS(@InvoiceTotal + @Diff) < ABS(@AppliedTotal)
			return -301
	END
	
	UPDATE tInvoiceLine 
	SET  TotalAmount = @TotalAmount
	WHERE InvoiceLineKey = @InvoiceLineKey

	IF @@ERROR <> 0
		RETURN -400
	
	If @RecalcSalesTaxes = 1
	begin
		exec sptInvoiceRecalcAmounts @InvoiceKey
		
		IF @@ERROR <> 0
			RETURN -500
	end 
	
	If @RecalcLineSalesTaxes = 1
	begin
		exec sptInvoiceRecalcLineAmounts @InvoiceKey, @InvoiceLineKey

		IF @@ERROR <> 0
			RETURN -500
	end 
	
	RETURN 1
GO
