USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentProjectEmployeeList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAssignmentProjectEmployeeList]
 (
  @ProjectKey int,
  @CompanyKey int
 )
AS --Encrypt
SELECT tUser.FirstName + ' ' + tUser.LastName
  AS UserName, 
  tUser.FirstName,
  tUser.LastName,
  tAssignment.*
FROM tAssignment (nolock) INNER JOIN
  tUser (nolock) ON tAssignment.UserKey = tUser.UserKey INNER JOIN
  tCompany (nolock) ON tUser.CompanyKey = tCompany.CompanyKey
WHERE tAssignment.ProjectKey = @ProjectKey AND
  tCompany.CompanyKey = @CompanyKey
ORDER BY tUser.LastName
GO
