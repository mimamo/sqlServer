USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundStatus]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundStatus]
 @ReviewRoundKey INT,
 @Status VARCHAR(75)
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 10/31/11	QMD 10.5.4.9	Created for new ArtReview
  */

	UPDATE  tReviewRound
	SET		Status = @Status
	WHERE   ReviewRoundKey = @ReviewRoundKey
GO
