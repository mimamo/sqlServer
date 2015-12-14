USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileRightDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileRightDelete]
(
	@FileKey int,
	@Entity varchar(50),
	@EntityKey int
)

AS --Encrypt

Delete tDAFileRight
Where
	FileKey = @FileKey and
	Entity = @Entity and
	EntityKey = @EntityKey

return 1
GO
