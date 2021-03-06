USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGeneralLedgerSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptGeneralLedgerSummary]

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
  || 07/28/11 RLB 10.546 (116542) created for Summary General Ledget Report
  || 04/12/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
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
	
	Create table #GLAccount
		(
			GLAccountKey int,
			AccountNumber varchar(100),
			AccountName varchar(200),
			AccountFullName varchar(300),
			DisplayOrder int,
			StartingBal money,
			EndingBal money,
			TotalAmount money,
			AccountType int,
			TotalDebit money,
			TotalCredit money
		)

	
	INSERT	#GLAccount (GLAccountKey, AccountNumber, AccountName, AccountFullName, DisplayOrder, StartingBal, EndingBal, TotalAmount, AccountType, TotalDebit, TotalCredit)
	SELECT	GLAccountKey, AccountNumber, AccountName, ISNULL(AccountNumber, '') + '-' + ISNULL(AccountName, '') as AccountFullName, DisplayOrder, 0, 0, 0, AccountType, 0, 0
	FROM	tGLAccount (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(AccountType IN (Select AccountType from #account_types) or @HasAccountTypes = 0)
	
	IF @CashBasisMode = 0
	BEGIN
	
		 -- Asset Accounts
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
				
			SELECT 	SUM(t.Debit - t.Credit)
			FROM vHTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate < @StartDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
		Where #GLAccount.AccountType in (10 , 11 , 12 , 13 , 14)
			
		-- Liability and Equity Accounts
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
				
			SELECT 	SUM(t.Credit - t.Debit)
			FROM vHTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate < @StartDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
		WHERE #GLAccount.AccountType in (20, 21, 22, 23, 30)
			
		IF @ResetStartingBalance = 0
		BEGIN
			
			-- Expenses
				
			UPDATE #GLAccount 
			SET #GLAccount.StartingBal = ISNULL((
				
				SELECT 	SUM(t.Debit - t.Credit)
				FROM vHTransaction t (nolock)
				WHERE #GLAccount.GLAccountKey = t.GLAccountKey
				AND t.TransactionDate < @StartDate
				AND t.TransactionDate >= @YearStart
				AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
				AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
				AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
				--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
					-- case when @GLCompanyKey = ALL
					(@GLCompanyKey IS NULL AND 
						(
						@RestrictToGLCompany = 0 OR 
						(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

			),0)
			WHERE #GLAccount.AccountType in (50, 51, 52)
				
			-- Equity Closes
			-- Income Accounts
			UPDATE #GLAccount 
			SET #GLAccount.StartingBal = ISNULL((
				
				SELECT 	SUM(t.Credit - t.Debit)
				FROM vHTransaction t (nolock)
				WHERE #GLAccount.GLAccountKey = t.GLAccountKey
				AND t.TransactionDate < @StartDate
				AND t.TransactionDate >= @YearStart
				AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
				AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
				AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
				--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
								-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							)
			
			),0)
			WHERE #GLAccount.AccountType in (31, 40, 41)
			
		END

				
		-- Retained Earnings		
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
				
			ISNULL((SELECT 	SUM(t.Credit - t.Debit)
					FROM vHTransaction t (nolock)
					inner join tGLAccount gla (nolock)on  t.GLAccountKey = gla.GLAccountKey
					WHERE t.CompanyKey = @CompanyKey
					AND  gla.AccountType in (31, 32, 40, 41, 50, 51, 52)
					AND t.TransactionDate < @YearStart
					AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
					AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
					AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
					--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					AND     (
						-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					)

			
			), 0)

			+
				
			ISNULL((SELECT 	SUM(t.Credit - t.Debit)
					FROM vHTransaction t (nolock)
					inner join tGLAccount gla (nolock)on  t.GLAccountKey = gla.GLAccountKey
					WHERE t.CompanyKey = @CompanyKey
					AND  gla.AccountType = 32
					AND t.TransactionDate >= @YearStart
					AND t.TransactionDate < @StartDate
					AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
					AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
					AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
					--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					AND     (
						-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					)

			), 0)
				
			
		),0)
		Where  #GLAccount.AccountType = 32
			
		-- Total Debit
		UPDATE #GLAccount 
		SET #GLAccount.TotalDebit = ISNULL((
				
			SELECT 	SUM(t.Debit)
			FROM vHTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate >= @StartDate
			AND t.TransactionDate <= @EndDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
			
		-- Total Credit
		UPDATE #GLAccount 
		SET #GLAccount.TotalCredit = ISNULL((
				
			SELECT 	SUM(t.Credit)
			FROM vHTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate >= @StartDate
			AND t.TransactionDate <= @EndDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
	
	END
	ELSE	
	BEGIN
		 -- Asset Accounts Cash
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
			
			SELECT 	SUM(t.Debit - t.Credit)
			FROM vHCashTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate < @StartDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
		Where #GLAccount.AccountType in (10 , 11 , 12 , 13 , 14)

		-- Liability and Equity Cash Accounts 
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
			
			SELECT 	SUM(t.Credit - t.Debit)
			FROM vHCashTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate < @StartDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

		),0)
		WHERE #GLAccount.AccountType in (20, 21, 22, 23, 30)

		IF @ResetStartingBalance = 0
		BEGIN
		
			-- Expenses Cash Accounts
			
			UPDATE #GLAccount 
			SET #GLAccount.StartingBal = ISNULL((
			
				SELECT 	SUM(t.Debit - t.Credit)
				FROM vHCashTransaction t (nolock)
				WHERE #GLAccount.GLAccountKey = t.GLAccountKey
				AND t.TransactionDate < @StartDate
				AND t.TransactionDate >= @YearStart
				AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
				AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
				AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
				--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
					-- case when @GLCompanyKey = ALL
					(@GLCompanyKey IS NULL AND 
						(
						@RestrictToGLCompany = 0 OR 
						(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

			),0)
			WHERE #GLAccount.AccountType in (50, 51, 52)

			-- Equity Closes Cash Accounts
			-- Income  Cash Accounts
			UPDATE #GLAccount 
			SET #GLAccount.StartingBal = ISNULL((
			
				SELECT 	SUM(t.Credit - t.Debit)
				FROM vHCashTransaction t (nolock)
				WHERE #GLAccount.GLAccountKey = t.GLAccountKey
				AND t.TransactionDate < @StartDate
				AND t.TransactionDate >= @YearStart
				AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
				AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
				AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
				--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
					-- case when @GLCompanyKey = ALL
					(@GLCompanyKey IS NULL AND 
						(
						@RestrictToGLCompany = 0 OR 
						(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
					OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

			),0)
			WHERE #GLAccount.AccountType in (31, 40, 41)

		END
			
		-- Retained Earnings cash Accounts		
		UPDATE #GLAccount 
		SET #GLAccount.StartingBal = ISNULL((
			
			ISNULL((SELECT 	SUM(t.Credit - t.Debit)
					FROM vHCashTransaction t (nolock)
					inner join tGLAccount gla (nolock)on  t.GLAccountKey = gla.GLAccountKey
					WHERE t.CompanyKey = @CompanyKey
					AND  gla.AccountType in (31, 32, 40, 41, 50, 51, 52)
					AND t.TransactionDate < @YearStart
					AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
					AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
					AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
					--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					AND     (
						-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					)

			), 0)
			+
			
			ISNULL((SELECT 	SUM(t.Credit - t.Debit)
					FROM vHCashTransaction t (nolock)
					inner join tGLAccount gla (nolock)on  t.GLAccountKey = gla.GLAccountKey
					WHERE t.CompanyKey = @CompanyKey
					AND  gla.AccountType = 32
					AND t.TransactionDate >= @YearStart
					AND t.TransactionDate < @StartDate
					AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
					AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
					AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
					--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			
					AND     (
						-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					)

			), 0)
			
		
		),0)
		Where  #GLAccount.AccountType = 32
		
		-- Total Debit Cash Accounts
		UPDATE #GLAccount 
		SET #GLAccount.TotalDebit = ISNULL((
			
			SELECT 	SUM(t.Debit)
			FROM vHCashTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate >= @StartDate
			AND t.TransactionDate <= @EndDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
					-- case when @GLCompanyKey = ALL
					(@GLCompanyKey IS NULL AND 
						(
						@RestrictToGLCompany = 0 OR 
						(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

		),0)
		
		-- Total Credit Cash Accounts
		UPDATE #GLAccount 
		SET #GLAccount.TotalCredit = ISNULL((
			
			SELECT 	SUM(t.Credit)
			FROM vHCashTransaction t (nolock)
			WHERE #GLAccount.GLAccountKey = t.GLAccountKey
			AND t.TransactionDate >= @StartDate
			AND t.TransactionDate <= @EndDate
			AND	(@ClassKey IS NULL OR t.ClassKey = @ClassKey)
			AND	(@OfficeKey IS NULL OR t.OfficeKey = @OfficeKey)
			AND	(@DepartmentKey IS NULL OR t.DepartmentKey = @DepartmentKey)
			--AND	(@GLCompanyKey IS NULL OR ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
					-- case when @GLCompanyKey = ALL
					(@GLCompanyKey IS NULL AND 
						(
						@RestrictToGLCompany = 0 OR 
						(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

		),0)
	
	
	END	
	
	-- Total Amounts
	UPDATE #GLAccount 
	SET #GLAccount.TotalAmount = #GLAccount.TotalDebit - #GLAccount.TotalCredit
	WHERE #GLAccount.AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52)
	
	UPDATE #GLAccount 
	SET #GLAccount.TotalAmount = #GLAccount.TotalCredit - #GLAccount.TotalDebit
	WHERE #GLAccount.AccountType in (20, 21, 22, 23, 30, 31, 32, 40, 41)
	
	-- Ending Balence
	UPDATE #GLAccount 
	SET #GLAccount.EndingBal = #GLAccount.StartingBal + #GLAccount.TotalAmount


	Select *
	From #GLAccount
	Order By DisplayOrder
GO
