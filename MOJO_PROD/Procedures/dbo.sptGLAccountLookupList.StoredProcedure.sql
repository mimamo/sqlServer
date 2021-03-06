USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountLookupList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountLookupList]

	(
		@CompanyKey int,
		@MinAccountType smallint,
		@MaxAccountType smallint,
		@AccountNumber varchar(100),
		@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel        What
  || 01/03/07 GHL 8.4        Added AccountName in the search 
  || 06/01/12 QMD 10.5.5.7   Added UserKey and the VisibleGLCompanyKey restriction.
  || 08/14/12 GHL 10.5.5.8   Using now RestrictToGLCompany for restriction instead of VisibleGLCompanyKey 
  */

if @AccountNumber is null
	if @MinAccountType = 0
		SELECT 
			GLAccountKey,
			AccountNumber,
			AccountName,
			Rollup,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			AccountType,
			Case AccountType
				When 10 then 'Bank'
				When 11 then 'AR'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'AP'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity Does Not Close'
				When 31 then 'Equity Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'COGS'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeName,
			DisplayLevel
		FROM tGLAccount (nolock)
		WHERE
			CompanyKey = @CompanyKey and Active = 1
		And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		ORDER BY
			DisplayOrder
	else
		SELECT 
			GLAccountKey,
			AccountNumber,
			AccountName,
			Rollup,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			AccountType,
			Case AccountType
				When 10 then 'Bank'
				When 11 then 'AR'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'AP'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity Does Not Close'
				When 31 then 'Equity Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'COGS'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeName,
			DisplayLevel
		FROM tGLAccount (nolock)
		WHERE
			CompanyKey = @CompanyKey and
			AccountType <= @MaxAccountType and
			AccountType >= @MinAccountType and
			Active = 1
		And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )

		ORDER BY
			DisplayOrder
else
	if @MinAccountType = 0
		SELECT 
			GLAccountKey,
			AccountNumber,
			AccountName,
			Rollup,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			AccountType,
			Case AccountType
				When 10 then 'Bank'
				When 11 then 'AR'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'AP'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity Does Not Close'
				When 31 then 'Equity Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'COGS'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeName,
			DisplayLevel
		FROM tGLAccount (nolock)
		WHERE
			CompanyKey = @CompanyKey and
			(
			AccountNumber like @AccountNumber + '%' 
			Or
			AccountName like '%' + @AccountNumber + '%'
			) and
			Active = 1
			And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
			ORDER BY
			DisplayOrder
	else
		
		SELECT 
			GLAccountKey,
			AccountNumber,
			AccountName,
			Rollup,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			AccountType,
			Case AccountType
				When 10 then 'Bank'
				When 11 then 'AR'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'AP'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity Does Not Close'
				When 31 then 'Equity Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'COGS'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeName,
			DisplayLevel
		FROM tGLAccount (nolock)
		WHERE
			CompanyKey = @CompanyKey and
			AccountType <= @MaxAccountType and
			AccountType >= @MinAccountType and
			(
			AccountNumber like @AccountNumber + '%' 
			Or
			AccountName like '%' + @AccountNumber + '%'
			) and
			Active = 1
		And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		ORDER BY
			DisplayOrder
GO
