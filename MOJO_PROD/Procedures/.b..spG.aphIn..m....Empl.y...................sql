USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphIncomePerEmployee]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphIncomePerEmployee]
(
	@CompanyKey int,
	@LaborBudgetKey int,
	@FullTimeHours int
)

As --Encrypt

 /*
  || When     Who Rel       What
  || 05/20/09 RLB 10.0.2.6  Labor is only pulling from billable projects now.

  */


Create Table #IncMonths
 (
	MonthNum int,
	YearNum int,
	EmployeeCount decimal(9,3),
	LaborIncome money,
	ExpenseIncome money )

Create Table #UserTime
 (
	UserKey int,
	Hours decimal (9,3),
	Percentage decimal(9,3)
 )

Declare @StartMonth int, @StartYear int, @i int, @EmployeeCount decimal(9,3), @LaborIncome money, @ExpenseIncome money
Declare @FullTimeMonth int, @FirstMonth int, @BudgetMonth int

Select @StartMonth = Month(GETDATE())
Select @StartYear = Year(GETDATE())
Select @i = 1, @FullTimeMonth = @FullTimeHours / 12
Select @FirstMonth = ISNULL(FirstMonth, 1) from tPreference (nolock) Where CompanyKey = @CompanyKey

While @i <= 6
BEGIN

	Delete #UserTime

	-- If there is no labor budget supplied (=0) then get it based on time sheets
	if @LaborBudgetKey = 0
	BEGIN
		Insert Into #UserTime (UserKey, Hours)
		Select tTime.UserKey, Sum(ActualHours)
		from tTimeSheet (nolock) inner join tTime (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		Where Month(tTimeSheet.StartDate) = @StartMonth 
			and Year(tTimeSheet.StartDate) = @StartYear 
			and tTimeSheet.CompanyKey = @CompanyKey
		Group By tTime.UserKey
	END
	ELSE
	BEGIN
		Select @BudgetMonth = @StartMonth + @FirstMonth - 1 + @i
		if @BudgetMonth > 12
			Select @BudgetMonth = @BudgetMonth - 12
			
		Insert Into #UserTime (UserKey, Hours)
		Select UserKey,
			Case @BudgetMonth 
			When 1 then AvailableHours1 
			When 2 then AvailableHours2 
			When 3 then AvailableHours3 
			When 4 then AvailableHours4 
			When 5 then AvailableHours5
			When 6 then AvailableHours6
			When 7 then AvailableHours7
			When 8 then AvailableHours8
			When 9 then AvailableHours9
			When 10 then AvailableHours10
			When 11 then AvailableHours11
			When 12 then AvailableHours12 END
		From tLaborBudgetDetail (nolock)
		Where LaborBudgetKey = @LaborBudgetKey
		
	END
	
	Update #UserTime 
	Set Percentage = 1
	Where Hours > @FullTimeMonth

	Update #UserTime
	Set Percentage = ISNULL(Hours, 0) / @FullTimeMonth
	Where Percentage is null

	Select @EmployeeCount = Sum(Percentage) 
	from #UserTime 
		
	Select @LaborIncome = Sum(ROUND(ISNULL(BilledHours * BilledRate, ActualHours * ActualRate), 2) ) 
	from tTime (nolock) inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
	Where
	Month(WorkDate) = @StartMonth and Year(WorkDate) = @StartYear and tTimeSheet.CompanyKey = @CompanyKey and tProject.NonBillable = 0

	Select @ExpenseIncome = Sum(BillableCost - TotalCost) 
	from tVoucherDetail vd (nolock) inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	Where v.CompanyKey = @CompanyKey and
	Month(v.InvoiceDate) = @StartMonth and
	Year(v.InvoiceDate) = @StartYear and
	ISNULL(vd.ProjectKey, 0) > 0

	Select @ExpenseIncome = ISNULL(@ExpenseIncome, 0) + Sum(BillableCost - TotalCost) 
	from tMiscCost mc (nolock) inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	Where p.CompanyKey = @CompanyKey and
	Month(mc.ExpenseDate) = @StartMonth and
	Year(mc.ExpenseDate) = @StartYear

	Select @ExpenseIncome = ISNULL(@ExpenseIncome, 0) + Sum(BillableCost - ActualCost) 
	from tExpenseReceipt er (nolock) inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	Where ee.CompanyKey = @CompanyKey and
	Month(er.ExpenseDate) = @StartMonth and
	Year(er.ExpenseDate) = @StartYear

	Insert #IncMonths (MonthNum, YearNum, EmployeeCount, LaborIncome, ExpenseIncome)
	Values (@StartMonth, @StartYear, @EmployeeCount, @LaborIncome, @ExpenseIncome)
	
	if @StartMonth = 1
		Select @StartMonth = 12, @StartYear = @StartYear - 1
	else
		Select @StartMonth = @StartMonth - 1

	Select @i = @i + 1
END


Select * from #IncMonths Order By YearNum, MonthNum
GO
