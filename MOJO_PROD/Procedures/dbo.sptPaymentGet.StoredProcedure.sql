USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentGet]
	@PaymentKey int

AS --Encrypt

/*
|| When     Who Rel			What
|| 09/21/07 BSH 8.5			(9659)Added @LineCount to lock GLCompany on payment header.
|| 03/01/10 MAS 10.5.2	    Added the ID, Name and Number columns needed for the Flex Lookups.
|| 12/10/10 RLB 10.539     (96920) pulling down ParentRecurringTranKey
|| 10/28/11 GHL 10.549      Added VendorHasCreditCard field
|| 04/10/13 GHL 10.566      Added prepayment count so that we can add an action to remove them on the UI
|| 11/08/13 GHL 10.573      Added multi currency info
*/

Declare @Cleared int
Declare @LineCount int
Declare @PrepayCount int
Declare @VendorHasCreditCard int

DECLARE @CompanyKey int
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @PaymentDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

If Exists(Select 1 from tTransaction (NOLOCK) Where Entity = 'PAYMENT' And EntityKey = @PaymentKey
			And   Cleared = 1 
			)
	Select @Cleared = 1

Select @LineCount = COUNT(*) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey
Select @PrepayCount = COUNT(*) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey and isnull(Prepay, 0) = 1
	
if @PaymentKey = 0
	select @VendorHasCreditCard = 0
else
begin
	-- the payment exists
    -- determine if the vendor has a credit card
	if exists (select 1 from tGLAccount gla (nolock)
			inner join tPayment p (nolock) on p.CompanyKey = gla.CompanyKey -- uses IX_tGLAccount
			where p.PaymentKey = @PaymentKey
			and   gla.VendorKey = p.VendorKey
			) 
			select @VendorHasCreditCard = 1
		else
			select @VendorHasCreditCard = 0
end

select @CompanyKey = p.CompanyKey
	  ,@GLCompanyKey = isnull(p.GLCompanyKey, 0) 
      ,@CurrencyID = p.CurrencyID
	  ,@PaymentDate = p.PaymentDate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from   tPayment p (nolock)
inner join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
where  p.PaymentKey = @PaymentKey    

-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @PaymentDate, @ExchangeRate output, @RateHistory output

SELECT     
	 p.* 
	,gl.AccountNumber, gl.GLAccountKey, gl.AccountName
	,c.VendorID, c.CompanyKey as VendorKey, c.CompanyName as VendorName
	,cl.ClassID, cl.ClassKey, cl.ClassName
	,glc.GLCompanyID, glc.GLCompanyKey, glc.GLCompanyName
	,(Select ISNULL(Sum(Amount), 0) from tPaymentDetail (NOLOCK) Where VoucherKey > 0 and PaymentKey = @PaymentKey) as VoucherTotal
	,(Select ISNULL(Sum(Amount), 0) from tPaymentDetail (NOLOCK) Where (VoucherKey = 0 or VoucherKey is null) and PaymentKey = @PaymentKey) as GLTotal
	,gl2.GLAccountKey as UnappliedPaymentAccountKey,gl2.AccountNumber as UnappliedPaymentAccountNumber, gl2.AccountName as UnappliedPaymentAccountName
	,gl3.GLAccountKey as CashAccountKey, gl3.AccountNumber as CashAccountNumber	 ,gl3.AccountName as CashAccountName 
	,ISNULL(@Cleared, 0) As Cleared
	,ISNULL(@LineCount, 0) as LineCount
	,ISNULL(@PrepayCount, 0) as PrepayCount
	,ISNULL(@VendorHasCreditCard, 0) as VendorHasCreditCard
	,rt.RecurTranKey as ParentRecurringTranKey
	,@RateHistory as RateHistory
FROM         
	tPayment p (nolock)
	INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey 
	left outer JOIN tGLAccount gl(nolock) ON p.CashAccountKey = gl.GLAccountKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	left outer join tClass cl (nolock) on p.ClassKey = cl.ClassKey
	left outer join tGLAccount gl2 (nolock) on p.UnappliedPaymentAccountKey = gl2.GLAccountKey
	left outer join tGLAccount gl3 (nolock) on p.CashAccountKey = gl3.GLAccountKey
	left outer join tRecurTran rt (nolock) on p.RecurringParentKey = rt.EntityKey and rt.Entity = 'PAYMENT'
Where
	PaymentKey = @PaymentKey
	
RETURN 1
GO
