USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleUserGet]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleUserGet]
	@UserKey int,
	@DashboardModuleKey int

AS --Encrypt

		SELECT *
		FROM tDashboardModuleUser (nolock)
		WHERE
			UserKey = @UserKey
			AND DashboardModuleKey = @DashboardModuleKey

	RETURN 1
GO
