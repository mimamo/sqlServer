USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphBillingEfficiencyWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphBillingEfficiencyWJ]

	(
		@CompanyKey int,
		@LaborBudgetKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime
	)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 02/07/08 QMD WMJ 1.0   Modified for initial Release of WMJ

  */

Declare @AvailableHours int, @TargetBillableHours int, @TotalBillable int, 
	@TotalBilled int, @i int, @BudgetMonth int,
	@BudgetHours int, @AvailHours int, @StartMonth int, @StartYear int, 
	@EndMonth int, @EndYear int, @MonthCount int,
	@FirstMonth int

Select @FirstMonth = ISNULL(FirstMonth, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey

Select @StartMonth = Month(@StartDate), 
	@StartYear = Year(@StartDate), 
	@EndMonth = Month(@EndMonth), 
	@EndYear = Year(@EndMonth)

Select @MonthCount = DateDiff(mm, @StartDate, @EndDate) + 1
Select @BudgetMonth = @StartMonth + @FirstMonth - 1, @i = 1
if @BudgetMonth > 12
	Select @BudgetMonth = @BudgetMonth - 12

if ISNULL(@LaborBudgetKey, 0) = 0
	Select @AvailableHours = 0, @TargetBillableHours = 0
else
BEGIN
	While 1=1
	BEGIN
		if @i > @MonthCount
			Break
			
		Select 
			@AvailHours = Case @BudgetMonth 
			When 1 then Sum(AvailableHours1) 
			When 2 then Sum(AvailableHours2) 
			When 3 then Sum(AvailableHours3) 
			When 4 then Sum(AvailableHours4) 
			When 5 then Sum(AvailableHours5)
			When 6 then Sum(AvailableHours6)
			When 7 then Sum(AvailableHours7)
			When 8 then Sum(AvailableHours8)
			When 9 then Sum(AvailableHours9)
			When 10 then Sum(AvailableHours10)
			When 11 then Sum(AvailableHours11)
			When 12 then Sum(AvailableHours12) END,
			@BudgetHours = Case @BudgetMonth 
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
			Where lb.LaborBudgetKey = @LaborBudgetKey
			
		Select @BudgetMonth = @BudgetMonth + 1, 
			@i = @i + 1,
			@AvailableHours = ISNULL(@AvailableHours, 0) + ISNULL(@AvailHours, 0), 
			@TargetBillableHours = ISNULL(@TargetBillableHours, 0) + ISNULL(@BudgetHours, 0)
		
		If @BudgetMonth > 12
			Select @BudgetMonth = 1
		
	END
		
END


-- Billable Hours
Select @TotalBillable = ISNULL(Sum(tTime.ActualHours) , 0)
from tTime (nolock) 
	inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
Where
	tTime.ActualRate > 0 and
	tProject.NonBillable = 0 and
	WorkDate >= @StartDate and 
	WorkDate <= @EndDate and 
	tTimeSheet.CompanyKey = @CompanyKey
			
Select @TotalBilled = ISNULL(Sum(BilledHours) , 0)
from tTime (nolock) 
	inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
Where
	tTime.InvoiceLineKey is not null and
	tTime.WriteOff = 0 and
	tProject.NonBillable = 0 and
	WorkDate >= @StartDate and 
	WorkDate <= @EndDate and 
	tTimeSheet.CompanyKey = @CompanyKey
			
			

SELECT	ISNULL(@AvailableHours, 0) AS [AvailableHours]
		,CASE 
			WHEN ISNULL(@AvailableHours, 0) - ISNULL(@TotalBillable, 0) < 0 THEN 0
			ELSE ISNULL(@AvailableHours, 0) - ISNULL(@TotalBillable, 0)
		 END AS NonBillable
		,ISNULL(@TotalBillable, 0) AS TotalHours
		,[Type] = 'Total Billable Hours'
		,[Description] = 'Billable'

UNION

SELECT	ISNULL(@AvailableHours, 0) AS [AvailableHours]
		,CASE 
			WHEN ISNULL(@AvailableHours, 0) - ISNULL(@TotalBilled, 0) < 0 THEN 0
			ELSE ISNULL(@AvailableHours, 0) - ISNULL(@TotalBilled, 0) 
		 END AS NonBillable
		,ISNULL(@TotalBilled, 0)  AS TotalHours
		,[Type] = 'Total Billed Hours'
		,[Description] = 'Billed'

UNION    

SELECT	ISNULL(@AvailableHours, 0) AS [AvailableHours]
		,CASE 
			WHEN ISNULL(@AvailableHours, 0) - ISNULL(@TargetBillableHours, 0) < 0 THEN 0
			ELSE ISNULL(@AvailableHours, 0) - ISNULL(@TargetBillableHours, 0) 
		 END AS NonBillable
		,ISNULL(@TargetBillableHours, 0) AS TotalHours
		,[Type] = 'Target Billable Hours'
		,[Description] = 'Plan'

ORDER BY [Description]
GO
