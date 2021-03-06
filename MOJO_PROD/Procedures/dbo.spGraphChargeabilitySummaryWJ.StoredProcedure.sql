USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphChargeabilitySummaryWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphChargeabilitySummaryWJ]
(
	@CompanyKey int,
	@LaborBudgetKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@UserKey int,
	@GLCompanyKey int,
	@SessionUserKey int = null
)

AS --Encrypt

  /*
  || When     Who Rel           What
  || 01/23/08 QMD WMJ 1.0       Modified for initial Release of WMJ
  || 08/14/08 QMD WMJ 10.1.0.0  (31514) Changed cut and paste error below ... replaced @OfficeKey with @DepartmentKey
  || 02/06/09 RTC WMJ 10.1.0.8  (45624) Exclude time entires marked as billed from non-billable projects, rewritten for performance
  || 02/16/09 MFT WMJ 10.1.0.9  (46821) Re-added test for user, office and dept. for TargetHours update
  || 07/27/12 RLB WMJ 10.5.5.8  Adding HMI restrict to GL Company Greg also ask me to add GLCompany to the Widget
  */


Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

CREATE TABLE #IncMonths
 (
	MonthNum		int,
	YearNum			int,
	TargetHours		int,
	BillableHours	int,
	BilledHours		int,
	UnbilledHours	int
 )


declare @StartMonth int, @StartYear int, @i int, @TargetHours int, @BillableHours int, @BilledHours int, @UnbilledHours int, @FirstMonth int, @BudgetMonth int
declare @StartDate smalldatetime
declare @EndDate smalldatetime
declare @StartDateMonth int
declare @StartDateYear int

select @FirstMonth = isnull(FirstMonth, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
select @StartMonth = month(getdate())
select @StartYear = year(getdate())
select @EndDate = getdate()
select @StartDateMonth = @StartMonth - 6
select @StartDateYear = @StartYear
if @StartDateMonth = 0
	begin
		select @StartDateMonth = @StartDateMonth + 12
		select @StartDateYear = @StartDateYear - 1
	end
if @StartDateMonth < 0
	begin
		select @StartDateMonth = @StartDateMonth + 13
		select @StartDateYear = @StartDateYear - 1
	end
	
select @StartDate = cast(cast(@StartDateMonth as varchar(10)) + '/01/' + cast(@StartDateYear as varchar(10)) as smalldatetime)

select @i = 1

while @i <= 6
	begin
		insert #IncMonths (MonthNum, YearNum, TargetHours) values (@StartMonth, @StartYear, 0)
	
		select @BudgetMonth = @StartMonth - @FirstMonth + 1
		if @BudgetMonth <= 0
			select @BudgetMonth = @BudgetMonth + 12
			
		if isnull(@LaborBudgetKey, 0) > 0
		
			update #IncMonths
				set TargetHours = (
					Select
						Case @BudgetMonth 
							When 1 then Sum(TargetHours1) 
							When 2 then Sum(TargetHours2) 
							When 3 then Sum(TargetHours3) 
							When 4 then Sum(TargetHours4) 
							When 5 then Sum(TargetHours5)
							When 6 then Sum(TargetHours6)
							When 7 then Sum(TargetHours7)
							When 8 then Sum(TargetHours8)
							When 9 then Sum(TargetHours9)
							When 10 then Sum(TargetHours10)
							When 11 then Sum(TargetHours11)
							When 12 then Sum(TargetHours12) END
					from tLaborBudget lb (nolock) 
					inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
					inner join tUser (nolock) on lbd.UserKey = tUser.UserKey
					Where lb.CompanyKey = @CompanyKey
					AND (@LaborBudgetKey IS NULL OR lb.LaborBudgetKey = @LaborBudgetKey)
					AND (@OfficeKey IS NULL OR ISNULL(tUser.OfficeKey, 0) = ISNULL(@OfficeKey, 0))
					AND (@DepartmentKey IS NULL OR ISNULL(tUser.DepartmentKey, 0) = ISNULL(@DepartmentKey, 0))
					AND (@UserKey IS NULL OR lbd.UserKey = @UserKey)
					AND (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
					AND (@UserKey IS NOT NULL or(@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @SessionUserKey))))
				)
			where MonthNum = @StartMonth
			and YearNum = @StartYear	

		if @StartMonth = 1
			select @StartMonth = 12, @StartYear = @StartYear - 1
		else
			select @StartMonth = @StartMonth - 1

		select @i = @i + 1
	end


	update #IncMonths
	set BillableHours = wrk.BillableHours
	from (
		select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(tTime.ActualHours) , 0) as BillableHours
		from tTime (nolock) 
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		where
			tProject.CompanyKey = @CompanyKey
			and tProject.NonBillable = 0 
			and tTime.ActualRate > 0 
			and WorkDate between @StartDate and @EndDate 
			and (@OfficeKey is null or isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0))
			and (@DepartmentKey is null or isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0))
			and (@UserKey is null or tTime.UserKey = @UserKey)
			and (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
			and (@UserKey IS NOT NULL or (@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @SessionUserKey))))
			group by month(WorkDate), year(WorkDate)
	) as wrk
	where MonthNum = wrk.WorkMonth
	and YearNum = wrk.WorkYear

	update #IncMonths
	set BilledHours = wrk.BilledHours 
	from (
		select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(BilledHours) , 0) as BilledHours
		from tTime (nolock) 
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		where
			tProject.CompanyKey = @CompanyKey
			and tProject.NonBillable = 0 
			and tTime.InvoiceLineKey is not null 
			and WorkDate between @StartDate and @EndDate 
			and (@OfficeKey is null or isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0))
			and (@DepartmentKey is null or isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0))
			and (@UserKey is null or tTime.UserKey = @UserKey)
			and (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
			and (@UserKey IS NOT NULL or (@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @SessionUserKey))))
			group by month(WorkDate), year(WorkDate)
	) as wrk
	where MonthNum = wrk.WorkMonth
	and YearNum = wrk.WorkYear

	update #IncMonths
	set UnbilledHours = wrk.UnbilledHours
	from (
		select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(ActualHours) , 0) as UnbilledHours
		from tTime (nolock) 
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		where 
			tProject.CompanyKey = @CompanyKey
			and tTime.InvoiceLineKey is null 
			and tTime.WriteOff = 0 
			and tTime.ActualRate > 0 
			and tProject.NonBillable = 0 
			and WorkDate between @StartDate and @EndDate  
			and (@OfficeKey is null or isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0))
			and (@DepartmentKey is null or isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0))
			and (@UserKey is null or tTime.UserKey = @UserKey)
			and (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
			and (@UserKey IS NOT NULL or (@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @SessionUserKey)))) 
		group by month(WorkDate), year(WorkDate)
	) as wrk
	where MonthNum = wrk.WorkMonth
	and YearNum = wrk.WorkYear




select	MonthNum, 
		YearNum,
		isnull(TargetHours, 0) as [Target Hours],
		isnull(BillableHours, 0) as [Billable Hours], 
		isnull(BilledHours, 0) as [Billed Hours],
		isnull(UnbilledHours, 0) as [Unbilled Hours] 
from	#IncMonths 
order by YearNum, MonthNum
GO
