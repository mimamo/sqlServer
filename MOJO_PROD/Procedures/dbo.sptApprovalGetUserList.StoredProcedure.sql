USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetUserList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetUserList]
 (
  @UserKey int
 )
AS --Encrypt
SELECT 
 tProject.ProjectNumber,
 tProject.ProjectKey,
 tProject.ProjectName,
 tApproval.ApprovalKey, 
 tApproval.Subject, 
 tApproval.Description, 
 tApproval.Status,
 tApproval.DueDate,
 tApproval.DateSent
FROM tApproval (nolock) 
	INNER JOIN tApprovalList (nolock) ON tApproval.ApprovalKey = tApprovalList.ApprovalKey
    inner join tProject (nolock) on tApproval.ProjectKey = tProject.ProjectKey
WHERE 
	((
	tApproval.ApprovalOrderType = 2 AND			-- Send In Order
	tApproval.ActiveApprover = @UserKey AND 
    tApprovalList.UserKey = @UserKey AND 
	tApproval.Status = 1
 ) OR (
	tApproval.ApprovalOrderType = 1 AND			-- Send At Once 
    tApprovalList.UserKey = @UserKey AND
	tApproval.Status = 1 
	)) 
AND
	tApprovalList.Completed = 0
ORDER BY 
	tApproval.DueDate
GO
