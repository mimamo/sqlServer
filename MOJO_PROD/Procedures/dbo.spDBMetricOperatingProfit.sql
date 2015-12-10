USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricOperatingProfit]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricOperatingProfit]
		@CompanyKey int,
		@NbrPeriods int,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/05/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
  */

declare @AGIAmt decimal(24,4)
declare @COGSAmt decimal(24,4)
declare @ExpenseAmt decimal(24,4)
declare @IncomeAmt decimal(24,4)
declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @AGIFromDate datetime
declare @AGIToDate datetime
declare @OperatingProfit decimal(9,2)	
declare @TotExpenseAmtCredit decimal(24,4)
declare @TotExpenseAmtDebit decimal(24,4)
declare @TotExpenseAmt decimal(24,4)
declare @Periods int

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

create table #tMetric (MonthNum int null, MetricVal decimal(24,4) null)

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
select @AGIFromDate = dateadd(mm,-11,@FromDate)
select @AGIToDate = @ToDate
	
while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- calculate AGI for last 12 complete months
		exec spDBMetricAGI @CompanyKey, @AGIFromDate, @AGIToDate, @GLCompanyKey, @UserKey, @IncomeAmt output, @COGSAmt output, @ExpenseAmt output, @AGIAmt output
		
		select @TotExpenseAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 51  -- Expense Accounts
		and TransactionDate >= @AGIFromDate 
		and TransactionDate < @AGIToDate
		
		select @TotExpenseAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 51  -- Expense Accounts
		and TransactionDate >= @AGIFromDate 
		and TransactionDate < @AGIToDate
		
		select @TotExpenseAmt = @TotExpenseAmtDebit - @TotExpenseAmtCredit
		
		if @AGIAmt = 0
			select @OperatingProfit = 0
		else
			select @OperatingProfit = round((@IncomeAmt-(@COGSAmt+@TotExpenseAmt))/@AGIAmt,2)
		
		insert #tMetric values (datepart(mm,@FromDate),@OperatingProfit)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @AGIFromDate = dateadd(mm,1,@AGIFromDate)
		select @AGIToDate = @ToDate
	end

-- return calculations in recordset
select *, UpperTarget = .15, LowerTarget = .1 from #tMetric
GO
