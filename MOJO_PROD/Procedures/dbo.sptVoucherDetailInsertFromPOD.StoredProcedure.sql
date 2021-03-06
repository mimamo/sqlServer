USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailInsertFromPOD]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptVoucherDetailInsertFromPOD]
	@VoucherKey int,
	@PurchaseOrderDetailKey int--,
--	@oIdentity INT OUTPUT
AS --Encrypt

declare @oIdentity int
Declare @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money
Declare @Billed int, @Posted int, @Status int, @TrackQuantityOnHand int 
Declare @POExchangeRate decimal(24,7), @HTotalCost money

Declare 	@ClientKey int
Declare 	@ProjectKey int
Declare 	@TaskKey int
Declare 	@ItemKey int
Declare 	@ClassKey int
Declare 	@ShortDescription varchar(2000)
Declare 	@Quantity decimal(15, 3)
Declare 	@UnitCost money
Declare 	@UnitDescription varchar(30)
Declare 	@TotalCost money
Declare 	@UnitRate money
Declare 	@Billable tinyint
Declare 	@Markup decimal(9, 3)
Declare 	@BillableCost money
Declare 	@ExpenseAccountKey int
Declare 	@Taxable tinyint
Declare 	@Taxable2 tinyint
Declare 	@LastVoucher tinyint
Declare 	@OfficeKey int
Declare 	@DepartmentKey int
Declare 	@CheckProject int 
Declare 	@Commission decimal(24,4) 
Declare 	@GrossAmount money 
Declare 	@PCurrencyID varchar(10) 
Declare 	@PExchangeRate decimal(24,7) 
Declare 	@PTotalCost money 
declare     @CompanyKey int
Declare     @VendorKey int

	select @CompanyKey = PO.CompanyKey,
	@VendorKey = PO.VendorKey,
	@ProjectKey =POD.ProjectKey,
	@TaskKey = POD.TaskKey,
	@ItemKey = POD.ItemKey,
	@ClassKey = POD.ClassKey,
	@ShortDescription = POD.ShortDescription,
	@Quantity = POD.Quantity,
	@UnitCost = POD.UnitCost,
	@UnitDescription = POD.UnitDescription,
	@TotalCost = POD.TotalCost - ISNULL(POD.AppliedCost,0),
	@UnitRate = POD.UnitRate,
	@Billable = POD.Billable,
	@Markup = POD.Markup,
	@BillableCost = POD.BillableCost,
--	POD.ExpenseAccountKey,
	@Taxable = POD.Taxable,
	@Taxable2 = POD.Taxable2,
	@LastVoucher = 0,--@LastVoucher tinyint,
	@OfficeKey = POD.OfficeKey,
	@DepartmentKey = POD.DepartmentKey,
	@CheckProject = 0, --@CheckProject int = 1,
	@Commission = POD.Commission,
	@GrossAmount = POD.GrossAmount,
	@PCurrencyID =POD.PCurrencyID,
	@PExchangeRate = isnull(POD.PExchangeRate,1),
	@PTotalCost = NULL
	from tPurchaseOrderDetail POD
	inner join tPurchaseOrder PO on PO.PurchaseOrderKey = POD.PurchaseOrderKey
	where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
-- need to find flient and expense account

		if isnull(@ProjectKey, 0) > 0
			begin
				if ISNULL(@ItemKey, 0) > 0
					Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

				if ISNULL(@ExpenseAccountKey, 0) = 0
					Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
					
				if ISNULL(@ExpenseAccountKey, 0) = 0
					Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
			end

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
	Declare  @IOClientLink int, @BCClientLink int, @POKind int, @MediaEstimateKey int, @PODProjectKey int
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
