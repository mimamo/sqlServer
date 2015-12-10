USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailUpdate]
	@PaymentDetailKey int = NULL,
	@PaymentKey int,
	@GLAccountKey int,
	@ClassKey int,
	@VoucherKey int,
	@Description varchar(500),
	@Quantity decimal(9, 3),
	@UnitAmount money,
	@DiscAmount money,
	@Amount money,
	@OfficeKey int,
	@DepartmentKey int,
	@Exclude1099 money = 0,
	@NoOverApplyCheck tinyint = NULL,
	@SalesTaxKey int = NULL,
	@Prepay tinyint = 0,
	@TargetGLCompanyKey int = NULL

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/24/07 BSH 8.5     (9659)Update OfficeKey, DepartmentKey
|| 03/17/09 MFT 10.021  (40077) Added Exclude1099
|| 03/17/09 GWG 10.021  Removed discount amount from the calc to determine if overapplying to a payment
|| 03/10/10 MAS 10.5.2	Added @NoOverApplyCheck flag
|| 04/01/10 RLB 10.521  Returning Keys
|| 07/22/10 MFT 10.532  Added SalesTaxKey
|| 11/30/10 MFT 10.538  Enhanced (-1) check for over-applied voucher, removed @OfficeKey and @ClassKey from voucher select to allow edits on payment detail
|| 12/16/10 MFT 10.539  Corrected subtraction of negative error in -1 check, corrected AppliedTotal calculation
|| 02/02/11 GHL 10.540  (102247) For vouchers, the class should be copied from the payment header
|| 10/05/11 MFT 10.548  Added @Prepay and insert logic
|| 02/24/12 GHL 10.552  Added credit card contribution + modified credits
|| 04/03/12 GHL 10.554  Added @TargetGLCompanyKey
|| 04/13/12 GHL 10.555  for vouchers get TargetGLCompanyKey from tVoucher 
|| 05/08/12 GHL 10.556  (142796) When possible TargetGLCompanyKey should be null (same as payment)
*/

DECLARE @AppliedTotal money
DECLARE @VoucherAmt money
DECLARE @VoucherFinalAmt money
DECLARE @PaymentGLCompanyKey int

Select @PaymentGLCompanyKey = GLCompanyKey from tPayment (NOLOCK) Where PaymentKey = @PaymentKey
		
IF @VoucherKey IS NOT NULL
	BEGIN
		SELECT 
			@VoucherAmt = VoucherTotal
			,@GLAccountKey = ISNULL(APAccountKey, 0)
			,@TargetGLCompanyKey = GLCompanyKey
		FROM tVoucher (nolock)
		WHERE VoucherKey = @VoucherKey
		
		IF @TargetGLCompanyKey = 0
			SELECT @TargetGLCompanyKey = NULL

		SELECT
			@AppliedTotal =
			(
				SELECT ISNULL(SUM(Amount), 0) + ISNULL(SUM(DiscAmount), 0)
				FROM tPaymentDetail (nolock)
				WHERE
					VoucherKey = @VoucherKey AND
					PaymentDetailKey <> @PaymentDetailKey
			) 
			+
			ISNULL((SELECT SUM(Amount) FROM tVoucherCredit (nolock) WHERE VoucherKey = @VoucherKey), 0)
			+
			ISNULL((SELECT SUM(Amount) * -1 FROM tVoucherCredit (nolock) WHERE CreditVoucherKey = @VoucherKey), 0)
			+
			ISNULL((SELECT SUM(Amount) FROM tVoucherCC (nolock) WHERE VoucherKey = @VoucherKey), 0)
		
		/*
		IF ABS(@VoucherAmt) < ABS(@AppliedTotal + @Amount + @DiscAmount)
			RETURN -1
		*/
		SELECT @VoucherFinalAmt = @AppliedTotal + @Amount + @DiscAmount
		IF @VoucherAmt < 0
			BEGIN
				IF @VoucherFinalAmt < @VoucherAmt OR @VoucherFinalAmt > 0 RETURN -1
			END
		ELSE
			BEGIN
				IF @VoucherFinalAmt > @VoucherAmt OR @VoucherFinalAmt < 0 RETURN -1
			END
	
		-- Copy the class from the payment header
		if isnull(@ClassKey, 0) = 0
			select @ClassKey = ClassKey from tPayment (nolock) where PaymentKey = @PaymentKey

	END

IF ISNULL(@NoOverApplyCheck,0) = 0
	BEGIN
		Declare @PaymentAmount money, @Applied money

		Select @PaymentAmount = PaymentAmount from tPayment (NOLOCK) Where PaymentKey = @PaymentKey
		Select @Applied = ISNULL(Sum(Amount), 0) from tPaymentDetail (NOLOCK) Where PaymentDetailKey <> @PaymentDetailKey and PaymentKey = @PaymentKey

		if @PaymentAmount >= 0
			if @Applied + @Amount > @PaymentAmount
				Return -2
		if @PaymentAmount < 0
			if @Applied + @Amount < @PaymentAmount
				Return -2
	END
	
if isnull(@PaymentGLCompanyKey, 0) =  isnull(@TargetGLCompanyKey, 0)
	select @TargetGLCompanyKey = null

begin transaction
	IF ISNULL(@PaymentDetailKey, 0) > 0
		UPDATE
			tPaymentDetail
		SET
			GLAccountKey = ISNULL(@GLAccountKey, 0),
			ClassKey = @ClassKey,
			VoucherKey = @VoucherKey,
			Description = @Description,
			Quantity = @Quantity,
			UnitAmount = @UnitAmount,
			DiscAmount = @DiscAmount,
			Amount = @Amount,
			OfficeKey = @OfficeKey,
			DepartmentKey = @DepartmentKey,
			Exclude1099 = @Exclude1099,
			SalesTaxKey = @SalesTaxKey,
			TargetGLCompanyKey = @TargetGLCompanyKey
		WHERE
			PaymentDetailKey = @PaymentDetailKey
	ELSE
		BEGIN
			INSERT tPaymentDetail
				(
					PaymentKey,
					GLAccountKey,
					ClassKey,
					VoucherKey,
					Description,
					Quantity,
					UnitAmount,
					DiscAmount,
					Amount,
					Prepay,
					OfficeKey,
					DepartmentKey,
					Exclude1099,
					SalesTaxKey,
					TargetGLCompanyKey
				)
			VALUES
				(
					@PaymentKey,
					ISNULL(@GLAccountKey, 0),
					@ClassKey,
					@VoucherKey,
					@Description,
					@Quantity,
					@UnitAmount,
					@DiscAmount,
					@Amount,
					@Prepay,
					@OfficeKey,
					@DepartmentKey,
					@Exclude1099,
					@SalesTaxKey,
					@TargetGLCompanyKey
			)
			
			SELECT @PaymentDetailKey = SCOPE_IDENTITY()
		END

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -1
	end

	if not @VoucherKey is null
		exec sptVoucherUpdateAmountPaid @VoucherKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -1
	end

commit transaction

	RETURN @PaymentDetailKey
GO
