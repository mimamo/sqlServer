USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFormGetAssocProjects]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFormGetAssocProjects]
  @UserKey int
 ,@FormDefKey int
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN
*/

 DECLARE @CompanyKey INT
 
 SELECT  @CompanyKey = OwnerCompanyKey
 FROM    tUser (NOLOCK)
 WHERE UserKey = @UserKey
 
 IF @CompanyKey IS NULL
  SELECT  @CompanyKey = CompanyKey
  FROM    tUser (NOLOCK)
  WHERE UserKey = @UserKey
    
 SELECT isnull(p.ProjectNumber+' \ ','') + ISNULL(LEFT(c.CompanyName,15)+' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject, p.ProjectKey
 FROM tAssignment a (nolock)
	INNER JOIN tProject p (nolock) ON a.ProjectKey =p.ProjectKey
    LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey =c.CompanyKey
 WHERE a.UserKey  =@UserKey
 AND  p.Active  =1
 AND  p.Deleted  =0
 AND     p.CompanyKey    = @CompanyKey -- Limit to the user's company
 and     p.ProjectKey in (select ProjectKey from tForm where FormDefKey = @FormDefKey)
 ORDER BY ClientProject ASC
 
 RETURN 1
GO
