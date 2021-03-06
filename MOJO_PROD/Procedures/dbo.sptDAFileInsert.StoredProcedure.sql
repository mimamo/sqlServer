USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileInsert]
	@FolderKey int,
	@ClientFolderKey int,
	@FileName varchar(300),
	@Description varchar(4000),
	@VersionComments varchar(4000),
	@TrackRevisions tinyint,
	@RevisionsToKeep int,
	@AddedDate smalldatetime,
	@AddedByKey int,
	@FileSize int,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @FileVersionKey int

if exists(Select 1 from tDAFile (NOLOCK) Where RTRIM(LTRIM(UPPER(@FileName))) = RTRIM(LTRIM(UPPER(FileName))) and FolderKey = @FolderKey)
	return -1
	

	INSERT tDAFile
		(
		FolderKey,
		ClientFolderKey,
		FileName,
		Description,
		CurrentVersionKey,
		TrackRevisions,
		RevisionsToKeep,
		CheckedOutByKey,
		AddedDate,
		AddedByKey
		)

	VALUES
		(
		@FolderKey,
		@ClientFolderKey,
		@FileName,
		@Description,
		0,
		@TrackRevisions,
		@RevisionsToKeep,
		0,
		@AddedDate,
		@AddedByKey
		)
		
	
	SELECT @oIdentity = @@IDENTITY

	INSERT tDAFileVersion
		(
		FileKey,
		VersionNumber,
		VersionComments,
		FileSize,
		Status,
		Deleted,
		VersionDate,
		VersionByKey
		)
		Values
		(
		@oIdentity,
		1,
		@VersionComments,
		@FileSize,
		1,
		0,
		@AddedDate,
		@AddedByKey
		)
		
	Select @FileVersionKey = @@IDENTITY
	
	Update tDAFile
	Set CurrentVersionKey = @FileVersionKey
	Where
		FileKey = @oIdentity

	Insert tDAFileRight (FileKey, Entity, EntityKey, AllowRead, AllowUpdate, AllowChange, AllowDelete)
	Select
		tDAFile.FileKey, tDAFolderRight.Entity, tDAFolderRight.EntityKey, AllowRead, AllowAddFile, AllowAddFile, AllowDelete
	From
		tDAFile (NOLOCK)
		inner join tDAFolderRight (NOLOCK) on tDAFolderRight.FolderKey = tDAFile.FolderKey
	Where
		tDAFile.FileKey = @oIdentity
		
	RETURN 1
GO
