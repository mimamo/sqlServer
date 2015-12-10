USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphChargeabilitySummary]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphChargeabilitySummary]
(
	@CompanyKey int,
	@LaborBudgetKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@UserKey int,
	@Mode smallint  --no longer used
)

AS --Encrypt

  /*
  || When     Who Rel           What
  || 01/23/08 QMD WMJ 1.0       Modified for initial Release of WMJ
  || 08/14/08 QMD WMJ 10.1.0.0  (31514) Changed cut and paste error below ... replaced @OfficeKey with @DepartmentKey
  || 02/06/09 RTC WMJ 10.1.0.8  (45624) Exclude time entires marked as billed from non-billable projects, rewritten for performance
  */


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
select @StartDate = cast(cast(@StartDateYear as varchar(10)) + '-' + cast(@StartDateMonth as varchar(10)) + '-01 00:00:00' as smalldatetime)

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
				select 
					case @BudgetMonth 
						when 1 then sum(TargetHours1) 
						when 2 then sum(TargetHours2) 
						when 3 then sum(TargetHours3) 
						when 4 then sum(TargetHours4) 
						when 5 then sum(TargetHours5)
						when 6 then sum(TargetHours6)
						when 7 then sum(TargetHours7)
						when 8 then sum(TargetHours8)
						when 9 then sum(TargetHours9)
						when 10 then sum(TargetHours10)
						when 11 then sum(TargetHours11)
						when 12 then sum(TargetHours12) 
					end
				from tLaborBudget lb (nolock) 
					inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
					inner join tUser (nolock) on lbd.UserKey = tUser.UserKey
				where lb.CompanyKey = @CompanyKey
				and (lb.LaborBudgetKey = @LaborBudgetKey OR @LaborBudgetKey IS NULL)
			)
			where MonthNum = @StartMonth
			and YearNum = @StartYear

		if @StartMonth = 1
			select @StartMonth = 12, @StartYear = @StartYear - 1
		else
			select @StartMonth = @StartMonth - 1

		select @i = @i + 1
	end


if @UserKey is not null or @OfficeKey is not null or @DepartmentKey is not null
	begin
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
				and (isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
				and (isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0) or @DepartmentKey is null)
				and (tTime.UserKey = @UserKey or @UserKey is null)
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
				and (isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
				and (isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0) or @DepartmentKey is null)
				and (tTime.UserKey = @UserKey or @UserKey is null)
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
				and (isnull(tUser.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
				and (isnull(tUser.DepartmentKey, 0) = isnull(@DepartmentKey, 0) or @DepartmentKey is null)
				and (tTime.UserKey = @UserKey or @UserKey is null)
			group by month(WorkDate), year(WorkDate)
		) as wrk
		where MonthNum = wrk.WorkMonth
		and YearNum = wrk.WorkYear
	end
else
	begin
		update #IncMonths
		set BillableHours = wrk.BillableHours
		from (
			select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(tTime.ActualHours) , 0) as BillableHours
			from tTime (nolock) 
				inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			where
				tProject.CompanyKey = @CompanyKey
				and tProject.NonBillable = 0 
				and tTime.ActualRate > 0 
				and WorkDate between @StartDate and @EndDate  
			group by month(WorkDate), year(WorkDate)
		) as wrk
		where MonthNum = wrk.WorkMonth
		and YearNum = wrk.WorkYear

		update #IncMonths
		set BilledHours = wrk.BilledHours 
		from (
			select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(BilledHours) , 0) as BilledHours
			from tTime (nolock) 
				inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			where
				tProject.CompanyKey = @CompanyKey
				and tProject.NonBillable = 0 
				and tTime.InvoiceLineKey is not null 
				and WorkDate between @StartDate and @EndDate 
			group by month(WorkDate), year(WorkDate)
		) as wrk
		where MonthNum = wrk.WorkMonth
		and YearNum = wrk.WorkYear

		update #IncMonths
		set UnbilledHours = wrk.UnbilledHours
		from (
			select month(WorkDate) as WorkMonth, year(WorkDate) as WorkYear, isnull(sum(ActualHours) , 0) as UnbilledHours
			from tTime (nolock) 
				inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			where 
				tProject.CompanyKey = @CompanyKey
				and tProject.NonBillable = 0 
				and tTime.InvoiceLineKey is null 
				and tTime.WriteOff = 0 
				and tTime.ActualRate > 0 
				and WorkDate between @StartDate and @EndDate 
			group by month(WorkDate), year(WorkDate)
		) as wrk
		where MonthNum = wrk.WorkMonth
		and YearNum = wrk.WorkYear
	end


select	MonthNum, 
		YearNum,
		isnull(TargetHours, 0) as [TargetHours],
		isnull(BillableHours, 0) as [BillableHours], 
		isnull(BilledHours, 0) as [BilledHours],
		isnull(UnbilledHours, 0) as [UnbilledHours] 
from	#IncMonths 
order by YearNum, MonthNum
GO
