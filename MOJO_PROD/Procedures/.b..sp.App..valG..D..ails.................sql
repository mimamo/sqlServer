USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetDetails]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetDetails]
 (
  @ApprovalKey int
 )
AS --Encrypt
SELECT 
 tApproval.ApprovalKey, 
 tApproval.Subject, 
    tApproval.Description, 
    tApproval.DueDate, 
    tApproval.ApprovalOrderType, 
    tApproval.ActiveApprover, 
    tApproval.DateCreated, 
    tApproval.DateSent, 
    tApprovalItem.ApprovalItemKey, 
    tApprovalItem.ItemName, 
    tApprovalItem.Description AS ItemDescription
FROM 
 tApproval (nolock) INNER JOIN tApprovalItem (nolock) ON 
    tApproval.ApprovalKey = tApprovalItem.ApprovalKey
WHERE 
 tApproval.ApprovalKey = @ApprovalKey
ORDER BY 
 tApprovalItem.ApprovalItemKey
GO
