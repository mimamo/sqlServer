USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCreditUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCreditUpdate]
	@VoucherCreditKey int = NULL,
	@VoucherKey int = NULL,
	@CreditVoucherKey int = NULL,
	@Description varchar(500),
	@Amount money

AS --Encrypt

/*
	|| When     Who  Rel       What
	|| 10/10/11 MFT  10.5.4.9  Added insert logic
	|| 01/13/12 GHL  10.5.5.2  Capture Error and Identity in same statement
	|| 01/13/12 GHL  10.5.5.2  Added checking of sign of VoucherTotal on both VoucherKey/CreditVoucherKey
	||                         to prevent any mismatch on the flex screens + fixed typo on @@ERROR
	|| 02/23/12 GHL  10.5.5.2  (135065) Corrected query for @ApplAmt for CreditVoucherKey
	||                         i.e. where CreditVoucherKey = @CreditVoucherKey
	|| 02/24/12 GHL  10.5.5.2  Added CCAmount (amount on credit card)
*/

DECLARE @CreditAmt AS money, @ApplAmt AS money, @PaidAmount AS money, @CCAmount money, @Error int

IF ISNULL(@VoucherCreditKey, 0) > 0
	BEGIN
		SELECT @VoucherKey = VoucherKey, @CreditVoucherKey = CreditVoucherKey
		FROM tVoucherCredit (nolock)
		WHERE VoucherCreditKey = @VoucherCreditKey
		
		SELECT @ApplAmt = ISNULL(SUM(Amount), 0)
		FROM tVoucherCredit (nolock)
		WHERE CreditVoucherKey = @CreditVoucherKey AND ISNULL(VoucherCreditKey, 0) <> ISNULL(@VoucherCreditKey, 0)
	END
ELSE
	BEGIN
		SELECT @ApplAmt = ISNULL(SUM(Amount), 0) FROM tVoucherCredit (nolock) WHERE CreditVoucherKey = @CreditVoucherKey
	END

SELECT @CreditAmt = ABS(VoucherTotal) FROM tVoucher (nolock) WHERE VoucherKey = @CreditVoucherKey

IF @ApplAmt + @Amount > @CreditAmt
	RETURN -1

DECLARE @VoucherTotal money
DECLARE @VoucherAmt money

IF ISNULL(@VoucherCreditKey, 0) > 0
	BEGIN
		SELECT @VoucherTotal = ISNULL(VoucherTotal, 0)
		FROM tVoucher (nolock)
		WHERE VoucherKey = @VoucherKey
		
		SELECT @ApplAmt = ISNULL(SUM(Amount), 0)
		FROM tVoucherCredit (nolock)
		WHERE VoucherKey = @VoucherKey AND VoucherCreditKey <> @VoucherCreditKey
		
		SELECT @PaidAmount = ISNULL(SUM(Amount), 0) + ISNULL(SUM(DiscAmount), 0)
		FROM tPaymentDetail (nolock)
		WHERE VoucherKey = @VoucherKey
		
		-- Impact of credit cards
		SELECT @CCAmount = ISNULL(SUM(Amount), 0) 
		FROM tVoucherCC (nolock) 
		WHERE VoucherKey = @VoucherKey  

		IF @VoucherTotal - @Amount - @PaidAmount - @ApplAmt - @CCAmount < 0
			RETURN -2

		-- Validation of VoucherKey, total cannot be negative
		IF @VoucherTotal < 0
			RETURN -4

		SELECT @VoucherTotal = ISNULL(VoucherTotal, 0)
		FROM tVoucher (nolock)
		WHERE VoucherKey = @CreditVoucherKey

		-- Validation of CreditVoucherKey, total cannot be 0 or positive
		IF @VoucherTotal >= 0
			RETURN -4

	END
ELSE
	BEGIN
		SELECT @VoucherTotal = ISNULL(VoucherTotal, 0) - ISNULL(AmountPaid, 0)
		FROM tVoucher (nolock) WHERE VoucherKey = @VoucherKey
		
		IF @VoucherTotal - @Amount < 0
			RETURN -2
	END

BEGIN TRAN
	IF ISNULL(@VoucherCreditKey, 0) > 0
		UPDATE
			tVoucherCredit
		SET
			Description = @Description,
			Amount = @Amount
		WHERE
			VoucherCreditKey = @VoucherCreditKey
	ELSE
		BEGIN
			INSERT INTO
				tVoucherCredit
				(
					VoucherKey,
					CreditVoucherKey,
					Description,
					Amount
				)

			VALUES
				(
					@VoucherKey,
					@CreditVoucherKey,
					@Description,
					@Amount
				)
			
			SELECT @Error = @@ERROR, @VoucherCreditKey = SCOPE_IDENTITY()
		END
	IF @Error <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END
		
	EXEC sptVoucherUpdateAmountPaid @VoucherKey
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END
	
	EXEC sptVoucherUpdateAmountPaid @CreditVoucherKey
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END
COMMIT TRAN

RETURN @VoucherCreditKey
GO
