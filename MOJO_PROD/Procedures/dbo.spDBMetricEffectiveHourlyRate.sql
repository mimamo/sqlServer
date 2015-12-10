USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricEffectiveHourlyRate]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricEffectiveHourlyRate]
	@CompanyKey int,
	@FullTimeHours int,
	@LaborBudgetKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
   */

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @IncomeFromDate datetime
declare @EmployeeCount int
declare @FullTimeMonth int
declare @FTEMonthlyHours int
declare @IncomeAmtCredit decimal(24,4)
declare @IncomeAmtDebit decimal(24,4)
declare @IncomeAmt decimal(24,4)
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

if isnull(@LaborBudgetKey,0) = 0 
	create Table #UserTime (UserKey int null, Hours decimal (9,3) null, Percentage decimal(9,3) null)

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
select @IncomeFromDate = dateadd(mm,-11,@FromDate)
select @FullTimeMonth = round(@FullTimeHours / 12,0)

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- calculate FTE based on Labor Budget or actual hours
		if isnull(@LaborBudgetKey,0) = 0 
			begin
				delete #UserTime
				
				insert #UserTime (UserKey, Hours)
				select t.UserKey, sum(ActualHours)
				from
					tTimeSheet ts (nolock)
					inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				  INNER JOIN tUser u (nolock) ON ts.UserKey = u.UserKey
					INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
				where
					month(ts.StartDate) = month(@FromDate) 
					and year(ts.StartDate) = year(@FromDate) 
					and ts.CompanyKey = @CompanyKey
				group by t.UserKey
				
				/*update #UserTime 
				set Percentage = 1
				where Hours >= @FullTimeMonth
				
				update #UserTime
				set Percentage = isnull(Hours, 0) / @FullTimeMonth
				where Percentage is null
				
				select @EmployeeCount = round(sum(Percentage),0)
				from #UserTime
				
				select @FTEMonthlyHours = @EmployeeCount * @FullTimeMonth 
				*/ 

				select @FTEMonthlyHours = sum(Hours)
				from #UserTime
			end
		else
			begin
				select 
					@FTEMonthlyHours = case month(@FromDate) 
					when 1 then sum(AvailableHours1) 
					when 2 then sum(AvailableHours2) 
					when 3 then sum(AvailableHours3) 
					when 4 then sum(AvailableHours4) 
					when 5 then sum(AvailableHours5)
					when 6 then sum(AvailableHours6)
					when 7 then sum(AvailableHours7)
					when 8 then sum(AvailableHours8)
					when 9 then sum(AvailableHours9)
					when 10 then sum(AvailableHours10)
					when 11 then sum(AvailableHours11)
					when 12 then sum(AvailableHours12) end
				from
					tLaborBudget lb (nolock) 
					inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
				Where lb.LaborBudgetKey = @LaborBudgetKey			
			end

		-- calculate total fee income for the period
		select @IncomeAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 40  -- Income Accounts
		and g.LaborIncome = 1
		and TransactionDate >= @IncomeFromDate 
		and TransactionDate < @ToDate

		select @IncomeAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 40  -- Income Accounts
		and g.LaborIncome = 1
		and TransactionDate >= @IncomeFromDate
		and TransactionDate < @ToDate

		select @IncomeAmt = (@IncomeAmtCredit - @IncomeAmtDebit) / 12

		insert #tMetric values (datepart(mm,@FromDate),isnull(round(@IncomeAmt/@FTEMonthlyHours,2),0))

		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @IncomeFromDate = dateadd(mm,1,@IncomeFromDate)
	end
	
-- return calculations in recordset
select * from #tMetric
GO
