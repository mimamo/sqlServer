USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricAGIBillingsFTE]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricAGIBillingsFTE]
	@CompanyKey int,
	@FullTimeHours int, -- number of working hours per employee and per year 
	@LaborBudgetKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt
 
  /*
  || When     Who Rel       What
  || 05/24/11 RLB 10.5.4.4  (112132) Mike requested change to calculate Employee count for the yr not the month
  || 06/28/11 GHL 10.5.4.4  (112132) Reviewed calcs based on Mike's comments in issue
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  */

/*

Notes from Mike
===============
I calculated both the AGI and FTE numbers for the prior 12  
month period (6/1/10-5/31/11).  Here's my calculation:
AGI for 6/1/10-5/31/11 = $1,168,088
FTE = 19,234.25 total hours for 6/1/10-5/31/11 divided by 2080 = 9.25
AGI/FTE = $1,168,088 / 9.25 = $126,279.78
Workamajig shows $130,761.00

Design Document
===============
calculate AGIAmount by calling spDBMetricAGI in date range (a year)

if isnull(@LaborBudgetKey, 0) = 0
    we will calculate FTE (Full Time Equivalent) or Effective Number of Employees   
    based on ActualHours and FullTimeHours  

	ActualHours = Sum (ActualHours) from tTime where WorkDate in date range

	FTE = ActualHours / FullTimeHours
	
	AGI FTE = AGI / FTE
	
else 
    we will calculate FTE (Full Time Equivalent) or Effective Number of Employees   
    based on AvailableHours and TargetHours on labor budget   

	ActualHours = Sum (TargetHours) from tLaborBudgetDetail 

	we can keep FullTimeHours or recalc  
	FullTimeHours = Sum (AvailableHours) from tLaborBudgetDetail / count(*) from tLaborBudgetDetail
	Note:I will keep FullTimeHours

	FTE = ActualHours / FullTimeHours
	
	AGI FTE = AGI / FTE

*/

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

-- Protection against division by zero
if isnull(@FullTimeHours, 0) <= 0
	select @FullTimeHours = 2080  -- 40 hrs * 52 wks = 2080

declare @AGIAmt decimal(24,4)
declare @COGSAmt decimal(24,4)
declare @ExpenseAmt decimal(24,4)
declare @IncomeAmt decimal(24,4)
declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @AGIFromDate datetime
declare @AGIToDate datetime
declare @EmployeeCount decimal(24,4)
declare @ActualHours decimal(24, 4)
declare @Periods int

create table #tMetric (MonthNum int null, MetricVal decimal(24,4) null)

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
select @AGIFromDate = dateadd(mm,-11,@FromDate)
select @AGIToDate = @ToDate

-- calculate FTE based on Labor Budget or actual hours
if isnull(@LaborBudgetKey,0) > 0 
	begin
	-- this can be calculated upfront since it is not a function of dates
		select 
			@ActualHours = Total1 + Total2 + Total3 + Total4 + Total5 + Total6 + Total7 + Total8 + Total9 + Total10 + Total11 + Total12
			from (select
					SUM(TargetHours1) as Total1,
					SUM(TargetHours2) as Total2,
					SUM(TargetHours3) as Total3,
					SUM(TargetHours4) as Total4,
					SUM(TargetHours5) as Total5,
					SUM(TargetHours6) as Total6,
					SUM(TargetHours7) as Total7,
					SUM(TargetHours8) as Total8,
					SUM(TargetHours9) as Total9,
					SUM(TargetHours10) as Total10,
					SUM(TargetHours11) as Total11,
					SUM(TargetHours12) as Total12 
				from tLaborBudget lb (nolock) 
				inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
				Where lb.LaborBudgetKey = @LaborBudgetKey ) as data
		
		-- FTE = Full Time Equivalent or effective employee count 
		select @EmployeeCount = @ActualHours/ cast (@FullTimeHours as decimal(24, 4))
	end

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
   	
		-- calculate AGI for last 12 complete months
		exec spDBMetricAGI @CompanyKey, @AGIFromDate, @AGIToDate, @GLCompanyKey, @UserKey, @IncomeAmt output, @COGSAmt output, @ExpenseAmt output, @AGIAmt output
		
		-- calculate FTE based on Labor Budget or actual hours
		if isnull(@LaborBudgetKey,0) = 0 
			begin
				-- calculate actual based on 1 year of data
				select @ActualHours = sum(t.ActualHours)
				from
					tTimeSheet ts (nolock) 
					inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
					INNER JOIN tUser u (nolock) ON t.UserKey = u.UserKey
					INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
				where
					t.WorkDate >= @AGIFromDate
					and t.WorkDate < @AGIToDate
					and ts.CompanyKey = @CompanyKey
				
				-- FTE = Full Time Equivalent or effective employee count 
				select @EmployeeCount = @ActualHours/ cast (@FullTimeHours as decimal(24, 4))
		end
	
	if isnull(@EmployeeCount, 0) <= 0
		select @EmployeeCount = count(*)
		from
			tUser u (nolock)
			INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
		where CompanyKey = @CompanyKey
	if isnull(@EmployeeCount, 0) <= 0
		select @EmployeeCount = 1
		
		insert #tMetric values (datepart(mm,@FromDate),isnull(round(@AGIAmt/@EmployeeCount,0),2))
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @AGIFromDate = dateadd(mm,1,@AGIFromDate)
		select @AGIToDate = @ToDate
  end
 
-- return calculations in recordset
select * from #tMetric
GO
