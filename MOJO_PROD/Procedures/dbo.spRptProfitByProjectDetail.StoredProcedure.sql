USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByProjectDetail]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByProjectDetail]
	@ProjectKey int,
	@GLCompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AllocateBy int,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/27/08  CRG 10.0.1.1 (33250) Created for the Profit By Project Detail report
|| 05/11/10  GHL 10.523   (80512) Fixed where clause with GLCompanyKey 
|| 04/11/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Using now vHTransaction for home currency
|| 03/17/15  WDF 10.590  (249338) Added Rounding to calculations under 'Direct Labor'
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	--Revenue
	SELECT	ISNULL(SUM(t.Credit - t.Debit), 0) AS Amount, gl.AccountName AS Label, gl.GLAccountKey AS ID
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 40
	AND		ISNULL(t.Overhead, 0) = 0
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

	AND		t.ProjectKey = @ProjectKey
	GROUP BY gl.AccountName, gl.GLAccountKey

	--Outside Costs
	SELECT	ISNULL(SUM(t.Debit - t.Credit), 0) AS Amount, gl.AccountName AS Label, gl.GLAccountKey AS ID
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 50
	AND		ISNULL(t.Overhead, 0) = 0
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

	AND		t.ProjectKey = @ProjectKey
	GROUP BY gl.AccountName, gl.GLAccountKey
		
	--Inside Costs Direct
	SELECT	ISNULL(SUM(t.Debit - t.Credit), 0) AS Amount, gl.AccountName AS Label, gl.GLAccountKey AS ID
	FROM	vHTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType = 51
	AND		ISNULL(t.Overhead, 0) = 0
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

	AND		t.ProjectKey = @ProjectKey
	GROUP BY gl.AccountName, gl.GLAccountKey

	--Direct Labor
	IF @AllocateBy IN (2, 3)
		SELECT ISNULL(tmp.Cost, 0) AS Amount, ISNULL(s.Description, '(Other)') AS Label, ISNULL(s.ServiceKey, 0) AS ID
		FROM	#tTime tmp
		LEFT JOIN tService s (nolock) ON tmp.ServiceKey = s.ServiceKey
		WHERE	tmp.ProjectKey = @ProjectKey
	ELSE
		SELECT	SUM(round(ISNULL(t.ActualHours, 0) * ISNULL(t.HCostRate, 0), 2)) AS Amount, ISNULL(s.Description, '(Other)') AS Label, ISNULL(s.ServiceKey, 0) AS ID
		FROM	tTime t (nolock)
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		LEFT JOIN tService s (nolock) ON t.ServiceKey = s.ServiceKey
		WHERE	t.WorkDate >= @StartDate 
		AND		t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		p.ProjectKey = @ProjectKey
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
		
	--Inside Expense
	SELECT	SUM(round(ISNULL(mc.TotalCost, 0) * mc.ExchangeRate, 2) ) AS Amount, i.ItemName AS Label, i.ItemKey AS ID
	FROM	tMiscCost mc (nolock)
	INNER JOIN tItem i (nolock) ON mc.ItemKey = i.ItemKey
	INNER JOIN tProject p (nolock) ON mc.ProjectKey = p.ProjectKey
	WHERE	mc.ExpenseDate >= @StartDate
	AND		mc.ExpenseDate <= @EndDate
	AND		p.ProjectKey = @ProjectKey
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

	GROUP BY i.ItemName, i.ItemKey
	
	UNION
	
	SELECT	SUM(round(ISNULL(er.ActualCost, 0) * ee.ExchangeRate, 2) ), i.ItemName, i.ItemKey
	FROM	tExpenseReceipt er (nolock)
	INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	INNER JOIN tItem i (nolock) ON er.ItemKey = i.ItemKey
	INNER JOIN tProject p (nolock) ON er.ProjectKey = p.ProjectKey
	WHERE	er.ExpenseDate >= @StartDate
	AND		er.ExpenseDate <= @EndDate
	AND		ee.Status = 4
	AND		er.VoucherDetailKey IS NULL
	AND		p.ProjectKey = @ProjectKey
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

	GROUP BY i.ItemName, i.ItemKey
GO
