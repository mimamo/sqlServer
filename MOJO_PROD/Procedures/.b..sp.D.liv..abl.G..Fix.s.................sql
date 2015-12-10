USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDeliverableGetFixes]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDeliverableGetFixes] 
 @ProjectKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 05/28/14	QMD 10.5.8.0    Created for new app to get deliverable fixes
  */
    
SELECT	d.DeliverableName, p.ProjectName, p.ProjectNumber, r.ReviewRoundKey, COUNT(*) AS NumberOfFixes
FROM	tReviewDeliverable d (NOLOCK) INNER JOIN tReviewRound r (NOLOCK) ON d.ReviewDeliverableKey = r.ReviewDeliverableKey
			INNER JOIN tProject p (NOLOCK) ON d.ProjectKey = p.ProjectKey
			LEFT JOIN tReviewComment rc (NOLOCK) ON r.ReviewRoundKey = rc.ReviewRoundKey
WHERE	d.ProjectKey = @ProjectKey
		AND ISNULL(rc.FixThis,0) = 1
		AND rc.FixedDate IS NULL
GROUP BY d.DeliverableName, p.ProjectName, p.ProjectNumber, r.ReviewRoundKey
GO
