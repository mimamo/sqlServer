USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentDelete]
 @ReviewCommentKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 05/29/14	QMD 10.5.8.0	Created for wjapp ArtReview
  */

	DELETE	tReviewComment
	WHERE	ReviewCommentKey = @ReviewCommentKey OR ParentCommentKey = @ReviewCommentKey
GO
