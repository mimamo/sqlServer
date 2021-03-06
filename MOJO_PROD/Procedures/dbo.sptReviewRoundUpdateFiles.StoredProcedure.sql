USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundUpdateFiles]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundUpdateFiles]
 @ReviewRoundKey INT,
 @Files VARCHAR(4000)
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 12/22/11	QMD 10.5.5.1	Created for new ArtReview
  */

UPDATE tReviewRound
SET Files = ISNULL(Files,'') + @Files
WHERE ReviewRoundKey = @ReviewRoundKey
GO
