USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGetList]

	@PaymentKey int
	,@SummarizeCCCharges int = 0

AS --Encrypt

/*
|| When     Who Rel			What
|| 07/22/10 MFT 10.532  Added tSalesTax
|| 11/13/12 GHL 10.562  (159263) When paying credit cards, the list of CC Charges is too long
||                      In that case, summarize the data, 1 line per Credit Card/GLAccount
*/

declare @CCChargesExist int
select @CCChargesExist = 0
if exists (select 1 
			from tPaymentDetail pd (nolock)
			inner join tVoucher ccc (nolock) on pd.VoucherKey = ccc.VoucherKey
			where pd.PaymentKey = @PaymentKey
			and   isnull(ccc.CreditCard, 0) = 1
		) 
		select @CCChargesExist = 1
if @CCChargesExist = 0
	select @SummarizeCCCharges = 0

if @SummarizeCCCharges = 0
	SELECT     
		 pd.*
		,gl2.AccountNumber as AccountNumber
		,gl2.AccountName as AccountName
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
		,st.SalesTaxName
		,st.SalesTaxKey
	FROM         
		tPaymentDetail pd (nolock)
		left outer  JOIN tGLAccount gl2 (nolock) ON pd.GLAccountKey = gl2.GLAccountKey
		left outer join tClass cl (nolock) on pd.ClassKey = cl.ClassKey
		left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		left outer join tSalesTax st (nolock) ON pd.SalesTaxKey = st.SalesTaxKey
	WHERE
		PaymentKey = @PaymentKey
	ORDER BY InvoiceNumber

else

	select Max(v.InvoiceDate) as InvoiceDate
		  ,'ACCT ' + gl.AccountNumber as Reference
		  ,SUM(isnull(v.VoucherTotal,0)) as  VoucherTotal
		  ,SUM(isnull(v.VoucherTotal, 0) - isnull(v.AmountPaid, 0)) as VoucherAmountOpen
		  ,SUM(pd.DiscAmount) as DiscAmount
		  ,SUM(pd.Amount) as Amount
		  ,NULL as InvoiceDescription
	from   tPaymentDetail pd (nolock)
	left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
	left outer  JOIN tGLAccount gl (nolock) ON pd.GLAccountKey = gl.GLAccountKey
	WHERE
		PaymentKey = @PaymentKey
	group by gl.AccountNumber
	order by gl.AccountNumber

RETURN 1
GO
