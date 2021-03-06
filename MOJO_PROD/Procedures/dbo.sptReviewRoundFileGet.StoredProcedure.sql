USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundFileGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundFileGet]
 @ReviewRoundKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/04/11	QMD 10.5.x.x	Created for new ArtReview
  */
  

  SELECT	*
  FROM		tReviewRoundFile r (NOLOCK) 
  WHERE		ReviewRoundKey = @ReviewRoundKey
  ORDER BY  DisplayOrder ASC
GO
