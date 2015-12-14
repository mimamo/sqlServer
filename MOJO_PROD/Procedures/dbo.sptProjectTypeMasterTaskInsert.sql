USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeMasterTaskInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeMasterTaskInsert]
	(
		@ProjectTypeKey int,
		@MasterTaskKey int,
		@DisplayOrder int
	)
AS --Encrypt

Insert tProjectTypeMasterTask
	(
	ProjectTypeKey,
	MasterTaskKey,
	DisplayOrder
	)
Values
	(
	@ProjectTypeKey,
	@MasterTaskKey,
	@DisplayOrder
	)

return 1
GO
