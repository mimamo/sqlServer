USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleUpdate]
	@DashboardModuleKey int,
	@DashboardKey int,
	@DashboardModuleDefKey int

AS --Encrypt

	UPDATE
		tDashboardModule
	SET
		DashboardKey = @DashboardKey,
		DashboardModuleDefKey = @DashboardModuleDefKey
	WHERE
		DashboardModuleKey = @DashboardModuleKey 

	RETURN 1
GO
