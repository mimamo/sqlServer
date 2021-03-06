USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLTrialBalanceCurrency]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLTrialBalanceCurrency]
(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@CashBasis int = 0,
	@UserKey int = null
)

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/03/14  GHL 10.577  Creation. Cloned spRptGLTrialBalance and modfied for multi currency (bank revaluation)
|| 03/11/14  GHL 10.578  Removed creation of rate tables, this is passed now from the UI
|| 03/20/14  GHL 10.578  Added Adv Bill account to revalue
|| 11/13/14  GHL 10.586  (236437) Fixed calc of RE amounts (was commented out by mistake)
*/

-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @FirstMonth int
Declare @FirstYear int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @FirstMonth = ISNULL(FirstMonth, 1) 
	,@AdvBillAccountKey = AdvBillAccountKey
from tPreference (nolock) Where CompanyKey = @CompanyKey

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
	CurrencyID varchar(10) null,
	Debit money,
	Credit money,
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

/* done in VB
create table #revaluerate(
		CurrencyID varchar(10) null
		,PreviousRate decimal(24,7) null
		,CurrentRate decimal(24,7) null
		)
*/

IF @CashBasis = 0
	INSERT	#GLTran (CompanyKey, GLAccountKey, GLCompanyKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit)
	SELECT	CompanyKey, GLAccountKey, t.GLCompanyKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit
	FROM	tTransaction t (nolock)
				INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
				INNER JOIN #ClassKeys c ON ISNULL(t.ClassKey, 0) = c.ClassKey
	WHERE	CompanyKey = @CompanyKey
ELSE
	INSERT	#GLTran (CompanyKey, GLAccountKey, GLCompanyKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit)
	SELECT	CompanyKey, GLAccountKey, t.GLCompanyKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit
	FROM	tCashTransaction t (nolock)
				INNER JOIN #GLCompanyKeys glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
				INNER JOIN #ClassKeys c ON ISNULL(t.ClassKey, 0) = c.ClassKey
	WHERE	CompanyKey = @CompanyKey

-- we only revalue Bank Accounts (10) and Credit Card Accounts (23) + AP (11) and AR (20) accounts.
	update #GLTran
	set    Revalue = 0

	update #GLTran
	set    #GLTran.Revalue = 1
	from   tGLAccount gla (nolock) 
	where  #GLTran.GLAccountKey = gla.GLAccountKey
	and    gla.AccountType in (10, 11, 20, 23)
	and    gla.CurrencyID is not null
	and    #GLTran.CurrencyID is not null -- do not revalue the AR AP adjustments
	and    #GLTran.TransactionDate <= @AsOfDate -- only if Tran Date before or on Balance Date  

	update #GLTran
	set    #GLTran.Revalue = 1
	where  #GLTran.GLAccountKey = @AdvBillAccountKey
	and    #GLTran.CurrencyID is not null
	and    #GLTran.TransactionDate <= @AsOfDate -- only if Tran Date before or on Balance Date  

	/* Need to revalue if Tran Date <= Balance Date
	if Tran Date <= Beginning Date, there will be a retained earning and a current earning
	if Tran Date > Beginning Date, there will only be a current earning 

	if Tran Date > Balance Date, this is in the future, no need to revalue
	*/

	insert #revalue(GLAccountKey,TransactionDate,CurrencyID, Debit,Credit,HDebit ,HCredit)
	select GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit
	from   #GLTran
	where  Revalue = 1

	exec spRptBalanceSheetRevaluation @CompanyKey, @BeginningDate, @AsOfDate

declare @RevaluationCurrentEarning money
declare @RevaluationRetainedEarning money

select @RevaluationCurrentEarning = sum(CurrentEarning)
      ,@RevaluationRetainedEarning = sum(RetainedEarning) 
from #revalued 

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
	Select @REAmountCR = ISNULL(SUM(HCredit), 0), @REAmountDB = ISNULL(SUM(HDebit), 0) 
		from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and AccountType in (31, 40, 41, 50, 51, 52) 
		and TransactionDate < @BeginningDate
		and t.Revalue = 0
else
	Select @REAmountCR = ISNULL(SUM(HCredit), 0), @REAmountDB = ISNULL(SUM(HDebit), 0) 
		from #GLTran t (nolock) inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where t.CompanyKey = @CompanyKey and isnull(AccountTypeCash,AccountType) in (31, 40, 41, 50, 51, 52) 
		and TransactionDate < @BeginningDate
		and t.Revalue = 0

	-- Get any transactions posted directly to retained earnings
	If @REAccountKey is null
		Select @REAmountCR2 = 0, @REAmountDB2 = 0
	else	
		Select @REAmountCR2 = ISNULL(SUM(HCredit), 0), @REAmountDB2 = ISNULL(SUM(HDebit), 0)  
		from #GLTran t (nolock)
		Where t.GLAccountKey = @REAccountKey and TransactionDate <= @AsOfDate
		and t.Revalue = 0

		
--select * from 		#revalue
--select * from 		#revalued
--select * from #revaluerate
/*
select @RevaluationCurrentEarning as RevaluationCurrentEarning 
      ,@RevaluationRetainedEarning as RevaluationRetainedEarning
	  ,@REAmountDB + @REAmountDB2 as REAmountDB
	  ,@REAmountCR + @REAmountCR2 as REAmountCR
*/

Select @REAmountDB = @REAmountDB + @REAmountDB2 , @REAmountCR = @REAmountCR + @REAmountCR2 


declare @REBalance money
declare @UnrealizedBalance money

select @REBalance = @REAmountDB - @REAmountCR - isnull(@RevaluationRetainedEarning,0)
select @UnrealizedBalance = -@RevaluationCurrentEarning

create table #glacct (GLAccountKey int null, HDebit money null, HCredit money null, Amount money null, Revalued money null)
insert #glacct (GLAccountKey)
select GLAccountKey from tGLAccount (nolock) where CompanyKey = @CompanyKey and AccountType <= 30 and Rollup = 0

update #glacct
set    #glacct.HDebit = (select
	sum (#GLTran.HDebit)
	from #GLTran 
	where Revalue = 0 and #GLTran.TransactionDate <= @AsOfDate and #GLTran.GLAccountKey = #glacct.GLAccountKey)  

update #glacct
set    #glacct.HCredit = (select
	sum (#GLTran.HCredit)
	from #GLTran 
	where Revalue = 0 and #GLTran.TransactionDate <= @AsOfDate and #GLTran.GLAccountKey = #glacct.GLAccountKey)  

update #glacct
set Amount = isnull(HDebit, 0) - isnull(HCredit,0)

update #glacct
set    #glacct.Revalued = (select SUM(#revalued.RevaluedHValue)
from   #revalued
where  #revalued.GLAccountKey = #glacct.GLAccountKey 

)
update #glacct
set Amount = isnull(Amount, 0) + isnull(Revalued, 0)
from tGLAccount gla (nolock) 
where #glacct.GLAccountKey = gla.GLAccountKey
and  AccountType <= 11

update #glacct
set Amount = isnull(Amount, 0) - isnull(Revalued, 0)
from tGLAccount gla (nolock) 
where #glacct.GLAccountKey = gla.GLAccountKey
and  AccountType > 11

/*
select * from #glacct where Amount <> 0

select b.AccountNumber, b.AccountType, a.* 
from #GLTran a
inner join tGLAccount b on a.GLAccountKey = b.GLAccountKey
*/



-- This summarizes all the do not close accounts.
if @CashBasis = 0
	-- Regular/Accrual GL

	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountType
		,CASE WHEN ISNULL(#glacct.Amount, 0) > 0 THEN
			ISNULL(#glacct.Amount, 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(#glacct.Amount, 0) > 0  THEN
			NULL ELSE -ISNULL(#glacct.Amount, 0)  END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join #glacct on gl.GLAccountKey = #glacct.GLAccountKey  
	Where
		gl.CompanyKey = @CompanyKey and
		gl.AccountType <= 30 and
		gl.Rollup = 0
	
		
Union ALL

Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountType
		,CASE WHEN ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) > 0 THEN
			ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.HCredit), 0) - ISNULL(SUM(t.HDebit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, HDebit, HCredit From #GLTran (nolock) 
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
		,case when isnull(@REBalance, 0) > 0 then
			isnull(@REBalance, 0) else  NULL end AS Debit
		,case when isnull(@REBalance, 0) > 0 then
			null else -isnull(@REBalance, 0)  end AS Credit
		,@REDisplayOrder

Union ALL
	Select
		 -2
		,''
		,'Unrealized Gains/Losses'
		,41
		,case when isnull(@UnrealizedBalance, 0) > 0 then
			isnull(@UnrealizedBalance, 0) else  NULL end AS Debit
		,case when isnull(@UnrealizedBalance, 0) > 0 then
			null else -isnull(@UnrealizedBalance, 0)  end AS Credit
		,999998
		
	ORDER BY DisplayOrder
		
ELSE
	-- Cash Basis GL

	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountType
		,CASE WHEN ISNULL(#glacct.Amount, 0) > 0 THEN
			ISNULL(#glacct.Amount, 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(#glacct.Amount, 0) > 0  THEN
			NULL ELSE -ISNULL(#glacct.Amount, 0)  END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join #glacct on gl.GLAccountKey = #glacct.GLAccountKey  
	Where
		gl.CompanyKey = @CompanyKey and
		gl.AccountType <= 30 and
		gl.Rollup = 0
	

Union ALL

Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,isnull(gl.AccountTypeCash, gl.AccountType) As AccountType
		,CASE WHEN ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) > 0 THEN
			ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) ELSE NULL END AS Debit
		,CASE WHEN ISNULL(SUM(t.HDebit), 0) - ISNULL(SUM(t.HCredit), 0) > 0 THEN
			NULL ELSE ISNULL(SUM(t.HCredit), 0) - ISNULL(SUM(t.HDebit), 0) END AS Credit
		,DisplayOrder
	From
		tGLAccount gl (nolock)
		left outer join 
		(Select GLAccountKey, HDebit, HCredit From #GLTran (nolock) 
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
		,case when isnull(@REBalance, 0) > 0 then
			isnull(@REBalance, 0) else  NULL end AS Debit
		,case when isnull(@REBalance, 0) > 0 then
			null else -isnull(@REBalance, 0)  end AS Credit
		,@REDisplayOrder

Union ALL
	Select
		 -2
		,''
		,'Unrealized Gains/Losses'
		,41
		,case when isnull(@UnrealizedBalance, 0) > 0 then
			isnull(@UnrealizedBalance, 0) else  NULL end AS Debit
		,case when isnull(@UnrealizedBalance, 0) > 0 then
			null else -isnull(@UnrealizedBalance, 0)  end AS Credit
		,999998

	ORDER BY DisplayOrder
GO
