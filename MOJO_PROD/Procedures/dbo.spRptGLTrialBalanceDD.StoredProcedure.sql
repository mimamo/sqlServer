USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLTrialBalanceDD]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLTrialBalanceDD]
	@GLAccountKey int,
	@AsOfDate smalldatetime,
	@ClassKey int,
	@GLCompanyKey int, --0 indicates the report is looking for "No Company Specified". NULL indicates All.
	@CashBasis int = 0,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/12/12  MFT 10.561  Created for drill down
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
*/

DECLARE @CompanyKey int
SELECT @CompanyKey = CompanyKey FROM tGLAccount WHERE GLAccountKey = @GLAccountKey

-- Calculate the beginning of fiscal year
DECLARE @BeginningDate smalldatetime
DECLARE @FirstMonth int
DECLARE @FirstYear int

SELECT @FirstMonth = ISNULL(FirstMonth, 1) FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey
SELECT @FirstYear = YEAR(@AsOfDate)
IF @FirstMonth > MONTH(@AsOfDate)
	SELECT @FirstYear = @FirstYear - 1

SELECT @BeginningDate = CASE WHEN ISNULL(AccountTypeCash, AccountType) IN (31, 40, 41, 50, 51, 52)
	THEN CAST(CAST(@FirstMonth AS varchar) + '/1/' + CAST(@FirstYear AS varchar) AS smalldatetime)
	ELSE '1/1/1900' END
FROM tGLAccount (nolock)
WHERE GLAccountKey = @GLAccountKey

DECLARE @RestrictToGLCompany int SELECT @RestrictToGLCompany = 0

SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	FROM tUser u (nolock)
	INNER JOIN tPreference p (nolock) ON p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	WHERE u.UserKey = @UserKey

--To allow sp to be called as a stand alone
IF OBJECT_ID('tempdb..#GLCompanyKeys') IS NULL
	BEGIN
		CREATE TABLE #GLCompanyKeys(GLCompanyKey int NOT NULL PRIMARY KEY)
	END

--If filtered in the UI, selected keys
--will be there, otherwise insert all
DECLARE @GLCount int
SELECT @GLCount = COUNT(*) FROM #GLCompanyKeys
IF @GLCount = 0
	BEGIN
		IF @RestrictToGLCompany = 0
			BEGIN
				INSERT INTO #GLCompanyKeys VALUES(0)
				INSERT INTO #GLCompanyKeys
				SELECT GLCompanyKey
				FROM tGLCompany (nolock)
				WHERE CompanyKey = @CompanyKey
			END
		ELSE
			INSERT INTO #GLCompanyKeys
			SELECT GLCompanyKey
			FROM tUserGLCompanyAccess (nolock)
			WHERE UserKey = @UserKey
	END
--If @GLCompanyKey was provided, delete others
--(for backward compatability)
DELETE FROM #GLCompanyKeys WHERE GLCompanyKey != @GLCompanyKey

IF @CashBasis = 0
	SELECT
		t.Entity,
		t.EntityKey,
		t.GLAccountKey,
		t.GLCompanyKey,
		t.TransactionDate,
		t.Reference,
		t.Memo,
		c.CompanyName,
		t.Debit,
		t.Credit
	FROM
		vHTransaction t (nolock)
		INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		LEFT JOIN tCompany c (nolock) ON t.SourceCompanyKey = c.CompanyKey
	WHERE
		t.GLAccountKey = @GLAccountKey AND
		(t.ClassKey = @ClassKey OR @ClassKey IS NULL) AND
		t.TransactionDate >= @BeginningDate AND
		t.TransactionDate <= @AsOfDate
ELSE
	SELECT
		t.Entity,
		t.EntityKey,
		t.GLAccountKey,
		t.GLCompanyKey,
		t.TransactionDate,
		t.Reference,
		t.Memo,
		c.CompanyName,
		t.Debit,
		t.Credit
	FROM
		vHCashTransaction t (nolock)
		INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		LEFT JOIN tCompany c (nolock) ON t.SourceCompanyKey = c.CompanyKey
	WHERE
		t.GLAccountKey = @GLAccountKey AND
		(t.ClassKey = @ClassKey OR @ClassKey IS NULL) AND
		t.TransactionDate >= @BeginningDate AND
		t.TransactionDate <= @AsOfDate
GO
