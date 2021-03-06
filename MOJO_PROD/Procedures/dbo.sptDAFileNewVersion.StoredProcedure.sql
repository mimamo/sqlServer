USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileNewVersion]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileNewVersion]

	(
		@FileKey int,
		@FileSize int,
		@Status smallint,
		@VersionComments varchar(4000),
		@VersionByKey int
	)

AS --Encrypt

Declare @NewVersionKey int, @OldVersionKey int, @VersionNumber int, @Deleted tinyint, @TrackRevisions tinyint

Select @VersionNumber = Max(VersionNumber) + 1 from tDAFileVersion (nolock) Where FileKey = @FileKey
Select @TrackRevisions = TrackRevisions, @OldVersionKey = CurrentVersionKey from tDAFile (nolock) Where FileKey = @FileKey

if @TrackRevisions = 1
	Select @Deleted = 0
else
	Select @Deleted = 1

Insert tDAFileVersion
	(FileKey, VersionNumber, VersionComments, FileSize, Status, Deleted, VersionDate, VersionByKey)
Values
	(@FileKey, @VersionNumber, @VersionComments, @FileSize, @Status, 0, GETUTCDATE(), @VersionByKey)

Update tDAFileVersion
Set Deleted = @Deleted
Where FileVersionKey = @OldVersionKey

Select @NewVersionKey = @@Identity


Update tDAFile 
Set CurrentVersionKey = @NewVersionKey
Where FileKey = @FileKey
GO
