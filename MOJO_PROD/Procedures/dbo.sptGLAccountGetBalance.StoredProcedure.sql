USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetBalance]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetBalance]

	(
		@CompanyKey int,
		@GLAccountType smallint = NULL,
		@GLCompanyKey int = NULL,
		@UserKey int = NULL
	)

AS --Encrypt

/*
|| When      Who Rel		What
|| 10/02/12  KMC 10.5.6.0	(134065) Created stored procedure to retrieve the balance for a specific GL Account Type
||                          for a specific company.
|| 10/26/12  KMC 10.5.6.1   (157551) Added additional else for viewing ALL balancesif there are no GL restrictions, and
||                          made sure the GL restrictions were being check in proper spots.
|| 11/05/12  GWG 10.5.6.1   Fixed getting balances on the right side and sorting and grouping and restrict to today or earlier
|| 05/22/13  KMC 10.5.6.8   (179091) Added Active = 1 to WHERE clause to only pull active accounts
|| 08/18/13  WDF 10.5.7.2   (190442) Modified GL restrictions
*/

/*
		GL Account Types
		----------------------
        All = 0
        Bank = 10
        AR = 11
        CurrentAsset = 12
        FixedAsset = 13
        OtherAsset = 14
        AP = 20
        CurrentLiability = 21
        LongTermLiability = 22
        CreditCard = 23
        EquityNoClose = 30
        EquityClose = 31
        RetainedEarnings = 32
        Income = 40
        IncomeOther = 41
        COGS = 50
        Expenses = 51
        ExpensesOther = 52
*/

-- Calculate the beginning of fiscal year
Declare @BeginningDate smalldatetime
Declare @YearStart smalldatetime
Declare @FirstMonth int
Declare @CurYear int
Declare @BalanceMonth int
Declare @FirstYear int
Declare @RestrictToGLCompany int
Declare @Today smalldatetime

Select @FirstMonth = ISNULL(FirstMonth, 1) 
      ,@RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey


Select @FirstYear = Year(GETDATE())
if @FirstMonth > Month(GETDATE())
	Select @FirstYear = @FirstYear - 1
	
Select @BeginningDate = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)
Select @Today = dbo.fFormatDateNoTime(GETDATE())


if @RestrictToGLCompany = 0
	SELECT gl.AccountNumber, gl.AccountName, gl.DisplayOrder,
			SUM(ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0)) AS AccountBalance
	  FROM tTransaction t (NOLOCK)
		LEFT JOIN tGLAccount gl (NOLOCK) ON t.GLAccountKey = gl.GLAccountKey
	 WHERE t.CompanyKey = @CompanyKey
	   AND gl.Active = 1
	   AND (@GLAccountType <= 0 OR gl.AccountType = @GLAccountType)
       AND (@GLCompanyKey <= 0 OR GLCompanyKey = @GLCompanyKey)
	   AND AccountType < 40
	   AND t.TransactionDate <= @Today
	 GROUP BY gl.AccountNumber, gl.AccountName, gl.DisplayOrder
	 
	 UNION ALL
	 
	SELECT gl.AccountNumber, gl.AccountName, gl.DisplayOrder,
			SUM(ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0)) AS AccountBalance
	  FROM tTransaction t (NOLOCK)
		LEFT JOIN tGLAccount gl (NOLOCK) ON t.GLAccountKey = gl.GLAccountKey
	 WHERE t.CompanyKey = @CompanyKey
	   AND gl.Active = 1
	   AND (@GLAccountType <= 0 OR gl.AccountType = @GLAccountType)
       AND (@GLCompanyKey <= 0 OR GLCompanyKey = @GLCompanyKey)
	   AND AccountType >= 40
	   AND t.TransactionDate >= @BeginningDate
	   AND t.TransactionDate <= @Today
	 GROUP BY gl.AccountNumber, gl.AccountName, gl.DisplayOrder
	 ORDER BY gl.DisplayOrder

ELSE

	SELECT gl.AccountNumber, gl.AccountName, gl.DisplayOrder,
			SUM(ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0)) AS AccountBalance
	  FROM tTransaction t (NOLOCK)
		LEFT JOIN tGLAccount gl (NOLOCK) ON t.GLAccountKey = gl.GLAccountKey
	 WHERE t.CompanyKey = @CompanyKey
	   AND gl.Active = 1
	   AND (@GLAccountType <= 0 OR gl.AccountType = @GLAccountType)
       AND (GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))
       AND (@GLCompanyKey <= 0 OR GLCompanyKey = @GLCompanyKey)
	   AND AccountType < 40
	   AND t.TransactionDate <= @Today
	 GROUP BY gl.AccountNumber, gl.AccountName, gl.DisplayOrder
	 
	 UNION ALL
	 
	SELECT gl.AccountNumber, gl.AccountName, gl.DisplayOrder,
			SUM(ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0)) AS AccountBalance
	  FROM tTransaction t (NOLOCK)
		LEFT JOIN tGLAccount gl (NOLOCK) ON t.GLAccountKey = gl.GLAccountKey
	 WHERE t.CompanyKey = @CompanyKey
	   AND gl.Active = 1
	   AND (@GLAccountType <= 0 OR gl.AccountType = @GLAccountType)
       AND (GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))
       AND (@GLCompanyKey <= 0 OR GLCompanyKey = @GLCompanyKey)	   
       AND AccountType >= 40
	   AND t.TransactionDate >= @BeginningDate
	   AND t.TransactionDate <= @Today
	 GROUP BY gl.AccountNumber, gl.AccountName, gl.DisplayOrder
	 ORDER BY gl.DisplayOrder
	return 1
GO
