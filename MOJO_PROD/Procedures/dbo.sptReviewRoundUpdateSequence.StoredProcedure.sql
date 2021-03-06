USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundUpdateSequence]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundUpdateSequence]
 @ReviewDeliverableKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/21/11	MAS 10.5.4.9    Created for new ArtReview - Updates the round sequence
  || 12/13/11   QMD 10.5.5.1    Added update for status 4
  || 01/10/11   QMD 10.5.5.2    Added update for LastCompletedRoundKey
  || 02/10/12   QMD 10.5.5.3    changed the status to included 3 - Rejected
  || 02/14/12   QMD 10.5.5.3    Added subquery for Action 2 (rejected)
  || 03/28/12   QMD 10.5.5.5    Added subquery Internal Review label
  || 04/16/13   QMD 10.5.6.7    Added logic for internal review counts vs round count
  || 06/07/13   QMD 10.5.6.7    Changed inner to left join for interal review label.
  || 03/17/14   QMD 10.5.7.8    Added Client Only Step clause.
  || 05/20/14   QMD 10.5.8.0    (216843) Added call to sptApprovalStepUpdateStatusNames
  */


-- TODO: tReviewRound.Status has NOT really been defined - I'm just picking 4 as canceled out of the air
-- TODO: Need to check if a Round can contain more than 1 internal step. If it does the logic to set the lastCompletedRoundKey
--		 will need to be updated.

If ISNULL(@ReviewDeliverableKey, 0) < 1 
	Return
	
-- update internal review count
UPDATE rr
SET rr.RoundName = t.NewRoundName
FROM tReviewRound rr (nolock)
INNER JOIN (SELECT tRR.ReviewRoundKey, 
				(SELECT 'Internal Review ' + CONVERT(Varchar(20), count(*) )
				 FROM    tReviewRound counter (nolock)
				 WHERE   counter.ReviewRoundKey <= tRR.ReviewRoundKey            
						 AND ReviewDeliverableKey = @ReviewDeliverableKey
						 AND Status <= 3 
						 AND ReviewRoundKey IN (
												SELECT	ReviewRoundKey
												FROM	tReviewRound r (NOLOCK) INNER JOIN tApprovalStep s (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND s.Entity = 'tReviewRound'
															LEFT JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
												WHERE	s.Internal = 1
														AND ((ISNULL(asu.Action,0) = 2 AND s.Completed = 1)
															OR (ISNULL(asu.Action,0) = 0) AND s.Completed = 0 
															OR (ISNULL(asu.Action,0) = 1) AND s.Completed = 1 AND ActiveStep = 0)
														AND r.ReviewDeliverableKey = @ReviewDeliverableKey
												)
				  ) AS NewRoundName
			 FROM   tReviewRound tRR (nolock)
			 WHERE  tRR.ReviewDeliverableKey = @ReviewDeliverableKey 
					AND Status <= 3 
					AND ReviewRoundKey IN (
											SELECT	ReviewRoundKey
											FROM	tReviewRound r (NOLOCK) INNER JOIN tApprovalStep s (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND s.Entity = 'tReviewRound'
														LEFT JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
											WHERE	s.Internal = 1
													AND ((ISNULL(asu.Action,0) = 2 AND s.Completed = 1)
														OR (ISNULL(asu.Action,0) = 0) AND s.Completed = 0 
														OR (ISNULL(asu.Action,0) = 1) AND s.Completed = 1 AND ActiveStep = 0)
													AND r.ReviewDeliverableKey = @ReviewDeliverableKey
										  )
           ) t ON rr.ReviewRoundKey = t.ReviewRoundKey
           	
	
-- update round count
UPDATE rr
SET rr.RoundName = t.NewRoundName
FROM tReviewRound rr (nolock)
INNER JOIN (SELECT tRR.ReviewRoundKey, 
			(SELECT 'Round ' + CONVERT(Varchar(20), count(*) )
             FROM   tReviewRound counter (nolock)
             WHERE  counter.ReviewRoundKey <= tRR.ReviewRoundKey            
			 AND ReviewDeliverableKey = @ReviewDeliverableKey
			 AND ISNULL(Status,0) <> 4
			 AND ReviewRoundKey IN  (
								SELECT	r.ReviewRoundKey
								FROM	tReviewRound r (NOLOCK) INNER JOIN tApprovalStep s (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND s.Entity = 'tReviewRound'
											INNER JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
								WHERE	s.Internal = 0
										AND r.ReviewDeliverableKey = @ReviewDeliverableKey							
										AND ((ISNULL(asu.Action,0) = 2 AND s.Completed = 1) -- REJECTED
											OR ((ISNULL(asu.Action,0) = 1) AND s.Completed = 0) -- ACCEPTED
											OR ((ISNULL(asu.Action,0) = 0) AND ActiveStep = 1) -- IN PROCESS							
											OR ((ISNULL(asu.Action,0) = 0) AND ActiveStep = 0 AND r.Status = 1 AND ISNULL(r.RoundName,'') = '')) -- CLIENT ONLY STEP / NO INTERNAL STEP
							  )
			) AS NewRoundName
			FROM   tReviewRound tRR (nolock)
			WHERE  tRR.ReviewDeliverableKey = @ReviewDeliverableKey
			   AND ISNULL(tRR.Status,0) <> 4 
			   AND ReviewRoundKey IN  (
								SELECT	r.ReviewRoundKey
								FROM	tReviewRound r (NOLOCK) INNER JOIN tApprovalStep s (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND s.Entity = 'tReviewRound'
											INNER JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
								WHERE	s.Internal = 0
										AND r.ReviewDeliverableKey = @ReviewDeliverableKey							
										AND ((ISNULL(asu.Action,0) = 2 AND s.Completed = 1) -- REJECTED
											OR ((ISNULL(asu.Action,0) = 1) AND s.Completed = 0) -- ACCEPTED
											OR ((ISNULL(asu.Action,0) = 0) AND ActiveStep = 1) -- IN PROCESS
											OR ((ISNULL(asu.Action,0) = 0) AND ActiveStep = 0 AND r.Status = 1 AND ISNULL(r.RoundName,'') = '')) -- CLIENT ONLY STEP / NO INTERNAL STEP
							  )
           ) t ON rr.ReviewRoundKey = t.ReviewRoundKey
     
UPDATE	tReviewRound
SET		RoundName = 'Cancelled'
WHERE	ReviewDeliverableKey = @ReviewDeliverableKey 
		AND 
			Status = 4           
			/*OR
			Status = 3 AND ReviewRoundKey IN (
									SELECT	ReviewRoundKey
									FROM	tReviewRound r (NOLOCK) INNER JOIN tApprovalStep s (NOLOCK) ON r.ReviewRoundKey = s.EntityKey AND s.Entity = 'tReviewRound'
												INNER JOIN tApprovalStepUser asu (NOLOCK) ON s.ApprovalStepKey = asu.ApprovalStepKey
									WHERE	s.Internal = 1
											AND asu.Action = 2 
											AND s.Completed = 0
											AND r.ReviewDeliverableKey = @ReviewDeliverableKey
								   )
			)*/
			
--Update Deliverable LastCompletedRoundKey
DECLARE @ReviewRoundKey INT

SELECT	@ReviewRoundKey = MAX(rr.ReviewRoundKey)
FROM	tReviewRound rr (NOLOCK) INNER JOIN tApprovalStep aps (NOLOCK) ON rr.ReviewRoundKey = aps.EntityKey  AND aps.Entity = 'tReviewRound'
WHERE	rr.ReviewDeliverableKey = @ReviewDeliverableKey
		AND rr.Status IN (2,3)
		AND ISNULL(aps.Internal,1) = 1
		AND aps.Completed = 1

IF ISNULL(@ReviewRoundKey,0) = 0
	BEGIN
		SELECT	@ReviewRoundKey = MAX(rr.ReviewRoundKey)
		FROM	tReviewRound rr (NOLOCK) INNER JOIN tApprovalStep aps (NOLOCK) ON rr.ReviewRoundKey = aps.EntityKey  AND aps.Entity = 'tReviewRound'
		WHERE	rr.ReviewDeliverableKey = @ReviewDeliverableKey
				AND rr.Status IN (2,3)
	END
     
UPDATE	tReviewDeliverable
SET		LastCompletedRoundKey = @ReviewRoundKey
WHERE	ReviewDeliverableKey = @ReviewDeliverableKey           


DECLARE @ApprovalStepKey INT

SELECT	@ApprovalStepKey = ApprovalStepKey
FROM	tReviewDeliverable rd (NOLOCK) INNER JOIN tReviewRound r (NOLOCK) ON rd.ReviewDeliverableKey = r.ReviewDeliverableKey
		INNER JOIN tApprovalStep a (NOLOCK) ON a.EntityKey = r.ReviewRoundKey AND a.Entity = 'tReviewRound'
WHERE	rd.ReviewDeliverableKey = @ReviewDeliverableKey
		AND a.ActiveStep = 1

EXEC sptApprovalStepUpdateStatusNames @ApprovalStepKey
GO
