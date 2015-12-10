USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailRevenue]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailRevenue]
	@GLCompanyKey int,
	@ClientKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Detail smallint,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created for the Profit By Client Detail report
|| 11/13/07  CRG 8.5     Removed Entity Restrictions
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Reading now vHTransaction for home currency amounts
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

-- @Detail = 1: By GLAccount, 2: By ProjectType

	IF @Detail = 1
		SELECT	ISNULL(SUM(t.Credit - t.Debit), 0) AS Amount, gl.AccountName AS Label, gl.GLAccountKey AS ID
		FROM	vHTransaction t (nolock)
		INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		WHERE	t.TransactionDate >= @StartDate 
		AND		t.TransactionDate <= @EndDate
		AND		gl.AccountType = 40
		AND		ISNULL(t.Overhead, 0) = 0
		AND		t.ClientKey = @ClientKey
		--AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
		GROUP BY gl.AccountName, gl.GLAccountKey
	ELSE
		SELECT	ISNULL(SUM(t.Credit - t.Debit), 0) AS Amount, ISNULL(pt.ProjectTypeName, '(Other)') AS Label, ISNULL(pt.ProjectTypeKey, 0) AS ID
		FROM	vHTransaction t (nolock)
		INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		LEFT JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey
		WHERE	t.TransactionDate >= @StartDate 
		AND		t.TransactionDate <= @EndDate
		AND		gl.AccountType = 40
		AND		ISNULL(t.Overhead, 0) = 0
		AND		t.ClientKey = @ClientKey
		--AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
		GROUP BY pt.ProjectTypeName, pt.ProjectTypeKey
GO
