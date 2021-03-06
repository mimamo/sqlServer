USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundFileDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundFileDelete]
 @ReviewRoundKey INT,
 @Path VARCHAR(200) = NULL
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/12/11	QMD 10.5.x.x	Created for new ArtReview
  || 01/20/12   GWG 10.5.5.2    Modified to delete all files for a round
  || 03/04/14   QMD 10.5.7.8    Give option to delete one file
  */
  
  IF ISNULL(@Path,'') <> ''
	DELETE	tReviewRoundFile
	WHERE	ReviewRoundKey = @ReviewRoundKey
		AND FilePath = @Path
  ELSE
    DELETE tReviewRoundFile
	WHERE	 ReviewRoundKey = @ReviewRoundKey
GO
