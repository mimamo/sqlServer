USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLAccrual]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLAccrual]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null,
	@TranCountOnly tinyint = 0
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/21/07   CRG 8.5      Created for Flex Corporate P&L
|| 12/7/09   CRG 10.5.1.5 (46327) Modified to use a temp table for selected ClassKeys
|| 04/11/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/18/12  GHL 10.558   Added support of multiple GL companies and offices and departments
|| 10/26/12  CRG 10.5.6.1 Added TranCountOnly to return the number of transactions so that some columns can be hidden when running "One Column Per"
|| 12/30/13  GHL 10.575   Using now vHTransaction because it is mapped to HDebit/HCredit
|| 02/11/14  GHL 10.577   Added logic for Bank Revaluations and Unrealized Gains
|| 02/14/14  GHL 10.577   Bank accounts are revalued by account (not by transaction)
|| 02/24/14  GHL 10.577   Added TranCountOnly logic for revaluations and gains
|| 03/20/14  GHL 10.578   Added the adv bill account to revalue
*/

/* Assume Created in VB
	CREATE TABLE #ClassKeys (ClassKey int NULL)
*/

Declare @RestrictToGLCompany int
Declare @MultiCurrency int
Declare @AdvBillAccountKey int -- we will revalue the adv bill account 

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	  ,@AdvBillAccountKey = AdvBillAccountKey
from   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
select @MultiCurrency = isnull(@MultiCurrency, 0)

DECLARE	@HasClassKeys int
SELECT	@HasClassKeys = COUNT(*)
FROM	#ClassKeys

DECLARE	@HasGLCompanyKeys int
SELECT	@HasGLCompanyKeys = COUNT(*)
FROM	#GLCompanyKeys

DECLARE	@HasOfficeKeys int
SELECT	@HasOfficeKeys = COUNT(*)
FROM	#OfficeKeys

DECLARE	@HasDepartmentKeys int
SELECT	@HasDepartmentKeys = COUNT(*)
FROM	#DepartmentKeys

declare @BankRevaluations money
declare @UnrealizedCurrencyGains money
declare @BankRevaluationsCount int
declare @UnrealizedCurrencyGainsCount int
  
if @MultiCurrency = 1
begin

	Create table #revalue
	(
	GLAccountKey int
	,TransactionDate smalldatetime null
	,CurrencyID varchar(10) null
 	,Debit money null -- in Transaction Currency
	,Credit money null
	,HDebit money null -- in Home Currency
	,HCredit money null
	)

	-- bank accounts cannot be revalued transaction by transaction
	-- they have to be revalued as a group, i.e. if I have 1000 EUR at 1.389128 it should be:
	-- round(1000 * 1.389128, 2) = 1389.13 
	-- not SUM(round(values, 1.389128, 2) which will be diff from 1389.13   
	Create table #revalued
	(
	GLAccountKey int null
	,CurrencyID varchar(10) null
	,AccountType int null
	,OriginalHValue1 money null -- 1st period, original value
	,RevaluedHValue1 money null -- 1st period, revalued value
	,OriginalHValue money null  -- 2 periods
	,RevaluedHValue money null
	,RetainedEarning money null
	,CurrentEarning money null
	)

	insert #revalue(GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	where t.CompanyKey = @CompanyKey
	and   gla.AccountType in (10, 11, 20, 23) -- Bank, CC, AP, AR
	and   gla.CurrencyID is not null
	and   t.CurrencyID is not null		        -- do not revalue the AR/AP adjustments where CurrencyID is null
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)
		
		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)

	-- And now process the Adv Bill account
	insert #revalue(GLAccountKey,TransactionDate,CurrencyID,Debit,Credit,HDebit ,HCredit)
	select t.GLAccountKey,t.TransactionDate,t.CurrencyID, t.Debit,t.Credit,t.HDebit ,t.HCredit
	from  tTransaction t (nolock)
	where t.CompanyKey = @CompanyKey
	and   t.GLAccountKey = @AdvBillAccountKey
	and   t.CurrencyID is not null		        
	and   t.TransactionDate <= @EndDate
	AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)
		
		AND (
			-- All offices
			@HasOfficeKeys = 0 
			-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
			OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
		)

		AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
		AND (
			-- All departments
			@HasDepartmentKeys = 0 
			-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
			OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)			
			)

	exec spRptBalanceSheetRevaluation @CompanyKey, @StartDate, @EndDate 

	select @BankRevaluations = isnull(sum(CurrentEarning), 0) from #revalued where AccountType = 10 
	select @UnrealizedCurrencyGains = isnull(sum(CurrentEarning), 0) from #revalued where AccountType <> 10 

	select @BankRevaluationsCount = count(*) from #revalued 
	where AccountType = 10 and isnull(CurrentEarning, 0) <> 0
	 
	select @UnrealizedCurrencyGainsCount = count(*) from #revalued 
	where AccountType <> 10  and isnull(CurrentEarning, 0) <> 0

	--select * from #revalue
	--select * from #revalued
 
end
 	
SELECT	GLAccountKey,
		ISNULL(ParentAccountKey, 0) as ParentAccountKey,
		DisplayOrder,
		DisplayLevel,
		Rollup,
		CASE gl.AccountType
			WHEN 40 THEN 1
			WHEN 50 THEN 2
			WHEN 51 THEN 3
			WHEN 41 THEN 4
			WHEN 52 THEN 5 
		END AS MinorGroup,
		ISNULL(
			CASE 
				WHEN AccountType IN (40, 41) THEN
					(SELECT CASE @TranCountOnly
								WHEN 1 THEN COUNT(*)
								ELSE SUM(Credit - Debit) 
							END
					FROM	vHTransaction t (nolock) 
					WHERE	t.GLAccountKey = gl.GLAccountKey
					
					--If we pass in 0 for GLCompany, Office, Class, or Department, we want rows where that value is NULL.
					--If we pass in NULL, we want all rows.					
					
					AND (
							-- All companies
							(
							@HasGLCompanyKeys = 0 AND
								(
								@RestrictToGLCompany = 0 OR 
								(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
						-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
						OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
						)

					AND (
							-- All offices
							@HasOfficeKeys = 0 
							-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
							OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
						)

					AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
					
					AND (
							-- All departments
							@HasDepartmentKeys = 0 
							-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
							OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
						)

					AND		t.TransactionDate >= @StartDate
					AND		t.TransactionDate <= @EndDate)
				ELSE
					(SELECT CASE @TranCountOnly
								WHEN 1 THEN COUNT(*)
								ELSE SUM(Debit - Credit) 
							END
					FROM	vHTransaction t (nolock) 
					WHERE	t.GLAccountKey = gl.GLAccountKey
					
					--If we pass in 0 for GLCompany, Office, Class, or Department, we want rows where that value is NULL.
					--If we pass in NULL, we want all rows.					
					
					AND (
						-- All companies
						(
						@HasGLCompanyKeys = 0 AND
							(
							@RestrictToGLCompany = 0 OR 
							(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
					OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
					)

					AND (
						-- All offices
						@HasOfficeKeys = 0 
						-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
						OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
					)

					AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)

					AND (
							-- All departments
							@HasDepartmentKeys = 0 
							-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
							OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
						)

					AND		t.TransactionDate >= @StartDate
					AND		t.TransactionDate <= @EndDate)
			END
		, 0) AS Amount
FROM	tGLAccount gl (nolock)
WHERE	CompanyKey = @CompanyKey 
AND		AccountType IN (40, 41, 50, 51, 52)


Union ALL
	Select
		 -1 -- GLAccountKey
		,0 -- ParentAccountKey
		--,'' -- AccountNumber
		--,'Bank Revaluations' -- AccountName
		,99998 -- DisplayOrder
		,0 -- DisplayLevel
		,0 -- Rollup
		,4 -- Minor Group
		,case @TranCountOnly 
			when 1 then isnull(@BankRevaluationsCount, 0) 
			else @BankRevaluations
		end

Union ALL
	Select
		 -2 -- GLAccountKey
		,0 -- ParentAccountKey
		--,'' -- AccountNumber
		--,'Unrealized Gains' -- AccountName
		,99999 -- DisplayOrder
		,0 -- DisplayLevel
		,0 -- Rollup
		,4 -- Minor Group
		,case @TranCountOnly 
			when 1 then isnull(@UnrealizedCurrencyGainsCount, 0) 
			else @UnrealizedCurrencyGains
		end

ORDER BY MinorGroup, DisplayOrder
GO
