USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardDelete]
	@DashboardKey int

AS --Encrypt

	If exists(Select 1 from tDashboardGroup (nolock) Where DashboardKey = @DashboardKey)
		return -1
		
	Delete tDashboardModuleUser
	From tDashboardModule
	Where tDashboardModule.DashboardModuleKey = tDashboardModuleUser.DashboardModuleKey and
	tDashboardModule.DashboardKey = @DashboardKey

	Delete tDashboardModule
	Where tDashboardModule.DashboardKey = @DashboardKey
	
	DELETE
	FROM tDashboard
	WHERE
		DashboardKey = @DashboardKey 

	RETURN 1
GO
