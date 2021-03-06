USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptStatementOfCashFlowAdjustmentsCurrency]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptStatementOfCashFlowAdjustmentsCurrency]
	(@CompanyKey int
	,@StartDate smalldatetime
	,@BalanceDate smalldatetime
	,@GLCompanyKey int -- -1 All, 0 NULL, >0 valid GLCompany
	,@UserKey int = null
)
AS  -- Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey parameter.
|| 07/1/07   GWG 10.0.0.4 Moved current liability to operating activities
|| 02/10/09  GHL 10.018  (37631) Changed logic for GLCompany to match change in the UI
|| 10/13/11  GHL 10.459  Added support of credit card charges (liability) AccountType = 23
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
|| 09/26/14  GHL 10.584  (230656) Cloned spRptStatementOfCashFlowAdjustments for multi currency
||                       AP, AR, CC in foreign curr must be revalued 
*/

	SET NOCOUNT ON
	
/*
For 10, 20, 23, AdvBill

                  start date                            balance date
---------------------------------------------------------------------------------------->
                    |                                     |
					rate:1.15                             rate:1.3
                          200 at 1.2=240                  200 at 1.3=260 report 260 or RevaluedHValue
					
   100 at 1.1=110                                         100 at 1.3=130      		 
       RetainedEarning = 115-110=5                        CurrentEarning = 20-5=15 report CurrentEarning
       
*/

Declare @RestrictToGLCompany int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@AdvBillAccountKey = AdvBillAccountKey
from tPreference p (nolock) 
Where p.CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

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

Create table #revaluedCurrentEarning
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

	Insert Into #GLTran (GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit, Revalue)
	Select	t.GLAccountKey, t.TransactionDate, t.CurrencyID, t.Debit, t.Credit, t.HDebit, t.HCredit, 0 
	From	tTransaction t (nolock) 
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
 	Where	t.CompanyKey = @CompanyKey
	And		t.TransactionDate >= @StartDate
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and gla.AccountType > 10 
	and gla.AccountType < 33 
	and gla.AccountType not in (11, 20, 23)
	and isnull(gla.GLAccountKey,0) <> isnull(@AdvBillAccountKey, 0) 	

	-- for AP,AR,CC Adv bills, take them all (regardless of dates) we may have to revalue
	Insert Into #GLTran (GLAccountKey, TransactionDate, CurrencyID, Debit, Credit, HDebit, HCredit, Revalue)
	Select	t.GLAccountKey, t.TransactionDate, t.CurrencyID, t.Debit, t.Credit, t.HDebit, t.HCredit, 0 
	From	tTransaction t (nolock) 
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
 	Where	t.CompanyKey = @CompanyKey
	--And		t.TransactionDate >= @StartDate -- we may have to revalue, so take all dates 
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and gla.AccountType > 10 
	and gla.AccountType < 33 
	and (gla.AccountType  in (11, 20, 23)
		or isnull(gla.GLAccountKey,0) = isnull(@AdvBillAccountKey, 0) ) 

	update #GLTran
	set    #GLTran.Revalue = 1
	from   tGLAccount gla (nolock) 
	where  #GLTran.GLAccountKey = gla.GLAccountKey
	and    gla.AccountType in (11, 20, 23)              -- AR AP CCs
	and    gla.CurrencyID is not null			
	and    #GLTran.CurrencyID is not null		        -- do not revalue the AR/AP adjustments where CurrencyID is null
	
	update #GLTran
	set    #GLTran.Revalue = 1
	where  #GLTran.GLAccountKey = @AdvBillAccountKey
	and    #GLTran.CurrencyID is not null
	
	-- Now revalue the adjustments before the startdate, for these we want the Current Earnings only
	insert #revalue(GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit
	from   #GLTran
	where  Revalue = 1
	and    TransactionDate < @StartDate

	exec spRptBalanceSheetRevaluation @CompanyKey, @StartDate, @BalanceDate

	-- Save these adjustments in a separate table (we want to use CurrentEarning only)
   insert #revaluedCurrentEarning(GLAccountKey ,CurrencyID ,AccountType,OriginalHValue1,RevaluedHValue1
	,OriginalHValue,RevaluedHValue ,RetainedEarning ,CurrentEarning)
   select GLAccountKey ,CurrencyID ,AccountType,OriginalHValue1,RevaluedHValue1
	,OriginalHValue,RevaluedHValue ,RetainedEarning ,CurrentEarning
   from #revalued
 
   -- Now revalue the adjustments after or on the startdate, for these we want the RevaluedHValue only
   truncate table #revalue
   truncate table #revalued

	insert #revalue(GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit
	from   #GLTran
	where  Revalue = 1
	and    TransactionDate >= @StartDate

	exec spRptBalanceSheetRevaluation @CompanyKey, @StartDate, @BalanceDate

	-- problem here below is that we take Credit - Debit
	-- and spRptBalanceSheetRevaluation does:
	-- Debit - Credit  when Acct Type <=11
	-- Credit - Debit when Acct Type >11
	-- flip the signs here 
	update #revalued set RevaluedHValue = -1.0 * RevaluedHValue where AccountType <=11
	update #revalued set CurrentEarning = -1.0 * CurrentEarning where AccountType <=11

	--select * from #GLTran where GLAccountKey = 7289 
	--select * from #revalue where GLAccountKey = 7289 
	--select * from #revalued where GLAccountKey = 7289

	Select 
		GLAccountKey
		,AccountNumber
		,AccountName
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case -- 1 Operating activity, 2 investing, 3 financial
			When AccountType = 11 then 1
			When AccountType = 12 then 1
			When AccountType = 13 then 2
			When AccountType = 14 then 2
			When AccountType = 20 then 1
			When AccountType = 21 then 1 -- Current liability
			When AccountType = 22 then 3 -- Long term liability
			When AccountType = 23 then 3 -- Credit Card 
			When AccountType = 30 then 3
			When AccountType = 31 then 3
			When AccountType = 32 then 3			 
		 end as MajorGroup
		 -- add the amounts which were not revalued 
		,ISNULL((Select Sum(HCredit - HDebit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate
				and		TransactionDate <= @BalanceDate
				and     t.Revalue = 0), 0)
		-- add the amounts revalued, with transaction date >= StartDate
        +ISNULL((
			select sum(reval.RevaluedHValue)
			from #revalued reval 
			where reval.GLAccountKey = gl.GLAccountKey
		   ),0)
		-- add the current earnings only for transaction date < StartSate 
		+ISNULL((
			select sum(earn.CurrentEarning)
			from #revaluedCurrentEarning earn 
			where earn.GLAccountKey = gl.GLAccountKey
		   ),0)
			As PeriodAmount
		,Cast(0 as Money) as PeriodAmountRollup
	From
		tGLAccount gl (nolock)
	Where
		CompanyKey = @CompanyKey 
	and AccountType > 10 
	and AccountType < 33 
	--and GLAccountKey = 7289
	Order By MajorGroup, DisplayOrder
	
	RETURN
GO
