USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefGetListAccess]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefGetListAccess]

	@CompanyKey int,
	@Active tinyint = NULL,
	@UserKey int	

AS --Encrypt

If @Active is null
	SELECT rd.*,
		Case rd.Active When 1 then 'YES' else 'NO' end as ActiveText
	FROM tRequestDef rd (NOLOCK) inner join tSecurityAccess sa (nolock) on rd.RequestDefKey = sa.EntityKey
	     inner join tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
	WHERE rd.CompanyKey = @CompanyKey
	  and sa.CompanyKey = @CompanyKey
	  and sa.Entity = 'tRequestDef'
	  and us.UserKey = @UserKey
	Order By rd.Active DESC, rd.RequestName
else
	SELECT rd.*,
		Case rd.Active When 1 then 'YES' else 'NO' end as ActiveText
	FROM tRequestDef rd (NOLOCK) inner join tSecurityAccess sa (nolock) on rd.RequestDefKey = sa.EntityKey
	     inner join tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
	WHERE rd.CompanyKey = @CompanyKey
	  and sa.CompanyKey = @CompanyKey
	  and sa.Entity = 'tRequestDef'
	  and us.UserKey = @UserKey
	  and rd.Active = @Active
	Order By rd.Active DESC, rd.RequestName

	RETURN 1
GO
