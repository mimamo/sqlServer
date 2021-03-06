USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGroupInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGroupInsert]
	@SecurityGroupKey int,
	@DashboardKey int,
	@DisplayOrder int
AS --Encrypt

	INSERT tDashboardGroup
		(
		SecurityGroupKey,
		DashboardKey,
		DisplayOrder
		)

	VALUES
		(
		@SecurityGroupKey,
		@DashboardKey,
		@DisplayOrder
		)
	

	RETURN 1
GO
