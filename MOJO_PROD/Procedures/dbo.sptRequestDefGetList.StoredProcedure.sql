USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefGetList]

	@CompanyKey int,
	@Active tinyint = NULL,
	@UserKey int = NULL


AS --Encrypt

/*
|| When     Who Rel   What
|| 10/17/06 CRG 8.35  Added the UserKey parameter to restrict the RequestDefs to a particular user
*/

IF @UserKey IS NULL
BEGIN
	If @Active is null
		SELECT *,
			Case Active When 1 then 'YES' else 'NO' end as ActiveText
		FROM tRequestDef (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey
		Order By Active DESC, RequestName
	else
		SELECT *,
			Case Active When 1 then 'YES' else 'NO' end as ActiveText
		FROM tRequestDef (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey and Active = @Active
		Order By RequestName
END
ELSE
BEGIN
	If @Active is null
		SELECT	rd.*,
				Case rd.Active When 1 then 'YES' else 'NO' end as ActiveText
		FROM	tRequestDef rd (NOLOCK) 
		INNER JOIN tSecurityAccess sa (nolock) ON rd.RequestDefKey = sa.EntityKey
	    INNER JOIN tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
		WHERE	rd.CompanyKey = @CompanyKey
		AND		sa.CompanyKey = @CompanyKey
		AND		sa.Entity = 'tRequestDef'
		AND		us.UserKey = @UserKey		
		Order By rd.Active DESC, RequestName
	else
		SELECT	rd.*,
				Case rd.Active When 1 then 'YES' else 'NO' end as ActiveText
		FROM	tRequestDef rd (NOLOCK) 
		INNER JOIN tSecurityAccess sa (nolock) ON rd.RequestDefKey = sa.EntityKey
	    INNER JOIN tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
		WHERE	rd.CompanyKey = @CompanyKey
		AND		sa.CompanyKey = @CompanyKey
		AND		sa.Entity = 'tRequestDef'
		AND		us.UserKey = @UserKey
		AND		rd.Active = @Active		
		Order By RequestName
END


	RETURN 1
GO
