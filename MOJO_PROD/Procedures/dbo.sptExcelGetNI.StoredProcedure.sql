USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExcelGetNI]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExcelGetNI]
	(
		@CompanyKey int,
		@AsOfDate smalldatetime,
		@CompanyName varchar(100),
		@Office varchar(100),
		@Department varchar(100),
		@ClientID varchar(50),
		@ClassID varchar(50),
		@ProjectNumber varchar(50),
		@CashBasis tinyint
	)

AS --Encrypt

 /*
  || When     Who Rel   What
  || 9/24/10  RLB 10535 (78254) Added for Cash Basis
  */

Declare @ClassKey int, @OfficeKey int, @DepartmentKey int, @ClientKey int, @ProjectKey int, @GLCompanyKey int

Select @GLCompanyKey = ISNULL(Min(GLCompanyKey), 0) from tGLCompany (nolock) Where CompanyKey = @CompanyKey and GLCompanyName = @CompanyName
Select @OfficeKey = ISNULL(Min(OfficeKey), 0) from tOffice (nolock) Where CompanyKey = @CompanyKey and OfficeName = @Office
Select @DepartmentKey = ISNULL(Min(DepartmentKey), 0) from tDepartment (nolock) Where CompanyKey = @CompanyKey and DepartmentName = @Department
Select @ClassKey = ISNULL(Min(ClassKey), 0) from tClass (nolock) Where CompanyKey = @CompanyKey and ClassID = @ClassID
Select @ClientKey = CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and CustomerID = @ClientID
Select @ProjectKey = ProjectKey from tProject (NOLOCK) Where CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber


-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @YearStart smalldatetime
Declare @FirstMonth int
Declare @CurYear int
Declare @BalanceMonth int
Declare @FirstYear int

Select @FirstMonth = ISNULL(FirstMonth, 1) from tPreference (nolock) Where CompanyKey = @CompanyKey
Select @FirstYear = Year(@AsOfDate)
if @FirstMonth > Month(@AsOfDate)
	Select @FirstYear = @FirstYear - 1
	
Select @BeginningDate = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)

	
	
-- Calculate the Retained Earnings Amount

-- Move prior net income over to retained earnings
if @CashBasis = 1
	Select ISNULL(Sum(Credit - Debit), 0)  as NetIncome
	from tCashTransaction t (nolock) 
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where t.CompanyKey = @CompanyKey 
	and AccountType in (40, 41, 50, 51, 52) 
	and	TransactionDate >= @BeginningDate
	and TransactionDate <= @AsOfDate
	and (ISNULL(@ClassKey, 0) = 0 or t.ClassKey = @ClassKey)
	and (ISNULL(@OfficeKey, 0) = 0 or t.OfficeKey = @OfficeKey)
	and (ISNULL(@DepartmentKey, 0) = 0 or t.DepartmentKey = @DepartmentKey)
	and (ISNULL(@GLCompanyKey, 0) = 0 or t.GLCompanyKey = @GLCompanyKey)
	and (ISNULL(@ClientKey, 0) = 0 or t.ClientKey = @ClientKey)
	and (ISNULL(@ProjectKey, 0) = 0 or t.ProjectKey = @ProjectKey)

else

	Select ISNULL(Sum(Credit - Debit), 0)  as NetIncome
	from tTransaction t (nolock) 
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where t.CompanyKey = @CompanyKey 
	and AccountType in (40, 41, 50, 51, 52) 
	and	TransactionDate >= @BeginningDate
	and TransactionDate <= @AsOfDate
	and (ISNULL(@ClassKey, 0) = 0 or t.ClassKey = @ClassKey)
	and (ISNULL(@OfficeKey, 0) = 0 or t.OfficeKey = @OfficeKey)
	and (ISNULL(@DepartmentKey, 0) = 0 or t.DepartmentKey = @DepartmentKey)
	and (ISNULL(@GLCompanyKey, 0) = 0 or t.GLCompanyKey = @GLCompanyKey)
	and (ISNULL(@ClientKey, 0) = 0 or t.ClientKey = @ClientKey)
	and (ISNULL(@ProjectKey, 0) = 0 or t.ProjectKey = @ProjectKey)
GO
