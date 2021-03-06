USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaStdCommentDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaStdCommentDelete]
	@MediaStdCommentKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/

	DELETE
	FROM tMediaStdComment
	WHERE
		MediaStdCommentKey = @MediaStdCommentKey

	RETURN 1
GO
