USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineDelete]
	@InvoiceLineKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/22/07 GHL 8.4  Added Project Rollup section.
  || 05/01/07 GHL 8.5  Added check of sales taxes in tInvoiceAdvanceBillTax
  || 08/07/07 GHL 8.5  Added invoice summary rollup + modified project rollup 
  || 08/22/07 GWG 8.5  Fixed logic in checking if ok to delete on applied credits
  || 09/26/07 GHL 8.5  Removed invoice summary since it is done in invoice recalc amounts  
  || 10/12/07 CRG 8.5  Modified to mark voucher unbilled if linked to an Expense Receipt that is being removed from this invoice line.  
  || 11/09/07 GHL 8.5  Modified checking of WIPPostingInKey 
  || 03/09/09 GHL 10.020 (48695) Added check of TotalCost <> 0 for prebill accruals  
  || 09/24/09 GHL 10.5 Replaced sptInvoiceRecalcAmounts by sptInvoiceRollupAmounts
  || 12/10/10 GHL 10.539 (96967) Renamed #tProjectRollup to #project_roll this was causing problem when calling sptProjectRollupUpdate in SQL 2000
  || 11/16/11 GHL 10.550 (126231) Modified the way we calculate LastBillingDate on retainers
  ||                     = max i.InvoiceDate where il.RetainerKey = RetainerKey instead of 
  ||                     = max i.InvoiceDate where il.RetainerKey = RetainerKey and i.InvoiceKey <> InvoiceKey
  || 04/20/12 GHL 10.555 (140727) Added nulling of BilledItem
  */

declare @CurrentDisplayOrder int
declare @InvoiceKey int
declare @CurrentParentLineKey int
Declare @TotalAmount money
Declare @CreditAmt money, @AdvBillAmt money, @InvoiceTotal money, @AppliedTotal money, @AdvBill tinyint, @LineAmt money
Declare @CurTotal money, @Diff money
Declare @CompanyKey int, @InvoiceDate datetime, @UpdateRetainer int, @RetainerKey int, @RetainerLastBillingDate datetime, @ProjectKey int

	IF EXISTS(SELECT 1 FROM tInvoiceLine (nolock) WHERE ParentLineKey = @InvoiceLineKey) 
		RETURN -1

	IF EXISTS(SELECT 1 FROM tTime (nolock) WHERE InvoiceLineKey = @InvoiceLineKey and (WIPPostingInKey <> 0 or WIPPostingOutKey <> 0)) 
		RETURN -2

	IF EXISTS(SELECT 1 FROM tExpenseReceipt (nolock) WHERE InvoiceLineKey = @InvoiceLineKey and (WIPPostingInKey <> 0 or WIPPostingOutKey <> 0)) 
		RETURN -2

	IF EXISTS(SELECT 1 FROM tMiscCost (nolock) WHERE InvoiceLineKey = @InvoiceLineKey and (WIPPostingInKey <> 0 or WIPPostingOutKey <> 0)) 
		RETURN -2

	IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) WHERE InvoiceLineKey = @InvoiceLineKey and (WIPPostingInKey <> 0 or WIPPostingOutKey <> 0)) 
		RETURN -2

	-- You can not delete an invoice if it has a prebilled order and that order has a voucher applied to it. This would cause the prebill accruals to go out of whack
	IF EXISTS(SELECT 1 FROM tPurchaseOrderDetail pd (nolock) 
				inner join tVoucherDetail vd (nolock) on pd.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey 
				WHERE pd.InvoiceLineKey = @InvoiceLineKey
				AND   ISNULL(pd.TotalCost, 0) <> 0 -- Must have something to accrue
				) 
		RETURN -3

	select @CurrentDisplayOrder = DisplayOrder
	      ,@InvoiceKey = InvoiceKey
	      ,@CurrentParentLineKey = ParentLineKey
	      ,@TotalAmount = TotalAmount
		  ,@RetainerKey = isnull(RetainerKey, 0)	
		  ,@ProjectKey = ProjectKey
	  from tInvoiceLine (nolock) 
	 where InvoiceLineKey = @InvoiceLineKey

	Select @AdvBill = AdvanceBill
		  ,@InvoiceTotal = ISNULL(InvoiceTotalAmount, 0)
		  ,@AppliedTotal = isnull(AmountReceived, 0) + isnull(RetainerAmount, 0) + isnull(DiscountAmount, 0)
		  ,@CompanyKey = CompanyKey
		  ,@InvoiceDate = InvoiceDate
	from tInvoice (nolock) 
	Where InvoiceKey = @InvoiceKey



	if @InvoiceTotal < 0
	BEGIN
		-- verify the new line amount does not cause an overapplied situation
		Select @CreditAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey
		-- make sure the new amount does not send the line positive if credits are applied
		if @CreditAmt > 0
		BEGIN
			if @InvoiceTotal - @TotalAmount > 0
			BEGIN
				return -101
			end
		END
		if ABS(@InvoiceTotal) - ABS(@TotalAmount) < ABS(@CreditAmt)
		BEGIN
			Return -100
		END
	END

	if @AdvBill = 1
	BEGIN
		-- Make sure the line amount (neg) does not cause an overapplied situation
		Select @AdvBillAmt = ISNULL(Sum(Amount), 0) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey
		if ABS(@InvoiceTotal - @TotalAmount) < ABS(@AdvBillAmt)
			return -201
	END

	-- verify the new line amount does not cause an overapplied situation
	if ABS(@InvoiceTotal - @TotalAmount) < ABS(@AppliedTotal)
		return -301



	Select @UpdateRetainer = 0
	if @RetainerKey <> 0
		begin
			Select @RetainerLastBillingDate = LastBillingDate
			From tRetainer (NOLOCK)
			Where RetainerKey = @RetainerKey

			If @InvoiceDate = @RetainerLastBillingDate
			begin
				Select @UpdateRetainer = 1
					  ,@RetainerLastBillingDate = NULL

				Select @RetainerLastBillingDate = MAX(i.InvoiceDate)
				From   tInvoice i (NOLOCK)
					Inner Join tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
				Where  i.CompanyKey = @CompanyKey
				And	   il.RetainerKey = @RetainerKey
				And	   il.BillFrom = 1 -- Indicates retainer amount
			end
		end 

	-- capture projects recreating the summary
	create table #project_roll (ProjectKey int null)
	insert #project_roll (ProjectKey)
	select distinct ProjectKey from tInvoiceSummary (nolock) 
	where ProjectKey is not null 
	and InvoiceKey = @InvoiceKey
	and InvoiceLineKey = @InvoiceLineKey

	Begin Transaction

	If @UpdateRetainer = 1
	begin
		Update tRetainer Set LastBillingDate = @RetainerLastBillingDate Where RetainerKey = @RetainerKey  

		if @@ERROR <> 0 
		begin
		rollback transaction 
		return -1
		end
	end

	update tInvoiceLine
	   set DisplayOrder = DisplayOrder - 1
	 where InvoiceKey = @InvoiceKey
	   and ParentLineKey = @CurrentParentLineKey
	   and DisplayOrder > @CurrentDisplayOrder


	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	update tTime
	   set 
		InvoiceLineKey = null,
		BilledService = null,
		BilledHours = null,
		BilledRate = null,
		DateBilled = NULL
	 where InvoiceLineKey = @InvoiceLineKey

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	update tVoucherDetail
	   set 
		InvoiceLineKey = null,
		BilledItem = null,
		AmountBilled = null,
		DateBilled = NULL	
	 where InvoiceLineKey = @InvoiceLineKey

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	update tMiscCost
	   set 
		InvoiceLineKey = null,
		BilledItem = null,
		AmountBilled = null,
		DateBilled = NULL
	 where InvoiceLineKey = @InvoiceLineKey

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	--If Expense Receipts linked to this invoice line are also linked to a voucher, mark as Unbilled
	UPDATE	tVoucherDetail
	SET		DateBilled = null,
			BilledItem = null,
			InvoiceLineKey = null
	FROM	tExpenseReceipt er (nolock)
	INNER JOIN tInvoiceLine il (nolock) ON er.InvoiceLineKey = il.InvoiceLineKey
	WHERE	il.InvoiceLineKey = @InvoiceLineKey
	AND		er.VoucherDetailKey = tVoucherDetail.VoucherDetailKey
	 
	update tExpenseReceipt
	   set 
		InvoiceLineKey = null,
		BilledItem = null,
		AmountBilled = null,
		DateBilled = NULL
	 where InvoiceLineKey = @InvoiceLineKey

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	update tPurchaseOrderDetail
	   set 
		InvoiceLineKey = null,
		BilledItem = null,
		AccruedCost = NULL,
		AmountBilled = null,
		DateBilled = NULL
	 where InvoiceLineKey = @InvoiceLineKey

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	DELETE tInvoiceLineTax
	 WHERE
	  InvoiceLineKey = @InvoiceLineKey 

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	DELETE tInvoiceLine
	 WHERE
	  InvoiceLineKey = @InvoiceLineKey 

	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

Commit Transaction

	EXEC sptInvoiceRollupAmounts @InvoiceKey
	exec sptInvoiceOrder @InvoiceKey, 0, 0, 0

	-- Project Rollup with TranType = Billing (6)
	Select @ProjectKey = -1
	While (1=1)
	Begin
		Select @ProjectKey = Min(ProjectKey)
		From #project_roll
		Where ProjectKey > @ProjectKey

		If @ProjectKey is null
			break

		EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0
	End

	EXEC sptInvoiceAdvanceBillTaxCheck @InvoiceKey

	RETURN 1
GO
