USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalRecall]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalRecall]
	(
		@ApprovalKey int
	)

AS --Encrypt

DELETE FROM 
 tApprovalItemReply
WHERE
 ApprovalItemKey in (
  SELECT ApprovalItemKey
  FROM tApprovalItem (nolock)
  WHERE ApprovalKey = @ApprovalKey
  )
  
 UPDATE tApproval
 SET DateSent = NULL, Status = 0, ActiveApprover = NULL
 WHERE ApprovalKey = @ApprovalKey
 
 
 Update tApprovalList
 Set Completed = 0 
 Where ApprovalKey = @ApprovalKey
GO
