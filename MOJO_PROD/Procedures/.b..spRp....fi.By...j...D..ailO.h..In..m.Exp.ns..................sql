USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByProjectDetailOtherIncomeExpense]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByProjectDetailOtherIncomeExpense]
	@GLCompanyKey int,
	@ProjectKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null,
	@OtherIncomeDirect money OUTPUT,
	@OtherCostsDirect money OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/27/08  CRG 10.0.1.1 (33250) Created for the Profit By Project Detail report
|| 05/11/10  GHL 10.523   (80512) Fixed where clause with GLCompanyKey 
|| 04/11/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Using now vHTransaction for home currency
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
	WHERE	t.ProjectKey = @ProjectKey
	--AND		(isnull(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	
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

	AND		t.TransactionDate >= @StartDate
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 41
	AND		ISNULL(t.Overhead, 0) = 0

	SELECT	@OtherCostsDirect = ISNULL(SUM(Debit - Credit), 0)
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.ProjectKey = @ProjectKey
	--AND		(isnull(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	
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

	AND		t.TransactionDate >= @StartDate
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 52
	AND		ISNULL(t.Overhead, 0) = 0
GO
