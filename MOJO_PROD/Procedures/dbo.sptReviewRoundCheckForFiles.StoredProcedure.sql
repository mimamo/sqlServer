USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundCheckForFiles]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundCheckForFiles]
 @FilePath		VARCHAR(1500),
 @ProjectKey	INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 01/04/12	QMD 10.5.5.2	Created for new ArtReview
  || 01/20/12	QMD 10.5.5.2	Changed CompanyName to ClientName
  || 04/15/14	QMD 10.5.7.8	Changed Inner to Left join on the project info
  || 03/19/15   GAR 10.5.9.0    (246227)  Add ability to send multiple files for review
  */
	--Look for file
	IF (SELECT COUNT(*) FROM #FileList) > 0
	BEGIN
		SELECT a.*
		FROM (
				SELECT	rr.Status, rd.ReviewDeliverableKey, rd.ProjectKey, p.ProjectNumber + ' - ' + p.ProjectName as ProjectFormattedName, rd.DeliverableName, (Select count(*) from tReviewRound (nolock) Where ReviewDeliverableKey = rd.ReviewDeliverableKey) as RoundCount
				FROM	tReviewRoundFile rrf (NOLOCK) INNER JOIN tReviewRound rr (NOLOCK) ON rr.ReviewRoundKey = rrf.ReviewRoundKey
							INNER JOIN tReviewDeliverable rd (NOLOCK) ON rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
							INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey
							INNER JOIN (
										SELECT	ReviewDeliverableKey, MAX(ReviewRoundKey) as ReviewRoundKey
										FROM	tReviewRound (NOLOCK)
										GROUP BY ReviewDeliverableKey
										) r ON r.ReviewRoundKey = rr.ReviewRoundKey
							INNER JOIN #FileList ON rrf.FilePath = #FileList.FilePath COLLATE DATABASE_DEFAULT
				WHERE	rrf.IsURL = 0
						AND rd.ProjectKey = @ProjectKey
						--AND rrf.FilePath = @FilePath
						--AND rr.Status IN (3,4) --Rejected, Approved(Complete)
				GROUP BY rr.Status, rd.ReviewDeliverableKey, rd.ProjectKey, rd.DeliverableName, p.ProjectNumber, p.ProjectName
				) a
		WHERE a.Status NOT IN (1,2)
	END
	ELSE
	BEGIN
		SELECT a.*
		FROM (
				SELECT	rrf.FilePath, rr.Status, rd.ReviewDeliverableKey, rd.ProjectKey, p.ProjectNumber + ' - ' + p.ProjectName as ProjectFormattedName, rd.DeliverableName, (Select count(*) from tReviewRound (nolock) Where ReviewDeliverableKey = rd.ReviewDeliverableKey) as RoundCount
				FROM	tReviewRoundFile rrf (NOLOCK) INNER JOIN tReviewRound rr (NOLOCK) ON rr.ReviewRoundKey = rrf.ReviewRoundKey
							INNER JOIN tReviewDeliverable rd (NOLOCK) ON rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
							INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey
							INNER JOIN (
										SELECT	ReviewDeliverableKey, MAX(ReviewRoundKey) as ReviewRoundKey
										FROM	tReviewRound (NOLOCK)
										GROUP BY ReviewDeliverableKey
										) r ON r.ReviewRoundKey = rr.ReviewRoundKey
				WHERE	rrf.IsURL = 0
						AND rd.ProjectKey = @ProjectKey
						AND rrf.FilePath = @FilePath
						--AND rr.Status IN (3,4) --Rejected, Approved(Complete)
				GROUP BY rrf.FilePath, rr.Status, rd.ReviewDeliverableKey, rd.ProjectKey, rd.DeliverableName, p.ProjectNumber, p.ProjectName
				) a
		WHERE a.Status NOT IN (1,2)
	END
	
	--Get Project Info
	SELECT	c.CustomerID AS ClientID, c.CompanyName AS ClientName, ProjectKey, ProjectNumber, ProjectName, (ISNULL(ProjectNumber,'') + ' - ' + ISNULL(ProjectName,'')) AS ProjectFormattedName
	FROM	tProject p (NOLOCK) LEFT JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
	WHERE	ProjectKey = @ProjectKey
GO
