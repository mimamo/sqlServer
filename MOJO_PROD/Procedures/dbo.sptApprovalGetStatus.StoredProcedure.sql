USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetStatus]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetStatus]
 (
  @ApprovalKey int
 )
AS --Encrypt
SELECT 
	a.ApprovalKey, 
	a.ProjectKey,
	a.Subject, 
    a.Description, 
    a.DueDate, 
    a.ApprovalOrderType, 
    a.Status, 
    a.DateCreated, 
    a.DateSent, 
    ai.ItemName, 
    ai.Description AS ItemDescription, 
    ai.ApprovalItemKey, 
    u1.FirstName + ' ' + u1.LastName AS ActiveApproverName,
    u.FirstName + ' ' + u.LastName AS ApprovalUser, 
    air.Status AS ReplyStatus, 
    air.Comments, 
    air.ApprovalItemReplyKey, 
    al.ApprovalOrder
FROM 
	tApproval a (nolock)
	INNER JOIN tApprovalItem ai (nolock) ON a.ApprovalKey = ai.ApprovalKey 
	INNER JOIN tApprovalItemReply air (nolock) ON ai.ApprovalItemKey = air.ApprovalItemKey
    INNER JOIN tUser u (nolock) ON air.UserKey = u.UserKey 
    INNER JOIN tApprovalList al (nolock) ON ai.ApprovalKey = al.ApprovalKey AND 
    air.UserKey = al.UserKey 
    LEFT OUTER JOIN tUser u1 (nolock) ON a.ActiveApprover = u1.UserKey
WHERE
	a.ApprovalKey = @ApprovalKey
ORDER BY 
	ai.ApprovalItemKey, al.ApprovalOrder
GO
