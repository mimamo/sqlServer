USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricDashboard]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricDashboard]
	@CompanyKey int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel      What
  || 07/15/10 GWG 10.532   Fixed how the collection period is calculated.
  || 07/31/12 MFT 10.5.5.8 Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
  */

declare @MonthlyOverheadAmtCredit decimal(24,4)
declare @MonthlyOverheadAmtDebit decimal(24,4)
declare @MonthlyOverheadAmt decimal(24,4)
declare @MonthsOfCash decimal(9,2)
declare @LiquidAssetsAmt decimal(24,4)
declare @LiquidAssetsDebit decimal(24,4)
declare @LiquidAssetsCredit decimal(24,4)
declare @AccountsRecvAmtDebit decimal(24,4)
declare @AccountsRecvAmtCredit decimal(24,4)
declare @AccountsRecvAmt decimal(24,4)
declare @CollectionPeriodDays int
declare @TotalExpenseAmtDebit decimal(24,4)
declare @TotalExpenseAmtCredit decimal(24,4)
declare @TotalExpenseAmt decimal(24,4)
declare @CurrLiabilitiesAmtDebit decimal(24,4)
declare @CurrLiabilitiesAmtCredit decimal(24,4)
declare @CurrLiabilitiesAmt decimal(24,4)
declare @PaymentPeriodDays int
declare @ProjectedAGI decimal(24,4)
declare @ProjectedEffectiveHourlyRate money
declare @ProjectedBillingEfficiency decimal(9,2)
declare @LargestClientSize decimal(9,2)
declare @AGIAmt decimal(24,4)
declare @COGSAmt decimal(24,4)
declare @ExpenseAmt decimal(24,4)
declare @IncomeAmt decimal(24,4)
declare @CurrDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @AGIFromDate datetime
declare @AGIToDate datetime
declare @ClientCompanyKey int
declare @CompanyName varchar(200)

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

select @CurrDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/' + cast(datepart(d,getdate()) as varchar(2)) + '/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @AGIToDate = cast(cast(datepart(mm,@CurrDate) as varchar(2)) + '/01/' + cast(datepart(yyyy,@CurrDate) as varchar(4)) as datetime)
select @AGIFromDate = dateadd(mm,-12,@AGIToDate)
select @ToDate = @CurrDate
select @FromDate = dateadd(dd,-30,@ToDate)

-- get largest client
exec spDBMetricLargestClientPerc @CompanyKey, @AGIFromDate, @AGIToDate, @GLCompanyKey, @UserKey, @ClientCompanyKey output, @CompanyName output, @LargestClientSize output

-- calculate AGI for last 12 complete months
exec spDBMetricAGI @CompanyKey, @AGIFromDate, @AGIToDate, @GLCompanyKey, @UserKey, @IncomeAmt output, @COGSAmt output, @ExpenseAmt output, @AGIAmt output

-- monthly overhead
select @MonthlyOverheadAmtDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType = 51  -- Expense Accounts
and isnull(t.ClientKey,0) = 0
and TransactionDate >= @FromDate 
and TransactionDate < @ToDate

select @MonthlyOverheadAmtCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType = 51  -- Expense Accounts
and isnull(t.ClientKey,0) = 0
and TransactionDate >= @FromDate 
and TransactionDate < @ToDate

select @MonthlyOverheadAmt = @MonthlyOverheadAmtDebit - @MonthlyOverheadAmtCredit

-- months of cash
select @LiquidAssetsDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (10,12)  -- Bank, Current Asset Accounts	
and TransactionDate < @ToDate

select @LiquidAssetsCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (10,12)  -- Bank, Current Asset Accounts	
and TransactionDate < @ToDate

select @LiquidAssetsAmt = @LiquidAssetsDebit - @LiquidAssetsCredit

if @MonthlyOverheadAmt <> 0
select @MonthsOfCash = round(@LiquidAssetsAmt / @MonthlyOverheadAmt,1)
else 
select @MonthsOfCash = 999

-- collection period
select @AccountsRecvAmt = sum(Debit - Credit)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType = 11  -- Receivable Accounts
and TransactionDate >= @AGIFromDate 
and TransactionDate < @AGIToDate

if @IncomeAmt <> 0 and @AccountsRecvAmt <> 0
select @CollectionPeriodDays = round(@AccountsRecvAmt / (@IncomeAmt/365),0)
else
select @CollectionPeriodDays = 999

-- payment period
select @TotalExpenseAmtDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (50,51) -- COGS, Expense Accounts
and TransactionDate >= @AGIFromDate 
and TransactionDate < @AGIToDate

select @TotalExpenseAmtCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (50,51)  -- COGS, Expense Accounts
and TransactionDate >= @AGIFromDate 
and TransactionDate < @AGIToDate

select @TotalExpenseAmt = @TotalExpenseAmtDebit - @TotalExpenseAmtCredit

select @CurrLiabilitiesAmtCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (20,21)  -- Payable, Short Term Liabiblit Accounts
and TransactionDate < @AGIToDate

select @CurrLiabilitiesAmtDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where t.CompanyKey = @CompanyKey
and g.AccountType in (20,21)  -- Payable, Short Term Liabiblit Accounts
and TransactionDate < @AGIToDate

select @CurrLiabilitiesAmt = @CurrLiabilitiesAmtCredit - @CurrLiabilitiesAmtDebit

if @TotalExpenseAmt <> 0 and @CurrLiabilitiesAmt <> 0
	select @PaymentPeriodDays = round(@CurrLiabilitiesAmt / (@TotalExpenseAmt/365),0)
else
	select @PaymentPeriodDays = 0

-- return calculations in recordset
select @MonthsOfCash as MonthsOfCash
			,@CollectionPeriodDays as CollectionPeriodDays
			,@PaymentPeriodDays as PaymentPeriodDays
			,@ProjectedAGI as ProjectedAGI
			,@ProjectedEffectiveHourlyRate as ProjectedEffectiveHourlyRate
			,@ProjectedBillingEfficiency as ProjectedBillingEfficiency 
			,@LargestClientSize as LargestClientSize
GO
