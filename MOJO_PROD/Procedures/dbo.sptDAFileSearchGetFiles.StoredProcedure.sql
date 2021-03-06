USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileSearchGetFiles]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileSearchGetFiles]

	(
		@UserKey int,
		@ViewAllProjects tinyint = 0
	)

AS --Encrypt

Declare @SecurityGroupKey int, @Admin tinyint

Select @SecurityGroupKey = SecurityGroupKey, @Admin = Administrator from tUser (nolock) Where UserKey = @UserKey

IF @ViewAllProjects = 0
BEGIN
	if @Admin = 0
		If exists(Select 1 from #tFileSearchAttr)
			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearchAttr) as fsa on fsa.FileKey = tDAFile.FileKey
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
				left outer join 
				(Select * from tDAFileRight (nolock) Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
				left outer join 
				(Select * from tDAFileRight (nolock) Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey
			Where	tAssignment.UserKey = @UserKey 
				
		else

			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey, 
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
				left outer join 
				(Select * from tDAFileRight Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
				left outer join 
				(Select * from tDAFileRight Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey
			Where	tAssignment.UserKey = @UserKey 
	else
		If exists(Select 1 from #tFileSearchAttr)
			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearchAttr) as fsa on fsa.FileKey = tDAFile.FileKey
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
			Where	tAssignment.UserKey = @UserKey 
		else

			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
			Where	tAssignment.UserKey = @UserKey 
END
ELSE
BEGIN
	if @Admin = 0
		If exists(Select 1 from #tFileSearchAttr)
			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearchAttr) as fsa on fsa.FileKey = tDAFile.FileKey
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				left outer join 
				(Select * from tDAFileRight (nolock) Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
				left outer join 
				(Select * from tDAFileRight (nolock) Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey
			
		else

			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
				left outer join 
				(Select * from tDAFileRight Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
				left outer join 
				(Select * from tDAFileRight Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey
	else
		If exists(Select 1 from #tFileSearchAttr)
			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearchAttr) as fsa on fsa.FileKey = tDAFile.FileKey
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
		else

			Select distinct 
				tDAFile.FileKey,
				tDAFile.FolderKey,
				tDAFile.ClientFolderKey,
				tDAFile.FileName,
				tDAFile.Description,
				tDAFile.TrackRevisions,
				tDAFile.RevisionsToKeep,
				tDAFile.CurrentVersionKey,
				tDAFile.CheckedOutByKey,
				tDAFile.CheckedOutDate,
				tDAFile.CheckOutComment,
				tDAFile.LockFile,
				tDAFile.AddedDate,
				tDAFile.AddedByKey,
				tDAFolder.FolderName, 
				tDAFolder.ProjectKey, 
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
				inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
				inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
				inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
				inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
				left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
				inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
				inner join tProject (nolock) on tDAFolder.ProjectKey = tProject.ProjectKey
END
GO
