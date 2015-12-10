USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderRightInsert]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderRightInsert]
(
	@FolderKey int,
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

if exists(Select 1 from tDAFolderRight (nolock) Where FolderKey = @FolderKey and Entity = @Entity and EntityKey = @EntityKey)
	return 1
	
Insert tDAFolderRight (FolderKey, Entity, EntityKey, AllowAdd, AllowAddFile, AllowChange, AllowRead, AllowDelete)
Values (@FolderKey, @Entity, @EntityKey, 1, 1, 1, 1, 1)

return 1
GO
