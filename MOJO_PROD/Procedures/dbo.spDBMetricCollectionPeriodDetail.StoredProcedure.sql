USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricCollectionPeriodDetail]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricCollectionPeriodDetail]

		@CompanyKey INT,
		@FromDate DATETIME,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

  /*
  || When     Who Rel			What
  || 07/25/11 QMD WMJ 10.5.4.6  Initial Release: Used to get the detail for the month
  || 11/27/12 WDF WMJ 10.6.6.2  Added @GLCompanyKey & @UserKey params and GL Company restrictions 
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction   
  */

	DECLARE @EndRangeDate DATETIME
	DECLARE @ToDate DATETIME 
		
	SET @EndRangeDate = cast(cast(datepart(mm,@FromDate) as varchar(2)) + '/01/' + cast(datepart(yyyy,@FromDate) as varchar(4)) as datetime)
	SET @ToDate = DATEADD(mm, 1, @EndRangeDate)
	SET @FromDate = DATEADD(mm,-11,@EndRangeDate)

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------	
	
	CREATE TABLE #metricDetail (CompanyName VARCHAR(300), IncomeCredit DECIMAL(24,4) DEFAULT(0), 
								IncomeDebit DECIMAL(24,4) DEFAULT(0), IncomeAmount DECIMAL(24,4) DEFAULT(0), 
								ARAmtCredit DECIMAL(24,4) DEFAULT(0), ARAmtDebit DECIMAL(24,4) DEFAULT(0), 
								ARAmt DECIMAL(24,4) DEFAULT(0), TotalIncomeAmount DECIMAL(24,4) DEFAULT(0),
								TotalARAmount DECIMAL(24,4) DEFAULT(0))

	INSERT INTO #metricDetail (CompanyName, IncomeCredit, IncomeDebit, IncomeAmount)		
	SELECT	c.CompanyName, SUM(ISNULL(Credit,0)) AS IncomeCredit, SUM(ISNULL(Debit,0)) AS IncomeDebit, SUM(ISNULL(Credit,0)) - SUM(ISNULL(Debit,0)) AS IncomeAmount
	FROM	vHTransaction t (NOLOCK) INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
									INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
									LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.ClientKey
	WHERE	t.CompanyKey = @CompanyKey
			and	g.AccountType = 40  -- Income Accounts
			and	TransactionDate >= @FromDate 
			and TransactionDate < @ToDate 
	GROUP BY c.CompanyName
	
	UPDATE m
	SET	ARAmtCredit = m.ARAmtCredit + a.ARAmtCredit, ARAmtDebit = m.ARAmtDebit + a.ARAmtDebit, ARAmt = m.ARAmt + a.ARAmt
	FROM (	
		SELECT	c.CompanyName, SUM(ISNULL(Credit,0)) AS ARAmtCredit, SUM(ISNULL(Debit,0)) AS ARAmtDebit, SUM(ISNULL(Debit,0)) - SUM(ISNULL(Credit,0)) AS ARAmt
		FROM	vHTransaction t (NOLOCK) INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
										INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
										LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.ClientKey
		WHERE	t.CompanyKey = @CompanyKey
			and g.AccountType = 11  -- AR Accounts
			and TransactionDate < @ToDate  
		GROUP BY c.CompanyName  
	) a, #metricDetail m
	WHERE ISNULL(a.CompanyName,'') = ISNULL(m.CompanyName,'') COLLATE DATABASE_DEFAULT

	INSERT INTO #metricDetail (CompanyName, ARAmtCredit, ARAmtDebit, ARAmt)		
	SELECT	c.CompanyName, SUM(ISNULL(Credit,0)) AS ARAmtCredit, SUM(ISNULL(Debit,0)) AS ARAmtDebit, SUM(ISNULL(Debit,0)) - SUM(ISNULL(Credit,0)) AS ARAmt
	FROM	vHTransaction t (NOLOCK) INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
									INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
									LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.ClientKey
	WHERE	t.CompanyKey = @CompanyKey
		AND g.AccountType = 11  -- AR Accounts
		AND TransactionDate < @ToDate 
		AND NOT EXISTS (SELECT * FROM #metricDetail WHERE ISNULL(c.CompanyName,'') = ISNULL(CompanyName,'') COLLATE DATABASE_DEFAULT) 
	GROUP BY c.CompanyName  

	DECLARE @TotalIncomeAmount DECIMAL(24,4)
	DECLARE @TotalARAmount DECIMAL(24,4)
	
	SELECT @TotalIncomeAmount = SUM(IncomeAmount), @TotalARAmount = SUM(ARAmt)  FROM #metricDetail

	UPDATE #metricDetail
	SET	TotalIncomeAmount = @TotalIncomeAmount, TotalARAmount = @TotalARAmount
		
	SELECT *,
		CASE IncomeAmount 
			WHEN 0 THEN 0
			ELSE ARAmt / (IncomeAmount/365)
		END AS DaysTotal
	FROM #metricDetail
	ORDER BY CompanyName
GO
