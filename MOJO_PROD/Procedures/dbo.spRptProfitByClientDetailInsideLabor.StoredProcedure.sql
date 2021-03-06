USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailInsideLabor]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailInsideLabor]
	@CompanyKey int,
	@GLCompanyKey int,
	@ClientKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AllocateBy int,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created for the Profit By Client Detail report
|| 02/08/08  CRG 8.5.0.4 (20497) Restrictions on only projects that have transactions posted was reinstated.
|| 03/06/09  GHL 10.0.2.0 (48226 + 48250) Removed the restriction on projects with posted transactions
||                       because now users compare inside labor cost with various allocation methods 
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Using now HCostRate (in home currency)
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	IF @AllocateBy IN (2, 3)
		SELECT ISNULL(tmp.Cost, 0) AS Amount, ISNULL(s.Description, '(Other)') AS Label, ISNULL(s.ServiceKey, 0) AS ID
		FROM	#tTime tmp
		LEFT JOIN tService s (nolock) ON tmp.ServiceKey = s.ServiceKey
		WHERE	tmp.ClientKey = @ClientKey
	ELSE
		SELECT	SUM(ISNULL(t.ActualHours, 0) * ISNULL(t.HCostRate, 0)) AS Amount, ISNULL(s.Description, '(Other)') AS Label, ISNULL(s.ServiceKey, 0) AS ID
		FROM	tTime t (nolock)
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		LEFT JOIN tService s (nolock) ON t.ServiceKey = s.ServiceKey
--This inner join has been uncommented for 20497
/*
		INNER JOIN 
				(SELECT DISTINCT ProjectKey
				FROM	tTransaction (nolock)
				INNER JOIN tGLAccount ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
				WHERE	tTransaction.TransactionDate >= @StartDate AND tTransaction.TransactionDate <= @EndDate
				AND		tGLAccount.AccountType IN (40, 41, 50, 51, 52)
				AND		(ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
				AND		tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
*/
		WHERE	t.WorkDate >= @StartDate 
		AND		t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		p.ClientKey = @ClientKey
		--AND		(ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)

		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)	

		GROUP BY s.Description, s.ServiceKey
GO
