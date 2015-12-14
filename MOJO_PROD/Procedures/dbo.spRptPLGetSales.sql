USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPLGetSales]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPLGetSales]

	(
		@CompanyKey int,
		@StartDate1 smalldatetime,
		@EndDate1 smalldatetime,
		@StartDate2 smalldatetime,
		@EndDate2 smalldatetime,
		@GLBudgetKey int,
		@BudgetMonth int,
		@ClassKey int
	)

AS --Encrypt

Declare @MTDActualSales money, @YTDActualSales money, @MTDBudgetSales money, @YTDBudgetSales money
Declare @BudgetType int
Select @BudgetType = BudgetType from tGLBudget (nolock) Where GLBudgetKey = @GLBudgetKey

--Actual Month Sales
if ISNULL(@ClassKey, 0) = 0
	Select @MTDActualSales = ISNULL(Sum(Credit - Debit), 0)
	from tTransaction t (nolock) 
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.TransactionDate >= @StartDate1
		and		t.TransactionDate <= @EndDate1
		and		t.CompanyKey = @CompanyKey
		and		gl.AccountType = 40
else
	Select @MTDActualSales = ISNULL(Sum(Credit - Debit), 0)
	from tTransaction t (nolock) 
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.TransactionDate >= @StartDate1
		and		t.TransactionDate <= @EndDate1
		and		t.CompanyKey = @CompanyKey
		and		gl.AccountType = 40
		and		t.ClassKey = @ClassKey
		
--Actual Anual Sales
if ISNULL(@ClassKey, 0) = 0
	Select @YTDActualSales = ISNULL(Sum(Credit - Debit), 0)
	from tTransaction t (nolock) 
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.TransactionDate >= @StartDate2
		and		t.TransactionDate <= @EndDate2
		and		t.CompanyKey = @CompanyKey
		and		gl.AccountType = 40
else
	Select @YTDActualSales = ISNULL(Sum(Credit - Debit), 0)
	from tTransaction t (nolock) 
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		Where	t.TransactionDate >= @StartDate2
		and		t.TransactionDate <= @EndDate2
		and		t.CompanyKey = @CompanyKey
		and		gl.AccountType = 40
		and		t.ClassKey = @ClassKey
		
		
-- Month Budget Sales
if ISNULL(@GLBudgetKey, 0) > 0
BEGIN
	if ISNULL(@ClassKey, 0) = 0 OR @BudgetType = 1
	BEGIN
		if @BudgetMonth = 1
			Select @MTDBudgetSales = ISNULL(Sum(Month1), 0),
			@YTDBudgetSales = ISNULL(Sum(Month1), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 2
			Select @MTDBudgetSales = ISNULL(Sum(Month2), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 3
			Select @MTDBudgetSales = ISNULL(Sum(Month3), 0),
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 4
			Select @MTDBudgetSales = ISNULL(Sum(Month4), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 5
			Select @MTDBudgetSales = ISNULL(Sum(Month5), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 6
			Select @MTDBudgetSales = ISNULL(Sum(Month6), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 7
			Select @MTDBudgetSales = ISNULL(Sum(Month7), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 8
			Select @MTDBudgetSales = ISNULL(Sum(Month8), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 9
			Select @MTDBudgetSales = ISNULL(Sum(Month9), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 10
			Select @MTDBudgetSales = ISNULL(Sum(Month10), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 11
			Select @MTDBudgetSales = ISNULL(Sum(Month11), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40
		if @BudgetMonth = 12
			Select @MTDBudgetSales = ISNULL(Sum(Month12), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40

	END
	else
	BEGIN
		if @BudgetMonth = 1
			Select @MTDBudgetSales = ISNULL(Sum(Month1), 0),
			@YTDBudgetSales = ISNULL(Sum(Month1), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 2
			Select @MTDBudgetSales = ISNULL(Sum(Month2), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 3
			Select @MTDBudgetSales = ISNULL(Sum(Month3), 0),
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 4
			Select @MTDBudgetSales = ISNULL(Sum(Month4), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 5
			Select @MTDBudgetSales = ISNULL(Sum(Month5), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 6
			Select @MTDBudgetSales = ISNULL(Sum(Month6), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 7
			Select @MTDBudgetSales = ISNULL(Sum(Month7), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 8
			Select @MTDBudgetSales = ISNULL(Sum(Month8), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 9
			Select @MTDBudgetSales = ISNULL(Sum(Month9), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 10
			Select @MTDBudgetSales = ISNULL(Sum(Month10), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 11
			Select @MTDBudgetSales = ISNULL(Sum(Month11), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
		if @BudgetMonth = 12
			Select @MTDBudgetSales = ISNULL(Sum(Month12), 0) ,
			@YTDBudgetSales = ISNULL(Sum(Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12), 0) 
			from tGLBudgetDetail bd (nolock) inner join tGLAccount gl (nolock) on gl.GLAccountKey = bd.GLAccountKey
			Where bd.GLBudgetKey = @GLBudgetKey and gl.AccountType = 40 and bd.ClassKey = @ClassKey
	END
END
ELSE
BEGIN
	Select @MTDBudgetSales = 0, @YTDBudgetSales = 0
END
		
		
Select
	@MTDActualSales as MTDActualSales,
	@YTDActualSales as YTDActualSales,
	@MTDBudgetSales as MTDBudgetSales,
	@YTDBudgetSales as YTDBudgetSales
GO
