USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPLGetBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPLGetBudget]

	(
		@CompanyKey int,
		@StartDate1 smalldatetime,
		@EndDate1 smalldatetime,
		@StartDate2 smalldatetime,
		@EndDate2 smalldatetime,
		@GLBudgetKey int,
		@BudgetMonth int,
		@NullClassKeyOnly int,		-- User requested explicitly Null Class only
		@ClassKeys varchar(8000),	-- Comma Delimited Keys
		@OfficeKey int,
		@DepartmentKey int,
		@ClientKey int,
		@ProjectKey int,
		@AllocateOverhead tinyint
	)

AS --Encrypt


/*
In 82 we have ClientKey and ClassKey in tGLBudgetDetail
Users could potentially insert the following cases for the same budget

ClientKey	ClassKey	
--------------------
   0          0				All Clients, All Classes on UI
   0          X				All Clients, A Class
   X          0				A Client, All Classes
   X          X				A Client, A Class

i.e. there are risks of reporting over budgets

|| When     Who Rel   What
|| 03/26/10 RLB 10.520 (77088) updated for GLBudget having -1 for all

*/

Declare @BudgetType int
Select @BudgetType = BudgetType from tGLBudget (nolock) Where GLBudgetKey = @GLBudgetKey

Declare @TotOverhead money, @TotLaborCost money, @LaborCost money, @Perc decimal(24,4), @AllocOverhead money, @AllocPeriodAmt1 money, @AllocPeriodAmt2 money

If ISNULL(@ProjectKey, 0) > 0
	begin
		Select @ClientKey = ClientKey From tProject (nolock) Where ProjectKey = @ProjectKey
		Select @ClientKey = isnull(@ClientKey, 0)
	end
	
Create table #GLTran
(
	CompanyKey int,
	GLAccountKey int,
	ClientKey int,
	ProjectKey int null,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)
Create table #GLBudget
(
	GLAccountKey int,
	Month1 money,
	Month2 money,
	Month3 money,
	Month4 money,
	Month5 money,
	Month6 money,
	Month7 money,
	Month8 money,
	Month9 money,
	Month10 money,
	Month11 money,
	Month12 money,
	YearTotal money
)

Create table #tClass (ClassKey int null)

declare @KeyChar varchar(100)
declare @KeyInt int
declare @Pos int

IF LEN(@ClassKeys) > 0 
BEGIN
	-- Extract classes if any and store in temp table
	WHILE (1 = 1)
	BEGIN
		SELECT @Pos = CHARINDEX (',', @ClassKeys, 1) 
		IF @Pos = 0 
			SELECT @KeyChar = @ClassKeys
		ELSE
			SELECT @KeyChar = LEFT(@ClassKeys, @Pos -1)

		IF LEN(@KeyChar) > 0
		BEGIN
			SELECT @KeyInt = CONVERT(Int, @KeyChar)
			INSERT #tClass (ClassKey) SELECT @KeyInt 
		END

		IF @Pos = 0 
			BREAK
	
		SELECT @ClassKeys = SUBSTRING(@ClassKeys, @Pos + 1, LEN(@ClassKeys)) 
	END
END
ELSE
BEGIN
	-- No classes passed

	IF @OfficeKey = 0 AND @DepartmentKey = 0
	BEGIN
		-- If no classes passed, no office, no department 
		-- then we will capture tGLBudgetDetail.ClassKey = -1 (it is never null) 
		INSERT #tClass (ClassKey) VALUES (-1)

		-- And all the classes in company
		INSERT #tClass (ClassKey) 
		SELECT ClassKey
		FROM   tClass (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
	END
	ELSE
		-- Check for classes in office or department
		INSERT #tClass (ClassKey) 
		SELECT ClassKey 
		FROM   tClass (NOLOCK) 
		WHERE  CompanyKey = @CompanyKey
		AND    (@OfficeKey = 0 Or ISNULL(OfficeKey, 0) = @OfficeKey)
		AND    (@DepartmentKey = 0 Or ISNULL(DepartmentKey, 0) = @DepartmentKey)

END

Insert Into #GLBudget(GLAccountKey, Month1, Month2, Month3, Month4, Month5, Month6, Month7, Month8, Month9, Month10, Month11,  Month12)
Select GLAccountKey, Sum(Month1), Sum(Month2), Sum(Month3), Sum(Month4), Sum(Month5), Sum(Month6), Sum(Month7), Sum(Month8), Sum(Month9), Sum(Month10), Sum(Month11), Sum(Month12)
from   tGLBudgetDetail (nolock) Where GLBudgetKey = @GLBudgetKey
And    ClassKey In (Select ClassKey From #tClass)
And	   (ISNULL(@ClientKey, 0) = 0 Or ClientKey = @ClientKey)
Group By GLAccountKey
	
IF ISNULL(@NullClassKeyOnly, 0) = 0
	Insert Into #GLTran (CompanyKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select CompanyKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock)
	Where  CompanyKey = @CompanyKey
	And    ISNULL(ClassKey, -1) In (Select ClassKey From #tClass)						
ELSE
	-- Null Classes Only
	Insert Into #GLTran (CompanyKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select CompanyKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
	Where  CompanyKey = @CompanyKey and ISNULL(ClassKey, -1) = -1	


-- Calculate Overhead ******************************************************************
if @AllocateOverhead = 1
BEGIN
	
	-- Overhead for the period 1
	Select @TotOverhead = ISNULL(Sum(Debit - Credit), 0)
	from #GLTran 
	inner join tGLAccount gl (nolock) on #GLTran.GLAccountKey = gl.GLAccountKey
	Where gl.AccountType = 51 and ISNULL(#GLTran.ClientKey, 0) = 0 and TransactionDate >= @StartDate1 and TransactionDate <= @EndDate1
		
	Select @LaborCost = ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0)
	From tTime (nolock)
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		left outer join tProject on tTime.ProjectKey = tProject.ProjectKey
	Where
		(ISNULL(@ProjectKey, 0) = 0 or tTime.ProjectKey = @ProjectKey) and
		(ISNULL(@ClientKey, 0) = 0 or tProject.ClientKey = @ClientKey) and
		(ISNULL(@DepartmentKey, 0) = 0 or tUser.DepartmentKey = @DepartmentKey) and
		(ISNULL(@OfficeKey, 0) = 0 or tUser.OfficeKey = @OfficeKey) and
		tTime.WorkDate >= @StartDate1 and tTime.WorkDate <= @EndDate1 and
		tTimeSheet.CompanyKey = @CompanyKey

	Select @TotLaborCost = ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0)
	From tTime (nolock)
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		left outer join tProject on tTime.ProjectKey = tProject.ProjectKey
	Where
		tTime.WorkDate >= @StartDate1 and tTime.WorkDate <= @EndDate1 and
		tTimeSheet.CompanyKey = @CompanyKey
		
	if ISNULL(@TotLaborCost, 0) = 0
		Select @Perc = 0
	else
		Select @Perc = ISNULL(@LaborCost, 0) / ISNULL(@TotLaborCost, 0)
		
	Select @AllocPeriodAmt1 = ISNULL(@TotOverhead, 0) * @Perc
	
	--select @LaborCost, @TotLaborCost, @Perc, @TotOverhead

	-- Overhead for the period
	Select @TotOverhead = ISNULL(Sum(Debit - Credit), 0)
	from #GLTran 
	inner join tGLAccount gl (nolock) on #GLTran.GLAccountKey = gl.GLAccountKey
	Where gl.AccountType = 51 and ISNULL(ClientKey, 0) = 0 and TransactionDate >= @StartDate2 and TransactionDate <= @EndDate2
		
	Select @LaborCost = ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0)
	From tTime (nolock)
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		left outer join tProject on tTime.ProjectKey = tProject.ProjectKey
	Where
		(ISNULL(@ProjectKey, 0) = 0 or tTime.ProjectKey = @ProjectKey) and
		(ISNULL(@ClientKey, 0) = 0 or tProject.ClientKey = @ClientKey) and
		(ISNULL(@DepartmentKey, 0) = 0 or tUser.DepartmentKey = @DepartmentKey) and
		(ISNULL(@OfficeKey, 0) = 0 or tUser.OfficeKey = @OfficeKey) and
		tTime.WorkDate >= @StartDate2 and tTime.WorkDate <= @EndDate2 and
		tTimeSheet.CompanyKey = @CompanyKey

	Select @TotLaborCost = ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0)
	From tTime (nolock)
		inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		left outer join tProject on tTime.ProjectKey = tProject.ProjectKey
	Where
		tTime.WorkDate >= @StartDate2 and tTime.WorkDate <= @EndDate2 and
		tTimeSheet.CompanyKey = @CompanyKey
		
	if ISNULL(@TotLaborCost, 0) = 0
		Select @Perc = 0
	else
		Select @Perc = ISNULL(@LaborCost, 0) / ISNULL(@TotLaborCost, 0)
	
	Select @AllocPeriodAmt2 = ISNULL(@TotOverhead, 0) * @Perc
END
-- End Calculate Overhead ******************************************************************

				
if @ProjectKey > 0
	Delete #GLTran Where ProjectKey is null or ProjectKey <> @ProjectKey 
else
	if @ClientKey > 0
		Delete #GLTran Where ClientKey is null or ClientKey <> @ClientKey

if @AllocateOverhead = 1
	Select 
		gl.GLAccountKey
		,AccountNumber
		,AccountName
		,AccountType
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 1
			When AccountType = 51 then 2
			When AccountType = 41 then 3
			When AccountType = 52 then 3 end as MajorGroup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 2
			When AccountType = 51 then 3
			When AccountType = 41 then 4
			When AccountType = 52 then 5 end as MinorGroup
		
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate1
				and		TransactionDate <= @EndDate1)
			else
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate1
				and		TransactionDate <= @EndDate1) end , 0)
			As MonthAmount
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate2
				and		TransactionDate <= @EndDate2)
			else
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate2
				and		TransactionDate <= @EndDate2) end , 0)
			As YearAmount
		,Month1	,Month2	,Month3	,Month4	,Month5	,Month6	,Month7	,Month8	,Month9	,Month10 ,Month11 ,Month12
		,Case @BudgetMonth
			When 1 then ISNULL(bd.Month1, 0)
			When 2 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0)
			When 3 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0)
			When 4 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0)
			When 5 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
			When 6 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0)
			When 7 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0)
			When 8 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0)
			When 9 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0)
			When 10 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
			When 11 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0)
			When 12 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
			end as Month0
	From
		tGLAccount gl (nolock)
		left outer join 
			#GLBudget bd on gl.GLAccountKey = bd.GLAccountKey
	Where
		gl.CompanyKey = @CompanyKey and
		AccountType in (40, 41, 50, 51, 52)
	
	UNION ALL
	
	Select
		-1
		,''
		,'Allocated Overhead'
		,52
		,0
		,99999999999999
		,0
		,0
		,3 
		,5
		,@AllocPeriodAmt1
		,@AllocPeriodAmt2
		,0,0,0,0,0,0,0,0,0,0,0,0
		,0
		
	Order By MajorGroup, MinorGroup, DisplayOrder

else

	Select 
		gl.GLAccountKey
		,AccountNumber
		,AccountName
		,AccountType
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 1
			When AccountType = 51 then 2
			When AccountType = 41 then 3
			When AccountType = 52 then 3 end as MajorGroup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 2
			When AccountType = 51 then 3
			When AccountType = 41 then 4
			When AccountType = 52 then 5 end as MinorGroup
		
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate1
				and		TransactionDate <= @EndDate1)
			else
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate1
				and		TransactionDate <= @EndDate1) end , 0)
			As MonthAmount
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate2
				and		TransactionDate <= @EndDate2)
			else
				(Select Sum(Debit - Credit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate2
				and		TransactionDate <= @EndDate2) end , 0)
			As YearAmount
		,Month1	,Month2	,Month3	,Month4	,Month5	,Month6	,Month7	,Month8	,Month9	,Month10 ,Month11 ,Month12
		,Case @BudgetMonth
			When 1 then ISNULL(bd.Month1, 0)
			When 2 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0)
			When 3 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0)
			When 4 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0)
			When 5 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
			When 6 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0)
			When 7 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0)
			When 8 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0)
			When 9 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0)
			When 10 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
			When 11 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0)
			When 12 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
			end as Month0
	From
		tGLAccount gl (nolock)
		left outer join 
			#GLBudget bd on gl.GLAccountKey = bd.GLAccountKey
	Where
		gl.CompanyKey = @CompanyKey and
		AccountType in (40, 41, 50, 51, 52)
	Order By MajorGroup, MinorGroup, DisplayOrder
GO
