USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserDefaultsInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserDefaultsInsert]
 @ApprovalStepKey INT,
 @Internal INT,
 @EnableRouting INT
  
AS --Encrypt  
  
    /*
  || When		Who Rel			What
  || 11/29/11	QMD 10.5.5.0	Created for new ArtReview
  || 12/02/11	QMD 10.5.5.0   	For external steps default notifiers should be internal and external people.
  || 01/13/12	QMD 10.5.5.2   	Added active user logic
  || 01/17/14   RLB 10.5.7.6    (202816) Default ActiveUser to 0 becuase it is set in another sp
  || 11/24/14   QMD 10.5.8.6    (236970) Commented out the logic to set the first user to active when @EnableRouting = 1
  */
  
  DECLARE @ActiveUser INT 
	
  IF (@Internal = 1)
	BEGIN 

		--ActiveUser determined in the send of a review in sptApprovalStepInit
		SET @ActiveUser = 0
		
		--Do Approvers First ordering by full name
		INSERT INTO tApprovalStepUser (ApprovalStepKey, AssignedUserKey, DisplayOrder, ActiveUser)
		SELECT	ApprovalStepKey = @ApprovalStepKey, ass.UserKey AS AssignedUserKey,
					(
					SELECT	Count(*)
					FROM	tAssignment a (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON a.ProjectKey = r.ProjectKey
								INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
								INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
								INNER JOIN tUser us (NOLOCK) ON a.UserKey = us.UserKey
					WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
							AND us.OwnerCompanyKey IS NULL
							AND a.DeliverableReviewer = 1
							AND a.UserKey <= ass.UserKey
					) AS DisplayOrder,
					@ActiveUser
		FROM	tAssignment ass (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON ass.ProjectKey = r.ProjectKey
					INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
					INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
					INNER JOIN vUserName u (NOLOCK) ON ass.UserKey = u.UserKey
					INNER JOIN tUser (NOLOCK) ON u.UserKey = tUser.UserKey
		WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
				AND tUser.OwnerCompanyKey IS NULL
				AND ass.DeliverableReviewer = 1
		ORDER BY u.UserFullName

		--IF(@EnableRouting = 1)
		--	UPDATE	tApprovalStepUser
		--	SET		ActiveUser = 1
		--	WHERE	ApprovalStepKey = @ApprovalStepKey
		--			AND DisplayOrder = 1

		-- Do Notifiers
		INSERT INTO tApprovalStepNotify (ApprovalStepKey, AssignedUserKey)
		SELECT	ApprovalStepKey = @ApprovalStepKey, ass.UserKey as AssignedUserKey
		FROM	tAssignment ass (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON ass.ProjectKey = r.ProjectKey
					INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
					INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
					INNER JOIN vUserName u (NOLOCK) ON ass.UserKey = u.UserKey
					INNER JOIN tUser (NOLOCK) ON u.UserKey = tUser.UserKey
		WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
				AND tUser.OwnerCompanyKey IS NULL
				AND ass.DeliverableNotify = 1
		ORDER BY u.UserFullName
	END
  ELSE
	BEGIN 
		--Do Approvers First ordering by full name
		INSERT INTO tApprovalStepUser (ApprovalStepKey, AssignedUserKey, DisplayOrder)
		SELECT	ApprovalStepKey = @ApprovalStepKey, ass.UserKey AS AssignedUserKey,
					(
					SELECT	Count(*)
					FROM	tAssignment a (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON a.ProjectKey = r.ProjectKey
								INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
								INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
								INNER JOIN tUser us (NOLOCK) ON a.UserKey = us.UserKey
					WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
							AND us.OwnerCompanyKey IS NOT NULL
							AND a.DeliverableReviewer = 1
							AND a.UserKey <= ass.UserKey
					) AS DisplayOrder
		FROM	tAssignment ass (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON ass.ProjectKey = r.ProjectKey
					INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
					INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
					INNER JOIN vUserName u (NOLOCK) ON ass.UserKey = u.UserKey
					INNER JOIN tUser (NOLOCK) ON u.UserKey = tUser.UserKey
		WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
				AND tUser.OwnerCompanyKey IS NOT NULL
				AND ass.DeliverableReviewer = 1
		ORDER BY u.UserFullName

		-- Do Notifiers
		INSERT INTO tApprovalStepNotify (ApprovalStepKey, AssignedUserKey)
		SELECT	ApprovalStepKey = @ApprovalStepKey, ass.UserKey as AssignedUserKey
		FROM	tAssignment ass (NOLOCK) INNER JOIN tReviewDeliverable r (NOLOCK) ON ass.ProjectKey = r.ProjectKey
					INNER JOIN tReviewRound rnd (NOLOCK) ON rnd.ReviewDeliverableKey = r.ReviewDeliverableKey
					INNER JOIN tApprovalStep aStep (NOLOCK) ON aStep.Entity = 'tReviewRound' AND aStep.EntityKey = rnd.ReviewRoundKey
					INNER JOIN vUserName u (NOLOCK) ON ass.UserKey = u.UserKey
					INNER JOIN tUser (NOLOCK) ON u.UserKey = tUser.UserKey
		WHERE	aStep.ApprovalStepKey = @ApprovalStepKey
				AND ass.DeliverableNotify = 1
		ORDER BY u.UserFullName
	END    
    

  
	RETURN 1
GO
