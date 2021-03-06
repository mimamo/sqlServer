USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileVersionGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileVersionGet]

	(
		@FileVersionKey int,
		@UserKey int
	)

AS --Encrypt

Declare @SecurityGroupKey int

Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey

Select tDAFileVersion.*,
	tDAFile.FileName,
	tDAFile.CurrentVersionKey,
	tDAFile.FolderKey,
	tDAFolder.SystemPath,
	tUser.FirstName + ' ' + tUser.LastName as VersionBy,
	ISNULL(tUserRight.AllowRead, tGroupRight.AllowRead) as AllowRead,
	ISNULL(tUserRight.AllowUpdate, tGroupRight.AllowUpdate) as AllowUpdate,
	ISNULL(tUserRight.AllowChange, tGroupRight.AllowChange) as AllowChange,
	ISNULL(tUserRight.AllowDelete, tGroupRight.AllowDelete) as AllowDelete
From 
	tDAFileVersion (nolock)
	inner join tDAFile (nolock) on tDAFileVersion.FileKey = tDAFile.FileKey
	inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
	inner join tUser (nolock) on tUser.UserKey = tDAFileVersion.VersionByKey
	left outer join 
	(Select * from tDAFileRight (nolock) Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFile.FileKey = tUserRight.FileKey
	left outer join 
	(Select * from tDAFileRight (nolock) Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFile.FileKey = tGroupRight.FileKey

Where
	tDAFileVersion.FileVersionKey = @FileVersionKey
GO
