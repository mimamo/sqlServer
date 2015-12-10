USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsRightDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsRightDelete]
(
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

Delete tPreferenceDARights
Where
	CompanyKey = @CompanyKey and
	Entity = @Entity and
	EntityKey = @EntityKey

return 1
GO
