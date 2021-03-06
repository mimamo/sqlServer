USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGetPrepayVoucherList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGetPrepayVoucherList]

	(
		@PaymentKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 03/17/09 MFT 10.021  (40077) Added Exclude1099
*/

SELECT     
	pd.PaymentDetailKey
	,pd.VoucherKey
	,pd.Description
	,pd.DiscAmount
	,pd.Amount
	,v.InvoiceNumber
	,v.InvoiceDate
	,v.PostingDate
	,pd.Exclude1099
FROM         
	tPayment p (nolock)
	inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
	inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
Where
	p.PaymentKey = @PaymentKey and pd.VoucherKey is not null and ISNULL(pd.Prepay, 0) = 1
GO
