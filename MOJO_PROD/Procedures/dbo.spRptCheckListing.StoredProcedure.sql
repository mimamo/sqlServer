USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCheckListing]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptCheckListing]
(
	@CompanyKey int,
	@VendorKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null,
	@CurrencyID varchar(10) = null
)

AS --Encrypt

  /*
  || When     Who Rel     What
  || 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess 
  || 01/24/14 GHL 10.576  Added Currency filter 
  */

Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
      ,@MultiCurrency = isnull(@MultiCurrency, 0)

if @VendorKey = 0
	select @VendorKey = null


	Select
		 p.PaymentKey
		,p.CheckNumber
		,c.VendorID
		,p.PayToName
		,p.PaymentDate
		,p.VoidPaymentKey
		,v.InvoiceNumber
		,gl.AccountNumber + ' - ' + gl.AccountName as AccountName
		,pd.Amount
	From 
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
		inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
		inner join tGLAccount gl (nolock) on pd.GLAccountKey = gl.GLAccountKey
		left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
	Where 
		PaymentDate	>= @StartDate and
		PaymentDate <= @EndDate and
		p.CompanyKey = @CompanyKey and
		(@VendorKey is null Or p.VendorKey = @VendorKey) and
		p.CheckNumber is not null  
		
	AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

	AND (@MultiCurrency = 0
		OR isnull(p.CurrencyID, '') = isnull(@CurrencyID, '') )

	Order By
		p.CheckNumber
GO
