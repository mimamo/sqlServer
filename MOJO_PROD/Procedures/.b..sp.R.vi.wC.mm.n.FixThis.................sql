USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentFixThis]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentFixThis]
 @ReviewCommentKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 05/30/14	QMD 10.5.8.0	Created for round review (wjapp)
  */
 
 UPDATE tReviewComment
 SET	FixThis  = 1, FixedDate = NULL
 WHERE	ReviewCommentKey = @ReviewCommentKey
GO
