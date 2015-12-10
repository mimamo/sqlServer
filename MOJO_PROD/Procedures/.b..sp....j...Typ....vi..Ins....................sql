USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeServiceInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeServiceInsert]
	(
		@ProjectTypeKey int,
		@ServiceKey int
	)
AS --Encrypt

Insert tProjectTypeService
	(
	ProjectTypeKey,
	ServiceKey
	)
Values
	(
	@ProjectTypeKey,
	@ServiceKey
	)

return 1
GO
