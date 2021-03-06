USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountValidAccount]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountValidAccount]

	(
		@CompanyKey int,
		@AccountNumber varchar(100),
		@AccountType smallint,      -- 0 All
		@Rollup smallint,           -- 0 Rollup = 0, 1 Rollup = 1, 2 All
		@UserKey int = null,
		@GLCompanyKey int = null
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 08/15/12  GHL 10.559  Added checking of tGLAccount.RestrictToGLCompany
*/

-- check @RestrictGLCompany at the company level because the only way to correct a problem on the GL account maintenance screen
-- is to have that flag set
Declare @RestrictToGLCompany int
Select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

Declare @GLAccountKey int

if @RestrictToGLCompany = 0
	Select @GLAccountKey = GLAccountKey
	From tGLAccount (nolock)
	Where CompanyKey = @CompanyKey  
	and (@AccountType <= 0 Or AccountType = @AccountType)
	and (@Rollup = 2 Or Rollup = @Rollup)
	and AccountNumber = @AccountNumber 
	and Active = 1
else
begin
	-- if the company key is null or 0, check user (report mode) 
	if isnull(@GLCompanyKey, 0) = 0
		Select @GLAccountKey = GLAccountKey
		From tGLAccount (nolock)
		Where CompanyKey = @CompanyKey  
		and (@AccountType <= 0 Or AccountType = @AccountType)
		and (@Rollup = 2 Or Rollup = @Rollup)
		and AccountNumber = @AccountNumber 
		and Active = 1	
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
	else
		-- if the company is not null, check gl company (we are in transaction mode)
		Select @GLAccountKey = GLAccountKey
		From tGLAccount (nolock)
		Where CompanyKey = @CompanyKey  
		and (@AccountType <= 0 Or AccountType = @AccountType)
		and (@Rollup = 2 Or Rollup = @Rollup)
		and AccountNumber = @AccountNumber 
		and Active = 1	
		And   (isnull(tGLAccount.RestrictToGLCompany, 0) = 0
					Or 
					tGLAccount.GLAccountKey in (
                           select glca.EntityKey 
						   from   tGLCompanyAccess glca (nolock) 
							where glca.Entity = 'tGLAccount'
							and   glca.GLCompanyKey = @GLCompanyKey
						  )
				  )

end

return isnull(@GLAccountKey, 0)
GO
