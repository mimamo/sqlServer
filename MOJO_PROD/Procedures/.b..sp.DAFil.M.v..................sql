USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileMove]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileMove]

	(
		@FileKey int,
		@NewFolderKey int
	)

AS

Declare @CurFolderKey int, @FileName varchar(300)

Select @CurFolderKey = FolderKey, @FileName = FileName from tDAFile (nolock) Where FileKey = @FileKey

if exists(Select 1 from tDAFile (nolock) Where RTRIM(LTRIM(UPPER(@FileName))) = RTRIM(LTRIM(UPPER(FileName))) and FolderKey = @NewFolderKey)
	return -1
	
Update tDAFile Set FolderKey = @NewFolderKey Where FileKey = @FileKey

return 1
GO
