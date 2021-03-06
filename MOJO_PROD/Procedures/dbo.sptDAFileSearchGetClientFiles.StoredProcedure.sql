USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileSearchGetClientFiles]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileSearchGetClientFiles]

	(
		@UserKey int
	)

AS --Encrypt


If exists(Select 1 from #tFileSearchAttr)
	Select tDAFile.*, 
		tDAClientFolder.FolderName, 
		tDAClientFolder.ProjectKey, 
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
		tUser3.FirstName + ' ' + tUser3.LastName as CheckedOutBy
	From 
		tDAFile (nolock)
		inner join (Select Distinct FileKey from #tFileSearchAttr) as fsa on fsa.FileKey = tDAFile.FileKey
		inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
		inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
		inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
		inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
		left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
		inner join tDAClientFolder (nolock) on tDAFile.ClientFolderKey = tDAClientFolder.ClientFolderKey
		inner join tProject (nolock) on tDAClientFolder.ProjectKey = tProject.ProjectKey
		inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
	Where
		tAssignment.UserKey = @UserKey
else

	Select tDAFile.*, 
		tDAClientFolder.FolderName, 
		tDAClientFolder.ProjectKey, 
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
		tUser3.FirstName + ' ' + tUser3.LastName as CheckedOutBy
	From 
		tDAFile (nolock)
		inner join (Select Distinct FileKey from #tFileSearch) as fs on fs.FileKey = tDAFile.FileKey
		inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
		inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
		inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
		left outer join tUser tUser3 (nolock) on tDAFile.CheckedOutByKey = tUser3.UserKey
		inner join tDAClientFolder (nolock) on tDAFile.ClientFolderKey = tDAClientFolder.ClientFolderKey
		inner join tProject (nolock) on tDAClientFolder.ProjectKey = tProject.ProjectKey
		inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey
	Where
		tAssignment.UserKey = @UserKey
GO
