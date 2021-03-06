USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavGetConversionData]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavGetConversionData]
	@CompanyKey int
AS

/*
|| When      Who Rel      What
|| 11/17/11  CRG 10.5.5.0 Created
|| 2/12/13   CRG 10.5.6.4 Changed inner join to left join on the ClientKey for projects that do not have a Client
|| 2/13/13   CRG 10.5.6.5 Now pulling WebDAV safe names for project and client
*/

	SELECT	f.*, 
			ISNULL(p.WebDavProjectNumber, p.ProjectNumber) AS ProjectNumber, 
			ISNULL(p.WebDavProjectName, p.ProjectName) AS ProjectName, 
			ISNULL(c.WebDavClientID, c.CustomerID) AS CustomerID, 
			ISNULL(c.WebDavCompanyName, c.CompanyName) AS CompanyName, 
			ISNULL(ps.IsActive, 1) AS Active
	INTO	#folders
	FROM	tDAFolder f (nolock)
	INNER JOIN tProject p (nolock) ON f.ProjectKey = p.ProjectKey
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE	p.CompanyKey = @CompanyKey

	SELECT	*
	FROM	#folders

	SELECT	fr.*
	FROM	tDAFolderRight fr (nolock)
	INNER JOIN #folders f ON fr.FolderKey = f.FolderKey

	SELECT	fl.*, f.ProjectKey
	FROM	tDAFile fl (nolock)
	INNER JOIN #folders f ON fl.FolderKey = f.FolderKey

	EXEC sptWebDavAttachmentSync @CompanyKey, 0, 0
GO
