USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileGet]

	(
		@FileKey int,
		@UserKey int
	)

AS --Encrypt

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
		ISNULL(tUserRight.AllowDelete, tGroupRight.AllowDelete) as AllowDelete
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
		tDAFile.FileKey = @FileKey
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
		1 as AllowDelete
	From 
		tDAFile (nolock)
		inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
		inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
		inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
		left outer join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
		left outer join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
		left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
	Where
		tDAFile.FileKey = @FileKey
GO
