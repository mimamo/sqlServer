USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptStatementOfCashFlowIncomeCurrency]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptStatementOfCashFlowIncomeCurrency]
	(@CompanyKey int
	,@StartDate smalldatetime
	,@BalanceDate smalldatetime
	,@GLCompanyKey int -- -1 All, 0 NULL, >0 valid GLCompany	
	,@UserKey int = null
	,@oNetIncome money output
	,@oBeginCash money output
	,@oEndCash money output
	)

AS  -- Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey parameter.
|| 02/10/09  GHL 10.018  (37631) Changed logic for GLCompany to match change in the UI
|| 08/16/11  GHL 10.546  (118913) Lifted ambiguity about GLCompanyKey
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
|| 09/26/14  GHL 10.584  (230656) Cloned spRptStatementOfCashFlowIncome for multi currency
||                       Net Income must include bank, AP, Ar, CC revals, and cash in foreign cash must be revalued 
*/

	SET NOCOUNT ON
	
Declare @RestrictToGLCompany int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

select @AdvBillAccountKey = AdvBillAccountKey
from tPreference (nolock)
where CompanyKey = @CompanyKey

select @AdvBillAccountKey = isnull(@AdvBillAccountKey, 0)

/* Step 1 Revalue the bank, AP, AR, CC and AdvBill accounts
*/

Create table #revalue
	(
	TransactionKey int 
	,GLAccountKey int
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


	insert #revalue(TransactionKey,GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select t.TransactionKey,t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	where t.CompanyKey = @CompanyKey
	and   gla.AccountType in (10, 11, 20, 23) -- Bank, CC, AP, AR
	and   gla.CurrencyID is not null
	and   t.CurrencyID is not null		        -- do not revalue the AR/AP adjustments where CurrencyID is null
	and   t.TransactionDate <= @BalanceDate
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
		
	-- And now process the Adv Bill account
	insert #revalue(TransactionKey,GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select t.TransactionKey,t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
	where t.CompanyKey = @CompanyKey
	and   t.GLAccountKey = @AdvBillAccountKey
	and   t.CurrencyID is not null		        
	and   t.TransactionDate <= @BalanceDate
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

	exec spRptBalanceSheetRevaluation @CompanyKey, @StartDate, @BalanceDate 

/* Step 2 calc the Net Income
*/
	declare @NetIncome As money
	declare @NetIncomeRevalued as money

	Select @NetIncome =
		(
		select ISNULL(Sum(Credit - Debit), 0) 
		from		vHTransaction t (nolock) 
		inner join	tGLAccount  gl (nolock)
		on			t.GLAccountKey = gl.GLAccountKey
		where		t.CompanyKey = @CompanyKey 
		and			AccountType > 33
		and			TransactionDate >= @StartDate
		and			TransactionDate <= @BalanceDate
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
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
		)

	-- Net income due to revaluation of bank accounts, AP, AR CC
	select @NetIncomeRevalued =  Sum(CurrentEarning) from #revalued

	-- The final Net Income is the sum of the 2
	select @NetIncome = isnull(@NetIncome, 0) + isnull(@NetIncomeRevalued, 0) 
	 
/* Step 3 Calc the Cash
*/
	declare  @BeginCash As money
			,@EndCash As money 
	declare  @BeginCashRevalued As money
			,@EndCashRevalued As money 
	
	-- Cash at beginning of period
	Select @BeginCash = Sum(Debit - Credit) -- Debit/Credit point to HDebit/HCredit in vHTransaction
	from		vHTransaction (nolock)  
	inner join	tGLAccount (nolock) on vHTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where		tGLAccount.CompanyKey = @CompanyKey 
	and			AccountType = 10  -- Bank
	and			TransactionDate < @StartDate 
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tTransaction.GLCompanyKey, 0)) 
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND vHTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(vHTransaction.GLCompanyKey, 0) = @GLCompanyKey)
			)
	AND TransactionKey not in (select TransactionKey from #revalue) -- may not be needed for Cash accounts


	-- Cash at end of period
	Select @EndCash = Sum(Debit - Credit) 
	from		vHTransaction (nolock) 
	inner join	tGLAccount (nolock) on vHTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where		tGLAccount.CompanyKey = @CompanyKey 
	and			AccountType = 10  -- Bank
	and			TransactionDate <= @BalanceDate
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tTransaction.GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND vHTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(vHTransaction.GLCompanyKey, 0) = @GLCompanyKey)
			)
	AND TransactionKey not in (select TransactionKey from #revalue) -- may not be needed for Cash Accounts


  select @BeginCashRevalued = sum(RevaluedHValue1) from #revalued where AccountType = 10 -- revalued at the end of first period
  select @EndCashRevalued = sum(RevaluedHValue) from #revalued where AccountType = 10 -- revalued at the end of second period

  -- the cash is the sum of the 2
  select @BeginCash = isnull(@BeginCash, 0) + isnull(@BeginCashRevalued, 0)
  select @EndCash = isnull(@EndCash, 0) + isnull(@EndCashRevalued, 0)

	Select	@oNetIncome = ISNULL(@NetIncome, 0)
			,@oBeginCash = ISNULL(@BeginCash, 0)
			,@oEndCash = ISNULL(@EndCash, 0)

/* debug	

select tGLAccount.AccountNumber, tGLAccount.AccountName, r.* 
from #revalued r 
inner join tGLAccount (nolock) on r.GLAccountKey = tGLAccount.GLAccountKey
where r.AccountType = 10 order by AccountNumber

Select  Sum(Debit - Credit) as Amount,  tGLAccount.GLAccountKey, tGLAccount.AccountNumber, tGLAccount.AccountName
	from		vHTransaction (nolock) 
	inner join	tGLAccount (nolock) on vHTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where		tGLAccount.CompanyKey = @CompanyKey 
	and			AccountType = 10  -- Bank
	and			TransactionDate <= @BalanceDate
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tTransaction.GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND vHTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(vHTransaction.GLCompanyKey, 0) = @GLCompanyKey)
			)
	AND TransactionKey not in (select TransactionKey from #revalue) -- may not be needed for Cash Accounts
	group by tGLAccount.GLAccountKey, tGLAccount.AccountNumber, tGLAccount.AccountName order by tGLAccount.AccountNumber

*/

	RETURN
GO
