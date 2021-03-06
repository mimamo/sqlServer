USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderUpdate]

	(
		@FolderKey int,
		@ParentFolderKey int,
		@UserKey int,
		@FolderName varchar(300),
		@FolderDescription varchar(1000)
	)

AS



Declare @SystemPath as varchar(255), @ParentPath varchar(255), @ProjectKey int

if @ParentFolderKey = 0 
	return -1
	
if exists(
	Select 1 from tDAFolder (nolock) 
	Where ParentFolderKey = @ParentFolderKey 
	and RTRIM(LTRIM(UPPER(FolderName))) = RTRIM(LTRIM(UPPER(@FolderName)))
	and FolderKey <> @FolderKey)
	
	return -2
	
Select @SystemPath = SystemPath, @ProjectKey = ProjectKey from tDAFolder (nolock) Where FolderKey = @FolderKey
Select @ParentPath = SystemPath from tDAFolder (nolock) Where FolderKey = @ParentFolderKey

Update tDAFolder
Set FolderName = @FolderName,
	ParentFolderKey = @ParentFolderKey,
	FolderDescription = @FolderDescription,
	SystemPath = @ParentPath + '\' + @FolderName
Where FolderKey = @FolderKey

Update tDAFolder
Set SystemPath = Replace(SystemPath, @SystemPath + '\', @ParentPath + '\' + @FolderName + '\')
Where ProjectKey = @ProjectKey
GO
