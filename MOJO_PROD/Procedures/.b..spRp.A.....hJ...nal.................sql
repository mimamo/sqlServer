USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAPPurchJournal]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptAPPurchJournal]
(
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
	@UserKey int = null	
)

as --Encrypt

  /*
  || When     Who Rel    What
  || 02/21/08 GHL 8.5    (21207) Must be able to drill down by GL Company 
  || 11/06/09 GHL 10.513 (67681) Added cleanup of extra time info set by Flex
  || 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 10/25/12 GHL 10.561  Changed v.GLCompanyKey to t.GLCompanyKey for ICT
  || 01/23/14 GHL 10.576  Using now HDebit/HCredit vs Debit/Credit 
  || 11/06/14 WDF 10.586 (225259) Added Credit Card records
 */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

-- cleanup times
select @StartDate = convert(smalldatetime, convert(varchar(10), @StartDate, 101), 101)
select @EndDate = convert(smalldatetime, convert(varchar(10), @EndDate, 101), 101)
  
Select
	t.Entity as Type,
	v.VoucherKey as TypeKey,
	v.InvoiceDate as TranDate,
	v.VendorKey,
	c.VendorID,
	c.CompanyName as VendorName,
	v.Status,
	v.InvoiceNumber,
	gl.AccountNumber,
	gl.AccountName,
	t.Memo as Description,
	p.ProjectNumber,
	t.HDebit as Debit,
	t.HCredit as Credit
From
	tVoucher v (nolock) 
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	inner join tTransaction t (nolock) on v.VoucherKey = t.EntityKey and 
	                                      ('VOUCHER' = t.Entity or 'CREDITCARD' = t.Entity)
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where
	v.CompanyKey = @CompanyKey and
	v.PostingDate >= @StartDate and
	v.PostingDate <= @EndDate 
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) )

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR
					t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) 
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != 1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
GO
