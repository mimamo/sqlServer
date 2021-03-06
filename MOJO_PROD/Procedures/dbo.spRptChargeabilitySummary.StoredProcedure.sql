USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptChargeabilitySummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptChargeabilitySummary]

	(
		@CompanyKey int,
		@ClientKey int,
		@ClientDivisionKey int,
		@ClientProductKey int,		
		@LaborBudgetKey int,
		@Year int,
		@Month int,
		@NumberOfMonths int,
		@IncludeNonBillable tinyint,
		@ActiveOnly tinyint
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/12/07  CRG 8.4.3.8 (14463) Fixed StartDate when user selects "All Year"
|| 06/19/09  RLB 10.5.0.0 In the billable portion i removed the first non billable where clause because it is being pasted in later in the where clause.
|| 06/22/09  RLB 10.5.0.0 (55241) the report handles decimals so i changed the temp table variable from int to float since it was cutting off the decimals.
|| 07/20/09	 GWG 10.5.0.4 Modified the Non billable restrict clauses to make more sense on the report. basically include non billable is only in effect on the total hours.
							all other columns respect the normal non billable settings or not at all.
|| 02/04/09  GWG 10.5.1.7 Modified the billable and write off sections to only include billable projects.
|| 07/18/13  RLB 10.5.7.0 (179300) Adding Number of months Option
|| 01/22/14  GHL 10.5.7.6 Converted to home currency
*/

Declare @StartMonth int, @StartYear int, @FirstMonth int, @i int, @BudgetMonth int, @StartDate smalldatetime, @EndDate smalldatetime

Create Table #csAmounts (
	UserKey int,
	HoursPlanAvailable decimal(24,4),
	HoursPlanBillable decimal(24,4),
	DollarsPlanBillable money,
	HoursBillable decimal(24,4),
	HoursTotal decimal(24,4),
	HoursBilled decimal(24,4),
	HoursUnbilled decimal(24,4),
	HoursWriteOff decimal(24,4),
	DollarsBillable money,
	DollarsBilled money,
	DollarsUnbilled money,
	DollarsWriteOff money
)

-- Will simplify queries below
Select @ClientKey = isnull(@ClientKey, 0)
	   ,@ClientDivisionKey = isnull(@ClientDivisionKey, 0)
	   ,@ClientProductKey = isnull(@ClientProductKey, 0)

Select @FirstMonth = ISNULL(FirstMonth, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey

Insert into #csAmounts (UserKey, HoursPlanAvailable, HoursPlanBillable,	DollarsPlanBillable, HoursBillable, HoursTotal,	HoursBilled, HoursUnbilled,	HoursWriteOff, DollarsBillable,	DollarsBilled, DollarsUnbilled,	DollarsWriteOff)
Select tUser.UserKey,0,0,0,0,0,0,0,0,0,0,0,0 from tUser (nolock) 
Where CompanyKey = @CompanyKey

-- Get the plan amounts
Create Table #csLaborBudget 
	(
		UserKey int,
		AvailableHours1 int,
		TargetHours1 int,
		TargetDollars1 money,
		AvailableHours2 int,
		TargetHours2 int,
		TargetDollars2 money,
		AvailableHours3 int,
		TargetHours3 int,
		TargetDollars3 money,
		AvailableHours4 int,
		TargetHours4 int,
		TargetDollars4 money,
		AvailableHours5 int,
		TargetHours5 int,
		TargetDollars5 money,
		AvailableHours6 int,
		TargetHours6 int,
		TargetDollars6 money,
		AvailableHours7 int,
		TargetHours7 int,
		TargetDollars7 money,
		AvailableHours8 int,
		TargetHours8 int,
		TargetDollars8 money,
		AvailableHours9 int,
		TargetHours9 int,
		TargetDollars9 money,
		AvailableHours10 int,
		TargetHours10 int,
		TargetDollars10 money,
		AvailableHours11 int,
		TargetHours11 int,
		TargetDollars11 money,
		AvailableHours12 int,
		TargetHours12 int,
		TargetDollars12 money,
		TotalAvailableHours int,
		TotalTargetHours int,
		TotalTargetDollars money
	)
Insert into #csLaborBudget 
	(
		UserKey,
		AvailableHours1,
		TargetHours1,
		TargetDollars1,
		AvailableHours2,
		TargetHours2,
		TargetDollars2,
		AvailableHours3,
		TargetHours3,
		TargetDollars3,
		AvailableHours4,
		TargetHours4,
		TargetDollars4,
		AvailableHours5,
		TargetHours5,
		TargetDollars5,
		AvailableHours6,
		TargetHours6,
		TargetDollars6,
		AvailableHours7,
		TargetHours7,
		TargetDollars7,
		AvailableHours8,
		TargetHours8,
		TargetDollars8,
		AvailableHours9,
		TargetHours9,
		TargetDollars9,
		AvailableHours10,
		TargetHours10,
		TargetDollars10,
		AvailableHours11,
		TargetHours11,
		TargetDollars11,
		AvailableHours12,
		TargetHours12,
		TargetDollars12,
		TotalAvailableHours,
		TotalTargetHours,
		TotalTargetDollars	
	)
Select UserKey,
		AvailableHours1,
		TargetHours1,
		TargetDollars1,
		AvailableHours2,
		TargetHours2,
		TargetDollars2,
		AvailableHours3,
		TargetHours3,
		TargetDollars3,
		AvailableHours4,
		TargetHours4,
		TargetDollars4,
		AvailableHours5,
		TargetHours5,
		TargetDollars5,
		AvailableHours6,
		TargetHours6,
		TargetDollars6,
		AvailableHours7,
		TargetHours7,
		TargetDollars7,
		AvailableHours8,
		TargetHours8,
		TargetDollars8,
		AvailableHours9,
		TargetHours9,
		TargetDollars9,
		AvailableHours10,
		TargetHours10,
		TargetDollars10,
		AvailableHours11,
		TargetHours11,
		TargetDollars11,
		AvailableHours12,
		TargetHours12,
		TargetDollars12,
		0,
		0,
		0 
	from tLaborBudgetDetail (nolock) where LaborBudgetKey = @LaborBudgetKey

Select @BudgetMonth = ISNULL(@Month, 1) - @FirstMonth + 1
if @BudgetMonth <= 0
	Select @BudgetMonth = @BudgetMonth + 12

-- used to get selected labor budget months
Declare @MonthStartCount int, @MonthCount int
Select @MonthStartCount = 1, @MonthCount = @NumberOfMonths 
	
Select @StartDate = Cast(Cast(@Month as varchar) + '/1/' + Cast(@Year as varchar) as smalldatetime)
Select @EndDate = DateAdd(d, -1, DateAdd(mm, @NumberOfMonths, @StartDate))


while (1=1)
	BEGIN
		if @MonthStartCount > @MonthCount
			BREAK
		
		if @BudgetMonth = 1
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours1, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours1, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars1, 0)
		END 
		if @BudgetMonth = 2
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) +ISNULL( AvailableHours2, 0) 
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours2, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars2, 0) 
		END
		if @BudgetMonth = 3
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours3, 0) 
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours3, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars3, 0) 
		END
		if @BudgetMonth = 4
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours4, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours4, 0)
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars4, 0) 
		END 
		if @BudgetMonth = 5
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours5, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours5, 0) 
			update #csLaborBudget set TotalTargetDollars =ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars5, 0)
		END 
		if @BudgetMonth = 6
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours6, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours6, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars6, 0)  
		END
		if @BudgetMonth = 7
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours7, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours7, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars7, 0) 
		END 
		if @BudgetMonth = 8
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours8, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours8, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars8, 0)
		END 
		if @BudgetMonth = 9
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours9, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours9, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars9, 0) 
		END 
		if @BudgetMonth = 10
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours10, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours10, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars10, 0)
		END  
		if @BudgetMonth = 11
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours11, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours11, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars11, 0)
		END  
		if @BudgetMonth = 12
		BEGIN
			update #csLaborBudget set TotalAvailableHours = ISNULL(TotalAvailableHours, 0) + ISNULL(AvailableHours12, 0)
			update #csLaborBudget set TotalTargetHours = ISNULL(TotalTargetHours, 0) + ISNULL(TargetHours12, 0) 
			update #csLaborBudget set TotalTargetDollars = ISNULL(TotalTargetDollars, 0) + ISNULL(TargetDollars12, 0)
		END  
		
		select @MonthStartCount = @MonthStartCount + 1
		select @BudgetMonth = @BudgetMonth + 1

		if @BudgetMonth > 12
			select @BudgetMonth = 1

	END

Update #csAmounts
SET HoursPlanAvailable = TotalAvailableHours,
	HoursPlanBillable = TotalTargetHours,
	DollarsPlanBillable = TotalTargetDollars
from #csLaborBudget
WHERE #csLaborBudget.UserKey =  #csAmounts.UserKey


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
		and (@ClientDivisionKey = 0 Or isnull(tProject.ClientDivisionKey, 0) = @ClientDivisionKey )
		and (@ClientProductKey = 0 Or isnull(tProject.ClientProductKey, 0) = @ClientProductKey )
		and (@ClientKey = 0 Or (
						isnull(tProject.ClientKey, 0) = @ClientKey Or isnull(tProject.ClientKey, 0) in
						(Select CompanyKey From tCompany (nolock) Where ParentCompanyKey = @ClientKey)
			))
		
	Group By UserKey) as TimeData
Where
	#csAmounts.UserKey = TimeData.UserKey
		
-- Total
Update #csAmounts
	Set HoursTotal = ISNULL(TotalHours, 0)
From
	(Select tTime.UserKey, 
		ISNULL(Sum(tTime.ActualHours) , 0) as TotalHours
	from tTime (nolock) 
		inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
	Where
		WorkDate >= @StartDate and 
		WorkDate <= @EndDate and 
		tTimeSheet.CompanyKey = @CompanyKey 
		and tProject.NonBillable <= @IncludeNonBillable
		and (@ClientDivisionKey = 0 Or isnull(tProject.ClientDivisionKey, 0) = @ClientDivisionKey )
		and (@ClientProductKey = 0 Or isnull(tProject.ClientProductKey, 0) = @ClientProductKey )
		and (@ClientKey = 0 Or (
						isnull(tProject.ClientKey, 0) = @ClientKey Or isnull(tProject.ClientKey, 0) in
						(Select CompanyKey From tCompany (nolock) Where ParentCompanyKey = @ClientKey)
			))

	Group By tTime.UserKey) as TimeData
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
		tProject.NonBillable = 0 and
		tTime.ActualRate > 0
		and (@ClientDivisionKey = 0 Or isnull(tProject.ClientDivisionKey, 0) = @ClientDivisionKey )
		and (@ClientProductKey = 0 Or isnull(tProject.ClientProductKey, 0) = @ClientProductKey )
		and (@ClientKey = 0 Or (
						isnull(tProject.ClientKey, 0) = @ClientKey Or isnull(tProject.ClientKey, 0) in
						(Select CompanyKey From tCompany (nolock) Where ParentCompanyKey = @ClientKey)
			))
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
		and (@ClientDivisionKey = 0 Or isnull(tProject.ClientDivisionKey, 0) = @ClientDivisionKey )
		and (@ClientProductKey = 0 Or isnull(tProject.ClientProductKey, 0) = @ClientProductKey )
		and (@ClientKey = 0 Or (
						isnull(tProject.ClientKey, 0) = @ClientKey Or isnull(tProject.ClientKey, 0) in
						(Select CompanyKey From tCompany (nolock) Where ParentCompanyKey = @ClientKey)
			))
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
		and (@ClientDivisionKey = 0 Or isnull(tProject.ClientDivisionKey, 0) = @ClientDivisionKey )
		and (@ClientProductKey = 0 Or isnull(tProject.ClientProductKey, 0) = @ClientProductKey )
		and (@ClientKey = 0 Or (
						isnull(tProject.ClientKey, 0) = @ClientKey Or isnull(tProject.ClientKey, 0) in
						(Select CompanyKey From tCompany (nolock) Where ParentCompanyKey = @ClientKey)
			))
	Group By UserKey) as TimeData
Where
	#csAmounts.UserKey = TimeData.UserKey

if 	@ActiveOnly = 1
	DELETE from #csAmounts where #csAmounts.HoursTotal = 0
	
Select
	#csAmounts.*,
	ISNULL(tUser.OfficeKey, 0) as OfficeKey,
	ISNULL(tUser.DepartmentKey, 0) as DepartmentKey,
	ISNULL(tOffice.OfficeName, ' No Office') as OfficeName,
	ISNULL(tDepartment.DepartmentName, ' No Department') as DepartmentName,
	tUser.FirstName + ' ' + tUser.LastName as UserName,
	tUser.HourlyRate,
	tUser.HourlyCost,
	HoursPlanBillable - HoursBillable as CHVariance
From
	#csAmounts
	Inner join tUser (nolock) on tUser.UserKey = #csAmounts.UserKey
	left outer join tOffice (nolock) on tUser.OfficeKey = tOffice.OfficeKey
	left outer join tDepartment (nolock) on tUser.DepartmentKey = tDepartment.DepartmentKey
Order By 
	OfficeName, DepartmentName, tUser.LastName
GO
