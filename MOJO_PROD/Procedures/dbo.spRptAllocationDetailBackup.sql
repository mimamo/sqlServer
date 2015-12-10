USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAllocationDetailBackup]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptAllocationDetailBackup]
	(	
		@CompanyKey int
		,@GLAccountType int = 50 --default COGS
		,@GLCompanyKey INT = -1	
		,@StartDate DATETIME
		,@EndDate DATETIME	
		,@UserKey int = null 
			
	)
AS

/*
|| When     Who Rel     What
|| 07/30/10 RLB 10.533  Created for new Allocation Detail Backup Report
|| 04/12/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/14 GHL 10.576  Using now vHTransaction (Credit mapped to HCredit)
*/

	SET NOCOUNT ON

	IF @StartDate is NULL
		SELECT @StartDate = '1/1/1995'

	IF @EndDate is NULL
		SELECT @EndDate = '1/1/2070'
	
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
	
if @GLAccountType = 53

	Select TransactionDate
	,Reference
	,Isnull(Memo, 'No Memo') as Memo
	,Case gla.AccountType 
		when 50 then 'Cost of Goods Sold'
		when 51 then 'Expense'
		else 'Other Expense'
		end as AccountType
	,ISNULL(t.Debit, 0) - ISNULL(t.Credit, 0) as Amount
	,gla.AccountNumber + ' - ' + gla.AccountName as AccountName
	
	From vHTransaction t (nolock)
	inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	Where t.CompanyKey = @CompanyKey
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)

	and gla.AccountType in (50,51,52)
	and (t.ClientKey is null or t.Overhead = 1)
	and TransactionDate >= @StartDate
	and TransactionDate <= @EndDate
	Order by gla.AccountType, TransactionDate, gla.AccountNumber
		
ELSE
	
	Select TransactionDate
	,Reference
	,isnull(Memo, 'No Memo') as Memo
	,Case gla.AccountType 
		when 50 then 'Cost of Goods Sold'
		when 51 then 'Expense'
		else 'Other Expense'
		end as AccountType
	,ISNULL(t.Debit, 0) - ISNULL(t.Credit, 0) as Amount
	,gla.AccountNumber + ' - ' + gla.AccountName as AccountName
	
	From vHTransaction t (nolock)
	inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
	Where t.CompanyKey = @CompanyKey
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
	and gla.AccountType = @GLAccountType
	and (t.ClientKey is null or t.Overhead = 1)
	and TransactionDate >= @StartDate
	and TransactionDate <= @EndDate
	Order by gla.AccountType, TransactionDate, gla.AccountNumber
	
	RETURN 1
GO
