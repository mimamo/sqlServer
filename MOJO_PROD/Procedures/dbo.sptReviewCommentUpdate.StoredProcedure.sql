USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewCommentUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewCommentUpdate]
 @ReviewCommentKey INT,
 @ReviewRoundKey INT,
 @ApprovalStepKey INT,
 @ParentCommentKey INT,
 @UserKey INT,
 @Page INT,
 @UserName VARCHAR(250),
 @Comment VARCHAR(5000),
 @Position INT,
 @ReviewRoundFileKey INT = NULL
AS --Encrypt

  /*
  || When		Who Rel			What
  || 10/31/11	QMD 10.5.4.9	Created for new ArtReview
  || 01/01/12   RJE 10.?.?.?    Revised for table structure
  || 04/15/15   GAR 10.5.9.0    253431 - Made @ReviewRoundFileKey optional to fix deliverable comments.
  */

IF EXISTS (SELECT * FROM tReviewComment (NOLOCK) WHERE ReviewCommentKey = @ReviewCommentKey)
	BEGIN
		UPDATE  tReviewComment
		SET		Comment = @Comment
		WHERE   ReviewCommentKey = @ReviewCommentKey
		RETURN @ReviewCommentKey
	END	
ELSE
	BEGIN
		INSERT INTO tReviewComment
				(ReviewRoundKey,
				 ApprovalStepKey,
				 ParentCommentKey,
				 UserKey,
				 ReviewRoundFileKey,
				 Page,
				 UserName,
				 Comment,
				 DateAdded,
				 Position
				)
		VALUES  (@ReviewRoundKey,
				 @ApprovalStepKey,
				 CASE WHEN @ParentCommentKey < 0 THEN 0 ELSE @ParentCommentKey END,
				 @UserKey,
				 @ReviewRoundFileKey,
				 @Page,
				 @UserName,
				 @Comment,
				 GETUTCDATE(),
				 @Position
				)
		 
		
		IF @ParentCommentKey < 0 
		BEGIN
		UPDATE  tReviewComment
		SET		ParentCommentKey = @@IDENTITY
		WHERE   ReviewCommentKey = @@IDENTITY
		END
		RETURN @@IDENTITY

	END
GO
