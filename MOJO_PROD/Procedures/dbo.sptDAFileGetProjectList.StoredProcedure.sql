USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileGetProjectList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileGetProjectList]

	(
		@ProjectKey int,
		@UserKey int
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 3/26/08   CRG 1.0.0.0  Added FileFolderName, FormattedFileSize and ASC_Selected
|| 5/19/09   CRG 10.5.0.0 Added DisplayFolderName, Type, Entity, EntityKey, LinkDescription, and added sorting for the Activity Links screen
*/

Declare @SecurityGroupKey int, @Admin tinyint

Select @SecurityGroupKey = SecurityGroupKey, @Admin = Administrator from tUser (nolock) Where UserKey = @UserKey

if @Admin = 0
	Select tDAFile.*, 
		tDAFolder.FolderName, 
		tDAFolder.ProjectKey, 
		tDAFolder.SystemPath,
		tProject.ProjectNumber, 
		tProject.ProjectName, 
		tDAFileVersion.VersionNumber,
		tDAFileVersion.VersionComments,
		tDAFileVersion.FileSize,
		tDAFileVersion.Status,
		tDAFileVersion.Deleted,
		tDAFileVersion.VersionDate,
		tUser.FirstName + ' ' + tUser.LastName as UpdatedBy,
		tUser2.FirstName + ' ' + tUser2.LastName as AddedBy,
		tUser3.FirstName + ' ' + tUser3.LastName as CheckedOutBy,
		ISNULL(tUserRight.AllowRead, tGroupRight.AllowRead) as AllowRead,
		ISNULL(tUserRight.AllowUpdate, tGroupRight.AllowUpdate) as AllowUpdate,
		ISNULL(tUserRight.AllowChange, tGroupRight.AllowChange) as AllowChange,
		ISNULL(tUserRight.AllowDelete, tGroupRight.AllowDelete) as AllowDelete,
		CASE tDAFolder.ParentFolderKey
			WHEN 0 THEN tDAFile.FileName
			ELSE ISNULL(tDAFolder.FolderName, '') + '\' + ISNULL(tDAFile.FileName, '')
		END AS FileFolderName,
		CASE 
			WHEN tDAFileVersion.FileSize > 1000000 THEN CAST(ROUND(CAST(tDAFileVersion.FileSize AS float) / 1000000, 2) AS varchar) + ' MB'
			ELSE CAST(ROUND(CAST(tDAFileVersion.FileSize AS float) / 1000, 0) AS varchar) + ' KB'
		END AS FormattedFileSize,
		0 AS ASC_Selected,
		CASE tDAFolder.ParentFolderKey
			WHEN 0 THEN NULL
			ELSE tDAFolder.FolderName
		END AS DisplayFolderName,
		'Project File' as Type, 
		'tDAFile' as Entity, 
		tDAFile.FileKey as EntityKey,
		tDAFile.FileName as LinkDescription
	From 
		tDAFile (nolock)
		inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
		inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
		inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
		left outer join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
		left outer join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
		left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
		left outer join 
		(Select * from tDAFileRight (nolock) Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
		left outer join 
		(Select * from tDAFileRight (nolock) Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey
	Where
		tProject.ProjectKey = @ProjectKey
	ORDER BY DisplayFolderName, FileName
else
	Select tDAFile.*, 
		tDAFolder.FolderName, 
		tDAFolder.ProjectKey, 
		tDAFolder.SystemPath,
		tProject.ProjectNumber, 
		tProject.ProjectName, 
		tDAFileVersion.VersionNumber,
		tDAFileVersion.VersionComments,
		tDAFileVersion.FileSize,
		tDAFileVersion.Status,
		tDAFileVersion.Deleted,
		tDAFileVersion.VersionDate,
		tUser.FirstName + ' ' + tUser.LastName as UpdatedBy,
		tUser2.FirstName + ' ' + tUser2.LastName as AddedBy,
		tUser3.FirstName + ' ' + tUser3.LastName as CheckedOutBy,
		1 as AllowRead,
		1 as AllowUpdate,
		1 as AllowChange,
		1 as AllowDelete,
		CASE tDAFolder.ParentFolderKey
			WHEN 0 THEN tDAFile.FileName
			ELSE ISNULL(tDAFolder.FolderName, '') + '\' + ISNULL(tDAFile.FileName, '')
		END AS FileFolderName,
		CASE 
			WHEN tDAFileVersion.FileSize > 1000000 THEN CAST(ROUND(CAST(tDAFileVersion.FileSize AS float) / 1000000, 2) AS varchar) + ' MB'
			ELSE CAST(ROUND(CAST(tDAFileVersion.FileSize AS float) / 1000, 0) AS varchar) + ' KB'
		END AS FormattedFileSize,
		0 AS ASC_Selected,
		CASE tDAFolder.ParentFolderKey
			WHEN 0 THEN NULL
			ELSE tDAFolder.FolderName
		END AS DisplayFolderName,
		'Project File' as Type, 
		'tDAFile' as Entity, 
		tDAFile.FileKey as EntityKey,
		tDAFile.FileName as LinkDescription
	From 
		tDAFile (nolock)
		inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
		inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
		inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
		left outer join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
		left outer join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
		left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
	Where
		tProject.ProjectKey = @ProjectKey
	ORDER BY DisplayFolderName, FileName
GO
