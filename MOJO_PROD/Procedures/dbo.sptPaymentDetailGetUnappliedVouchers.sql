USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDetailGetUnappliedVouchers]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDetailGetUnappliedVouchers]

	(
		@VendorKey int,
		@GLCompanyKey int,
		@UserKey int,
		@CreditCard int = 0,
		@CurrencyID varchar(10) = null
	)

AS --Encrypt

/*
|| When     Who Rel		  What
|| 12/14/10 MFT 10.5.3.8  Added sort on InvoiceDate
|| 10/28/11 GHL 10.5.4.9  Added CreditCard param
|| 03/21/12 GWG 10.5.5.4  Modified join to find vouchers in other companies that have a mapping
|| 03/05/12 GHL 10.5.6.5  (170700) Added OfficeKey and ClassKey from invoice so that they can be 
||						  reversed during posting
|| 03/19/12 GHL 10.5.6.6  (172083) Added discount date to show on Flex screen
|| 04/29/13 GHL 10.5.6.7  (176301) Added rounding of Discount
|| 11/08/13 GHL 10.5.7.4  Added currency info
|| 02/20/15 MAS 10.5.8.9  (243079) Added VoucherID to be used as a Reference number
*/

	declare @RestrictToGLCompany tinyint

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey


		Select Distinct
			0 as Applied
			,v.VoucherKey
			,v.InvoiceNumber
			,v.InvoiceDate
			,v.DueDate
			,DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) as DiscountDate
			,Case When DATEADD(dd, ISNULL(v.TermsDays, 0), v.InvoiceDate) > GETDATE() Then
				
				ROUND((ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * (ISNULL(v.TermsPercent, 0) / 100.0), 2) 
				
				else 0 END as OpenDiscount
			,ISNULL(v.AmountPaid, 0) as VoucherAmountPaid
			,ISNULL(v.VoucherTotal, 0) as VoucherTotal
			,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) as VoucherAmountOpen
			,0
			,ISNULL(bbu.FirstName + ' ', '') + ISNULL(bbu.LastName, '') as BoughtByName
			,v.BoughtFrom
			,ISNULL(v.CreditCard, 0) as CreditCard
			,v.OfficeKey
			,v.ClassKey
			,v.VoucherID
		FROM         
			tVoucher v (nolock)
			left outer join tUserGLCompanyAccess gla (nolock) on v.GLCompanyKey = gla.GLCompanyKey
			left join tUser bbu (nolock) on v.BoughtByKey = bbu.UserKey
		Where
			v.VoucherTotal - v.AmountPaid <> 0 and
			v.VendorKey = @VendorKey and
			v.Status = 4 and
			(@RestrictToGLCompany = 0 OR gla.UserKey = @UserKey) and
			(ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR v.GLCompanyKey in (Select TargetGLCompanyKey from tGLCompanyMap (nolock) Where SourceGLCompanyKey = @GLCompanyKey) ) and
			ISNULL(v.CreditCard, 0) = @CreditCard and
			ISNULL(v.CurrencyID, '') = ISNULL(@CurrencyID, '')
		ORDER BY
			v.InvoiceDate
GO
