USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetForWebDav]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetForWebDav]
	@CompanyKey int,
	@ProjectNumber varchar(50)
AS

/*
|| When      Who Rel      What
|| 11/6/12   CRG 10.5.6.2 Created to for the WebDAV verify folder name process in the conversion program
*/

	DECLARE	@ProjectKey int

	SELECT	@ProjectKey = ProjectKey
	FROM	tProject (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		UPPER(WebDavProjectNumber) = UPPER(@ProjectNumber)

	IF @ProjectKey IS NULL
	BEGIN
		SELECT	@ProjectKey = ProjectKey
		FROM	tProject (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UPPER(ProjectNumber) = UPPER(@ProjectNumber)

		IF @ProjectKey > 0
			EXEC sptProjectWebDavSafeFolders @ProjectKey, 0
	END			

	SELECT	WebDavProjectNumber, WebDavProjectName
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey
GO
