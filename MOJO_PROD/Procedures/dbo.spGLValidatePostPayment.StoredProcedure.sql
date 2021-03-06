USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLValidatePostPayment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLValidatePostPayment]
	(
	@PaymentKey int
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 12/07/12 GHL 10.563 A payment can only be posted if all vouchers applied to a credit card
  ||                     applied to the payment are posted. This is because of the cash basis posting
  ||                     Returns a list of unposted vouchers to display
  */ 

	SET NOCOUNT ON

	select  distinct v.InvoiceNumber
	from    tPaymentDetail pd (nolock)
		inner join tVoucher cc (nolock) on pd.VoucherKey = cc.VoucherKey
		inner join tVoucherCC vcc (nolock) on cc.VoucherKey = vcc.VoucherCCKey
		inner join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey
	where   pd.PaymentKey = @PaymentKey
	and     cc.CreditCard = 1
	and     v.Posted = 0
	
	RETURN 1
GO
