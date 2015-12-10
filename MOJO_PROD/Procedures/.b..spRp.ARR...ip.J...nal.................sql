USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptARReceiptJournal]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptARReceiptJournal]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 02/21/08 GHL 8.5   (21207) Must be able to drill down by GL Company 
|| 06/11/08 GHL 8.513 (28473) Added GLAccountKey for filter in report
|| 04/16/12 GHL 10.555 Added UserKey for UserGLCompanyAccess 
|| 01/24/14 GHL 10.576 Using now HDebit/HCredit vs Debit/Credit
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Select
	ch.CheckKey,
	ch.ClientKey,
	ch.ReferenceNumber,
	ch.PostingDate As CheckDate, -- Changed SP but not the report who expects CheckDate
	c.CompanyName,
	c.CustomerID,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName,
	t.Memo,
	t.HDebit as Debit,
	t.HCredit as Credit
From
	tCheck ch (nolock)
	inner join tTransaction t (nolock) on ch.CheckKey = t.EntityKey and 'RECEIPT' = t.Entity
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey

Where
	c.OwnerCompanyKey = @CompanyKey and
	ch.PostingDate >= @StartDate and
	ch.PostingDate <= @EndDate 
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(ch.GLCompanyKey, 0)) )

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(ch.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
			)

Order By
	PostingDate, CustomerID, TransactionKey
GO
