USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepCheckUsers]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepCheckUsers]

	@ReviewRoundKey int

AS --Encrypt

  /*
  || When		Who Rel			What
  || 03/12/14	QMD 10.5.7.8	Check to see if a given round has at least 1 approver
  */


	IF EXISTS(
		SELECT	*
		FROM	tReviewRound rr (NOLOCK) INNER JOIN tApprovalStep a (NOLOCK) ON rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
					INNER JOIN tApprovalStepUser asu (NOLOCK) ON asu.ApprovalStepKey = a.ApprovalStepKey
		WHERE	rr.ReviewRoundKey = @ReviewRoundKey
				AND asu.DisplayOrder = 1 )								
		RETURN 1  -- Success
	ELSE
		RETURN -1 -- Can't find a single approver
GO
