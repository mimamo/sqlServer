USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailOtherIncomeExpense]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailOtherIncomeExpense]
	@GLCompanyKey int,
	@ClientKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null,
	@OtherIncomeDirect money OUTPUT,
	@OtherCostsDirect money OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 11/14/07  CRG 8.5     Created to reflect design change
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Reading now vHTransaction for home currency amounts
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	SELECT	@OtherIncomeDirect = ISNULL(SUM(Credit - Debit), 0)
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.ClientKey = @ClientKey
	AND		t.TransactionDate >= @StartDate
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 41
	AND		ISNULL(t.Overhead, 0) = 0
	--AND		(t.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
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
		
	SELECT	@OtherCostsDirect = ISNULL(SUM(Debit - Credit), 0)
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.ClientKey = @ClientKey
	AND		t.TransactionDate >= @StartDate
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 52
	AND		ISNULL(t.Overhead, 0) = 0
	--AND		(t.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
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
GO
