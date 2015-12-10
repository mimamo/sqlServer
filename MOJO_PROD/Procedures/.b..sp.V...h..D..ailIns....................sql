USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailInsert]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailInsert]
	@VoucherKey int,
	@PurchaseOrderDetailKey int,
	@ClientKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(2000),
	@Quantity decimal(15, 3),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Billable tinyint,
	@Markup decimal(9, 3),
	@BillableCost money,
	@ExpenseAccountKey int,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@LastVoucher tinyint,
	@OfficeKey int,
	@DepartmentKey int,
	@CheckProject int = 1,
	@Commission decimal(24,4) = null,
	@GrossAmount money = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,  
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 09/28/06 CRG 8.35  Added LastVoucher parameter, and modified accrual processing when LastVoucher = 1
|| 12/20/06 BSH 8.4   Added call to sptVoucherGetMaxDate
|| 3/17/07  GWG 8.41  Change the update close line to update the specific spot, not the line
|| 4/03/07  GHL 8.41  Added logic to get the client
|| 08/08/07 BSH 8.5   (9659)Insert OfficeKey, DepartmentKey
|| 01/31/08 GHL 8.503 (20244) Added CheckProject parameter so that the checking of the project 
||                    can be bypassed when creating vouchers from expense receipts  
|| 04/21/08 GHL 8.509 (24855) Update tItem.QuantityOnHand when approved and @TrackQuantityOnHand = 1 
|| 01/21/09 GWG 10.017 Modified the calculation of the amount to accrue to be 0 if the cost < 0 (basically do not un unaccrue)
|| 04/10/09 GHL 10.023 (50955) The problem is that when vd.TotalCost = 0 and LastVoucher = 1, no prebill reversal was posted
||                     Changed If @TotalCost > 0 to If @TotalCost >= 0 
|| 05/21/09 GWG 10.025 Modified the calculation of accrued cost to take in cases where an amount was unaccrued but now there is no amt to accrue. reverses it
|| 10/21/09 GHL 10.512 Changed the recalc of sales tax amounts to the line level, i.e. not invoice level
||                     So that we do not recalc other lines 
|| 07/07/11 GHL 10.546 (111482) Copying now taxes from PO to voucher detail when applying to a PO  
|| 08/24/11 GHL 10.547 Changed calculations for QuantityOnHand 
|| 08/30/11 GHL 10.547 (120094) Do not copy taxes from PO to voucher because sales taxes and total cost 
||                     could be different
|| 09/19/12 GHL 10.560 Increased ShortDescription to 2000 
|| 10/14/13 GHL 10.573 Added Commission + GrossAmount (new field)
||                     So that when we prebill at Net, GrossAmount = Net * ( 1 + MU/100), and BillableCost = Net
||                     This way the Item Rate Manager can still be used with Net and Gross Amount instead of Net and BillableCost
|| 11/06/13 GHL 10.574 Added fields for multi currency, make sure PExchangeRate > 0
|| 11/07/13 GHL 10.574 AccruedCost is in Home Currency, so convert for PrebillAmount
|| 03/19/14 RLB 10.578 (209928) added check on Billable when changing a zero gross amount
|| 09/03/14 GHL 10.584 (228260) When calling sptPurchaseOrderSpotChangeClose, do not affect billing
|| 03/04/15 WDF 10.590 (248350) Changed @CurItemQty decimal(9, 3) to decimal(24,4) to prevent arithmetic overflow error
*/

Declare @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money
Declare @Billed int, @Posted int, @Status int, @TrackQuantityOnHand int 
Declare @POExchangeRate decimal(24,7), @HTotalCost money

	SELECT @Posted = v.Posted
			,@Status = v.Status
			,@TrackQuantityOnHand = pre.TrackQuantityOnHand
	FROM   tVoucher v (NOLOCK)
		INNER JOIN tPreference pre (NOLOCK) on pre.CompanyKey = v.CompanyKey
	WHERE  v.VoucherKey = @VoucherKey
	 
	IF @Posted = 1
	    RETURN -3
	    	
	if @CheckProject = 1 And ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2
				
	DECLARE @NextNumber INT
	
	SELECT @NextNumber = MAX(LineNumber)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  VoucherKey = @VoucherKey
	
	IF @NextNumber IS NULL
		SELECT @NextNumber = 1
	ELSE
		SELECT @NextNumber = @NextNumber + 1
		
	Select @CurPODetAmt = ISNULL(AccruedCost, 0) from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	select @POPostedAmt = ISNULL(Sum(PrebillAmount), 0) from tVoucherDetail (NOLOCK) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				
	if @CurPODetAmt <> 0 OR @CurPODetAmt <> @POPostedAmt
	BEGIN
		-- Convert to Home Curr, using the exchange rate on the PO
		select @POExchangeRate = po.ExchangeRate
		from   tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
		where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

		select @POExchangeRate = isnull(@POExchangeRate, 1)

		if isnull(@POExchangeRate, 0) <= 0
			select @POExchangeRate = 1

		select @HTotalCost = ROUND(@TotalCost * @POExchangeRate, 2) 

		if @CurPODetAmt > 0
		BEGIN
			if @HTotalCost >= 0  -- Do nothing if the amount is less than 0 and the accrue amount > 0
			BEGIN
				if @CurPODetAmt < @POPostedAmt + @HTotalCost
					Select @AccrualAmt = @CurPODetAmt - @POPostedAmt
				else
					IF @LastVoucher = 1
						SELECT	@AccrualAmt = @CurPODetAmt - @POPostedAmt
					ELSE
						Select @AccrualAmt = @HTotalCost
			END
		END
		ELSE
		BEGIN
			if @HTotalCost <= 0
			BEGIN
				if @CurPODetAmt > @POPostedAmt + @HTotalCost
					Select @AccrualAmt = @CurPODetAmt - @POPostedAmt
				else
					IF @LastVoucher = 1
						SELECT	@AccrualAmt = @CurPODetAmt - @POPostedAmt
					ELSE
						Select @AccrualAmt = @HTotalCost
			END
		END
	END
	
	
	
	-- ClientLink: 1 via Project, 2 via Media Estimate
	Declare @CompanyKey int, @IOClientLink int, @BCClientLink int, @POKind int, @MediaEstimateKey int, @PODProjectKey int
	if isnull(@ClientKey, 0) = 0
	begin
	
		Select @CompanyKey = CompanyKey From tVoucher (nolock) Where VoucherKey = @VoucherKey  
		Select @IOClientLink = ISNULL(IOClientLink, 1), @BCClientLink = ISNULL(BCClientLink, 1)
		From   tPreference (nolock) Where CompanyKey = @CompanyKey

		EXEC sptVoucherDetailFindClient @ProjectKey, @ItemKey, @PurchaseOrderDetailKey, @IOClientLink ,@BCClientLink 
			,@ClientKey output	
	 end
	 
	-- If markup is null calculate from commission
	if @Markup is null and @Commission is not null
		select @Markup = dbo.fCommissionToMarkup(@Commission)
		 
	if @GrossAmount is null and @Billable = 1
		select @GrossAmount = ROUND(@TotalCost * (1 + @Markup/100), 2)

	if @PTotalCost is null
		select @PTotalCost = @TotalCost

	if isnull(@PExchangeRate, 0) <= 0
		select @PExchangeRate = 1

begin transaction

	if @Status = 4 AND @TrackQuantityOnHand = 1
	BEGIN
		Declare @CurItemQty decimal(24, 4)

		if ISNULL(@ItemKey, 0) > 0
		begin
			Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
			--Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey
			Update tItem Set QuantityOnHand = @CurItemQty + @Quantity Where ItemKey = @ItemKey

   			if @@ERROR <> 0 
			begin
			rollback transaction 
			return -1
			end

		end
	END	

	--If this is the last voucher for the PO Detail, close the PO Detail line	
	if isnull(@LastVoucher, 0) > 0
		if isnull(@PurchaseOrderDetailKey, 0) > 0
			exec sptPurchaseOrderSpotChangeClose @PurchaseOrderDetailKey, 1, 0 --and do not affect billing

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -1
	end
		
	INSERT tVoucherDetail
		(
		VoucherKey,
		LineNumber,
		PurchaseOrderDetailKey,
		ClientKey,
		ProjectKey,
		TaskKey,
		ItemKey,
		ClassKey,
		ShortDescription,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		UnitRate,
		Billable,
		Markup,
		BillableCost,
		AmountBilled,
		InvoiceLineKey,
		WriteOff,
		ExpenseAccountKey,
		Taxable,
		Taxable2,
		LastVoucher,
		OfficeKey,
		DepartmentKey,
		Commission,
		GrossAmount,
		PCurrencyID,
	    PExchangeRate,
	    PTotalCost  
		)

	VALUES
		(
		@VoucherKey,
		@NextNumber,
		@PurchaseOrderDetailKey,
		@ClientKey,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@ShortDescription,
		@Quantity,
		@UnitCost,
		@UnitDescription,
		@TotalCost,
		@UnitRate,
		@Billable,
		@Markup,
		@BillableCost,
		0,
		NULL,
		0,
		@ExpenseAccountKey,
		@Taxable,
		@Taxable2,
		@LastVoucher,
		@OfficeKey,
		@DepartmentKey,
		@Commission,
		@GrossAmount,
		@PCurrencyID,
	    @PExchangeRate,
	    @PTotalCost  
		)
	
	SELECT @oIdentity = @@IDENTITY
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
	Update tVoucherDetail Set PrebillAmount = ISNULL(@AccrualAmt, 0) Where VoucherDetailKey = @oIdentity

	if @BillableCost = 0 And @PurchaseOrderDetailKey > 0
		if exists(Select 1 from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey and InvoiceLineKey > 0)
			Update tVoucherDetail 
				Set InvoiceLineKey = 0, DateBilled = ISNULL(tPurchaseOrderDetail.DateBilled, GETDATE())
				from tPurchaseOrderDetail
				Where tVoucherDetail.PurchaseOrderDetailKey = tPurchaseOrderDetail.PurchaseOrderDetailKey and
					tVoucherDetail.VoucherDetailKey = @oIdentity

	exec sptPurchaseOrderDetailUpdateAppliedCost @PurchaseOrderDetailKey
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
	exec sptVoucherRecalcLineAmounts @VoucherKey, @oIdentity
		if @@ERROR <> 0 
		begin
		rollback transaction 
		return -1
		end

	EXEC sptVoucherGetMaxDate @oIdentity
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
commit transaction

	RETURN 1
GO
