USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalListDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalListDelete]
 @ApprovalKey int,
 @UserKey int

AS --Encrypt

/*
|| When     Who Rel   What
|| 4/2/07   GWG 8.5   Added the removal of a persons replies when they are deleted from the list
|| 3/30/11  RLB 10542 (107468) when removing a person check and see if all others have completed if so complete the review
*/

Declare @Order int, @MinStatus int,  @ApprovalOrderType smallint
	

SELECT	@ApprovalOrderType = ApprovalOrderType
FROM	tApproval (nolock)
WHERE	ApprovalKey = @ApprovalKey

Select @Order = ApprovalOrder from tApprovalList (nolock) Where ApprovalKey = @ApprovalKey and UserKey = @UserKey
Delete tApprovalList Where ApprovalKey = @ApprovalKey and UserKey = @UserKey

DELETE FROM 
 tApprovalItemReply
WHERE
 ApprovalItemKey in (
  SELECT ApprovalItemKey
  FROM tApprovalItem (nolock)
  WHERE ApprovalKey = @ApprovalKey
  )
 AND UserKey = @UserKey

Update tApprovalList
Set ApprovalOrder = ApprovalOrder - 1 Where ApprovalKey = @ApprovalKey and ApprovalOrder > @Order

SELECT	@MinStatus = MIN(tApprovalList.Completed)
	FROM	tApproval (nolock) 
		INNER JOIN tApprovalList (nolock) ON tApproval.ApprovalKey = tApprovalList.ApprovalKey
	WHERE	tApproval.ApprovalKey = @ApprovalKey
	GROUP BY tApproval.ApprovalKey

IF @ApprovalOrderType = 1
BEGIN
	IF @MinStatus = 1
		UPDATE	tApproval
		SET		Status = 2
		WHERE	ApprovalKey = @ApprovalKey
END
ELSE
BEGIN
	IF @MinStatus = 1
		UPDATE	tApproval
		SET		Status = 2, ActiveApprover = null
		WHERE	ApprovalKey = @ApprovalKey

END


 RETURN 1
GO
