USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalDelete]
 @ApprovalKey int
AS --Encrypt
Declare @MaxStatus int
 SELECT @MaxStatus = MAX(tApprovalItemReply.Status)
 FROM 
  tApproval (nolock) INNER JOIN tApprovalItem (nolock) ON 
     tApproval.ApprovalKey = tApprovalItem.ApprovalKey INNER JOIN
     tApprovalItemReply (nolock) ON tApprovalItem.ApprovalItemKey = tApprovalItemReply.ApprovalItemKey
 GROUP BY tApproval.ApprovalKey
 HAVING tApproval.ApprovalKey = @ApprovalKey
 
 SELECT @MaxStatus = ISNULL(@MaxStatus, 0) -- This will tie the min response in with the status on the listing page
 
 IF @MaxStatus = 0
 BEGIN
  DELETE
  FROM tApprovalList
  WHERE
   ApprovalKey = @ApprovalKey 
  DELETE
  FROM tApprovalItemReply
  WHERE
   ApprovalItemKey in (
    Select ApprovalItemKey 
    FROM tApprovalItem 
    Where ApprovalKey = @ApprovalKey)
  DELETE
  FROM tApprovalItem
  WHERE
   ApprovalKey = @ApprovalKey 
  DELETE
  FROM tApproval
  WHERE
   ApprovalKey = @ApprovalKey 
  RETURN 1
 END
 ELSE
  RETURN -1
GO
