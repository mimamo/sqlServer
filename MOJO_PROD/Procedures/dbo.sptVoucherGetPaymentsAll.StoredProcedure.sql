USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetPaymentsAll]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetPaymentsAll]
	@VoucherKey int

AS --Encrypt

  /*
  || When     Who  Rel       What
  || 09/29/11 MFT  10.5.4.8  Created for WMJ
  */

SELECT
	'PAYMENT' AS PaymentType,
	p.PaymentKey,
	p.PaymentDate,
	p.PostingDate,
	p.CheckNumber,
	p.Posted,
	NULL AS UnappliedAmount,
	pd.PaymentDetailKey,
	pd.DiscAmount,
	pd.Amount,
	pd.Prepay,
	pd.VoucherKey
FROM
	tPayment p (nolock)
	INNER JOIN tPaymentDetail pd (nolock) ON p.PaymentKey = pd.PaymentKey
WHERE
	pd.VoucherKey = @VoucherKey AND
	ISNULL(pd.Prepay, 0) = 0
	
UNION

SELECT
	'PRE-PAYMENT' AS PaymentType,
	p.PaymentKey,
	p.PaymentDate,
	p.PostingDate,
	p.CheckNumber,
	p.Posted,
	p.PaymentAmount - pd.Amount - pd.DiscAmount - ISNULL((SELECT SUM(Amount) FROM tPaymentDetail (nolock) WHERE tPaymentDetail.PaymentKey = p.PaymentKey and tPaymentDetail.PaymentDetailKey <> pd.PaymentDetailKey),0) AS UnappliedAmount,
	pd.PaymentDetailKey,
	pd.DiscAmount,
	pd.Amount,
	pd.Prepay,
	pd.VoucherKey
FROM
	tPayment p (nolock)
	INNER JOIN tPaymentDetail pd (nolock) ON p.PaymentKey = pd.PaymentKey
WHERE
	pd.VoucherKey = @VoucherKey AND
	ISNULL(pd.Prepay, 0) = 1
ORDER BY
	p.PaymentDate
GO
