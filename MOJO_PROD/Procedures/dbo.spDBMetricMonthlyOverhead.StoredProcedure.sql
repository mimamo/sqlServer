USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricMonthlyOverhead]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricMonthlyOverhead]
		@CompanyKey int,
		@NbrPeriods int,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

/*
|| When     Who Rel       What
|| 04/09/08 GHL 8.5.0.8   (24248) Changed query to match spRptProfitCalcOverheadAllocation
||                        Also rounding at 2 decimals since we display a percentage on screen (i.e x100)
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
declare @MonthlyOverhead decimal(9,2)	
declare @MonthlyOverheadAmtCredit decimal(24,4)
declare @MonthlyOverheadAmtDebit decimal(24,4)
declare @MonthlyOverheadAmt decimal(24,4)
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

create table #tMetric (MonthNum int null, MetricVal decimal(9,2) null)

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
		
		-- calculate monthly overhead
		select @MonthlyOverheadAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		--and g.AccountType = 51  -- Expense Accounts
		--and isnull(t.ClientKey,0) = 0
		and g.AccountType in (50, 51, 52)
		and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
		and TransactionDate >= @FromDate 
		and TransactionDate < @ToDate
		
		select @MonthlyOverheadAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		--and g.AccountType = 51  -- Expense Accounts
		--and isnull(t.ClientKey,0) = 0
		and g.AccountType in (50, 51, 52)
		and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
		and TransactionDate >= @FromDate 
		and TransactionDate < @ToDate
		
		select @MonthlyOverheadAmt = @MonthlyOverheadAmtDebit - @MonthlyOverheadAmtCredit
		
		if @AGIAmt <> 0
			select @MonthlyOverhead = round(@MonthlyOverheadAmt / (@AGIAmt/12),2)
		else
			select @MonthlyOverhead = 0		
		
		insert #tMetric values (datepart(mm,@FromDate),@MonthlyOverhead)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @AGIFromDate = dateadd(mm,1,@AGIFromDate)
		select @AGIToDate = @ToDate
	end

-- return calculations in recordset
select * from #tMetric
GO
