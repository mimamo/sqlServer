USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityCopyProject]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityCopyProject]
	@ProjectKey int,
	@CopyToProjectKey int
AS

/*
|| When      Who Rel      What
|| 9/6/12    CRG 10.5.6.0 Created to copy security from one project to another
*/

	DECLARE	@WebDavSecurityKey int,
			@CompanyKey int,
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

	SELECT	@CompanyKey = CompanyKey
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	SELECT	@WebDavSecurityKey = 0

	WHILE (1=1)
	BEGIN
		SELECT	@WebDavSecurityKey = MIN(WebDavSecurityKey)
		FROM	tWebDavSecurity (nolock)
		WHERE	ProjectKey = @ProjectKey
		AND		WebDavSecurityKey > @WebDavSecurityKey

		IF @WebDavSecurityKey IS NULL
			BREAK

		SELECT	@Entity = Entity,
				@EntityKey = EntityKey,
				@Path = Path,
				@AddFolder = AddFolder,
				@DeleteFolder = DeleteFolder,
				@RenameMoveFolder = RenameMoveFolder,
				@ViewFolder = ViewFolder,
				@ModifyFolderSecurity = ModifyFolderSecurity,
				@AddFile = AddFile,
				@UpdateFile = UpdateFile,
				@DeleteFile = DeleteFile,
				@RenameMoveFile = RenameMoveFile
		FROM	tWebDavSecurity (nolock)
		WHERE	WebDavSecurityKey = @WebDavSecurityKey

		EXEC sptWebDavSecurityUpdate
				@CompanyKey,
				@CopyToProjectKey,
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
				@RenameMoveFile
	END
GO
