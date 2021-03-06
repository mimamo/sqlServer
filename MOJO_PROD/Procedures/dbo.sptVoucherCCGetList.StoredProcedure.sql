USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCCGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCCGetList]
	(
	@VoucherKey int 
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/19/11 GHL 10.547 Creation for credit card charges
  ||                     Gets the list of vouchers applied to a credit card charge 
  || 11/29/11 GHL 10.550 Added Posted status to show on voucher_payment.aspx
  || 01/12/12 GHL 10.552 Corrected join with tVoucher when CreditCard=0
  || 04/20/15 GHL 10.591 Added VoucherID because the credit card numbers are too large to easily identify
  */

	SET NOCOUNT ON

	declare @CreditCard int
	
	select @CreditCard = CreditCard
	from   tVoucher (nolock)
	where  VoucherKey = @VoucherKey
	
	select @CreditCard = isnull(@CreditCard, 0)
	
	if @CreditCard = 1

		select vcc.*
			  ,v.InvoiceNumber
			  ,v.VoucherID
			  ,v.InvoiceDate
			  ,v.DueDate
			  ,v.VoucherTotal
			  ,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as UnappliedAmount
			  ,p.ProjectNumber
			  ,p.ProjectName
			  ,v.Posted
		from   tVoucherCC vcc (nolock)
		left outer join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	
		where  vcc.VoucherCCKey = @VoucherKey

	else

		select vcc.*
			  ,v.InvoiceNumber
			  ,v.VoucherID
			  ,v.InvoiceDate
			  ,v.DueDate
			  ,v.VoucherTotal
			  ,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as UnappliedAmount
			  ,p.ProjectNumber
			  ,p.ProjectName
			  ,v.Posted
		from   tVoucherCC vcc (nolock)
		left outer join tVoucher v (nolock) on vcc.VoucherCCKey = v.VoucherKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	
		where  vcc.VoucherKey = @VoucherKey

	RETURN 1
GO
