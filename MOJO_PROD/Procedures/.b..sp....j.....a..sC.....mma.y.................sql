USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusCodeSummary]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectStatusCodeSummary]

	(
		@UserKey int
	)

AS --Encrypt

SELECT 
	tProjectStatus.ProjectStatusKey, 
    tProjectStatus.ProjectStatus, 
	COUNT(tProject.ProjectKey) AS ProjectCount, 
	tProjectStatus.DisplayOrder
FROM 
	tProject (NOLOCK) INNER JOIN tProjectStatus (NOLOCK) ON 
    tProject.ProjectStatusKey = tProjectStatus.ProjectStatusKey 
    INNER JOIN tAssignment (NOLOCK) ON 
    tProject.ProjectKey = tAssignment.ProjectKey
WHERE 
	tProject.Active = 1 AND 
	tAssignment.UserKey = @UserKey AND 
    tProject.Deleted = 0
GROUP BY 
	tProjectStatus.ProjectStatus, 
    tProjectStatus.ProjectStatusKey, 
    tProjectStatus.DisplayOrder
ORDER BY 
	tProjectStatus.DisplayOrder
GO
