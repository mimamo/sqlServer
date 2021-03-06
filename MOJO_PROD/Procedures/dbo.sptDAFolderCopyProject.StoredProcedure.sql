USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderCopyProject]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderCopyProject]
	(
		@SrcProjectKey INT,
		@DestProjectKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	DECLARE @IsClientFolder SMALLINT
			,@RetVal INT
	
	-- Need to save 2 sets of keys before saving files
	CREATE TABLE #FolderKey(SrcFolderKey INT NULL, DestFolderKey INT NULL)
	CREATE TABLE #ClientFolderKey(SrcClientFolderKey INT NULL, DestClientFolderKey INT NULL)
		
	-- Copy employee folder, starting at root folder i.e. 0 
	SELECT @IsClientFolder = 0
	EXEC @RetVal = sptDAFolderCopyFolder @SrcProjectKey ,@DestProjectKey, 0, 0, @IsClientFolder, @UserKey

	IF @RetVal <> 1
		RETURN -1
	   
	-- Copy client folder, starting at root folder i.e. 0 
	SELECT @IsClientFolder = 1
	EXEC @RetVal = sptDAFolderCopyFolder @SrcProjectKey ,@DestProjectKey, 0, 0, @IsClientFolder, @UserKey
	   
	IF @RetVal <> 1
		RETURN -2

	DECLARE @SrcFileKey INT
			,@DestFileKey INT
			,@SrcFolderKey int
			,@DestFolderKey int
			,@SrcClientFolderKey int
			,@DestClientFolderKey int
			
	SELECT @SrcFileKey = -1
	
	WHILE (1=1)
	BEGIN
		SELECT @SrcFileKey = MIN(f.FileKey)
		FROM   tDAFile f (NOLOCK)
			INNER JOIN #FolderKey b ON f.FolderKey = b.SrcFolderKey
		WHERE    f.FileKey > @SrcFileKey
		AND UPPER(FileName) NOT LIKE '%.LOG' -- Do not copy logs
				
		IF @SrcFileKey IS NULL
			BREAK
			
		SELECT @SrcFolderKey = FolderKey
			  ,@SrcClientFolderKey = ISNULL(ClientFolderKey, 0)
		FROM   tDAFile (NOLOCK)
		WHERE  FileKey = @SrcFileKey
	
		IF @SrcClientFolderKey = 0
			SELECT @DestClientFolderKey = 0
		ELSE
			SELECT @DestClientFolderKey = DestClientFolderKey
			FROM   #ClientFolderKey 
			WHERE  SrcClientFolderKey = @SrcClientFolderKey
					
		SELECT @DestFolderKey = DestFolderKey
		FROM   #FolderKey 
		WHERE  SrcFolderKey = @SrcFolderKey
		
		INSERT tDAFile
			(
			FolderKey,
			ClientFolderKey,
			FileName,
			Description,
			TrackRevisions,
			RevisionsToKeep,
			CurrentVersionKey,
			CheckedOutByKey,
			CheckedOutDate,
			CheckOutComment,
			LockFile,
			AddedDate,
			AddedByKey
			)
		SELECT
			@DestFolderKey,
			@DestClientFolderKey,
			FileName,
			Description,
			TrackRevisions,
			RevisionsToKeep,
			CurrentVersionKey,
			CheckedOutByKey,
			CheckedOutDate,
			CheckOutComment,
			LockFile,
			GETDATE(),
			@UserKey
		FROM tDAFile (NOLOCK)
		WHERE FileKey = @SrcFileKey

		SELECT @DestFileKey = @@IDENTITY
	
		INSERT tDAFileRight
			(
			FileKey,
			Entity,
			EntityKey,
			AllowRead,
			AllowUpdate,
			AllowChange,
			AllowDelete
			)
		SELECT
			@DestFileKey,
			Entity,
			EntityKey,
			AllowRead,
			AllowUpdate,
			AllowChange,
			AllowDelete
		FROM tDAFileRight (NOLOCK)
		WHERE FileKey = @SrcFileKey
				 
		
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
		SELECT
			@DestFileKey,
			VersionNumber,
			VersionComments,
			FileSize,
			Status,
			Deleted,
			VersionDate,
			VersionByKey
		FROM tDAFileVersion (NOLOCK)
		WHERE FileKey = @SrcFileKey
		
		-- Now set the Current Version
		UPDATE tDAFile
		SET    tDAFile.CurrentVersionKey =	(
										 SELECT MAX(FileVersionKey)
										 FROM	tDAFileVersion (NOLOCK)
										 WHERE  FileKey = @DestFileKey
											) 
		WHERE  FileKey = @DestFileKey

	END
	   
	RETURN 1
GO
