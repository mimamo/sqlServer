USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphIncomePerEmployeeWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphIncomePerEmployeeWJ]
(
	@CompanyKey int,
	@LaborBudgetKey int,
	@FullTimeHours int,
	@GLCompanyKey int = null,
	@UserKey int = null
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 01/16/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 05/20/09 RLB 10.0.2.6  Labor is only pulling from billable projects now.
  || 03/02/12 GHL 10.5.5.4  (136419) Instead of calculating 
  ||                         AGI or Revenue = LaborIncome + ExpenseIncome (Gross - Net)
  ||                         now AGI = Income - COGS 
  || 07/27/12 RLB 10.5.5.8  Added Restrict  GL Company changes for HMI
  || 08/07/12 RLB 10.5.5.8  Added GLCompany option
  */

  
 Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


Create Table #IncMonths
 (
	MonthNum int
	,YearNum int
	,EmployeeCount decimal(9,3)

	,LaborIncome money
	,ExpenseIncome money
	
	,Income money
	,COGS money
	)

Create Table #UserTime
 (
	UserKey int,
	Hours decimal (9,3),
	Percentage decimal(9,3)
 )

Declare @StartMonth int, @StartYear int, @i int, @EmployeeCount decimal(9,3)
Declare @LaborIncome money, @ExpenseIncome money
Declare @Income money, @COGS money
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
		from tTimeSheet (nolock) 
		inner join tTime (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		inner join tUser (nolock) on tTimeSheet.UserKey = tUser.UserKey
		Where Month(tTimeSheet.StartDate) = @StartMonth 
			and Year(tTimeSheet.StartDate) = @StartYear 
			and tTimeSheet.CompanyKey = @CompanyKey
			and (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
			and (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 Or (tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))))
		Group By tTime.UserKey
	END
	ELSE
	BEGIN
		Select @BudgetMonth = @StartMonth + @FirstMonth - 1 + @i
		if @BudgetMonth > 12
			Select @BudgetMonth = @BudgetMonth - 12
			
		Insert Into #UserTime (UserKey, Hours)
		Select tLaborBudgetDetail.UserKey,
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
		inner join tUser (nolock) on tLaborBudgetDetail.UserKey = tUser.UserKey
		Where LaborBudgetKey = @LaborBudgetKey
		and (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))
		
	END
	
	Update #UserTime 
	Set Percentage = 1
	Where Hours > @FullTimeMonth

	Update #UserTime
	Set Percentage = ISNULL(Hours, 0) / @FullTimeMonth
	Where Percentage is null

	Select @EmployeeCount = Sum(Percentage) 
	from #UserTime 
		
	-- Now calculate revenue

	/* 
	--Old way to calculate

	Select @LaborIncome = Sum(ROUND(ISNULL(BilledHours * BilledRate, ActualHours * ActualRate), 2) ) 
	from tTime (nolock) inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
	Where
	Month(WorkDate) = @StartMonth and Year(WorkDate) = @StartYear 
	and tTimeSheet.CompanyKey = @CompanyKey and tProject.NonBillable = 0
	
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
	
	*/

	-- New way to calculate

	select @Income = isnull(sum(Credit - Debit),0)
      from tTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
     where t.CompanyKey = @CompanyKey
       and g.AccountType = 40  -- Income Accounts
       and Month(TransactionDate) = @StartMonth 
       and Year(TransactionDate) = @StartYear
	   and (@GLCompanyKey IS NULL OR t.GLCompanyKey = @GLCompanyKey)
	   and (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 or (t.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))))

	select @COGS = isnull(sum(Debit - Credit),0)
      from tTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
     where t.CompanyKey = @CompanyKey
       and g.AccountType = 50  -- Cost Of Goods Sold Accounts
       and Month(TransactionDate) = @StartMonth 
       and Year(TransactionDate) = @StartYear
	   and (@GLCompanyKey IS NULL OR t.GLCompanyKey = @GLCompanyKey)
       and (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 or (t.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))))

	Insert #IncMonths (MonthNum, YearNum, EmployeeCount, LaborIncome, ExpenseIncome, Income, COGS)
	Values (@StartMonth, @StartYear, @EmployeeCount, @LaborIncome, @ExpenseIncome, @Income, @COGS)
	
	if @StartMonth = 1
		Select @StartMonth = 12, @StartYear = @StartYear - 1
	else
		Select @StartMonth = @StartMonth - 1

	Select @i = @i + 1
END

Select	*, case ISNULL(EmployeeCount,0)
			when 0 Then 0
			--else (ISNULL(LaborIncome,0) + ISNULL(ExpenseIncome,0)) / ISNULL(EmployeeCount,1)
			else (ISNULL(Income,0) - ISNULL(COGS,0)) / ISNULL(EmployeeCount,1)
		end as Revenue
from	#IncMonths 
Order By YearNum, MonthNum
GO
