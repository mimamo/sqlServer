USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricPaymentPeriod]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spDBMetricPaymentPeriod]

		@CompanyKey int,
		@NbrPeriods int,		
		@GLCompanyKey int,
		@UserKey int

as --Encrypt

  /*
  || When     Who Rel			What
  || 09/21/06 RTC 8.35			Corrected the calculation of the period dates.
  || 03/05/08 QMD WMJ 1.0		Modified for initial Release of WMJ
  || 07/25/11 QMD WMJ 10.5.4.5  Modified metric table to include from date
  || 11/27/12 WDF WMJ 10.6.6.2  Added @GLCompanyKey & @UserKey params and GL Company restrictions 
  || 03/13/14 GHL 10.5.7.8      Using now vHTransaction 
  */
  
declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @PeriodFromDate datetime
declare @PeriodToDate datetime
declare @ExpenseAmtCredit decimal(24,4)
declare @ExpenseAmtDebit decimal(24,4)
declare @ExpenseAmt decimal(24,4)
declare @APAmtCredit decimal(24,4)
declare @APAmtDebit decimal(24,4)
declare @APAmt decimal(24,4)
declare @APDays decimal(24,4)
declare @Periods decimal(24,4)

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

	create table #tMetric (MonthNum int null, MetricVal decimal(24,4), FromDate datetime)

	select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
	select @Periods = @NbrPeriods * -1
	select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
	select @ToDate = dateadd(mm,1,@FromDate)
	select @PeriodFromDate = dateadd(mm,-11,@FromDate)
	select @PeriodToDate = @ToDate
	
	while 1=1
		begin 
			if @ToDate > @EndRangeDate
				break
			
			-- expenses
			select @ExpenseAmtDebit = isnull(sum(isnull(Debit,0)),0)
			from vHTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
										 INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
			where t.CompanyKey = @CompanyKey
			and g.AccountType in (50,51) -- COGS, Expense Accounts
			and TransactionDate >= @PeriodFromDate 
			and TransactionDate < @PeriodToDate
			
			select @ExpenseAmtCredit = isnull(sum(isnull(Credit,0)),0)
			from vHTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
										 INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
			where t.CompanyKey = @CompanyKey
			and g.AccountType in (50,51)  -- COGS, Expense Accounts
			and TransactionDate >= @PeriodFromDate 
			and TransactionDate < @PeriodToDate

			select @ExpenseAmt = @ExpenseAmtDebit - @ExpenseAmtCredit
			
			-- AP
			select @APAmtCredit = isnull(sum(isnull(Credit,0)),0)
			from vHTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
										 INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
			where t.CompanyKey = @CompanyKey
			and g.AccountType in (20,21)  -- Payable, Short Term Liabiblit Accounts
			and TransactionDate < @ToDate

			select @APAmtDebit = isnull(sum(isnull(Debit,0)),0)
			from vHTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
										 INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
			where t.CompanyKey = @CompanyKey
			and g.AccountType in (20,21)  -- Payable, Short Term Liabiblit Accounts
			and TransactionDate < @ToDate

			select @APAmt = @APAmtCredit - @APAmtDebit
			
			if @ExpenseAmt = 0 
				select @APDays = 0
			else
				select @APDays = round(@APAmt/(@ExpenseAmt/365),0)
						
			insert #tMetric values (datepart(mm,@FromDate),@APDays, @FromDate)

			select @FromDate = dateadd(mm,1,@FromDate)
			select @ToDate = dateadd(mm,1,@ToDate)
			select @PeriodFromDate = dateadd(mm,1,@PeriodFromDate)
			select @PeriodToDate = @ToDate
		end
	
	-- return calculations in recordset
	select *, Target = 30 from #tMetric
GO
