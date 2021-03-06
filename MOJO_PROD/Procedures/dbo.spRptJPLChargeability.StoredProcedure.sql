USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptJPLChargeability]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptJPLChargeability]
	(
	@CompanyKey int
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	,@TimeApproverKey int
	,@UserKey int
	,@IncludeInactiveEmployees tinyint
	)
AS
	SET NOCOUNT ON 

/*
|| When      Who Rel      What
|| 01/22/15  GAR 10.588   (242601) Creation for an enhancement for JPL.
*/

	-- assume: create table #departments (DepartmentKey int null)

	declare @AllDepartments int
	
	-- if no departments in the temp table, that means take all
	if (select count(*) from #departments) = 0
		select @AllDepartments = 1
	else
		select @AllDepartments = 0
		
	Create Table #csAmounts (
		UserKey int,
		HoursBillable decimal(24,4),
		HoursBillableNew decimal(24,4),
		HoursNonBillableClient decimal(24,4),
		HoursNonBillableMarketingPR decimal(12,4),
		HoursNonBillableInternal decimal(12,4),	
		HoursTotal decimal(24,4),
		HoursNonBillableTimeOff decimal(12,4),
		HoursCharged decimal(24,4),
		HoursBilled decimal(24,4),
		HoursUnbilled decimal(24,4),
		HoursWriteOff decimal(24,4),
		DollarsBillable money,
		DollarsBillableNew money,
		DollarsNonBillableClient money,
		DollarsNonBillableMarketingPR money,
		DollarsNonBillableInternal money,
		DollarsNonBillableTimeOff money,
		DollarsBilled money,
		DollarsUnbilled money,
		DollarsWriteOff money,
		AverageBillRate money,
		BillablePercentOfHoursWorked decimal(12,4)
	)

	Insert into #csAmounts (UserKey, HoursBillable, HoursBillableNew, HoursNonBillableClient, HoursNonBillableMarketingPR, HoursNonBillableInternal, HoursNonBillableTimeOff, 
		HoursTotal, HoursCharged,	HoursBilled, HoursUnbilled,	HoursWriteOff, DollarsBillable, DollarsBillableNew, DollarsNonBillableClient, DollarsNonBillableMarketingPR, DollarsNonBillableInternal, DollarsNonBillableTimeOff,	
		DollarsBilled, DollarsUnbilled,	DollarsWriteOff, AverageBillRate, BillablePercentOfHoursWorked)
	Select tUser.UserKey,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 from tUser (nolock) 
	Where CompanyKey = @CompanyKey

	-- Billable
	Update #csAmounts
		Set HoursBillable = ISNULL(TotalHours, 0),
		DollarsBillable = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		Where
			tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey and
			tProject.NonBillable = 0
			
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	Update #csAmounts
		Set HoursBillableNew = ISNULL(TotalHours, 0),
		DollarsBillableNew = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		Where
			tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey and
			tProject.NonBillable = 0
			
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- Non-Billable-Client
	Update #csAmounts
		Set HoursNonBillableClient = ISNULL(TotalHours, 0),
		DollarsNonBillableClient = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tFieldValue cf (nolock) ON tProject.CustomFieldKey = cf.ObjectFieldSetKey
				AND cf.FieldValue = 'Non-billable - Client'
		Where
			--tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey 
			--and
			--tProject.NonBillable = 0
					
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- Internal Marketing and PR
	Update #csAmounts
		Set HoursNonBillableMarketingPR = ISNULL(TotalHours, 0),
		DollarsNonBillableMarketingPR = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tFieldValue cf (nolock) ON tProject.CustomFieldKey = cf.ObjectFieldSetKey
				and cf.FieldValue = 'Non-billable - Marketing and PR'
		Where
			--tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey 
			--and
			--tProject.NonBillable = 0
			
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- Internal Non-Billable
	Update #csAmounts
		Set HoursNonBillableInternal = ISNULL(TotalHours, 0),
		DollarsNonBillableInternal = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tFieldValue cf (nolock) ON tProject.CustomFieldKey = cf.ObjectFieldSetKey
				AND cf.FieldValue = 'Non-billable - Internal'
		Where
			--tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey 
			--and
			--tProject.NonBillable = 0
			
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- Time Off Non-Billable
	Update #csAmounts
		Set HoursNonBillableTimeOff = ISNULL(TotalHours, 0),
		DollarsNonBillableTimeOff  = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tFieldValue cf (nolock) ON tProject.CustomFieldKey = cf.ObjectFieldSetKey
				AND cf.FieldValue = 'Non-billable - Time Off'
		Where
			--tTime.ActualRate > 0 and
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey 
			--and
			--tProject.NonBillable = 0
			
		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- UnBilled
	Update #csAmounts
		Set HoursUnbilled = ISNULL(TotalHours, 0),
		DollarsUnbilled = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		Where
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey and
			InvoiceLineKey is null and
			WriteOff = 0 and
			--tProject.NonBillable = 0 and
			tTime.ActualRate > 0

		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
		
	-- Billed
	Update #csAmounts
		Set HoursBilled = ISNULL(TotalHours, 0),
		DollarsBilled = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.BilledHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.BilledHours * tTime.BilledRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		Where
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey and
			InvoiceLineKey is not null and
			tProject.NonBillable = 0 and
			WriteOff = 0

		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey
		
	-- WriteOff
	Update #csAmounts
		Set HoursWriteOff = ISNULL(TotalHours, 0),
		DollarsWriteOff = ISNULL(TotalDollars, 0)
	From
		(Select UserKey, 
			ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours,
			ISNULL(Sum(
				ROUND(ROUND(tTime.ActualHours * tTime.ActualRate, 2) * tTime.ExchangeRate, 2)
				) , 0) as TotalDollars
		from tTime (nolock) 
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
		Where
			WorkDate >= @StartDate and 
			WorkDate <= @EndDate and 
			tProject.CompanyKey = @CompanyKey and
			tProject.NonBillable = 0 and
			WriteOff = 1 

		Group By UserKey) as TimeData
	Where
		#csAmounts.UserKey = TimeData.UserKey

	-- Totals
	Update #csAmounts
		Set HoursTotal = HoursBillableNew + HoursNonBillableClient + HoursNonBillableMarketingPR + HoursNonBillableInternal,
		HoursCharged = HoursBillableNew + HoursNonBillableClient + HoursNonBillableMarketingPR + HoursNonBillableInternal + HoursNonBillableTimeOff,
		AverageBillRate = CASE WHEN HoursBillableNew = 0 THEN 0 ELSE (DollarsBillable) / HoursBillableNew END,
		BillablePercentOfHoursWorked = CASE WHEN HoursBillableNew + HoursNonBillableClient + HoursNonBillableMarketingPR + HoursNonBillableInternal = 0 THEN 0 ELSE HoursBillableNew / (HoursBillableNew + HoursNonBillableClient + HoursNonBillableMarketingPR + HoursNonBillableInternal) END
	From #csAmounts
		
	if @AllDepartments = 1
		Select
			tCompany.CompanyKey,
			tCompany.CompanyName,
			ISNULL(tUser.DepartmentKey, 0) as DepartmentKey,
			ISNULL(tDepartment.DepartmentName, ' No Department') as DepartmentName,
			ISNULL(timeApprover.UserKey,0) as ManagerKey,
			CASE WHEN ISNULL(timeApprover.UserKey,0) = 0 THEN 'No Manager' ELSE timeApprover.FirstName + ' ' + timeApprover.LastName END as ManagerName,
			tUser.FirstName + ' ' + tUser.LastName as UserName,
			CASE WHEN ISNULL(cf.FieldValue,'') = '' THEN '0' ELSE CONVERT(NUMERIC(14,4), cf.FieldValue) * .01 END AS 'TargetBillablePercent',
			#csAmounts.BillablePercentOfHoursWorked,
			#csAmounts.HoursBillableNew AS BillableHours,
			#csAmounts.HoursNonBillableClient,
			#csAmounts.HoursNonBillableMarketingPR,
			#csAmounts.HoursNonBillableInternal,
			#csAmounts.HoursTotal,
			#csAmounts.HoursNonBillableTimeOff,
			#csAmounts.HoursCharged,
			--#csAmounts.DollarsBilled + #csAmounts.DollarsUnbilled AS BilledAndUnbilledRevenue,
			#csAmounts.DollarsBillable AS BilledAndUnbilledRevenue,
			#csAmounts.DollarsWriteOff,
			ISNULL(tUser.HourlyRate,0) AS TargetBillRate,
			#csAmounts.AverageBillRate
		From
			#csAmounts Inner join 
			tUser (nolock) on tUser.UserKey = #csAmounts.UserKey
			left outer join tCompany (nolock) on tUser.CompanyKey = tCompany.CompanyKey
			left outer join tDepartment (nolock) on tUser.DepartmentKey = tDepartment.DepartmentKey
			left outer join vCFValues cf (nolock) ON tUser.CustomFieldKey = cf.CustomFieldKey
				and cf.EntityKey = @CompanyKey AND cf.FieldName = 'BillUtil'
			left outer join tUser timeApprover (nolock) on tUser.TimeApprover = timeApprover.UserKey
		Where (@UserKey <= 0 OR tUser.UserKey = @UserKey)
			and (@TimeApproverKey <= 0 or tUser.TimeApprover = @TimeApproverKey)
			and (@IncludeInactiveEmployees = 1 or tUser.Active = 1) 
		Order By 
			DepartmentName, tUser.LastName
		
	else
	
		Select
		tCompany.CompanyKey,
		tCompany.CompanyName,
		ISNULL(tUser.DepartmentKey, 0) as DepartmentKey,
		ISNULL(tDepartment.DepartmentName, ' No Department') as DepartmentName,
		ISNULL(timeApprover.UserKey,0) as ManagerKey,
		CASE WHEN ISNULL(timeApprover.UserKey,0) = 0 THEN 'No Manager' ELSE timeApprover.FirstName + ' ' + timeApprover.LastName END as ManagerName,
		tUser.FirstName + ' ' + tUser.LastName as UserName,
		CASE WHEN ISNULL(cf.FieldValue,'') = '' THEN '0' ELSE CONVERT(NUMERIC(14,4), cf.FieldValue) * .01 END AS 'TargetBillablePercent',
		#csAmounts.BillablePercentOfHoursWorked,
		#csAmounts.HoursBillableNew AS BillableHours,
		#csAmounts.HoursNonBillableClient,
		#csAmounts.HoursNonBillableMarketingPR,
		#csAmounts.HoursNonBillableInternal,
		#csAmounts.HoursTotal,
		#csAmounts.HoursNonBillableTimeOff,
		#csAmounts.HoursCharged,
		--#csAmounts.DollarsBilled + #csAmounts.DollarsUnbilled AS BilledAndUnbilledRevenue,
		#csAmounts.DollarsBillable AS BilledAndUnbilledRevenue,
		#csAmounts.DollarsWriteOff,
		ISNULL(tUser.HourlyRate,0) AS TargetBillRate,
		#csAmounts.AverageBillRate
	From
		#csAmounts Inner join 
		tUser (nolock) on tUser.UserKey = #csAmounts.UserKey
		left outer join tCompany (nolock) on tUser.CompanyKey = tCompany.CompanyKey
		left outer join tDepartment (nolock) on tUser.DepartmentKey = tDepartment.DepartmentKey
		left outer join vCFValues cf (nolock) ON tUser.CustomFieldKey = cf.CustomFieldKey
			and cf.EntityKey = @CompanyKey AND cf.FieldName = 'BillUtil'
		left outer join tUser timeApprover (nolock) on tUser.TimeApprover = timeApprover.UserKey
		inner join #departments d on tUser.DepartmentKey = d.DepartmentKey 
	Where (@UserKey <= 0 OR tUser.UserKey = @UserKey)
		and (@TimeApproverKey <= 0 or tUser.TimeApprover = @TimeApproverKey)
		and (@IncludeInactiveEmployees = 1 or tUser.Active = 1) 
	Order By 
		DepartmentName, tUser.LastName
GO
