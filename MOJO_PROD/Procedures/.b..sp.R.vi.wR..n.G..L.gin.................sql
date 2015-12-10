USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundGetLogin]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundGetLogin]
 @ReviewDeliverableKey INT,
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 01/01/12	GWG 10.5.x.x	Created for new ArtReview
  */
  -- Get the round info object
  
declare @RequestedRoundKey int, @PrivateCanView tinyint, @CanApprove tinyint, @ClientLogin tinyint

if @ReviewDeliverableKey is null
	Select @ReviewDeliverableKey = ReviewDeliverableKey From tReviewRound (nolock) Where ReviewRoundKey = @ReviewRoundKey 



-- Find the settings on the current round
Select @ReviewRoundKey = Max(ReviewRoundKey)
From tReviewRound (nolock) 
Where ReviewDeliverableKey = @ReviewDeliverableKey and Status = 2

if @ReviewRoundKey is null
	return -1


SELECT	r.*, d.CompanyKey, aps.ApprovalStepKey, aps.LoginRequired
FROM tReviewRound r (NOLOCK) 
INNER JOIN tReviewDeliverable d (NOLOCK) ON d.ReviewDeliverableKey = r.ReviewDeliverableKey
INNER JOIN tProject p (NOLOCK) ON p.ProjectKey = d.ProjectKey
LEFT OUTER JOIN tApprovalStep aps (NOLOCK) on r.ReviewRoundKey= aps.EntityKey and aps.Entity = 'tReviewRound' and ActiveStep = 1
WHERE		ReviewRoundKey = @ReviewRoundKey
GO
