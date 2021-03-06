USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailDelete]
	@PaymentDetailKey int

AS --Encrypt

/*
|| 10/02/12 GHL 10.560  Moved begin tran after validations
*/


Declare @VoucherKey int
Declare @PaymentKey int
Declare @Amount money, @CheckAmt money, @Applied money

Select @CheckAmt = PaymentAmount from tPayment (NOLOCK) Where PaymentKey = @PaymentKey
Select @Applied =  ISNULL(Sum(Amount + DiscAmount), 0) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey
Select @VoucherKey = VoucherKey, @PaymentKey = PaymentKey, @Amount = Amount  from tPaymentDetail (nolock) Where PaymentDetailKey = @PaymentDetailKey

	if @CheckAmt >= 0
		if @CheckAmt - @Applied + @Amount < 0
			return -2
			
	if @CheckAmt < 0
		if @CheckAmt - @Applied + @Amount > 0
			return -2

	begin transaction
			
	DELETE
	FROM tPaymentDetail
	WHERE
		PaymentDetailKey = @PaymentDetailKey 

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
	RETURN 1
GO
