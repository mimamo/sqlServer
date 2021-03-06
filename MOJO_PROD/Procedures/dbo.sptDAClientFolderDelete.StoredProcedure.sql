USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderDelete]

	(
		@FolderKey int
	)

AS --Encrypt
	

/*
Old method recurses the folders and deletes all
Declare @CurKey int

Select @CurKey = -1

While 1=1
BEGIN

Select @CurKey = Min(ClientFolderKey) from tDAClientFolder Where ParentFolderKey = @FolderKey and ClientFolderKey > @CurKey
	if @CurKey is null
		Break
	
	exec sptDAClientFolderDelete @CurKey

END
*/

if exists(Select 1 from tDAClientFolder (nolock) Where ParentFolderKey = @FolderKey)
	return -1

Update tDAFile
Set ClientFolderKey = NULL
Where
	ClientFolderKey = @FolderKey
	
Delete tDAClientFolder
	Where ClientFolderKey = @FolderKey


return 1
GO
