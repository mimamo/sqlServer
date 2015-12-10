USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefGetActiveList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefGetActiveList]

  @CompanyKey int
 ,@UserKey int
 ,@FormDefKey int = null
 
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

 SELECT	fd.*
 FROM	tFormDef fd (nolock) 
 INNER JOIN tSecurityAccess sa (nolock) ON fd.FormDefKey = sa.EntityKey
 INNER JOIN tUser us (nolock) ON sa.SecurityGroupKey = us.SecurityGroupKey
 WHERE  fd.CompanyKey = @CompanyKey 
 AND	(fd.Active = 1 OR fd.FormDefKey = @FormDefKey)
 AND	us.UserKey = @UserKey
 AND	sa.Entity = 'tFormDef'
 AND	sa.CompanyKey = @CompanyKey
 ORDER BY fd.WorkingLevel, fd.FormName
 
 RETURN 1
GO
