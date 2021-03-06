USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetPayments]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetPayments]

	(
		@VoucherKey int
	)

AS --Encrypt

  /*
  || When     Who  Rel       What
  || 02/13/14 GHL  10.5.6.7  Added Payment Amount to show on the grid
  */

Select
	 p.PaymentKey
	,p.PaymentDate
	,p.PostingDate
	,p.CheckNumber
	,p.Posted
	,pd.DiscAmount
	,pd.Amount
	,p.PaymentAmount	
From
	tPayment p (nolock)
	inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
Where
	pd.VoucherKey = @VoucherKey and ISNULL(pd.Prepay, 0) = 0
Order By
	p.PaymentDate
GO
