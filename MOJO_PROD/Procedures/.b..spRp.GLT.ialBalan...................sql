USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLTrialBalance]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec spRptGLTrialBalance 1986, '3/3/2013'

CREATE PROCEDURE [dbo].[spRptGLTrialBalance]
(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@CashBasis int = 0,
	@UserKey int = null
)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey parameter.
||					     Also now look for Office and Department directly on the Transaction, rather than going through the Class. 
|| 06/03/11  GHL 10.545  Added CashBasis parameter to run the report against GL or cash basis GL
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 10/09/12  MFT 10.561  Added #GLCompanyKeys filter structure and included DisplayOrder (for ORDER BY)
|| 10/30/12  MFT 10.562  Changed Debit/Credit columns to show the Net amount or NULL (the same as the PDF report)
||               Removed @GLCompanyKey and @ClassKey from input parameters, added support for #ClassKeys filter
|| 12/5/12   GWG 10.562  Added different way to get default classes (from trans to prevent no data from invalid classes) and protection against 0 class 
|| 12/7/12   GWG 10.563  Made it <> instead of > for Key > 0
|| 03/01/13  GWG 10.5.6.5Added the display order of the RE account to properly slot it in place
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
*/

-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @FirstMonth int
Declare @FirstYear int
Declare @MultiCurrency int

Select @FirstMonth = ISNULL(FirstMonth, 1) 
	,@MultiCurrency = ISNULL(MultiCurrency, 0)
from tPreference (nolock) Where CompanyKey = @CompanyKey

if @MultiCurrency =1
begin
	exec spRptGLTrialBalanceCurrency @CompanyKey, @AsOfDate, @CashBasis, @UserKey
	return 1
end 

Select @FirstYear = Year(@AsOfDate)
if @FirstMonth > Month(@AsOfDate)
	Select @FirstYear = @FirstYear - 1
	
Select @BeginningDate = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

--To allow sp to be called as a stand alone
IF OBJECT_ID('tempdb..#GLCompanyKeys') IS NULL
	BEGIN
		CREATE TABLE #GLCompanyKeys(GLCompanyKey int NOT NULL PRIMARY KEY)
	END
IF OBJECT_ID('tempdb..#ClassKeys') IS NULL
	BEGIN
		CREATE TABLE #ClassKeys(ClassKey int NOT NULL PRIMARY KEY)
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
				SELECT Distinct GLCompanyKey
				FROM tTransaction (nolock) 
				WHERE CompanyKey = @CompanyKey and GLCompanyKey is not null and GLCompanyKey <> 0
			END
		ELSE
			INSERT INTO #GLCompanyKeys
			SELECT GLCompanyKey
			FROM tUserGLCompanyAccess (nolock)
			WHERE UserKey = @UserKey
	END
DECLARE @ClassCount int
SELECT @ClassCount = COUNT(*) FROM #ClassKeys
IF @ClassCount = 0
	BEGIN
		INSERT INTO #ClassKeys VALUES(0)
		INSERT INTO #ClassKeys
		SELECT Distinct ClassKey
		FROM tTransaction (nolock)
		WHERE CompanyKey = @CompanyKey and ClassKey is not null and ClassKey <> 0
	END

Declare @GLAccountKey int
Declare @AccountNumber varchar(50)
Declare @AccountName varchar(100)
Declare @REAmountCR money
Declare @REAmountDB money
Declare @REAmountCR2 money
Declare @REAmountDB2 money
Declare @REDisplayOrder int

Create table #GLTran
(
	CompanyKey int,
	GLAccountKey int,
	GLCompanyKey int,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

IF @CashBasis = 0
	INSERT	#GLTran (CompanyKey, GLAccountKey, GLCompanyKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, GLAccountKey, t.GLCompanyKey, TransactionDate, Debit, Credit
	FROM	vHTransaction t (nolock)
				INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
				INNER JOIN #ClassKeys c ON ISNULL(t.ClassKey, 0) = c.ClassKey
	WHERE	CompanyKey = @CompanyKey
ELSE
	INSERT	#GLTran (CompanyKey, GLAccountKey, GLCompanyKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, GLAccountKey, t.GLCompanyKey, TransactionDate, Debit, Credit
	FROM	vHCashTransaction t (nolock)
				INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
				INNER JOIN #ClassKeys c ON ISNULL(t.ClassKey, 0) = c.ClassKey
	WHERE	CompanyKey = @CompanyKey


-- Get the retained Earnings Account
Declare @REAccountKey int

if @CashBasis = 0
	Select @REAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountType = 32
else
	Select @REAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and isnull(AccountTypeCash,AccountType) = 32

-- if there is no retained earnings account, create a virtual account
if @REAccountKey is null
	Select @GLAccountKey = -1, @AccountNumber = '000', @AccountName = 'Retained Earnings', @REDisplayOrder = 999999
else
	Select @GLAccountKey = GLAccountKey, @AccountNumber = AccountNumber, @AccountName = AccountName, @REDisplayOrder = DisplayOrder from tGLAccount (nolock) Where GLAccountKey = @REAccountKey

-- Calculate the Retained Earnings Amount
-- Move prior net income over to retained earnings
if @CashBasis = 0
	Select @REAmountCR = ISNULL(SUM(Credit), 0), @REAmountDB = ISNULL(SUM(Debit), 0) 
		from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and AccountType in (31, 40, 41, 50, 51, 52) and TransactionDate < @BeginningDate
else
	Select @REAmountCR = ISNULL(SUM(Credit), 0), @REAmountDB = ISNULL(SUM(Debit), 0) 
		from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and isnull(AccountTypeCash,AccountType) in (31, 40, 41, 50, 51, 52) and TransactionDate < @BeginningDate
	
	-- Get any transactions posted directly to retained earnings
	If @REAccountKey is null
		Select @REAmountCR2 = 0, @REAmountDB2 = 0
	else	
		Select @REAmountCR2 = ISNULL(SUM(Credit), 0), @REAmountDB2 = ISNULL(SUM(Debit), 0)  
		from #GLTran t (nolock)
		Where t.GLAccountKey = @REAccountKey and TransactionDate <= @AsOfDate
		
	Select @REAmountDB = @REAmountDB + @REAmountDB2, @REAmountCR = @REAmountCR + @REAmountCR2

-- This summarizes all the do not close accounts.
if @CashBasis = 0
	-- Regular/Accrual GL

	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountType
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.Credit), 0) - ISNULL(SUM(t.Debit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, Debit, Credit From #GLTran (nolock) 
			Where TransactionDate <= @AsOfDate ) t on gl.GLAccountKey = t.GLAccountKey 
	Where
		gl.CompanyKey = @CompanyKey and
		gl.AccountType <= 30 and
		gl.Rollup = 0
	Group By gl.GLAccountKey ,gl.AccountNumber ,gl.AccountName,gl.AccountType,DisplayOrder
		
Union ALL

Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountType
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.Credit), 0) - ISNULL(SUM(t.Debit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, Debit, Credit From #GLTran (nolock) 
			Where TransactionDate <= @AsOfDate
			 and TransactionDate >= @BeginningDate) t on gl.GLAccountKey = t.GLAccountKey 
	Where
		gl.CompanyKey = @CompanyKey and
		gl.AccountType in (31, 40, 41, 50, 51, 52) and
		gl.Rollup = 0
	Group By gl.GLAccountKey ,gl.AccountNumber ,gl.AccountName,gl.AccountType,DisplayOrder
		
-- Include the retained earnings account
Union ALL
	Select
		 @GLAccountKey
		,@AccountNumber
		,@AccountName
		,32
		,CASE WHEN ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) > 0 THEN
			ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(@REAmountCR), 0) - ISNULL(SUM(@REAmountDB), 0) END AS Credit
		,@REDisplayOrder
	ORDER BY DisplayOrder
		
ELSE
	-- Cash Basis GL

	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,ISNULL(gl.AccountTypeCash, gl.AccountType) AS AccountType
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.Credit), 0) - ISNULL(SUM(t.Debit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, Debit, Credit From #GLTran (nolock) 
			Where TransactionDate <= @AsOfDate ) t on gl.GLAccountKey = t.GLAccountKey 
	Where
		gl.CompanyKey = @CompanyKey and
		isnull(gl.AccountTypeCash, gl.AccountType) <= 30 and
		gl.Rollup = 0
	Group By gl.GLAccountKey ,gl.AccountNumber ,gl.AccountName,isnull(gl.AccountTypeCash, gl.AccountType),DisplayOrder
		
Union ALL

Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,isnull(gl.AccountTypeCash, gl.AccountType) As AccountType
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.Debit), 0) - ISNULL(SUM(t.Credit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.Credit), 0) - ISNULL(SUM(t.Debit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, Debit, Credit From #GLTran (nolock) 
			Where TransactionDate <= @AsOfDate
			 and TransactionDate >= @BeginningDate) t on gl.GLAccountKey = t.GLAccountKey 
	Where
		gl.CompanyKey = @CompanyKey and
		isnull(gl.AccountTypeCash, gl.AccountType) in (31, 40, 41, 50, 51, 52) and
		gl.Rollup = 0
	Group By gl.GLAccountKey ,gl.AccountNumber ,gl.AccountName,isnull(gl.AccountTypeCash, gl.AccountType),DisplayOrder
		
-- Include the retained earnings account
Union ALL
	Select
		 @GLAccountKey
		,@AccountNumber
		,@AccountName
		,32
		,CASE WHEN ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) > 0 THEN
			ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(@REAmountDB), 0) - ISNULL(SUM(@REAmountCR), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(@REAmountCR), 0) - ISNULL(SUM(@REAmountDB), 0) END AS Credit
		,@REDisplayOrder
	ORDER BY DisplayOrder
GO
