USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaStdCommentGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaStdCommentGet]
	@MediaStdCommentKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/
		SELECT *
		FROM tMediaStdComment (nolock)
		WHERE
			MediaStdCommentKey = @MediaStdCommentKey

	RETURN 1
GO
