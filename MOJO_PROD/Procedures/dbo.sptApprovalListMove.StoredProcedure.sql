USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalListMove]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalListMove]
 @ApprovalKey int,
 @UserKey int,
 @Direction smallint

AS --Encrypt

/**************************************************************************************************************
CRG 9/13/06 -	Now that the order can be changed after it's sent, I have added validation to make sure that 
				the move doesn't change the order of the current approver, or ones that have already been approved.
**************************************************************************************************************/

Declare @Order int, @OtherKey int
Declare @ApprovalOrderType smallint, @CurrentApprovalPos int, @OtherApprovalPos int

--Get the Order Type for the approval:
-- 1 All At Once
-- 2 Approval In Order
SELECT	@ApprovalOrderType = ApprovalOrderType
FROM	tApproval (nolock)
WHERE	ApprovalKey = @ApprovalKey

IF @ApprovalOrderType = 2 --Get the current approval position
	SELECT	@CurrentApprovalPos = ApprovalOrder
	FROM	tApprovalList al (nolock)
	INNER JOIN tApproval a (nolock) on al.ApprovalKey = a.ApprovalKey and al.UserKey = a.ActiveApprover
	WHERE	a.ApprovalKey = @ApprovalKey

Select @Order = ApprovalOrder from tApprovalList (nolock) Where ApprovalKey = @ApprovalKey and UserKey = @UserKey
Select @OtherKey = UserKey from tApprovalList (nolock) Where ApprovalKey = @ApprovalKey and ApprovalOrder = @Order + @Direction

if @OtherKey is Null
	return

--If the Approvals need to be in order, and the "other" key is at or before the current approver, don't allow it	
IF @ApprovalOrderType = 2 
BEGIN
	SELECT	@OtherApprovalPos = ApprovalOrder
	FROM	tApprovalList (nolock)
	WHERE	ApprovalKey = @ApprovalKey
	AND		UserKey = @OtherKey

	IF @OtherApprovalPos <= @CurrentApprovalPos
		RETURN
END

Update tApprovalList Set ApprovalOrder = @Order + @Direction Where ApprovalKey = @ApprovalKey and UserKey = @UserKey
Update tApprovalList Set ApprovalOrder = @Order Where ApprovalKey = @ApprovalKey and UserKey = @OtherKey
	
RETURN 1
GO
