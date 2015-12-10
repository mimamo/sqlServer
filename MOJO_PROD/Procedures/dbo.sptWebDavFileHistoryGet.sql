USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileHistoryGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileHistoryGet]
	@FileKey uniqueidentifier

AS

/*
|| When      Who Rel      What
|| 4/1/13    CRG 10.5.6.6 Created
*/

	SELECT	fh.*, u.UserName AS ModifiedUser
	FROM	tWebDavFileHistory fh (nolock)
	LEFT JOIN vUserName u (nolock) ON fh.ModifiedBy = u.UserKey
	WHERE	fh.FileKey = @FileKey
	ORDER BY fh.Modified DESC
GO
