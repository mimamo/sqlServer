USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditGetList]

	(
		@CompanyKey int,
		@SearchOption int,
		@SearchPhrase varchar(50)
	)

AS


if @SearchOption = 1
BEGIN
	SELECT Distinct
		vc.* 
		,c.VendorID
		,c.CompanyName as VendorName
		,Case vc.Posted When 1 then 'YES' else 'NO' end as PostStatus
		,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where tVendorCreditDetail.VendorCreditKey = vc.VendorCreditKey and VoucherKey is not null) as AppliedAmount
	FROM         
		tVendorCredit vc (nolock)
		INNER JOIN tCompany c (nolock) ON vc.VendorKey = c.CompanyKey 
		inner join tVendorCreditDetail vcd (nolock) on vc.VendorCreditKey = vcd.VendorCreditKey
		inner join tVoucher v (nolock) on v.VoucherKey = vcd.VoucherKey
		inner join tVoucherDetail vd (nolock) on v.VoucherKey = vd.VoucherKey
		left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	Where
		p.ProjectNumber like @SearchPhrase + '%' and
		vc.CompanyKey = @CompanyKey

END

if @SearchOption = 2
BEGIN
	SELECT
		vc.* 
		,c.VendorID
		,c.CompanyName as VendorName
		,Case vc.Posted When 1 then 'YES' else 'NO' end as PostStatus
		,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where tVendorCreditDetail.VendorCreditKey = vc.VendorCreditKey and VoucherKey is not null) as AppliedAmount
	FROM         
		tVendorCredit vc (nolock)
		INNER JOIN tCompany c (nolock) ON vc.VendorKey = c.CompanyKey 
	Where
		c.VendorID like @SearchPhrase + '%' and
		vc.CompanyKey = @CompanyKey

END

if @SearchOption = 3
BEGIN
	SELECT
		vc.* 
		,c.VendorID
		,c.CompanyName as VendorName
		,Case vc.Posted When 1 then 'YES' else 'NO' end as PostStatus
		,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where tVendorCreditDetail.VendorCreditKey = vc.VendorCreditKey and VoucherKey is not null) as AppliedAmount
	FROM         
		tVendorCredit vc (nolock)
		INNER JOIN tCompany c (nolock) ON vc.VendorKey = c.CompanyKey 
	Where
		c.CompanyName like @SearchPhrase + '%' and
		vc.CompanyKey = @CompanyKey

END

if @SearchOption = 4
BEGIN
	SELECT
		vc.* 
		,c.VendorID
		,c.CompanyName as VendorName
		,Case vc.Posted When 1 then 'YES' else 'NO' end as PostStatus
		,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where tVendorCreditDetail.VendorCreditKey = vc.VendorCreditKey and VoucherKey is not null) as AppliedAmount
	FROM         
		tVendorCredit vc (nolock)
		INNER JOIN tCompany c (nolock) ON vc.VendorKey = c.CompanyKey 
	Where
		vc.CreditDate = Cast(@SearchPhrase as smalldatetime) and
		vc.CompanyKey = @CompanyKey

END
GO
