USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGetVoucherList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGetVoucherList]

	(
		@PaymentKey int,
		@Restrict tinyint,
		@CreditCard int = 0
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/21/07 BSH 8.5     (9659)Restrict list to match the Payment's GLCompany
|| 03/17/09 MFT 10.021  (40077) Added Exclude1099
|| 10/28/11 GHL 10.459  Added CreditCard param
|| 04/17/15 GHL 10.591  Added VoucherID because the credit card numbers are too large to easily identify
*/

Declare @GLCompanyKey int
Declare @VendorKey int

Select @VendorKey = VendorKey, 
       @GLCompanyKey = ISNULL(GLCompanyKey, 0)
from tPayment (NOLOCK) 
Where PaymentKey = @PaymentKey


if @Restrict = 0
	SELECT     
		1 as Applied
		,pd.PaymentDetailKey
		,pd.VoucherKey
		,pd.Description
		,pd.DiscAmount
		,pd.Amount
		,v.InvoiceNumber
		,v.VoucherID
		,v.InvoiceDate
		,v.DueDate
		,Case When DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) > GETDATE() Then
			(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) + ISNULL(pd.Amount, 0)) * (ISNULL(v.TermsPercent, 0) / 100.0) else 0 END as OpenDiscount
		,ISNULL(v.AmountPaid, 0) as VoucherAmountPaid
		,ISNULL(v.VoucherTotal, 0) as VoucherTotal
		,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as VoucherAmountOpen
		,ISNULL(pd.Exclude1099, 0) As Exclude1099
		,ISNULL(bbu.FirstName + ' ', '') + ISNULL(bbu.LastName, '') as BoughtByName
		,v.BoughtFrom
		,ISNULL(v.CreditCard, 0) as CreditCard
	FROM         
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
		left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		left outer join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey 
	Where
		p.PaymentKey = @PaymentKey and pd.VoucherKey is not null and ISNULL(pd.Prepay, 0) = 0
	and isnull(v.CreditCard, 0) = @CreditCard
		
	UNION ALL

	Select
		0 as Applied
		,0
		,v.VoucherKey
		,''
		,0
		,0
		,v.InvoiceNumber
		,v.VoucherID
		,v.InvoiceDate
		,v.DueDate
		,Case When DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) > GETDATE() Then
			(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * (ISNULL(v.TermsPercent, 0) / 100.0) else 0 END as OpenDiscount
		,ISNULL(v.AmountPaid, 0) as VoucherAmountPaid
		,ISNULL(v.VoucherTotal, 0) as VoucherTotal
		,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as VoucherAmountOpen
		,0
		,ISNULL(bbu.FirstName + ' ', '') + ISNULL(bbu.LastName, '') as BoughtByName
		,v.BoughtFrom
		,ISNULL(v.CreditCard, 0) as CreditCard
	FROM         
		tVoucher v (nolock)
	left outer join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey 
	Where
		v.VoucherTotal - v.AmountPaid <> 0 and
		v.VendorKey = @VendorKey and
		v.Status = 4 and
		ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey and
		VoucherKey not in (Select VoucherKey From tPaymentDetail pd (NOLOCK) Where pd.PaymentKey = @PaymentKey)
		and isnull(v.CreditCard, 0) = @CreditCard
	
ELSE
	SELECT     
		1 as Applied
		,pd.PaymentDetailKey
		,pd.VoucherKey
		,pd.Description
		,pd.DiscAmount
		,pd.Amount
		,v.InvoiceNumber
		,v.VoucherID
		,v.InvoiceDate
		,v.DueDate
		,Case When DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) > GETDATE() Then
			ISNULL(v.VoucherTotal, 0) * (ISNULL(v.TermsPercent, 0) / 100.0) else 0 END as OpenDiscount
		,ISNULL(v.AmountPaid, 0) as VoucherAmountPaid
		,ISNULL(v.VoucherTotal, 0) as VoucherTotal
		,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as VoucherAmountOpen
		,ISNULL(pd.Exclude1099, 0) As Exclude1099
		,ISNULL(bbu.FirstName + ' ', '') + ISNULL(bbu.LastName, '') as BoughtByName
		,v.BoughtFrom
		,ISNULL(v.CreditCard, 0) as CreditCard
	FROM         
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
		left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		left outer join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey 
	Where
		p.PaymentKey = @PaymentKey and pd.VoucherKey is not null and ISNULL(pd.Prepay, 0) = 0
		and isnull(v.CreditCard, 0) = @CreditCard
GO
