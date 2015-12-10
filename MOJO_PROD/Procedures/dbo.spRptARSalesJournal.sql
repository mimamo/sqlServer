USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptARSalesJournal]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptARSalesJournal]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncomeOnly tinyint,
		@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 12/20/07 BSH 8.5    Added PostingDate
|| 02/21/08 GHL 8.5    (21207) Must be able to drill down by GL Company 
|| 10/25/12 GHL 10.561 Changed i.GLCompanyKey to t.GLCompanyKey for ICT
|| 01/24/14 GHL 10.576 Using now HDebit/HCredit vs Debit/Credit

*/

Declare @MinAccount int, @MaxAccount int
if @IncomeOnly = 1
	Select @MinAccount = 40, @MaxAccount = 41
else
	Select @MinAccount = 0, @MaxAccount = 999

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	Select
		'INVOICE' as Type,
		i.InvoiceKey as TranKey,
		i.ClientKey,
		i.InvoiceNumber,
		i.InvoiceDate,
		i.PostingDate,
		c.CompanyName,
		c.CustomerID,
		gl.AccountNumber,
		gl.AccountName,
		t.Memo,
		t.HDebit as Debit,
		t.HCredit as Credit,
		p.ProjectNumber
	From
		tInvoice i (nolock)
		inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and 'INVOICE' = t.Entity
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey

	Where
		i.CompanyKey = @CompanyKey and
		i.PostingDate >= @StartDate and
		i.PostingDate <= @EndDate and
		gl.AccountType >= @MinAccount and
		gl.AccountType <= @MaxAccount 
		--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )

		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

return 1
GO
