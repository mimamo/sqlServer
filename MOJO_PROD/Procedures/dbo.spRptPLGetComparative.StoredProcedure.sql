USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPLGetComparative]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPLGetComparative]

	(
		@CompanyKey int,
		@StartDate1 smalldatetime,
		@EndDate1 smalldatetime,
		@StartDate2 smalldatetime,
		@EndDate2 smalldatetime,
		@NullClassKeyOnly int,		-- User requested explicitly Null Class only
		@ClassKeys varchar(8000),	-- Comma Delimited Keys
		@OfficeKey int,
		@DepartmentKey int,
		@ClientKey int,
		@ProjectKey int,
		@AllocateOverhead tinyint
	)

AS --Encrypt

Declare @TotOverhead money, @TotLaborCost money, @LaborCost money, @Perc decimal(24,4), @AllocOverhead money, @AllocPeriodAmt1 money, @AllocPeriodAmt2 money

Create table #GLTran
(
	CompanyKey int,
	GLAccountKey int,
	ClassKey int,
	ClientKey int,
	ProjectKey int null,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

IF ISNULL(@NullClassKeyOnly, 0) = 0
	IF ISNULL(@OfficeKey, 0) = 0
		IF ISNULL(@DepartmentKey, 0) = 0
			Insert Into #GLTran (CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
			Select CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
			Where CompanyKey = @CompanyKey
		ELSE
			Insert Into #GLTran (CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
			Select CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
			Where CompanyKey = @CompanyKey and ClassKey in (Select ClassKey from tClass (nolock) Where DepartmentKey = @DepartmentKey)
	ELSE
		IF ISNULL(@DepartmentKey, 0) = 0
			Insert Into #GLTran (CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
			Select CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
			Where CompanyKey = @CompanyKey and ClassKey in (Select ClassKey from tClass (nolock) Where OfficeKey = @OfficeKey)
		ELSE
			Insert Into #GLTran (CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
			Select CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
			Where CompanyKey = @CompanyKey and ClassKey in (Select ClassKey from tClass (nolock) Where DepartmentKey = @DepartmentKey and OfficeKey = @OfficeKey)

ELSE
	Insert Into #GLTran (CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select CompanyKey, ClassKey, ClientKey, ProjectKey, GLAccountKey, TransactionDate, Debit, Credit From tTransaction (nolock) 
	Where CompanyKey = @CompanyKey and ISNULL(ClassKey, 0) = 0

IF ISNULL(@NullClassKeyOnly, 0) = 0 AND LEN(@ClassKeys) > 0
BEGIN
	DECLARE @MyStatement VARCHAR(8000)
	SELECT  @MyStatement = 'Delete #GLTran Where ClassKey is null or ClassKey NOT IN ( '+ @ClassKeys + ')'
	
	EXEC (@MyStatement)
END


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
begin
	select @ClientKey = 0
	Delete #GLTran Where ProjectKey is null or ProjectKey <> @ProjectKey
end

if @ClientKey > 0
	Delete #GLTran Where ClientKey is null or ClientKey <> @ClientKey
	
if @AllocateOverhead = 1
	Select 
		GLAccountKey
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
			As Amount1
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
			As Amount2
		,Cast(0 as Money) as Amount1Rollup
		,Cast(0 as Money) as Amount2Rollup
	From
		tGLAccount gl (nolock)
	Where
		CompanyKey = @CompanyKey and
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
		,0
		,0

	Order By MajorGroup, MinorGroup, DisplayOrder

else

	Select 
		GLAccountKey
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
			As Amount1
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
			As Amount2
		,Cast(0 as Money) as Amount1Rollup
		,Cast(0 as Money) as Amount2Rollup
	From
		tGLAccount gl (nolock)
	Where
		CompanyKey = @CompanyKey and
		AccountType in (40, 41, 50, 51, 52)
	Order By MajorGroup, MinorGroup, DisplayOrder
GO
