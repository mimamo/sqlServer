USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalListInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalListInsert]
 @ApprovalKey int,
 @UserKey int
AS --Encrypt

/*
|| When     Who Rel  What
|| 4/2/07   GWG 8.5  If the person is added after the review has been sent, add the reply records
*/

declare  @ApprovalOrder int

if exists(select 1 from tApprovalList (nolock) Where ApprovalKey = @ApprovalKey and UserKey = @UserKey)
	return -1
Select @ApprovalOrder = Max(ApprovalOrder) from tApprovalList (nolock) Where ApprovalKey = @ApprovalKey
Select @ApprovalOrder = ISNULL(@ApprovalOrder, 0) + 1

 INSERT tApprovalList
  (
  ApprovalKey,
  UserKey,
  ApprovalOrder
  )
 VALUES
  (
  @ApprovalKey,
  @UserKey,
  @ApprovalOrder
  )
 
 
 
 
 -- If the approval has been sent, then insert the reply keys
if exists(Select 1 from tApproval (nolock) Where ApprovalKey = @ApprovalKey and Status = 1)
	INSERT INTO tApprovalItemReply
		(ApprovalItemKey, UserKey, Status)
	SELECT ApprovalItemKey, @UserKey, 0
	FROM tApprovalItem (nolock)
	WHERE ApprovalKey = @ApprovalKey
 
 RETURN 1
GO
