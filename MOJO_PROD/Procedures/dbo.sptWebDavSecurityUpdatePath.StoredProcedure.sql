USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityUpdatePath]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityUpdatePath]
	@CompanyKey int,
	@ProjectKey int = null,
	@ProjectNumber varchar(50) = null, --Either ProjectKey or ProjectNumber must be passed in
	@OriginalPath varchar(2000),
	@NewPath varchar(2000),
	@IsCopy tinyint = 0 --If 0, then it's considered a move
AS

/*
|| When      Who Rel      What
|| 8/26/11   CRG 10.5.4.7 Created
|| 10/9/12   CRG 10.5.6.1 Now calling sptWebDavGetProjectFromNumber
*/

	IF @ProjectKey IS NULL
		EXEC @ProjectKey = sptWebDavGetProjectFromNumber @CompanyKey, @ProjectNumber

	--Remove the / from the end of the paths
	SELECT	@OriginalPath = ISNULL(@OriginalPath, '')
	IF CHARINDEX('/', @OriginalPath, LEN(@OriginalPath)) > 0
		SELECT @OriginalPath = SUBSTRING(@OriginalPath, 0, LEN(@OriginalPath) - 1)

	SELECT	@NewPath = ISNULL(@NewPath, '')
	IF CHARINDEX('/', @NewPath, LEN(@NewPath)) > 0
		SELECT @NewPath = SUBSTRING(@NewPath, 0, LEN(@NewPath) - 1)

	CREATE TABLE #keys 
		(WebDavSecurityKey int NULL,
		Path varchar(2000) NULL,
		NewPath varchar(2000) NULL)

	--Find all of the records that refer to that path (including its sub folders)
	INSERT	#keys (WebDavSecurityKey, Path)
	SELECT	WebDavSecurityKey, Path
	FROM	tWebDavSecurity (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		ProjectKey = @ProjectKey
	AND		UPPER(LEFT(Path, LEN(@OriginalPath))) = UPPER(@OriginalPath)

	--Add a ~ at the front of the temp paths to ensure that the replace will replace paths starting at the beginning (in case there is the same path pattern further down the chain)
	UPDATE	#keys
	SET		Path = '~' + ISNULL(Path, '')

	SELECT @NewPath = ISNULL(@NewPath, '')


	--Set the NewPath field replacing the OriginalPath with the TargetPath
	UPDATE	#keys
	SET		NewPath = REPLACE(Path, '~' + @OriginalPath, @NewPath)

	IF @IsCopy = 1
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
		SELECT	s.CompanyKey,
				s.ProjectKey,
				s.Entity,
				s.EntityKey,
				tmp.NewPath,
				s.AddFolder,
				s.DeleteFolder,
				s.RenameMoveFolder,
				s.ViewFolder,
				s.ModifyFolderSecurity,
				s.AddFile,
				s.UpdateFile,
				s.DeleteFile,
				s.RenameMoveFile
		FROM	tWebDavSecurity s (nolock)
		INNER JOIN #keys tmp ON s.WebDavSecurityKey = tmp.WebDavSecurityKey
	END
	ELSE
	BEGIN
		UPDATE	tWebDavSecurity
		SET		Path = tmp.NewPath
		FROM	tWebDavSecurity,
				#keys tmp
		WHERE	tWebDavSecurity.WebDavSecurityKey = tmp.WebDavSecurityKey
	END
GO
