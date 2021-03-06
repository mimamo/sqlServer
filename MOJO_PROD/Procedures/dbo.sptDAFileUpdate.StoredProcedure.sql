USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileUpdate]
(
	@FileKey int,
	@FolderKey int,
	@ClientFolderKey int,
	@FileName varchar(300),
	@TrackRevisions tinyint,
	@RevisionsToKeep int,
	@Description varchar(4000)
)
	
AS --Encrypt

if exists(Select 1 from tDAFile (nolock) 
	Where 
		RTRIM(LTRIM(UPPER(@FileName))) = RTRIM(LTRIM(UPPER(FileName))) and 
		FileKey <> @FileKey and
		FolderKey = @FolderKey)
		
	return -1



Update tDAFile
Set
	FolderKey = @FolderKey,
	ClientFolderKey = @ClientFolderKey,
	FileName = @FileName,
	TrackRevisions = @TrackRevisions,
	RevisionsToKeep = @RevisionsToKeep,
	Description = @Description
Where
	FileKey = @FileKey
	
return 1
GO
