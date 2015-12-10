USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkUpdateWebDavLinks]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLinkUpdateWebDavLinks]
AS

/*
|| When      Who Rel      What
|| 1/29/13   CRG 10.5.6.4 Created
*/

DECLARE	@FileKey int
SELECT	@FileKey = -1

DECLARE	@FolderKey int,
		@ProjectKey int,
		@FileName varchar(300),
		@WebDavRelativePath varchar(2000)

WHILE (1=1)
BEGIN
	SELECT	@FileKey = MIN(FileKey)
	FROM	tLink (nolock)
	WHERE	FileKey IS NOT NULL
	AND		FileKey > @FileKey
	
	IF @FileKey IS NULL
		BREAK
		
	SELECT	@FileName = FileName,
			@FolderKey = FolderKey
	FROM	tDAFile (nolock)
	WHERE	FileKey = @FileKey
	
	SELECT	@ProjectKey = ProjectKey,
			@WebDavRelativePath = WebDavRelativePath
	FROM	tDAFolder (nolock)
	WHERE	FolderKey = @FolderKey
	
	UPDATE	tLink
	SET		ProjectKey = @ProjectKey,
			WebDavFileName = @FileName,
			WebDavPath =
				CASE
					WHEN ISNULL(@WebDavRelativePath, '') <> '' THEN ISNULL(@WebDavRelativePath, '') + '/' + @FileName
					ELSE @FileName
				END
	WHERE	FileKey = @FileKey
END
GO
