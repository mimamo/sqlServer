USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReviewDeliverableDelete]
 @ReviewDeliverableKey int
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/27/11	MAS 10.5.4.8	Created
  || 09/26/12	QMD 10.5.6.0	Added additional tables to delete
  */

-- Delete any markup comments - tReviewCommentMarkup
Delete tReviewCommentMarkup Where ReviewCommentKey in (Select ReviewCommentKey from tReviewComment Where ReviewRoundKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey))


-- Delete any comments - tReviewComment 
Delete tReviewComment Where ReviewRoundKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)


-- Delete any files - tReviewRoundFile
Delete tReviewRoundFile Where ReviewRoundKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)


-- Delete Log entries -  ???????
Delete tReviewLog Where ReviewRoundKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)


-- Delete the ApprovalStep Approval users
Delete us 
from tApprovalStepUser us (nolock)
Join tApprovalStep s (nolock) on s.ApprovalStepKey = us.ApprovalStepKey
Where s.Entity = 'tReviewRound' And s.EntityKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)


-- Delete the ApprovalStep Notify users
Delete ns 
from tApprovalStepNotify ns (nolock)
Join tApprovalStep s (nolock) on s.ApprovalStepKey = ns.ApprovalStepKey
Where s.Entity = 'tReviewRound' And s.EntityKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)


-- Delete any steps - tApprovalStep
Delete tApprovalStep Where Entity = 'tReviewRound' And EntityKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)

-- Delete the round
Delete tReviewRound Where ReviewRoundKey in (Select ReviewRoundKey from tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)




 Delete 
 From tReviewDeliverable
 Where ReviewDeliverableKey = @ReviewDeliverableKey
 
 Return 1
GO
