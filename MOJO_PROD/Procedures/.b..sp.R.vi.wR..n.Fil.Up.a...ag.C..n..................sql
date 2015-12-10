USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundFileUpdatePageCount]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundFileUpdatePageCount]
 @ReviewRoundFileKey INT,
 @PageCount INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 04/06/15	QMD 10.5.9.0	Created for the deliverables
  */

UPDATE	tReviewRoundFile
SET		[PageCount] = @PageCount
WHERE	ReviewRoundFileKey = @ReviewRoundFileKey
GO
