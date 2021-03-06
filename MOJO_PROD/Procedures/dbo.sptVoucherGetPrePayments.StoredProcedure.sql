USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetPrePayments]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetPrePayments]

	(
		@VoucherKey int = NULL,
		@Restrict tinyint,
		@VendorKey int = NULL
	)

AS --Encrypt

  /*
  || When     Who  Rel       What
  || 10/7/08  GWG  10.0.1.0  Added a restirct to not show voided payments
  || 09/28/11 MFT  10.5.4.8  Moved @VendorKey to parameters, defaulted @VoucherKey to NULL to allow get prior to Voucher being saved
  || 01/11/12 GHL  10.5.5.2  Added a couple of fields to show in Flex
  || 08/24/12 GHL  10.5.5.9  Added checking of GLCompanyKey
  || 03/05/13 GHL 10.5.6.5   (170700) Added ClassKey from the check. Prepayments have to be reversed
  ||                         with correct class during posting
  */

declare @GLCompanyKey int

IF ISNULL(@VoucherKey, 0) > 0
	Select @VendorKey = VendorKey
	      ,@GLCompanyKey = GLCompanyKey  
	from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey

if @Restrict = 1
BEGIN
	Select
		 1 as Applied
		,p.PaymentKey
		,p.PaymentDate
		,p.CheckNumber
		,p.PaymentAmount
		,pd.PaymentDetailKey
		,pd.Amount as Amount
		,p.PaymentAmount - ISNULL((Select Sum(Amount) from tPaymentDetail (NOLOCK) Where tPaymentDetail.PaymentKey = p.PaymentKey and tPaymentDetail.PaymentDetailKey <> pd.PaymentDetailKey),0) as UnappliedAmount
		,pd.Description
		,p.PostingDate
		,p.ClassKey
	From
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	Where
		pd.VoucherKey = @VoucherKey and ISNULL(pd.Prepay, 0) = 1 
	Order By 
		p.PaymentDate
		
END
ELSE
BEGIN

	Select
		 1 as Applied
		,p.PaymentKey
		,p.PaymentDate
		,p.CheckNumber
		,p.PaymentAmount
		,pd.PaymentDetailKey
		,pd.Amount as Amount
		,p.PaymentAmount - isnull((Select Sum(Amount) from tPaymentDetail (NOLOCK) Where tPaymentDetail.PaymentKey = p.PaymentKey and tPaymentDetail.PaymentDetailKey <> pd.PaymentDetailKey),0) as UnappliedAmount
		,pd.Description
		,p.PostingDate
		,p.ClassKey
	From
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	Where
		pd.VoucherKey = @VoucherKey and ISNULL(pd.Prepay, 0) = 1 

	UNION ALL
	
	Select 
		 0 as Applied
		,p.PaymentKey
		,p.PaymentDate
		,p.CheckNumber
		,p.PaymentAmount
		,0 as PaymentDetailKey
		,0
		,p.PaymentAmount - ISNULL(Sum(pd.Amount + pd.DiscAmount), 0) as UnappliedAmount
		,''
		,p.PostingDate
		,p.ClassKey
	From
		tPayment p (nolock)
		left outer join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	Where
		p.Posted = 1 and
		ISNULL(p.VoidPaymentKey, 0) = 0 and
		p.VendorKey = @VendorKey and
		p.PaymentKey not in (Select PaymentKey from tPaymentDetail Where VoucherKey = @VoucherKey and Prepay = 1)
		and ISNULL(p.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
	Group By
		p.PaymentKey, p.PaymentDate, p.PostingDate, p.CheckNumber, p.Posted, p.PaymentAmount,p.ClassKey
	Having
		p.PaymentAmount - ISNULL(Sum(pd.Amount), 0) <> 0
	Order By
		p.PaymentDate

END
GO
