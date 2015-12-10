USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentEmployeeProjectList]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAssignmentEmployeeProjectList]
 (
  @UserKey int,
  @CompanyKey int
 )
AS --Encrypt

SELECT tProject.ProjectKey
	  ,tProject.ProjectNumber
	  ,tProject.ProjectName
	  ,tAssignment.HourlyRate
	  ,tAssignment.AssignmentKey
FROM tAssignment (NOLOCK)
INNER JOIN tProject (NOLOCK) ON tAssignment.ProjectKey = tProject.ProjectKey
WHERE tAssignment.UserKey = @UserKey 
AND   tProject.CompanyKey = @CompanyKey
GO
