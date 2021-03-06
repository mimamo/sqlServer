USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileDelete]
	@ProjectKey int,
	@Path varchar(2000),
	@FileName varchar(300) = NULL
AS

/*
|| When      Who Rel      What
|| 3/28/13   CRG 10.5.6.6 Created
*/

	SELECT	FileKey
	INTO	#FileKeys
	FROM	tWebDavFile (nolock)
	WHERE	ProjectKey = @ProjectKey
	AND		(
				(@FileName IS NULL AND UPPER(ISNULL(Path,'')) LIKE UPPER(ISNULL(@Path, '')) + '%') --No FileName, delete path and all sub folders
					OR
				(@FileName IS NOT NULL AND UPPER(ISNULL(Path,'')) = UPPER(ISNULL(@Path, '')) --Filename passed in, only delete for this folder
			)
	AND		(@FileName IS NULL OR UPPER(FileName) = UPPER(@FileName)))

	DELETE	tWebDavFileHistory
	WHERE	FileKey IN (SELECT FileKey FROM #FileKeys)

	DELETE	tWebDavFile
	WHERE	FileKey IN (SELECT FileKey FROM #FileKeys)
GO
