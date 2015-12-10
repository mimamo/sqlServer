USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityGetList]
	@CompanyKey int,
	@ProjectKey int = null,
	@ProjectNumber varchar(50) = null --Either ProjectKey or ProjectNumber must be passed in
AS

/*
|| When      Who Rel      What
|| 9/1/11    CRG 10.5.4.7 Created to get all security for a project or company
|| 2/1/2013  GWG 10.5.6.4 Took out the isnull on s.ProjectKey
|| 2/15/14   GWG 10.5.7.1 Added the Security group name so new app doesnt need to get it
*/

	IF @ProjectKey IS NULL AND @ProjectNumber is not null
		SELECT	@ProjectKey = ProjectKey
		FROM	tProject (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UPPER(LTRIM(RTRIM(ProjectNumber))) = UPPER(LTRIM(RTRIM(@ProjectNumber)))

	SELECT	s.WebDavSecurityKey,
			s.CompanyKey,
			s.ProjectKey,
			s.Entity,
			s.EntityKey,
			CASE s.Entity
				WHEN 'tUser' THEN u.UserName
				ELSE sg.GroupName
			END AS UserName,
			ISNULL(UPPER(s.Path), '') AS Path,
			ISNULL(s.Path, '') AS DisplayPath, --used to display the path in "regular" case to the user
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
	LEFT JOIN vUserName u (nolock) ON s.Entity = 'tUser' AND s.EntityKey = u.UserKey
	LEFT JOIN tSecurityGroup sg (nolock) on s.Entity = 'tSecurityGroup' AND s.EntityKey = sg.SecurityGroupKey
	WHERE	s.CompanyKey = @CompanyKey
	AND		(s.ProjectKey = 0 --CompanyLevel
			OR	
			s.ProjectKey = @ProjectKey)
	ORDER BY s.ProjectKey, s.Path
GO
