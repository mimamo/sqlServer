USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalSend]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalSend]
 (
  @ApprovalKey int
 )
AS --Encrypt
Declare @ApprovalOrderType smallint
Declare @FirstUser int
-- If no items have been added, don't let them send
IF NOT EXISTS(
 SELECT 1
 FROM
  tApprovalItem (nolock)
 WHERE
  ApprovalKey = @ApprovalKey
 AND
  ISNULL(Visible, 1) = 1 
  )
 
 RETURN -1
-- If no people have been selected, do not let them send
IF NOT EXISTS(
 SELECT 1
 FROM
  tApprovalList (nolock)
 WHERE
  ApprovalKey = @ApprovalKey)
 
 RETURN -2
-- Remove any replies if they should be there for any reason
DELETE FROM 
 tApprovalItemReply
WHERE
 ApprovalItemKey in (
  SELECT ApprovalItemKey
  FROM tApprovalItem (nolock)
  WHERE ApprovalKey = @ApprovalKey
  )
-- Insert all people into the reply table so that response records are there
INSERT INTO tApprovalItemReply
    (ApprovalItemKey, UserKey, Status)
 SELECT 
  tApprovalItem.ApprovalItemKey, 
     tApprovalList.UserKey,
  0
 FROM tApproval (nolock) LEFT OUTER JOIN tApprovalList (nolock) ON 
    tApproval.ApprovalKey = tApprovalList.ApprovalKey LEFT OUTER JOIN
    tApprovalItem (nolock) ON tApproval.ApprovalKey = tApprovalItem.ApprovalKey
 WHERE tApproval.ApprovalKey = @ApprovalKey
-- Determine the Sending Type
SELECT
 @ApprovalOrderType = ApprovalOrderType
FROM
 tApproval (nolock)
WHERE
 ApprovalKey = @ApprovalKey
-- If send in order, update the package with the active user
IF @ApprovalOrderType = 2
BEGIN
 SELECT 
  @FirstUser = UserKey
 FROM 
  tApprovalList (nolock)
 WHERE 
  ApprovalKey = @ApprovalKey AND 
  ApprovalOrder = 1
 UPDATE tApproval
 SET DateSent = GETDATE(), Status = 1, ActiveApprover = @FirstUser
 WHERE ApprovalKey = @ApprovalKey
END
ELSE
BEGIN
 UPDATE tApproval
 SET DateSent = GETDATE(), Status = 1, ActiveApprover = NULL
 WHERE ApprovalKey = @ApprovalKey
END
RETURN 1
GO
