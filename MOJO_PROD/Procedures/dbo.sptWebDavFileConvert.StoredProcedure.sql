USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileConvert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileConvert]
	@CompanyKey int = NULL
AS

/*
|| When      Who Rel      What
|| 4/9/13    CRG 10.5.6.6 Created
*/

	DECLARE	@FolderKey int,
			@ProjectKey int,
			@Path varchar(2000),
			@FileKey int,
			@NewFileKey uniqueidentifier

	CREATE TABLE #CompanyKeys (CompanyKey int NULL)

	IF @CompanyKey IS NULL
		INSERT	#CompanyKeys (CompanyKey)
		SELECT	p.CompanyKey
		FROM	tPreference p (nolock)
		INNER JOIN tCompany c (nolock) ON p.CompanyKey = c.CompanyKey
		WHERE	p.UsingWebDav = 1
		AND		c.Active = 1 
		AND		ISNULL(c.Locked, 0) = 0 
		AND		c.OwnerCompanyKey IS NULL
	ELSE
		INSERT	#CompanyKeys (CompanyKey) VALUES (@CompanyKey)

	SELECT	@CompanyKey = -1

	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	#CompanyKeys
		WHERE	CompanyKey > @CompanyKey

		IF @CompanyKey IS NULL
			BREAK

		SELECT	@FolderKey = -1

		WHILE (1=1)
		BEGIN
			SELECT	@FolderKey = MIN(f.FolderKey)
			FROM	tDAFolder f (nolock)
			INNER JOIN tProject p (nolock) ON f.ProjectKey = p.ProjectKey
			WHERE	p.CompanyKey = @CompanyKey
			AND		f.WebDavPath IS NOT NULL
			AND		f.FolderKey > @FolderKey

			IF @FolderKey IS NULL
				BREAK

			SELECT	@ProjectKey = ProjectKey,
					@Path = WebDavRelativePath
			FROM	tDAFolder (nolock)
			WHERE	FolderKey = @FolderKey

			SELECT	@FileKey = -1

			WHILE (1=1)
			BEGIN
				SELECT	@FileKey = MIN(FileKey)
				FROM	tDAFile (nolock)
				WHERE	FolderKey = @FolderKey
				AND		WebDavPath IS NOT NULL
				AND		NewFileKey IS NULL
				AND		FileKey > @FileKey

				IF @FileKey IS NULL
					BREAK

				SELECT	@NewFileKey = NEWID()

				INSERT	tWebDavFile
						(FileKey,
						CompanyKey,
						ProjectKey,
						Path,
						FileName,
						Description)
				SELECT	@NewFileKey,
						@CompanyKey,
						@ProjectKey,
						@Path,
						FileName,
						Description
				FROM	tDAFile (nolock)
				WHERE	FileKey = @FileKey

				INSERT	tWebDavFileHistory
						(FileKey,
						Modified,
						ModifiedBy,
						FileSize,
						Comments,
						Action)
				SELECT	@NewFileKey,
						VersionDate,
						VersionByKey,
						FileSize,
						VersionComments,
						-1
				FROM	tDAFileVersion (nolock)
				WHERE	FileKey = @FileKey
				
				UPDATE	tDAFile
				SET		NewFileKey = @NewFileKey
				WHERE	FileKey = @FileKey
			END
		END

	END
GO
