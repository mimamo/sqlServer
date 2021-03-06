USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundFileGetCopies]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundFileGetCopies]
 @ReviewDeliverableKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 10/01/12   QMD 10.5.6.0    Created to get files from the last round 
  */

Declare @CopiedReviewRoundKey int

-- Make sure the ReviewDeliverableKey is valid
If ISNULL(@ReviewDeliverableKey,0) = 0 
	Return -1 

SELECT	TOP 1 
		@CopiedReviewRoundKey = ReviewRoundKey
FROM	tReviewRound (NOLOCK)	
WHERE	ReviewDeliverableKey = @ReviewDeliverableKey
ORDER BY ReviewRoundKey DESC
	
-- Copy all the file and URL records 
SELECT	FilePath, 
		IsURL,
		DisplayOrder
FROM	tReviewRoundFile (NOLOCK) 
WHERE	ReviewRoundKey = @CopiedReviewRoundKey
GO
