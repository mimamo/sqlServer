USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExcelGetBalance]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptExcelGetBalance]
(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@AccountNumber varchar(100),
	@CompanyName varchar(100),
	@Office varchar(100),
	@Department varchar(100),
	@ClientID varchar(50),
	@ClassID varchar(50),
	@ProjectNumber varchar(50)
	
)

AS --Encrypt

/*
|| When      Who Rel     What
|| 12/18/07  GHL 8.5     Added alias to query for SQL 2005
*/

Declare @ClassKey int, @OfficeKey int, @DepartmentKey int, @ClientKey int, @ProjectKey int, @GLCompanyKey int
Declare @GLAccountKey int, @AccountType int
Declare @AccountName varchar(100)
Declare @BeginningDate smalldatetime
Declare @YearStart smalldatetime
Declare @FirstMonth int
Declare @CurYear int
Declare @BalanceMonth int
Declare @FirstYear int
Declare @ReturnAmount money

Select @FirstMonth = ISNULL(FirstMonth, 1) from tPreference (nolock) Where CompanyKey = @CompanyKey
Select @FirstYear = Year(@AsOfDate)
if @FirstMonth > Month(@AsOfDate)
	Select @FirstYear = @FirstYear - 1
	
Select @YearStart = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)

Select @GLAccountKey = GLAccountKey, @AccountType = AccountType from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountNumber = @AccountNumber
if @GLAccountKey is null
BEGIN
	Select 0 as ReturnAmount
	return -1
END

Select @GLCompanyKey = ISNULL(Min(GLCompanyKey), 0) from tGLCompany (nolock) Where CompanyKey = @CompanyKey and GLCompanyName = @CompanyName
Select @OfficeKey = ISNULL(Min(OfficeKey), 0) from tOffice (nolock) Where CompanyKey = @CompanyKey and OfficeName = @Office
Select @DepartmentKey = ISNULL(Min(DepartmentKey), 0) from tDepartment (nolock) Where CompanyKey = @CompanyKey and DepartmentName = @Department
Select @ClassKey = ISNULL(Min(ClassKey), 0) from tClass (nolock) Where CompanyKey = @CompanyKey and ClassID = @ClassID
Select @ClientKey = CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and CustomerID = @ClientID
Select @ProjectKey = ProjectKey from tProject (NOLOCK) Where CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber



Create table #GLTran
(
	CompanyKey int,
	GLAccountKey int,
	ClientKey int,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

Insert Into #GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
Select t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit From tTransaction t (nolock) 
Where t.CompanyKey = @CompanyKey
and (ISNULL(@ClassKey, 0) = 0 or t.ClassKey = @ClassKey)
and (ISNULL(@OfficeKey, 0) = 0 or t.OfficeKey = @OfficeKey)
and (ISNULL(@DepartmentKey, 0) = 0 or t.DepartmentKey = @DepartmentKey)
and (ISNULL(@GLCompanyKey, 0) = 0 or t.GLCompanyKey = @GLCompanyKey)
and (ISNULL(@ClientKey, 0) = 0 or t.ClientKey = @ClientKey)
and (ISNULL(@ProjectKey, 0) = 0 or t.ProjectKey = @ProjectKey)


if @AccountType in (10 , 11 , 12 , 13 , 14) -- Asset Accounts
		Select @ReturnAmount = SUM(Debit - Credit) from #GLTran (nolock)
			Where #GLTran.GLAccountKey = @GLAccountKey and TransactionDate <= @AsOfDate
	
if @AccountType in (20, 21, 22, 30) -- Liability and Equity Accounts
	Select @ReturnAmount = SUM(Credit - Debit) from #GLTran (nolock)
		Where #GLTran.GLAccountKey = @GLAccountKey and TransactionDate <= @AsOfDate

if @AccountType in (50, 51, 52) -- Expenses
	Select @ReturnAmount = SUM(Debit - Credit) from #GLTran (nolock)
		Where #GLTran.GLAccountKey = @GLAccountKey and TransactionDate <= @AsOfDate and TransactionDate >= @YearStart

if @AccountType = 31 -- Equity Closes
	Select @ReturnAmount = SUM(Credit - Debit) from #GLTran (nolock)
		Where #GLTran.GLAccountKey = @GLAccountKey and TransactionDate <= @AsOfDate and TransactionDate >= @YearStart

if @AccountType = 32 -- Retained Earnings
BEGIN
	Select @ReturnAmount = Sum(Credit - Debit) from #GLTran (nolock) 
		inner join tGLAccount (nolock) on #GLTran.GLAccountKey = #GLTran.GLAccountKey
		Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType in (31, 32, 40, 41, 50, 51, 52) 
			and #GLTran.TransactionDate < @YearStart
	Select @ReturnAmount = @ReturnAmount + Sum(Credit - Debit) from #GLTran (nolock) 
		inner join tGLAccount (nolock) on #GLTran.GLAccountKey = @GLAccountKey
		Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType = 32 
			and #GLTran.TransactionDate >= @YearStart and TransactionDate <= @AsOfDate
END
if @AccountType in (40, 41) -- Income Accounts
	Select @ReturnAmount = SUM(Credit - Debit) from #GLTran (nolock)
		Where #GLTran.GLAccountKey = @GLAccountKey and TransactionDate <= @AsOfDate and TransactionDate >= @YearStart

			
Select ISNULL(@ReturnAmount, 0) as ReturnAmount
GO
