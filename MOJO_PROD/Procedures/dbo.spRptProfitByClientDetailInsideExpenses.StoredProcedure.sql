USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailInsideExpenses]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailInsideExpenses]
	@CompanyKey int,
	@GLCompanyKey int,
	@ClientKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created for the Profit By Client Detail report
|| 02/08/08  CRG 8.5.0.4 (20497) Restrictions on only projects that have transactions posted was reinstated.
|| 03/06/09  GHL 10.0.2.0 (48226 + 48250) Removed the restriction on projects with posted transactions
||                       because now users compare inside labor cost with various allocation methods 
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Reading now home currency amounts (x by exchange rate)
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	SELECT	SUM(
	ISNULL(Round(mc.TotalCost * mc.ExchangeRate, 2), 0)
	) AS Amount, i.ItemName AS Label, i.ItemKey AS ID
	FROM	tMiscCost mc (nolock)
	INNER JOIN tItem i (nolock) ON mc.ItemKey = i.ItemKey
	INNER JOIN tProject p (nolock) ON mc.ProjectKey = p.ProjectKey
--This inner join has been uncommented for 20497
/*
	INNER JOIN 
			(SELECT DISTINCT ProjectKey
			FROM	tTransaction (nolock)
			INNER JOIN tGLAccount (nolock) ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
			WHERE	TransactionDate >= @StartDate and TransactionDate <= @EndDate
			AND		tGLAccount.AccountType in (40, 41, 50, 51, 52)
			AND		(tTransaction.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		 tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
*/			
	WHERE	mc.ExpenseDate >= @StartDate
	AND		mc.ExpenseDate <= @EndDate
	AND		p.ClientKey = @ClientKey
	--AND		(p.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
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
	GROUP BY i.ItemName, i.ItemKey
	
	UNION
	
	SELECT	SUM(ISNULL(round(er.ActualCost * ee.ExchangeRate,2),  0)), i.ItemName, i.ItemKey
	FROM	tExpenseReceipt er (nolock)
	INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	INNER JOIN tItem i (nolock) ON er.ItemKey = i.ItemKey
	INNER JOIN tProject p (nolock) ON er.ProjectKey = p.ProjectKey
--This inner join has been uncommented for 20497
/*
	INNER JOIN 
			(SELECT DISTINCT ProjectKey
			FROM	tTransaction (nolock)
			INNER JOIN tGLAccount (nolock) ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
			WHERE	TransactionDate >= @StartDate and TransactionDate <= @EndDate
			AND		tGLAccount.AccountType in (40, 41, 50, 51, 52)
			AND		(tTransaction.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		 tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
*/			
	WHERE	er.ExpenseDate >= @StartDate
	AND		er.ExpenseDate <= @EndDate
	AND		ee.Status = 4
	AND		er.VoucherDetailKey IS NULL
	AND		p.ClientKey = @ClientKey
	--AND		(p.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
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
	GROUP BY i.ItemName, i.ItemKey
GO
