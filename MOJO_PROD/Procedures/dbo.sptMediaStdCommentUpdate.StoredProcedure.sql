USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaStdCommentUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaStdCommentUpdate]
	 @MediaStdCommentKey int
	,@CompanyKey int
	,@POKind smallint
	,@CommentID varchar(50)
	,@Comment varchar(4000)
	,@Active smallint


AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
|| 02/16/14  PLC 10.5.7.8 Added active
*/


IF 	@MediaStdCommentKey > 0
	BEGIN
		UPDATE tMediaStdComment
		SET CommentID = @CommentID
		   ,Comment  = @Comment
		   ,Active = @Active
		WHERE MediaStdCommentKey = @MediaStdCommentKey

		RETURN @MediaStdCommentKey

	END
ELSE
	BEGIN
		INSERT tMediaStdComment
			(
			 CompanyKey
			,POKind
			,CommentID
			,Comment
			,Active
			)
		VALUES
			(
			 @CompanyKey
			,@POKind
			,@CommentID
			,@Comment
			,@Active
			)
		
		RETURN @@IDENTITY
	END
GO
