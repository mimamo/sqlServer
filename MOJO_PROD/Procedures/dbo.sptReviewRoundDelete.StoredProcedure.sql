USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReviewRoundDelete]
 @ReviewRoundKey int
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/15/11	MAS 10.5.4.8	Created for ArtReview
  || 09/20/12   GWG 10.5.6.0    Open up the delete so you can delete cancelled rounds
  */

Declare @ReviewDeliverableKey INT

-- First things first - Check to see if any of the rounds have been started
-- if so, return an error.
if exists(select 1 from tReviewRound (nolock) Where ReviewRoundKey = @ReviewRoundKey And DateSent IS NOT NULL and CancelledDate IS NULL)
	return -1
	
select @ReviewDeliverableKey = ReviewDeliverableKey 
from tReviewRound (nolock) Where ReviewRoundKey = @ReviewRoundKey


-- Delete any comments - tReviewComment 
Delete tReviewComment Where ReviewRoundKey = @ReviewRoundKey


-- Delete any files - tReviewRoundFile
Delete tReviewRoundFile Where ReviewRoundKey = @ReviewRoundKey


-- Delete Log entries -  ???????
Delete tReviewLog Where ReviewRoundKey = @ReviewRoundKey


-- Delete the ApprovalStep Approval users
Delete us 
from tApprovalStepUser us (nolock)
Join tApprovalStep s (nolock) on s.ApprovalStepKey = us.ApprovalStepKey
Where s.Entity = 'tReviewRound' And s.EntityKey = @ReviewRoundKey


-- Delete the ApprovalStep Notify users
Delete ns 
from tApprovalStepNotify ns (nolock)
Join tApprovalStep s (nolock) on s.ApprovalStepKey = ns.ApprovalStepKey
Where s.Entity = 'tReviewRound' And s.EntityKey = @ReviewRoundKey


-- Delete any steps - tApprovalStep
Delete tApprovalStep Where Entity = 'tReviewRound' And EntityKey = @ReviewRoundKey

-- Delete the round
Delete tReviewRound Where ReviewRoundKey = @ReviewRoundKey

Update tReviewRound Set LatestRound = 0 where ReviewDeliverableKey = @ReviewDeliverableKey
Update tReviewRound Set LatestRound = 1 where ReviewRoundKey in (SELECT MAX(ReviewRoundKey) FROM tReviewRound (nolock) Where ReviewDeliverableKey = @ReviewDeliverableKey)

exec sptReviewRoundUpdateSequence @ReviewDeliverableKey
Return 1
GO
