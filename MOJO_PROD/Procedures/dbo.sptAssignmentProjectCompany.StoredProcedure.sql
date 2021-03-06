USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentProjectCompany]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAssignmentProjectCompany]
 (
  @ProjectKey int
 )
AS --Encrypt
SELECT  tCompany.CompanyName, tCompany.CompanyKey
FROM  tAssignment (nolock) INNER JOIN
   tUser (nolock) ON tAssignment.UserKey = tUser.UserKey INNER JOIN
   tCompany (nolock) ON 
   tUser.CompanyKey = tCompany.CompanyKey
WHERE  tAssignment.ProjectKey = @ProjectKey
GROUP BY tCompany.CompanyName, tCompany.CompanyKey
ORDER BY tCompany.CompanyName
GO
