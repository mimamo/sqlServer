USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBalanceSheet]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBalanceSheet]
	(
		@CompanyKey int,
		@BalanceDate smalldatetime,
		@CashBasis int = 0, -- 0 Accrual, 1 Cash Basis
		@UserKey int = null 
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 10/18/07  CRG 8.5      Added GLCompanyKey parameter.
||					      Also now look for Office and Department directly on the Transaction, rather than going through the Class. 
|| 03/11/09  GHL 10.020   Added cash basis support    
|| 06/11/09  GHL 10.027   Added use of AccountTypeCash
|| 10/13/11  GHL 10.459   Added support of credit card charges (liability) AccountType = 23
|| 12/20/11  CRG 10.5.5.1 (129222) Added Active so that the Hide Zero logic works correctly.
|| 04/10/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/20/12  GHL 10.558   GLCompany and class are now multiselect lookups
|| 12/30/13  GHL 10.575   Using now vHTransaction and vHCashTransaction because it is mapped to HDebit/HCredit
|| 02/04/14  GHL 10.576   Calling now spRptBalanceSheetCurrency for multi currency 
*/

-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @YearStart smalldatetime
Declare @FirstMonth int
Declare @CurYear int
Declare @BalanceMonth int
Declare @FirstYear int
Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @FirstMonth = ISNULL(FirstMonth, 1) 
      ,@RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

if @MultiCurrency = 1
begin
	exec spRptBalanceSheetCurrency @CompanyKey, @BalanceDate, @CashBasis, @UserKey
	return 1
end 

Select @FirstYear = Year(@BalanceDate)
if @FirstMonth > Month(@BalanceDate)
	Select @FirstYear = @FirstYear - 1
	
Select @BeginningDate = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)

-- Get the retained Earnings Account
Declare @REAccountKey int
Select @REAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountType = 32

Declare @GLAccountKey int
Declare @AccountNumber varchar(50)
Declare @AccountName varchar(100)
Declare @REAmount money
Declare @REAmount2 money
Declare @NIAmount money

Create table #GLTran
(
	CompanyKey int,
	GLAccountKey int,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

DECLARE	@HasClassKeys int
SELECT	@HasClassKeys = COUNT(*)
FROM	#ClassKeys

DECLARE	@HasGLCompanyKeys int
SELECT	@HasGLCompanyKeys = COUNT(*)
FROM	#GLCompanyKeys

IF @CashBasis = 0
	INSERT	#GLTran (CompanyKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, GLAccountKey, TransactionDate, Debit, Credit
	--FROM	tTransaction (nolock) 
	FROM	vHTransaction (nolock) -- because v.Debit = tTransaction.HDebit
	WHERE	CompanyKey = @CompanyKey
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

	AND (@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
					

ELSE
	INSERT	#GLTran (CompanyKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, GLAccountKey, TransactionDate, Debit, Credit
	--FROM	tCashTransaction (nolock) 
	FROM	vHCashTransaction (nolock) 
	WHERE	CompanyKey = @CompanyKey
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

	AND (@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))

-- if there is no retained earnings account, create a virtual account
if @REAccountKey is null
	Select @GLAccountKey = -1, @AccountNumber = '000', @AccountName = 'Retained Earnings'
else
	Select @GLAccountKey = GLAccountKey, @AccountNumber = AccountNumber, @AccountName = AccountName from tGLAccount (nolock) Where GLAccountKey = @REAccountKey

-- Calculate the Retained Earnings Amount

	-- Move prior net income over to retained earnings
if @CashBasis = 1	
	Select @REAmount = ISNULL(Sum(Credit - Debit), 0) from #GLTran t (nolock) inner join vGLAccountCash gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and AccountType in (31, 40, 41, 50, 51, 52) and TransactionDate < @BeginningDate
else
	Select @REAmount = ISNULL(Sum(Credit - Debit), 0) from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and AccountType in (31, 40, 41, 50, 51, 52) and TransactionDate < @BeginningDate

	
	-- Get any transactions posted directly to retained earnings
	If @REAccountKey is null
		Select @REAmount2 = 0
	else	
		Select @REAmount2 = ISNULL(Sum(Credit - Debit), 0) from #GLTran t (nolock)
		Where t.GLAccountKey = @REAccountKey and TransactionDate <= @BalanceDate
		
	Select @REAmount = @REAmount + @REAmount2

-- Calculate the Net Income Amount
if @CashBasis = 1
	Select @NIAmount = ISNULL(Sum(Credit - Debit), 0) from #GLTran t (nolock) inner join vGLAccountCash gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.CompanyKey = @CompanyKey
		and		AccountType in (40, 41, 50, 51, 52)
		and		TransactionDate >= @BeginningDate
		and 	TransactionDate <= @BalanceDate
else
	Select @NIAmount = ISNULL(Sum(Credit - Debit), 0) from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.CompanyKey = @CompanyKey
		and		AccountType in (40, 41, 50, 51, 52)
		and		TransactionDate >= @BeginningDate
		and 	TransactionDate <= @BalanceDate


if @CashBasis = 1
    -- Cash Basis    
	Select 
		 GLAccountKey
		,AccountNumber
		,AccountName
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case	
			When AccountType < 19 then 1 else 2 end as MajorGroup
		,Case	
			When AccountType = 20 then 0 
			When AccountType = 21 then 0
			When AccountType = 22 then 0
			When AccountType = 23 then 0
			When AccountType = 2 then 0 
			else 1 end as MedianGroup
		,Case 
			When AccountType <= 12 then 1
			When AccountType = 13 then 2
			When AccountType = 14 then 3
			When AccountType = 20 then 4
			When AccountType = 21 then 4 -- Current Liability
			When AccountType = 22 then 5 -- Long Term Liability
			When AccountType = 23 then 4 -- Credit Card Charge
			When AccountType = 30 then 6 
			When AccountType = 31 then 6 end as MinorGroup
		,ISNULL(Case When AccountType < 20 and Rollup = 0 then
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate)
				When AccountType = 31 and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and		t.TransactionDate >= @BeginningDate)
			else
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate) end , 0)
			As Amount
		,Active
	From
		vGLAccountCash gl (nolock)
	Where
		CompanyKey = @CompanyKey and
		AccountType < 32

Union ALL
	Select
		 @GLAccountKey
		,@AccountNumber
		,@AccountName
		,0
		,99998
		,0
		,0
		,2
		,1
		,6
		,@REAmount
		,1 --Active

Union ALL
	Select
		 -2
		,''
		,'Net Income'
		,0
		,99999
		,0
		,0
		,2
		,1
		,6
		,@NIAmount
		,1 --Active

order by MajorGroup, MedianGroup, MinorGroup, DisplayOrder

else

	-- Accrual Basis
	Select 
		 GLAccountKey
		,AccountNumber
		,AccountName
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case	
			When AccountType < 19 then 1 else 2 end as MajorGroup
		,Case	
			When AccountType = 20 then 0 
			When AccountType = 21 then 0
			When AccountType = 22 then 0
			When AccountType = 23 then 0
			When AccountType = 2 then 0 
			else 1 end as MedianGroup
		,Case 
			When AccountType <= 12 then 1
			When AccountType = 13 then 2
			When AccountType = 14 then 3
			When AccountType = 20 then 4
			When AccountType = 21 then 4
			When AccountType = 22 then 5
			When AccountType = 23 then 4
			When AccountType = 30 then 6 
			When AccountType = 31 then 6 end as MinorGroup
		,ISNULL(Case When AccountType < 20 and Rollup = 0 then
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate)
				When AccountType = 31 and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and		t.TransactionDate >= @BeginningDate)
			else
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate) end , 0)
			As Amount
		,Active
	From
		tGLAccount gl (nolock)
	Where
		CompanyKey = @CompanyKey and
		AccountType < 32

Union ALL
	Select
		 @GLAccountKey
		,@AccountNumber
		,@AccountName
		,0
		,99998
		,0
		,0
		,2
		,1
		,6
		,@REAmount
		,1 --Active

Union ALL
	Select
		 -2
		,''
		,'Net Income'
		,0
		,99999
		,0
		,0
		,2
		,1
		,6
		,@NIAmount
		,1 --Active

order by MajorGroup, MedianGroup, MinorGroup, DisplayOrder
GO
