USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentDoneFixing]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentDoneFixing]
 @ReviewCommentKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 05/30/14	QMD 10.5.8.0	Created for round review (wjapp)
  */
 
 UPDATE tReviewComment
 SET	FixedDate = GETUTCDATE()
 WHERE	ReviewCommentKey = @ReviewCommentKey
GO
