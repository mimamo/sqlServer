USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBalanceSheetCurrency]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBalanceSheetCurrency]
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
|| 02/04/14  GHL 10.576   Created by cloning spRptBalanceSheet and added logic for multi currency 
|| 02/14/14  GHL 10.577   Bank accounts are revalued by account (not by transaction) only if Tran Date <= Balance Date (2/24/14)
|| 03/18/14  GHL 10.578   Added revaluation of the Advance Bill Account 
*/

-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @YearStart smalldatetime
Declare @FirstMonth int
Declare @CurYear int
Declare @BalanceMonth int
Declare @FirstYear int
Declare @RestrictToGLCompany int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @FirstMonth = ISNULL(FirstMonth, 1) 
      ,@RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@AdvBillAccountKey = AdvBillAccountKey
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

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
	GLAccountKey int null,
	TransactionDate smalldatetime null,
	CurrencyID varchar(10) null,
	Debit money null, -- in Transaction Currency
	Credit money null,
	HDebit money null, -- in Home Currency
	HCredit money null,
	Revalue int null 
)


Create table #revalue
	(
	GLAccountKey int
	,TransactionDate smalldatetime null
 	,CurrencyID varchar(10) null
	,Debit money null -- in Transaction Currency
	,Credit money null
	,HDebit money null -- in Home Currency
	,HCredit money null
	)

-- bank accounts cannot be revalued transaction by transaction
-- they have to be revalued as a group, i.e. if I have 1000 EUR at 1.389128 it should be:
-- round(1000 * 1.389128, 2) = 1389.13 
-- not SUM(round(values, 1.389128, 2) which will be diff from 1389.13   
Create table #revalued
	(
	GLAccountKey int null
	,CurrencyID varchar(10) null
	,AccountType int null
	,OriginalHValue1 money null -- 1st period, original value
	,RevaluedHValue1 money null -- 1st period, revalued value
	,OriginalHValue money null  -- 2 periods
	,RevaluedHValue money null
	,RetainedEarning money null
	,CurrentEarning money null
	)


/*
-- receive 200 EUR at 1.1 on 12/1/2013
Debit = 200
Credit = 0
HDebit = 220   at 1.1 on 12/1/2013
HCredit = 0
RevaluedHDebit1 = 240 at 1.2
RevaluedHCredit1 = 0
RevaluedHDebit = 280 at 1.4 =================>need in report
RevaluedHCredit = 0         =================>need in report

RetainedEarning = 240 -220 = 20 ==============>need in report
TotalEarning = 280 - 220 = 60 (not needed)
CurrentEarning =  60 - 20 = 40 ==============>need in report

*/

DECLARE	@HasClassKeys int
SELECT	@HasClassKeys = COUNT(*)
FROM	#ClassKeys

DECLARE	@HasGLCompanyKeys int
SELECT	@HasGLCompanyKeys = COUNT(*)
FROM	#GLCompanyKeys

IF @CashBasis = 0
	INSERT	#GLTran (GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit)
	SELECT	GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit
	FROM	tTransaction (nolock) 
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
	INSERT	#GLTran (GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit)
	SELECT	GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit
	FROM	tCashTransaction (nolock) 
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


	-- we only revalue Bank Accounts (10) and Credit Card Accounts (23) + AP (11) and AR (20) accounts.
	update #GLTran
	set    Revalue = 0

	update #GLTran
	set    #GLTran.Revalue = 1
	from   tGLAccount gla (nolock) 
	where  #GLTran.GLAccountKey = gla.GLAccountKey
	and    gla.AccountType in (10, 11, 20, 23)          -- Bank account and AR AP CCs
	and    gla.CurrencyID is not null			
	and    #GLTran.CurrencyID is not null		        -- do not revalue the AR/AP adjustments where CurrencyID is null
	and    #GLTran.TransactionDate <= @BalanceDate		-- only if Tran Date before or on Balance Date  

	update #GLTran
	set    #GLTran.Revalue = 1
	where  #GLTran.GLAccountKey = @AdvBillAccountKey
	and    #GLTran.CurrencyID is not null
	and    #GLTran.TransactionDate <= @BalanceDate -- only if Tran Date before or on Balance Date  


	/* Need to revalue if Tran Date <= Balance Date
	if Tran Date <= Beginning Date, there will be a retained earning and a current earning
	if Tran Date > Beginning Date, there will only be a current earning 

	if Tran Date > Balance Date, this is in the future, no need to revalue
	*/

	insert #revalue(GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit
	from   #GLTran
	where  Revalue = 1

	exec spRptBalanceSheetRevaluation @CompanyKey, @BeginningDate, @BalanceDate

-- if there is no retained earnings account, create a virtual account
if @REAccountKey is null
	Select @GLAccountKey = -1, @AccountNumber = '000', @AccountName = 'Retained Earnings'
else
	Select @GLAccountKey = GLAccountKey, @AccountNumber = AccountNumber, @AccountName = AccountName from tGLAccount (nolock) Where GLAccountKey = @REAccountKey

-- Calculate the Retained Earnings Amount

	-- Move prior net income over to retained earnings
if @CashBasis = 1	
	Select @REAmount = ISNULL(Sum(HCredit - HDebit), 0) from #GLTran t (nolock) 
		inner join vGLAccountCash gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where AccountType in (31, 40, 41, 50, 51, 52) 
		and TransactionDate < @BeginningDate
		and Revalue = 0
else
	Select @REAmount = ISNULL(Sum(HCredit - HDebit), 0) from #GLTran t (nolock) 
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where AccountType in (31, 40, 41, 50, 51, 52) 
		and TransactionDate < @BeginningDate
		and Revalue = 0

	-- Get any transactions posted directly to retained earnings
	If @REAccountKey is null
		Select @REAmount2 = 0
	else	
		Select @REAmount2 = ISNULL(Sum(HCredit - HDebit), 0) from #GLTran t (nolock)
		Where t.GLAccountKey = @REAccountKey and TransactionDate <= @BalanceDate
		and Revalue = 0

	Select @REAmount = @REAmount + @REAmount2

-- Calculate the Net Income Amount
if @CashBasis = 1
	Select @NIAmount = ISNULL(Sum(HCredit - HDebit), 0) 
		from #GLTran t (nolock) inner join vGLAccountCash gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	AccountType in (40, 41, 50, 51, 52)
		and		TransactionDate >= @BeginningDate
		and 	TransactionDate <= @BalanceDate
		and Revalue = 0
else
	Select @NIAmount = ISNULL(Sum(HCredit - HDebit), 0) 
		from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	AccountType in (40, 41, 50, 51, 52)
		and		TransactionDate >= @BeginningDate
		and 	TransactionDate <= @BalanceDate
		and Revalue = 0

declare @RevaluationCurrentEarning money
declare @RevaluationRetainedEarning money

select @RevaluationCurrentEarning = sum(CurrentEarning)
      ,@RevaluationRetainedEarning = sum(RetainedEarning) 
from #revalued 

select @NIAmount = isnull(@NIAmount, 0) + isnull(@RevaluationCurrentEarning,0) 
select @REAmount = isnull(@REAmount, 0) + isnull(@RevaluationRetainedEarning,0)

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
		,ISNULL(
		
			Case When AccountType < 20 and Rollup = 0 then
				(Select ISNULL(Sum(HDebit - HCredit), 0) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and     t.Revalue = 0) 
				+
				(Select ISNULL(Sum(RevaluedHValue),0) from #revalued t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)
				
				When AccountType = 31 and Rollup = 0 then

				(Select Sum(HCredit - HDebit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and		t.TransactionDate >= @BeginningDate)
			
				else

				(Select ISNULL(Sum(HCredit - HDebit), 0) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and     t.Revalue = 0) 
				+
				(Select ISNULL(Sum(RevaluedHValue),0) from #revalued t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)
								end 
			
			, 0) As Amount
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
		,ISNULL(
		
			Case When AccountType < 20 and Rollup = 0 then
				(Select ISNULL(Sum(HDebit - HCredit), 0) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and     t.Revalue = 0) 
				+
				(Select ISNULL(Sum(RevaluedHValue),0) from #revalued t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)

				When AccountType = 31 and Rollup = 0 then

				(Select Sum(HCredit - HDebit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and		t.TransactionDate >= @BeginningDate)
			
				else

				(Select ISNULL(Sum(HCredit - HDebit), 0) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		t.TransactionDate <= @BalanceDate
				and     t.Revalue = 0) 
				+
				(Select ISNULL(Sum(RevaluedHValue),0) from #revalued t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)
				
				end 
			
			, 0) As Amount
		,Active
		,AccountType
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
		,0
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
		,0
order by MajorGroup, MedianGroup, MinorGroup, DisplayOrder
GO
