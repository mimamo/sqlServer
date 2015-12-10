USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailUpdateCC]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailUpdateCC]
	@VoucherDetailKey int,
	@VoucherKey int,
	@ClientKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(2000),
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@BillableCost money,
	@ExpenseAccountKey int,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@OfficeKey int,
	@DepartmentKey int,
	@TargetGLCompanyKey int = null,
	@GrossAmount money = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,
	@Exclude1099 money = null

AS --Encrypt

/*
|| When     Who Rel   What
|| 09/28/06 CRG 8.35  Added LastVoucher parameter, and modified accrual processing when LastVoucher = 1
|| 12/20/06 BSH 8.4   Added call to sptVoucherGetMaxDate
|| 02/14/07 GHL 8.4   Added project rollup section
|| 3/17/07  GWG 8.41  Change the update close line to update the specific spot, not the line
|| 08/08/07 BSH 8.5   (9659)Update OfficeKey, DepartmentKey
|| 04/21/08 GHL 8.509 (24855) Update tItem.QuantityOnHand when approved and @TrackQuantityOnHand = 1 
|| 01/21/09 GWG 10.017 Modified the calculation of the amount to accrue to be 0 if the cost < 0 (basically do not un unaccrue)
|| 04/10/09 GHL 10.023 (50955) The problem is that when vd.TotalCost = 0 and LastVoucher = 1, no prebill reversal was posted
||                     Changed If @TotalCost > 0 to If @TotalCost >= 0 
|| 05/21/09 GWG 10.025 Modified the calculation of accrued cost to take in cases where an amount was unaccrued but now there is no amt to accrue. reverses it
|| 09/16/09 GHL 10.5   Removed recalc of Sales Tax Amounts
|| 08/17/11 GHL 10.547 Cloned sptVoucherDetailUpdate for CC charges 
|| 08/24/11 GHL 10.547 Changed calculations for QuantityOnHand 
|| 11/18/11 GHL 10.550 Removed project rollup since it is done at the end of the saving of the credit card
|| 04/03/12 GHL 10.555 Added @TargetGLCompanyKey param
|| 09/19/12 GHL 10.560 Increased ShortDescription to 2000 
|| 11/20/13 GHL 10.574 Added Multi Currency logic
|| 02/06/14 GHL 10.576 (204536) Added rounding of net and gross amounts
|| 03/22/14 RLB 10.578 (203504) Added field for enhancement 
|| 03/04/15 WDF 10.590 (248350) Changed @CurQty decimal(9, 3) and @CurItemQty decimal(9, 3) to 
                       decimal(24,4) to prevent arithmetic overflow error 
*/

Declare @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money
Declare @Posted int, @Status int, @TrackQuantityOnHand int

	SELECT @Posted = v.Posted
			,@Status = v.Status
			,@TrackQuantityOnHand = pre.TrackQuantityOnHand
	FROM   tVoucher v (NOLOCK)
		INNER JOIN tPreference pre (NOLOCK) on pre.CompanyKey = v.CompanyKey
	WHERE  v.VoucherKey = @VoucherKey
	    

	-- we allow now updates of ShortDescription after posting
	--IF @Posted = 1
	--    RETURN -1
	    
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2
	
	select @TotalCost = ROUND(@TotalCost, 2)
	select @BillableCost = ROUND(@BillableCost, 2)
	select @PTotalCost = ROUND(@PTotalCost, 2)
	select @GrossAmount = ROUND(@GrossAmount, 2)
			
begin transaction

	-- If already approved and we track qty on hand
	-- this happens when we approve automatically
	if @Status = 4 and @TrackQuantityOnHand = 1
		BEGIN
		Declare @CurItemKey int, @CurQty decimal(24, 4), @CurItemQty decimal(24, 4)

		Select @CurItemKey = ISNULL(ItemKey, 0), @CurQty = ISNULL(Quantity, 0) 
		from tVoucherDetail (nolock) 
		Where VoucherDetailKey = @VoucherDetailKey

		if ISNULL(@CurItemKey, 0) <> ISNULL(@ItemKey, 0)
		BEGIN
			-- Add to Old Qty and reduce New Item Qty
			Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @CurItemKey
			--Update tItem Set QuantityOnHand = @CurItemQty + @CurQty Where ItemKey = @CurItemKey
			Update tItem Set QuantityOnHand = @CurItemQty - @CurQty Where ItemKey = @CurItemKey

			if @@ERROR <> 0 
			begin
			rollback transaction 
			return -1
			end
			
			Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @ItemKey
			--Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey
			Update tItem Set QuantityOnHand = @CurItemQty + @Quantity Where ItemKey = @ItemKey

			if @@ERROR <> 0 
			begin
			rollback transaction 
			return -1
			end
			
		END
		ELSE
		BEGIN
			if ISNULL(@ItemKey, 0) > 0
			begin
				Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @ItemKey
				--Update tItem Set QuantityOnHand = @CurItemQty + @CurQty - @Quantity Where ItemKey = @ItemKey
				Update tItem Set QuantityOnHand = @CurItemQty - @CurQty + @Quantity Where ItemKey = @ItemKey

				if @@ERROR <> 0 
				begin
				rollback transaction 
				return -1
				end

			end

		END
	END			

	UPDATE
		tVoucherDetail
	SET
		VoucherKey = @VoucherKey,
		ClientKey = @ClientKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ItemKey = @ItemKey,
		ClassKey = @ClassKey,
		ShortDescription = @ShortDescription,
		Quantity = @Quantity,
		UnitCost = @UnitCost,
		UnitDescription = @UnitDescription,
		TotalCost = @TotalCost,
		UnitRate = @UnitRate,
		Billable = @Billable,
		Markup = @Markup,
		BillableCost = @BillableCost,
		ExpenseAccountKey = @ExpenseAccountKey,
		Taxable = @Taxable,
		Taxable2 = @Taxable2,
		SalesTax1Amount = isnull(@SalesTax1Amount, 0),
		SalesTax2Amount = isnull(@SalesTax2Amount, 0),
		SalesTaxAmount = isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0),

		OfficeKey = @OfficeKey,
		DepartmentKey = @DepartmentKey,
		TargetGLCompanyKey = @TargetGLCompanyKey,

		GrossAmount = @GrossAmount,
		PCurrencyID = @PCurrencyID,
		PExchangeRate = @PExchangeRate,
		PTotalCost = @PTotalCost,
		Exclude1099 = @Exclude1099
	WHERE
		VoucherDetailKey = @VoucherDetailKey 
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end


EXEC sptVoucherGetMaxDate @VoucherDetailKey

commit transaction

		
	RETURN 1
GO
