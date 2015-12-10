USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLAccrualDDRevaluation]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLAccrualDDRevaluation]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null,
	@IsBank int = -1, -- -1 All, 0: AR/AP/CC revaluations, 1: Bank revaluations
	@CashBasis int = 0
AS --Encrypt

/*
|| When      Who Rel      What
|| 02/18/14  GHL 10.577   Creation. Displays records when drilling down revaluations
|| 02/24/14  GHL 10.577   Added CashBasis param
|| 03/20/14  GHL 10.578   Added the Adv Bill account to revalue
*/

/* Assume Created in VB
	CREATE TABLE #ClassKeys (ClassKey int NULL)
*/

Declare @RestrictToGLCompany int
Declare @MultiCurrency int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	  ,@AdvBillAccountKey = AdvBillAccountKey
from   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
select @MultiCurrency = isnull(@MultiCurrency, 0)

DECLARE	@HasClassKeys int
SELECT	@HasClassKeys = COUNT(*)
FROM	#ClassKeys

DECLARE	@HasGLCompanyKeys int
SELECT	@HasGLCompanyKeys = COUNT(*)
FROM	#GLCompanyKeys

DECLARE	@HasOfficeKeys int
SELECT	@HasOfficeKeys = COUNT(*)
FROM	#OfficeKeys

DECLARE	@HasDepartmentKeys int
SELECT	@HasDepartmentKeys = COUNT(*)
FROM	#DepartmentKeys

declare @BankRevaluations money
declare @UnrealizedCurrencyGains money
  
if @MultiCurrency = 1
begin

	Create table #revalue
		(
		TransactionKey int null
		,GLAccountKey int null
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

		,OriginalValue money null
		)

	if @CashBasis = 0
	begin
	
	insert #revalue(TransactionKey, GLAccountKey, TransactionDate,CurrencyID, Debit,Credit,HDebit ,HCredit)
	select t.TransactionKey, t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	where t.CompanyKey = @CompanyKey
	and   gla.AccountType in (10, 11, 20, 23) -- Bank, CC, AP, AR
	and   gla.CurrencyID is not null -- this is a foreign account 
	and   t.CurrencyID is not null -- do not take the AR/AP adjustments
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)

	insert #revalue(TransactionKey, GLAccountKey, TransactionDate,CurrencyID, Debit,Credit,HDebit ,HCredit)
	select t.TransactionKey, t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
	where t.CompanyKey = @CompanyKey
	and   t.GLAccountKey = @AdvBillAccountKey
	and   t.CurrencyID is not null 
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)

	end
	else
	begin

	insert #revalue( GLAccountKey, TransactionDate,CurrencyID, Debit,Credit,HDebit ,HCredit)
	select t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tCashTransaction t (nolock)
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	where t.CompanyKey = @CompanyKey
	and   gla.AccountType in (10, 11, 20, 23) -- Bank, CC, AP, AR
	and   gla.CurrencyID is not null
	and   t.CurrencyID is not null 
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)

	insert #revalue( GLAccountKey, TransactionDate,CurrencyID, Debit,Credit,HDebit ,HCredit)
	select t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tCashTransaction t (nolock)
	where t.CompanyKey = @CompanyKey
	and   t.GLAccountKey = @AdvBillAccountKey
	and   t.CurrencyID is not null 
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)


	end

	exec spRptBalanceSheetRevaluation @CompanyKey, @StartDate, @EndDate 

	select @BankRevaluations = isnull(sum(CurrentEarning), 0) from #revalued where AccountType = 10 
	select @UnrealizedCurrencyGains = isnull(sum(CurrentEarning), 0) from #revalued where AccountType <> 10 

	-- we need to calculate the Balance
	update #revalued
	set    #revalued.OriginalValue = ISNULL((
		select sum(#revalue.Debit - #revalue.Credit) from #revalue 
		where #revalue.GLAccountKey =#revalued.GLAccountKey
		and   #revalue.CurrencyID =#revalued.CurrencyID collate database_default   
		),0)
	where #revalued.AccountType <= 11 -- Bank = 10, AR 11
	
	update #revalued
	set    #revalued.OriginalValue = ISNULL((
		select sum(#revalue.Credit - #revalue.Debit) from #revalue 
		where #revalue.GLAccountKey =#revalued.GLAccountKey   
		and   #revalue.CurrencyID =#revalued.CurrencyID collate database_default
		),0)
	where #revalued.AccountType > 11 -- AP 20, CC 23
	

	If @IsBank = -1
		select  gla.AccountNumber, gla.AccountName 
				,reval.* 
				,isnull(reval.RetainedEarning, 0) + isnull(reval.CurrentEarning, 0) as TotalEarning 
				,r.PreviousRate
				,r.CurrentRate
		from #revalued reval
		left outer join #revaluerate r (nolock) on reval.CurrencyID = r.CurrencyID collate database_default
		inner join tGLAccount gla (nolock) on reval.GLAccountKey = gla.GLAccountKey
	
	If @IsBank = 0
		select  gla.AccountNumber, gla.AccountName 
				,reval.* 
				,isnull(reval.RetainedEarning, 0) + isnull(reval.CurrentEarning, 0) as TotalEarning 
				,r.PreviousRate
				,r.CurrentRate
		from #revalued reval
		inner join tGLAccount gla (nolock) on reval.GLAccountKey = gla.GLAccountKey
		left outer join #revaluerate r (nolock) on reval.CurrencyID = r.CurrencyID collate database_default
		where reval.AccountType <> 10
	
	If @IsBank = 1
		select  gla.AccountNumber, gla.AccountName 
				,reval.* 
				,isnull(reval.RetainedEarning, 0) + isnull(reval.CurrentEarning, 0) as TotalEarning 
				,r.PreviousRate
				,r.CurrentRate
		from #revalued reval
		inner join tGLAccount gla (nolock) on reval.GLAccountKey = gla.GLAccountKey
		left outer join #revaluerate r (nolock) on reval.CurrencyID = r.CurrencyID collate database_default
		where reval.AccountType = 10
	
 -- use this one if we want to drill down further		 
 --select * from #revalue

end
GO
