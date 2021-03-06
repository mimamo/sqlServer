USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentRemovePrepayments]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentRemovePrepayments]
	(
	@PaymentKey int
	)
AS --Encrypt

/*
  || When     Who Rel     What
  || 04/01/13 GHL 10.566  (171747) Created SP so that we can remove prepayments
  ||                       for a payment and repost vouchers 
  || 04/10/13 GHL 10.566  Only delete prepayment if unposting is successful
*/
	SET NOCOUNT ON

	declare @PaymentDetailKey int
	declare @VoucherKey int
	declare @Posted int
	declare @RetVal int
	declare @CompanyKey int

	select @CompanyKey = CompanyKey from tPayment (nolock) where PaymentKey = @PaymentKey

	select @PaymentDetailKey = -1
	while (1=1)
	begin
		select @PaymentDetailKey = min(PaymentDetailKey)
		from   tPaymentDetail (nolock)
		where  PaymentKey = @PaymentKey
		and    Prepay = 1
		and    PaymentDetailKey > @PaymentDetailKey
		and    VoucherKey is not null

		if @PaymentDetailKey is null
			break
		
		select @VoucherKey = VoucherKey from tPaymentDetail (nolock)
		where  PaymentDetailKey = @PaymentDetailKey
		 	
		select @Posted = Posted from tVoucher (nolock) where VoucherKey = @VoucherKey

		if @Posted = 1
			exec @RetVal = spGLUnPostVoucher @VoucherKey, 0, null
		else
			select @RetVal = 1

		if @RetVal = 1
		begin
			exec @RetVal = sptPaymentDetailDelete @PaymentDetailKey	 

			if @Posted = 1
				exec @RetVal = spGLPostVoucher @CompanyKey, @VoucherKey, 0, 1, 0 
		end

	end

	RETURN 1
GO
