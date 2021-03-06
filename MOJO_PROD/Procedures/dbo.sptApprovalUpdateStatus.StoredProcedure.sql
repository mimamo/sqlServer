USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalUpdateStatus]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalUpdateStatus]
 (
  @ApprovalKey int,
  @UserKey int
 )
AS --Encrypt

/*
	Who		When		What
	GHL		04/03/2006	Setting now the approval as completed
						as soon as somebody rejects when they approve in order
*/


Declare 
 @CurrentUserKey int,
 @NextUserKey int,
 @ApprovalOrderType smallint,
 @MinStatus int,
 @OrderPosition int
 
SELECT	@CurrentUserKey = ActiveApprover,
		@ApprovalOrderType = ApprovalOrderType
FROM	tApproval (nolock)
WHERE	ApprovalKey = @ApprovalKey
 
-- Update the completed status for this user
UPDATE	tApprovalList
SET		Completed = 1
WHERE	ApprovalKey = @ApprovalKey 
AND		UserKey = @UserKey
 
-- Send to everyone at once
IF @ApprovalOrderType = 1
BEGIN 
	-- Check if everyone has responded and update the package status
	SELECT	@MinStatus = MIN(tApprovalList.Completed)
	FROM	tApproval (nolock) 
		INNER JOIN tApprovalList (nolock) ON tApproval.ApprovalKey = tApprovalList.ApprovalKey
	WHERE	tApproval.ApprovalKey = @ApprovalKey
	GROUP BY tApproval.ApprovalKey
 
	IF @MinStatus = 1
		UPDATE	tApproval
		SET		Status = 2
		WHERE	ApprovalKey = @ApprovalKey
 
END
ELSE
BEGIN
	-- Approve in a certain order
	  
	-- Determine the position of the current approver
	SELECT	@OrderPosition = ApprovalOrder
	FROM	tApprovalList (nolock)
	WHERE	ApprovalKey = @ApprovalKey
	AND		UserKey = @CurrentUserKey
 
	-- Determine if any item was rejected
	If NOT exists(Select 1 from tApprovalItemReply air (nolock) 
		Where ApprovalItemKey in 
			(SELECT ApprovalItemKey FROM tApprovalItem (nolock) WHERE ApprovalKey = @ApprovalKey )
		and UserKey = @UserKey and Status = 4)
	BEGIN
		-- None has been rejected
		
		-- Get the next approver
		SELECT	@NextUserKey = UserKey
		FROM	tApprovalList (nolock)
		WHERE	ApprovalKey = @ApprovalKey
		AND		ApprovalOrder = @OrderPosition + 1

		-- If there is no next approver set the status of the package to complete
		IF @NextUserKey IS NULL
			UPDATE	tApproval
			SET		Status = 2,
					ActiveApprover = NULL
			WHERE	ApprovalKey = @ApprovalKey
	 
		-- Otherwise, set the next user
		ELSE
			UPDATE	tApproval
			SET		ActiveApprover = @NextUserKey
			WHERE	ApprovalKey = @ApprovalKey

	END 
	ELSE
	BEGIN
		-- As soon as one item has been rejected by any approver, set the approval as completed
		-- since the next approvers can only approve if earlier approvers have not rejected
		-- Added by GHL on 04/03/2006
		UPDATE	tApproval
		SET		Status = 2
		WHERE	ApprovalKey = @ApprovalKey
	
	END
	 
END
GO
