USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailUpdate]
	@VoucherDetailKey int = NULL,
	@VoucherKey int,
	@PurchaseOrderDetailKey int,
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
	@LastVoucher tinyint,
	@OfficeKey int,
	@DepartmentKey int,
	@TargetGLCompanyKey int = null,
	@ProjectRollup tinyint = 1,
	@Commission decimal(24,4) = null,
	@GrossAmount money = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null  
	
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
|| 08/24/11 GHL 10.547 Changed calculations for QuantityOnHand
|| 09/20/11 MFT 10.548 Added insert logic
|| 11/29/11 GHL 10.550 Added @ProjectRollup parameter because in Flex, it is not advisable to make project rollup calls in a loop
||                     We do it at the end of the loop (projects need to be queried at the begining and the end of the process)
||                     This is OK in ASP when we update one line at a time
||                     Also removed call to sptVoucherRecalcLineAmounts because this is done in the UI in Flex and in a second DB call in ASP
|| 03/26/12 GHL 10.554 Added setting of vd.TargetGLCompanyKey = po.GLCompanyKey
||                     + @TargetGLCompanyKey param
|| 09/12/12 GHL 10.560 (153656) Reading identity and error in one select
|| 09/19/12 GHL 10.560 Increased ShortDescription to 2000 
|| 11/16/12 GWG 10.562 Added a check for project gl company to be the same as either the header or target.
|| 02/06/12 GHL 10.564 (167821) If posted, allowing now to update a few fields
|| 04/03/13 GHL 10.566 (173714) Added isnull(GLCompanyKey, 0) when returning error -4
|| 10/14/13 GHL 10.573 Added Commission + GrossAmount (new field)
||                     So that when we prebill at Net, GrossAmount = Net * ( 1 + MU/100), and BillableCost = Net
||                     This way the Item Rate Manager can still be used with Net and Gross Amount instead of Net and BillableCost
||                     Calculate markup from commission
|| 11/06/13 GHL 10.574 Added Multi Currency logic, make sure that exchange rate > 0
||                     AccruedCost is in Home Currency, so convert to PrebillAmount using PO exchange rate
|| 01/20/14 GHL 10.575 For import compare isnull(PTotalCost, 0) to 0 rather than PTotalCost to NULL
|| 03/19/14 RLB 10.578 (209928) added check on Billable when changing a zero gross amount
|| 04/23/14 GHL 10.579 (213864) If Billable = 0, set GrossAmount = 0
|| 09/03/14 GHL 10.584 (228260) When calling sptPurchaseOrderSpotChangeClose, do not affect billing
|| 03/04/15 WDF 10.590 (248350) Changed @CurQty decimal(9, 3) and @CurItemQty decimal(9, 3) to 
||                       decimal(24,4) due to arithmetic overflow error
|| 04/17/15 GHL 10.591 (253794) PO and VI lines must have the same project currency
*/ 

	Declare @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money, @ProjectGLCompanyKey int, @HeaderGLCompanyKey int
	Declare @Posted int, @Status int, @TrackQuantityOnHand int, @Error int
	Declare @CurItemKey int, @CurQty decimal(24, 4), @CurItemQty decimal(24, 4)
	Declare @POExchangeRate decimal(24,7), @HTotalCost MONEY, @MultiCurrency int

	SELECT @Posted = v.Posted
			,@Status = v.Status
			,@TrackQuantityOnHand = pre.TrackQuantityOnHand
			,@HeaderGLCompanyKey = ISNULL(v.GLCompanyKey, 0)
			,@MultiCurrency = ISNULL(pre.MultiCurrency, 0)
	FROM   tVoucher v (NOLOCK)
		INNER JOIN tPreference pre (NOLOCK) on pre.CompanyKey = v.CompanyKey
	WHERE  v.VoucherKey = @VoucherKey
	
	-- If markup is null calculate from commission
	if @Markup is null and @Commission is not null
		select @Markup = dbo.fCommissionToMarkup(@Commission)
		 
	if isnull(@GrossAmount, 0) = 0 and @Billable = 1
		select @GrossAmount = ROUND(@TotalCost * (1 + @Markup/100), 2)
	
	if @Billable = 0
		select @GrossAmount = 0

	IF isnull(@PTotalCost,0) = 0
		select @PTotalCost = @TotalCost

	if isnull(@PExchangeRate, 0) <= 0
		select @PExchangeRate = 1

	IF @Posted = 1 And @VoucherDetailKey <=0
	  RETURN -3
	
	IF @Posted = 1 And @VoucherDetailKey >0
	BEGIN
		-- Just update the couple of fields enabled on the screen and exit out
		-- this way, users can still update the description and the billing info
		UPDATE
			tVoucherDetail
		SET
			ShortDescription = @ShortDescription,
			UnitRate = @UnitRate,
			Billable = @Billable,
			Markup = @Markup,
			BillableCost = @BillableCost,
			Commission = @Commission,
			GrossAmount = @GrossAmount
		WHERE
			VoucherDetailKey = @VoucherDetailKey

		RETURN @VoucherDetailKey
	END


	if ISNULL(@ProjectKey, 0) > 0
	BEGIN
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2


		Select @ProjectGLCompanyKey = ISNULL(GLCompanyKey, 0) from tProject (nolock) Where ProjectKey = @ProjectKey

		if isnull(@ProjectGLCompanyKey, 0) <> isnull(@HeaderGLCompanyKey, 0) 
		   And isnull(@ProjectGLCompanyKey, 0) <> isnull(@TargetGLCompanyKey, 0)
			Return -4
	END
	
	DECLARE @NextNumber INT
	
	SELECT @NextNumber = MAX(LineNumber)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  VoucherKey = @VoucherKey
	
	IF @NextNumber IS NULL
		SELECT @NextNumber = 1
	ELSE
		SELECT @NextNumber = @NextNumber + 1
	
	if ISNULL(@PurchaseOrderDetailKey, 0) > 0
		BEGIN --@PurchaseOrderDetailKey > 0
			
			DECLARE @PODPCurrencyID VARCHAR(10), @ProjectCurrencyID VARCHAR(10)
			IF @MultiCurrency = 1
			BEGIN
				SELECT @PODPCurrencyID = PCurrencyID FROM tPurchaseOrderDetail (NOLOCK) WHERE PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				-- VI and PO lines must have the same currency ID
				IF ISNULL(@PCurrencyID, '') <> ISNULL(@PODPCurrencyID, '')
					RETURN -5
				IF @ProjectKey > 0
					SELECT @ProjectCurrencyID = CurrencyID FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey
				-- Project and PO lines must have the same currency ID
				IF ISNULL(@ProjectCurrencyID, '') <> ISNULL(@PODPCurrencyID, '')
					RETURN -5
			END
            
			Select @CurPODetAmt = ISNULL(AccruedCost, 0), @PreBillAmt = ISNULL(AmountBilled, 0) from tPurchaseOrderDetail (NOLOCK) 
			Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			select @POPostedAmt = ISNULL(Sum(PrebillAmount), 0) from tVoucherDetail (NOLOCK) 
			Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey and VoucherDetailKey <> isnull(@VoucherDetailKey, 0)
			
			if @CurPODetAmt <> 0 OR @CurPODetAmt <> @POPostedAmt
				BEGIN --@CurPODetAmt <> 0 OR @CurPODetAmt <> @POPostedAmt

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
						BEGIN --@CurPODetAmt > 0
							if @HTotalCost >= 0  -- Do nothing if the amount is less than 0 and the accrue amount > 0
								BEGIN --@TotalCost >= 0
									if @CurPODetAmt < @POPostedAmt + @HTotalCost
										Select @AccrualAmt = @CurPODetAmt - @POPostedAmt
									else
										IF @LastVoucher = 1
											SELECT	@AccrualAmt = @CurPODetAmt - @POPostedAmt
										ELSE
											Select @AccrualAmt = @HTotalCost
								END --@TotalCost >= 0
						END --@CurPODetAmt > 0
					ELSE
						BEGIN --@CurPODetAmt = 0
							if @HTotalCost <= 0
								BEGIN --@TotalCost <= 0
									if @CurPODetAmt > @POPostedAmt + @HTotalCost
										Select @AccrualAmt = @CurPODetAmt - @POPostedAmt
									else
										IF @LastVoucher = 1
											SELECT	@AccrualAmt = @CurPODetAmt - @POPostedAmt
										ELSE
											Select @AccrualAmt = @HTotalCost
								END --@TotalCost <= 0
						END --@CurPODetAmt = 0
				END --@CurPODetAmt <> 0 OR @CurPODetAmt <> @POPostedAmt
		END --@PurchaseOrderDetailKey > 0
	
	IF ISNULL(@VoucherDetailKey, 0) > 0
		BEGIN --UPDATE
			--Get the previous value for LastVoucher
			DECLARE	@OldLastVoucher tinyint
							,@OldProjectKey int
			
			SELECT	@OldLastVoucher = LastVoucher
							 ,@OldProjectKey = ProjectKey
			FROM	tVoucherDetail (NOLOCK)
			WHERE	VoucherDetailKey = @VoucherDetailKey
			
			SELECT	@OldLastVoucher = ISNULL(@OldLastVoucher, 0)
			SELECT	@LastVoucher = ISNULL(@LastVoucher, 0)
			
			begin transaction
			
				-- If already approved and we track qty on hand
				-- this happens when we approve automatically
				if @Status = 4 and @TrackQuantityOnHand = 1
					BEGIN --@Status = 4 and @TrackQuantityOnHand = 1
						Select @CurItemKey = ISNULL(ItemKey, 0), @CurQty = ISNULL(Quantity, 0)
						from tVoucherDetail (nolock)
						Where VoucherDetailKey = @VoucherDetailKey
						
						if ISNULL(@CurItemKey, 0) <> ISNULL(@ItemKey, 0)
							BEGIN --@CurItemKey <> @ItemKey
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
							END --@CurItemKey <> @ItemKey
						ELSE
							BEGIN --@CurItemKey = @ItemKey
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
									end --ISNULL(@ItemKey, 0) > 0
							END --@CurItemKey = @ItemKey
					END --@Status = 4 and @TrackQuantityOnHand = 1
				
				UPDATE
					tVoucherDetail
				SET
					VoucherKey = @VoucherKey,
					PurchaseOrderDetailKey = @PurchaseOrderDetailKey,
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
					PrebillAmount = ISNULL(@AccrualAmt, 0),
					Taxable = @Taxable,
					Taxable2 = @Taxable2,
					LastVoucher = @LastVoucher,
					OfficeKey = @OfficeKey,
					DepartmentKey = @DepartmentKey,
					TargetGLCompanyKey = @TargetGLCompanyKey,
					Commission = @Commission,
					GrossAmount = @GrossAmount,
					PCurrencyID = @PCurrencyID,
					PExchangeRate = @PExchangeRate,
					PTotalCost = @PTotalCost
				WHERE
					VoucherDetailKey = @VoucherDetailKey
				
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				
				exec sptPurchaseOrderDetailUpdateAppliedCost @PurchaseOrderDetailKey
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				
				--If the LastVoucher checkbox is changed, update the PO Detail line
				IF @OldLastVoucher <> @LastVoucher
					IF ISNULL(@PurchaseOrderDetailKey, 0) > 0
						exec sptPurchaseOrderSpotChangeClose @PurchaseOrderDetailKey, @LastVoucher, 0 -- do not affect billing
				
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				
				EXEC sptVoucherGetMaxDate @VoucherDetailKey
				
			commit transaction
			
			DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
			if @ProjectRollup = 1
			begin
			SELECT	@TranType = 4,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 1
				EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
				IF @OldProjectKey <> @ProjectKey
					EXEC sptProjectRollupUpdate @OldProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
			end

			RETURN @VoucherDetailKey
		END --UPDATE
	ELSE
		BEGIN --INSERT
			-- ClientLink: 1 via Project, 2 via Media Estimate
			Declare @CompanyKey int, @IOClientLink int, @BCClientLink int, @POKind int, @MediaEstimateKey int, @PODProjectKey int
			if isnull(@ClientKey, 0) = 0
				begin --@ClientKey = 0
					Select @CompanyKey = CompanyKey From tVoucher (nolock) Where VoucherKey = @VoucherKey
					
					Select @IOClientLink = ISNULL(IOClientLink, 1), @BCClientLink = ISNULL(BCClientLink, 1)
					From   tPreference (nolock) Where CompanyKey = @CompanyKey
					
					EXEC sptVoucherDetailFindClient @ProjectKey, @ItemKey, @PurchaseOrderDetailKey, @IOClientLink, @BCClientLink, @ClientKey output
	 			end --@ClientKey = 0
	 		
	 		begin transaction
	 			if @Status = 4 AND @TrackQuantityOnHand = 1
	 				BEGIN --@Status = 4 and @TrackQuantityOnHand = 1
						if ISNULL(@ItemKey, 0) > 0
							begin --@ItemKey > 0
								Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
								--Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey
								Update tItem Set QuantityOnHand = @CurItemQty + @Quantity Where ItemKey = @ItemKey
								
				   			if @@ERROR <> 0
									begin
										rollback transaction
										return -1
									end
							end --@ItemKey > 0
					END --@Status = 4 and @TrackQuantityOnHand = 1
				
				--If this is the last voucher for the PO Detail, close the PO Detail line
				if isnull(@LastVoucher, 0) > 0
					if isnull(@PurchaseOrderDetailKey, 0) > 0
						exec sptPurchaseOrderSpotChangeClose @PurchaseOrderDetailKey, 1, 0 -- do not affect billing
				
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
						TargetGLCompanyKey,
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
						@TargetGLCompanyKey,
						@Commission,
						@GrossAmount,
						@PCurrencyID,
	                    @PExchangeRate,
	                    @PTotalCost  
					)
				
				SELECT @VoucherDetailKey = SCOPE_IDENTITY(), @Error = @@Error
				if @Error <> 0
					begin
						rollback transaction
						return -1
					end
				
				Update tVoucherDetail Set PrebillAmount = ISNULL(@AccrualAmt, 0) Where VoucherDetailKey = @VoucherDetailKey
				
				if @BillableCost = 0 And @PurchaseOrderDetailKey > 0
					if exists(Select 1 from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey and InvoiceLineKey > 0)
						Update tVoucherDetail
						Set InvoiceLineKey = 0, DateBilled = ISNULL(tPurchaseOrderDetail.DateBilled, GETDATE())
						from tPurchaseOrderDetail
						Where
							tVoucherDetail.PurchaseOrderDetailKey = tPurchaseOrderDetail.PurchaseOrderDetailKey and
							tVoucherDetail.VoucherDetailKey = @VoucherDetailKey
				
				if @PurchaseOrderDetailKey > 0
				begin
					update tVoucherDetail
					set    tVoucherDetail.TargetGLCompanyKey = case when po.GLCompanyKey = 0 then null else po.GLCompanyKey end 
					from   tPurchaseOrderDetail pod (nolock)
						inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
					where  tVoucherDetail.VoucherDetailKey = @VoucherDetailKey
					and   pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				end

				exec sptPurchaseOrderDetailUpdateAppliedCost @PurchaseOrderDetailKey
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				
				/* Removed this call because the taxes are constantly recalculated in the UI in Flex
				   and in ASP, there is a subsequent call to do it
				    
				exec sptVoucherRecalcLineAmounts @VoucherKey, @VoucherDetailKey
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				*/

				EXEC sptVoucherGetMaxDate @VoucherDetailKey
				if @@ERROR <> 0
					begin
						rollback transaction
						return -1
					end
				
			commit transaction
				
			RETURN @VoucherDetailKey
		END --INSERT
GO
