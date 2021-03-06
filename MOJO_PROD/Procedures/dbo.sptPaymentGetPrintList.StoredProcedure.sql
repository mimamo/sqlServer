USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentGetPrintList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentGetPrintList]

	(
		@CompanyKey int,
		@CashAccountKey int,
		@GLCompanyKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel       What
|| 05/21/12 RLB 10.5.5.6  (134308) change made to pull negative amounts
|| 09/11/12 RLB 10.5.6.0  (153942) Adding filter for GLCompany
|| 11/01/12 WDF 10.5.6.1  (153783) Only pull > 0 amounts (Per G.G. regardless of 134308)
*/

Select
	 p.PaymentKey
	,c.CompanyName
	,c.VendorID
	,c.VendorID + ' - ' + c.CompanyName as VendorName
	,p.PaymentDate
	,p.PaymentAmount
From 
	tPayment p (NOLOCK) 
	inner join tCompany c (NOLOCK) on p.VendorKey = c.CompanyKey
Where 
	p.CompanyKey = @CompanyKey 
	and p.CheckNumber is NULL 
	and p.PaymentAmount > 0
	and ISNULL(c.OnHold,0) = 0
	and p.CashAccountKey = @CashAccountKey
	and (@GLCompanyKey IS NULL or p.GLCompanyKey = @GLCompanyKey)
Order By PaymentDate, VendorID
GO
