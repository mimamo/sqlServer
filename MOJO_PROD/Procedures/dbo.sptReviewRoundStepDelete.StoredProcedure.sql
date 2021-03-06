USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundStepDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReviewRoundStepDelete]
 @ApprovalStepKey int
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/27/11	MAS 10.5.4.8	Created for ArtReview
  || 01/28/13   RLB 10.5.6.4    Update Display Order after approval step delete
  */

Declare @EntityKey int

Select @EntityKey = EntityKey From tApprovalStep Where ApprovalStepKey = @ApprovalStepKey

-- First things first - Check to see if the round has been started - if so, return an error.
if exists(select 1 from tReviewRound Where ReviewRoundKey = @EntityKey And DateSent IS NOT NULL)
	return -1

-- Delete the ApprovalStep Approval users
Delete tApprovalStepUser Where ApprovalStepKey = @ApprovalStepKey

-- Delete the ApprovalStep Notify users
Delete tApprovalStepNotify Where ApprovalStepKey = @ApprovalStepKey

-- Delete any steps - tApprovalStep
Delete tApprovalStep Where ApprovalStepKey = @ApprovalStepKey

Declare @CurrentApprovalStepKey int, @NewDisplayOrder int

select @CurrentApprovalStepKey = -1, @NewDisplayOrder = 0
While(1=1)
BEGIN
	Select @CurrentApprovalStepKey = Min(ApprovalStepKey)
	From tApprovalStep (nolock)
	Where ApprovalStepKey > @CurrentApprovalStepKey and Entity = 'tReviewRound' and EntityKey = @EntityKey
	
	IF @CurrentApprovalStepKey IS NULL
			BREAK

	select @NewDisplayOrder = @NewDisplayOrder + 1

	update tApprovalStep set DisplayOrder = @NewDisplayOrder
	where ApprovalStepKey = @CurrentApprovalStepKey

End
Return 1
GO
