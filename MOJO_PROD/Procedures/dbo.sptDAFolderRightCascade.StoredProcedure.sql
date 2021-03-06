USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderRightCascade]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderRightCascade]
(
	@FolderKey int,
	@FirstFolder tinyint = 0
)
AS --Encrypt

/*
|| When       Who Rel     What
|| 1/8/10     RLB 10516   (71657) AllowAddFile was twice on the selecte's change the second one to AllowChange to cascade rights correctly
*/

Declare @CurKey int

-- If this is the first folder, update the rights on the files
if @FirstFolder = 1
BEGIN
	Delete tDAFileRight 
	from
		tDAFile
	Where
		tDAFileRight.FileKey = tDAFile.FileKey and
		tDAFile.FolderKey = @FolderKey
		
	Insert tDAFileRight (FileKey, Entity, EntityKey, AllowRead, AllowUpdate, AllowChange, AllowDelete)
	Select
		tDAFile.FileKey, tDAFolderRight.Entity, tDAFolderRight.EntityKey, AllowRead, AllowAddFile, AllowChange, AllowDelete
	From
		tDAFile (nolock)
		inner join tDAFolderRight (nolock) on tDAFolderRight.FolderKey = tDAFile.FolderKey
	Where
		tDAFile.FolderKey = @FolderKey
END


Select @CurKey = -1
While 1=1
BEGIN

	Select @CurKey = Min(FolderKey) from tDAFolder (nolock) Where ParentFolderKey = @FolderKey and FolderKey > @CurKey
	if @CurKey is null
		break
		
	Delete tDAFolderRight Where FolderKey = @CurKey
	
	Insert tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete)
	Select @CurKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete
	From tDAFolderRight (nolock)
		Where tDAFolderRight.FolderKey = @FolderKey
		
	Delete tDAFileRight 
	from
		tDAFile
	Where
		tDAFileRight.FileKey = tDAFile.FileKey and
		tDAFile.FolderKey = @CurKey
		
	Insert tDAFileRight (FileKey, Entity, EntityKey, AllowRead, AllowUpdate, AllowChange, AllowDelete)
	Select
		tDAFile.FileKey, tDAFolderRight.Entity, tDAFolderRight.EntityKey, AllowRead, AllowAddFile, AllowChange, AllowDelete
	From
		tDAFile (nolock)
		inner join tDAFolderRight (nolock) on tDAFolderRight.FolderKey = tDAFile.FolderKey
	Where
		tDAFile.FolderKey = @CurKey
		
	exec sptDAFolderRightCascade @CurKey, 0

END
GO
