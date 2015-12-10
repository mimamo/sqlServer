USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleUserUpdate]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleUserUpdate]
	@UserKey int,
	@DashboardModuleKey int,
	@DisplayStatus smallint

AS --Encrypt

If exists(Select 1 from tDashboardModuleUser (nolock) Where UserKey = @UserKey AND DashboardModuleKey = @DashboardModuleKey)
	UPDATE
		tDashboardModuleUser
	SET
		DisplayStatus = @DisplayStatus
	WHERE
		UserKey = @UserKey 
		AND DashboardModuleKey = @DashboardModuleKey 
else
	INSERT tDashboardModuleUser
		(
		UserKey,
		DashboardModuleKey,
		DisplayStatus
		)

	VALUES
		(
		@UserKey,
		@DashboardModuleKey,
		@DisplayStatus
		)


	RETURN 1
GO
