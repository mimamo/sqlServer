USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailBudgetRevenue]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailBudgetRevenue]
	@GLBudgetKey int,
	@GLCompanyKey int,
	@ClientKey int,
	@Month int,
	@AccountType int,
	@UserKey int = null,
	@RollupValue money = null OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/17/07  CRG 8.5     Created for the Profit By Client Detail report
|| 11/14/07  CRG 8.5     Modified for new design
|| 3/12/09   CRG 10.0.2.0 Modified to handle the fact that "No Specific" is now saved as -1.
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	IF @GLCompanyKey = 0
		SELECT @GLCompanyKey = -1

	IF @AccountType = 40 --Show Account Detail
		SELECT	SUM(
					CASE @Month
						WHEN -1 THEN ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
									+ ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
									+ ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
						WHEN 1 THEN bd.Month1
						WHEN 2 THEN bd.Month2
						WHEN 3 THEN bd.Month3
						WHEN 4 THEN bd.Month4
						WHEN 5 THEN bd.Month5
						WHEN 6 THEN bd.Month6
						WHEN 7 THEN bd.Month7
						WHEN 8 THEN bd.Month8
						WHEN 9 THEN bd.Month9
						WHEN 10 THEN bd.Month10
						WHEN 11 THEN bd.Month11
						WHEN 12 THEN bd.Month12
					END) AS Amount,
				gl.AccountName AS Label,
				gl.GLAccountKey AS ID
		FROM	tGLBudgetDetail bd (nolock)
		INNER JOIN tGLAccount gl (nolock) ON bd.GLAccountKey = gl.GLAccountKey
		AND		bd.GLBudgetKey = @GLBudgetKey
		--AND		(ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)

		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND bd.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey)
			)	


		AND		bd.ClientKey = @ClientKey
		AND		gl.AccountType = @AccountType
		GROUP BY gl.AccountName, gl.GLAccountKey
	ELSE --Show Rolled up Value for Entire Account Type
		SELECT	@RollupValue = SUM(
					CASE @Month
						WHEN -1 THEN ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
									+ ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
									+ ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
						WHEN 1 THEN bd.Month1
						WHEN 2 THEN bd.Month2
						WHEN 3 THEN bd.Month3
						WHEN 4 THEN bd.Month4
						WHEN 5 THEN bd.Month5
						WHEN 6 THEN bd.Month6
						WHEN 7 THEN bd.Month7
						WHEN 8 THEN bd.Month8
						WHEN 9 THEN bd.Month9
						WHEN 10 THEN bd.Month10
						WHEN 11 THEN bd.Month11
						WHEN 12 THEN bd.Month12
					END)
		FROM	tGLBudgetDetail bd (nolock)
		INNER JOIN tGLAccount gl (nolock) ON bd.GLAccountKey = gl.GLAccountKey
		AND		bd.GLBudgetKey = @GLBudgetKey
		--AND		(ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND bd.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey)
			)

		AND		bd.ClientKey = @ClientKey
		AND		gl.AccountType = @AccountType
GO
