USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGetPortalList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewDeliverableGetPortalList]
	@UserKey INT,
	@CurrentList INT,
	@ProjectKey INT = 0
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/06/11	QMD 10.5.4.9	Created for art review portal list
  || 09/15/12   GWG 10.5.6.0    Modified to select everything for a project
  */


if @ProjectKey = 0
BEGIN
  if @CurrentList = 1
	 BEGIN
		SELECT	p.ProjectKey, p.ProjectNumber, p.ProjectName, rd.ReviewDeliverableKey, rd.DeliverableName, rd.Description, rr.RoundName, rr.ReviewRoundKey,
			a.ApprovalStepKey, a.Internal, a.LoginRequired, asu.DueDate
		FROM	tApprovalStepUser asu (NOLOCK) 
		INNER JOIN tApprovalStep a (NOLOCK) ON asu.ApprovalStepKey = a.ApprovalStepKey
		INNER JOIN tReviewRound rr (NOLOCK) ON rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
		INNER JOIN tReviewDeliverable rd (NOLOCK) ON rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey

		WHERE	asu.AssignedUserKey = @UserKey and asu.ActiveUser = 1 and a.ActiveStep = 1
		--TODO add datesent restriction
		ORDER BY p.ProjectNumber, DeliverableName

	END
	ELSE
	BEGIN
		SELECT	p.ProjectKey, p.ProjectNumber, p.ProjectName, rd.ReviewDeliverableKey, rd.DeliverableName, rd.Description, ISNULL(rr.RoundName, 'Round 1') as RoundName, rr.ReviewRoundKey
		FROM	tReviewDeliverable rd (NOLOCK) 
		INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tReviewRound rr (NOLOCK) on rd.LastCompletedRoundKey = rr.ReviewRoundKey

		WHERE	rd.ReviewDeliverableKey in (Select Distinct ReviewDeliverableKey from tReviewRound rr (nolock)
											inner join tApprovalStep a (nolock) on rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
											inner join tApprovalStepUser asu (NOLOCK) on asu.ApprovalStepKey = a.ApprovalStepKey
											Where asu.AssignedUserKey = @UserKey and asu.CompletedUser = 1)
		AND p.Active = 1
		--TODO add datesent restriction
		ORDER BY p.ProjectNumber, DeliverableName
	END
END
ELSE
BEGIN
		SELECT	p.ProjectKey, p.ProjectNumber, p.ProjectName, rd.ReviewDeliverableKey, rd.DeliverableName, rd.Description, rd.DueDate, ISNULL(rr.RoundName, 'Round 1') as RoundName, rr.ReviewRoundKey
		FROM	tReviewDeliverable rd (NOLOCK) 
		INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tReviewRound rr (NOLOCK) on rd.LastCompletedRoundKey = rr.ReviewRoundKey

		WHERE	rd.ReviewDeliverableKey in (Select Distinct ReviewDeliverableKey from tReviewRound rr (nolock)
											inner join tApprovalStep a (nolock) on rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
											inner join tApprovalStepUser asu (NOLOCK) on asu.ApprovalStepKey = a.ApprovalStepKey
											Where asu.AssignedUserKey = @UserKey)
		AND p.ProjectKey = @ProjectKey
		--TODO add datesent restriction
		ORDER BY p.ProjectNumber, DeliverableName


END
GO
