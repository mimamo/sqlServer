USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderRightUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderRightUpdate]
(
	@FolderKey int,
	@Entity varchar(50),
	@EntityKey int,
	@AllowRead tinyint,
	@AllowAdd tinyint,
	@AllowAddFile tinyint,
	@AllowChange tinyint,
	@AllowDelete tinyint
)

AS --Encrypt

if exists(Select 1 from tDAFolderRight (nolock) Where FolderKey = @FolderKey and Entity = @Entity and EntityKey = @EntityKey)
	Update tDAFolderRight
	Set
		AllowRead = @AllowRead,
		AllowAdd = @AllowAdd,
		AllowAddFile = @AllowAddFile,
		AllowChange = @AllowChange,
		AllowDelete = @AllowDelete
	Where
		FolderKey = @FolderKey and
		Entity = @Entity and
		EntityKey = @EntityKey
else
	Insert tDAFolderRight (FolderKey, Entity, EntityKey, AllowAdd, AllowAddFile, AllowChange, AllowRead, AllowDelete)
	Values (@FolderKey, @Entity, @EntityKey, @AllowAdd, @AllowAddFile, @AllowChange, @AllowRead, @AllowDelete)

return 1
GO
