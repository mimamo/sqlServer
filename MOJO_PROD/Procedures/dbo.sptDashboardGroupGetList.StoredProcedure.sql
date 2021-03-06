USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGroupGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGroupGetList]

	@SecurityGroupKey int,
	@Type smallint


AS --Encrypt

		SELECT tDashboard.*
		FROM tDashboardGroup (nolock)
		Inner join tDashboard (nolock) on tDashboardGroup.DashboardKey = tDashboard.DashboardKey
		WHERE
		SecurityGroupKey = @SecurityGroupKey and
		DashboardType = @Type
		Order By DisplayOrder

	RETURN 1
GO
