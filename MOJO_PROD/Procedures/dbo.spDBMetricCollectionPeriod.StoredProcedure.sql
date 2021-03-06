USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricCollectionPeriod]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricCollectionPeriod]
	@CompanyKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/05/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 07/19/11 QMD 10.5.4.5  Added FromDate to temp table
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
  */

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @PeriodFromDate datetime
declare @PeriodToDate datetime
declare @IncomeAmtCredit decimal(24,4)
declare @IncomeAmtDebit decimal(24,4)
declare @IncomeAmt decimal(24,4)
declare @ARAmtCredit decimal(24,4)
declare @ARAmtDebit decimal(24,4)
declare @ARAmt decimal(24,4)
declare @ARDays decimal(24,4)
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
		
		-- income credit
		select @IncomeAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 40  -- Income Accounts
		and TransactionDate >= @PeriodFromDate 
		and TransactionDate < @PeriodToDate
		
		-- income debit
		select @IncomeAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 40  -- Income Accounts
		and TransactionDate >= @PeriodFromDate 
		and TransactionDate < @PeriodToDate
		
		select @IncomeAmt = @IncomeAmtCredit - @IncomeAmtDebit
		
		--AR debit
		select @ARAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 11  -- AR Accounts
		and TransactionDate < @ToDate
		
		--AR debit
		select @ARAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 11  -- AR Accounts
		and TransactionDate < @ToDate
		
		select @ARAmt = @ARAmtDebit - @ARAmtCredit
		
		if @IncomeAmt = 0 
			select @ARDays = 0
		else
			select @ARDays = round(@ARAmt/(@IncomeAmt/365),0)
		
		insert #tMetric values (datepart(mm,@FromDate),@ARDays, @FromDate)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @PeriodFromDate = dateadd(mm,1,@PeriodFromDate)
		select @PeriodToDate = @ToDate
	end
	
	-- return calculations in recordset
	select *, Target = 45 from #tMetric
GO
