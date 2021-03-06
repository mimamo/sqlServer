USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundReActivate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundReActivate]
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/25/12	QMD 10.5.6.0	Created to get re-activate a completed round and approved deliverable.
  */
  
	DECLARE @ReviewDeliverableKey INT
	DECLARE @MaxApprovalStepKey INT
	
	SELECT @ReviewDeliverableKey = ReviewDeliverableKey FROM tReviewRound (NOLOCK) WHERE ReviewRoundKey = @ReviewRoundKey
	
	UPDATE	tReviewRound
	SET		Status = 2 --sent
	WHERE	ReviewRoundKey = @ReviewRoundKey
	
	UPDATE  tReviewDeliverable
	SET		Approved = 0, ApprovedDate = NULL, ReActivatedDate = GETDATE()
	WHERE	ReviewDeliverableKey = @ReviewDeliverableKey
			AND Approved = 1
			
	SELECT @MaxApprovalStepKey = MAX(ApprovalStepKey) FROM tApprovalStep WHERE Entity = 'tReviewRound' AND EntityKey = @ReviewRoundKey
	
	UPDATE	tApprovalStep
	SET		Pause = 1, Paused = 1
	WHERE	ApprovalStepKey = @MaxApprovalStepKey
GO
