USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptARSalesJournalSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptARSalesJournalSummary]

	(
		@CompanyKey int,
		@ClientKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncomeOnly tinyint,
		@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 06/25/08 GHL 8.515 (29019) Must be able to drill down by GL Company 
|| 11/11/09 GWG 10.5.1.3 Changed the check for client key for new standards in reports.
|| 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 10/25/12 GHL 10.561 Changed i.GLCompanyKey to t.GLCompanyKey for ICT
||                     Combined 2 queries (client/no client) by changing where clause
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
		AccountNumber + ' ' + AccountName as AccountName, 
		Sum(Debit) as Debit,
		Sum(Credit) as Credit
	From
	(	Select
			gl.AccountNumber,
			gl.AccountName,
			t.HDebit as Debit,
			t.HCredit as Credit
		From
			tInvoice i (nolock)
			inner join tTransaction t (nolock) on i.InvoiceKey = t.EntityKey and 'INVOICE' = t.Entity
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
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

			AND (
				@ClientKey <= 0 -- ALL
				Or
				i.ClientKey = @ClientKey
			)

			) as tr

	Group By
		AccountNumber, AccountName
	Order By AccountNumber
GO
