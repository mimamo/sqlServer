USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderGetProjectList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderGetProjectList]

	(
		@ProjectKey int,
		@UserKey int
	)

AS --Encrypt

Declare @SecurityGroupKey int, @Admin tinyint

Select @SecurityGroupKey = SecurityGroupKey, @Admin = Administrator from tUser (nolock) Where UserKey = @UserKey

if @Admin = 0
	Select 
		tDAFolder.*, 
		ISNULL(tUserRight.AllowRead, tGroupRight.AllowRead) as AllowRead,
		ISNULL(tUserRight.AllowAdd, tGroupRight.AllowAdd) as AllowAdd,
		ISNULL(tUserRight.AllowAddFile, tGroupRight.AllowAddFile) as AllowAddFile,
		ISNULL(tUserRight.AllowChange, tGroupRight.AllowChange) as AllowChange,
		ISNULL(tUserRight.AllowDelete, tGroupRight.AllowDelete) as AllowDelete
		from tDAFolder (nolock) 
			left outer join 
			(Select * from tDAFolderRight (nolock) Where Entity = 'User' and EntityKey = @UserKey) as tUserRight on tDAFolder.FolderKey = tUserRight.FolderKey
			left outer join 
			(Select * from tDAFolderRight (nolock) Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tGroupRight on tDAFolder.FolderKey = tGroupRight.FolderKey
		Where ProjectKey = @ProjectKey
else
	Select 
		tDAFolder.*, 
		1 as AllowRead,
		1 as AllowAdd,
		1 as AllowAddFile,
		1 as AllowChange,
		1 as AllowDelete
		from tDAFolder (nolock) 
		Where ProjectKey = @ProjectKey
GO
