USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleUserUpdateSettings]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleUserUpdateSettings]
	@UserKey int,
	@DashboardModuleKey int,
	@Settings text

AS --Encrypt

If exists(Select 1 from tDashboardModuleUser (nolock) Where UserKey = @UserKey AND DashboardModuleKey = @DashboardModuleKey)
	UPDATE
		tDashboardModuleUser
	SET
		Settings = @Settings
	WHERE
		UserKey = @UserKey 
		AND DashboardModuleKey = @DashboardModuleKey 
else
	-- 0 Open, 1, Minimized, 2 Removed

	INSERT tDashboardModuleUser
		(
		UserKey,
		DashboardModuleKey,
		DisplayStatus,
		Settings
		)

	VALUES
		(
		@UserKey,
		@DashboardModuleKey,
		0,
		@Settings
		)


	RETURN 1
GO
