USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormUserList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormUserList]
 (
  @CompanyKey int,
  @UserKey int
 )
AS --Encrypt

  /*
  || When     Who Rel   What
  || 6/4/2007 GWG 8.5   Removed the ViewAll option so that all forms that a user has rights to see
  */

/*
IF @ViewAll = 0
	SELECT 
	 tFormDef.FormDefKey, 
	 tFormDef.FormName, 
	 tFormDef.Description
	FROM 
	 tFormDef (NOLOCK) LEFT OUTER JOIN tForm (NOLOCK) ON 
	     tFormDef.FormDefKey = tForm.FormDefKey
	WHERE 
	 tFormDef.CompanyKey = @CompanyKey AND
	 tForm.AssignedTo = @UserKey AND
	 tFormDef.Active = 1
	GROUP BY 
	 tFormDef.FormDefKey, 
	 tFormDef.FormName, 
	 tFormDef.Description
	ORDER BY
	 tFormDef.FormName
ELSE
*/
	SELECT 
	 tFormDef.FormDefKey, 
	 tFormDef.FormName, 
	 tFormDef.Description
 FROM tFormDef (nolock) inner join tSecurityAccess sa (nolock) on tFormDef.FormDefKey = sa.EntityKey
      inner join tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
	WHERE 
	 tFormDef.CompanyKey = @CompanyKey AND
	 tFormDef.Active = 1 and
	 us.UserKey = @UserKey and
	 sa.Entity = 'tFormDef' and
	 sa.CompanyKey = @CompanyKey	 
	ORDER BY
	 tFormDef.FormName
GO
