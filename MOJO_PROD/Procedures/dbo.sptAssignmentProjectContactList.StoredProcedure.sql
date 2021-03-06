USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentProjectContactList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAssignmentProjectContactList]
 (
  @ProjectKey int,
  @CompanyKey int
 )
AS --Encrypt
SELECT 
	tCompany.CompanyName + ' \ ' + tUser.FirstName + ' ' + tUser.LastName AS UserName, 
	tUser.FirstName,
  tUser.LastName,
  tCompany.CompanyName,
	tAssignment.*
FROM tAssignment (nolock) INNER JOIN
  tUser (nolock) ON tAssignment.UserKey = tUser.UserKey INNER JOIN
  tCompany (nolock) ON tUser.CompanyKey = tCompany.CompanyKey
WHERE tAssignment.ProjectKey = @ProjectKey AND
  tCompany.OwnerCompanyKey = @CompanyKey
ORDER BY tCompany.CompanyName, tUser.FirstName
GO
