USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetWebDavFolderNames]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetWebDavFolderNames]
	@ProjectKey int
AS

/*
|| When      Who Rel      What
|| 10/8/12   CRG 10.5.6.1 Created
|| 11/16/12  CRG 10.5.6.2 (160115) Changed join to a left join to handle projects with no clients
|| 1/15/14   CRG 10.5.7.6 Modified to ensure that the WebDAV safe names have been set for both the Client and the Project
*/

	DECLARE	@WebDavProjectNumber varchar(100),
			@WebDavProjectName varchar(100),
			@ClientKey int,
			@WebDavClientID varchar(100),
			@WebDavCompanyName varchar(200)
			
	SELECT	@WebDavProjectNumber = p.WebDavProjectNumber,
			@WebDavProjectName = p.WebDavProjectName,
			@ClientKey = p.ClientKey,
			@WebDavClientID = c.WebDavClientID,
			@WebDavCompanyName = c.WebDavCompanyName
	FROM	tProject p (nolock)
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	WHERE	p.ProjectKey = @ProjectKey

	IF @WebDavProjectNumber IS NULL OR @WebDavProjectName IS NULL
		EXEC sptProjectWebDavSafeFolders @ProjectKey, 0
		
	IF ISNULL(@ClientKey, 0) > 0
		IF @WebDavClientID IS NULL OR @WebDavCompanyName IS NULL
			EXEC sptCompanyWebDavSafeFolders @ClientKey, 0

	SELECT	p.ProjectNumber,
			p.ProjectName,
			p.WebDavProjectNumber,
			p.WebDavProjectName,
			c.CustomerID,
			c.CompanyName,
			c.WebDavClientID,
			c.WebDavCompanyName,
			p.OfficeKey,
			p.FilesArchived
	FROM	tProject p (nolock)
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	WHERE	p.ProjectKey = @ProjectKey
GO
