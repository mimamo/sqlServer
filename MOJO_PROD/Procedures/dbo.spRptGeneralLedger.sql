USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGeneralLedger]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGeneralLedger]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@ClassKey int,
		@OfficeKey int,
		@DepartmentKey int,
		@GLCompanyKey int, --0 indicates the report is looking for "No Company Specified". NULL indicates All.
		@CashBasisMode int = 0, -- 0 Accrual, 1 Cash Basis 
	    @IncludeUnposted int = 0,
		@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel     What
  || 04/10/07 GHL 8.411   Bug 8855. Formatting of AccountFullName in rpx causing next GL account
  ||                      to be displayed on the group header, when there is a detail with 1 row
  ||                      at top of page. Added AccountFullName column.   
  || 10/18/07 CRG 8.5     Added GLCompanyKey parameter.
  ||                      Also now look for Office and Department directly on the Transaction, rather than going through the Class.  
  || 8/20/08  GWG 10.007  Added Sorting by Entity and EntityKey inside of a tran date      
  || 03/11/09 GHL 10.020  Added cash basis support    
  || 07/20/09 GWG 10.505  Changed the last sort to be by reference.
  || 11/11/09 GHL 10.513  Added Include Unposted parameter
  || 12/2/10  RLB 10.539  (95907) Added join to pull journal entry description as name  
  || 07/27/11 RLB 10.546  (116542) passing in an account type temp table so i can filter the report on those types
  || 04/12/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 08/14/12 KMC 10.559  (151555) Added AccountType = 23 to the case statements for Liability and Equity Accounts so
  ||                      the beginning balance for the month shows up on the report
  || 07/12/18 WDF 10.570 (176497) Added VoucherID
  || 01/06/14 GHL 10.576  Using now vHTransaction instead of tTransaction (Credit is mapped to HCredit)
  */

  /* Assume Created in VB
	CREATE TABLE #account_types (AccountType int NULL)
*/

DECLARE	@HasAccountTypes int

SELECT	@HasAccountTypes = COUNT(*)
FROM	#account_types

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


Declare @FirstMonth int, @FirstYear int, @YearStart smalldatetime, @ResetStartingBalance tinyint

-- Calculate GL Year Start
Select @FirstMonth = ISNULL(FirstMonth, 1) from tPreference (nolock) Where CompanyKey = @CompanyKey
Select @FirstYear = Year(@EndDate)
if @FirstMonth > Month(@EndDate)
	Select @FirstYear = @FirstYear - 1
Select @YearStart = Cast(Cast(@FirstMonth as Varchar) + '/1/' + cast(@FirstYear as Varchar) as smalldatetime)

-- When we cross over several fiscal years, the starting balance of some accounts need to be reset 
-- Income (AccountType 40, 41), Expense Account (AccountType 50, 51, 52) and Equity (AccountType 31)
Select @ResetStartingBalance = 0
if @YearStart > @StartDate
	Select @ResetStartingBalance = 1
	
Create table #GLTran
(
	CompanyKey int,
	SourceCompanyKey int,
	GLAccountKey int,
	Reference varchar(100),
	Entity varchar(100),
	EntityKey int,
	Memo varchar(500),
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

IF @CashBasisMode = 0
BEGIN
	INSERT	#GLTran (CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, Debit, Credit
	FROM	vHTransaction (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(ClassKey = @ClassKey OR @ClassKey IS NULL)
	AND		(OfficeKey = @OfficeKey OR @OfficeKey IS NULL)
	AND		(DepartmentKey = @DepartmentKey OR @DepartmentKey IS NULL)
	--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)


	-- for unposted transactions reverse Debit and Credit
	IF @IncludeUnposted = 1
	INSERT	#GLTran (CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, HDebit * -1, HCredit * -1
	FROM	tTransactionUnpost (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(ClassKey = @ClassKey OR @ClassKey IS NULL)
	AND		(OfficeKey = @OfficeKey OR @OfficeKey IS NULL)
	AND		(DepartmentKey = @DepartmentKey OR @DepartmentKey IS NULL)
	--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)
	
END
ELSE
	INSERT	#GLTran (CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT	CompanyKey, SourceCompanyKey, Reference, Entity, EntityKey, Memo, GLAccountKey, TransactionDate, Debit, Credit
	FROM	vHCashTransaction (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(ClassKey = @ClassKey OR @ClassKey IS NULL)
	AND		(OfficeKey = @OfficeKey OR @OfficeKey IS NULL)
	AND		(DepartmentKey = @DepartmentKey OR @DepartmentKey IS NULL)
	--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)
if @HasAccountTypes = 0
BEGIN
	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountNumber + ' - ' + gl.AccountName AS AccountFullName
		,gl.AccountType
		,gl.DisplayOrder
		,gl.DisplayLevel
		,gl.StartingBal
		,t.*
		,ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0) as Amount
		,v.VoucherID
	From
		(Select 
			GLAccountKey
			,AccountNumber
			,AccountName
			,AccountType
			,DisplayOrder
			,DisplayLevel
			,Case 
				When AccountType in (10 , 11 , 12 , 13 , 14) then -- Asset Accounts
					ISNULL((Select SUM(Debit - Credit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate), 0)
				
				When AccountType in (20, 21, 22, 23, 30) then -- Liability and Equity Accounts
					ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate), 0)
				
				When AccountType in (50, 51, 52) then -- Expenses
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Debit - Credit) from #GLTran (nolock)
							Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey 
							and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
					
				When AccountType = 31 then -- Equity Closes
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
							Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey 
							and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
					
				When AccountType = 32 then -- Retained Earnings
					ISNULL((Select Sum(Credit - Debit) from #GLTran (nolock) 
						inner join tGLAccount (nolock) on #GLTran.GLAccountKey = tGLAccount.GLAccountKey
						Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType in (31, 32, 40, 41, 50, 51, 52) 
							and #GLTran.TransactionDate < @YearStart), 0) +
					ISNULL((Select Sum(Credit - Debit) from #GLTran (nolock) 
						inner join tGLAccount (nolock) on #GLTran.GLAccountKey = tGLAccount.GLAccountKey
						Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType = 32 
							and #GLTran.TransactionDate >= @YearStart and TransactionDate < @StartDate), 0)
				
				When AccountType in (40, 41) then -- Income Accounts
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
				End as StartingBal
		from tGLAccount (nolock)
		Where
			CompanyKey = @CompanyKey) as gl
		Left Outer Join (
			Select #GLTran.*, ISNULL(tCompany.CompanyName, tJournalEntry.Description) as CompanyName  from #GLTran (nolock) 
			Left Outer Join tCompany on #GLTran.SourceCompanyKey = tCompany.CompanyKey
			left Outer Join tJournalEntry on #GLTran.EntityKey = tJournalEntry.JournalEntryKey and #GLTran.Entity = 'GENJRNL'
			Where TransactionDate >= @StartDate
			and	  TransactionDate <= @EndDate
			and	  #GLTran.CompanyKey = @CompanyKey
			) as t on gl.GLAccountKey = t.GLAccountKey 
        Left JOIN tVoucher v ON (v.VoucherKey = t.EntityKey AND
                                 t.Entity = 'Voucher')
	Order by
		DisplayOrder, TransactionDate, t.Reference, t.Entity
END
ELSE
	Select 
		 gl.GLAccountKey
		,gl.AccountNumber
		,gl.AccountName
		,gl.AccountNumber + ' - ' + gl.AccountName AS AccountFullName
		,gl.AccountType
		,gl.DisplayOrder
		,gl.DisplayLevel
		,gl.StartingBal
		,t.*
		,ISNULL(Case When AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52) then Debit - Credit else Credit - Debit end, 0) as Amount
		,v.VoucherID
	From
		(Select 
			GLAccountKey
			,AccountNumber
			,AccountName
			,AccountType
			,DisplayOrder
			,DisplayLevel
			,Case 
				When AccountType in (10 , 11 , 12 , 13 , 14) then -- Asset Accounts
					ISNULL((Select SUM(Debit - Credit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate), 0)
				
				When AccountType in (20, 21, 22, 23, 30) then -- Liability and Equity Accounts
					ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate), 0)
				
				When AccountType in (50, 51, 52) then -- Expenses
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Debit - Credit) from #GLTran (nolock)
							Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey 
							and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
					
				When AccountType = 31 then -- Equity Closes
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
							Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey 
							and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
					
				When AccountType = 32 then -- Retained Earnings
					ISNULL((Select Sum(Credit - Debit) from #GLTran (nolock) 
						inner join tGLAccount (nolock) on #GLTran.GLAccountKey = tGLAccount.GLAccountKey
						Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType in (31, 32, 40, 41, 50, 51, 52) 
							and #GLTran.TransactionDate < @YearStart), 0) +
					ISNULL((Select Sum(Credit - Debit) from #GLTran (nolock) 
						inner join tGLAccount (nolock) on #GLTran.GLAccountKey = tGLAccount.GLAccountKey
						Where #GLTran.CompanyKey = @CompanyKey and tGLAccount.AccountType = 32 
							and #GLTran.TransactionDate >= @YearStart and TransactionDate < @StartDate), 0)
				
				When AccountType in (40, 41) then -- Income Accounts
					CASE WHEN @ResetStartingBalance = 1 THEN 0
					ELSE
						ISNULL((Select SUM(Credit - Debit) from #GLTran (nolock)
						Where #GLTran.GLAccountKey = tGLAccount.GLAccountKey and TransactionDate < @StartDate and TransactionDate >= @YearStart), 0)
					END
				End as StartingBal
		from tGLAccount (nolock)
		Where
			CompanyKey = @CompanyKey
			and (AccountType IN (Select AccountType from #account_types) or @HasAccountTypes = 0)) as gl
		Left Outer Join (
			Select #GLTran.*, ISNULL(tCompany.CompanyName, tJournalEntry.Description) as CompanyName  from #GLTran (nolock) 
			Left Outer Join tCompany (nolock) on #GLTran.SourceCompanyKey = tCompany.CompanyKey
			left Outer Join tJournalEntry (nolock) on #GLTran.EntityKey = tJournalEntry.JournalEntryKey and #GLTran.Entity = 'GENJRNL'
			inner join tGLAccount (nolock) on #GLTran.GLAccountKey = tGLAccount.GLAccountKey
			Where TransactionDate >= @StartDate
			and	  TransactionDate <= @EndDate
			and	  #GLTran.CompanyKey = @CompanyKey
			and (tGLAccount.AccountType IN (Select AccountType from #account_types) or @HasAccountTypes = 0)
			) as t on gl.GLAccountKey = t.GLAccountKey 
        Left JOIN tVoucher v (nolock) ON (v.VoucherKey = t.EntityKey AND
                                          t.Entity = 'Voucher')
	Order by
		DisplayOrder, TransactionDate, t.Reference, t.Entity
GO
