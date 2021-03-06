USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetEmails]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetEmails]
 (
  @ApprovalKey int
 )
As --Encrypt
Declare 
 @ApprovalOrderType smallint,
 @CurrentUserKey int,
 @CompletionStatus smallint
 
SELECT 
 @CurrentUserKey = ActiveApprover,
 @ApprovalOrderType = ApprovalOrderType,
 @CompletionStatus = Status
FROM
 tApproval (nolock)
WHERE
 ApprovalKey = @ApprovalKey
 
IF @ApprovalOrderType = 1
 SELECT 
  tUser.FirstName, 
  tUser.LastName, 
  tUser.Email
 FROM 
  tApprovalList (nolock) INNER JOIN tUser (nolock) ON tApprovalList.UserKey = tUser.UserKey
 WHERE 
  tApprovalList.ApprovalKey = @ApprovalKey and Completed = 0
ELSE
BEGIN
  
 IF @CompletionStatus = 1
  SELECT 
   tUser.FirstName, 
   tUser.LastName, 
   tUser.Email
  FROM 
   tApproval (nolock) INNER JOIN tUser (nolock) ON tApproval.ActiveApprover = tUser.UserKey
  WHERE 
   tApproval.ApprovalKey = @ApprovalKey
END
GO
