USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricPaymentPeriodDetail]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricPaymentPeriodDetail]

		@CompanyKey INT,
		@FromDate DATETIME,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

  /*
  || When     Who Rel			What
  || 07/25/11 QMD WMJ 10.5.4.6  Initial Release: Used to get the detail for the month
  || 11/23/11 GHL WMJ 10.5.5.0  (126710) Joining now tCompany.CompanyKey with t.SourceCompanyKey vs t.ClientKey 
  ||                            because we are dealing with AP and not AR
  ||                            Fixed collation errors when running 2008
  || 11/27/12 WDF WMJ 10.6.6.2  Added @GLCompanyKey & @UserKey params and GL Company restrictions  
  || 03/13/14 GHL 10.5.7.8      Using now vHTransaction  
  */

	DECLARE @EndRangeDate DATETIME
	DECLARE @ToDate DATETIME 
	
	SET @FromDate = DATEADD(mm, 1, @FromDate)
	SET @EndRangeDate = cast(cast(datepart(mm,@FromDate) as varchar(2)) + '/01/' + cast(datepart(yyyy,@FromDate) as varchar(4)) as datetime)
	SET @FromDate = DATEADD(mm, -12, @EndRangeDate)
	SET @ToDate = @EndRangeDate

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
		
	CREATE TABLE #metricDetail (CompanyName VARCHAR(300), ExpenseAmtCredit DECIMAL(24,4) DEFAULT(0), 
								ExpenseAmtDebit DECIMAL(24,4)  DEFAULT(0), ExpenseAmt DECIMAL(24,4) DEFAULT(0), 
								APAmtCredit DECIMAL(24,4)  DEFAULT(0), APAmtDebit DECIMAL(24,4)  DEFAULT(0), APAmt DECIMAL(24,4)  DEFAULT(0),
								TotalExpenseAmt DECIMAL(24,4)  DEFAULT(0), TotalAPAmt DECIMAL(24,4)  DEFAULT(0))

	INSERT INTO #metricDetail (CompanyName, ExpenseAmtCredit, ExpenseAmtDebit, ExpenseAmt)		
	SELECT	c.CompanyName, ISNULL(SUM(ISNULL(Credit,0)),0) AS ExpenseAmtCredit, ISNULL(SUM(ISNULL(Debit,0)),0) AS ExpenseAmtDebit, 
			ISNULL(SUM(ISNULL(Debit,0)),0) - ISNULL(SUM(ISNULL(Credit,0)),0) AS ExpenseAmt
	FROM	vHTransaction t (NOLOCK) 
	
	INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
	LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.SourceCompanyKey
	
	WHERE	t.CompanyKey = @CompanyKey
			AND g.AccountType IN (50,51) -- COGS, Expense Accounts
			AND TransactionDate >=  @FromDate
			AND TransactionDate < @ToDate
	GROUP BY c.CompanyName
				
	UPDATE m
	SET	APAmtCredit = m.APAmtCredit + a.APAmtCredit, APAmtDebit = m.APAmtDebit + a.APAmtDebit, APAmt = m.APAmt + a.APAmt
	FROM (	
			SELECT	c.CompanyName, ISNULL(SUM(ISNULL(Credit,0)),0) AS APAmtCredit,  ISNULL(SUM(ISNULL(Debit,0)),0) AS APAmtDebit, 
					ISNULL(SUM(ISNULL(Credit,0)),0) - ISNULL(SUM(ISNULL(Debit,0)),0) AS APAmt
			FROM	vHTransaction t (NOLOCK) 
			
			INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
			LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.SourceCompanyKey
			
			WHERE	t.CompanyKey = @CompanyKey
					AND g.AccountType IN (20,21)  -- Payable, Short Term Liabiblit Accounts
					AND TransactionDate < @ToDate
			GROUP BY c.CompanyName 
		 ) a, #metricDetail m
	WHERE ISNULL(a.CompanyName,'') = ISNULL(m.CompanyName,'') COLLATE DATABASE_DEFAULT

	INSERT INTO #metricDetail (CompanyName, APAmtCredit, APAmtDebit, APAmt)		
	SELECT	c.CompanyName, ISNULL(SUM(ISNULL(Credit,0)),0) AS APAmtCredit,  ISNULL(SUM(ISNULL(Debit,0)),0) AS APAmtDebit, 
			ISNULL(SUM(ISNULL(Credit,0)),0) - ISNULL(SUM(ISNULL(Debit,0)),0) AS APAmt
	FROM	vHTransaction t (NOLOCK) 
	
	INNER JOIN tGLAccount g (NOLOCK) ON t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
	LEFT JOIN tCompany c (NOLOCK) ON c.CompanyKey = t.SourceCompanyKey
	
	WHERE	t.CompanyKey = @CompanyKey
			AND g.AccountType IN (20,21)  -- Payable, Short Term Liabiblit Accounts
			AND TransactionDate < @ToDate
			AND NOT EXISTS (SELECT * FROM #metricDetail 
				WHERE ISNULL(c.CompanyName,'') = ISNULL(CompanyName,'') COLLATE DATABASE_DEFAULT)
	GROUP BY c.CompanyName 

	DECLARE @TotalExpenseAmt DECIMAL(24,4)
	DECLARE @TotalAPAmt DECIMAL(24,4)
	
	SELECT @TotalExpenseAmt = SUM(ExpenseAmt), @TotalAPAmt = SUM(APAmt)  FROM #metricDetail

	UPDATE #metricDetail
	SET	TotalExpenseAmt = @TotalExpenseAmt, TotalAPAmt = @TotalAPAmt
				
	SELECT  *,
		CASE ExpenseAmt 
			WHEN 0 THEN 0
			ELSE APAmt / (ExpenseAmt/365)
		END AS DaysTotal
	FROM #metricDetail
	ORDER BY CompanyName
GO
