USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCCGetUnappliedList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCCGetUnappliedList]
	(
	@CompanyKey int
	,@CreditCard int -- 1 if credit card side, 0 if voucher side
	,@GLCompanyKey int
	,@VoucherKey int 
	,@VendorKey int
	,@InvoiceNumber varchar(50)
	,@StartDate datetime
	,@EndDate datetime
	,@UserKey int
	,@CurrencyID varchar(10) = null
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/19/11 GHL 10.547 Creation for credit card charges
  ||                     Gets the list of vouchers unapplied to a credit card charge
  || 10/5/11  GHL 10.549 Added params @CompanyKey/@CreditCard/@GLCompanyKey for the cases when @VoucherKey = 0
  || 04/03/12 GHL 10.555 Added logic for tUserGLCompanyAccess/tGLCompanyMap 
  || 05/10/12 GHL 10.556 Added VendorKey to validate against BoughtFromKey for 1099       
  || 11/20/13 GHL 10.574 Added CurrencyID filter  
  || 03/19/14 RLB 10.578 (203504) Added field for enhancement         
  */

	SET NOCOUNT ON

	declare @RestrictToGLCompany tinyint

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

	if @CreditCard = 1
		-- this is a credit card charge
		-- get real vouchers

		Select distinct
			0 as Applied,
			0 as Exclude1099,
			v.VoucherKey, 
			v.InvoiceNumber, 
			v.InvoiceDate, 
			v.VoucherTotal,
			v.DueDate,
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) as UnappliedAmount,
			p.ProjectNumber,
			p.ProjectName,
			v.VendorKey,
			vend.VendorID,
			vend.CompanyName as VendorName
		From 
			tVoucher v (nolock)
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
		left outer join tCompany vend (nolock) on v.VendorKey = vend.CompanyKey
		left outer join tUserGLCompanyAccess gla (nolock) on v.GLCompanyKey = gla.GLCompanyKey
		Where
			v.CompanyKey = @CompanyKey and
			isnull(v.CreditCard, 0) = 0 and 
			(@VendorKey is null or v.VendorKey = @VendorKey) and

			(@RestrictToGLCompany = 0 OR gla.UserKey = @UserKey) and
			(ISNULL(v.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) OR v.GLCompanyKey in (Select TargetGLCompanyKey from tGLCompanyMap (nolock) Where SourceGLCompanyKey = @GLCompanyKey) ) and
			
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) <> 0 and
			(@InvoiceNumber is null or (v.InvoiceNumber like '%' + @InvoiceNumber + '%' )) and
			(@StartDate is null or v.DueDate > @StartDate) and
			(@EndDate is null or v.DueDate < @EndDate) and
			v.VoucherKey not in (Select VoucherKey from tVoucherCC (nolock) Where tVoucherCC.VoucherCCKey = @VoucherKey)
			and (isnull(v.CurrencyID, '') = isnull(@CurrencyID,'') )

			order by vend.VendorID, v.InvoiceNumber
	else
		-- current voucher is NOT a credit card charge
		-- get credit card charges

		Select distinct
			0 as Applied,
			0 as Exclude1099,
			v.VoucherKey, 
			v.InvoiceNumber, 
			v.InvoiceDate, 
			v.DueDate,
			v.VoucherTotal,
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) as UnappliedAmount,
			p.ProjectNumber,
			p.ProjectName,
			v.VendorKey,
			vend.VendorID,
			vend.CompanyName as VendorName
	
		From 
			tVoucher v (nolock)
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
		left outer join tCompany vend (nolock) on v.VendorKey = vend.CompanyKey
		Where
			v.CompanyKey = @CompanyKey and
			isnull(v.CreditCard, 0) = 1 and
			(@VendorKey is null or v.VendorKey = @VendorKey) and
			ISNULL(v.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and 
			ISNULL(VoucherTotal, 0) - isnull(AmountPaid, 0) <> 0 and
			(@InvoiceNumber is null or (v.InvoiceNumber like '%' + @InvoiceNumber + '%' )) and
			(@StartDate is null or v.InvoiceDate > @StartDate) and
			(@EndDate is null or v.InvoiceDate < @EndDate) and
			v.VoucherKey not in (Select VoucherCCKey from tVoucherCC (nolock) Where tVoucherCC.VoucherKey = @VoucherKey)
			and (isnull(v.CurrencyID, '') = isnull(@CurrencyID,'') )

			order by vend.VendorID
GO
