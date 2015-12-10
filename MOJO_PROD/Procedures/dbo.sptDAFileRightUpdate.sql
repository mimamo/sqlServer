USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileRightUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileRightUpdate]
(
	@FileKey int,
	@Entity varchar(50),
	@EntityKey int,
	@AllowRead tinyint,
	@AllowUpdate tinyint,
	@AllowChange tinyint,
	@AllowDelete tinyint
)

AS --Encrypt

if exists(Select 1 from tDAFileRight (nolock) Where FileKey = @FileKey and Entity = @Entity and EntityKey = @EntityKey)
	Update tDAFileRight
	Set
		AllowRead = @AllowRead,
		AllowUpdate = @AllowUpdate,
		AllowChange = @AllowChange,
		AllowDelete = @AllowDelete
	Where
		FileKey = @FileKey and
		Entity = @Entity and
		EntityKey = @EntityKey
else
	Insert tDAFileRight (FileKey, Entity, EntityKey, AllowUpdate, AllowChange, AllowRead, AllowDelete)
	Values (@FileKey, @Entity, @EntityKey, @AllowUpdate, @AllowChange, @AllowRead, @AllowDelete)

return 1
GO
