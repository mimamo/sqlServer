USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderCopyFolder]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderCopyFolder]
	(
		@SrcProjectKey INT
	   ,@DestProjectKey INT
	   ,@SrcParentFolderKey INT		-- Start at 0
	   ,@DestParentFolderKey INT	-- Start at 0
	   ,@IsClientFolder SMALLINT
	   ,@UserKey INT
	)
AS -- Encrypt

/*
|| When      Who Rel      What
|| 9/6/12    CRG 10.5.5.9 (153382) Modified to check for the existence of the root folder first, to avoid duplicating it
|| 10/18/12  CRG 10.5.6.1 (152930) Fixed a bug where the rights weren't being copied over to the root folder if it already existed.
*/

	SET NOCOUNT ON
	
	-- Assume done from a calling SP
	-- CREATE TABLE #FolderKey(SrcFolderKey INT NULL, DestFolderKey INT NULL)
	-- CREATE TABLE #ClientFolderKey(SrcClientFolderKey INT NULL, DestClientFolderKey INT NULL)
	
	DECLARE @SrcFolderKey INT
			,@DestFolderKey INT
			,@FolderName VARCHAR(300)
			,@FolderDescription VARCHAR(4000)
			,@SystemPath VARCHAR(255)
			,@SrcProjectChar AS VARCHAR(254)
			,@DestProjectChar AS VARCHAR(254)
			,@RetVal INT
			,@RootExists tinyint
	
	SELECT @RootExists = 0

	IF ISNULL(@IsClientFolder, 0) = 0
	BEGIN
		IF @SrcParentFolderKey = 0
		BEGIN
			--Check to see if the root already exists for the project
			IF EXISTS
					(SELECT	1
					FROM	tDAFolder (nolock)
					WHERE	ProjectKey = @DestProjectKey
					AND		ParentFolderKey = 0)
				SELECT @RootExists = 1
		END
	 					
		SELECT @SrcFolderKey = -1
		WHILE (1=1)
		BEGIN
			SELECT	@SrcFolderKey = MIN(FolderKey)
			FROM	tDAFolder (NOLOCK)
			WHERE	ProjectKey = @SrcProjectKey
			AND		ParentFolderKey = @SrcParentFolderKey
			AND		FolderKey > @SrcFolderKey
			
			IF @SrcFolderKey IS NULL
				BREAK
				
			SELECT @FolderName = FolderName
				,@FolderDescription = FolderDescription
				,@SystemPath = SystemPath
			FROM   tDAFolder (NOLOCK)
			WHERE  ProjectKey = @SrcProjectKey
			AND    ParentFolderKey = @SrcParentFolderKey
			AND    FolderKey = @SrcFolderKey
			  	
			-- Will have to correct the path
			IF @SrcParentFolderKey = 0
				SELECT @FolderName = CAST(@DestProjectKey AS VARCHAR(300))
					,@SystemPath = CAST(@DestProjectKey AS VARCHAR(255))
			ELSE
			BEGIN
				SELECT @SrcProjectChar = CAST(@SrcProjectKey AS VARCHAR(253)) + '\'
					,@DestProjectChar = CAST(@DestProjectKey AS VARCHAR(253)) 
					
				SELECT @SystemPath = SUBSTRING(@SystemPath, LEN(@SrcProjectChar), 255)
				SELECT @SystemPath = @DestProjectChar + @SystemPath 
			END
			
			IF @RootExists = 0
			BEGIN
				INSERT tDAFolder (
					ProjectKey
					,ParentFolderKey
					,FolderName
					,FolderDescription
					,SystemPath )
				VALUES (
					@DestProjectKey
					,@DestParentFolderKey
					,@FolderName
					,@FolderDescription
					,@SystemPath )
				
				SELECT @DestFolderKey = @@IDENTITY	

				IF @DestFolderKey > 0
				BEGIN
					INSERT tDAFolderRight (
						FolderKey			
						,Entity
						,EntityKey
						,AllowRead
						,AllowAdd
						,AllowAddFile
						,AllowChange
						,AllowDelete
						)
					SELECT @DestFolderKey
						,Entity
						,EntityKey
						,AllowRead
						,AllowAdd
						,AllowAddFile
						,AllowChange
						,AllowDelete
					FROM tDAFolderRight (nolock)
					WHERE FolderKey = @SrcFolderKey		
				END
			END
			ELSE
			BEGIN
				SELECT	@DestFolderKey = FolderKey
				FROM	tDAFolder (nolock)
				WHERE	ProjectKey = @DestProjectKey
				AND		ParentFolderKey = 0

				IF @DestFolderKey > 0
				BEGIN
					INSERT tDAFolderRight (
						FolderKey			
						,Entity
						,EntityKey
						,AllowRead
						,AllowAdd
						,AllowAddFile
						,AllowChange
						,AllowDelete
						)
					SELECT @DestFolderKey
						,Entity
						,EntityKey
						,AllowRead
						,AllowAdd
						,AllowAddFile
						,AllowChange
						,AllowDelete
					FROM tDAFolderRight (nolock)
					WHERE FolderKey = @SrcFolderKey		
				END
			END
			
			-- Save Keys
			INSERT #FolderKey(SrcFolderKey, DestFolderKey)
			VALUES (@SrcFolderKey, @DestFolderKey)												
				
			-- Copy sub dirs recursively
			EXEC @RetVal = sptDAFolderCopyFolder @SrcProjectKey, @DestProjectKey, @SrcFolderKey, @DestFolderKey, @IsClientFolder, @UserKey

			-- If limit to 32 nesting levels is reached		 			
			IF @RetVal <> 1
				RETURN -1
										
		END -- End While

	END -- If Client Folder

	ELSE
	
	-- Client Folder
	
	BEGIN
	
		SELECT @SrcFolderKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @SrcFolderKey = MIN(ClientFolderKey)
			FROM   tDAClientFolder (NOLOCK)
			WHERE  ProjectKey = @SrcProjectKey
			AND    ParentFolderKey = @SrcParentFolderKey
			AND    ClientFolderKey > @SrcFolderKey
			
			IF @SrcFolderKey IS NULL
				BREAK
				
			SELECT @FolderName = FolderName
			       ,@FolderDescription = FolderDescription
			FROM   tDAClientFolder (NOLOCK)
			WHERE  ProjectKey = @SrcProjectKey
			AND    ParentFolderKey = @SrcParentFolderKey
			AND    ClientFolderKey = @SrcFolderKey
			  	
				 	
			INSERT tDAClientFolder (
				ProjectKey
				,ParentFolderKey
				,FolderName
				,FolderDescription
				)
			VALUES (
				@DestProjectKey
				,@DestParentFolderKey
				,@FolderName
				,@FolderDescription
				)
				
			SELECT @DestFolderKey = @@IDENTITY	

			IF @DestFolderKey > 0	
			BEGIN
				INSERT tDAFolderRight (
					FolderKey			
					,Entity
					,EntityKey
					,AllowRead
					,AllowAdd
					,AllowAddFile
					,AllowChange
					,AllowDelete
					)
				SELECT @DestFolderKey
					,Entity
					,EntityKey
					,AllowRead
					,AllowAdd
					,AllowAddFile
					,AllowChange
					,AllowDelete
				FROM tDAFolderRight (NOLOCK)
				WHERE FolderKey = @SrcFolderKey		

				-- Save Keys
				INSERT #ClientFolderKey(SrcClientFolderKey, DestClientFolderKey)
				VALUES (@SrcFolderKey, @DestFolderKey)												
									
				-- Copy sub dirs recursively
				EXEC @RetVal = sptDAFolderCopyFolder @SrcProjectKey, @DestProjectKey, @SrcFolderKey, @DestFolderKey, @IsClientFolder, @UserKey

				-- If limit to 32 nesting levels is reached		 			
				IF @RetVal <> 1
					RETURN -1
			END										
		END
		
	END			
	
	RETURN 1
GO
