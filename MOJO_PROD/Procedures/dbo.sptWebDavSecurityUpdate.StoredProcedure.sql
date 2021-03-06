USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityUpdate]
	@CompanyKey int,
	@ProjectKey int,
    @Entity varchar(50),
	@EntityKey int,
	@Path varchar(2000),
	@AddFolder tinyint,
	@DeleteFolder tinyint,
	@RenameMoveFolder tinyint,
	@ViewFolder tinyint,
	@ModifyFolderSecurity tinyint,
	@AddFile tinyint,
	@UpdateFile tinyint,
	@DeleteFile tinyint,
	@RenameMoveFile tinyint
AS

/*
|| When      Who Rel      What
|| 9/8/11    CRG 10.5.4.8 Created
*/

	SELECT	@ProjectKey = ISNULL(@ProjectKey, 0),
			@Entity = ISNULL(@Entity, ''),
			@EntityKey = ISNULL(@EntityKey, 0),
			@Path = ISNULL(@Path, '')

	BEGIN TRAN

	--Test to make sure that there is not already a row with this data. 
	--The identity column WebDavSeucirytKey is really just extra here and not really used.
	--The true "key" is CompanyKey, ProjectKey, Entity, EntityKey, Path. But, since Path is varchar(2000), we can't use it in an index.
	DECLARE	@WebDavSecurityKey int
	SELECT	@WebDavSecurityKey = ISNULL(MIN(WebDavSecurityKey), 0)
	FROM	tWebDavSecurity --don't use nolock because we want to ensure that we have committed data here so that the rows are definitely unique
	WHERE	CompanyKey = @CompanyKey
	AND		ProjectKey = @ProjectKey
	AND		Entity = @Entity
	AND		EntityKey = @EntityKey
	AND		ISNULL(Path, '') = @Path

	IF @WebDavSecurityKey = 0
	BEGIN
		INSERT	tWebDavSecurity
				(CompanyKey,
				ProjectKey,
				Entity,
				EntityKey,
				Path,
				AddFolder,
				DeleteFolder,
				RenameMoveFolder,
				ViewFolder,
				ModifyFolderSecurity,
				AddFile,
				UpdateFile,
				DeleteFile,
				RenameMoveFile)
		VALUES	(@CompanyKey,
				@ProjectKey,
				@Entity,
				@EntityKey,
				@Path,
				@AddFolder,
				@DeleteFolder,
				@RenameMoveFolder,
				@ViewFolder,
				@ModifyFolderSecurity,
				@AddFile,
				@UpdateFile,
				@DeleteFile,
				@RenameMoveFile)
		
		SELECT	@WebDavSecurityKey = @@IDENTITY

		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
	END
	ELSE
	BEGIN
		UPDATE	tWebDavSecurity
		SET		AddFolder = @AddFolder,
				DeleteFolder = @DeleteFolder,
				RenameMoveFolder = @RenameMoveFolder,
				ViewFolder = @ViewFolder,
				ModifyFolderSecurity = @ModifyFolderSecurity,
				AddFile = @AddFile,
				UpdateFile = @UpdateFile,
				DeleteFile = @DeleteFile,
				RenameMoveFile = @RenameMoveFile
		WHERE	WebDavSecurityKey = @WebDavSecurityKey

		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
	END

	COMMIT TRAN

	RETURN @WebDavSecurityKey
GO
