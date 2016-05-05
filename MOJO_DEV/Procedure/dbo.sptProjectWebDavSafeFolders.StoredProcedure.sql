USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectWebDavSafeFolders]    Script Date: 04/29/2016 16:23:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sptProjectWebDavSafeFolders]
	@ProjectKey int,
	@SelectValues tinyint = 1 --If 0, the query at the end will not run
AS 

/*
|| When      Who Rel      What
|| 10/5/12   CRG 10.5.6.1 Created to set the safe WebDAV folder names
*/

	DECLARE	@CompanyKey int,
			@SafeFolder varchar(200),
			@ProjectNumber varchar(50),
			@ProjectName varchar(100)

	SELECT	@CompanyKey = CompanyKey,
			@ProjectNumber = ProjectNumber,
			@ProjectName = ProjectName
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey  
 
	SELECT @SafeFolder = dbo.fSafeWebDavFolder(@ProjectNumber, 1)
 
	WHILE(1=1)
	BEGIN
		IF NOT EXISTS
			(SELECT	1
			FROM	tProject (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		UPPER(WebDavProjectNumber) = UPPER(@SafeFolder)
			AND		ProjectKey <> @ProjectKey)
		BEGIN
			UPDATE	tProject
			SET		WebDavProjectNumber = @SafeFolder,
					WebDavProjectName = dbo.fSafeWebDavFolder(@ProjectName, 0)
			WHERE	ProjectKey = @ProjectKey
   
			BREAK --Exit the loop
		END
		
		IF LEN(@SafeFolder) >= 100
			BREAK
  
		SELECT @SafeFolder = ISNULL(@SafeFolder, '') + '_'
	END
 
	IF @SelectValues = 1
		SELECT WebDavProjectNumber, WebDavProjectName
		FROM tProject (nolock)
		WHERE ProjectKey = @ProjectKey
