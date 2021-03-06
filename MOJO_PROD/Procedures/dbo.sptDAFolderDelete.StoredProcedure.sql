USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderDelete]

	(
		@FolderKey int
	)

AS --Encrypt
	
Declare @CurKey int

Select @CurKey = -1

While 1=1
BEGIN

Select @CurKey = Min(FolderKey) from tDAFolder (nolock) Where ParentFolderKey = @FolderKey and FolderKey > @CurKey
	if @CurKey is null
		Break
	
	exec sptDAFolderDelete @CurKey

END

	Update tProject Set ImageFolderKey = NULL Where ImageFolderKey = @FolderKey
	
	Delete tDAFileRight 
		Where FileKey in (Select FileKey from tDAFile Where FolderKey = @FolderKey)
	
	Delete tDAFileVersion
		Where FileKey in (Select FileKey from tDAFile Where FolderKey = @FolderKey)
		
	Delete tDAFile
		Where FolderKey = @FolderKey
		
	Delete tDAFolderRight
		Where FolderKey = @FolderKey
		
	Delete tDAFolder
		Where FolderKey = @FolderKey



return 1
GO
