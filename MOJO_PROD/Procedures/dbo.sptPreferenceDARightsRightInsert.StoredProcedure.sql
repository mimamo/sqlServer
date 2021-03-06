USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsRightInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsRightInsert]
(
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

if exists(Select 1 from tPreferenceDARights (NOLOCK) Where CompanyKey = @CompanyKey and Entity = @Entity and EntityKey = @EntityKey)
	return 1
	
Insert tPreferenceDARights (CompanyKey, Entity, EntityKey, AllowAdd, AllowAddFile, AllowChange, AllowRead, AllowDelete)
Values (@CompanyKey, @Entity, @EntityKey, 1, 1, 1, 1, 1)

return 1
GO
