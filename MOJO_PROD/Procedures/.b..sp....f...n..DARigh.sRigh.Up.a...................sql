USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsRightUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsRightUpdate]
(
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@AllowRead tinyint,
	@AllowAdd tinyint,
	@AllowAddFile tinyint,
	@AllowChange tinyint,
	@AllowDelete tinyint
)

AS --Encrypt

if exists(Select 1 from tPreferenceDARights (NOLOCK) Where CompanyKey = @CompanyKey and Entity = @Entity and EntityKey = @EntityKey)
	Update tPreferenceDARights
	Set
		AllowRead = @AllowRead,
		AllowAdd = @AllowAdd,
		AllowAddFile = @AllowAddFile,
		AllowChange = @AllowChange,
		AllowDelete = @AllowDelete
	Where
		CompanyKey = @CompanyKey and
		Entity = @Entity and
		EntityKey = @EntityKey
else
	Insert tPreferenceDARights (CompanyKey, Entity, EntityKey, AllowAdd, AllowAddFile, AllowChange, AllowRead, AllowDelete)
	Values (@CompanyKey, @Entity, @EntityKey, @AllowAdd, @AllowAddFile, @AllowChange, @AllowRead, @AllowDelete)

return 1
GO
