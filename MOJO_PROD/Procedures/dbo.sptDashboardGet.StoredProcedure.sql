USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGet]
	@DashboardKey int

AS --Encrypt

		SELECT *
		FROM tDashboard (nolock)
		WHERE
			DashboardKey = @DashboardKey

	RETURN 1
GO
