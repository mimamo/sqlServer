USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptConcentricChargeability]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptConcentricChargeability]
	(
	@CompanyKey int
	,@CurYear int
	,@CurMonth int
	,@CurNumberOfMonths int
	,@PrevYear int
	,@PrevMonth int
	,@PrevNumberOfMonths int
	,@ActiveOnly tinyint
	,@NonBillableClientKey1 int
	,@NonBillableClientKey2 int
    ,@NonBillableClientKey3 int
    ,@NonBillableClientKey4 int
	,@NonBillableClientKey5 int
	)
AS
	SET NOCOUNT ON 

/*
|| When      Who Rel      What
|| 12/08/14  GHL 10.587   (229954) Creation for an enhancement for Concentric Partners
|| 12/09/14  GHL 10.587   Added protection against null previous values (when only 1 month is selected)
|| 01/27/15  GHL 10.588   (243597) If @PrevNumberOfMonths = 0, i.e. it was not calculated because we have 1 month
||                        copy current month values to previous or YTD months 
*/

	/* Assume done in VB

	-- These are the hours for the current month
	create table #CurHour (
		UserKey int null
		,HoursPlanAvailable decimal(24,4) null -- Total on labor budget
		,HoursPlanBillable decimal(24,4) null  -- Total Billable on labor
		
		,HoursTotal decimal(24,4) null         -- Actual Total
		,HoursBillable decimal(24,4) null      -- Actual Billable
		) 

	-- these are the hours for the previous months
	create table #PrevHour (
		UserKey int null
		,HoursPlanAvailable decimal(24,4) null 
		,HoursPlanBillable decimal(24,4) null
		
		,HoursTotal decimal(24,4) null
		,HoursBillable decimal(24,4) null
		)

	*/

	-- use 3rd table to merge users and add non billable clients
	create table #Hour (
		UserKey int null
		,CurHoursPlanAvailable decimal(24,4) null
		,CurHoursPlanBillable decimal(24,4) null
		,CurHoursTotal decimal(24,4) null
		,CurHoursBillable decimal(24,4) null
		
		,PrevHoursPlanAvailable decimal(24,4) null
		,PrevHoursPlanBillable decimal(24,4) null
		,PrevHoursTotal decimal(24,4) null
		,PrevHoursBillable decimal(24,4) null
		
		,CurNonBillableHours1 decimal(24,4) null
		,CurNonBillableHours2 decimal(24,4) null
		,CurNonBillableHours3 decimal(24,4) null
		,CurNonBillableHours4 decimal(24,4) null
		,CurNonBillableHours5 decimal(24,4) null
		,CurNonBillableHoursTotal decimal(24,4) null

		,PrevNonBillableHours1 decimal(24,4) null
		,PrevNonBillableHours2 decimal(24,4) null
		,PrevNonBillableHours3 decimal(24,4) null
		,PrevNonBillableHours4 decimal(24,4) null
		,PrevNonBillableHours5 decimal(24,4) null
		,PrevNonBillableHoursTotal decimal(24,4) null

		)

	declare	@CurStartDate smalldatetime
	,@CurEndDate smalldatetime
	,@PrevStartDate smalldatetime
	,@PrevEndDate smalldatetime

Select @CurStartDate = Cast(Cast(@CurMonth as varchar) + '/1/' + Cast(@CurYear as varchar) as smalldatetime)
Select @CurEndDate = DateAdd(d, -1, DateAdd(mm, @CurNumberOfMonths, @CurStartDate))

if @PrevNumberOfMonths > 0
Select @PrevStartDate = Cast(Cast(@PrevMonth as varchar) + '/1/' + Cast(@PrevYear as varchar) as smalldatetime)
Select @PrevEndDate = DateAdd(d, -1, DateAdd(mm, @PrevNumberOfMonths, @PrevStartDate))

-- First merge the 2 temp tables
 
insert #Hour (UserKey, CurHoursPlanAvailable, CurHoursPlanBillable, CurHoursTotal, CurHoursBillable
	,PrevHoursPlanAvailable, PrevHoursPlanBillable, PrevHoursTotal, PrevHoursBillable)
select cur.UserKey, cur.HoursPlanAvailable, cur.HoursPlanBillable, cur.HoursTotal, cur.HoursBillable
		,isnull(prev.HoursPlanAvailable,0), isnull(prev.HoursPlanBillable,0), isnull(prev.HoursTotal,0), isnull(prev.HoursBillable, 0)
from   #CurHour cur
left join #PrevHour prev on cur.UserKey = prev.UserKey


	-- Now delete if required, before doing any other queries
	if 	@ActiveOnly = 1
		DELETE from #Hour where isnull(#Hour.CurHoursTotal,0) + isnull(#Hour.PrevHoursTotal,0)  = 0

	if isnull(@NonBillableClientKey1, 0) > 0
	begin
		update #Hour
		set    #Hour.CurNonBillableHours1 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey1
			and   t.WorkDate >= @CurStartDate
			and   t.WorkDate <= @CurEndDate
			and   t.UserKey = #Hour.UserKey
			)
		
		if @PrevNumberOfMonths > 0
		update #Hour
		set    #Hour.PrevNonBillableHours1 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey1
			and   t.WorkDate >= @PrevStartDate
			and   t.WorkDate <= @PrevEndDate
			and   t.UserKey = #Hour.UserKey
			)
	end


	if isnull(@NonBillableClientKey2, 0) > 0
	begin
		update #Hour
		set    #Hour.CurNonBillableHours2 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey2
			and   t.WorkDate >= @CurStartDate
			and   t.WorkDate <= @CurEndDate
			and   t.UserKey = #Hour.UserKey
			)
		
		if @PrevNumberOfMonths > 0
		update #Hour
		set    #Hour.PrevNonBillableHours2 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey2
			and   t.WorkDate >= @PrevStartDate
			and   t.WorkDate <= @PrevEndDate
			and   t.UserKey = #Hour.UserKey
			)
	end


	if isnull(@NonBillableClientKey3, 0) > 0
	begin
		update #Hour
		set    #Hour.CurNonBillableHours3 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey3
			and   t.WorkDate >= @CurStartDate
			and   t.WorkDate <= @CurEndDate
			and   t.UserKey = #Hour.UserKey
			)
		
		if @PrevNumberOfMonths > 0
		update #Hour
		set    #Hour.PrevNonBillableHours3 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey3
			and   t.WorkDate >= @PrevStartDate
			and   t.WorkDate <= @PrevEndDate
			and   t.UserKey = #Hour.UserKey
			)
	end


	if isnull(@NonBillableClientKey4, 0) > 0
	begin
		update #Hour
		set    #Hour.CurNonBillableHours4 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey4
			and   t.WorkDate >= @CurStartDate
			and   t.WorkDate <= @CurEndDate
			and   t.UserKey = #Hour.UserKey
			)
		
		if @PrevNumberOfMonths > 0
		update #Hour
		set    #Hour.PrevNonBillableHours4 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey4
			and   t.WorkDate >= @PrevStartDate
			and   t.WorkDate <= @PrevEndDate
			and   t.UserKey = #Hour.UserKey
			)
	end

	if isnull(@NonBillableClientKey5, 0) > 0
	begin
		update #Hour
		set    #Hour.CurNonBillableHours5 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey5
			and   t.WorkDate >= @CurStartDate
			and   t.WorkDate <= @CurEndDate
			and   t.UserKey = #Hour.UserKey
			)
		
		if @PrevNumberOfMonths > 0
		update #Hour
		set    #Hour.PrevNonBillableHours5 = 
			(
			select sum(t.ActualHours)
			from   tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where p.ClientKey = @NonBillableClientKey5
			and   t.WorkDate >= @PrevStartDate
			and   t.WorkDate <= @PrevEndDate
			and   t.UserKey = #Hour.UserKey
			)
	end

	-- if we had only 1 month, YTD values were not calculated, copy from the current values
	if isnull(@PrevNumberOfMonths, 0) = 0
		update #Hour
		set PrevHoursPlanAvailable =CurHoursPlanAvailable
		   ,PrevHoursPlanBillable = CurHoursPlanBillable
		   ,PrevHoursTotal = CurHoursTotal
		   ,PrevHoursBillable =CurHoursBillable

		   ,PrevNonBillableHours1 = CurNonBillableHours1
		   ,PrevNonBillableHours2 = CurNonBillableHours2
		   ,PrevNonBillableHours3 = CurNonBillableHours3
		   ,PrevNonBillableHours4 = CurNonBillableHours4
		   ,PrevNonBillableHours5 = CurNonBillableHours5
		   ,PrevNonBillableHoursTotal = CurNonBillableHoursTotal

	update #Hour
	set CurNonBillableHoursTotal = isnull(CurNonBillableHours1, 0) + isnull(CurNonBillableHours2, 0) + isnull(CurNonBillableHours3, 0) + isnull(CurNonBillableHours4, 0) + isnull(CurNonBillableHours5, 0)
       ,PrevNonBillableHoursTotal = isnull(PrevNonBillableHours1, 0) + isnull(PrevNonBillableHours2, 0) + isnull(PrevNonBillableHours3, 0) + isnull(PrevNonBillableHours4, 0) + isnull(PrevNonBillableHours5, 0)
    
	   ,CurNonBillableHours1 = isnull(CurNonBillableHours1, 0)
	   ,CurNonBillableHours2 = isnull(CurNonBillableHours2, 0)
	   ,CurNonBillableHours3 = isnull(CurNonBillableHours3, 0)
	   ,CurNonBillableHours4 = isnull(CurNonBillableHours4, 0)
	   ,CurNonBillableHours5 = isnull(CurNonBillableHours5, 0)

	   ,PrevNonBillableHours1 = isnull(PrevNonBillableHours1, 0)
	   ,PrevNonBillableHours2 = isnull(PrevNonBillableHours2, 0)
	   ,PrevNonBillableHours3 = isnull(PrevNonBillableHours3, 0)
	   ,PrevNonBillableHours4 = isnull(PrevNonBillableHours4, 0)
	   ,PrevNonBillableHours5 = isnull(PrevNonBillableHours5, 0)

	Select
	#Hour.*,
	ISNULL(tUser.OfficeKey, 0) as OfficeKey,
	ISNULL(tUser.DepartmentKey, 0) as DepartmentKey,
	ISNULL(tOffice.OfficeName, ' No Office') as OfficeName,
	ISNULL(tDepartment.DepartmentName, ' No Department') as DepartmentName,
	tUser.FirstName + ' ' + tUser.LastName as UserName,
	tUser.HourlyRate,
	tUser.HourlyCost,
	isnull(CurHoursPlanBillable, 0) - isnull(CurHoursBillable, 0) as CurCHVariance, -- Chargeable Hours variance
	isnull(PrevHoursPlanBillable, 0) - isnull(PrevHoursBillable, 0) as PrevCHVariance -- Chargeable Hours variance

From
	#Hour
	Inner join tUser (nolock) on tUser.UserKey = #Hour.UserKey
	left outer join tOffice (nolock) on tUser.OfficeKey = tOffice.OfficeKey
	left outer join tDepartment (nolock) on tUser.DepartmentKey = tDepartment.DepartmentKey
Order By 
	OfficeName, DepartmentName, tUser.LastName
	
	


	RETURN
GO
