USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleGet]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleGet]
	@DashboardModuleKey int

AS --Encrypt

		SELECT *
		FROM tDashboardModule (nolock)
		WHERE
			DashboardModuleKey = @DashboardModuleKey

	RETURN 1
GO
