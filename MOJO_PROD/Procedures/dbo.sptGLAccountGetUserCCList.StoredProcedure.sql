USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetUserCCList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetUserCCList]
	(
	@UserKey int
	,@BoughtByKey int
	,@Active int = 1
    ,@GLAccountKey int = 0
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When      Who Rel     What
|| 8/31/11   GHL 10.547  Created for credit card entry screen
|| 10/8/12   GHL 10.561  Taking in account tGLAccount.RestrictToGLCompany
|| 04/09/15  WDF 10.591  (251643) For the CC Edit screen, the invoice's @GLAccountKey is sent to insure the  
                         record is returned in case the @BoughtByKey is no longer a 'user' of that Account. 
*/

if @Active = 1

	select  gla.*
	       ,gla.AccountNumber + ' - ' + gla.AccountName as FormattedName
	from    tGLAccount gla (nolock) 
		inner join tGLAccountUser glau (nolock) on gla.GLAccountKey = glau.GLAccountKey 
	where glau.UserKey = @BoughtByKey -- get the credit cards for the user who is buying
	and   gla.Active = 1 
	And   (isnull(gla.RestrictToGLCompany, 0) = 0 -- but check gl companies for the current user
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
	UNION
	select  gla.*
           ,gla.AccountNumber + ' - ' + gla.AccountName as FormattedName
      from tGLAccount gla (nolock) inner join tUser u (nolock) on (u.CompanyKey = gla.CompanyKey and
                                                                   u.UserKey = @UserKey)
     where gla.GLAccountKey = @GLAccountKey
	   and gla.Active = 1 
	   and   (isnull(gla.RestrictToGLCompany, 0) = 0 -- but check gl companies for the current user
						Or 
						gla.GLAccountKey in (
							   select glca.EntityKey 
							   from tGLCompanyAccess glca (nolock) 
									inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
								where glca.Entity = 'tGLAccount'
								and  uglca.UserKey = @UserKey
							  )
					  )
	order by gla.AccountNumber + ' - ' + gla.AccountName

else

	select  gla.*
	       ,gla.AccountNumber + ' - ' + gla.AccountName as FormattedName
	from    tGLAccount gla (nolock) 
		inner join tGLAccountUser glau (nolock) on gla.GLAccountKey = glau.GLAccountKey 
	where glau.UserKey = @UserKey
	And   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
	order by gla.AccountNumber + ' - ' + gla.AccountName

	RETURN 1
GO
