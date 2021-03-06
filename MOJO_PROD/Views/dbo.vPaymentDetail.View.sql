USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vPaymentDetail]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE           View [dbo].[vPaymentDetail]

as

SELECT     
	 p.* 
	,gl.AccountNumber
	,gl.AccountName
	,c.VendorID
	,c.CompanyName as VendorName
	,pd.PaymentDetailKey
	,pd.GLAccountKey
	,pd.VoucherKey
	,pd.Description
	,pd.Quantity
	,pd.UnitAmount
	,pd.DiscAmount
	,pd.Amount
	,gl2.AccountNumber as DetailAccountNumber
	,gl2.AccountName as DetailAccountName
	,cl.ClassID
	,cl.ClassName
	,v.InvoiceNumber
	,v.InvoiceDate
	,v.DueDate
	,ISNULL(v.AmountPaid, 0) as VoucherAmountPaid
	,ISNULL(v.VoucherTotal, 0) as VoucherTotal
	,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as VoucherAmountOpen
	,ISNULL('INV ' + v.InvoiceNumber, 'ACCT ' + gl2.AccountNumber) as Reference
    	,isnull(v.Description,'') as InvoiceDescription
	,'' AS Address
FROM         
	tPayment p (nolock)
	inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
	INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey 
	left outer  JOIN tGLAccount gl (nolock) ON p.CashAccountKey = gl.GLAccountKey
	left outer  JOIN tGLAccount gl2 (nolock) ON pd.GLAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on pd.ClassKey = cl.ClassKey
	left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
GO
