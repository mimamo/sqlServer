USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLValidateUnpostVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLValidateUnpostVoucher]
	(
	@VoucherKey int
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 12/07/12 GHL 10.563 A posted voucher applied to a credit card applied to a posted payment
  ||                     cannot be unposted. This is because of cash basis posting
  ||                     Returns a list of posted payments to display
  */ 

	SET NOCOUNT ON

	select distinct p.CheckNumber
	from   tVoucherCC vcc (nolock)
	inner join tVoucher cc (nolock) on vcc.VoucherCCKey = cc.VoucherKey
	inner join tPaymentDetail pd (nolock) on cc.VoucherKey = pd.VoucherKey
	inner join tPayment p (nolock) on pd.PaymentKey = p.PaymentKey
	where  vcc.VoucherKey = @VoucherKey
	and    p.Posted = 1

	RETURN 1
GO
