USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetPrepaymentsForVendor]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetPrepaymentsForVendor]
	(
	@VendorKey int		-- pass vendor in case VoucherKey is 0
	,@GLCompanyKey int	-- pass gl company in case VoucherKey is 0, -1 All, 0 Blank, > 0 valid GLCompany
	,@VoucherKey int = null
	,@UserKey int = null
	,@CurrencyID varchar(10) = null -- NULL/Blank = Home Currency, or valid Currency or ALL for all currencies 
	)

AS --Encrypt

  /*
  || When     Who  Rel       What
  || 08/20/12 GHL  10.5.5.9  Cloned sptInvoiceGetPrepaymentsForClient
  ||                         Should support 2 screens:
  ||                         1) Voucher edit screen where:
  ||                         - VendorKey + GLCompanyKey known (but GLK could be blank)
  ||                         - VoucherKey may (update mode) or may not (add mode) be known
  ||                         - UserKey should be null
  ||
  ||                         2) Pay credit card screen where:
  ||                         - VendorKey is known
  ||                         - GLCompanyKey is optional
  ||                         - VoucherKey is blank
  ||                         - we need UserKey to restrict if needed
  || 03/05/13 GHL 10.5.6.5   (170700) Added ClassKey from the check. Prepayments have to be reversed
  ||                         with correct class during posting
  || 11/06/13 GHL 10.5.7.4   Added CurrencyID filter
  || 03/07/14 GHL 10.5.7.8   Added CurrencyID column to show on the 'Pay Credit Cards' screen 
  ||                         if CurrencyID = 'ALL', take all currencies
  */
  
declare @RestrictToGLCompany int
declare @MultiCurrency int
declare @CompanyKey int

if @UserKey is not null
begin
	select @CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
	from   tUser (nolock)
	where  UserKey = @UserKey

	select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) 
	      ,@MultiCurrency = isnull(MultiCurrency, 0)
	from tPreference (nolock)
	where CompanyKey = @CompanyKey
end

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
		,@MultiCurrency = isnull(@MultiCurrency, 0)

Select 
	0 as Applied,
	p.PaymentKey,
	p.CheckNumber,
	p.PaymentDate,
	p.PaymentAmount,
	p.PaymentAmount - ISNULL(Sum(pd.Amount), 0) as UnappliedAmount,
	0 as PaymentDetailKey,
	0 as Amount,
	p.GLCompanyKey,
	glc.GLCompanyID,
	glc.GLCompanyName,
	p.ClassKey,
	p.CurrencyID
From
	tPayment p (nolock)
	left outer join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	left outer join tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
Where
	p.VendorKey = @VendorKey 
	and  p.Posted = 1 
	and ISNULL(p.VoidPaymentKey, 0) = 0 
	and p.PaymentKey not in (Select PaymentKey From tPaymentDetail (nolock) Where VoucherKey = @VoucherKey and Prepay=1)

	and (@GLCompanyKey = -1 OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey) 
	
	and (
		@RestrictToGLCompany = 0

		Or

		(ISNULL(p.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey ))

		)
	and (
		@MultiCurrency = 0

		Or

		(
		@CurrencyID = 'ALL' -- for the Pay Credit Cards 
		or 
		isnull(p.CurrencyID, '') = isnull(@CurrencyID,'') 
		)
	)
Group By
	p.PaymentKey, p.CheckNumber, p.PaymentDate, p.PaymentAmount,p.GLCompanyKey,p.CurrencyID, glc.GLCompanyID,glc.GLCompanyName, p.ClassKey
	
Having p.PaymentAmount - ISNULL(Sum(pd.Amount), 0) <> 0
GO
