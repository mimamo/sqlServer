USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderGetFiles]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderGetFiles]

	(
		@FolderKey int
	)

AS --Encrypt

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
	tUser2.FirstName + ' ' + tUser2.LastName as AddedBy
From 
	tDAFile (nolock)
	inner join tDAFileVersion (nolock) on tDAFile.CurrentVersionKey = tDAFileVersion.FileVersionKey
	inner join tUser (nolock) on tDAFileVersion.VersionByKey = tUser.UserKey
	inner join tUser tUser2 (nolock) on tDAFile.AddedByKey = tUser2.UserKey
	inner join tDAClientFolder (nolock) on tDAFile.ClientFolderKey = tDAClientFolder.ClientFolderKey
	inner join tProject (nolock) on tDAClientFolder.ProjectKey = tProject.ProjectKey
Where
	tDAFile.ClientFolderKey = @FolderKey
Order By
	FileName
GO
