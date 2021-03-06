USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAPPaymentJournal]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptAPPaymentJournal]
(
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
	@UserKey int = null
)

as --Encrypt

  /*
  || When     Who Rel     What
  || 02/21/08 GHL 8.5     (21207) Must be able to drill down by GL Company
  || 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess 
  || 09/20/13 WDF 10.572  Added VoucherID 
  || 01/23/14 GHL 10.576  Using now HDebit/HCredit vs Debit/Credit 
 */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
  
Select
	p.VendorKey,
	p.PaymentKey,
	p.PaymentDate,
	p.CheckNumber,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName,
	c.VendorID,
	c.CompanyName,
	t.TransactionKey,
	t.Reference,
	t.ClassKey,
	cl.ClassID,
	t.Memo as Description,
	t.HDebit as Debit,
	t.HCredit as Credit,
	v.VoucherID
From
	tPayment p (nolock)
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	inner join tTransaction t (nolock) on p.PaymentKey = t.EntityKey and 'PAYMENT' = t.Entity
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	left outer join tClass cl (nolock) on t.ClassKey = cl.ClassKey
	left outer join tPaymentDetail pd (nolock) on t.DetailLineKey = pd.PaymentDetailKey
	left outer join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
Where
	p.CompanyKey = @CompanyKey and
	p.PaymentDate >= @StartDate and
	p.PaymentDate <= @EndDate 
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

Order By
	p.PaymentDate, c.VendorID, p.PaymentKey, t.TransactionKey
GO
