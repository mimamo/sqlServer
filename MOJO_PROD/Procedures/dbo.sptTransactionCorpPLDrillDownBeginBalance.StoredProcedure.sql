USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionCorpPLDrillDownBeginBalance]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionCorpPLDrillDownBeginBalance]
	@GLAccountKey int,
	@StartDate smalldatetime,
	@CashBasis tinyint,
	@CashBasisLegacy int = 1,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 07/01/09  GHL 10.502  Created to support Flex GL account DD
|| 12/7/09   CRG 10.5.1.5 (46327) Modified to use a temp table for selected ClassKeys
|| 04/11/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/19/12  GHL 10.558   Multiple select for Gl companies, office, departments
|| 12/31/13  GHL 10.575   Reading now views rather than tTransaction because in the views Debit maps to HDebit, etcc
|| 02/14/14  GHL 10.577   Bank accounts are revalued at account level, therefore return the balance in foreign currency
||                        so that it can be recalculated on the UI and used to recalculate the end balance as well
*/

	/* Assume Created in VB
		CREATE TABLE #ClassKeys (ClassKey int NULL)
	*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

Declare @MultiCurrency int
Select @MultiCurrency = ISNULL(pref.MultiCurrency, 0)
from   tGLAccount gla (nolock)
	inner join tPreference pref (nolock) on gla.CompanyKey = pref.CompanyKey
where gla.GLAccountKey = @GLAccountKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
select @MultiCurrency = isnull(@MultiCurrency, 0)

	DECLARE	@HasClassKeys int		SELECT	@HasClassKeys = COUNT(*) FROM #ClassKeys
	DECLARE	@HasGLCompanyKeys int	SELECT	@HasGLCompanyKeys = COUNT(*) FROM #GLCompanyKeys
	DECLARE	@HasOfficeKeys int		SELECT	@HasOfficeKeys = COUNT(*) FROM #OfficeKeys
	DECLARE	@HasDepartmentKeys int	SELECT	@HasDepartmentKeys = COUNT(*) FROM #DepartmentKeys


	DECLARE @CompanyKey INT, @TrackCash INT, @AccountType smallint
	
	-- These are in Home Currency
	DECLARE @BeginningBal money, @Debit money, @Credit money
	-- These are in Transaction Currency
	DECLARE @CBeginningBal money, @CDebit money, @CCredit money

	
	SELECT @CompanyKey = CompanyKey
	      ,@AccountType = AccountType
		  
	FROM   tGLAccount (NOLOCK)
	WHERE  GLAccountKey = @GLAccountKey

	IF @CashBasis = 1
	BEGIN
		EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, NULL
		IF @TrackCash = 0
			SELECT @CashBasisLegacy = 1
	
	END

	IF @StartDate IS NULL	
	    SELECT @BeginningBal = 0
	    	   ,@CBeginningBal = 0
			    
	if @AccountType >= 40
			Select @BeginningBal = 0
				 ,@CBeginningBal = 0
			    
	IF @BeginningBal IS NULL
	BEGIN
		IF @CashBasis = 1 AND @CashBasisLegacy = 0
		BEGIN

			SELECT @BeginningBal = SUM(Debit - Credit) 
			      ,@CBeginningBal = SUM(CDebit - CCredit)
			FROM   vHCashTransaction (NOLOCK) 
			WHERE  GLAccountKey = @GLAccountKey 
			AND    TransactionDate < @StartDate
			--AND	  (@GLCompanyKey IS NULL OR ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
		END
			
		ELSE IF @CashBasis = 1 AND @CashBasisLegacy = 1
		BEGIN
 
			-- vTransactionCash does not have a foreign currency

			SELECT @BeginningBal = SUM(Debit - Credit) 
				 ,@CBeginningBal = SUM(Debit - Credit) 
			FROM   vTransactionCash (NOLOCK) 
			WHERE  GLAccountKey = @GLAccountKey 
			AND    PostingDate < @StartDate
			--AND	  (@GLCompanyKey IS NULL OR ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )		
		
			
		END
		ELSE
		BEGIN
			-- Accrual

			SELECT @BeginningBal = SUM(Debit - Credit) 
				  ,@CBeginningBal = SUM(CDebit - CCredit)
			FROM   vHTransaction (NOLOCK) 
			WHERE  GLAccountKey = @GLAccountKey 
			AND    TransactionDate < @StartDate
			--AND	  (@GLCompanyKey IS NULL OR ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )

		END
		
						
		IF @AccountType IN (10 , 11 , 12 , 13 , 14) 
			SELECT @Debit = @BeginningBal, @Credit = 0
			      ,@CDebit = @CBeginningBal, @CCredit = 0
		ELSE
		BEGIN
			-- Begining balance should be SUM(Credit - Debit) so multiply by -1 
			SELECT @BeginningBal = -1 * @BeginningBal 
			SELECT @Debit = 0, @Credit = @BeginningBal

			SELECT @CBeginningBal = -1 * @CBeginningBal 
			SELECT @CDebit = 0, @CCredit = @CBeginningBal
		END
		  
	END	
	

	SELECT  ISNULL(@BeginningBal, 0) AS BeginningBal
			, ISNULL(@Debit, 0) AS Debit
			, ISNULL(@Credit, 0) AS Credit
			
			, ISNULL(@CBeginningBal, 0) AS CBeginningBal
			, ISNULL(@CDebit, 0) AS CDebit
			, ISNULL(@CCredit, 0) AS CCredit 
			
			, @AccountType AS AccountType -- Needed to determine visibility on screen
GO
