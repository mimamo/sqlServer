USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentApplOverApplyCheck]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentApplOverApplyCheck]
	@PaymentKey int
AS --Encrypt

/*
|| When      Who Rel		What
|| 03/10/10  MAS 10.5.1.9	Created
|| 04/01/10 RLB 10.521  Returning Keys
|| 06/29/12 GHL 10.557  Prevent from returning a negative number, this displays an error message on the UI
*/

if @PaymentKey <= 0
	return 0

DECLARE @AppliedAmount money
DECLARE @PaymentAmount money

SELECT @AppliedAmount = ISNULL(Sum(Amount), 0) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey
SELECT @PaymentAmount = PaymentAmount from tPayment (NOLOCK) Where PaymentKey = @PaymentKey

IF ISNULL(@PaymentAmount,0) > 0
	BEGIN
		If @PaymentAmount < ISNULL(@AppliedAmount, 0)
			RETURN -1
	END
Else
	BEGIN
		IF ISNULL(@PaymentAmount, 0) > ISNULL(@AppliedAmount, 0)
			RETURN -1
	END

RETURN @PaymentKey
GO
