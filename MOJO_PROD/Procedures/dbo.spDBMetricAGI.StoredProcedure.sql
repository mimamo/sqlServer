USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricAGI]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricAGI]
	@CompanyKey int,
	@FromDate datetime,
	@ToDate datetime,
	@GLCompanyKey int,
	@UserKey int,
	@IncomeAmt decimal(24,4) output,
	@COGSAmt decimal(24,4) output,
	@ExpenseAmt decimal(24,4) output,
	@AGIAmt decimal(24,4) output

AS --Encrypt

/*
  || When     Who Rel       What
  || 12/2/09  GWG 10.5.1.4  Modified the agi calculation to be in line with the pl and client pl (with overhead allocated)
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
*/

declare @IncomeAmtCredit decimal(24,4)
declare @IncomeAmtDebit decimal(24,4)
declare @COGSAmtCredit decimal(24,4)
declare @COGSAmtDebit decimal(24,4)
declare @ExpenseAmtCredit decimal(24,4)
declare @ExpenseAmtDebit decimal(24,4)

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

-- income credit
select @IncomeAmtCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where
	t.CompanyKey = @CompanyKey
	and g.AccountType = 40  -- Income Accounts
	and TransactionDate >= @FromDate 
	and TransactionDate < @ToDate

-- income debit
select @IncomeAmtDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where
	t.CompanyKey = @CompanyKey
	and g.AccountType = 40  -- Income Accounts
	and TransactionDate >= @FromDate
	and TransactionDate < @ToDate

-- COGS
select @COGSAmtDebit = isnull(sum(isnull(Debit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where
	t.CompanyKey = @CompanyKey
	and g.AccountType = 50  -- Cost Of Goods Sold Accounts
	and TransactionDate >= @FromDate 
	and TransactionDate < @ToDate

select @COGSAmtCredit = isnull(sum(isnull(Credit,0)),0)
from
	vHTransaction t (nolock)
	inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
	INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
where
	t.CompanyKey = @CompanyKey
	and g.AccountType = 50  -- Cost Of Goods Sold Accounts
	and TransactionDate >= @FromDate 
	and TransactionDate < @ToDate

	-- expenses (client only)
/*	select @ExpenseAmtDebit = isnull(sum(isnull(Debit,0)),0)
      from tTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
     where t.CompanyKey = @CompanyKey
       and g.AccountType = 51  -- Expense Accounts
	   and isnull(t.ClientKey,0) > 0
       and TransactionDate >= @FromDate 
       and TransactionDate < @ToDate
       
	select @ExpenseAmtCredit = isnull(sum(isnull(Credit,0)),0)
      from tTransaction t (nolock) inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
     where t.CompanyKey = @CompanyKey
       and g.AccountType = 51  -- Expense Accounts
	   and isnull(t.ClientKey,0) > 0
       and TransactionDate >= @FromDate 
       and TransactionDate < @ToDate */

select @IncomeAmt = @IncomeAmtCredit - @IncomeAmtDebit
select @COGSAmt = @COGSAmtDebit - @COGSAmtCredit
select @ExpenseAmt = @ExpenseAmtDebit - @ExpenseAmtCredit
select @AGIAmt = @IncomeAmt - @COGSAmt
GO
