USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileRightInsert]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileRightInsert]
(
	@FileKey int,
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

if exists(Select 1 from tDAFileRight (nolock) Where FileKey = @FileKey and Entity = @Entity and EntityKey = @EntityKey)
	return 1
	
Insert tDAFileRight (FileKey, Entity, EntityKey, AllowUpdate, AllowChange, AllowRead, AllowDelete)
Values (@FileKey, @Entity, @EntityKey, 1, 1, 1, 1)

return 1
GO
