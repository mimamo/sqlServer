USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGeneralJournal]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGeneralJournal]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@GLCompanyKey INT = -1,		-- -1 All, 0 NULL, >0 valid GLCompany
		@Entity varchar(50),
		@CashBasisMode int = 0, -- 0 Accrual, 1 Cash Basis 
		@IncludeUnposted int = 0,
		@UserKey int = null
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey and Entity parameters.
|| 02/21/08  GHL 8.5     (21207) GLCompanyKey consistent with other reports
|| 03/11/09  GHL 10.020  Added cash basis support    
|| 11/11/09  GHL 10.513  Added Include Unposted parameter    
|| 12/11/09  GHL 10.514  (70268) Added missing EntityKey
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/12  GHL 10.576  Using now vHTransaction and vHCashTransaction (Debit mapped to HDebit)
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

If @CashBasisMode = 0
Begin
	If @IncludeUnposted = 0
	
	Select 
		t.TransactionDate,
		t.Entity,
		t.EntityKey,
		t.Reference,
		t.Memo,
		t.Debit,
		t.Credit,
		c.CompanyName,
		gl.AccountNumber,
		gl.AccountName
	from vHTransaction t (nolock) 
		Left Outer Join tCompany c (nolock) on t.SourceCompanyKey = c.CompanyKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where		t.TransactionDate >= @StartDate
		and		t.TransactionDate <= @EndDate
		and		t.CompanyKey = @CompanyKey
		--and		(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )

		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)


		and		(t.Entity = @Entity OR @Entity IS NULL)
	Order By
		t.TransactionDate, t.Entity, t.EntityKey, t.TransactionKey

	Else
	
	Select
		t.TransactionKey, 
		t.TransactionDate,
		t.Entity,
		t.EntityKey,
		t.Reference,
		t.Memo,
		t.Debit,
		t.Credit,
		c.CompanyName,
		gl.AccountNumber,
		gl.AccountName
	from vHTransaction t (nolock) 
		Left Outer Join tCompany c (nolock) on t.SourceCompanyKey = c.CompanyKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where		t.TransactionDate >= @StartDate
		and		t.TransactionDate <= @EndDate
		and		t.CompanyKey = @CompanyKey
		--and		(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		and		(t.Entity = @Entity OR @Entity IS NULL)

	Union All
	
	Select 
		t.TransactionKey, 
		t.TransactionDate,
		t.Entity,
		t.EntityKey,
		t.Reference,
		t.Memo,
		t.HDebit * -1 As Debit,	--reverse Debit and Credit
		t.HCredit * -1 As Credit,
		c.CompanyName,
		gl.AccountNumber,
		gl.AccountName
	from tTransactionUnpost t (nolock) 
		Left Outer Join tCompany c (nolock) on t.SourceCompanyKey = c.CompanyKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where		t.TransactionDate >= @StartDate
		and		t.TransactionDate <= @EndDate
		and		t.CompanyKey = @CompanyKey
		--and		(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
		
		and		(t.Entity = @Entity OR @Entity IS NULL)

	Order By
		TransactionDate, Entity, EntityKey, TransactionKey

End
Else
	Select 
		t.TransactionDate,
		t.Entity,
		t.EntityKey,
		t.Reference,
		t.Memo,
		t.Debit,
		t.Credit,
		c.CompanyName,
		gl.AccountNumber,
		gl.AccountName
	from vHCashTransaction t (nolock) 
		Left Outer Join tCompany c (nolock) on t.SourceCompanyKey = c.CompanyKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where		t.TransactionDate >= @StartDate
		and		t.TransactionDate <= @EndDate
		and		t.CompanyKey = @CompanyKey
		--and		(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		and		(t.Entity = @Entity OR @Entity IS NULL)
	Order By
		t.TransactionDate, t.Entity, t.EntityKey
GO
